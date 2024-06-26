import express, { Request, Response } from "express";
import db from "../utils/MongoData";

let signInUser = express.Router();
signInUser.use(express.json());

signInUser.post("/", async (req: Request, res: Response) => {
  console.log(req.body);
  //   return res.status(403).json({ isSuccess: true });
  try {
    const result = await db!.collection("user").insertOne(req.body);

    if (result) {
      console.log("저장 성공");
    } else {
      console.log("저장 실패");
    }
  } catch {
    console.log("디비 연결 실패");
  }
});

export default signInUser;
