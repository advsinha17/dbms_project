
CALL add_user(10000001, 'mypassword12', 'Advik','Sinha','f20222004@hyderabad.bits-pilani.ac.in', 1);
CALL add_user(10000002,'mypassword12', 'Archith','Vinod Kumar','f20220229@hyderabad.bits-pilani.ac.in', 1);
CALL add_user(10000003,'mypassword12', 'Rohan','Mathew','f20220211@hyderabad.bits-pilani.ac.in', 1);
CALL add_user(10000004,'mypassword12', 'Arnav','Gupta','f20220067@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000005,'mypassword12', 'Aarav','Haran','f20220880@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000006,'mypassword12', 'Kevin','George Mathew','f20220238@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000007,'mypassword12', 'Aditya','Pentyala','f20220522@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000008,'mypassword12', 'Abishek','Muthukumar','f20220770@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000009,'mypassword12', 'Saharsh','Misra','f20220074@hyderabad.bits-pilani.ac.in', 0);
CALL add_user(10000010,'mypassword12', 'Abinav','Venkatagiri','f20222002@hyderabad.bits-pilani.ac.in', 0);


CALL create_new_restaurant(1000,10000001,'Yumpies','Variety of Indian and Chinese dishes, along with Maggi noodles served','Open','1234567890');
CALL create_new_restaurant(1001,10000003,'Thickshake Company','Milkshakes,thickshakes and icecream avalailable','Closed','2345678901');
CALL create_new_restaurant(1002,10000001,'Chipotle','Delicious south indian breakfast served','Open','3456789012');
CALL create_new_restaurant(1003,10000001,'Wichplease','Variety of sandwiches and maggi served','Closed','4567890123');
CALL create_new_restaurant(1004,10000002,'Chai Coffee Company','chinese cuisine along with indian sweets and snacks served','Permanently Closed','5678901234');
CALL create_new_restaurant(1005,10000003,'Maggi Hotspot','100 different varities of maggi served along with some beverages','Open','6789012345');
CALL create_new_restaurant(1006,10000003,'SFC','continental cuisine along with packaged ice cream and deserts served here','Under Renovation','7890123456');
CALL create_new_restaurant(1007,10000002,'Chaat Place','Indian chaat items available','Open','8901234567');

CALL create_menu_item(50000000, 1000, 'Paneer Rice Bowl', 100, 'Medium spicy');
CALL create_menu_item(50000001, 1000, 'Veg Noodles', 120, 'Very spicy');
CALL create_menu_item(50000002, 1000, 'Chicken Noodles', 130, 'Very spicy');
CALL create_menu_item(50000003, 1000, 'Veg Fried Rice', 120, 'Medium spicy');
CALL create_menu_item(50000004, 1000, 'Chicken Fried Rice', 130, 'Medium spicy');
CALL create_menu_item(50000005, 1001, 'Strawberry Icecream', 25, 'Served with strawberry syrup');
CALL create_menu_item(50000006, 1001, 'Berry Chocochip Shake', 130, 'Icecream thickshake');
CALL create_menu_item(50000007, 1001, 'Chocolate Icecream', 30, 'Served with chocolate syrup');
CALL create_menu_item(50000008, 1001, 'Blueberry Velvet Shake', 140, 'Icecream thickshake');
CALL create_menu_item(50000009, 1002, 'Plain Dosa', 50, 'Served with white chutney');
CALL create_menu_item(50000010, 1002, 'Onion Dosa', 60, 'Served with red and white chutney');
CALL create_menu_item(50000011, 1002, 'Masala Dosa', 55, 'Served with white chutney');
CALL create_menu_item(50000012, 1003, 'Spinach Corn Sandwich', 70, 'Triple layer');
CALL create_menu_item(50000013, 1003, 'Tandoori Paneer Sandwich', 70, 'Triple layer');
CALL create_menu_item(50000014, 1004, 'Veg Manchow Soup', 50, 'Non spicy');
CALL create_menu_item(50000015, 1004, 'Veg Chowmein', 100, 'Served with baked noodles');
CALL create_menu_item(50000016, 1004, 'Chicken Chowmein', 110, 'Served with baked noodles');
CALL create_menu_item(50000017, 1005, 'Cheese Oregano Maggi', 60, 'Non spicy');
CALL create_menu_item(50000018, 1005, 'Double Masala Maggi', 50, 'Medium spicy');
CALL create_menu_item(50000019, 1005, 'Delhi Dhamaka Maggi', 90, 'Very spicy');
CALL create_menu_item(50000020, 1006, 'Veg Burger', 90, 'Served with sauce and dip');
CALL create_menu_item(50000021, 1006, 'Chicken Burger', 100, 'Served with sauce and dip');
CALL create_menu_item(50000022, 1007, 'Chole Bhature', 70, 'Medium spicy');
CALL create_menu_item(50000023, 1007, 'Pav Bhaji', 80, 'Medium spicy');
CALL create_menu_item(50000024, 1007, 'Vada Pav', 50, 'Extremely spicy');
CALL create_menu_item(50000025, 1007, 'Golgappe', 30, '8 pieces');
CALL create_menu_item(50000026, 1007, 'Chole Kulcha', 80, 'Medium spicy');
CALL create_menu_item(50000027, 1007, 'Papdi Chaat', 40, 'Served with dhaniya and curd');


CALL create_new_order(60000000, 10000004, 1000, 9912345678);
CALL create_order_item(60000000, 70000000, 1, 50000001);
CALL create_order_item(60000000, 70000001, 1, 50000000);
CALL create_order_item(60000000, 70000002, 2, 50000004);
CALL create_order_item(60000000, 70000003, 1, 50000002);
CALL place_order(60000000, 'Cash');
CALL create_new_order(60000001, 10000006, 1001, 9812345678);
CALL create_order_item(60000001, 70000000, 1, 50000005);
CALL create_order_item(60000001, 70000001, 3, 50000006);
CALL create_order_item(60000001, 70000002, 2, 50000007);
CALL place_order(60000001, 'UPI');
CALL create_new_order(60000002, 10000009, 1007, 9712345678);
CALL create_order_item(60000002, 70000000, 1, 50000025);
CALL create_order_item(60000002, 70000001, 2, 50000026);
CALL place_order(60000002, 'Card');



CALL create_new_order(60000003, 10000003, 1000, 9612345678);
CALL create_order_item(60000003, 70000000, 3, 50000009);
CALL create_order_item(60000003, 70000001, 1, 50000010);
CALL create_order_item(60000003, 70000002, 1, 50000011);
CALL place_order(60000003, 'Cash');

