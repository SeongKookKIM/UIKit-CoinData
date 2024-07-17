import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import db from "../../utils/MongoData";
import { UserInfoType } from "../../Types/AuthType";

let editProfile = express.Router();
editProfile.use(express.json());

dotenv.config();

// 회원정보 수정
editProfile.post("/editProfile", async (req: Request, res: Response) => {
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
    // 기존 비밀번호 확인
    const findUser = await db!
      .collection("user")
      .findOne({ id: req.body.defaultId });
    if (!findUser) {
      return answer(403, "존재하지 않는 ID입니다.", false);
    }

    const isPasswordValid = bcrypt.compareSync(
      req.body.password,
      findUser.password
    );

    if (!isPasswordValid) {
      return answer(403, "기존 비밀번호가 일치하지 않습니다.", false);
    }

    // 기존 비밀번호와 일치할 경우
    if (req.body.password === req.body.newPassword) {
      return answer(403, "새로운 비밀번호와 기존비밀번호가 일치합니다.", false);
    }
    // 기존 아이디와 일치하지 않을경우 디비에 일치하는 아이디를 찾음
    if (req.body.id !== req.body.defaultId) {
      const findId = await db!.collection("user").findOne({ id: req.body.id });

      if (findId) {
        return answer(403, "이미 존재하는 ID입니다.", false);
      }
    }
    // 기존 닉네임과 일치하지 않을경우 디비에 일치하는 닉네이음 찾음
    if (req.body.nickName !== req.body.defaultNickname) {
      const findNickName = await db!
        .collection("user")
        .findOne({ nickName: req.body.nickName });

      if (findNickName) {
        return answer(403, "이미 존재하는 닉네임입니다.", false);
      }
    }
    const hash = bcrypt.hashSync(req.body.newPassword, 12);

    const userInfo: UserInfoType = {
      nickName: req.body.nickName,
      id: req.body.id,
      password: hash,
    };

    const editProfile = await db!
      .collection("user")
      .updateOne(
        { id: req.body.defaultId, nickName: req.body.defaultNickname },
        { $set: userInfo }
      );

    if (editProfile) {
      const accessToken = jwt.sign(
        { id: userInfo.id, nickName: userInfo.nickName },
        process.env.ACCESS_TOKEN_SECRET!,
        {
          expiresIn: "30m",
        }
      );
      const refreshToken = jwt.sign(
        { id: userInfo.id, nickName: userInfo.nickName },
        process.env.REFRESH_TOKEN_SECRET!,
        {
          expiresIn: "7d",
        }
      );

      return answer(
        200,
        "회원정보를 수정하였습니다",
        true,
        accessToken,
        refreshToken
      );
    }
    return answer(403, "회원정보 수정 중 오류가 발생했습니다", false);
  } catch (error) {
    console.error("회원정보 수정 오류:", error);
    return answer(500, "서버 오류가 발생했습니다.", false);
  }
});

export default editProfile;
