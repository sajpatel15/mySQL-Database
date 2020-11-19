-- CALL myCreateTable(100000) took 738.968 sec --
-- CALL mySelectTest(50,1000) took 56.531 sec --

-- CALL myCreateTable(100000) with INDEX took 500.797 sec -- 
-- CALL mySelectTest(50,1000) with INDEX took 0.313 sec --

DROP PROCEDURE IF EXISTS mySelectTest;
DROP PROCEDURE IF EXISTS myCreateTable;

DROP TABLE IF EXISTS myTable;
delimiter //
CREATE PROCEDURE myCreateTable(IN ENTRIES INT)
BEGIN
	DECLARE COUNTER INT DEFAULT 0;
    
	CREATE TABLE myTable
    (
		Pkey BIGINT AUTO_INCREMENT PRIMARY KEY,
        num INT,
        INDEX(num)
    );
    
    WHILE counter < ENTRIES DO
		INSERT INTO myTABLE(num) VALUE (FLOOR(RAND() * 1000));
		SET counter = counter + 1;
	END WHILE; 

END // 
delimiter ;

delimiter //
CREATE PROCEDURE mySelectTest(IN TARGET INT, IN NUM_RUN INT)
BEGIN
	DECLARE counter INT DEFAULT 0;
    DECLARE total_rows INT DEFAULT 0;
    
	WHILE counter < NUM_RUN DO
		SELECT COUNT(*) INTO total_rows
		FROM myTable
		WHERE num = TARGET;
		SET counter = counter + 1;
	END WHILE;
END //
delimiter ;

 CALL myCreateTable(100000); 
 CALL mySelectTest(50, 1000);