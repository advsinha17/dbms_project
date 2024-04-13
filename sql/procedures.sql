SET SQL_MODE=ORACLE;

DELIMITER /

CREATE OR REPLACE PROCEDURE add_user(user_id IN INT, fname IN VARCHAR2, lname IN VARCHAR2, email IN VARCHAR2) AS
BEGIN
    IF ((fname <> '') && (lname <> '') && (email <> '')) THEN
        IF (email REGEXP '^f20(19|20|21|22|23)[0-9]{4}@hyderabad\\.bits-pilani\\.ac\\.in$') THEN
            INSERT INTO users (user_id, fname, lname, email)
            VALUES (user_id, fname, lname, email);
            SELECT CONCAT('Created user with user id ', user_id) AS SUCCESS;
        ELSE
            SELECT 'Invalid email format' AS WARNING;
        END IF;
    ELSE
        SELECT 'Insufficient information provided' AS WARNING;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE create_new_restaurant(restaurant_id IN INT, name IN VARCHAR2, description IN VARCHAR2, status IN VARCHAR2, phone IN VARCHAR2) AS
BEGIN
    IF ((name <> '') && (description <> '')) THEN
        IF ((status <> 'Coming Soon') && (status <> 'Closed') && (status <> 'Open') && (status <> 'Permanently Closed') && (status <> 'Under Renovation')) THEN
            SELECT 'Status must be one of the following values: Coming Soon, Closed, Open, Permanently Closed, Under Renovation' AS WARNING;
        ELSE
            INSERT INTO restaurant (restaurant_id, restaurant_name, description, status)
            VALUES (restaurant_id, name, description, status);
            SELECT CONCAT('Restaurant created with restaurant_id ', restaurant_id) AS SUCCESS;
            IF ((phone <> '') AND (phone REGEXP '^[0-9]{10}$')) THEN
                INSERT INTO restaurant_contacts(restaurant_id, contact)
                VALUES (restaurant_id, phone);
                SELECT 'Phone number for restaurant created' AS SUCCESS;
            ELSIF (phone <> '') THEN
                SELECT 'Phone number must be numeric ONLY and 10 digits long' AS WARNING;
            END IF;
        END IF;
    ELSE
        SELECT 'Name and description must be provided' AS WARNING;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE create_menu_item(item_id IN INT, restaurant_id IN INT, item_name IN VARCHAR2, price IN INT, item_des IN VARCHAR2) AS
BEGIN
    IF ((item_name <> '')) THEN
        INSERT INTO menu_items (item_id, restaurant_id, item_name, price, item_desc)
        VALUES (item_id, restaurant_id, item_name, price, item_desc);
        SELECT 'Menu item with id ' || item_id || ' and name ' || item_name || ' created successfully.' AS SUCCESS;
    ELSE
        SELECT 'Menu item name cannot be empty.' AS WARNING;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE create_new_order(order_id IN INT, order_user IN INT, order_rest_id IN INT, phone_number IN VARCHAR2) AS
BEGIN
    IF (phone_number <> '' AND (phone_number REGEXP '^[0-9]{10}$')) THEN
        INSERT INTO orders (order_id, order_user, order_restaurant_id, total_amount, order_status, payment_method, order_date_time, phone_number)
        VALUES (order_id, order_user, order_restaurant_id, 0, 'Order Incomplete', 'Order Incomplete', NULL, phone_number);
        SELECT 'Order created with order ID ' || order_id;
    ELSE
        SELECT 'Phone number must be numberic ONLY and 10 digits long';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE create_order_item(order_id IN INT, order_item_id IN INT, quantity IN INT, menu_item_id IN INT) AS
subtotal INT;
BEGIN
    IF (quantity = 0) THEN
        SELECT 'Quantity must be greater than zero' AS WARNING;
    ELSE
        subtotal := calc_subtotal(menu_item_id, quantity);
        IF (subtotal = 0) THEN
            SELECT 'Menu item not found' AS WARNING;
        ELSE
            INSERT INTO order_item (order_id, order_item_id, quantity, subtotal, menu_item_id)
            VALUES (order_id, order_item_id, quantity, subtotal, menu_item_id);
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE place_order(order_id IN INT, payment_method IN VARCHAR2) AS
total_amount INT;
BEGIN

-- calculate total amount, set order status, payment method and order_date_time


CREATE OR REPLACE FUNCTION calc_total (order_id IN INT) RETURN INT IS
total_amount INT;
BEGIN
    -- check if valid order, find order, return total

CREATE OR REPLACE FUNCTION calc_subtotal(menu_item_id IN INT, quantity IN INT) RETURN INT IS
subtotal INT;
item_price INT;
BEGIN
    SELECT price INTO item_price FROM menu_items WHERE item_id = menu_item_id;
    subtotal := item_price * quantity;
    RETURN subtotal;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/



CREATE OR REPLACE FUNCTION get_total_spending(user_id IN INT) RETURN INT IS
total_spending INT;
BEGIN
    SELECT COALESCE(SUM(total_amount), 0) INTO total_spending
    FROM orders
    WHERE order_user = user_id;
    RETURN total_spending;
END;
/



CREATE OR REPLACE PROCEDURE get_orders_for_user(user_id IN INT) AS
BEGIN
    SELECT * FROM orders WHERE order_user = user_id;
END;
/


-- some procedures to be created:
-- 1. set number for restaurant - done
-- 3. set opening hours (ADVIK IS DOING THIS)
-- 4. add new menu item - done
-- 5. create new order - done
-- 6. get order details given order id
-- 7. get all orders for a given restaurant
-- 8. get all orders for a given user
-- 9. total earnings for restaurant - done
-- 10. total spending for user - done
-- 11. get menu for given restaurant



-- IF YOU ARE MAKING MORE PROCEDURES DO IT HERE, ABOVE THE DELIMITER ; LINE


DELIMITER ;
