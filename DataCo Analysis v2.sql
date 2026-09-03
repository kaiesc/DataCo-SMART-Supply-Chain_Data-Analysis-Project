-- =========================================================
-- SECTION A: SALES & CATEGORY PERFORMANCE
-- =========================================================

-- A1. Which product categories generate the most revenue vs. the most profit?
SELECT 
	"Category Name",
	ROUND(SUM("Order Item Total")::numeric, 2) AS "Total Revenue",
	RANK() OVER (
		ORDER BY ROUND(SUM("Order Item Total")::numeric, 2) DESC
	) AS "Revenue Rank",
	ROUND(SUM("Order Profit Per Order")::numeric, 2) AS "Total Profit",
	RANK() OVER (
		ORDER BY ROUND(SUM("Order Profit Per Order")::numeric, 2) DESC
	) AS "Profit Rank",
	ROUND(100.0 * (SUM("Order Profit Per Order")::numeric/SUM("Order Item Total")::numeric), 2) AS "Profit Margin Percentage"
FROM supplychainds
GROUP BY "Category Name"
ORDER BY "Total Revenue" DESC
LIMIT 10;
	
-- A2. Rank products within each department by profitability.
SELECT 
	"Product Name", 
	"Department Name", 
	ROUND(SUM("Order Profit Per Order")::numeric, 2) AS "Total Profit",
	DENSE_RANK() OVER (
		PARTITION BY "Department Name"
		ORDER BY ROUND(SUM("Order Profit Per Order")::numeric, 2) DESC
	) AS "Profit Rank"
FROM supplychainds
GROUP BY "Product Name", "Department Name";

-- A3. Is revenue growing, flat, or declining month over month?
WITH "Year-Month Sales" AS (
	SELECT 
		LEFT("order date (DateOrders)", 7) AS "Order YrMo",
		ROUND(SUM("Order Item Total")::numeric, 2) AS "Total Revenue"
	FROM supplychainds 
	GROUP BY "Order YrMo"
	ORDER BY "Order YrMo"
)
SELECT 
	"Order YrMo",
	"Total Revenue",
	LAG("Total Revenue", 1) OVER (ORDER BY "Order YrMo") AS "Prev. Month Sales",
	ROUND(("Total Revenue" - LAG("Total Revenue", 1) OVER (ORDER BY "Order YrMo")) / 
	LAG("Total Revenue", 1) OVER (ORDER BY "Order YrMo")* 100.0, 2) AS "Revenue Growth"
FROM "Year-Month Sales"
ORDER BY "Order YrMo";

-- A4. Do a small number of categories drive most of the profit?
WITH ProfitVCategory AS (
	SELECT 
		"Category Name",
		ROUND(SUM("Order Profit Per Order")::numeric, 2) AS "Total Profit"
	FROM supplychainds
	GROUP BY "Category Name"
	ORDER BY "Total Profit" DESC
)
SELECT
	"Category Name",
	"Total Profit",
	SUM("Total Profit") OVER (ORDER BY "Total Profit" DESC) AS "Profit Running Total",
	ROUND( SUM("Total Profit") OVER (ORDER BY "Total Profit" DESC)
	/ SUM("Total Profit") OVER () * 100, 2) AS "Cumulative Percentage"
FROM ProfitVCategory;

-- =========================================================
-- SECTION B: CUSTOMER & MARKET ANALYSIS
-- =========================================================

-- B1. Which market + customer segment combination drives the most sales volume?
SELECT 
	"Market", 
	"Customer Segment",
	SUM("Order Item Quantity") AS "Sales Volume"
FROM supplychainds
GROUP BY "Market", "Customer Segment"
ORDER BY "Sales Volume" DESC;

-- B2. Who are the top 10 customers by total spend?
SELECT 
	"Customer Id",
	"Customer Fname" || ' ' || "Customer Lname" AS "Customer Name",
	ROUND(SUM("Order Item Total")::numeric, 2) AS "Total Spend",
	RANK() OVER (ORDER BY SUM("Order Item Total") DESC) AS spend_rank
FROM supplychainds
GROUP BY "Customer Id", "Customer Fname", "Customer Lname"
ORDER BY "Total Spend" DESC
LIMIT 10;

-- B3. If you split all customers into 4 equal spend tiers, what defines a "top tier" customer?
WITH CustomerSpend AS (
	SELECT 
		"Customer Id",
		ROUND(SUM("Order Item Total")::numeric, 2) AS "Total Spend"
	FROM supplychainds
	GROUP BY "Customer Id"
)
SELECT 
	"Customer Id", 
	"Total Spend",
	NTILE(4) OVER (ORDER BY "Total Spend" DESC) AS "Spend Quartile"
FROM CustomerSpend;
	
-- B4. Which order regions are punching above/below their weight in profit vs. order volume?
SELECT 
	"Order Region",
	COUNT(DISTINCT "Order Id") AS "Order Volume",
	ROUND(SUM("Order Profit Per Order")::numeric, 2) AS "Total Profit",
	ROUND(SUM("Order Profit Per Order")::numeric / SUM("Order Item Quantity"), 2) AS "Profit per Order",
	DENSE_RANK() OVER (ORDER BY ROUND(SUM("Order Profit Per Order")::numeric, 2) DESC) AS "Profit Rank"
FROM supplychainds
GROUP BY "Order Region";

-- =========================================================
-- SECTION C: DISCOUNTING & PRICE SENSITIVITY
-- =========================================================

-- C1. At what discount rate does profitability start to break down?
SELECT 
	CASE 
		WHEN ROUND("Order Item Discount Rate"::numeric, 2) = 0 THEN 'No Discount'
		WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.05 THEN '1% - 5%'
		WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.10 THEN '6% - 10%'
		WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.15 THEN '11% - 15%'
		WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.20 THEN '16% - 20%'
		ELSE '21%+'
	END AS "Discount Tiers",
	COUNT(DISTINCT "Order Id") AS "Total Orders",
	SUM("Order Item Quantity") AS "Total Units",
	ROUND(SUM("Order Profit Per Order")::numeric, 2) AS "Total Profit",
	ROUND(SUM("Order Profit Per Order")::numeric / SUM("Order Item Quantity"), 2) AS "Profit per Unit"
FROM supplychainds
GROUP BY "Discount Tiers"
ORDER BY "Profit per Unit" DESC;

-- C2. Which categories lose the most profit-per-unit as discount rate increases?
WITH "Profit per Unit per Category and Discount Tier" AS (
	SELECT 
		"Category Name",
		CASE 
			WHEN ROUND("Order Item Discount Rate"::numeric, 2) = 0 THEN '0% / No Discount'
			WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.05 THEN '01% - 05%'
			WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.10 THEN '06% - 10%'
			WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.15 THEN '11% - 15%'
			WHEN ROUND("Order Item Discount Rate"::numeric, 2) <= 0.20 THEN '16% - 20%'
			ELSE '21%+'
		END AS "Discount Tier",
		ROUND(SUM("Order Profit Per Order")::numeric / SUM("Order Item Quantity"), 2) AS "Profit per Unit"
	FROM supplychainds
	GROUP BY "Category Name", "Discount Tier"
	ORDER BY "Category Name", "Discount Tier"
), 
"PPU difference" AS (
	SELECT
		"Category Name",
		"Discount Tier",
		"Profit per Unit",  
		"Profit per Unit" - LAG("Profit per Unit", 1) OVER (
			PARTITION BY "Category Name" 
			ORDER BY "Discount Tier") AS "PPU Diff (current - previous DT)"
	FROM "Profit per Unit per Category and Discount Tier"
)
SELECT
	"Category Name",
	"Discount Tier",
	"Profit per Unit", 
	"PPU Diff (current - previous DT)",
	RANK() OVER (ORDER BY "PPU Diff (current - previous DT)") AS "Most Loss (Profit per Unit)"
FROM "PPU difference"
WHERE "PPU Diff (current - previous DT)" IS NOT NULL;

-- =========================================================
-- SECTION D: FULFILLMENT & LOGISTICS / SLA
-- =========================================================
-- D1. Which shipping mode has the least reliable actual-vs-scheduled delivery performance?
SELECT 
	"Shipping Mode",
	ROUND(AVG("Shipment Delay (days)"), 3) AS "Average Shipment Delay",
	SUM(CASE WHEN "Shipment Delay (days)" > 0 THEN 1 ELSE 0 END) AS "Delayed Shipping",
	SUM(CASE WHEN "Shipment Delay (days)" <= 0 THEN 1 ELSE 0 END) AS "Advance/On Time Shipping", 
	ROUND(100.0 * SUM(CASE WHEN "Shipment Delay (days)" > 0 THEN 1 ELSE 0 END) / 
		(SUM(CASE WHEN "Shipment Delay (days)" > 0 THEN 1 ELSE 0 END) + 
		SUM(CASE WHEN "Shipment Delay (days)" <= 0 THEN 1 ELSE 0 END)), 2) AS "Delayed Shipment Percentage"
FROM supplychainds
WHERE "Delivery Status" != 'Shipping canceled'
GROUP BY "Shipping Mode"
ORDER BY "Delayed Shipment Percentage" DESC;

-- D2. Which region + shipping mode combination has the worst late-delivery rate? Where should logistics focus first?
WITH "Shipment Delay" AS (
	SELECT 
		"Order Id",
		"Order Region", 
		"Shipping Mode",
		"Delivery Status"
	FROM supplychainds
	WHERE "Delivery Status" != 'Shipping canceled'
	ORDER BY "Order Id"
)
SELECT 
	"Order Region", 
	"Shipping Mode",
	SUM(CASE WHEN "Delivery Status" = 'Late delivery' THEN 1 ELSE 0 END) AS "Orders w/ Delayed Shipping", 
	COUNT(*) AS "Total Orders", 
	ROUND(100.0 * SUM(CASE WHEN "Delivery Status" = 'Late delivery' THEN 1 ELSE 0 END) / COUNT(*), 2) AS "Delayed Deliveries Percentage",
	DENSE_RANK() OVER(
		ORDER BY
			ROUND(100.0 * SUM(CASE WHEN "Delivery Status" = 'Late delivery' THEN 1 ELSE 0 END) / COUNT(*), 2) DESC, 
			COUNT(*) DESC
		) AS "Worst Reliability Rank"
	FROM "Shipment Delay"
GROUP BY "Order Region", "Shipping Mode";

-- D3. On average, how many days over or under schedule does each shipping mode run? (actual days - scheduled days)
SELECT 
	"Shipping Mode",
	ROUND(AVG("Days for shipping (real)" - "Days for shipment (scheduled)"), 3) AS "Average Delay Gap (days)"
FROM supplychainds
GROUP BY "Shipping Mode"
ORDER BY "Average Delay Gap (days)" DESC;

-- D4. Which region + shipping mode combinations perform best on-time — what's the internal benchmark worth studying?
WITH "Shipment Delay" AS (
	SELECT 
		"Order Id",
		"Order Region", 
		"Shipping Mode",
		"Days for shipping (real)" - "Days for shipment (scheduled)" AS "Delay in Shipment (days)"
	FROM supplychainds
)
SELECT 
	"Order Region", 
	"Shipping Mode",
	SUM(CASE WHEN "Delay in Shipment (days)" <= 0 THEN 1 ELSE 0 END) AS "Orders w/ Advance / On-Time Shipping", 
	COUNT(*) AS "Total Orders",
	ROUND(100.0 * SUM(CASE WHEN "Delay in Shipment (days)" <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS "Advance / On-Time Deliveries Percentage",
	DENSE_RANK() OVER(
		ORDER BY
			ROUND(100.0 * SUM(CASE WHEN "Delay in Shipment (days)" <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2) DESC, 
			COUNT(*) DESC
		) AS "Best Performance Rank"
	FROM "Shipment Delay"
GROUP BY "Order Region", "Shipping Mode"
HAVING (COUNT(*) >= 1000 AND SUM(CASE WHEN "Delay in Shipment (days)" <= 0 THEN 1 ELSE 0 END) != 0);