import express, { Request, Response } from "express";
import db from "../../utils/MongoData";

let widthdraw = express.Router();
widthdraw.use(express.json());

// 회원탈퇴
widthdraw.post("/withdraw", async (req: Request, res: Response) => {
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

export default widthdraw;
