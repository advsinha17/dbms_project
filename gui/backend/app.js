import express from "express";
import { getConnection } from "./db.js";

const app = express();
const port = 8000;

app.get("/", async (req, res) => {
  const connection = await getConnection();
  connection.release();
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
