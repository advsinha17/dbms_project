import express from "express";
import { getConnection } from "./db.js";

router.get("/admindashboard/:id", async (req, res) => {
  //to get all info on restaurants by a particular user
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const no_of_restaurants = await connection.query(
      "SELECT COUNT(*) FROM restaurant\
        WHERE restaurant.owner_id = ?",
      [id]
    );
    const no_of_restaurants_open = await connection.query(
      "SELECT COUNT(*) FROM restaurant\
        WHERE restaurant.owner_id = ?\
        AND restaurant.status = 'Open'",
      [id]
    );
    const [result] = await connection.query(
      "SELECT COUNT(*) AS total_orders, SUM(orders.total_amount) AS total_revenue\
        FROM orders\
        WHERE orders.order_restaurant_id IN\
        (SELECT restaurant.restaurant_id FROM restaurant\
        WHERE restaurant.owner_id = ?)",
      [id]
    );
    const responseBody = {
      no_of_restaurants: no_of_restaurants,
      no_of_restaurants_open: no_of_restaurants_open,
      total_order: result[0],
      total_revenue: result[1],
    };
    res.status(200).json(responseBody);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});

router.get("/userdashboard/:id", async (req, res) => {
  //to get all info on restaurants by a particular user
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const total_active_orders = await connection.query(
      "SELECT COUNT(*) FROM orders\
        WHERE orders.order_user = ?\
        AND order.status <> 'Order Collected'",
      [id]
    );
    const [result] = await connection.query(
      "SELECT COUNT(*) AS total_orders, SUM(orders.total_amount) AS total_revenue\
        FROM orders\
        WHERE orders.order_user = ?",
      [id]
    );
    const [favourite_restaurants_top5] = await connection.query(
      "SELECT restaurant.restaurant_name FROM restaurant\
        WHERE restaurant.restaurant_id IN\
        (SELECT orders.order_restaurant_id FROM orders\
        WHERE orders.order_user = ?\
        GROUP BY orders.order_restaurant_id\
        ORDER BY COUNT(*) DESC)\
        LIMIT 5",
      [id]
    );

    const [favourite_menu_items_top5] = await connection.query(
      "SELECT menu_item.item_name FROM menu_item\
        WHERE menu_item.item_id IN\
        (SELECT order_item.menu_item_id FROM orders\
        INNER JOIN order_item\
        ON orders.order_id = order_item.order_id\
        WHERE orders.order_user = ?\
        GROUP BY order_item.menu_item_id\
        ORDER BY SUM(order_item.quantity) DESC)\
        LIMIT 5",
      [id]
    );

    const responseBody = {
      total_active_orders: total_active_orders,
      total_orders: result[0],
      total_spent: result[1],
      favourite_restaurants: favourite_restaurants_top5,
      favourite_menuitems: favourite_menu_items_top5,
    };
    res.status(200).json(responseBody);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    connection.release();
  }
});
