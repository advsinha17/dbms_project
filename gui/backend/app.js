import express from "express";
import userRoutes from "./userRoutes.js";

const app = express();
const port = 8000;

app.use(express.json());

app.use("/user", userRoutes);

app.get("/", async (req, res) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
