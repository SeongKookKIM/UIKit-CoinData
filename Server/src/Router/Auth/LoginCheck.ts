import express, { Request, Response } from "express";
import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import { TokenPayload, UserInfoType } from "../../Types/AuthType";

let loginCheck = express.Router();
loginCheck.use(express.json());

dotenv.config();

// 토큰체크
loginCheck.post("/loginCheck", async (req: Request, res: Response) => {
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

export default loginCheck;
