SHOW DATABASES;
USE walmart_sales;
SELECT DATABASE();
SELECT * FROM walmart_new_data;
SELECT COUNT(*) FROM walmart_new_data;
SHOW TABLES;


-- find different payment method and number of transactions, number of quantity sold
SELECT 
      payment_method,
      COUNT(*) as no_payments,
      SUM(quantity)as no_quantity_sold
FROM walmart_new_data
GROUP BY payment_method;


  -- Identify the highest rated category in each branch, displaying the branch, cateogory and avg rating
SELECT 
    Branch,
    category,
    AVG(rating) AS avg_rating
FROM walmart_new_data
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- identify the busiest day of each branch based on the number of transactions
SELECT 
    Branch,
    DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
    COUNT(*) AS no_transactions
FROM walmart_new_data
GROUP BY Branch, day_name
ORDER BY day_name, no_transactions DESC;

-- calculate the total quantity of items sold per payment method,  list payment method and total quantity
SELECT 
    payment_method,
    SUM(quantity) AS total_quantity
FROM walmart_new_data
GROUP BY payment_method;
 
 -- determine the ave, min and max rating of products for each city, List the city , av rating, min rating and max rating

SELECT 
    city,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM walmart_new_data
GROUP BY city;

-- calculate the total profit for each category by considering total profits as (unit_price * quantity * profit_margin )
-- list category and total_profit, ordered from highest to lowest profit 
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart_new_data
GROUP BY category
ORDER BY total_profit DESC;

-- determine the most common payment method for each Branch
-- display branch and preferred payment method
SELECT 
    Branch,
    payment_method,
    COUNT(*) AS no_transactions
FROM walmart_new_data
GROUP BY Branch, payment_method
ORDER BY Branch, no_transactions DESC;

-- categorize sales into 3 groups MORNING, AFTERNOON, EVENING
-- Find out each of the shift and number of invoices
SELECT 
    CASE 
        WHEN HOUR(STR_TO_DATE(date, '%d/%m/%Y')) BETWEEN 0 AND 11 THEN 'MORNING'
        WHEN HOUR(STR_TO_DATE(date, '%d/%m/%Y')) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS shift,
    COUNT(*) AS no_invoices
FROM walmart_new_data
WHERE date IS NOT NULL  -- Ensure no NULL dates are processed
GROUP BY 
    CASE 
        WHEN HOUR(STR_TO_DATE(date, '%d/%m/%Y')) BETWEEN 0 AND 11 THEN 'MORNING'
        WHEN HOUR(STR_TO_DATE(date, '%d/%m/%Y')) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END
ORDER BY FIELD(shift, 'MORNING', 'AFTERNOON', 'EVENING');


-- identify 5 branch with highest decrease ratio in revenue compare to last year
SELECT 
    Branch,
    SUM(CASE WHEN YEAR(date) = 2022 THEN total ELSE 0 END) AS revenue_2022,
    SUM(CASE WHEN YEAR(date) = 2023 THEN total ELSE 0 END) AS revenue_2023,
    (SUM(CASE WHEN YEAR(date) = 2022 THEN total ELSE 0 END) - SUM(CASE WHEN YEAR(date) = 2023 THEN total ELSE 0 END)) /
    SUM(CASE WHEN YEAR(date) = 2022 THEN total ELSE 0 END) * 100 AS decrease_ratio
FROM walmart_new_data
WHERE YEAR(date) IN (2022, 2023)
GROUP BY Branch
HAVING revenue_2022 > 0  -- to avoid division by zero
ORDER BY decrease_ratio DESC
LIMIT 5;



