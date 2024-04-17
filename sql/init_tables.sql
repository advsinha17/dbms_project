--CREATE USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    password VARCHAR(20) not null,
    fname VARCHAR(50) not null,
    lname VARCHAR(50) not null,
    email VARCHAR(50) not null UNIQUE,
    is_admin INT not null
);


-- CREATE RESTAURANT TABLE
CREATE TABLE restaurant (
    restaurant_id INT PRIMARY KEY,
    owner_id INT,
    restaurant_name VARCHAR(20) not null UNIQUE,
    description VARCHAR(100) not null,
    status ENUM('Coming Soon', 'Closed', 'Open', 'Permanently Closed', 'Under Renovation') not null
);

ALTER TABLE restaurant add constraint fk_restaurant_owner FOREIGN KEY (owner_id) REFERENCES users(user_id);

-- CREATE RESTAURANT CONTACTS TABLE
CREATE TABLE restaurant_contacts (
    restaurant_id INT,
    contact VARCHAR(10) not null,
    PRIMARY KEY (restaurant_id, contact)
);

-- FOREIGN KEY BETWEEN RESTAURANT CONTACTS AND RESTAURANT 
ALTER TABLE restaurant_contacts add constraint fk_restaurant_contacts FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);
-- CHECK CONSTRAINT FOR PHONE NUMBER IN RESTAURANT CONTACTS
ALTER TABLE restaurant_contacts ADD CONSTRAINT chk_phone_no_format CHECK (contact REGEXP '^[0-9]{10}$');

-- CREATE MENU ITEMS TABLE
CREATE TABLE menu_item(
    item_id INT PRIMARY KEY,
    restaurant_id INT not null,
    item_name VARCHAR(40) not null,
    price INT not null,
    item_desc VARCHAR(50)
);

-- FOREIGN KEY BETWEEN MENU ITEMS AND RESTAURANT 
ALTER TABLE menu_item add constraint fk_menu_item FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);
-- CHECK IF PRICE IS POSITIVE
ALTER TABLE menu_item ADD CONSTRAINT chk_price_positive CHECK (price > 0);

-- CREATE ORDERS TABLE
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    order_user INT not null,
    order_restaurant_id INT not null,
    total_amount INT not null,
    order_status ENUM('Order Incomplete', 'Order Recieved', 'Order Ready', 'Order Collected') not null,
    payment_method ENUM('Cash', 'UPI', 'Card', 'Unknown') not null,
    order_date_time DATETIME,
    phone_number VARCHAR(10) not null
);

-- FOREIGN KEY BETWEEN ORDERS AND USERS
ALTER TABLE orders add constraint fk_order_users FOREIGN KEY (order_user) REFERENCES users(user_id);
-- FOREIGN KEY BETWEEN ORDERS AND RESTAURANT
ALTER TABLE orders add constraint fk_order_restaurant FOREIGN KEY (order_restaurant_id) REFERENCES restaurant(restaurant_id);
-- CHECK CONSTRAINT FOR PHONE NUMBER IN RESTAURANT CONTACTS
ALTER TABLE orders ADD CONSTRAINT chk_phone_no_format CHECK (phone_number REGEXP '^[0-9]{10}$');

-- CREATE ORDER ITEM TABLE
CREATE TABLE order_item(
    order_id INT,
    order_item_id INT,
    quantity INT not null,
    subtotal INT not null,
    menu_item_id INT not null,
    PRIMARY KEY (order_id,order_item_id)
);

-- FOREIGN KEY BETWEEN ORDER ITEM AND ORDERS
ALTER TABLE order_item add constraint fk_orderitem_order FOREIGN KEY (order_id) REFERENCES orders(order_id);
-- FOREIGN KEY BETWEEN ORDER ITEM AND MENU ITEM
ALTER TABLE order_item add constraint fk_orderitem_menu FOREIGN KEY (menu_item_id) REFERENCES menu_item(item_id);
-- CHECK IF QUANTITY PER ORDER ITEM IS POSITIVE
ALTER TABLE order_item ADD CONSTRAINT chk_quantity_positive CHECK (quantity > 0);

-- CREATE OPENING HOUR TABLE
CREATE TABLE opening_hour(
    restaurant_id INT,
    hours_id INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    opening_time TIME,
    closing_time TIME,
    PRIMARY KEY (restaurant_id,hours_id)
);

-- FOREIGN KEY BETWEEN OPENING HOUR AND RESTAURANT
ALTER TABLE opening_hour add constraint fk_openinghr_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);