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
let login = express_1.default.Router();
login.use(express_1.default.json());
dotenv.config();
// 로그인
login.post("/login", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const answer = (status, message, isSuccess, accessToken, refreshToken) => {
        return res.status(status).json({
            failMessage: message,
            isSuccess: isSuccess,
            accessToken: accessToken,
            refreshToken: refreshToken,
        });
    };
    try {
        const user = yield MongoData_1.default.collection("user").findOne({ id: req.body.id });
        if (!user) {
            return answer(403, "존재하지 않는 ID입니다.", false);
        }
        const isPasswordValid = bcryptjs_1.default.compareSync(req.body.password, user.password);
        if (!isPasswordValid) {
            return answer(403, "비밀번호가 틀렸습니다.", false);
        }
        const accessToken = jsonwebtoken_1.default.sign({ id: user.id, nickName: user.nickName }, process.env.ACCESS_TOKEN_SECRET, {
            expiresIn: "30m",
        });
        const refreshToken = jsonwebtoken_1.default.sign({ id: user.id, nickName: user.nickName }, process.env.REFRESH_TOKEN_SECRET, {
            expiresIn: "7d",
        });
        return answer(200, "로그인에 성공하였습니다.", true, accessToken, refreshToken);
    }
    catch (error) {
        console.error("로그인 오류:", error);
        return answer(500, "서버 오류가 발생했습니다.", false);
    }
}));
exports.default = login;
//# sourceMappingURL=Login.js.map