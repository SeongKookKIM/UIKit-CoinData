import express, { Request, Response } from "express";
import db from "../../utils/MongoData";

let getCoin = express.Router();
getCoin.use(express.json());

// Bookmark
getCoin.post("/get/bookmark", async (req: Request, res: Response) => {
  try {
    const findBookmark = await db!
      .collection("user")
      .findOne({ id: req.body.userId, nickName: req.body.userNickname });

    if (findBookmark) {
      return res.status(200).json(findBookmark.bookmark);
    } else {
      return res.status(403).json("북마크를 찾을 수 없습니다.");
    }
  } catch {
    return res.status(500).json("Error");
  }
});

export default getCoin;
