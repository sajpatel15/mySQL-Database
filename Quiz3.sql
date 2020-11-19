-- 1 --
SELECT cust_name 
FROM candy_customer
WHERE cust_type = (SELECT cust_type
		FROM candy_cust_type
        WHERE cust_type_desc = "Retail");


-- 2 --
SELECT cust_name 
FROM candy_customer c JOIN candy_cust_type ct
	ON c.cust_type = ct.cust_type
WHERE ct.cust_type_desc = "Retail";

-- 3 --
SELECT cust_name
FROM candy_customer
WHERE cust_id IN (SELECT cust_id
	FROM candy_purchase
    WHERE status = "NOT PAID");

-- 4 --
SELECT cust_name
FROM candy_customer
WHERE cust_id IN 
		(
        SELECT cust_id
		FROM candy_purchase
        WHERE prod_id IN 
			(SELECT prod_id
            FROM candy_product
            WHERE prod_desc = "Celestial Cashew Crunch")
        );

-- 5 --
SELECT DISTINCT prod_desc
FROM candy_product
WHERE prod_id IN 
		(
        SELECT prod_id 
        FROM candy_purchase p
        WHERE p.pounds > 
			(
            SELECT AVG(pounds)
            FROM candy_purchase
            )
		);

