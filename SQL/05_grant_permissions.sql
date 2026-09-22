-- ============================================================
-- E-COMMERCE PROJECT
-- 01 - SETUP
-- 05 - Accord des acces
-- ============================================================


-- Rôles :
--   ECOMMERCE_ADMIN → Administration
--   ECOMMERCE_DBT   → Transformation dbt
--   ECOMMERCE_BI    → Lecture pour la restitution (Power BI)
--
-- ============================================================


-- ============================================================
-- 01 - ROLE ADMINISTRATEUR
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- Le rôle ECOMMERCE_ADMIN est destiné à l'administration de la plateforme E-Commerce.

GRANT USAGE
ON DATABASE ECOMMERCE_DWH
TO ROLE ECOMMERCE_ADMIN;

GRANT USAGE, OPERATE
ON WAREHOUSE ECOMMERCE_WH
TO ROLE ECOMMERCE_ADMIN;


-- ============================================================
-- 02 - ROLE DBT
-- ============================================================

-- ------------------------------------------------------------
-- DATABASE
-- ------------------------------------------------------------

GRANT USAGE
ON DATABASE ECOMMERCE_DWH
TO ROLE ECOMMERCE_DBT;


-- ------------------------------------------------------------
-- WAREHOUSE
-- ------------------------------------------------------------

GRANT USAGE, OPERATE
ON WAREHOUSE ECOMMERCE_WH
TO ROLE ECOMMERCE_DBT;


-- ------------------------------------------------------------
-- SCHEMA RAW
-- Lecture uniquement
-- ------------------------------------------------------------

GRANT USAGE
ON SCHEMA ECOMMERCE_DWH.RAW
TO ROLE ECOMMERCE_DBT;

GRANT SELECT
ON ALL TABLES IN SCHEMA ECOMMERCE_DWH.RAW
TO ROLE ECOMMERCE_DBT;

-- Accès automatique aux futures tables RAW

GRANT SELECT
ON FUTURE TABLES IN SCHEMA ECOMMERCE_DWH.RAW
TO ROLE ECOMMERCE_DBT;


-- ------------------------------------------------------------
-- SCHEMA DWH
-- Création des modèles intermédiaires dbt
-- ------------------------------------------------------------

GRANT USAGE
ON SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;

GRANT CREATE TABLE
ON SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;

GRANT CREATE VIEW
ON SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;


-- Accès aux objets DWH déjà existants

GRANT SELECT
ON ALL TABLES IN SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;

GRANT SELECT
ON ALL VIEWS IN SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;


-- Accès automatique aux futurs objets DWH

GRANT SELECT
ON FUTURE TABLES IN SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;

GRANT SELECT
ON FUTURE VIEWS IN SCHEMA ECOMMERCE_DWH.DWH
TO ROLE ECOMMERCE_DBT;


-- ------------------------------------------------------------
-- SCHEMA SEM
-- Couche de restitution / Power BI
-- ------------------------------------------------------------

GRANT USAGE
ON SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;

GRANT CREATE TABLE
ON SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;

GRANT CREATE VIEW
ON SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;


-- Accès aux objets SEM déjà existants

GRANT SELECT
ON ALL TABLES IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;

GRANT SELECT
ON ALL VIEWS IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;


-- Accès automatique aux futurs objets SEM

GRANT SELECT
ON FUTURE TABLES IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;

GRANT SELECT
ON FUTURE VIEWS IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_DBT;


-- ============================================================
-- 03 - ROLE BI / POWER BI
-- ============================================================

-- Le rôle ECOMMERCE_BI est volontairement en lecture seule.
--
-- Power BI n'a pas besoin de créer ou modifier des objets Snowflake.
--
-- Il consomme uniquement la couche SEM.


-- ------------------------------------------------------------
-- DATABASE
-- ------------------------------------------------------------

GRANT USAGE
ON DATABASE ECOMMERCE_DWH
TO ROLE ECOMMERCE_BI;


-- ------------------------------------------------------------
-- WAREHOUSE
-- ------------------------------------------------------------

GRANT USAGE
ON WAREHOUSE ECOMMERCE_WH
TO ROLE ECOMMERCE_BI;


-- ------------------------------------------------------------
-- SEM
-- ------------------------------------------------------------

GRANT USAGE
ON SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_BI;


-- Lecture des tables SEM existantes

GRANT SELECT
ON ALL TABLES IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_BI;


-- Lecture des vues SEM existantes

GRANT SELECT
ON ALL VIEWS IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_BI;


-- Accès automatique aux futures tables SEM

GRANT SELECT
ON FUTURE TABLES IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_BI;


-- Accès automatique aux futures vues SEM

GRANT SELECT
ON FUTURE VIEWS IN SCHEMA ECOMMERCE_DWH.SEM
TO ROLE ECOMMERCE_BI;


-- ============================================================
-- 04 - CREATION DE SCHEMA PAR DBT
-- ============================================================

-- Autorise dbt à créer de nouveaux schemas dans la database si nécessaire.
--
-- Utile notamment lors de l'initialisation du projet.

GRANT CREATE SCHEMA
ON DATABASE ECOMMERCE_DWH
TO ROLE ECOMMERCE_DBT;


-- ============================================================
-- 05 - ATTRIBUTION DES ROLES A L'UTILISATEUR
-- ============================================================

-- Rôle DBT pour exécuter le projet dbt

GRANT ROLE ECOMMERCE_DBT
TO USER AHMEDZ59;


-- Rôle BI uniquement si l'utilisateur doit tester les accès Power BI depuis son propre compte.

GRANT ROLE ECOMMERCE_BI
TO USER AHMEDZ59;


-- Rôle administrateur
-- À utiliser uniquement pour les opérations d'administration.

GRANT ROLE ECOMMERCE_ADMIN
TO USER AHMEDZ59;


-- ============================================================
-- 06 - VERIFICATION DES ACCES
-- ============================================================

-- Vérifier les droits du rôle DBT

SHOW GRANTS TO ROLE ECOMMERCE_DBT;


-- Vérifier les droits du rôle BI

SHOW GRANTS TO ROLE ECOMMERCE_BI;


-- Vérifier les rôles attribués à l'utilisateur

SHOW GRANTS TO USER AHMEDZ59;


-- ============================================================
-- 07 - VERIFICATION DES OBJETS
-- ============================================================

-- Vérification RAW

SHOW TABLES
IN SCHEMA ECOMMERCE_DWH.RAW;


-- Vérification DWH

SHOW TABLES
IN SCHEMA ECOMMERCE_DWH.DWH;


-- Vérification SEM

SHOW VIEWS
IN SCHEMA ECOMMERCE_DWH.SEM;


-- Vérification tables SEM éventuelles

SHOW TABLES
IN SCHEMA ECOMMERCE_DWH.SEM;