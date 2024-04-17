import express from "express";
import { getConnection } from "./db.js";

const router = express.Router();

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  const connection = await getConnection();
  try {
    const [users] = await connection.query(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );
    if (users.length === 0) {
      res.status(401).json({ message: "Invalid email" });
    } else {
      const [passwords] = await connection.query(
        "SELECT * FROM users WHERE email = ? AND password = ?",
        [email, password]
      );
      if (passwords.length === 0) {
        res.status(401).json({ message: "Invalid password" });
      } else {
        res.json({ message: "Login successful" });
      }
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.post("/signup", async (req, res) => {
  const { email, password } = req.body;
  const connection = await getConnection();
  try {
    const [users] = await connection.query(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );
    if (users.length > 0) {
      res.status(400).json({ message: "User already exists" });
    } else {
      await connection.query("CALL create_user(?, ?)", [email, password]);
      res.json({ message: "Signup successful" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

export default router;
