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
const MongoData_1 = __importDefault(require("../../utils/MongoData"));
let widthdraw = express_1.default.Router();
widthdraw.use(express_1.default.json());
// 회원탈퇴
widthdraw.post("/withdraw", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userInfo = {
        id: req.body.id,
        nickName: req.body.nickName,
    };
    try {
        const findUser = yield MongoData_1.default.collection("user").deleteOne(userInfo);
        if (findUser) {
            return res
                .status(200)
                .json({ widthdrawMessage: "회원탈퇴가 정상적으로 진행되었습니다." });
        }
        return res.status(403).json({
            widthdrawMessage: "유저정보를 찾지 못하여 회원탈퇴에 실패하였습니다.",
        });
    }
    catch (_a) {
        return res
            .status(401)
            .json({ widthdrawMessage: "회원탈퇴 진행 중 문제가 발생하였습니다." });
    }
}));
exports.default = widthdraw;
//# sourceMappingURL=Withdraw.js.map