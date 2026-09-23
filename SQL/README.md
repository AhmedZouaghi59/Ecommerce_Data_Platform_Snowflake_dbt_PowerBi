# 🗄️ SQL — Snowflake

Le dossier `SQL` regroupe les scripts **SQL utilisés pour configurer l'environnement Snowflake et réaliser l'ingestion initiale des données** du projet **E-Commerce Data Platform**.

Cette partie intervient en amont de dbt. Elle permet de préparer la plateforme, de définir les différents espaces de travail, de gérer les accès et de charger les données sources dans la couche `RAW`.

Les transformations, la modélisation et les contrôles de qualité réalisés dans le cadre du pipeline sont ensuite pris en charge par **dbt**.

---

## 📂 Organisation du projet

```text
SQL/
│
├── 01_SETUP/
│   ├── 01_create_database.sql
│   ├── 02_create_warehouse.sql
│   ├── 03_create_roles.sql
│   ├── 04_create_schemas.sql
│   └── 05_grant_permissions.sql
│
├── 02_INGESTION/
│   ├── 01_create_raw_table.sql
│   ├── 02_load_raw.sql
│   └── 03_data_quality_checks.sql
│
└── README.md
```

---

# ⚙️ 01 — SETUP

Le dossier `01_SETUP` contient les scripts nécessaires à la mise en place de l'environnement Snowflake.

L'objectif est de disposer d'une structure claire dès le début du projet, avec une séparation entre les données, les traitements et les différents usages de la plateforme.

---

## 🗃️ Création de la base de données

Le script `01_create_database.sql` permet de créer la base utilisée par le projet :

```text
ECOMMERCE_DWH
```

Cette base constitue le point central de stockage des données utilisées dans le pipeline.

---

## ⚡ Création du Warehouse

Le script `02_create_warehouse.sql` crée le warehouse Snowflake utilisé pour exécuter les requêtes SQL et les traitements dbt :

```text
ECOMMERCE_WH
```

Le warehouse constitue la ressource de calcul utilisée pour les opérations réalisées dans Snowflake.

---

## 👤 Gestion des rôles

Le script `03_create_roles.sql` crée les rôles utilisés dans le projet :

```text
ECOMMERCE_ADMIN
ECOMMERCE_DBT
ECOMMERCE_BI
```

Chaque rôle correspond à un usage différent de la plateforme.

Cette organisation permet notamment de distinguer :

* l'administration de l'environnement ;
* les traitements réalisés par dbt ;
* l'accès utilisé pour la restitution BI.

---

## 🏗️ Création des schémas

Le script `04_create_schemas.sql` crée les différentes couches du Data Warehouse :

```text
ECOMMERCE_DWH
├── RAW
├── DWH
└── SEM
```

### `RAW`

Contient les données sources après leur ingestion dans Snowflake.

### `DWH`

Contient les données structurées et modélisées avec dbt.

### `SEM`

Correspond à la couche analytique utilisée pour préparer les données destinées à Power BI.

Cette organisation permet de séparer clairement les données sources, les traitements et la restitution.

---

## 🔐 Gestion des permissions

Le script `05_grant_permissions.sql` permet d'attribuer les droits nécessaires aux différents rôles.

L'objectif est notamment de permettre :

* à `ECOMMERCE_DBT` d'accéder aux données nécessaires et de construire les modèles ;
* à `ECOMMERCE_BI` d'accéder aux données destinées à la restitution ;
* à `ECOMMERCE_ADMIN` de gérer l'environnement Snowflake.

La gestion des rôles et permissions permet ainsi de conserver une séparation simple entre les différents usages de la plateforme.

---

# 📥 02 — INGESTION

Le dossier `02_INGESTION` correspond à l'intégration initiale du dataset **Superstore** dans Snowflake.

Cette étape permet de faire passer les données du fichier source vers la couche `RAW`, qui constitue le point de départ du pipeline de transformation.

---

## 📋 Création de la table RAW

Le script `01_create_raw_table.sql` crée la table :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

Cette table contient les données sources utilisées comme point de départ du projet.

L'objectif est de conserver une version proche de la source avant d'appliquer les transformations métier.

---

## 📤 Chargement des données

Le script `02_load_raw.sql` permet de charger les données du dataset dans la table RAW.

Le principe suivi est de conserver une séparation entre l'ingestion et les transformations :

```text
Superstore CSV
      ↓
Snowflake RAW
      ↓
Transformations dbt
```

La couche `RAW` joue ainsi le rôle de zone d'atterrissage avant les traitements réalisés dans dbt.

---

# ✅ Contrôles après ingestion

Le script `03_data_quality_checks.sql` contient les premiers contrôles réalisés directement dans Snowflake après le chargement des données.

Ces contrôles permettent notamment de vérifier :

* le nombre de lignes chargées ;
* le nombre de commandes ;
* le nombre de clients ;
* le nombre de produits ;
* la période couverte par les données ;
* les montants de ventes et de bénéfices ;
* la présence de valeurs `NULL` ;
* les quantités invalides ;
* les remises hors intervalle ;
* la présence éventuelle de ventes négatives.

L'objectif est de vérifier que les données ont bien été chargées et qu'elles présentent une structure cohérente avant de lancer les transformations dbt.

Les contrôles de qualité intégrés au pipeline sont ensuite centralisés dans **dbt**, avec des tests standards et des règles métier personnalisées.

---

# 🔄 Place de SQL dans l'architecture

Les scripts SQL constituent la première étape technique du pipeline.

```text
Superstore CSV
      ↓
SQL — Setup
      ↓
Snowflake
      ↓
SQL — Ingestion
      ↓
RAW
      ↓
dbt
      ↓
DWH
      ↓
SEM
      ↓
Power BI
```

La répartition des responsabilités est la suivante :

```text
SQL
→ Configuration de Snowflake
→ Gestion des rôles et permissions
→ Création des structures
→ Ingestion initiale
→ Contrôles après chargement

dbt
→ Transformations SQL
→ Modélisation DWH
→ Nettoyage et standardisation
→ Data Quality

Power BI
→ Modèle analytique
→ KPIs
→ Visualisation et restitution
```

Cette séparation permet de garder une chaîne de traitement lisible et de distinguer les étapes d'ingestion des transformations analytiques.

---

# 🎯 Ce que cette partie met en pratique

Cette partie du projet permet de mettre en pratique plusieurs compétences liées à un environnement Data :

* création et organisation d'une base Snowflake ;
* utilisation des warehouses ;
* gestion des rôles et des permissions ;
* organisation d'un Data Warehouse en plusieurs couches ;
* ingestion de données dans une table `RAW` ;
* contrôles SQL après ingestion ;
* préparation d'un environnement pour dbt et Power BI.

---

# ✅ Résultat

À l'issue de cette étape, l'environnement Snowflake est configuré et les données sources sont disponibles dans :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

La plateforme est alors prête pour l'étape suivante du pipeline : **la transformation et la modélisation des données avec dbt**.

```text
Snowflake RAW
      ↓
     dbt
      ↓
     DWH
      ↓
     SEM
      ↓
   Power BI
```
