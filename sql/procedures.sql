SET SQL_MODE=ORACLE;

DELIMITER /

CREATE OR REPLACE PROCEDURE add_user(user_id IN INT, fname IN VARCHAR2, lname IN VARCHAR2, email IN VARCHAR2, is_admin IN BOOLEAN) AS
BEGIN
    IF ((fname <> '') && (lname <> '') && (email <> '')) THEN
        IF (email REGEXP '^f20(19|20|21|22|23)[0-9]{4}@hyderabad\\.bits-pilani\\.ac\\.in$') THEN
            INSERT INTO users (user_id, fname, lname, email, is_admin)
            VALUES (user_id, fname, lname, email, is_admin);
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

CREATE OR REPLACE PROCEDURE create_new_restaurant(restaurant_id IN INT, owner_id IN INT, name IN VARCHAR2, description IN VARCHAR2, status IN VARCHAR2, phone IN VARCHAR2) AS
    is_admin BOOLEAN;
BEGIN
    SELECT is_admin INTO is_admin FROM users WHERE user_id = owner_id;
    IF is_admin THEN
        INSERT INTO restaurant (restaurant_id, owner_id, restaurant_name, description, status)
        VALUES (restaurant_id, owner_id, name, description, status);
        SELECT CONCAT('Restaurant created with restaurant_id ', restaurant_id) AS SUCCESS;
        IF ((phone <> '') AND (phone REGEXP '^[0-9]{10}$')) THEN
            INSERT INTO restaurant_contacts(restaurant_id, contact)
            VALUES (restaurant_id, phone);
            SELECT 'Phone number for restaurant created' AS SUCCESS;
        ELSIF (phone <> '') THEN
            SELECT 'Phone number must be numeric ONLY and 10 digits long' AS WARNING;
        END IF;
    ELSE
        SELECT 'Owner must be an admin user' AS WARNING;
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
        VALUES (order_id, order_user, order_restaurant_id, 0, 'Order Incomplete', 'Unknown', NULL, phone_number);
        SELECT 'Order created with order ID ' || order_id;
    ELSE
        SELECT 'Phone number must be numberic ONLY and 10 digits long';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

CREATE OR REPLACE PROCEDURE set_opening_hours(restaurant_id INT, hours_id INT, day_of_week VARCHAR(20), opening_time TIME, closing_time TIME) AS
BEGIN
    INSERT INTO opening_hours (restaurant_id, hours_id, day_of_week, opening_time, closing_time)
    VALUES (restaurant_id, hours_id, day_of_week, opening_time, closing_time)
    ON DUPLICATE KEY UPDATE
        day_of_week = VALUES(day_of_week),
        opening_time = VALUES(opening_time),
        closing_time = VALUES(closing_time);
    SELECT 'Opening hours set successfully.' AS SUCCESS;
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
BEGIN
    UPDATE orders
    SET order_status = 'Order Recieved',
        payment_method = payment_method,
        order_date_time = SYSDATE
    WHERE order_id = order_id;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
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

CREATE OR REPLACE PROCEDURE get_order_details(order_id IN INT) AS
    CURSOR c_order_details IS
    SELECT o.order_id, o.order_status, o.payment_method, o.order_date_time, o.total_amount, u.fname || ' ' || u.lname AS user_full_name, mi.item_name
    FROM orders o
    JOIN users u ON o.order_user = u.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN menu_item mi ON oi.menu_item_id = mi.item_id
    WHERE o.order_id = order_id;
    v_order_details c_order_details%ROWTYPE;
BEGIN
    OPEN c_order_details;
    FETCH c_order_details INTO v_order_details;
    CLOSE c_order_details;
    SELECT 'Order id: ' || v_order_details.order_id AS SUCCESS;
    SELECT 'Order status: ' || v_order_details.order_status AS SUCCESS;
    SELECT 'User full names: ' || v_order_details.user_full_name AS SUCCESS;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        SELECT 'Order not found.' AS EXCEPTION;
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLERRM AS EXCEPTION;
END;
/

-- CREATE OR REPLACE PROCEDURE get_order_details(order_id IN INT) AS
--     CURSOR c_order_details IS
--     SELECT o.order_id, o.order_status, o.payment_method, o.order_date_time, o.total_amount, u.fname || ' ' || u.lname AS user_full_name, mi.item_name
--     FROM orders o
--     JOIN users u ON o.order_user = u.user_id
--     JOIN order_items oi ON o.order_id = oi.order_id
--     JOIN menu_item mi ON oi.menu_item_id = mi.item_id
--     WHERE o.order_id = order_id;
--     v_order_details c_order_details%ROWTYPE;
-- BEGIN
--     OPEN c_order_details;
--     FETCH c_order_details INTO v_order_details;
--     CLOSE c_order_details;
--     DBMS_OUTPUT.PUT_LINE('Order ID: ' || v_order_details.order_id);
--     DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_order_details.order_status);
--     DBMS_OUTPUT.PUT_LINE('Payment Method: ' || v_order_details.payment_method);
--     DBMS_OUTPUT.PUT_LINE('Order Date Time: ' || v_order_details.order_date_time);
--     DBMS_OUTPUT.PUT_LINE('Total Amount: ' || v_order_details.total_amount);
--     DBMS_OUTPUT.PUT_LINE('User Full Name: ' || v_order_details.user_full_name);
--     DBMS_OUTPUT.PUT_LINE('Item Name: ' || v_order_details.item_name);
-- EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--         DBMS_OUTPUT.PUT_LINE('No data found for order id: ' || order_id);
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
-- END;
-- /

-- some procedures to be created:
-- 1. set number for restaurant - done
-- 3. set opening hours - done
-- 4. add new menu item - done
-- 5. create new order - done
-- 9. total earnings for restaurant - done
-- 10. total spending for user - done

-- 6. get order details given order id
-- 7. get all orders for a given restaurant
-- 8. get all orders for a given user
-- 11. get menu for given restaurant


-- IF YOU ARE MAKING MORE PROCEDURES DO IT HERE, ABOVE THE DELIMITER ; LINE


DELIMITER ;
