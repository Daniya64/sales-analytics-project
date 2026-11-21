
-- Q4: Year-over-Year Sales Growth using LAG

WITH yearly AS (
    SELECT
        order_year,
        SUM(sales) AS sales
    FROM superstore
    GROUP BY order_year
)
SELECT
    order_year,
    ROUND(sales) AS sales,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY order_year))
        / LAG(sales) OVER (ORDER BY order_year) * 100,
        1
    ) AS yoy_growth_pct
FROM yearly
ORDER BY order_year;



-- Q5: Rank Sub-Categories Within Each Category

SELECT
    category,
    sub_category,
    ROUND(SUM(profit)) AS profit,
    RANK() OVER (
        PARTITION BY category
        ORDER BY SUM(profit) DESC
    ) AS rank_in_category
FROM superstore
GROUP BY category, sub_category
ORDER BY category, rank_in_category;



-- Q6: Running Total of Sales Per Year

SELECT
    order_year,
    order_month,
    ROUND(SUM(sales)) AS monthly_sales,
    ROUND(
        SUM(SUM(sales)) OVER (
            PARTITION BY order_year
            ORDER BY order_month
        )
    ) AS running_total
FROM superstore
GROUP BY order_year, order_month
ORDER BY order_year, order_month;



-- Q7: Top 3 Products Per Category

SELECT *
FROM (
    SELECT
        category,
        product_name,
        ROUND(SUM(profit)) AS profit,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY SUM(profit) DESC
        ) AS rn
    FROM superstore
    GROUP BY category, product_name
) t
WHERE rn <= 3
ORDER BY category, rn;


-- Q8: Customer Value Quartiles

WITH cust AS (
    SELECT
        customer_name,
        SUM(sales) AS sales,
        SUM(profit) AS profit
    FROM superstore
    GROUP BY customer_name
)
SELECT
    customer_name,
    ROUND(sales) AS sales,
    ROUND(profit) AS profit,
    NTILE(4) OVER (
        ORDER BY profit DESC
    ) AS quartile
FROM cust
ORDER BY profit DESC;



-- Session 4: RFM Customer Segmentation

WITH rfm AS (
    SELECT
        customer_id,
        DATE '2017-12-31' - MAX(order_date) AS recency_days,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(sales) AS monetary
    FROM superstore
    GROUP BY customer_id
),
scored AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency) AS f_score,
        NTILE(4) OVER (ORDER BY monetary) AS m_score
    FROM rfm
)
SELECT
    CASE
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
            THEN 'Champions'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        WHEN r_score >= 3
            THEN 'Recent'
        ELSE 'Others'
    END AS segment,
    COUNT(*) AS customers
FROM scored
GROUP BY 1
ORDER BY customers DESC;



-- Create Monthly Performance View

CREATE OR REPLACE VIEW vw_monthly_performance AS
SELECT
    order_year,
    order_month,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM superstore
GROUP BY order_year, order_month;

--check working

SELECT *
FROM vw_monthly_performance
ORDER BY order_year, order_month;
