# 🛒 E-Commerce Data Platform — Snowflake, dbt & Power BI

Projet personnel réalisé pour mettre en pratique une **chaîne Data de bout en bout**, depuis l'ingestion de données commerciales jusqu'à leur analyse dans Power BI.

L'objectif est de construire une plateforme simple mais structurée, en séparant clairement les différentes étapes du traitement :

**ingestion → stockage → transformation → qualité des données → restitution BI**

Le projet s'appuie principalement sur **Snowflake, SQL, dbt et Power BI**, avec une organisation en couches `RAW`, `DWH` et `SEM`.

---

## 🎯 Objectif du projet

Au-delà de la création d'un dashboard, l'objectif est de reproduire les principales étapes d'un environnement Data moderne et de comprendre la place de chaque technologie dans la chaîne.

Le projet permet notamment de mettre en pratique :

* la création d'un environnement Snowflake ;
* l'ingestion de données dans une couche `RAW` ;
* la modélisation d'un Data Warehouse ;
* les transformations SQL avec dbt ;
* le nettoyage et la standardisation des données ;
* la mise en place de contrôles de Data Quality ;
* la création d'un modèle analytique dans Power BI ;
* la documentation et le versioning du projet avec Git/GitHub.

---

# 🏗️ Architecture globale

Le projet suit une architecture en plusieurs étapes :

```text
                 ┌──────────────────────┐
                 │    Superstore CSV    │
                 │       Source         │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │    Snowflake RAW     │
                 │                      │
                 │    RAW_SUPERSTORE    │
                 └──────────┬───────────┘
                            │
                            │ dbt
                            ▼
                 ┌──────────────────────┐
                 │    Snowflake DWH     │
                 │                      │
                 │ DIM_CUSTOMER_DWH     │
                 │ DIM_PRODUCT_DWH      │
                 │ DIM_LOCATION_DWH     │
                 │ DIM_SHIPPING_DWH     │
                 │ FACT_SALES_DWH       │
                 └──────────┬───────────┘
                            │
                            │ dbt
                            ▼
                 ┌──────────────────────┐
                 │ Nettoyage &          │
                 │ standardisation      │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │    Snowflake SEM     │
                 │                      │
                 │ DIM_CUSTOMER         │
                 │ DIM_PRODUCT          │
                 │ DIM_LOCATION         │
                 │ DIM_SHIPPING         │
                 │ FACT_SALES           │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │      Power BI        │
                 │                      │
                 │   Star Schema        │
                 │   DAX                │
                 │   Dashboard          │
                 └──────────────────────┘
```

La répartition des responsabilités est volontairement simple :

```text
SQL / Snowflake
→ infrastructure, accès et ingestion

dbt
→ transformation, modélisation, nettoyage et Data Quality

Power BI
→ modèle analytique, DAX, visualisation et analyse
```

Cette séparation permet de conserver une chaîne de traitement lisible et de limiter la dispersion des transformations entre les différents outils.

---

# ❄️ Snowflake

**Snowflake constitue la plateforme centrale de stockage et de calcul du projet.**

La base utilisée est :

```text
ECOMMERCE_DWH
```

Elle est organisée autour de trois couches :

```text
ECOMMERCE_DWH
│
├── RAW
│   └── RAW_SUPERSTORE
│
├── DWH
│   ├── DIM_CUSTOMER_DWH
│   ├── DIM_PRODUCT_DWH
│   ├── DIM_LOCATION_DWH
│   ├── DIM_SHIPPING_DWH
│   └── FACT_SALES_DWH
│
└── SEM
    ├── DIM_CUSTOMER
    ├── DIM_PRODUCT
    ├── DIM_LOCATION
    ├── DIM_SHIPPING
    └── FACT_SALES
```

### `RAW`

La couche `RAW` conserve les données sources après leur ingestion dans Snowflake.

### `DWH`

La couche `DWH` contient les données structurées et modélisées pour l'analyse.

### `SEM`

La couche `SEM` correspond à la couche analytique préparée pour la consommation BI.

Les scripts SQL utilisés pour créer l'environnement, gérer les rôles et permissions et charger les données sont documentés séparément.

👉 **[Voir la documentation SQL & Snowflake](SQL/README.md)**

---

# 🔧 dbt

**dbt constitue le cœur de la transformation du projet.**

Il prend les données présentes dans `RAW`, construit les modèles du Data Warehouse puis prépare la couche `SEM`.

```text
RAW
 ↓
DWH
 ↓
Nettoyage / standardisation
 ↓
SEM
```

### Modélisation

Les modèles DWH permettent notamment de structurer :

* les clients ;
* les produits ;
* la géographie ;
* les modes de livraison ;
* les ventes.

Une attention particulière est portée à la déduplication des dimensions et à la cohérence entre la table de faits et les dimensions.

### Nettoyage

La préparation de la couche `SEM` comprend notamment :

* nettoyage des champs textuels ;
* conversion des dates ;
* standardisation des types ;
* gestion de la précision des montants ;
* filtrage de certaines valeurs invalides ;
* préparation des colonnes nécessaires à la couche BI.

### Data Quality

La qualité des données est intégrée directement dans dbt grâce à des tests standards et des règles métier personnalisées.

Les tests couvrent notamment :

* la complétude ;
* l'unicité ;
* les relations entre les tables ;
* la cohérence des quantités ;
* la validité des remises ;
* la cohérence des montants et des dates.

👉 **[Voir la documentation complète du projet dbt](DBT/README.md)**

---

# 📊 Power BI

**Power BI constitue la couche de restitution et d'analyse du projet.**

Le rapport exploite les données préparées dans la couche `SEM` et repose sur une **modélisation en étoile (Star Schema)**.

![Dashboard](Power%20BI/Dashboard.PNG)

Le rapport permet d'explorer la performance commerciale selon plusieurs dimensions :

* temps ;
* produits ;
* catégories ;
* clients ;
* segments ;
* géographie ;
* commandes ;
* rentabilité.

L'objectif est de fournir une lecture interactive de la donnée et de faciliter l'identification des tendances, variations et points d'attention.

![Modèle de données](Power%20BI/Data_Model.PNG)

La documentation détaillée du rapport Power BI est disponible ici :

👉 **[Voir la documentation Power BI](Power%20BI/README.md)**

---

# 🧮 Mesures DAX

Les indicateurs utilisés dans le rapport sont calculés avec **DAX**.

Les mesures couvrent notamment les besoins liés à :

* la performance commerciale ;
* la rentabilité ;
* le suivi des commandes et des clients ;
* les analyses temporelles ;
* les comparaisons avec la période précédente.

Afin d'éviter de dupliquer la documentation, les mesures sont regroupées dans une documentation dédiée.

👉 **[Voir la documentation complète des mesures DAX](Mesures/README_Mesures_DAX.md)**

---

# 📂 Données

Le projet utilise le dataset **Superstore** comme source initiale.

**Source :** Superstore Dataset — Kaggle

👉 [Voir le dataset sur Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

Le dataset contient notamment des informations relatives :

* aux commandes ;
* aux clients ;
* aux produits ;
* aux catégories et sous-catégories ;
* aux ventes ;
* aux quantités ;
* aux remises ;
* aux bénéfices ;
* à la localisation ;
* aux modes d'expédition.

La donnée suit ensuite le parcours :

```text
CSV
 ↓
RAW
 ↓
DWH
 ↓
SEM
 ↓
Power BI
```

---

# ✅ Data Quality

La qualité des données est intégrée dans la chaîne de transformation plutôt que traitée uniquement à la fin du projet.

Les contrôles sont principalement réalisés dans dbt à travers :

```text
                    dbt
                     │
          ┌──────────┴──────────┐
          │                     │
   Tests standards        Tests métier
          │                     │
      not_null             quantity_positive
      unique               discount_valid
      relationships        sales_positive
                           ship_date_after_order_date
```

Les tests sont déclarés dans les fichiers YAML et peuvent être exécutés avec :

```bash
dbt test --target dev
```

Cette organisation permet de vérifier les règles de qualité avant la consommation des données dans la couche analytique.

---

# 📁 Structure du repository

```text
Ecommerce_Data_Platform_Snowflake_dbt_PowerBi/
│
├── README.md
│
├── SQL/
│   ├── 01_SETUP/
│   ├── 02_INGESTION/
│   └── README.md
│
├── DBT/
│   ├── macros/
│   ├── models/
│   │   ├── DWH/
│   │   ├── SEM/
│   │   └── sources.yml
│   ├── dbt_project.yml
│   ├── packages.yml
│   ├── profiles.yml
│   └── README.md
│
├── Power BI/
│   ├── Dashboard.PNG
│   ├── Data_Model.PNG
│   └── README.md
│
├── Mesures/
│   ├── README_Mesures_DAX.md
│   └── README.md
│
├── Screenshots/
│   └── README.md
│
└── README.md
```

---

# 🧭 Documentation du projet

Ce README présente la vision globale de la plateforme. Chaque composant possède ensuite sa propre documentation technique.

| Partie              | Documentation                                                  |
| ------------------- | -------------------------------------------------------------- |
| 🗄️ SQL / Snowflake | [SQL/README.md](SQL/README.md)                                 |
| 🔧 dbt              | [DBT/README.md](DBT/README.md)                                 |
| 📊 Power BI         | [Power BI/README.md](Power%20BI/README.md)                     |
| 🧮 Mesures DAX      | [Mesures/README_Mesures_DAX.md](Mesures/README_Mesures_DAX.md) |
| 📸 Screenshots      | [Screenshots/README.md](Screenshots/README.md)                 |

---

# 🛠️ Technologies utilisées

### Data Platform

* **Snowflake**
* **SQL**

### Transformation

* **dbt**
* **Jinja**

### Data Quality

* **dbt Tests**
* Tests génériques
* Tests métier

### Business Intelligence

* **Power BI**
* **DAX**
* **Power Query**
* **Star Schema**

### Versioning

* **Git**
* **GitHub**

---

# 🎓 Compétences mises en pratique

Ce projet permet de mettre en pratique plusieurs compétences autour de la Data et de la Business Intelligence :

* conception d'une architecture Data Warehouse ;
* modélisation dimensionnelle ;
* développement SQL ;
* utilisation de Snowflake ;
* transformation ELT avec dbt ;
* nettoyage et standardisation des données ;
* mise en place de tests de qualité ;
* gestion des dépendances entre modèles ;
* développement de mesures DAX ;
* conception d'un dashboard Power BI ;
* documentation et organisation d'un projet Data avec Git/GitHub.

---

# 🚀 Ce que ce projet illustre

À travers ce projet, l'objectif est surtout de montrer la capacité à **comprendre une chaîne Data dans son ensemble**, et pas uniquement à utiliser un outil isolé.

```text
Source
  ↓
Ingestion
  ↓
Stockage
  ↓
Transformation
  ↓
Data Quality
  ↓
Modélisation
  ↓
Business Intelligence
```

Chaque technologie intervient à une étape précise du processus, avec une séparation claire entre la préparation de la donnée et sa restitution.

---

# 👤 Auteur

**Ahmed Zouaghi**

Master 2 SIAD — Business Intelligence
Université de Lille

🔗 [GitHub](https://github.com/AhmedZouaghi59)
