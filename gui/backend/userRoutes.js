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
    console.log(users);
    if (!users) {
      res.status(401).json({ message: "Invalid email" });
    } else {
      if (password === users.password) {
        res.json({ message: "Login successful", userId: users.user_id });
      } else {
        res.status(401).json({ message: "Invalid password" });
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
  const { email, password, firstName, lastName } = req.body;
  const connection = await getConnection();
  try {
    const [users] = await connection.query(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );
    if (users) {
      res.status(400).json({ message: "User already exists" });
    } else {
      let userId;
      while (true) {
        userId = Math.floor(10000000 + Math.random() * 90000000);
        const [idExists] = await connection.query(
          "SELECT * FROM users WHERE user_id = ?",
          [userId]
        );
        if (!idExists) {
          break;
        }
      }
      const [result] = await connection.query(
        "CALL add_user(?, ?, ?, ?, ?, ?)",
        [userId, password, firstName, lastName, email, 0]
      );
      if (result[0] && result[0].WARNING) {
        res
          .status(400)
          .json({ message: "Signup failed", reason: result[0].WARNING });
      } else if (result.affectedRows === 0) {
        res
          .status(400)
          .json({ message: "Signup failed", reason: result.message });
      } else {
        res.json({ message: "Signup successful", userId: userId });
      }
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.post("/admin", async (req, res) => {
  const { email, password } = req.body;
  const connection = await getConnection();
  try {
    const [users] = await connection.query(
      "SELECT * FROM users WHERE email = ? AND is_admin = 1",
      [email]
    );
    if (!users) {
      res
        .status(400)
        .json({ message: "Email does not belong to an admin user" });
    } else {
      if (password === users.password) {
        res.json({ message: "Admin login successful", userId: users.user_id });
      } else {
        res.status(400).json({ message: "Incorrect password" });
      }
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

export default router;
