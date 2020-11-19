-- 1 -- 
SELECT * 
FROM candy_customer;

-- 2 --
SELECT cust_id, cust_name
FROM candy_customer
WHERE cust_type = "w";

-- 3 --
SELECT username
FROM candy_customer
WHERE cust_phone LIKE "434%";

-- 4 --
SELECT prod_desc, (prod_price - prod_cost) AS profit
FROM candy_product
ORDER BY profit DESC;

-- 5 -- 
SELECT COUNT(DISTINCT (delivery_date)) AS number_of_different_delivery_days
FROM candy_purchase;