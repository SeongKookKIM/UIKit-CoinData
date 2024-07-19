"use strict";
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
const MongoData_1 = __importDefault(require("../../utils/MongoData"));
let signUp = express_1.default.Router();
signUp.use(express_1.default.json());
// 회원가입
signUp.post("/signUp", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const answer = (status, message, isSuccess) => {
        return res
            .status(status)
            .json({ failMessage: message, isSuccess: isSuccess });
    };
    try {
        const findNickName = yield MongoData_1.default
            .collection("user")
            .findOne({ nickName: req.body.nickName });
        const findId = yield MongoData_1.default.collection("user").findOne({ id: req.body.id });
        if (findNickName) {
            return answer(403, "이미 존재하는 닉네임입니다.", false);
        }
        else if (findId) {
            return answer(403, "이미 존재하는 ID입니다.", false);
        }
        else {
            const hash = bcryptjs_1.default.hashSync(req.body.password, 12);
            const userInfo = {
                nickName: req.body.nickName,
                id: req.body.id,
                password: hash,
            };
            const result = yield MongoData_1.default.collection("user").insertOne(userInfo);
            if (result) {
                return answer(200, "회원가입을 축하드립니다!", true);
            }
            return answer(403, "회원가입에 실패하였습니다.", false);
        }
    }
    catch (_a) {
        return answer(403, "DB연결에 실패하였습니다.", false);
    }
}));
exports.default = signUp;
//# sourceMappingURL=SignUp.js.map