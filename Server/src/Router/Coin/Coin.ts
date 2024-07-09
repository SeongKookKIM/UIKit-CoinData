import express, { Request, Response } from "express";
import db from "../../utils/MongoData";

let coin = express.Router();
coin.use(express.json());

coin.post("/add/bookmark", async (req: Request, res: Response) => {
  try {
    const findUser = await db!
      .collection("user")
      .findOne({ id: req.body.userId, nickName: req.body.userNickname });

    if (findUser) {
      const bookmarkArray = findUser.bookmark || [];
      const bookmarkExists = bookmarkArray.includes(req.body.coinName);

      if (bookmarkExists) {
        return res
          .status(403)
          .json({ isSuccess: false, message: "이미 북마크에 존재합니다." });
      } else {
        bookmarkArray.push(req.body.coinName);

        await db!
          .collection("user")
          .updateOne(
            { id: req.body.userId, nickName: req.body.userNickname },
            { $set: { bookmark: bookmarkArray } }
          );

        return res
          .status(200)
          .json({ isSuccess: true, message: "북마크에 저장하였습니다." });
      }
    } else {
      return res
        .status(403)
        .json({ isSuccess: false, message: "데이터 저장해 실패하였습니다." });
    }
  } catch (error) {
    console.error("에러 발생:", error);
    return res.status(500).json({
      isSuccess: false,
      message: "서버 에러가 발생했습니다. 잠시후 다시 추가해주세요.",
    });
  }
});

// Bookmark
coin.post("/get/bookmark", async (req: Request, res: Response) => {
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

// Bookmark Delete
coin.post("/delete/bookmark", async (req: Request, res: Response) => {
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

export default coin;
