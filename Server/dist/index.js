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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv = __importStar(require("dotenv"));
const SignUp_1 = __importDefault(require("./Router/Auth/SignUp"));
const Login_1 = __importDefault(require("./Router/Auth/Login"));
const LoginCheck_1 = __importDefault(require("./Router/Auth/LoginCheck"));
const Withdraw_1 = __importDefault(require("./Router/Auth/Withdraw"));
const EditProfile_1 = __importDefault(require("./Router/Auth/EditProfile"));
const AddCoin_1 = __importDefault(require("./Router/Coin/AddCoin"));
const DeleteCoin_1 = __importDefault(require("./Router/Coin/DeleteCoin"));
const GetCoin_1 = __importDefault(require("./Router/Coin/GetCoin"));
const app = (0, express_1.default)();
app.use(express_1.default.urlencoded({ extended: true }));
app.use(express_1.default.json());
app.use((0, cors_1.default)());
dotenv.config();
app.listen(process.env.PORT || 8080, () => {
    console.log("서버연결");
});
app.get("/", (req, res) => {
    return res.status(200).json("서버 연결!");
});
// Auth
app.use("/auth", SignUp_1.default);
app.use("/auth", Login_1.default);
app.use("/auth", LoginCheck_1.default);
app.use("/auth", Withdraw_1.default);
app.use("/auth", EditProfile_1.default);
// Coin
app.use("/coin", AddCoin_1.default);
app.use("/coin", DeleteCoin_1.default);
app.use("/coin", GetCoin_1.default);
//# sourceMappingURL=index.js.map