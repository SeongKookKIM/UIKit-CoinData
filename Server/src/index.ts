import express, { Request, Response } from "express";
import cors from "cors";
import * as dotenv from "dotenv";
import signInUser from "./Router/SingIn";

const app = express();

app.use(express.urlencoded({ extended: true }));

app.use(express.json());
app.use(cors());

dotenv.config();

app.listen(process.env.PORT || 8080, () => {
  console.log("서버연결");
});

app.get("/", (req: Request, res: Response) => {
  return res.status(200).json("서버 연결!");
});

app.use("/signIn", signInUser);
