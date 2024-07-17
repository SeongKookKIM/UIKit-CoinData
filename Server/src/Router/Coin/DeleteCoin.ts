import express, { Request, Response } from "express";
import db from "../../utils/MongoData";

let deleteCoin = express.Router();
deleteCoin.use(express.json());

// Bookmark Delete
deleteCoin.post("/delete/bookmark", async (req: Request, res: Response) => {
  try {
    const finduser = await db!
      .collection("user")
      .findOne({ id: req.body.userId, nickName: req.body.userNickname });

    if (finduser) {
      let resultBookmark: string[] = finduser.bookmark.filter(
        (bookmark: string[]) => bookmark != req.body.coinName
      );

      await db!
        .collection("user")
        .updateOne(
          { id: finduser.id, nickName: finduser.nickName },
          { $set: { bookmark: resultBookmark } }
        );

      return res.status(200).json(resultBookmark);
    } else {
      return res.status(403).json("유저 정보가 존재하지 않습니다.");
    }
  } catch {
    return res.status(500).json("Delete 서버 에러");
  }
});

export default deleteCoin;
