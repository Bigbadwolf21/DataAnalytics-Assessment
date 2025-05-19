-- Customer Lifetime Value (CLV) Estimation
-- Calculates CLV based on transaction patterns and account tenure

WITH customer_data AS (
    SELECT 
        u.id AS customer_id,
        u.first_name || ' ' || u.last_name AS name,
        u.date_joined,
        -- Calculate tenure with a minimum of 1 month to avoid division by zero
        GREATEST(
            EXTRACT(MONTH FROM AGE(CURRENT_DATE, u.date_joined)) + 
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.date_joined)) * 12,
            1
        ) AS tenure_months,
        COUNT(s.id) AS transaction_count,
        COALESCE(SUM(s.confirmed_amount), 0) / 100.0 AS total_transaction_value
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined
)

SELECT 
    customer_id,
    name,
    tenure_months,
    transaction_count AS total_transactions,
    -- CLV calculation with multiple safeguards
    ROUND(
        (transaction_count / NULLIF(tenure_months, 0)) * 12 * 
        (CASE 
            WHEN transaction_count = 0 THEN 0
            ELSE (total_transaction_value / transaction_count) * 0.001
        END),
        2
    ) AS estimated_clv, 
    -- Additional helpful metrics
    ROUND(total_transaction_value / NULLIF(tenure_months, 0), 2) AS monthly_volume,
    ROUND((total_transaction_value / NULLIF(transaction_count, 0)) / 100.0, 2) AS avg_tx_value
FROM customer_data
ORDER BY estimated_clv DESC;
