-- ============================================================
-- E-COMMERCE PROJECT
-- 02 - INGESTION
-- 02 - RAW LOAD
-- ============================================================

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE ECOMMERCE_WH;

USE DATABASE ECOMMERCE_DWH;

-- ------------------------------------------------------------
-- 1. Vérification de la table RAW
-- ------------------------------------------------------------

SHOW TABLES IN SCHEMA RAW;

-- ------------------------------------------------------------
-- 2. Vérification du nombre de lignes chargées
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS NB_LIGNES
FROM RAW.RAW_SUPERSTORE;

-- ------------------------------------------------------------
-- 3. Vérification des premières lignes
-- ------------------------------------------------------------

SELECT *
FROM RAW.RAW_SUPERSTORE
LIMIT 10;