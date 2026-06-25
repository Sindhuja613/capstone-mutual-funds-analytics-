# Data Dictionary: Mutual Funds Analytics Relational Model

This comprehensive data dictionary documents the column schemas, types, relational constraints, and origins of the tables comprising the system's **Star Schema Architecture**.

---

## 1. Dimension Tables

### A. Table Name: `dim_fund`
* **Business Concept:** Central core registry holding structural metadata, taxonomy classifications, and cost ceilings for mutual fund assets.
* **Primary Source:** `fund_master.csv` Base Reference Matrix.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `amfi_code` | INTEGER | PRIMARY KEY | Unique Association of Mutual Funds in India (AMFI) identification index. |
| `fund_house` | TEXT | NOT NULL | Name of the Asset Management Company (AMC) managing the fund asset. |
| `category` | TEXT | None | Macro asset class deployment classification (e.g., Equity, Debt, Hybrid). |
| `expen` | REAL | None | Truncated variable entry field map representing the structural Expense Ratio percentage. |

### B. Table Name: `dim_date`
* **Business Concept:** Unified temporal dimension allowing high-performance time-series filtration across years, quarters, months, and weekdays.
* **Primary Source:** Generated Static Financial Calendar Dimension Lookup.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `date_id` | INTEGER | PRIMARY KEY | Sequential unique identifier integer serving as the tracking key. |
| `date` | INTEGER | NOT NULL | Raw timestamp or canonical date integer map vector representation. |
| `year` | INTEGER | None | Calendar year identifier numerical marker (e.g., 2026). |
| `month` | INTEGER | None | Numerical month calendar breakdown index range (1 to 12). |
| `quarter` | INTEGER | None | Financial business calendar quarter quadrant tracker range (1 to 4). |
| `is_weekday` | INTEGER | None | Boolean constraint indicator flag evaluating working weeks (1 = Yes, 0 = Weekend). |

---

## 2. Fact Tables

### A. Table Name: `fact_nav`
* **Business Concept:** High-volume granular ledger capturing daily pricing evaluations and performance fluctuations.
* **Primary Source:** `nav_history_clean.csv` / Automated Endpoint Extractions.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `amfi_code` | INTEGER | FOREIGN KEY | Maps asset entity context tracking back into `dim_fund`. |
| `date` | INTEGER | FOREIGN KEY | Connects data points chronologically over to `dim_date`. |
| `nav` | REAL | NOT NULL | Strict Net Asset Value pricing rate record entry for the target day. |
| `daily_return_pct`| REAL | None | Calculated percentage margin delta movement shift from previous closing price. |

### B. Table Name: `fact_transactions`
* **Business Concept:** Transaction log capturing asset allocation variations and investor buying profiles.
* **Primary Source:** `transactions_clean.csv` Ledger System Logs.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `tx_id` | INTEGER | PRIMARY KEY | Unique operational tracking code identifying an individual trade sequence. |
| `inverstor_id` | INTEGER | None | Traceable profile anchor ID marking the target transacting investor entity. |
| `amfi_code` | INTEGER | FOREIGN KEY | Links target trade back into a mutual fund category via `dim_fund`. |
| `date` | INTEGER | None | Date reference tracking marker logging execution parameters. |
| `amount` | REAL | None | Net valuation volume of fiat currency deployed inside the transaction. |
| `type` | TEXT | CHECK (Value Mix) | Restricts transactions to validated types: `LUMPSUM`, `REDEMPTION`, or `SIP`. |

### C. Table Name: `fact_performance`
* **Business Concept:** Risk evaluation manifest storing risk-adjusted return metrics and tail risk analysis vectors.
* **Primary Source:** `fund_performance_clean.csv` Optimization Analysis Datasets.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `amfi_code` | INTEGER | FOREIGN KEY | Mapping index pointer linking variables back into `dim_fund`. |
| `return_1yr_pct` | REAL | None | 1-Year trailing annualized profit performance tracking gauge index. |
| `sharpe_ratio` | REAL | None | Mathematical risk-adjusted return ratio evaluating excess alpha reward metrics. |
| `alpha` | REAL | None | Performance metric measuring returns above benchmark indexes. |
| `max_drawdown_pct`| REAL | None | Peak-to-trough drop tracking indicator measuring market drawdown risk. |

### D. Table Name: `fact_portfolio`
* **Business Concept:** Granular look-through asset allocation matrix tracking underlying equity weight profiles and sector focus.
* **Primary Source:** Asset Management Disclosure Reporting Forms.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `amfi_code` | INTEGER | FOREIGN KEY | Links underlying portfolio structure holdings to `dim_fund`. |
| `stock_symbol` | TEXT | None | Standardized ticker identification marker tracking company equities (e.g., RELIANCE). |
| `weight_pct` | REAL | None | Allocation percentage constraint mapping the security size within the fund. |
| `sector` | TEXT | None | Industry category track taxonomy marker (e.g., Banking, Technology, Energy). |
| `date` | DATE | None | Dynamic report window date marking current disclosure parameters. |

### E. Table Name: `fact_aum`
* **Business Concept:** Macro corporate tracking dashboard detailing scaling volume statistics and market concentration per AMC.
* **Primary Source:** Corporate Fund House Asset Reporting Manifests.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `fund_house` | TEXT | None | Target parent text identifier mapping macro metrics directly by AMC name. |
| `date` | DATE | None | Reporting timestamp window recording capital volume statistics. |
| `aum_crore` | REAL | None | Aggregated scale mass tracking metric recorded in Crores (₹). |
| `num_schemes` | INTEGER | None | Total active mutual fund offerings managed by the specific fund house. |

### F. Table Name: `fact_sip_industry`
* **Business Concept:** High-level macroeconomic intelligence tracking baseline monthly retail investor trends.
* **Primary Source:** AMFI National Inflow Data Sheets.

| Column Name | SQL Data Type | Constraint / Key | Description / Business Rule |
| :--- | :--- | :--- | :--- |
| `month` | INTEGER | None | Target monthly chronological numerical layout tracking indicator. |
| `sip_inflow_crore` | REAL | None | Consolidated monthly systematic investment plan volume across India in Crores (₹). |
| `sip_accounts_crore`| INTEGER | None | Total number of active concurrent SIP accounts running across the country. |
