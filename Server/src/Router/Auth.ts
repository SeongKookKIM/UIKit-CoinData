import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import db from "../utils/MongoData";
import { TokenPayload, UserInfoType } from "../Types/AuthType";

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

// 토큰체크
auth.post("/loginCheck", async (req: Request, res: Response) => {
  const accessToken = (req.headers["authorization"] as string)?.split(" ")[1];
  const refreshToken = (req.headers["refresh-token"] as string)?.split(" ")[1];

  const returnToken = (
    status: number,
    isLogin: boolean,
    nickName?: string | null,
    id?: string | null,
    accessToken?: string | null,
    refreshToken?: string | null
  ) => {
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
    const decodedAccess = jwt.verify(
      accessToken,
      process.env.ACCESS_TOKEN_SECRET!
    ) as TokenPayload;

    if (decodedAccess.exp >= now) {
      // 엑세스 토큰 유효기간 통과일 경우
      returnToken(
        200,
        true,
        decodedAccess.nickName,
        decodedAccess.id,
        accessToken,
        refreshToken
      );
    }
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      console.error("엑세스 토큰 검증 실패:", error.message);
      try {
        // Refresh 토큰 검증
        const decodedRefresh = jwt.verify(
          refreshToken,
          process.env.REFRESH_TOKEN_SECRET!
        ) as TokenPayload;

        if (decodedRefresh.exp >= now) {
          const accessToken = jwt.sign(
            { id: decodedRefresh.id, nickName: decodedRefresh.nickName },
            process.env.ACCESS_TOKEN_SECRET!,
            {
              expiresIn: "30m",
            }
          );

          returnToken(
            200,
            true,
            decodedRefresh.nickName,
            decodedRefresh.id,
            accessToken,
            refreshToken
          );
        }
      } catch (error) {
        if (error instanceof jwt.TokenExpiredError) {
          console.error("토큰 만료:", error.message);
          returnToken(401, false, null, null, null, null);
        } else {
          console.error("알 수 없는 오류:", error);
          returnToken(500, false, null, null, null, null);
        }
      }
    } else if (error instanceof jwt.TokenExpiredError) {
      console.error("토큰 만료:", error.message);
      returnToken(401, false, null, null, null, null);
    } else {
      console.error("알 수 없는 오류:", error);
      returnToken(500, false, null, null, null, null);
    }
  }
});

// 회원탈퇴
auth.post("/widhdraw", async (req: Request, res: Response) => {
  console.log(req.body);

  const userInfo = {
    id: req.body.id,
    nickName: req.body.nickName,
  };

  try {
    const findUser = await db!.collection("user").deleteOne(userInfo);
    if (findUser) {
      return res
        .status(200)
        .json({ widthdrawMessage: "회원탈퇴가 정상적으로 진행되었습니다." });
    }
    return res.status(403).json({
      widthdrawMessage: "유저정보를 찾지 못하여 회원탈퇴에 실패하였습니다.",
    });
  } catch {
    return res
      .status(401)
      .json({ widthdrawMessage: "회원탈퇴 진행 중 문제가 발생하였습니다." });
  }
});

export default auth;
