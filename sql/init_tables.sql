-- CREATE USERS TABLE
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

-- FOREIGN KEY BETWEEN RESTAURANT AND RESTAURANT CONTACTS
ALTER TABLE restaurant_contacts add constraint fk_restaurant_contacts FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);
