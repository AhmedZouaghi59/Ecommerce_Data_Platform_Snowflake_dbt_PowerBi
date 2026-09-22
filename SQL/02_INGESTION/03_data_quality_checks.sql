-- ============================================================
-- E-COMMERCE PROJECT
-- 02 - INGESTION
-- 03 - DATA QUALITY CHECKS
-- ============================================================

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE ECOMMERCE_WH;

USE DATABASE ECOMMERCE_DWH;

-- ============================================================
-- 1. Nombre de lignes
-- ============================================================

SELECT
    COUNT(*) AS NB_LIGNES
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 2. Nombre de commandes
-- ============================================================

SELECT COUNT(DISTINCT "Order ID") AS NB_COMMANDES
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 3. Nombre de clients
-- ============================================================

SELECT COUNT(DISTINCT "Customer ID") AS NB_CLIENTS
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 4. Nombre de produits
-- ============================================================

SELECT COUNT(DISTINCT "Product ID") AS NB_PRODUITS
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 5. Période des données
-- ============================================================

SELECT  MIN("Order Date") AS DATE_MIN, MAX("Order Date") AS DATE_MAX
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 6. Chiffre d'affaires et bénéfice
-- ============================================================

SELECT SUM("Sales") AS CA, SUM("Profit") AS BENEFICE
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 7. Contrôle des valeurs NULL
-- ============================================================

SELECT
    COUNT(*) - COUNT("Order ID") AS NULL_ORDER_ID,
    COUNT(*) - COUNT("Customer ID") AS NULL_CUSTOMER_ID,
    COUNT(*) - COUNT("Product ID") AS NULL_PRODUCT_ID,
    COUNT(*) - COUNT("Order Date") AS NULL_ORDER_DATE,
    COUNT(*) - COUNT("Sales") AS NULL_SALES,
    COUNT(*) - COUNT("Profit") AS NULL_PROFIT
FROM RAW.RAW_SUPERSTORE;


-- ============================================================
-- 8. Contrôle des quantités invalides
-- ============================================================

SELECT COUNT(*) AS NB_QUANTITE_INVALIDE
FROM RAW.RAW_SUPERSTORE
WHERE "Quantity" <= 0 OR "Quantity" IS NULL;


-- ============================================================
-- 9. Contrôle des remises
-- ============================================================

SELECT COUNT(*) AS NB_DISCOUNT_INVALIDE
FROM RAW.RAW_SUPERSTORE
WHERE "Discount" < 0 OR "Discount" > 1;


-- ============================================================
-- 10. Contrôle des ventes
-- ============================================================

SELECT COUNT(*) AS NB_SALES_NEGATIVES
FROM RAW.RAW_SUPERSTORE
WHERE "Sales" < 0;

-- ============================================================
-- 11. Synthèse globale de la RAW
-- ============================================================

SELECT
    COUNT(*) AS NB_LIGNES,
    COUNT(DISTINCT "Order ID") AS NB_COMMANDES,
    COUNT(DISTINCT "Customer ID") AS NB_CLIENTS,
    COUNT(DISTINCT "Product ID") AS NB_PRODUITS,
    MIN("Order Date") AS DATE_MIN,
    MAX("Order Date") AS DATE_MAX,
    SUM("Sales") AS CA,
    SUM("Profit") AS BENEFICE
FROM RAW.RAW_SUPERSTORE;