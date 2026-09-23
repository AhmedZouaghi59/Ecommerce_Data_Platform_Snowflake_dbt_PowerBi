# 🔧 DBT — Transformation & Data Quality

Le dossier `DBT` contient le projet **dbt** utilisé pour transformer et préparer les données du projet E-Commerce dans **Snowflake**.

Après leur ingestion dans la couche `RAW`, les données sont structurées dans le **Data Warehouse (`DWH`)**, puis nettoyées et préparées dans une couche **Semantic (`SEM`)** avant d'être consommées par **Power BI**.

L'objectif est de centraliser dans dbt les principales transformations SQL, la modélisation des données et les contrôles de qualité, tout en séparant clairement les différentes étapes du traitement.

---

## 📂 Organisation du projet

```text
DBT/
│
├── macros/
│   └── ...
│
├── models/
│   ├── DWH/
│   │   └── ...
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

---

## 🔄 Architecture de transformation

Le flux de données suit une architecture simple en plusieurs couches :

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

### RAW

La couche `RAW` contient les données sources après leur ingestion dans Snowflake (via upload local).

Elle constitue le point de départ des transformations dbt.

### DWH

La couche `DWH` permet de structurer les données pour l'analyse en construisant les différentes dimensions et la table de faits.

### SEM

La couche `SEM` correspond à la couche analytique finale. Les données y sont nettoyées, standardisées et préparées pour être directement exploitées dans Power BI.

---

# 🏗️ Modélisation du Data Warehouse

Le dossier `models/DWH` contient les modèles utilisés pour construire le Data Warehouse.

Les principaux modèles sont :

* `dim_customer_dwh` : dimension clients ;
* `dim_product_dwh` : dimension produits ;
* `dim_location_dwh` : dimension géographique ;
* `dim_shipping_dwh` : dimension des modes de livraison ;
* `fact_sales_dwh` : table de faits des ventes.

Les transformations réalisées à ce niveau permettent notamment de :

* sélectionner les données nécessaires à l'analyse ;
* structurer les dimensions et la table de faits ;
* dédupliquer certaines dimensions ;
* préparer les relations entre les faits et les dimensions ;
* construire une base cohérente pour la couche analytique.

Par exemple, la dimension produit est dédupliquée à partir du `Product ID` afin d'éviter plusieurs occurrences d'un même produit dans le modèle.

Le fichier `schema.yml` contient les principaux tests de qualité appliqués aux modèles DWH.

---

# 🧹 Nettoyage et préparation des données

Une phase de nettoyage et de standardisation est réalisée avant l'alimentation de la couche `SEM`.

Cette étape permet de fournir à Power BI des données plus propres, homogènes et adaptées à l'analyse.

Les transformations comprennent notamment :

* suppression des espaces inutiles avec `TRIM` ;
* nettoyage des valeurs textuelles ;
* conversion des dates dans un type `DATE` ;
* conversion des valeurs numériques dans des types adaptés ;
* gestion de la précision des montants ;
* standardisation des noms de colonnes ;
* filtrage de certaines valeurs vides ou invalides.

### Exemple : conversion des dates

```sql
CAST(order_date AS DATE) AS "Order Date"
```

Cette transformation permet de garantir un type adapté aux analyses temporelles.

### Exemple : nettoyage d'un identifiant

```sql
TRIM(customer_id) AS "Customer ID"
```

Les espaces inutiles sont supprimés afin d'éviter des incohérences lors des jointures ou des contrôles.

### Exemple : gestion des montants

```sql
CAST(sales AS NUMBER(18,4)) AS "Sales"
```

La valeur est conservée avec une précision suffisante dans Snowflake. Le format d'affichage est ensuite géré au niveau de Power BI.

Le flux global est donc :

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

# 📊 Couche SEM

Le dossier `models/SEM` correspond à la couche analytique utilisée pour la restitution.

Les modèles SEM reprennent les données préparées dans le DWH et appliquent les dernières transformations nécessaires avant leur utilisation dans Power BI.

Les principaux modèles sont :

* `dim_customer.sql`
* `dim_product.sql`
* `dim_location.sql`
* `dim_shipping.sql`
* `fact_sales.sql`

La couche SEM fournit ainsi des données :

* nettoyées ;
* standardisées ;
* correctement typées ;
* adaptées à la consommation BI.

L'intérêt est de conserver une séparation claire entre la **modélisation du Data Warehouse** et la **préparation des données pour la restitution**.

Cela permet également de limiter la quantité de logique de transformation directement implémentée dans Power Query.

---

# ✅ Data Quality

La qualité des données est contrôlée directement dans dbt grâce aux tests déclarés dans les fichiers YAML.

Les principaux tests utilisés sont :

* `not_null` : vérifier qu'une colonne obligatoire n'est pas vide ;
* `unique` : contrôler l'unicité d'une valeur ;
* `relationships` : vérifier les relations entre les tables.

Des contrôles métier personnalisés sont également utilisés pour certaines règles :

* quantité strictement positive ;
* remise comprise entre `0` et `1` ;
* ventes non négatives ;
* cohérence entre date de commande et date d'expédition.

Le principe est de déclarer les contrôles dans les fichiers YAML et de centraliser leur logique dans des macros lorsque cela est nécessaire.

```text
YAML
 ↓
Définition du test
 ↓
Macro / logique SQL
 ↓
Contrôle des données
 ↓
dbt test
```

Les tests sont exécutés avec :

```bash
dbt test --target dev
```

Cette approche permet de vérifier les principales règles de qualité avant d'utiliser les données dans la couche analytique.

---

# 🧩 Macros

Le dossier `macros` contient les fonctions et règles réutilisables du projet.

Il comprend notamment :

### `generate_schema_name.sql`

Cette macro permet de gérer la génération des schémas utilisés par les modèles `DWH` et `SEM`.

### Tests métier personnalisés

Certaines règles de qualité qui ne sont pas couvertes par les tests standards de dbt sont également définies sous forme de macros.

L'intérêt est de centraliser ces règles afin de pouvoir les réutiliser sans dupliquer la logique SQL.

---

# ⚙️ Configuration du projet

### `dbt_project.yml`

Le fichier contient la configuration principale du projet :

* nom du projet ;
* chemins utilisés par dbt ;
* configuration des modèles ;
* organisation des différentes couches ;
* matérialisation des modèles.

### `packages.yml`

Ce fichier permet de gérer les éventuelles dépendances externes du projet dbt.

### `profiles.yml`

Il contient la configuration permettant à dbt de se connecter à Snowflake.

L'environnement utilisé dans le projet comprend notamment :

```text
Role      : ECOMMERCE_DBT
Warehouse : ECOMMERCE_WH
Database  : ECOMMERCE_DWH
```

---

# 🚀 Exécution du projet

Les principales commandes utilisées sont :

### Vérifier la connexion et la configuration

```bash
dbt debug --target dev
```

### Construire les modèles

```bash
dbt run --target dev
```

### Exécuter les tests de qualité

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

# 🎯 Rôle de dbt dans le projet

Dans ce projet, **dbt constitue la couche de transformation et de modélisation entre Snowflake RAW et la couche analytique**.

Il permet de centraliser :

```text
Snowflake RAW
      ↓
     DBT
      │
      ├── Sources
      ├── Transformations SQL
      ├── Modélisation DWH
      ├── Nettoyage
      ├── Standardisation
      ├── Gestion des dépendances
      └── Data Quality
      ↓
Snowflake DWH
      ↓
Snowflake SEM
      ↓
Power BI
```

Cette organisation permet de garder une chaîne de transformation claire et maintenable, tout en séparant les données sources, la modélisation du Data Warehouse et la préparation des données pour la BI.

Le projet met ainsi en pratique une approche **ELT avec Snowflake et dbt**, où les transformations sont réalisées directement dans l'entrepôt de données avant la restitution dans Power BI.
