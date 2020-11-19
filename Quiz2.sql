-- 1 --
SELECT cust_name AS Customer
FROM candy_customer c JOIN candy_cust_type t
	ON c.cust_type = t.cust_type
WHERE cust_type_desc = 'Retail';

-- 2 --
SELECT cust_type, count(cust_type) AS count_of_each_type
FROM candy_customer 
GROUP BY cust_type;

-- 3 --
SELECT cust_name AS Customer
FROM candy_customer c JOIN candy_purchase p
	ON c.cust_id = p.cust_id
    JOIN candy_product cpd
    ON p.prod_id = cpd.prod_id
WHERE cpd.prod_desc = "Celestial Cashew Crunch";

-- 4 -- 
SELECT  prod_id, avg(pounds) AS average_pound
FROM candy_purchase
GROUP BY prod_id
HAVING  count(cust_id) > 3;

-- 5 --
SELECT prod_desc
FROM candy_product cpd LEFT JOIN candy_purchase p
	ON cpd.prod_id = p.prod_id
WHERE purch_id IS NULL;
