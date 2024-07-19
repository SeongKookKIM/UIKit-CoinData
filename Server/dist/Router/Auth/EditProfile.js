"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const dotenv = __importStar(require("dotenv"));
const MongoData_1 = __importDefault(require("../../utils/MongoData"));
let editProfile = express_1.default.Router();
editProfile.use(express_1.default.json());
dotenv.config();
// 회원정보 수정
editProfile.post("/editProfile", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const answer = (status, message, isSuccess, accessToken, refreshToken) => {
        return res.status(status).json({
            failMessage: message,
            isSuccess: isSuccess,
            accessToken: accessToken,
            refreshToken: refreshToken,
        });
    };
    try {
        // 기존 비밀번호 확인
        const findUser = yield MongoData_1.default
            .collection("user")
            .findOne({ id: req.body.defaultId });
        if (!findUser) {
            return answer(403, "존재하지 않는 ID입니다.", false);
        }
        const isPasswordValid = bcryptjs_1.default.compareSync(req.body.password, findUser.password);
        if (!isPasswordValid) {
            return answer(403, "기존 비밀번호가 일치하지 않습니다.", false);
        }
        // 기존 비밀번호와 일치할 경우
        if (req.body.password === req.body.newPassword) {
            return answer(403, "새로운 비밀번호와 기존비밀번호가 일치합니다.", false);
        }
        // 기존 아이디와 일치하지 않을경우 디비에 일치하는 아이디를 찾음
        if (req.body.id !== req.body.defaultId) {
            const findId = yield MongoData_1.default.collection("user").findOne({ id: req.body.id });
            if (findId) {
                return answer(403, "이미 존재하는 ID입니다.", false);
            }
        }
        // 기존 닉네임과 일치하지 않을경우 디비에 일치하는 닉네이음 찾음
        if (req.body.nickName !== req.body.defaultNickname) {
            const findNickName = yield MongoData_1.default
                .collection("user")
                .findOne({ nickName: req.body.nickName });
            if (findNickName) {
                return answer(403, "이미 존재하는 닉네임입니다.", false);
            }
        }
        const hash = bcryptjs_1.default.hashSync(req.body.newPassword, 12);
        const userInfo = {
            nickName: req.body.nickName,
            id: req.body.id,
            password: hash,
        };
        const editProfile = yield MongoData_1.default
            .collection("user")
            .updateOne({ id: req.body.defaultId, nickName: req.body.defaultNickname }, { $set: userInfo });
        if (editProfile) {
            const accessToken = jsonwebtoken_1.default.sign({ id: userInfo.id, nickName: userInfo.nickName }, process.env.ACCESS_TOKEN_SECRET, {
                expiresIn: "30m",
            });
            const refreshToken = jsonwebtoken_1.default.sign({ id: userInfo.id, nickName: userInfo.nickName }, process.env.REFRESH_TOKEN_SECRET, {
                expiresIn: "7d",
            });
            return answer(200, "회원정보를 수정하였습니다", true, accessToken, refreshToken);
        }
        return answer(403, "회원정보 수정 중 오류가 발생했습니다", false);
    }
    catch (error) {
        console.error("회원정보 수정 오류:", error);
        return answer(500, "서버 오류가 발생했습니다.", false);
    }
}));
exports.default = editProfile;
//# sourceMappingURL=EditProfile.js.map