# DataCo SMART Supply Chain Data Analysis Project
The DataCo supply chain dataset consists of roughly 180k transactions from supply chains used by the company DataCo Global for 3 years, with 53 columns containing information on various aspects of the supply chain, including product details, pricing, discount, and shipping.
# PROBLEM STATEMENT
The DataCo supply chain dataset presents a comprehensive set of information related to product sales, operational fulfillment, and shipping logistics. The challenge is to extract meaningful insights and actionable recommendations from the data to eliminate delivery delays, mitigate transaction security risks, and optimize discounting strategies to improve overall supply chain profitability.
# TOOLS USED
- Python: Numpy, Pandas, SeaBorn, Matplotlib
- PostgreSQL
- Tableau
# DOCUMENTATION
## Python Analysis
### Table of Contents
1. Import required libraries
2. Data Understanding
    - Loading of data
    - Inspecting data
3. Data Quality Assessment
    - Missing values analysis
    - Duplicate data analysis
    - Unique values analysis
    - Check for duplicate columns
    - Data quality assessment summary
4. Data Cleaning
    - Removing irrelevant columns
    - Data normalization
5. Feature Engineering
    - Time features (from Order Date)
    - Discount Tier Bins
    - Order Processing Duration (days)
    - Shipment Delay Gap (days)
6. Exporting Clean Data
7. Exploratory Data Analysis
   - Graphs
   - **Sales Analysis**
        1.  Analyze revenue generated, total items sold, and profit margins across product categories to evaluate sales performance.
        2.  Identify customer demographics and geographic markets (by segment, country, and region) to determine which customer groups are driving the highest purchasing volume.
        3.  Track discounting strategies and price sensitivity to ensure product lines remain profitable and discount rates are optimized to match customer buying behavior.
    - **Operations Analysis**
        1.  Analyze order status distributions across payment methods to minimize lost revenue and streamline order verification workflows.
        2.  Evaluate market and department fulfillment workload by measuring total units fulfilled and unique order volume across global sales regions to optimize labor and resource allocation.
        3.  Assess delivery status performance and operational processing efficiency by tracking fulfillment statuses to identify operational bottlenecks before orders enter transit.
    - **Fulfillment & Logistics Analysis**
        1. Evaluate fulfillment reliability by comparing order volume across shipping modes and actual transit durations segmented by SLA breach and compliant statuses.
        2. Evaluate shipping mode efficiency and delay rates across transit options (Standard Class, First Class, Second Class, Same Day) segmented by Customer Country to identify which shipping methods experience the highest rate of delivery schedule breaches in each region.
## PostgreSQL Analysis
### Table of Contents
1. **Sales and Category Performance**
    1. Which product categories generate the most revenue vs. the most profit?
    2. Rank products within each department by profitability.
    3. Is revenue growing, flat, or declining month over month?
    4. Do a small number of categories drive most of the profit?
2. **Customer and Market Analysis**
    1. Which market + customer segment combination drives the most sales volume?
    2. Who are the top 10 customers by total spend?
    3. If you split all customers into 4 equal spend tiers, what defines a "top tier" customer?
    4. Which order regions are punching above/below their weight in profit vs. order volume?
3. **Discounting and Price Sensitivity**
    1. At what discount rate does profitability start to break down?
    2. Which categories lose the most profit-per-unit as discount rate increases?
4. **Fulfillment and Logistics / SLA**
    1. Which shipping mode has the least reliable actual-vs-scheduled delivery performance?
    2. Which region + shipping mode combination has the worst late-delivery rate? Where should logistics focus first?
    3. On average, how many days over or under schedule does each shipping mode run? (actual days - scheduled days)
    4. Which region + shipping mode combinations perform best on-time — what's the internal benchmark worth studying?
## Tableau
