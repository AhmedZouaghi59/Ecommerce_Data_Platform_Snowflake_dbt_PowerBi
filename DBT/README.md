# 🔧 DBT — Transformation & Data Quality

Le dossier `DBT` contient le projet **dbt** utilisé pour transformer les données du projet E-Commerce dans Snowflake.

dbt intervient après l'ingestion des données dans la couche `RAW`. Les données sont ensuite structurées dans la couche `DWH`, puis font l'objet d'une **phase de nettoyage et de préparation** avant d'être exposées dans la couche `SEM` et consommées par Power BI.

L'objectif est de centraliser dans dbt la logique de **transformation, de nettoyage, de modélisation et de Data Quality**, tout en gardant les différentes étapes clairement séparées.

## 📂 Organisation

```text
DBT/
│
├── macros/
│   └── ...
│
├── models/
│   ├── DWH/
│   │   ├── ...
│   │   └── schema.yml
│   │
│   ├── SEM/
│   │   └── ...
│   │
│   └── sources.yml
│
├── dbt_project.yml
├── packages.yml
└── profiles.yml
```

## 🔄 Flux de transformation

Le projet suit une architecture en plusieurs étapes :

```text
Snowflake RAW
      │
      │ source()
      ▼
     DWH
      │
      │ Nettoyage / préparation
      ▼
     SEM
      │
      ▼
   Power BI
```

La couche `RAW` contient les données sources. dbt les référence avec `source()` et construit ensuite les modèles du DWH.

La couche `DWH` permet de structurer les données et de construire les différentes dimensions ainsi que la table de faits.

Entre le `DWH` et le `SEM`, une étape importante de **nettoyage et de préparation des données** est réalisée. Cette phase permet de préparer une donnée propre et homogène avant sa consommation par Power BI.

---

## 🏗️ Modèles DWH

Le dossier `models/DWH` contient les modèles qui construisent le Data Warehouse.

La couche DWH comprend notamment :

- `dim_customer_dwh` : dimension clients ;
- `dim_product_dwh` : dimension produits ;
- `dim_location_dwh` : dimension géographique ;
- `dim_shipping_dwh` : dimension des modes de livraison ;
- `fact_sales_dwh` : table de faits des ventes.

Les transformations réalisées à ce niveau permettent notamment de :

- sélectionner les données nécessaires à l'analyse ;
- structurer les dimensions et la table de faits ;
- dédupliquer certaines dimensions ;
- préparer les relations entre les faits et les dimensions ;
- construire une base cohérente pour la couche analytique.

Par exemple, la dimension produit est dédupliquée au niveau du `Product ID` afin d'éviter les doublons lors des relations avec la table de faits.

Le fichier `schema.yml` contient les tests de qualité appliqués aux modèles DWH.

---

## 🧹 Nettoyage & préparation entre DWH et SEM

Avant d'alimenter la couche `SEM`, les données passent par une **phase de nettoyage et de standardisation**.

Cette étape est importante car le DWH sert principalement à structurer et modéliser les données, tandis que la couche SEM doit fournir une donnée directement exploitable par l'outil BI.

Les transformations réalisées dans cette phase comprennent notamment :

- suppression des espaces inutiles dans les identifiants et les champs texte avec `TRIM` ;
- nettoyage des valeurs textuelles ;
- conversion des dates dans un type `DATE` ;
- conversion des valeurs numériques dans des types adaptés ;
- gestion cohérente des décimales pour les montants ;
- standardisation des noms de colonnes attendus par Power BI ;
- filtrage des valeurs vides ou invalides sur certaines dimensions ;
- préparation d'une structure stable pour la restitution.

Par exemple, dans la table de faits SEM :

```sql
CAST(order_date AS DATE) AS "Order Date"
```

permet de garantir un type date adapté à l'analyse temporelle.

Les identifiants et champs textuels sont également nettoyés :

```sql
TRIM(customer_id) AS "Customer ID"
```

et les montants sont convertis avec une précision suffisante :

```sql
CAST(sales AS NUMBER(18,4)) AS "Sales"
```

Cette approche permet de conserver la précision des données dans Snowflake tout en laissant Power BI gérer leur formatage pour la restitution.

Le flux complet devient donc :

```text
RAW
 ↓
Structuration / modélisation
 ↓
DWH
 ↓
Nettoyage / standardisation
 ↓
SEM
 ↓
Power BI
```

---

## 📊 Modèles SEM

Le dossier `models/SEM` correspond à la couche de restitution.

Les modèles SEM reprennent les données préparées dans le DWH puis appliquent les dernières transformations nécessaires avant leur utilisation dans Power BI.

On y retrouve notamment :

- `dim_customer.sql`
- `dim_product.sql`
- `dim_location.sql`
- `dim_shipping.sql`
- `fact_sales.sql`

La couche SEM sert donc de **couche analytique finale**, avec des données :

- nettoyées ;
- standardisées ;
- correctement typées ;
- adaptées à la consommation BI.

L'objectif est de fournir à Power BI une source stable et directement exploitable sans déplacer toute la logique de préparation dans Power Query.

---

## 🔗 Sources

Le fichier :

```text
models/sources.yml
```

déclare la source RAW utilisée par dbt.

La source principale du projet est :

```text
ECOMMERCE_DWH.RAW.RAW_SUPERSTORE
```

Elle est appelée dans les modèles avec :

```sql
{{ source('raw', 'raw_superstore') }}
```

Les dépendances entre les différents modèles sont ensuite gérées avec :

```sql
{{ ref('nom_du_modele') }}
```

Cela permet à dbt de comprendre automatiquement l'ordre des transformations et de construire le graphe de dépendances du projet.

---

## ✅ Data Quality

La qualité des données est gérée directement dans dbt.

Les tests sont déclarés dans les fichiers YAML et couvrent notamment :

- `not_null` pour contrôler la complétude ;
- `unique` pour contrôler l'unicité ;
- `relationships` pour contrôler l'intégrité référentielle.

Des règles métier personnalisées sont également utilisées pour contrôler certaines valeurs :

- quantité strictement positive ;
- remise comprise entre 0 et 1 ;
- ventes non négatives ;
- cohérence entre date de commande et date d'expédition.

Le principe est de déclarer le contrôle dans le YAML et de laisser les macros définir la logique des tests personnalisés.

```text
YAML
 ↓
Déclaration du test
 ↓
Macro
 ↓
Requête SQL de contrôle
 ↓
dbt test
```

Les tests sont exécutés avec :

```bash
dbt test --target dev
```

Les tests permettent ainsi de vérifier la qualité des données avant leur utilisation dans la couche analytique.

---

## 🧩 Macros

Le dossier `macros` contient les règles réutilisables du projet.

Il comprend notamment :

- la macro `generate_schema_name.sql`, utilisée pour gérer les schémas `DWH` et `SEM` ;
- les tests métier personnalisés utilisés depuis les fichiers YAML.

Les macros permettent de centraliser les règles et de les réutiliser sans dupliquer le SQL.

---

## ⚙️ Fichiers de configuration

### `dbt_project.yml`

Contient la configuration principale du projet :

- nom du projet ;
- chemins utilisés par dbt ;
- configuration des modèles ;
- matérialisation des différentes couches.

### `packages.yml`

Permet de gérer les éventuelles dépendances externes du projet dbt.

### `profiles.yml`

Contient la configuration utilisée par dbt pour accéder à Snowflake.

Le projet utilise notamment :

```text
Role      : ECOMMERCE_DBT
Warehouse : ECOMMERCE_WH
Database  : ECOMMERCE_DWH
```

---

## 🚀 Exécution

Les principales commandes utilisées sont :

### Vérifier la configuration

```bash
dbt debug --target dev
```

### Construire les modèles

```bash
dbt run --target dev
```

### Exécuter les tests

```bash
dbt test --target dev
```

Le cycle principal est donc :

```text
dbt debug
    ↓
dbt run
    ↓
dbt test
```

---

## 🎯 Rôle de dbt dans le projet

dbt constitue le cœur de la transformation entre Snowflake RAW et la couche analytique.

```text
Snowflake RAW
      ↓
     DBT
      │
      ├── Structuration
      ├── Modélisation DWH
      ├── Nettoyage
      ├── Standardisation
      ├── Dépendances
      └── Data Quality
      ↓
Snowflake DWH
      ↓
Nettoyage / préparation SEM
      ↓
Snowflake SEM
      ↓
Power BI
```

Cette organisation permet de garder une logique de transformation claire, versionnée et maintenable, tout en séparant les données brutes, le Data Warehouse, la phase de nettoyage et la couche de restitution.

## 🛠️ Technologies

- dbt
- Snowflake
- SQL
- Jinja
- Git / GitHub
