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
let deleteCoin = express_1.default.Router();
deleteCoin.use(express_1.default.json());
// Bookmark Delete
deleteCoin.post("/delete/bookmark", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const finduser = yield MongoData_1.default
            .collection("user")
            .findOne({ id: req.body.userId, nickName: req.body.userNickname });
        if (finduser) {
            let resultBookmark = finduser.bookmark.filter((bookmark) => bookmark != req.body.coinName);
            yield MongoData_1.default
                .collection("user")
                .updateOne({ id: finduser.id, nickName: finduser.nickName }, { $set: { bookmark: resultBookmark } });
            return res.status(200).json(resultBookmark);
        }
        else {
            return res.status(403).json("유저 정보가 존재하지 않습니다.");
        }
    }
    catch (_a) {
        return res.status(500).json("Delete 서버 에러");
    }
}));
exports.default = deleteCoin;
//# sourceMappingURL=DeleteCoin.js.map