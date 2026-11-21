
-- Q1: Find the 5 sub-categories with the lowest profit

SELECT
    sub_category,
    ROUND(SUM(sales)) AS sales,
    ROUND(SUM(profit)) AS profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margin_pct
FROM superstore
GROUP BY sub_category
ORDER BY profit
LIMIT 5;


-- Q2: Analyze profit based on discount ranges

SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.1 THEN '0-10%'
        WHEN discount <= 0.2 THEN '10-20%'
        WHEN discount <= 0.3 THEN '20-30%'
        WHEN discount <= 0.5 THEN '30-50%'
        ELSE '50%+'
    END AS discount_band,
    COUNT(*) AS order_lines,
    ROUND(SUM(profit)) AS profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margin_pct
FROM superstore
GROUP BY 1
ORDER BY MIN(discount);


-- Q3: Find all states generating negative profit

SELECT
    state,
    ROUND(SUM(profit)) AS profit
FROM superstore
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY profit;
