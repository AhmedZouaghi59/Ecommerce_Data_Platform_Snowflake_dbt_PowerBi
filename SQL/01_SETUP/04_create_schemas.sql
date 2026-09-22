-- ============================================================
-- E-COMMERCE PROJECT
-- 01 - SETUP
-- 04 - Création des schémas
-- ============================================================

USE ROLE ACCOUNTADMIN;

USE DATABASE ECOMMERCE_DWH;

CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DWH.RAW;

CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DWH.DWH;

CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DWH.SEM;
