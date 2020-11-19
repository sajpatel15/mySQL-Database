DROP TABLE IF EXISTS candy_matview;
DROP TRIGGER IF EXISTS candy_trigger;

CREATE TABLE candy_matview(
	cust_name VARCHAR(30),
    cust_type_desc VARCHAR(10),
    prod_desc VARCHAR(30),
    pounds FLOAT
    );
    
INSERT INTO candy_matview (cust_name, cust_type_desc, prod_desc, pounds)
	(SELECT cc.cust_name, cct.cust_type_desc, cpd.prod_desc, cp.pounds
    FROM candy_purchase cp JOIN candy_customer cc ON cp.cust_id = cc.cust_id
    JOIN candy_cust_type cct ON cc.cust_type = cct.cust_type
    JOIN candy_product cpd ON cp.prod_id = cpd.prod_id
    );
    
DELIMITER // 
CREATE TRIGGER candy_trigger
	AFTER INSERT ON candy_purchase 
    FOR EACH ROW
    BEGIN
		 INSERT INTO candy_matview (cust_name, cust_type_desc, prod_desc, pounds)
			VALUES ((SELECT cust_name FROM candy_customer WHERE cust_id = NEW.cust_id), 
					(SELECT cct.cust_type_desc FROM candy_cust_type cct JOIN candy_customer cc ON cct.cust_type = cc.cust_type WHERE cc.cust_id = NEW.cust_id),
                    (SELECT prod_desc FROM candy_product WHERE prod_id = NEW.prod_id),
                    (SELECT pounds FROM candy_purchase WHERE pounds = NEW.pounds)
                    );
    END // 
DELIMITER ;

INSERT INTO candy_purchase 
VALUES(100,
		(select prod_id from candy_product where prod_desc = 'Nuts Not Nachos'),
		(select cust_id from candy_customer where cust_name = 'The Candy Kid'),
		'2020-11-2', 
		'2020-11-6',
		5.2,
		'PAID'
    );

SELECT * FROM candy_matview;