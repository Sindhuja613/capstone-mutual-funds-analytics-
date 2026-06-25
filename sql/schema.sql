-- ====================================================================
-- STAR SCHEMA BLUEPRINT FOR MUTUAL FUND ANALYTICS DB
-- ====================================================================

-- DIMENSION 1:
CREATE TABLE dim_fund (
    amfi_code INTEGER PRIMARY KEY,
    fund_house TEXT NOT NULL,
    category TEXT,
    expen
);

-- DIMENSION 2: 
CREATE TABLE dim_date (
    date_id INTEGER PRIMARY KEY,
    date INTEGER NOT NULL,
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
    daily_return_pct REAL,
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code),
    FOREIGN KEY (date) REFERENCES dim_date(date_id)
);

-- FACT 2:
CREATE TABLE fact_transactions (
    tx_id INTEGER PRIMARY KEY,
    inverstor_id INTEGER,
    amfi_code INTEGER,
    date INTEGER,
    amount REAL,
    type TEXT CHECK(type IN ('LUMPSUM', 'REDEMPTION', 'SIP')),
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

-- FACT 3:
CREATE TABLE fact_performance (
    amfi_code INTEGER ,
    return_1yr_pct REAL,
    sharpe_ratio REAL,
    alpha REAL,
    max_drawdown_pct REAL,
    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

-- FACT 4: 
CREATE TABLE fact_portfolio (
    amfi_code INTEGER,
    stock_symbol TEXT,
    weight_pct REAL,
    sector TEXT,
    date DATE
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
    sip_accounts_crore INTEGER
);
