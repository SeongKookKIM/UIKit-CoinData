import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import db from "../../utils/MongoData";

let login = express.Router();
login.use(express.json());

dotenv.config();

// 로그인
login.post("/login", async (req: Request, res: Response) => {
  const answer = (
    status: number,
    message: string,
    isSuccess: boolean,
    accessToken?: string,
    refreshToken?: string
  ) => {
    return res.status(status).json({
      failMessage: message,
      isSuccess: isSuccess,
      accessToken: accessToken,
      refreshToken: refreshToken,
    });
  };

  try {
    const user = await db!.collection("user").findOne({ id: req.body.id });
    if (!user) {
      return answer(403, "존재하지 않는 ID입니다.", false);
    }

    const isPasswordValid = bcrypt.compareSync(
      req.body.password,
      user.password
    );
    if (!isPasswordValid) {
      return answer(403, "비밀번호가 틀렸습니다.", false);
    }

    const accessToken = jwt.sign(
      { id: user.id, nickName: user.nickName },
      process.env.ACCESS_TOKEN_SECRET!,
      {
        expiresIn: "30m",
      }
    );
    const refreshToken = jwt.sign(
      { id: user.id, nickName: user.nickName },
      process.env.REFRESH_TOKEN_SECRET!,
      {
        expiresIn: "7d",
      }
    );

    return answer(
      200,
      "로그인에 성공하였습니다.",
      true,
      accessToken,
      refreshToken
    );
  } catch (error) {
    console.error("로그인 오류:", error);
    return answer(500, "서버 오류가 발생했습니다.", false);
  }
});

export default login;
