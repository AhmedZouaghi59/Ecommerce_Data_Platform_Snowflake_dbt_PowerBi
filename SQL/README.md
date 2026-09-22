# 🗄️ SQL — Snowflake

Ce dossier regroupe les scripts SQL utilisés pour mettre en place l'environnement Snowflake du projet **E-Commerce Data Platform**.

Cette partie correspond principalement à la **configuration de la plateforme, à la gestion des accès et à l'ingestion initiale des données**. Les transformations et les contrôles de qualité intégrés au pipeline sont ensuite pris en charge par dbt.

## 📂 Organisation

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

## ⚙️ 01_SETUP

Le dossier `01_SETUP` contient les scripts nécessaires à la création et à la configuration de l'environnement Snowflake.

### `01_create_database.sql`

Création de la base de données utilisée par le projet :

```text
ECOMMERCE_DWH
```

Cette base constitue le point central de stockage des données.

### `02_create_warehouse.sql`

Création du warehouse Snowflake utilisé pour exécuter les requêtes SQL et les transformations dbt :

```text
ECOMMERCE_WH
```

### `03_create_roles.sql`

Création des rôles utilisés dans le projet afin de séparer les responsabilités :

```text
ECOMMERCE_ADMIN
ECOMMERCE_DBT
ECOMMERCE_BI
```

Chaque rôle correspond à un usage différent de la plateforme.

### `04_create_schemas.sql`

Création des différentes couches du Data Warehouse :

```text
ECOMMERCE_DWH
├── RAW
├── DWH
└── SEM
```

- **RAW** : données sources chargées dans Snowflake.
- **DWH** : données structurées et transformées avec dbt.
- **SEM** : couche de restitution destinée à Power BI.

### `05_grant_permissions.sql`

Attribution des permissions nécessaires aux différents rôles.

L'objectif est notamment de permettre à dbt de lire les données RAW et de construire les modèles DWH/SEM, tout en conservant un accès en lecture pour la partie BI.

---

## 📥 02_INGESTION

Le dossier `02_INGESTION` correspond à l'intégration initiale du dataset Superstore dans Snowflake.

### `01_create_raw_table.sql`

Création de la table source :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

La table reprend les données du dataset Superstore utilisées comme point de départ du projet.

### `02_load_raw.sql`

Chargement des données sources dans la table RAW.

Cette étape permet de faire entrer les données dans Snowflake avant leur transformation avec dbt.

Le principe est de conserver une couche RAW proche de la source afin de séparer clairement :

```text
Source
  ↓
RAW
  ↓
Transformations dbt
```

### `03_data_quality_checks.sql`

Ce script contient les premiers contrôles réalisés directement sur les données RAW afin de vérifier leur cohérence après l'ingestion.

Les contrôles portent notamment sur :

- le nombre de lignes ;
- le nombre de commandes ;
- le nombre de clients ;
- le nombre de produits ;
- la période couverte par les données ;
- le chiffre d'affaires et le bénéfice ;
- les valeurs NULL ;
- les quantités invalides ;
- les remises hors intervalle ;
- les ventes négatives.

Ces contrôles servent principalement à **valider la qualité de la source après ingestion**.

Les contrôles de qualité récurrents du projet sont ensuite centralisés dans dbt à travers les tests YAML et les tests métier personnalisés.

---

## 🔄 Place de la partie SQL dans l'architecture

Les scripts SQL permettent de préparer la plateforme et d'intégrer la donnée avant le traitement dbt.

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

La séparation des responsabilités est donc la suivante :

```text
SQL
→ Configuration, administration et ingestion initiale

dbt
→ Transformation, modélisation et Data Quality

Power BI
→ Analyse et restitution
```

---

## 🛠️ Technologies

- Snowflake
- SQL
- Git / GitHub
- dbt
- Power BI

---

## ✅ Résultat

À l'issue de cette étape, l'environnement Snowflake est initialisé et les données sources sont disponibles dans :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

La base est ensuite prête pour la transformation et la modélisation avec dbt.
