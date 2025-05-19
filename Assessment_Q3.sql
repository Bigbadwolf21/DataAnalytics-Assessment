-- Account Inactivity Alert
-- Identifies accounts with no deposits in over 1 year

WITH 
-- Get the last transaction date for each plan
last_transactions AS (
    SELECT 
        plan_id,
        MAX(created_at) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0  -- considering only deposit transactions (inflows)
    GROUP BY plan_id
)

-- Final result with inactivity calculation
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    lt.last_transaction_date,
    EXTRACT(DAY FROM (CURRENT_DATE - lt.last_transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN last_transactions lt ON p.id = lt.plan_id
WHERE 
    -- Accounts with no transactions at all will be treated as inactive
    lt.last_transaction_date IS NULL 
    OR 
    -- Accounts with no transactions in the last 365 days
    lt.last_transaction_date < CURRENT_DATE - INTERVAL '365 days'
ORDER BY inactivity_days DESC;
