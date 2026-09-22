# 📐 Mesures DAX — E-Commerce Power BI

Ce dossier regroupe les principales mesures DAX utilisées dans le dashboard Power BI d'analyse des ventes et de la rentabilité.

Les mesures sont organisées en trois catégories :

- 📊 **Indicateurs KPI**
- 📈 **Indicateurs KPI N-1**
- 🔄 **Mesures d'affichage**

---

## 📊 1. Indicateurs KPI

### Chiffre d'affaires

```DAX
CA =
SUM(Fact_Sales[Sales])
```

Calcule le chiffre d'affaires total à partir des ventes.

---

### Nombre de clients

```DAX
Nb de clients =
DISTINCTCOUNT(Fact_Sales[Customer ID])
```

Calcule le nombre de clients uniques.

---

### Nombre de commandes

```DAX
Nb de commandes =
DISTINCTCOUNT(Fact_Sales[Order ID])
```

Calcule le nombre de commandes uniques.

---

### Bénéfice

```DAX
Bénéfice =
SUM(Fact_Sales[Profit])
```

Calcule le bénéfice total réalisé.

---

### Marge %

```DAX
Marge % =
DIVIDE([Bénéfice], [CA])
```

Calcule la marge en pourcentage du chiffre d'affaires.

---

### Panier moyen

```DAX
Panier moyen =
DIVIDE([CA], [Nb de commandes])
```

Calcule le chiffre d'affaires moyen généré par commande.

---

## 📈 2. Indicateurs KPI N-1

Ces mesures permettent de comparer les performances de la période sélectionnée avec la période équivalente de l'année précédente.

### CA N1

```DAX
CA N1 =
CALCULATE(
    [CA],
    SAMEPERIODLASTYEAR(Calendrier[Date])
)
```

Retourne le chiffre d'affaires réalisé sur la période équivalente de l'année précédente.

---

### CA N1 %

```DAX
CA N1 % =
DIVIDE([CA] - [CA N1], [CA N1])
```

Calcule l'évolution du chiffre d'affaires par rapport à N-1.

---

### Nb de clients N1 %

```DAX
Nb de clients N1 % =
VAR ClnN1 =
    CALCULATE(
        [Nb de clients],
        SAMEPERIODLASTYEAR(Calendrier[Date])
    )
RETURN
    DIVIDE(
        [Nb de clients] - ClnN1,
        ClnN1
    )
```

Calcule l'évolution du nombre de clients par rapport à N-1.

---

### Nb de commandes N1 %

```DAX
Nb de commandes N1 % =
VAR cmd =
    CALCULATE(
        [Nb de commandes],
        SAMEPERIODLASTYEAR(Calendrier[Date])
    )
RETURN
    DIVIDE(
        [Nb de commandes] - cmd,
        cmd
    )
```

Calcule l'évolution du nombre de commandes par rapport à N-1.

---

### Bénéfice N1 %

```DAX
Bénéfice N1 % =
VAR ben =
    CALCULATE(
        [Bénéfice],
        SAMEPERIODLASTYEAR(Calendrier[Date])
    )
RETURN
    DIVIDE(
        [Bénéfice] - ben,
        ben
    )
```

Calcule l'évolution du bénéfice par rapport à N-1.

---

### Panier moyen N1 %

```DAX
Panier moyen N1 % =
VAR PM =
    CALCULATE(
        [Panier moyen],
        SAMEPERIODLASTYEAR(Calendrier[Date])
    )
RETURN
    DIVIDE(
        [Panier moyen] - PM,
        PM
    )
```

Calcule l'évolution du panier moyen par rapport à N-1.

---

### Marge N1 %

```DAX
Marge N1 % =
VAR mg =
    CALCULATE(
        [Marge %],
        SAMEPERIODLASTYEAR(Calendrier[Date])
    )
RETURN
    DIVIDE(
        [Marge %] - mg,
        mg
    )
```

Calcule l'évolution de la marge par rapport à N-1.

---

## 🔄 3. Mesures d'affichage

Ces mesures permettent d'afficher les évolutions des KPI avec des indicateurs visuels sous forme de flèches.

### CA Evolution Affichage

```DAX
CA Evolution Affichage =
VAR Evolution = [CA N1 %]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Evolution), BLANK(),
        Evolution > 0, "▲ " & FORMAT(Evolution, "0.0%"),
        Evolution < 0, "▼ " & FORMAT(ABS(Evolution), "0.0%"),
        "▬ 0,0%"
    )
```

Affiche l'évolution du chiffre d'affaires avec une flèche indiquant la tendance.

---

### Marge Evolution Affichage

```DAX
Marge Evolution Affichage =
VAR Evolution = [Marge N1 %]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Evolution), BLANK(),
        Evolution > 0, "▲ " & FORMAT(Evolution, "0.0") & " PT",
        Evolution < 0, "▼ " & FORMAT(ABS(Evolution), "0.0") & " PT",
        "▬ 0,0 PT"
    )
```

Affiche l'évolution de la marge en points.

---

### Nb cln Evolution Affichage

```DAX
Nb cln Evolution Affichage =
VAR Evolution = [Nb de clients N1 %]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Evolution), BLANK(),
        Evolution > 0, "▲ " & FORMAT(Evolution, "0.0%"),
        Evolution < 0, "▼ " & FORMAT(ABS(Evolution), "0.0%"),
        "▬ 0,0%"
    )
```

Affiche l'évolution du nombre de clients avec une flèche.

---

### Nb cmd Evolution Affichage

```DAX
Nb cmd Evolution Affichage =
VAR Evolution = [Nb de commandes N1 %]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Evolution), BLANK(),
        Evolution > 0, "▲ " & FORMAT(Evolution, "0.0%"),
        Evolution < 0, "▼ " & FORMAT(ABS(Evolution), "0.0%"),
        "▬ 0,0%"
    )
```

Affiche l'évolution du nombre de commandes avec une flèche.

---

### PM Evolution Affichage

```DAX
PM Evolution Affichage =
VAR Evolution = [Panier moyen N1 %]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Evolution), BLANK(),
        Evolution > 0, "▲ " & FORMAT(Evolution, "0.0%"),
        Evolution < 0, "▼ " & FORMAT(ABS(Evolution), "0.0%"),
        "▬ 0,0%"
    )
```

Affiche l'évolution du panier moyen avec une flèche.

---

## 🗂️ Organisation des mesures

| Catégorie   | Mesures |
|---|---|
| Indicateurs KPI | CA, Nb de clients, Nb de commandes, Bénéfice, Marge %, Panier moyen |
| Indicateurs KPI N-1 | CA N1, CA N1 %, Nb de clients N1 %, Nb de commandes N1 %, Bénéfice N1 %, Panier moyen N1 %, Marge N1 % |
| Mesures d'affichage | CA Evolution Affichage, Marge Evolution Affichage, Nb cln Evolution Affichage, Nb cmd Evolution Affichage, PM Evolution Affichage |

---

## 🛠️ Fonctions DAX principales utilisées

- `SUM()` — agrégation des ventes et du bénéfice
- `DISTINCTCOUNT()` — comptage des clients et commandes uniques
- `DIVIDE()` — calcul des ratios et pourcentages
- `CALCULATE()` — modification du contexte de filtre
- `SAMEPERIODLASTYEAR()` — comparaison avec la période N-1
- `VAR / RETURN` — structuration des calculs intermédiaires
- `SWITCH()` — gestion des différents cas d'affichage
- `ISBLANK()` — gestion des valeurs vides
- `FORMAT()` — formatage des indicateurs

---

## 🎯 Objectif

Ces mesures permettent de suivre et d'analyser les principaux indicateurs de performance du dashboard :

- Chiffre d'affaires
- Nombre de commandes
- Nombre de clients
- Bénéfice
- Marge
- Panier moyen
- Évolution des performances par rapport à N-1

Elles permettent également d'améliorer la lisibilité du dashboard grâce à des indicateurs d'évolution visuels utilisant des flèches directionnelles.
