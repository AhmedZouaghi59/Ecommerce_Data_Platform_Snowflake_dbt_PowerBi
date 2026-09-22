# 🛒 E-Commerce Data Platform — Snowflake, dbt & Power BI

## 📊 Présentation

Ce projet personnel consiste à construire une chaîne complète de traitement et d'analyse de données commerciales, depuis l'ingestion d'un dataset e-commerce jusqu'à sa restitution dans Power BI.

L'objectif n'est pas uniquement de construire un dashboard, mais de mettre en place une **véritable chaîne Data structurée**, avec une séparation claire entre l'ingestion, le stockage, la transformation, la qualité des données et la restitution BI.

Le projet s'appuie sur **Snowflake, SQL, dbt et Power BI**, avec une architecture organisée autour des couches `RAW`, `DWH` et `SEM`.

```text
Superstore CSV
      ↓
Snowflake RAW
      ↓
dbt — Structuration
      ↓
Snowflake DWH
      ↓
dbt — Nettoyage & standardisation
      ↓
Snowflake SEM
      ↓
Power BI
      ↓
KPI & Business Analytics
```

---

## 🎯 Objectifs du projet

Le projet répond à deux objectifs complémentaires.

### Côté Data

Mettre en place une architecture permettant de :

- centraliser les données dans Snowflake ;
- séparer les données brutes des données transformées ;
- construire un Data Warehouse structuré ;
- nettoyer et standardiser les données avant leur consommation ;
- appliquer des contrôles de qualité avec dbt ;
- versionner l'ensemble du projet avec Git et GitHub.

### Côté Business Intelligence

Transformer les données préparées en indicateurs permettant d'analyser :

- le chiffre d'affaires ;
- la rentabilité ;
- les commandes ;
- les clients ;
- les produits et catégories ;
- les segments clients ;
- les performances géographiques ;
- l'évolution des KPI dans le temps ;
- les écarts par rapport à N-1.

---

# 🏗️ Architecture globale

L'architecture du projet repose sur une séparation claire des responsabilités.

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
                         │ Star Schema          │
                         │ DAX                  │
                         │ Dashboard            │
                         └──────────────────────┘
```

La logique de préparation est donc volontairement séparée de la restitution :

```text
SQL / Snowflake
→ infrastructure, accès et ingestion

dbt
→ transformation, modélisation, nettoyage et Data Quality

Power BI
→ modèle analytique, DAX, visualisation et analyse
```

---

# ❄️ Snowflake

Snowflake constitue la plateforme centrale du projet.

La base utilisée est :

```text
ECOMMERCE_DWH
```

avec les principales couches :

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

La couche `RAW` conserve les données sources, la couche `DWH` porte la modélisation structurée et la couche `SEM` prépare les données pour la consommation BI.

Les scripts de configuration, de gestion des rôles, de permissions et d'ingestion sont documentés séparément.

👉 **[Voir la documentation SQL & Snowflake](SQL/README.md)**

---

# 🔧 dbt

dbt constitue le cœur de la transformation du projet.

Il prend les données de la couche `RAW`, construit le Data Warehouse puis prépare la couche `SEM`.

```text
RAW
 ↓
DWH
 ↓
Nettoyage / standardisation
 ↓
SEM
```

### DWH

Les modèles DWH structurent notamment :

- les clients ;
- les produits ;
- la géographie ;
- les modes de livraison ;
- les ventes.

Une attention particulière est portée à la déduplication des dimensions et à la cohérence des relations entre la table de faits et les dimensions.

### Nettoyage et standardisation

Entre le DWH et la SEM, une phase dédiée permet de préparer les données finales pour Power BI.

Elle comprend notamment :

- `TRIM` des champs textuels ;
- conversion des dates ;
- standardisation des types ;
- gestion de la précision des montants ;
- filtrage des valeurs vides ou invalides ;
- préparation des noms de colonnes attendus par la couche BI.

### Data Quality

La qualité des données est directement gérée avec dbt grâce à :

- `not_null` ;
- `unique` ;
- `relationships` ;
- tests métier personnalisés.

Ces tests couvrent notamment les quantités, les remises, les ventes et la cohérence des dates.

👉 **[Voir la documentation complète du projet dbt](DBT/README.md)**

---

# 📊 Power BI

Power BI constitue la couche de restitution du projet.

Le rapport exploite la couche `SEM` de Snowflake et repose sur un modèle en étoile permettant d'analyser la performance commerciale.

Les principaux KPI sont :

- **Chiffre d'affaires**
- **Bénéfice**
- **Marge %**
- **Nombre de commandes**
- **Nombre de clients**
- **Panier moyen**
- **Évolution du CA vs N-1**
- **Performance des catégories et produits**
- **Performance des segments clients**
- **Performance géographique**

Le dashboard cherche à répondre à des questions concrètes :

- Comment évolue le chiffre d'affaires dans le temps ?
- Quelles catégories génèrent le plus de revenus ?
- Quels produits contribuent le plus à la performance ?
- Quels segments clients représentent la plus grande contribution ?
- Quelles zones géographiques présentent les plus fortes performances ?
- Comment les KPI évoluent-ils par rapport à N-1 ?

👉 **[Voir la documentation Power BI](Power%20BI/README.md)**

---

# 🧮 DAX

Les indicateurs analytiques sont calculés avec DAX dans Power BI.

Quelques exemples :

```DAX
CA = SUM(Fact_Sales[Sales])

Nb de clients =
DISTINCTCOUNT(Fact_Sales[Customer ID])

Nb de commandes =
DISTINCTCOUNT(Fact_Sales[Order ID])

Bénéfice =
SUM(Fact_Sales[Profit])

Marge % =
DIVIDE([Bénéfice], [CA])

Panier moyen =
DIVIDE([CA], [Nb de commandes])

CA N1 =
CALCULATE(
    [CA],
    SAMEPERIODLASTYEAR(Calendrier[Date])
)
```

La dimension calendrier est conservée dans Power BI afin de gérer les analyses temporelles et les mesures associées.

👉 **[Voir la documentation des mesures DAX](Mesures/README_Mesures_DAX.md)**

---

# 📂 Données

Le projet utilise le dataset **Superstore** comme source initiale.

**Source :** Superstore Dataset — Kaggle

[Voir le dataset sur Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

Le dataset contient notamment des informations sur :

- les commandes ;
- les clients ;
- les produits ;
- les catégories et sous-catégories ;
- les ventes ;
- les quantités ;
- les remises ;
- les bénéfices ;
- la localisation ;
- les modes d'expédition.

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

La qualité n'est pas traitée comme une étape isolée : elle est intégrée directement au développement dbt.

Le projet utilise :

```text
                    dbt
                     │
          ┌──────────┴──────────┐
          │                     │
     Tests standards       Tests métier
          │                     │
      not_null              quantity_positive
      unique                discount_valid
      relationships         sales_positive
                            ship_date_after_order_date
```

Les tests sont déclarés dans les fichiers YAML et exécutés avec :

```bash
dbt test --target dev
```

Le principe est simple : le test retourne les lignes qui ne respectent pas la règle définie. S'il ne retourne aucune ligne non conforme, le test passe.

---

# 📈 Dashboard

![Dashboard](Power%20BI/Dashboard.PNG)

Le rapport permet d'explorer les performances commerciales selon plusieurs dimensions : temps, produits, clients, segments et géographie.

![Modèle de données](Power%20BI/Data_Model.PNG)

Le modèle analytique s'appuie sur une architecture en étoile afin de faciliter les analyses et les calculs DAX.

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

Le README principal donne une vue d'ensemble de la plateforme. Chaque partie possède ensuite sa propre documentation pour aller plus loin.

| Partie | Documentation |
|---|---|
| 🗄️ SQL / Snowflake | [SQL/README.md](SQL/README.md) |
| 🔧 DBT | [DBT/README.md](DBT/README.md) |
| 📊 Power BI | [Power BI/README.md](Power%20BI/README.md) |
| 🧮 Mesures DAX | [Mesures/README_Mesures_DAX.md](Mesures/README_Mesures_DAX.md) |
| 📸 Screenshots | [Screenshots/README.md](Screenshots/README.md) |

---

# 🛠️ Technologies utilisées

### Data Platform

- **Snowflake**
- SQL

### Transformation

- **dbt**
- Jinja

### Data Quality

- dbt Tests
- Tests génériques
- Tests métier

### Business Intelligence

- **Power BI**
- DAX
- Power Query
- Star Schema

### Versioning

- Git
- GitHub

---

# 🎓 Compétences mises en pratique

Ce projet permet de mettre en pratique plusieurs aspects d'un environnement Data moderne :

- conception d'une architecture Data Warehouse ;
- modélisation dimensionnelle ;
- développement SQL ;
- utilisation de Snowflake ;
- transformation ELT avec dbt ;
- nettoyage et standardisation des données ;
- mise en place de tests de qualité ;
- gestion des dépendances entre modèles ;
- conception de KPI avec DAX ;
- création d'un dashboard Power BI ;
- organisation et documentation d'un projet Data avec Git/GitHub.

---

# 👤 Auteur

**Ahmed Zouaghi**

Master 2 SIAD — Business Intelligence  
Université de Lille

🔗 [GitHub](https://github.com/AhmedZouaghi59)
```
