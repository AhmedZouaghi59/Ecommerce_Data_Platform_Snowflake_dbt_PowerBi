-- ============================================================
-- E-COMMERCE PROJECT
-- 02 - INGESTION
-- 01 - RAW TABLE
-- ============================================================

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE ECOMMERCE_WH;

USE DATABASE ECOMMERCE_DWH;

CREATE TABLE IF NOT EXISTS RAW.RAW_SUPERSTORE (
    "Row ID" INTEGER,
    "Order ID" VARCHAR,
    "Order Date" DATE,
    "Ship Date" DATE,
    "Ship Mode" VARCHAR,
    "Customer ID" VARCHAR,
    "Customer Name" VARCHAR,
    "Segment" VARCHAR,
    "Country" VARCHAR,
    "City" VARCHAR,
    "State" VARCHAR,
    "Postal Code" INTEGER,
    "Region" VARCHAR,
    "Product ID" VARCHAR,
    "Category" VARCHAR,
    "Sub-Category" VARCHAR,
    "Product Name" VARCHAR,
    "Sales" NUMBER(18,2),
    "Quantity" INTEGER,
    "Discount" NUMBER(10,4),
    "Profit" NUMBER(18,4)
);