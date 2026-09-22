# 🛒 E-Commerce Dashboard — Power BI

## 📊 Présentation

Cette partie du projet est dédiée à l'analyse de la performance commerciale d'une entreprise e-commerce à travers un **dashboard Power BI interactif**.

L'objectif est de transformer les données préparées dans Snowflake et dbt en **indicateurs de pilotage et insights exploitables**, afin d'analyser les principaux leviers de chiffre d'affaires, de rentabilité et de performance commerciale.

Power BI intervient en fin de chaîne, après l'ingestion, la transformation, le nettoyage et la préparation des données dans Snowflake.

---

## 🎯 Problématique

L'analyse cherche notamment à répondre aux questions suivantes :

- Comment évolue le chiffre d'affaires dans le temps ?
- Quelles catégories génèrent le plus de revenus ?
- Quels produits sont les plus performants ?
- Quels segments clients contribuent le plus au chiffre d'affaires ?
- Quelles catégories présentent les meilleures marges ?
- Comment évoluent les principaux KPI par rapport à N-1 ?
- Quelles zones géographiques concentrent les meilleures performances ?
- Quels éléments nécessitent une analyse plus approfondie ?

L'objectif est de passer d'une simple visualisation des données à une **lecture structurée de la performance commerciale**.

---

## 🛠️ Technologies

- **Power BI**
- **DAX**
- **Power Query**
- **Snowflake**
- **dbt**
- **Modélisation dimensionnelle**
- **Star Schema**

---

## 🧱 Modélisation & Architecture

Le rapport repose sur une **architecture en étoile (Star Schema)** afin de structurer les données et de faciliter leur analyse dans Power BI.

La préparation des données est réalisée en amont dans Snowflake avec dbt, puis la couche `SEM` est utilisée comme source analytique pour Power BI.

![Modèle de données](Data_Model.PNG)

### 🔄 Flux de traitement

Les données suivent un flux structuré depuis leur source jusqu'à leur restitution :

```text
Superstore CSV
       ↓
Snowflake RAW
       ↓
dbt — Structuration & modélisation DWH
       ↓
Nettoyage & standardisation
       ↓
Snowflake SEM
       ↓
Power BI
       ↓
Modèle en étoile
       ↓
Mesures DAX
       ↓
Dashboard
       ↓
Analyse & Insights
```

Cette organisation permet de séparer clairement les différentes étapes :

- **Snowflake RAW** pour l'ingestion des données sources ;
- **dbt / DWH** pour la structuration et la modélisation ;
- **dbt / SEM** pour le nettoyage et la préparation finale des données ;
- **Power BI** pour le modèle analytique, les mesures et la restitution.

La logique de préparation des données est ainsi principalement gérée en amont, ce qui permet de garder Power BI centré sur l'analyse et la visualisation.

---

## 📈 Dashboard

![Dashboard](Dashboard.PNG)

Le dashboard permet d'explorer les performances commerciales à travers plusieurs axes d'analyse.

### Principaux indicateurs

- **Chiffre d'affaires**
- **Nombre de commandes**
- **Nombre de clients**
- **Panier moyen**
- **Marge %**
- **Évolution du CA vs N-1**
- **Performance des catégories**
- **Performance des produits**
- **Performance des segments clients**
- **Performance géographique**

Ces indicateurs sont combinés à différentes visualisations afin de faciliter l'identification des tendances, des évolutions et des écarts de performance.

---

## 🧮 DAX

Les principales mesures DAX utilisées dans le dashboard permettent de calculer les KPI commerciaux, les indicateurs de rentabilité et les évolutions temporelles.

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
```

Pour la comparaison avec N-1 :

```DAX
CA N1 =
CALCULATE(
    [CA],
    SAMEPERIODLASTYEAR(Calendrier[Date])
)
```

La documentation complète des mesures est disponible dans le dossier [**Mesures**](../Mesures/README_Mesures_DAX.md).

---

## 📂 Données

### Source

**Superstore Dataset — Kaggle**

[Voir le dataset sur Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

Le dataset contient notamment des informations relatives aux :

- commandes ;
- clients ;
- produits ;
- catégories ;
- sous-catégories ;
- ventes ;
- quantités ;
- remises ;
- bénéfices ;
- régions et zones géographiques ;
- modes d'expédition.

Dans l'architecture finale, le dataset est chargé dans Snowflake puis transformé avec dbt avant d'être consommé par Power BI.

---

## 💡 Insights

Le dashboard permet d'identifier les principales tendances et leviers de performance à travers l'analyse du chiffre d'affaires, de la rentabilité, des commandes et du comportement client.

Les principaux axes d'analyse portent notamment sur :

- **L'évolution des KPI** par rapport à l'année précédente ;
- **La performance commerciale** à travers le chiffre d'affaires et le bénéfice ;
- **Le comportement d'achat** à travers le panier moyen et le volume de commandes ;
- **La dynamique client** et la contribution des différents segments ;
- **La performance des catégories et produits** ;
- **Les écarts de performance entre les différentes zones géographiques** ;
- **L'identification des variations et points d'attention** nécessitant une analyse approfondie.

Les indicateurs et visualisations permettent ainsi de transformer les données en **insights exploitables pour orienter le pilotage de la performance commerciale**.

---

## 🧹 Préparation des données

Une partie importante de la préparation est réalisée avant l'arrivée des données dans Power BI.

Le flux repose sur :

```text
RAW
 ↓
DWH
 ↓
Nettoyage / standardisation
 ↓
SEM
 ↓
Power BI
```

Le nettoyage réalisé avec dbt comprend notamment :

- le nettoyage des champs texte avec `TRIM` ;
- la standardisation des types de données ;
- la conversion des dates ;
- la préparation des montants et décimales ;
- le filtrage de certaines valeurs vides ou invalides ;
- la préparation des colonnes nécessaires au modèle analytique.

Power Query peut ensuite être utilisé pour les ajustements nécessaires au chargement ou au modèle Power BI, sans déplacer toute la logique de transformation du projet dans le rapport.

---

## 📐 Documentation

Les principaux éléments techniques sont disponibles dans le repository :

- [📊 Modèle de données](Data_Model.PNG)
- [📈 Dashboard Power BI](Dashboard.PNG)
- [🧮 Mesures DAX](../Mesures/README_Mesures_DAX.md)
- [🔧 Projet dbt](../DBT/README.md)
- [🗄️ Scripts SQL Snowflake](../SQL/README.md)

---

## 🎯 Rôle de Power BI dans le projet

Power BI constitue la couche de **Business Intelligence et de restitution**.

La séparation des responsabilités est la suivante :

```text
Snowflake
→ stockage et exécution SQL

dbt
→ transformation, modélisation, nettoyage et Data Quality

Power BI
→ modèle analytique, DAX, visualisation et analyse
```

Le dashboard permet ainsi de valoriser les données préparées dans la plateforme Data et de les transformer en indicateurs facilement exploitables pour le pilotage de la performance commerciale.

---

## 👤 Auteur

**Ahmed Zouaghi**

Master 2 SIAD — Business Intelligence  
Université de Lille
