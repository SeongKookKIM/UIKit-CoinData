import { MongoClient } from "mongodb";
import * as dotenv from "dotenv";

dotenv.config();

let db;

try {
  const client = new MongoClient(process.env.MONGO ?? "");

  client.connect();

  db = client.db("coin");

  if (db) {
    console.log("MongoDB Connect");
  } else {
    console.log("MongoDB DisConnect ");
  }
} catch {
  console.log("MongoDB DisConnect ");
}

export default db;
