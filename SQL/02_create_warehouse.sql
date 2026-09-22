-- ============================================================
-- E-COMMERCE PROJECT
-- 01 - SETUP
-- 02 - Création du WAREHOUSE ECOMMERCE_DW
-- ============================================================

CREATE WAREHOUSE IF NOT EXISTS ECOMMERCE_WH
WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;