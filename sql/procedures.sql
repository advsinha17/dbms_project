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


-- some procedures to be created:
-- 1. set number for restaurant
-- 3. set opening hours (ADVIK IS DOING THIS)
-- 4. add new menu item
-- 5. create new order
-- 6. get order details given order id
-- 7. get all orders for a given restaurant
-- 8. get all orders for a given user
-- 9. total earnings for restaurant
-- 10. total spending for user
-- 11. get menu for given restaurant



-- IF YOU ARE MAKING MORE PROCEDURES DO IT HERE, ABOVE THE DELIMITER ; LINE


DELIMITER ;
