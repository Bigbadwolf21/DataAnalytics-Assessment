-- Transaction Frequency Analysis
-- Categorizing customers by their average monthly transaction frequency

WITH 
-- Calculate transaction counts and tenure for each customer
customer_transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        -- Calculate tenure in months (time between first and last transaction)
        EXTRACT(MONTH FROM AGE(MAX(created_at), MIN(created_at))) + 
        EXTRACT(YEAR FROM AGE(MAX(created_at), MIN(created_at))) * 12 AS tenure_months
    FROM savings_savingsaccount
    GROUP BY owner_id
    HAVING COUNT(*) > 0  -- Excluding customers with no transactions
),

-- Calculate average monthly transactions and categorize
customer_frequency AS (
    SELECT 
        owner_id,
        total_transactions,
        -- Handle division by zero (customers with tenure < 1 month)
        CASE 
            WHEN tenure_months = 0 THEN total_transactions
            ELSE total_transactions / NULLIF(tenure_months, 0)
        END AS avg_monthly_transactions,
        -- Frequency categorization
        CASE 
            WHEN total_transactions / NULLIF(tenure_months, 0) >= 10 THEN 'High Frequency'
            WHEN total_transactions / NULLIF(tenure_months, 0) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_transactions
)

-- Final aggregation by frequency category
SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM customer_frequency
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
