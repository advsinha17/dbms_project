import { createPool } from "mariadb";
import { config } from "dotenv";

config();

const host = process.env.DATABASE_HOST;
const user = process.env.DATABASE_USER;
const password = process.env.DATABASE_PASSWORD;
const database = process.env.DATABASE;

const pool = createPool({
  host: host,
  user: user,
  password: password,
  database: database,
  connectionLimit: 5,
});

export async function getConnection() {
  try {
    const connection = await pool.getConnection();
    console.log("Successfully connected to the database.");
    return connection;
  } catch (error) {
    console.error(`Error connecting to the database: ${error}`);
    throw error;
  }
}
