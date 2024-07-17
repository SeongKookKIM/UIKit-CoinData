import express, { Request, Response } from "express";
import cors from "cors";
import * as dotenv from "dotenv";

import signUp from "./Router/Auth/SignUp";
import login from "./Router/Auth/Login";
import loginCheck from "./Router/Auth/LoginCheck";
import widthdraw from "./Router/Auth/Withdraw";
import editProfile from "./Router/Auth/EditProfile";
import addCoin from "./Router/Coin/AddCoin";
import deleteCoin from "./Router/Coin/DeleteCoin";
import getCoin from "./Router/Coin/GetCoin";

const app = express();

app.use(express.urlencoded({ extended: true }));

app.use(express.json());
app.use(cors());

dotenv.config();

app.listen(process.env.PORT || 8080, () => {
  console.log("서버연결");
});

app.get("/", (req: Request, res: Response) => {
  return res.status(200).json("서버 연결!");
});

// Auth
app.use("/auth", signUp);
app.use("/auth", login);
app.use("/auth", loginCheck);
app.use("/auth", widthdraw);
app.use("/auth", editProfile);

// Coin
app.use("/coin", addCoin);
app.use("/coin", deleteCoin);
app.use("/coin", getCoin);
