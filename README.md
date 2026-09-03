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
[Tableau Dashboard Link](https://public.tableau.com/app/profile/kyla.dela.pe.a/viz/Project1Dashboard_17882504091370/ExecutiveSummary)
### Overview
A 3-page interactive Tableau dashboard built to give a full view of a global retail supply chain — from top-line sales and profitability down to discount strategy and delivery performance. It's organized into Summary, Profit, and Logistics pages, each with its own KPI strip and filter set.
### Page 1: Summary
**Filters:** Order Year · Market · Delivery Status · Department Name

**KPIs**
1. Total Revenue : $33,054,402.38 
2. Total Profit : $3,966,902.97 
3. Total Orders : 180,519 orders 
4. Total Order Items : 384,079 units

**Visualizations**
- **Sales by Department** — a horizontal bar chart ranking all 11 departments by Total Sales. **Fan Shop** is by far the top performer, followed by Apparel, Golf, and Footwear; departments like Book Shop, Pet Shop, and Health and Beauty barely register by comparison.
- **Delivery Risk Breakdown** — a donut chart splitting all orders into four delivery outcomes: **Late delivery (36,048 orders)** is the largest single segment, well ahead of Advance shipping (15,127), Shipping on time (11,722), and Shipping canceled (2,855).
- **Sales and Profit Trend** — a month-by-month horizontal bar chart plotting Total Sales as bar length (colored in a red-to-yellow gradient by Market) with Total Profit overlaid as circle markers on a shared axis.

### Page 2: Profit
**Filters:** Order Year · Market · Delivery Status · Customer Segment

**KPIs**
1. Total Discounts Given : $3,730,378.40
2. Average Order Value : $183.11
3. Average Profit per Unit : $21.97
4. Average Profit Margin : 10.83%

**Visualizations**
- **Discount Impact Analysis** — a dual-axis bar-and-dot chart across six Discount Tiers. Total Profit peaks in the **1%–5% and 6%–10%** tiers (~900K), stays strong through 16%–20% (~800K), then drops sharply at 21%–25% (~350K).
- **Profit by Market and Customer Segment** — a color-coded heatmap crossing Customer Segment with Market. **Consumer/Europe is the standout cell at $627,099.00**, while Home Office/Africa is the weakest at $46,708.92.
- **Sales vs. Profit Margin per Category** — a scatter plot with a positive trend line, plotting Avg. Sales against Avg. Profit Margin (%) by product category, showing that categories with higher average order value also tend to carry higher margins.

### Page 3 — Logistics
**Filters:** Order Year · Market · Delivery Status · Shipping Mode
 
**KPIs**
1. Average Order Processing Time : 3.50 days 
2. Average Shipment Days : 0.57 days 
3. Late Delivery Rate : 54.83% 
 
**Visualizations**
- **Late Shipping Bottleneck by Market and Region** — a stacked bar chart of order volume by Market. **Europe (~18K orders)**, Pacific Asia, and Latin America drive the bulk of shipping volume — and, combined with the 54.83% late delivery rate KPI above, point to these three markets as the primary source of the delivery problem.
- **Shipment Delay Distribution** — a histogram of shipment delay in days (-3 to +5), peaking sharply at **+1 day late (~23K orders)**, with a visible right skew — most delays are minor, but a meaningful tail extends out to 3–4 days late.
- **Shipping Mode Breakdown** — a donut chart showing order volume by mode: **Standard Class dominates with 39,324 orders**, followed by Second Class (12,778), First Class (10,079), and Same Day (3,571).
- **Shipping Mode Performance** — a 100% stacked bar comparing performance outcomes across the four shipping modes. **First Class shares the highest late-delivery orders of any mode**, while Same Day carries the largest on-time segment, and Standard Class stands out for its sizable advance-shipping share.

---

### Key Takeaways
1. Over half of all orders (54.83%) arrive late, concentrated in Europe, Pacific Asia, and Latin America, with First Class showing the highest late-delivery share of any shipping mode.
2. Profit per order peaks between the 1%–20% discount tiers and declines sharply beyond 20%, indicating a ceiling the pricing strategy should respect.
3. Consumer customers in Europe generate roughly 13 times the profit of Home Office customers in Africa, highlighting where growth investment is most productive.
4. Fan Shop accounts for the majority of Order Item Total, while several departments contribute marginally.
