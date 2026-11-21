
-- Q1: Profit Margin by Region

SELECT
    region,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::NUMERIC,
        2
    ) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY profit_margin_pct DESC;



-- Q2: Average Shipping Days by Ship Mode

SELECT
    ship_mode,
    ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_days
FROM superstore
GROUP BY ship_mode
ORDER BY avg_shipping_days;



-- Q3: Top 5 Customers by Profit Within Each Segment

WITH customer_profit AS (
    SELECT
        segment,
        customer_name,
        SUM(profit) AS total_profit
    FROM superstore
    GROUP BY segment, customer_name
),
ranked_customers AS (
    SELECT
        segment,
        customer_name,
        ROUND(total_profit::NUMERIC, 2) AS total_profit,
        ROW_NUMBER() OVER (
            PARTITION BY segment
            ORDER BY total_profit DESC
        ) AS rank_in_segment
    FROM customer_profit
)
SELECT
    segment,
    customer_name,
    total_profit,
    rank_in_segment
FROM ranked_customers
WHERE rank_in_segment <= 5
ORDER BY segment, rank_in_segment;



-- Q4: Profit Analysis by Discount Band for Tables

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount'
        WHEN discount <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_band,

    COUNT(*) AS total_orders,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit

FROM superstore
WHERE sub_category = 'Tables'
GROUP BY discount_band
ORDER BY MIN(discount);



-- Q5: Highest Sales Month in Each Year

WITH monthly_sales AS (
    SELECT
        order_year,
        order_month,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY order_year, order_month
),
ranked_months AS (
    SELECT
        order_year,
        order_month,
        ROUND(total_sales::NUMERIC, 2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY order_year
            ORDER BY total_sales DESC
        ) AS rn
    FROM monthly_sales
)
SELECT
    order_year,
    order_month,
    total_sales
FROM ranked_months
WHERE rn = 1
ORDER BY order_year;
