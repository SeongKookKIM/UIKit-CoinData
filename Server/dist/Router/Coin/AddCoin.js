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
let addCoin = express_1.default.Router();
addCoin.use(express_1.default.json());
addCoin.post("/add/bookmark", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const findUser = yield MongoData_1.default
            .collection("user")
            .findOne({ id: req.body.userId, nickName: req.body.userNickname });
        if (findUser) {
            const bookmarkArray = findUser.bookmark || [];
            const bookmarkExists = bookmarkArray.includes(req.body.coinName);
            if (bookmarkExists) {
                return res
                    .status(403)
                    .json({ isSuccess: false, message: "이미 북마크에 존재합니다." });
            }
            else {
                bookmarkArray.push(req.body.coinName);
                yield MongoData_1.default
                    .collection("user")
                    .updateOne({ id: req.body.userId, nickName: req.body.userNickname }, { $set: { bookmark: bookmarkArray } });
                return res
                    .status(200)
                    .json({ isSuccess: true, message: "북마크에 저장하였습니다." });
            }
        }
        else {
            return res
                .status(403)
                .json({ isSuccess: false, message: "데이터 저장해 실패하였습니다." });
        }
    }
    catch (error) {
        console.error("에러 발생:", error);
        return res.status(500).json({
            isSuccess: false,
            message: "서버 에러가 발생했습니다. 잠시후 다시 추가해주세요.",
        });
    }
}));
exports.default = addCoin;
//# sourceMappingURL=AddCoin.js.map