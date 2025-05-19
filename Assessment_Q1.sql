-- High-Value Customers with Multiple Products
-- Finds customers with both savings and investment plans, sorted by total deposits

WITH 
-- Customers with at least one savings plan
savings_customers AS (
    SELECT DISTINCT owner_id
    FROM plans_plan
    WHERE is_regular_savings = 1
),

-- Customers with at least one investment plan
investment_customers AS (
    SELECT DISTINCT owner_id
    FROM plans_plan
    WHERE is_a_fund = 1
),

-- Customers with both types of plans
dual_product_customers AS (
    SELECT s.owner_id
    FROM savings_customers s
    INNER JOIN investment_customers i ON s.owner_id = i.owner_id
),

-- Calculate total deposits per customer
customer_deposits AS (
    SELECT 
        owner_id,
        SUM(confirmed_amount) / 100.0 AS total_deposits  -- Convert from kobo to currency
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Final result with all required fields
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    COALESCE(d.total_deposits, 0) AS total_deposits
FROM users_customuser u
JOIN dual_product_customers dp ON u.id = dp.owner_id
LEFT JOIN plans_plan p ON u.id = p.owner_id
LEFT JOIN customer_deposits d ON u.id = d.owner_id
GROUP BY u.id, u.first_name, u.last_name, d.total_deposits
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0 AND
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0
ORDER BY total_deposits DESC;
