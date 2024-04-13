SET SQL_MODE=ORACLE;

DELIMITER /

CREATE OR REPLACE TRIGGER update_subtotal BEFORE INSERT ON order_item FOR EACH ROW
DECLARE 
    item_price INT;
BEGIN
    SELECT price INTO item_price FROM menu_items WHERE item_id = :NEW.menu_item_id;
    :NEW.subtotal := item_price * :NEW.quantity;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        :NEW.subtotal := 0;
    WHEN OTHERS THEN
        :NEW.subtotal := -1;
END;
/


CREATE OR REPLACE TRIGGER update_total
AFTER INSERT ON order_items
FOR EACH ROW
DECLARE
    order_total INT;
BEGIN
    SELECT total_amount FROM orders INTO order_total FROM orders WHERE order_id = :NEW.order_id;
    order_total := order_total + :NEW.subtotal;

    UPDATE orders
    SET total_amount = order_total
    WHERE order_id = :NEW.order_id;
EXCEPTION
    WHEN OTHERS THEN
        UPDATE orders
        SET total_amount = -1
        WHERE order_id = :NEW.order_id;
END;
/

DELIMITER ;