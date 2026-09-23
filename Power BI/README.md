# 🛒 E-Commerce Dashboard — Power BI

## 📊 Présentation

Cette partie du projet est consacrée à l'analyse de la performance commerciale d'une entreprise e-commerce à travers un **dashboard Power BI interactif**.

L'objectif est de transformer les données préparées dans **Snowflake et dbt** en une restitution claire et exploitable, permettant d'explorer les évolutions commerciales, les performances produits et clients ainsi que les différences entre les zones géographiques.

Power BI intervient en fin de chaîne, après l'ingestion, la transformation, la modélisation et la préparation des données dans Snowflake.

L'enjeu est donc de passer d'une donnée préparée techniquement à une **analyse accessible et orientée métier**.

---

## 🎯 Problématique

Le rapport a été conçu pour permettre d'explorer plusieurs dimensions de la performance commerciale :

* Comment évolue l'activité dans le temps ?
* Quelles catégories et quels produits contribuent le plus à la performance ?
* Comment se répartit l'activité entre les différents segments clients ?
* Quelles différences observe-t-on entre les zones géographiques ?
* Quels écarts ou évolutions méritent une analyse complémentaire ?
* Comment exploiter les données de manière interactive pour faciliter l'analyse ?

L'objectif est de proposer une lecture structurée de la donnée plutôt qu'une simple juxtaposition de graphiques.

---

# 🧱 Modélisation & architecture

Le rapport repose sur une **modélisation en étoile (Star Schema)** afin de faciliter l'analyse dans Power BI et de structurer les relations entre les différentes tables.

Les données sont préparées en amont dans Snowflake et dbt, puis la couche `SEM` est utilisée comme source analytique pour Power BI.

![Modèle de données](Data_Model.PNG)

### 🔄 Flux de traitement

Les données suivent le parcours suivant :

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
Analyse
```

Chaque technologie intervient sur une partie spécifique de la chaîne :

```text
Snowflake RAW
→ ingestion et stockage des données sources

dbt / DWH
→ structuration et modélisation

dbt / SEM
→ nettoyage, standardisation et préparation analytique

Power BI
→ modèle analytique, DAX, visualisation et analyse
```

Cette séparation permet de conserver une logique claire et d'éviter de déplacer l'ensemble des transformations dans Power BI.

---

# 📈 Dashboard

![Dashboard](Dashboard.PNG)

Le dashboard permet d'explorer la performance commerciale selon plusieurs axes :

* évolution temporelle ;
* catégories et sous-catégories ;
* produits ;
* segments clients ;
* zones géographiques ;
* commandes et comportement d'achat ;
* rentabilité.

Les différentes visualisations sont organisées pour faciliter la lecture des tendances et la comparaison entre les différentes dimensions du modèle.

L'utilisation de filtres et d'interactions Power BI permet également d'explorer les données de manière dynamique selon la période, la catégorie, le produit, le segment ou la zone géographique.

---

# 🧮 Mesures DAX

Les mesures DAX utilisées dans le rapport permettent de construire les indicateurs nécessaires à l'analyse commerciale et aux comparaisons temporelles.

Plutôt que de dupliquer leur documentation dans ce README, l'ensemble des mesures est regroupé dans une section dédiée.

👉 **[Voir la documentation complète des mesures DAX](../Mesures/README_Mesures_DAX.md)**

Cette séparation permet de conserver :

* un README Power BI centré sur le rapport et son utilisation ;
* une documentation dédiée pour comprendre la logique des mesures et leurs calculs.

---

# 📂 Données

### Source

**Superstore Dataset — Kaggle**

[Voir le dataset sur Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

Le dataset contient notamment des informations sur :

* les commandes ;
* les clients ;
* les produits ;
* les catégories et sous-catégories ;
* les ventes ;
* les quantités ;
* les remises ;
* les bénéfices ;
* les régions et zones géographiques ;
* les modes d'expédition.

Dans l'architecture finale, les données sont chargées dans Snowflake puis transformées avec dbt avant d'être utilisées dans Power BI.

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

# 🧹 Préparation des données

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

Les transformations réalisées avec dbt comprennent notamment :

* nettoyage des champs texte avec `TRIM` ;
* standardisation des types de données ;
* conversion des dates ;
* préparation des montants et des décimales ;
* filtrage de certaines valeurs vides ou invalides ;
* préparation des colonnes nécessaires au modèle analytique.

Power Query reste disponible pour les éventuels ajustements liés au chargement ou au modèle Power BI.

L'objectif est cependant de conserver la majorité de la logique de préparation dans la plateforme Data plutôt que de la disperser dans le rapport.

---

# 📐 Documentation du projet

Les différents composants du projet sont documentés séparément :

* [📊 Modèle de données](Data_Model.PNG)
* [📈 Dashboard Power BI](Dashboard.PNG)
* [🧮 Mesures DAX](../Mesures/README_Mesures_DAX.md)
* [🔧 Projet dbt](../DBT/README.md)
* [🗄️ Scripts SQL Snowflake](../SQL/README.md)

Cette organisation permet de retrouver facilement la documentation technique de chaque partie du pipeline.

---

# 🎯 Rôle de Power BI dans le projet

Power BI constitue la couche de **Business Intelligence et de restitution**.

La répartition des responsabilités est la suivante :

```text
Snowflake
→ stockage, ingestion et exécution SQL

dbt
→ transformation, modélisation, nettoyage et Data Quality

Power BI
→ modèle analytique, mesures DAX, visualisation et analyse
```

Power BI permet ainsi de valoriser les données préparées dans Snowflake et dbt à travers une interface interactive orientée analyse métier.

Le dashboard constitue la dernière étape de la chaîne :

```text
Source
  ↓
Snowflake
  ↓
dbt
  ↓
Data Warehouse
  ↓
Semantic Layer
  ↓
Power BI
  ↓
Analyse
---
