# 🗄️ SQL — Snowflake

Ce dossier regroupe les scripts SQL utilisés pour mettre en place et administrer l’environnement Snowflake du projet E-Commerce Data Platform.

L’objectif est de séparer clairement la partie **configuration et administration de Snowflake** des transformations de données réalisées ensuite avec dbt.

## 📂 Organisation

```text
SQL/
├── 01_setup.sql
├── 02_roles.sql
├── 03_schemas.sql
├── 04_permissions.sql
├── 05_access.sql
└── 06_raw_ingestion.sql
```

### `01_setup.sql`

Préparation de l’environnement Snowflake nécessaire au projet.

Cette étape concerne notamment la mise en place de la base de données et du warehouse utilisés par la plateforme.

```text
Database  : ECOMMERCE_DWH
Warehouse : ECOMMERCE_WH
```

### `02_roles.sql`

Création des rôles utilisés dans le projet afin de séparer les responsabilités :

```text
ECOMMERCE_ADMIN
ECOMMERCE_DBT
ECOMMERCE_BI
```

Chaque rôle dispose ensuite de droits adaptés à son usage.

### `03_schemas.sql`

Création des différentes couches de données dans `ECOMMERCE_DWH` :

```text
ECOMMERCE_DWH
├── RAW
├── DWH
└── SEM
```

- **RAW** : données sources chargées dans Snowflake.
- **DWH** : données structurées et transformées avec dbt.
- **SEM** : couche de restitution destinée à Power BI.

### `04_permissions.sql`

Mise en place des permissions nécessaires sur la base, le warehouse et les différents schémas.

L’objectif est de conserver une séparation claire entre les usages :

```text
ECOMMERCE_DBT
→ lecture de RAW
→ transformation de DWH
→ transformation de SEM

ECOMMERCE_BI
→ lecture de SEM
```

Les droits nécessaires aux futurs objets sont également prévus afin de limiter les attributions manuelles.

### `05_access.sql`

Attribution des rôles aux utilisateurs et vérification des accès.

Cette étape permet notamment de s’assurer que les utilisateurs disposent du niveau de permission correspondant à leur rôle.

### `06_raw_ingestion.sql`

Préparation et contrôle de la couche RAW.

La source utilisée dans le projet est le dataset **Superstore**, chargé dans :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

La couche RAW reste volontairement proche des données sources. Les transformations et la modélisation sont ensuite prises en charge par dbt.

## 🔄 Place du dossier SQL dans le projet

Les scripts SQL correspondent à la partie **configuration et administration de Snowflake**.

La chaîne globale du projet est :

```text
Superstore CSV
      ↓
Snowflake RAW
      ↓
dbt
      ↓
Snowflake DWH
      ↓
dbt
      ↓
Snowflake SEM
      ↓
Power BI
```

La séparation des responsabilités est donc :

```text
SQL
→ Configuration, administration et accès Snowflake

dbt
→ Transformation, modélisation et Data Quality

Power BI
→ Analyse, KPI et restitution
```

Cette organisation permet de garder le projet lisible et de distinguer les opérations d’administration des traitements de données.

## 🛠️ Technologies

- Snowflake
- SQL
- Git / GitHub
- dbt

## ✅ Résultat

À l’issue de cette étape, l’environnement Snowflake est prêt pour les transformations dbt :

```text
ECOMMERCE_DWH
├── RAW
│   └── RAW_SUPERSTORE
├── DWH
└── SEM
```

Les rôles et permissions nécessaires sont également en place pour permettre la suite du traitement.
