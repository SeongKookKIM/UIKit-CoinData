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
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const dotenv = __importStar(require("dotenv"));
let loginCheck = express_1.default.Router();
loginCheck.use(express_1.default.json());
dotenv.config();
// 토큰체크
loginCheck.post("/loginCheck", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b;
    const accessToken = (_a = req.headers["authorization"]) === null || _a === void 0 ? void 0 : _a.split(" ")[1];
    const refreshToken = (_b = req.headers["refresh-token"]) === null || _b === void 0 ? void 0 : _b.split(" ")[1];
    const returnToken = (status, isLogin, nickName, id, accessToken, refreshToken) => {
        return res.status(status).json({
            isLogin: isLogin,
            nickName: nickName,
            id: id,
            accessToken: accessToken,
            refreshToken: refreshToken,
        });
    };
    if (!accessToken || !refreshToken) {
        returnToken(401, false, null, null, null, null);
    }
    if (!process.env.ACCESS_TOKEN_SECRET || !process.env.REFRESH_TOKEN_SECRET) {
        console.error("필요한 환경 변수가 설정되지 않았습니다.");
        process.exit(1);
    }
    // 현재 시간
    const now = Math.floor(Date.now() / 1000);
    try {
        // Access 토큰 검증
        const decodedAccess = jsonwebtoken_1.default.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
        if (decodedAccess.exp >= now) {
            // 엑세스 토큰 유효기간 통과일 경우
            returnToken(200, true, decodedAccess.nickName, decodedAccess.id, accessToken, refreshToken);
        }
    }
    catch (error) {
        if (error instanceof jsonwebtoken_1.default.JsonWebTokenError) {
            console.error("엑세스 토큰 검증 실패:", error.message);
            try {
                // Refresh 토큰 검증
                const decodedRefresh = jsonwebtoken_1.default.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
                if (decodedRefresh.exp >= now) {
                    const accessToken = jsonwebtoken_1.default.sign({ id: decodedRefresh.id, nickName: decodedRefresh.nickName }, process.env.ACCESS_TOKEN_SECRET, {
                        expiresIn: "30m",
                    });
                    returnToken(200, true, decodedRefresh.nickName, decodedRefresh.id, accessToken, refreshToken);
                }
            }
            catch (error) {
                if (error instanceof jsonwebtoken_1.default.TokenExpiredError) {
                    console.error("토큰 만료:", error.message);
                    returnToken(401, false, null, null, null, null);
                }
                else {
                    console.error("알 수 없는 오류:", error);
                    returnToken(500, false, null, null, null, null);
                }
            }
        }
        else if (error instanceof jsonwebtoken_1.default.TokenExpiredError) {
            console.error("토큰 만료:", error.message);
            returnToken(401, false, null, null, null, null);
        }
        else {
            console.error("알 수 없는 오류:", error);
            returnToken(500, false, null, null, null, null);
        }
    }
}));
exports.default = loginCheck;
//# sourceMappingURL=LoginCheck.js.map