# DataAnalytics-Assessment

## Overview
This repository contains my solutions to a data analyst technical assessment focusing on SQL problem-solving. Each solution approaches real business scenarios with careful consideration of data integrity, edge cases, and clear logic.

### Solution Approach
#### 1. Identifying High-Value Customers
Business Need: Find customers using both savings and investment products to identify cross-selling opportunities.

My Process:

First identified customers with savings accounts by filtering for regular savings plans

Separately identified customers with investment accounts

Found the intersection of these two groups

Calculated total deposits by converting from kobo to standard currency

Ensured accurate counting by using distinct plan IDs

Key Considerations:

Accounted for customers with multiple plans of the same type

Handled currency conversion consistently

Structured the query to be easily modifiable for different product combinations

#### 2. Transaction Frequency Analysis
Business Need: Understand customer engagement patterns by categorizing transaction frequency.

My Process:

Calculated each customer's account tenure in months

Determined monthly transaction rates

Created three frequency tiers based on business requirements

Aggregated results to show distribution across tiers

Key Considerations:

Special handling for new customers to avoid division errors

Clear threshold definitions between frequency categories

Used date functions precisely to calculate accurate tenure

#### 3. Account Inactivity Monitoring
Business Need: Identify dormant accounts for operational follow-up.

My Process:

Located the most recent transaction date for each account

Calculated days since last activity

Filtered for accounts exceeding 365 days inactive

Classified account types for appropriate handling

Key Considerations:

Distinguished between never-active and formerly-active accounts

Ensured only deposit transactions were considered

Provided clear inactivity metrics for actionability

#### 4. Customer Lifetime Value Estimation
Business Need: Quantify customer value for marketing decisions.

My Process:

Calculated account tenure in months

Aggregated transaction counts and values

Applied the given CLV formula with profit assumptions

Structured results to highlight highest-value customers

Key Considerations:

Safeguarded against calculation errors with new accounts

Maintained consistent currency conversion

Ordered results for immediate business insights

#### Challenges and Solutions
Data Structure Challenges
Challenge: Amounts stored in kobo (1/100 of currency unit)

Solution: Implemented systematic conversion in all calculations

Challenge: Mixed transaction types in single table

Solution: Used careful filtering for specific analysis needs

Temporal Analysis Challenges
Challenge: Accurate time period calculations

Solution: Leveraged precise date functions and interval arithmetic

Challenge: Handling accounts with minimal transaction history

Solution: Implemented protective logic for edge cases

Business Logic Implementation
Challenge: Translating vague requirements to specific rules

Solution: Documented clear assumptions for each analysis

Challenge: Maintaining consistency across similar calculations

Solution: Created modular query structures for reuse
