import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import db from "../utils/MongoData";
import { UserInfoType } from "../Types/AuthType";

let auth = express.Router();
auth.use(express.json());

dotenv.config();

// 회원가입
auth.post("/signIn", async (req: Request, res: Response) => {
  const answer = (status: number, message: string, isSuccess: boolean) => {
    return res
      .status(status)
      .json({ failMessage: message, isSuccess: isSuccess });
  };

  try {
    const findNickName = await db!
      .collection("user")
      .findOne({ nickName: req.body.nickName });
    const findId = await db!.collection("user").findOne({ id: req.body.id });

    if (findNickName) {
      return answer(403, "이미 존재하는 닉네임입니다.", false);
    } else if (findId) {
      return answer(403, "이미 존재하는 ID입니다.", false);
    } else {
      const hash = bcrypt.hashSync(req.body.password, 12);

      const userInfo: UserInfoType = {
        nickName: req.body.nickName,
        id: req.body.id,
        password: hash,
      };

      const result = await db!.collection("user").insertOne(userInfo);

      if (result) {
        return answer(200, "회원가입을 축하드립니다!", true);
      }
      return answer(403, "회원가입에 실패하였습니다.", false);
    }
  } catch {
    return answer(403, "DB연결에 실패하였습니다.", false);
  }
});

// 로그인
auth.post("/login", async (req: Request, res: Response) => {
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
      { id: user.id },
      process.env.ACCESS_TOKEN_SECRET!,
      {
        expiresIn: "60m",
      }
    );
    const refreshToken = jwt.sign(
      { id: user.id },
      process.env.REFRESH_TOKEN_SECRET!,
      {
        expiresIn: "7d",
      }
    );

    // 리프레쉬 토큰을 DB에 저장
    await db!
      .collection("user")
      .updateOne({ id: user.id }, { $set: { refreshToken: refreshToken } });

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

export default auth;
