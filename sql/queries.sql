-- ====================================================================
-- CAPSTONE ANALYTICAL QUERIES EXPLICIT MANIFEST
-- ====================================================================

-- (a) Top 5 Funds by Assets Under Management (AUM)
SELECT fm.amfi_code, fm.scheme_name, fa.aum_amount_cr, fm.fund_house
FROM dim_fund fm
JOIN fund_aum fa ON fm.amfi_code = fa.amfi_code
ORDER BY fa.aum_amount_cr DESC
LIMIT 5;;

----------------------------------------------------------------------

-- (b) Monthly Asset Pricing Evolution: Average NAV per Month
SELECT amfi_code, strftime('%Y-%m', date) AS month, ROUND(AVG(nav), 4) AS avg_nav
FROM fact_nav
GROUP BY amfi_code, date
ORDER BY date DESC, avg_nav DESC;;

----------------------------------------------------------------------

-- (c) Systematic Investment Plan (SIP) Inflow Aggregations
SELECT strftime('%Y', start_date) AS calendar_year, 
       ROUND(SUM(monthly_installment), 2) AS total_monthly_sip_inflow,
       ROUND(SUM(monthly_installment) * 12, 2) AS annualized_sip_run_rate
FROM fact_sip_industry
WHERE is_active = 1
GROUP BY calendar_year
ORDER BY calendar_year ASC;;

----------------------------------------------------------------------

-- (d) Geographic Capital Distribution: Transactions by State
SELECT sm.type, 
       COUNT(t.tx_id) AS total_transactions, 
       ROUND(SUM(t.amount), 2) AS total_transaction_volume
FROM fact_transactions t
JOIN dim_investor i ON t.investor_id = i.investor_id
GROUP BY sm.type
ORDER BY total_transaction_volume DESC;;

----------------------------------------------------------------------

-- (e) Cost-Optimization Screening: Funds with Expense Ratio < 1%
SELECT fm.amfi_code, fm.fund_house, fp.expense_ratio, fm.category
FROM dim_fund fm
JOIN fact_performance fp ON fm.amfi_code = fp.amfi_code
WHERE fp.expense_ratio < 1.0
ORDER BY fp.expense_ratio ASC;;

----------------------------------------------------------------------

-- (6) Liquidity Flow: Net Capital Velocity per Mutual Fund Scheme
SELECT fm.amfi_code, fm.fund_house,
       ROUND(SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.amount ELSE 0 END), 2) AS total_purchases,
       ROUND(SUM(CASE WHEN t.transaction_type = 'SELL' THEN t.amount ELSE 0 END), 2) AS total_redemptions,
       ROUND(SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.amount ELSE -t.amount END), 2) AS net_capital_velocity
FROM fact_transactions t
JOIN dim_fund fm ON t.amfi_code = fm.amfi_code
GROUP BY fm.amfi_code
ORDER BY net_capital_velocity DESC;;

----------------------------------------------------------------------

-- (7) AML/KYC Compliance Audit: Inflow Volumes by Verification Status
SELECT i.kyc_status, 
       COUNT(t.tx_id) AS total_txns, 
       ROUND(SUM(t.amount), 2) AS total_capital_volume
FROM fact_transactions t
JOIN dim_investor i ON t.investor_id = i.investor_id
GROUP BY i.kyc_status;;

----------------------------------------------------------------------

-- (8) Investment Quality Screening: High Sharpe Ratio (>1.5) and Competitive Cost
SELECT fm.amfi_code, fm.fund_house, fp.sharpe_ratio, fp.return_3yr, fp.expense_ratio
FROM dim_fund fm
JOIN fact_performance fp ON fm.amfi_code = fp.amfi_code
WHERE fp.sharpe_ratio > 1.5 AND fp.expense_ratio <= 1.5
ORDER BY fp.return_3yr DESC;;

----------------------------------------------------------------------

-- (9) Portfolio Risk Analysis: Peak Lifetime NAV Volatility Spreads
SELECT scheme_code, 
       MIN(nav) AS historical_floor, 
       MAX(nav) AS historical_peak, 
       ROUND(MAX(nav) - MIN(nav), 4) AS lifetime_volatility_spread
FROM nav_history
GROUP BY scheme_code
ORDER BY lifetime_volatility_spread DESC;;

----------------------------------------------------------------------

-- (10) Capital At Risk: Active SIP Commitments in Underperforming Funds
SELECT fm.scheme_code, fm.scheme_name, fp.sharpe_ratio, 
       COUNT(s.sip_id) AS active_sip_schedules, 
       ROUND(SUM(s.monthly_installment), 2) AS monthly_trapped_capital
FROM dim_fund fm
JOIN fact_performance fp ON fm.amfi_code = fp.amfi_code
JOIN fact_sip s ON fm.amfi_code = s.amfi_code
WHERE fp.is_underperforming_risk_free = 1 AND s.is_active = 1
GROUP BY fm.amfi_code;;

----------------------------------------------------------------------

