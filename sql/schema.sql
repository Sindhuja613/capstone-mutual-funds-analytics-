-- ====================================================================
-- STAR SCHEMA BLUEPRINT FOR MUTUAL FUND ANALYTICS DB
-- ====================================================================

-- DIMENSION 1:
CREATE TABLE dim_fund (
    amfi_code INTEGER PRIMARY KEY,
    fund_house TEXT NOT NULL,
    category TEXT,
    expense_ratio_pct REAL,
    min_sip_amount REAL,
    risk_category TEXT
);

-- DIMENSION 2: 
CREATE TABLE dim_date (
     date_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    is_weekday INTEGER
);

-- FACT 1: 
CREATE TABLE fact_nav (
    amfi_code INTEGER FOREIGN KEY,
    date INTEGER FOREIGN KEY,
    nav REAL NOT NULL,
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code),
    FOREIGN KEY (date) REFERENCES dim_date(date_id)
);

-- FACT 2:
CREATE TABLE fact_transactions (
    tx_id INTEGER PRIMARY KEY AUTOINCREMENT,
        investor_id INTEGER,
        amfi_code INTEGER,
        transaction_date TEXT,
        amount_inr REAL,
        transaction_type TEXT CHECK(transaction_type IN ('LUMPSUM', 'REDEMPTION', 'SIP')),
        state TEXT,
        city TEXT,
        city_tier VARCHAR(10),
        age_group VARCHAR(10),
        gender VARCHAR(10),
        FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code),
        FOREIGN KEY (transaction_date) REFERENCES dim_date(date)
);

-- FACT 3:
CREATE TABLE fact_performance (
    amfi_code INTEGER ,
    return_1yr_pct REAL,
    sharpe_ratio REAL,
    alpha REAL,
    max_drawdown_pct REAL,
    expense_ratio_pct REAL,
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

-- FACT 4: 
CREATE TABLE fact_portfolio (
    amfi_code INTEGER,
    stock_symbol TEXT,
    weight_pct REAL,
    sector TEXT,
    portfolio_date DATE
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

-- FACT 5:
CREATE TABLE fact_aum (
    fund_house TEXT,
    date DATE,
    aum_crore REAL,
    num_schemes INTEGER
);

-- FACT 6:
CREATE TABLE fact_sip_industry (
    month INTEGER,
    sip_inflow_crore REAL,
    yoy_growth_pct REAL,
    active_sip_accounts_crore INTEGER
);
