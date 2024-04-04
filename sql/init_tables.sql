--CREATE USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    fname VARCHAR(50) not null,
    lname VARCHAR(50) not null,
    email VARCHAR(50) not null UNIQUE
);


-- CREATE RESTAURANT TABLE
-- rest name unique?
-- status: open, closed, under renovation, ..?
-- description: not null?
CREATE TABLE restaurant (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(20) not null,
    description VARCHAR(100),
    status VARCHAR(20) not null
);

-- CREATE RESTAURANT CONTACTS TABLE
CREATE TABLE restaurant_contacts (
    restaurant_id INT,
    contact VARCHAR(10) not null,
    PRIMARY KEY (restaurant_id, contact)
);

-- FOREIGN KEY BETWEEN RESTAURANT CONTACTS AND RESTAURANT 
ALTER TABLE restaurant_contacts add constraint fk_restaurant_contacts FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);

-- CREATE MENU ITEMS TABLE
CREATE TABLE menu_item(
    item_id INT PRIMARY KEY,
    item_name VARCHAR(20),
    price INT,
    item_desc VARCHAR(50)
);

-- CREATE ORDERS TABLE
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    order_user INT,
    order_restaurant_id INT,
    total_amount INT,
    order_status VARCHAR(10),
    payment_method VARCHAR(15),
    order_date_time DATETIME,
    phone_number VARCHAR(10)
);

-- FOREIGN KEY BETWEEN ORDERS AND USERS
ALTER TABLE orders add constraint fk_order_users FOREIGN KEY (order_user) REFERENCES users(user_id);

-- FOREIGN KEY BETWEEN ORDERS AND RESTAURANT
ALTER TABLE orders add constraint fk_order_restaurant FOREIGN KEY (order_restaurant_id) REFERENCES restaurant(restaurant_id);

-- CREATE ORDER ITEM TABLE
CREATE TABLE order_item(
    order_id INT,
    order_item_id INT,
    quantity INT,
    subtotal INT,
    menu_item_id INT,
    PRIMARY KEY (order_id,order_item_id)
);

-- FOREIGN KEY BETWEEN ORDER ITEM AND ORDERS
ALTER TABLE order_item add constraint fk_orderitem_order FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- FOREIGN KEY BETWEEN ORDER ITEM AND MENU ITEM
ALTER TABLE order_item add constraint fk_orderitem_menu FOREIGN KEY (menu_item_id) REFERENCES menu_item(item_id);

-- CREATE OPENING HOUR TABLE
CREATE TABLE opening_hour(
    restaurant_hour_id INT,
    hours_id INT,
    day_of_week VARCHAR(10),
    opening_time TIME,
    closing_time TIME,
    PRIMARY KEY (restaurant_hour_id,hours_id)
);

-- FOREIGN KEY BETWEEN OPENING HOUR AND RESTAURANT
ALTER TABLE opening_hour add constraint fk_openinghr_restaurant FOREIGN KEY (restaurant_hour_id) REFERENCES restaurant(restaurant_id);