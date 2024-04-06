SET SQL_MODE=ORACLE;

DELIMITER /

CREATE OR REPLACE PROCEDURE add_user(user_id IN INT, fname IN VARCHAR2, lname IN VARCHAR2, email IN VARCHAR2) AS
BEGIN
    IF ((fname <> '') && (lname <> '') && (email <> '')) THEN
        INSERT INTO users (user_id,fname,lname,email)
        VALUES (user_id,fname,lname,email);
        SELECT CONCAT('Created user with user id ', user_id) AS SUCCESS;
    ELSE
        SELECT 'Insufficient information provided' AS WARNING;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        SELECT 'Exception ' || SQLCODE || ' ' || SQLERRM AS EXCEPTION;
END;
/


-- IF YOU ARE MAKING MORE PROCEDURES DO IT HERE, ABOVE THE DELIMITER ; LINE


DELIMITER ;
