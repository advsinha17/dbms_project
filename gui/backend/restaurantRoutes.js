import express from "express";
import { getConnection } from "./db.js";

const router = express.Router();
router.get("/restaurants", async (req, res) => {
  const connection = await getConnection();
  try {
    const [restaurants] = await connection.query("SELECT * FROM restaurant");
    if (restaurants.length === 0) {
      res.status(404).json({ message: "Restaurants not found" });
    } else {
      res.status(200).json({ restaurants });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ restaurants });
  } finally {
    connection.release();
  }
});

router.get("/restaurants/:id/menu", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const [menuItems] = await connection.query(
      "SELECT * FROM menu_item\
    WHERE menu_item.restaurant_id = ?",
      [id]
    );
    if (menuItems.length === 0) {
      res.status(404).json({ message: "Restaurant has no menu items" });
    } else {
      res.status(200).json({ menuItems });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/user/:id/orders", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const [orders] = await connection.query(
      "SELECT * FROM orders o\
      INNER JOIN order_item oi\
      ON o.order_id = oi.order_id\
      WHERE o.order_user = ?",
      [id]
    );
    if (menuItems.length === 0) {
      res.status(404).json({ message: "user has no orders" });
    } else {
      res.status(200).json({ menuItems });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/user/:id/totalspending", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const totalspending = await connection.query("CALL get_total_spending(?)", [
      id,
    ]);
    res.status(200).json({ totalspending });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/restaurant/:id/totalrevenue", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const totalrevenue = await connection.query(
      "SELECT SUM(orders.total_amount) FROM orders\
        WHERE orders.order_restaurant_id = ?",
      [id]
    );
    res.status(200).json({ totalrevenue });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/restaurant/:id/allorders", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const [all_orders] = await connection.query(
      "CALL get_orders_for_restaurant(?)",
      [id]
    );
    if (current_orders.length === 0) {
      res.status(404).json({ message: "restaurant has no orders" });
    } else {
      res.status(200).json({ current_orders });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/restaurant/:id/currentorders", async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const [current_orders] = await connection.query(
      "SELECT * FROM orders\
        WHERE orders.restaurant_id = ?\
        AND orders.status  = 'Order Recieved'",
      [id]
    );
    if (current_orders.length === 0) {
      res.status(404).json({ message: "restaurant has no current orders" });
    } else {
      res.status(200).json({ current_orders });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});
