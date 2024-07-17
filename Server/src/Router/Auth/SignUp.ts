import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import db from "../../utils/MongoData";
import { UserInfoType } from "../../Types/AuthType";

let signUp = express.Router();
signUp.use(express.json());

// 회원가입
signUp.post("/signUp", async (req: Request, res: Response) => {
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

export default signUp;
