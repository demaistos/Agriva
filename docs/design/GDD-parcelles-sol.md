> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Parcelles et Sol

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `docs/design/GDD-economie-base.md` §4, `docs/research/reality-vs-simagri-economie.md`, ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

La parcelle est le socle de toute production végétale. C'est un **actif vivant** : le joueur peut l'améliorer (drainage, chaulage, apports organiques) ou l'épuiser (monoculture, tassement, carence). Chaque parcelle raconte une histoire agronomique.

Dans SimAgri, le sol est un simple conteneur : une surface avec un rendement fixe. Pas de notion de fertilité, pas d'usure, pas de récompense pour celui qui soigne ses terres. Dans Agriva, le sol est un capital à entretenir — la différence entre un bon et un mauvais agriculteur se lit dans ses parcelles.

**Ce que SimAgri fait bien** : simplicité d'accès, pas besoin de comprendre l'agronomie pour jouer.
**Ce que SimAgri fait mal** : aucun lien entre pratiques et résultat, pas de progression agronomique.

### 1.2 Gameplay loop

```
┌──────────────────────────────────────────────────────────────┐
│                CYCLE DE LA PARCELLE                           │
└──────────────────────────────────────────────────────────────┘

ACQUISITION (cf. GDD-economie-base §4)
  ↓ Achat ou fermage → le joueur reçoit une parcelle avec ses caractéristiques
  ↓ Décision : la cultiver telle quelle ou investir pour l'améliorer ?

DIAGNOSTIC (optionnel mais recommandé)
  ↓ Analyse de sol (150 €) → révèle les carences et le potentiel
  ↓ Décision : corriger les défauts ou adapter les cultures au sol ?

EXPLOITATION (chaque campagne)
  ↓ La culture consomme des éléments → le sol s'appauvrit
  ↓ Les engrais et résidus restituent → le sol se recharge
  ↓ Le passage de machines en conditions humides → tassement
  ↓ Décision : intensifier (rendement max, sol épuisé) ou ménager ?

AMÉLIORATION (investissement long terme)
  ↓ Drainage, chaulage, apports organiques, décompactage
  ↓ Décision : investir 3 000 €/ha maintenant pour +400 €/ha/an ?

RÉSULTAT
  ↓ Rendement = f(potentiel sol, fertilité, climat, pratiques)
  ↓ Un sol bien géré → rendements stables et élevés
  ↓ Un sol épuisé → rendements en baisse, coûts de correction croissants
```

**Boucle courte (campagne)** : le joueur fertilise, cultive, récolte. Le sol évolue à chaque cycle.
**Boucle longue (5-10 ans)** : les investissements structurels (drainage, MO, pH) portent leurs fruits. Le joueur voit sa terre s'améliorer.

### 1.3 Les décisions du joueur

| Décision | Fréquence | Impact |
|----------|:---------:|--------|
| Quelle parcelle acquérir ? | Ponctuel | Potentiel pour 20 ans |
| Faire une analyse de sol ? | Tous les 5 ans | Visibilité sur les carences |
| Corriger le pH ? | Tous les 3-5 ans | Disponibilité des éléments |
| Apporter de la matière organique ? | Annuel | Réserve en eau, structure |
| Drainer une parcelle humide ? | Ponctuel | +300-500 €/ha/an, investissement 3 000 €/ha |
| Cultiver en conditions humides ? | Ponctuel | Risque de tassement |
| Monoculture ou rotation diversifiée ? | Annuel | Fertilité vs simplicité |

### 1.4 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Qualité de terre** | 3 niveaux (bonne/moyenne/pauvre) | 6 types de sol détaillés |
| **Fertilité** | Jauge unique 0-100% | 6 éléments (N, P, K, Ca, Mg, S) + pH + MO |
| **Apports** | Engrais = recharge la jauge | Dose précise par élément, excès possibles |
| **Rendement** | Qualité terre × jauge fertilité | Formule multi-facteurs (sol × éléments × eau × structure) |
| **Analyse de sol** | Montre la jauge + conseil simple | Tableau complet des 6 éléments + pH + MO + structure |
| **Tassement** | Non | Oui (pénalité si passage en conditions humides) |
| **Réserve en eau** | Non (pluie = bonus/malus global) | RU par type de sol, bilan hydrique |
| **Drainage** | +1 niveau de qualité | +30-50 mm de RU, suppression engorgement |
| **Perte définitive** | **Non** (la jauge remonte toujours) | Non (mais correction coûteuse) |

---

## 2. Caractéristiques d'une parcelle

### 2.1 Attributs physiques

Chaque parcelle possède des attributs fixes (déterminés à la création) et des attributs variables (qui évoluent avec les pratiques).

**Attributs fixes :**

| Attribut | Valeurs | Impact gameplay |
|----------|---------|----------------|
| Surface | 1 à 50 ha | Volume de production, temps de travail |
| Forme | Régulière / Irrégulière | Irrégulière : +10% temps de travail, -5% surface utile |
| Pente | Plate (0-3%) / Légère (3-8%) / Forte (8-15%) | Forte : érosion, pas d'irrigation possible |
| Distance au siège | Zone 1 à 10 | Temps de trajet, coût carburant, facteur prix (cf. §4 GDD-éco) |
| Type de sol | 6 types (cf. §2.2) | Potentiel de rendement, réserve en eau, portance |

**Attributs variables :**

| Attribut | Mode | Plage | Évolution |
|----------|:----:|-------|-----------|
| Fertilité globale | Normal | 0-100% | ±5-15%/an selon pratiques |
| Éléments N/P/K/Ca/Mg/S | Expert | 0-200 unités | Consommation/apport par culture |
| pH | Expert | 4,5-8,5 | Baisse naturelle -0,05/an, chaulage +0,3-0,5 |
| Matière organique | Expert | 0,8-4,5% | ±0,1%/an selon pratiques |
| Structure | Expert | Bonne/Moyenne/Dégradée | Tassement / décompactage |
| Drainage | Les deux | Oui/Non | Investissement permanent |

### 2.2 Types de sol

Six types de sol, inspirés de la réalité française. Chaque type définit le potentiel agronomique de la parcelle.

| Type de sol | Réserve utile (mm) | Portance | Sensibilité sécheresse | Qualité Normal |
|-------------|:------------------:|:--------:|:----------------------:|:--------------:|
| **Limon profond** | 180-220 | Moyenne | Faible | Bonne |
| **Limon-argileux** | 150-180 | Bonne | Faible | Bonne |
| **Argile** | 120-150 | Faible | Moyenne | Moyenne |
| **Sable** | 60-90 | Bonne | Forte | Pauvre |
| **Craie** | 80-120 | Bonne | Forte | Moyenne |
| **Sol caillouteux** | 50-80 | Bonne | Très forte | Pauvre |

**Cultures adaptées par type de sol :**

| Type de sol | Cultures optimales | Cultures possibles (pénalité) | Cultures déconseillées |
|-------------|-------------------|-------------------------------|------------------------|
| Limon profond | Blé, betterave, maïs, colza | Toutes | Aucune |
| Limon-argileux | Blé, colza, pois, féverole | Maïs (-5%), betterave (-8%) | Aucune |
| Argile | Colza, tournesol, féverole | Blé (-8%), orge (-10%) | Betterave, pomme de terre |
| Sable | Maïs irrigué, pomme de terre, légumes | Blé (-15%), orge (-12%) | Colza, betterave |
| Craie | Orge, luzerne, colza | Blé (-10%), tournesol (-8%) | Maïs, betterave |
| Sol caillouteux | Vigne, luzerne, tournesol | Orge (-15%), blé (-20%) | Maïs, betterave, pomme de terre |

### 2.3 Distance au siège — Zones

La distance au siège affecte le temps de trajet et le coût opérationnel (carburant). Elle influence aussi le prix foncier (cf. GDD-economie-base §4.3).

| Zone | Distance | Temps trajet A/R | Surcoût carburant | Facteur prix foncier |
|:----:|----------|:----------------:|:-----------------:|:--------------------:|
| 1-3 | Proche | 0-10 min | +0% | ×1,10 |
| 4-7 | Moyenne | 15-30 min | +5% | ×1,00 |
| 8-10 | Éloignée | 35-60 min | +12% | ×0,85 |

En mode Normal, la distance est un simple multiplicateur de temps de travail. En mode Expert, elle consomme réellement du carburant et du temps de trajet supplémentaire.

---

## 3. Les 6 éléments du sol

### 3.1 Principe (Expert)

Le sol contient 6 éléments nutritifs mesurés en unités/ha. Chaque culture consomme des quantités spécifiques ; les engrais et résidus restituent.

En mode Normal, ces 6 éléments sont agrégés en une **jauge de fertilité unique** (0-100%).

### 3.2 Valeurs de référence et seuils

| Élément | Unité | Optimal | Carence (<) | Excès (>) | Effet carence | Effet excès |
|---------|:-----:|:-------:|:-----------:|:---------:|--------------|-------------|
| **Azote (N)** | u/ha | 80-120 | 40 | 180 | Rendement -20 à -40% | Verse, pollution (-qualité) |
| **Phosphore (P)** | u/ha | 60-100 | 25 | 150 | Rendement -10 à -20%, enracinement faible | Blocage du zinc (aucun effet gameplay) |
| **Potassium (K)** | u/ha | 80-120 | 35 | 200 | Rendement -10 à -15%, sensibilité sécheresse | Blocage magnésium |
| **Calcium (Ca)** | u/ha | 100-150 | 50 | 250 | pH baisse, aluminium toxique | Sol battant (croûte) |
| **Magnésium (Mg)** | u/ha | 30-60 | 15 | 100 | Rendement -5 à -10%, jaunissement | Blocage potassium |
| **Soufre (S)** | u/ha | 20-40 | 10 | 80 | Rendement -5 à -15% (colza très sensible) | Aucun effet notable |

### 3.3 Consommation par culture (unités/ha/campagne)

| Culture | N | P | K | Ca | Mg | S |
|---------|:-:|:-:|:-:|:--:|:--:|:-:|
| Blé tendre (80 q) | 160 | 35 | 40 | 20 | 10 | 15 |
| Orge (70 q) | 130 | 30 | 35 | 18 | 8 | 12 |
| Colza (35 q) | 180 | 40 | 50 | 30 | 12 | 35 |
| Maïs grain (95 q) | 200 | 45 | 55 | 15 | 12 | 18 |
| Tournesol (28 q) | 100 | 30 | 60 | 25 | 10 | 12 |
| Betterave (85 t) | 140 | 50 | 200 | 40 | 15 | 20 |
| Pois/féverole | 0* | 25 | 35 | 20 | 8 | 8 |
| Prairie (fauche) | 40 | 20 | 80 | 30 | 10 | 8 |
| Luzerne | 0* | 30 | 100 | 50 | 12 | 15 |

*Légumineuses : fixation symbiotique → pas de consommation d'azote du sol + restitution de 30-40 u N au suivant.

### 3.4 Restitution par les résidus

Quand le joueur enfouit les résidus (pailles, cannes) au lieu de les exporter :

| Culture | N restitué | P restitué | K restitué | Ca | Mg | S |
|---------|:----------:|:----------:|:----------:|:--:|:--:|:-:|
| Paille de blé (enfouie) | +15 | +5 | +40 | +5 | +3 | +3 |
| Paille d'orge | +12 | +4 | +35 | +4 | +2 | +2 |
| Cannes de maïs | +20 | +8 | +50 | +5 | +4 | +3 |
| Fanes de betterave | +30 | +10 | +60 | +15 | +5 | +5 |
| Résidus colza | +10 | +5 | +25 | +8 | +3 | +8 |

**Décision gameplay** : exporter la paille (vente à 60 €/t ou litière animale) vs l'enfouir (restitution d'éléments, économie d'engrais). En blé à 80 q/ha → 4 t de paille → 240 € de vente OU +40 u K économisées (valeur engrais ~35 €). L'export est rentable à court terme mais appauvrit le sol.

### 3.5 Mode Normal — Jauge de fertilité

En Normal, les 6 éléments sont invisibles. Le joueur voit une seule jauge :

```
fertilité_globale = moyenne_pondérée(N×0,35, P×0,20, K×0,20, Ca×0,10, Mg×0,08, S×0,07)
                    normalisée sur 0-100%
```

| Jauge | Signification | Effet rendement |
|:-----:|---------------|:---------------:|
| 80-100% | Sol fertile | ×1,00 (plein potentiel) |
| 60-79% | Sol correct | ×0,90 |
| 40-59% | Sol fatigué | ×0,75 |
| 20-39% | Sol carencé | ×0,55 |
| 0-19% | Sol épuisé | ×0,35 |

**Apport simple (Normal)** : le joueur achète de l'engrais complet (NPK) → +15 à +25% de jauge selon la dose. Pas de choix par élément. Coût : 120-200 €/ha selon dose.

### 3.6 Formule de rendement

**Mode Normal :**
```
rendement = rendement_base_culture × facteur_qualité_terre × facteur_fertilité
  
  facteur_qualité_terre :
    Bonne  = 1,00
    Moyenne = 0,85
    Pauvre  = 0,70
  
  facteur_fertilité = voir tableau §3.5
```

**Mode Expert :**
```
rendement = rendement_base × f_sol × f_nutrition × f_eau × f_structure × f_précédent

  f_sol        = potentiel du type de sol pour cette culture (0,80 à 1,00)
  f_nutrition  = min(f_N, f_P, f_K, f_S) × correction(Ca, Mg)
                 Loi du minimum : l'élément le plus limitant plafonne le rendement
  f_eau        = min(1, eau_disponible / besoin_culture)
  f_structure  = 1,00 (bonne) / 0,92 (moyenne) / 0,80 (dégradée)
  f_précédent  = bonus rotation (cf. GDD-cultures)
```


---

### 3.6 Écume de sucrerie — Amendement calcique

L'écume de sucrerie est un **sous-produit de la transformation betteravière** que le joueur peut récupérer gratuitement (hors transport) auprès de la coopérative sucrière (cf. GDD-cooperatives-car §4).

#### Caractéristiques de l'écume

| Paramètre | Valeur |
|-----------|--------|
| Composition | CaCO₃ 60-70%, MO 10-15%, P₂O₅ 2-3%, N 0,5% |
| Apports par tonne (base 15 t/ha) | Ca +180 u, P +35 u, N +8 u, MO +0,2 pts |
| Dose recommandée | 15 t/ha |
| Fréquence maximale | 1 application tous les 5 ans (par parcelle) |
| Effet pH | +0,3 à +0,5 unité de pH (sol acide → neutre) |
| Effet structure | Améliore le complexe argilo-humique (+5% stabilité structurale) |
| Coût produit | Gratuit (disponible si sucrerie active sur le serveur) |
| Coût transport | Distance sucrerie × 0,12 €/t/km (à la charge du joueur) |
| Coût épandage | 7 €/t (épandeur à fumier, débit 3 ha/h à 15 t/ha) |

#### Itinéraire d'épandage (ADR-004)

```
ÉPANDAGE ÉCUME — Parcelle de 12 ha

  Chargement (télescopique + épandeur 14 t) :
    Volume total : 12 ha × 15 t/ha = 180 t
    Nombre de voyages : 180 ÷ 14 = 13 voyages
    Temps chargement/voyage : 12 min
    Total chargement : 13 × 12 min = 2 h 36

  Transport (si distance sucrerie 25 km) :
    Aller-retour : 50 km ÷ 25 km/h = 2 h/voyage
    Total transport : 13 × 2 h = 26 h

  Épandage (épandeur 14 t, largeur 8 m, vitesse 8 km/h) :
    Débit : 8 m × 8 km/h × 0,1 = 6,4 ha/h brut
    Mais 15 t/ha → épandeur vide en 14/15 = 0,93 ha/passage
    Temps réel épandage : 12 ha ÷ 0,93 × (temps passage) ≈ 3 h

  TOTAL CHANTIER : 2,6 + 26 + 3 = 31,6 h (répartis sur 3-4 jours)
  
  → L'écume est GRATUITE mais le chantier est LONG
  → Alternatif : faire appel à une ETA (7 €/t × 180 t = 1 260 €, 1 journée)
```

#### Conditions d'utilisation

| Condition | Détail |
|-----------|--------|
| Disponibilité | Uniquement si une sucrerie est active sur le serveur (coopérative betteravière) |
| Période d'épandage | Août-Novembre (post-récolte, sol portant) |
| Sol cible | pH < 6,8 (au-dessus = inutile, risque de blocage du fer) |
| Interdiction | Pas d'écume sur prairie (risque de contamination) |
| Délai d'effet | pH remonte progressivement sur 6 mois |

**Mode Normal** : action « Commander de l'écume » disponible si pH < 6,8. Livraison automatique, coût transport affiché.

**Mode Expert** : le joueur organise le chantier (transport, épandage, date). Effet pH mesuré à l'analyse de sol suivante.

---

## 4. pH et chaulage (Expert)

### 4.1 Principe

Le pH du sol conditionne la disponibilité des éléments nutritifs. Un pH trop bas (acide) bloque le phosphore et le calcium ; un pH trop haut (basique) bloque le fer et le manganèse. La plage optimale pour les grandes cultures est **6,5-7,5**.

### 4.2 Effet du pH sur la disponibilité des éléments

| pH | N disponible | P disponible | K disponible | Ca/Mg | Effet rendement |
|:--:|:------------:|:------------:|:------------:|:-----:|:---------------:|
| < 5,5 | 60% | 40% | 80% | 50% | ×0,70 |
| 5,5-6,0 | 75% | 60% | 90% | 70% | ×0,82 |
| 6,0-6,5 | 90% | 80% | 95% | 85% | ×0,92 |
| **6,5-7,5** | **100%** | **100%** | **100%** | **100%** | **×1,00** |
| 7,5-8,0 | 95% | 85% | 90% | 100% | ×0,95 |
| > 8,0 | 85% | 70% | 80% | 100% | ×0,88 |

**Gameplay** : même si le joueur apporte assez d'engrais, un pH de 5,5 rend 40% du phosphore indisponible → carence apparente malgré les apports. Corriger le pH est plus rentable qu'augmenter les doses.

### 4.3 Évolution naturelle du pH

```
Baisse naturelle : -0,05/an (lessivage, exportation par les cultures)
Accélérée par   : engrais ammoniacaux (-0,03 supplémentaire), monoculture
Stabilisée par  : résidus enfouis, prairie permanente
```

### 4.4 Chaulage

| Produit | Dose (t/ha) | Effet pH | Durée | Coût/ha | Coût/point de pH |
|---------|:-----------:|:--------:|:-----:|:-------:|:----------------:|
| Chite de chaux | 1,5-3,0 | +0,3 à +0,5 | 3-4 ans | 80-150 € | ~250 € |
| Amendement calcaire broyé | 3,0-5,0 | +0,5 à +0,8 | 5-6 ans | 120-200 € | ~220 € |
| Chaux vive | 1,0-2,0 | +0,5 à +0,7 | 3-4 ans | 150-250 € | ~300 € |

**Règle de jeu** : un seul chaulage par parcelle tous les 3 ans (le sol doit se stabiliser).

**Rentabilité** : corriger 1 point de pH (de 5,8 à 6,8) coûte ~450 €/ha mais gagne +18% de rendement. Sur blé à 1 200 €/ha de produit brut → +216 €/ha/an. Retour sur investissement en 2-3 ans.

---

## 5. Matière organique (Expert)

### 5.1 Principe

La matière organique (MO) est le moteur biologique du sol. Elle affecte :
- La **réserve en eau** (+2 mm de RU par +0,1% de MO)
- La **structure** (résistance au tassement)
- La **minéralisation** (libération d'azote gratuit : 20-40 u N/an si MO > 2,5%)
- La **vie biologique** (vers de terre, micro-organismes)

### 5.2 Plages de référence

| Taux de MO | Qualification | Effet réserve eau | Minéralisation N | Effet structure |
|:----------:|:------------:|:-----------------:|:----------------:|:---------------:|
| < 1,5% | Très faible | -20 mm RU | 10 u N/an | Fragile |
| 1,5-2,0% | Faible | -10 mm RU | 20 u N/an | Moyenne |
| 2,0-2,5% | Correcte | Base | 30 u N/an | Correcte |
| 2,5-3,0% | Bonne | +10 mm RU | 40 u N/an | Bonne |
| 3,0-3,5% | Élevée | +20 mm RU | 50 u N/an | Très bonne |
| > 3,5% | Prairie/sol forestier | +30 mm RU | 60 u N/an | Excellente |

### 5.3 Bilan humique annuel

```
variation_MO = (apports_humifiés - minéralisation) / masse_terre_ha

Minéralisation annuelle = MO_actuelle × coefficient_k1
  k1 = 0,02 (sol argileux, protège la MO)
  k1 = 0,03 (sol limoneux)
  k1 = 0,04 (sol sableux, dégrade vite la MO)

Apports humifiés = somme(apport_i × coefficient_isohumique_i)
```

**Coefficients isohumiques (fraction transformée en humus stable) :**

| Apport | Coefficient | Apport type (t/ha) | MO formée |
|--------|:-----------:|:------------------:|:---------:|
| Paille enfouie | 0,15 | 4 t | 0,6 t humus |
| Fumier bovin | 0,30 | 25 t | 7,5 t humus |
| Compost | 0,50 | 10 t | 5,0 t humus |
| Prairie (racines/an) | 0,35 | 5 t (MS racinaire) | 1,75 t humus |
| Couvert végétal CIPAN | 0,20 | 2,5 t | 0,5 t humus |

### 5.4 Scénarios de gestion MO

**Système céréalier sans élevage (paille exportée)** :
```
Minéralisation (MO 2,2%, limon) : -2 200 kg humus/an
Apports (uniquement racines + chaumes) : +800 kg humus/an
Bilan : -1 400 kg/an → MO baisse de 0,04%/an
→ En 10 ans : 2,2% → 1,8% → perte de réserve en eau et de minéralisation
```

**Système céréalier avec paille enfouie + CIPAN** :
```
Minéralisation : -2 200 kg humus/an
Apports (paille 600 + racines 800 + CIPAN 500) : +1 900 kg humus/an
Bilan : -300 kg/an → MO quasi stable (-0,01%/an)
```

**Système polyculture-élevage (fumier)** :
```
Minéralisation : -2 200 kg humus/an
Apports (fumier 7 500 + racines 800) : +8 300 kg humus/an
Bilan : +6 100 kg/an → MO monte de +0,15%/an
→ En 5 ans : 2,2% → 3,0% → gain de réserve en eau et de minéralisation
```

### 5.5 Gameplay

- **Décision** : exporter la paille (revenu immédiat) ou l'enfouir (capital sol à long terme)
- **Synergie élevage** : le fumier est le meilleur apport organique → avantage des systèmes mixtes
- **Achat de compost** : 30 €/t livré × 10 t/ha = 300 €/ha/an (alternative sans élevage)
- **Prairie temporaire** : 3 ans de prairie = +0,5% de MO, mais 3 ans sans revenu cultural

---

## 6. Structure et tassement (Expert)

### 6.1 Principe

La structure du sol est son agencement en agrégats (mottes, grumeaux). Une bonne structure permet l'enracinement, la circulation de l'eau et de l'air. Le tassement détruit cette structure.

### 6.2 Niveaux de structure

| État | Effet rendement | Effet infiltration eau | Cause |
|------|:---------------:|:---------------------:|-------|
| **Bonne** | ×1,00 | 100% de la RU accessible | Rotation diversifiée, pas de passage humide |
| **Moyenne** | ×0,92 | 80% de la RU accessible | Passage occasionnel en conditions limites |
| **Dégradée** | ×0,80 | 60% de la RU accessible | Passages répétés en sol humide, semelle de labour |

### 6.3 Mécanique de tassement

```
Chaque intervention en parcelle est évaluée :

risque_tassement = poids_machine × humidité_sol / portance_sol

Si humidité_sol > 80% de la capacité au champ :
  → zone à risque (alerte orange avant validation)

Si humidité_sol > 95% :
  → tassement garanti (alerte rouge)
  → structure descend d'un cran

Portance par type de sol :
  Argile      : 0,6 (très sensible)
  Limon       : 0,8
  Limon-argileux : 0,7
  Sable/craie : 1,0 (peu sensible)
  Caillouteux : 1,0
```

**Machines à risque** :

| Machine | Poids (facteur) | Risque relatif |
|---------|:---------------:|:--------------:|
| Tracteur seul | 1,0 | Faible |
| Tracteur + épandeur plein | 2,5 | Élevé |
| Moissonneuse-batteuse (trémie pleine) | 3,0 | Très élevé |
| Betteravière/arracheuse | 3,5 | Très élevé |
| Tracteur + semoir | 1,3 | Faible |

### 6.4 Semelle de labour

```
Si le joueur laboure systématiquement à la même profondeur (>3 ans consécutifs) :
  → formation d'une semelle de labour à 25-30 cm
  → effet : racines bloquées, eau stagnante au-dessus
  → pénalité : -8% rendement, structure passe à "moyenne" minimum

Prévention : alterner labour profond et travail superficiel, ou TCS (techniques culturales simplifiées)
```

### 6.5 Correction — Décompactage

| Action | Coût/ha | Effet | Délai |
|--------|:-------:|-------|:-----:|
| Décompactage superficiel | 45 €/ha | Moyenne → Bonne | 1 campagne |
| Sous-solage (semelle de labour) | 80 €/ha | Dégradée → Moyenne | 1 campagne |
| Sous-solage + prairie 2 ans | 80 € + perte de revenu | Dégradée → Bonne | 2 campagnes |
| Passage de fissurateur | 55 €/ha | Dégradée → Moyenne | 1 campagne |

**Gameplay** : le tassement est un risque à gérer, pas une punition gratuite. Le joueur reçoit une **alerte avant** de valider un passage en conditions humides. S'il choisit quand même (urgence de récolte, par exemple), il assume la conséquence.


---

## 7. Analyse de sol

### 7.1 Principe

L'analyse de sol est le **diagnostic** de la parcelle. Elle coûte 150 € et reste valable 5 ans (les éléments peu mobiles — P, K, Ca, Mg — évoluent lentement).

### 7.2 Ce que l'analyse révèle

| Information | Mode Normal | Mode Expert |
|-------------|:-----------:|:-----------:|
| Fertilité globale (jauge) | ✅ | ✅ |
| Conseil d'apport (dose recommandée) | ✅ | ✅ |
| N, P, K, Ca, Mg, S (valeurs exactes) | ❌ | ✅ |
| pH | ❌ | ✅ |
| Taux de matière organique | ❌ | ✅ |
| État de la structure | ❌ | ✅ |
| Réserve utile mesurée | ❌ | ✅ |
| CEC (capacité d'échange cationique) | ❌ | ✅ (informatif) |

### 7.3 Règles

```
Coût                  : 150 €/parcelle
Validité              : 5 campagnes (après 5 ans, les données deviennent "périmées" → affichage grisé)
Disponibilité résultat : immédiat (simplification gameplay)
Fréquence max         : 1 analyse/parcelle/an
Sans analyse          : Normal → jauge estimée (±15% d'erreur, affichée en "~")
                        Expert → aucune donnée sauf N (estimé par reliquat)
```

### 7.4 Gameplay de l'analyse

**En Normal** : l'analyse est un simple "scan" qui donne un conseil clair. Le joueur sait exactement quoi acheter.

**En Expert** : l'analyse est un outil de décision stratégique. Elle révèle les déséquilibres invisibles et permet d'optimiser les apports (économie de 10-20% sur les engrais en ciblant juste).

**Rentabilité** : 150 € d'analyse → économie potentielle de 30-50 €/ha sur 5 ans d'engrais ciblé (sur une parcelle de 20 ha : économie 3 000-5 000 € sur 5 ans). Toujours rentable.

---

## 8. Réserve utile et bilan hydrique (Expert)

### 8.1 Principe

La réserve utile (RU) est la quantité d'eau que le sol peut stocker et mettre à disposition de la culture. C'est le facteur n°1 de rendement en année sèche.

### 8.2 RU par type de sol

| Type de sol | RU de base (mm) | Avec drainage (+) | Avec MO 3%+ (+) | RU max possible |
|-------------|:---------------:|:-----------------:|:----------------:|:---------------:|
| Limon profond | 200 | +0 (déjà drainant) | +20 | 220 |
| Limon-argileux | 165 | +30 | +15 | 210 |
| Argile | 135 | +40 | +15 | 190 |
| Sable | 75 | +0 | +10 | 85 |
| Craie | 100 | +20 | +10 | 130 |
| Sol caillouteux | 65 | +0 | +5 | 70 |

### 8.3 Bilan hydrique simplifié

```
Chaque semaine in-game (Expert) :

eau_disponible = eau_stock + pluie_semaine - ETR_culture

ETR (évapotranspiration réelle) par stade :
  Semis-levée          : 10 mm/semaine
  Tallage/croissance   : 20 mm/semaine
  Floraison-remplissage: 35 mm/semaine  ← pic de besoin
  Maturation           : 15 mm/semaine

Si eau_disponible > RU :
  → excès drainé (perdu si pas de drainage installé, stocké si irrigation en réserve)

Si eau_disponible < 0 :
  → stress hydrique → pénalité rendement progressive
```

### 8.4 Stress hydrique et pénalité rendement

| Déficit hydrique cumulé | Effet rendement | Stade le plus sensible |
|:-----------------------:|:---------------:|:----------------------:|
| 0-20 mm | ×1,00 (aucun) | — |
| 20-50 mm | ×0,92 | Floraison |
| 50-100 mm | ×0,78 | Floraison + remplissage |
| 100-150 mm | ×0,60 | Tout stade |
| > 150 mm | ×0,40 (perte majeure) | Tout stade |

### 8.5 Interaction type de sol × sécheresse

**Exemple : été sec (4 semaines sans pluie pendant remplissage du grain)**
```
Besoin culture (blé, 4 sem × 35 mm) = 140 mm

Limon profond (RU 200 mm) :
  Stock disponible fin floraison = ~120 mm (après consommation printemps)
  Déficit = 140 - 120 = 20 mm → pénalité ×0,92 → rendement 74 q/ha

Sol caillouteux (RU 65 mm) :
  Stock disponible fin floraison = ~35 mm
  Déficit = 140 - 35 = 105 mm → pénalité ×0,60 → rendement 48 q/ha

→ Écart de 26 q/ha = 5 720 € de manque à gagner sur 1 ha de blé
→ Sur 20 ha : 114 400 € de différence sur une seule campagne sèche
```

### 8.6 Mode Normal — Simplification

En Normal, pas de bilan hydrique détaillé. Le climat est un **modificateur global** par campagne :

| Climat de l'année | Effet rendement Normal |
|:------------------:|:---------------------:|
| Année humide | ×1,00 (pas de pénalité, pas de bonus) |
| Année normale | ×1,00 |
| Année sèche | ×0,85 (terre bonne) / ×0,75 (moyenne) / ×0,65 (pauvre) |
| Année très sèche | ×0,75 (bonne) / ×0,60 (moyenne) / ×0,45 (pauvre) |

La qualité de terre en Normal intègre déjà implicitement la RU. Une "bonne terre" résiste mieux à la sécheresse.


---

## 9. Améliorations possibles

### 9.1 Tableau des investissements

| Amélioration | Coût/ha | Effet principal | Gain estimé/ha/an | ROI | Mode |
|-------------|:-------:|-----------------|:-----------------:|:---:|:----:|
| **Drainage** | 3 000 € | +30-50 mm RU, supprime engorgement | +300-500 € | 6-10 ans | N+E |
| **Chaulage** | 120-250 € | +0,3 à +0,8 pH | +150-250 € | 1-2 ans | E |
| **Apport compost** | 300 €/an | +0,05% MO/an, structure | +80-150 € | Continu | E |
| **Fumier (si élevage)** | 50 € (épandage) | +0,15% MO/an, N+P+K | +200-300 € | <1 an | E |
| **Broyage de pierres** | 800 € | Sol caillouteux → -50% cailloux, +travaillabilité | +100-200 € | 4-8 ans | E |
| **Décompactage** | 45-80 € | Structure moyenne/dégradée → bonne | +100-250 € | <1 an | E |
| **Couvert végétal (CIPAN)** | 60 € (semence) | +0,01% MO, piège N, structure | +50-100 € | <1 an | E |

### 9.2 Drainage — Détail

```
Conditions pour drainer :
  - Sol argile ou limon-argileux avec engorgement hivernal
  - Parcelle plate ou légère pente (pas forte pente)
  - Non drainé actuellement

Coût : 3 000 €/ha (investissement unique, amortissable sur 20 ans = 150 €/ha/an)
Effet :
  - Supprime les jours d'engorgement (parcelle praticable plus tôt au printemps)
  - +30 à +50 mm de RU effective (l'eau circule au lieu de stagner)
  - Portance améliorée (moins de risque de tassement)
  - Cultures possibles : betterave et maïs deviennent viables sur argile drainée

Gain estimé (argile, 135 ha) :
  Rendement blé sans drainage : 65 q/ha (engorgement + tassement)
  Rendement blé avec drainage : 78 q/ha
  Gain : +13 q × 220 €/t = +286 €/ha/an en blé
  + économie tassement (moins de passages annulés) : +50 €/ha/an
  → Gain total : ~336 €/ha/an pour 3 000 € investis = ROI 9 ans
```

### 9.3 Mode Normal — Améliorations simplifiées

En Normal, le joueur ne voit que deux améliorations :

| Amélioration | Coût | Effet affiché | Condition |
|-------------|:----:|---------------|-----------|
| **Drainage** | 3 000 €/ha | Qualité terre +1 niveau (pauvre → moyenne, ou moyenne → bonne) | Terre non drainée |
| **Amendement** | 200 €/ha | Fertilité +20% | Jauge < 80% |

Pas de pH, pas de MO, pas de structure en Normal. Le drainage est le seul investissement structurel visible.

---

## 9bis. Fertilisation organique et plafond réglementaire

> Cette section fait le lien entre les GDD d'élevage (production d'effluents),
> `GDD-transformation.md` §3 (méthanisation → digestat) et la fertilisation des parcelles.

### 9bis.1 Les apports organiques disponibles

| Effluent | Origine | Matière sèche | N (u/t) | P₂O₅ (u/t) | K₂O (u/t) | Dose usuelle |
|----------|---------|:-------------:|:-------:|:----------:|:---------:|:------------:|
| Fumier bovin | Litière paille + déjections | 22% | 5 | 3 | 7 | 25 t/ha |
| Fumier ovin/caprin | Litière paille | 30% | 7 | 4 | 9 | 20 t/ha |
| Fumier de volaille | Litière + fientes | 60% | 25 | 15 | 15 | 6 t/ha |
| Fumier équin | Litière pailleuse | 25% | 5 | 3 | 6 | 25 t/ha |
| Lisier bovin | Caillebotis | 8% | 3 | 1,5 | 4 | 30 m³/ha |
| Lisier porcin | Caillebotis | 4% | 4 | 2 | 3 | 25 m³/ha |
| **Digestat solide** | Méthanisation | 25% | 6 | 4 | 8 | 20 t/ha |
| **Digestat liquide** | Méthanisation | 5% | 4 | 1 | 5 | 30 m³/ha |
| Compost | Fumier composté (3 t → 1 t) | 40% | 12 | 8 | 16 | 12 t/ha |

**Le digestat de méthanisation** conserve la totalité de l'azote, du phosphore et du potassium
des substrats entrants, mais sous une forme **plus directement assimilable** (azote ammoniacal).
C'est un atout du joueur qui possède un méthaniseur : il transforme ses effluents en énergie
**sans perdre leur valeur fertilisante**.

### 9bis.2 Le plafond réglementaire — Directive Nitrates

**Mode Normal** : aucun plafond. Le joueur épand ses effluents, le jeu ne bloque jamais.
Une simple indication apparaît s'il dépasse largement les besoins de la culture.

**Mode Expert** : le plafond réglementaire s'applique.

```
PLAFOND : 170 kg d'azote organique par hectare et par an,
          calculé en MOYENNE sur la surface épandable de l'exploitation.

azote_organique_total = Σ (effluent_i × teneur_N_i)
surface_épandable     = SAU - (bandes tampons + surfaces non épandables)

Si azote_organique_total / surface_épandable > 170 u/ha :
  → Le joueur est en excédent structurel. Trois solutions :
     1. Exporter des effluents (coût de transport : 4-8 €/t ou €/m³)
     2. Augmenter sa surface (achat ou fermage)
     3. Réduire son cheptel
  → S'il ne fait rien : contrôle possible (5%/an) → pénalité PAC de -5 à -20%
```

**Exemple de vérification — élevage laitier 60 VL sur 105 ha** :
```
Production d'effluents :
  60 vaches × 18 t de fumier/an = 1 080 t
  Teneur : 1 080 t × 5 u N/t     = 5 400 u d'azote organique
  40 génisses × 9 t              =   360 t → 1 800 u
  ──────────────────────────────────────────────────────
  TOTAL                          = 7 200 u d'azote organique

Surface épandable : 105 ha - 5 ha (bandes tampons, chemins) = 100 ha

Ratio : 7 200 / 100 = 72 u N/ha  ✅ très en dessous du plafond de 170

→ Cet élevage peut même IMPORTER des effluents d'un voisin (jusqu'à 9 800 u
  supplémentaires), ce qui crée une opportunité d'échange entre joueurs.
```

**Exemple d'excédent — élevage porcin 200 truies naisseur-engraisseur sur 40 ha** :
```
Production de lisier : 200 truies (avec leur suite) × 5,5 m³/an = 1 100 m³
                       + 1 800 porcs charcutiers × 0,85 m³      = 1 530 m³
                       ──────────────────────────────────────────────────
                       TOTAL                                    = 2 630 m³

Azote : 2 630 m³ × 4 u N/m³ = 10 520 u

Surface épandable : 38 ha
Ratio : 10 520 / 38 = 277 u N/ha  ❌ DÉPASSEMENT (plafond 170)

Excédent à exporter : (277 - 170) × 38 = 4 066 u, soit 1 017 m³ de lisier
Coût d'exportation : 1 017 m³ × 5 €/m³ = 5 085 €/an

→ C'est une charge structurelle de l'élevage porcin hors-sol, absente en système
  herbager. Elle crée un vrai besoin d'échange avec les céréaliers voisins.
```

### 9bis.3 Le plan d'épandage (Expert)

```
Contraintes de calendrier (zone vulnérable) :
  Fumier composté   : autorisé toute l'année sauf sol gelé/enneigé
  Fumier frais      : interdit du 15 novembre au 15 janvier
  Lisier            : interdit du 1er octobre au 31 janvier sur sol nu
  Digestat liquide  : mêmes règles que le lisier

Contraintes de distance :
  Cours d'eau       : 35 m (lisier), 10 m (fumier composté)
  Habitations       : 100 m (lisier), 50 m (fumier)
  Puits, captages   : 50 m

Si le joueur épand hors calendrier ou trop près :
  → risque de contrôle, pénalité PAC
  → en Normal : le jeu affiche un avertissement mais n'empêche pas
  → en Expert : l'action est bloquée
```

### 9bis.4 Valorisation économique des effluents

```
Un apport de 25 t/ha de fumier bovin apporte :
  125 u N + 75 u P₂O₅ + 175 u K₂O

Équivalent en engrais minéral acheté :
  125 u N × 1,25 €/u    = 156 €
   75 u P × 1,00 €/u    =  75 €
  175 u K × 0,67 €/u    = 117 €
  ─────────────────────────────
  VALEUR FERTILISANTE   = 348 €/ha

Coût d'épandage (matériel propre) : 45 €/ha
Coût d'épandage (prestation ETA)  : 175 €/ha (25 t × 7 €/t)

→ ÉCONOMIE NETTE : 303 €/ha (matériel propre) ou 173 €/ha (ETA)

C'est le principal bénéfice économique du couplage culture-élevage :
un éleveur qui épand ses effluents économise 15 000 à 30 000 €/an d'engrais.
```

### 9bis.5 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|:------:|:------:|
| Plafond 170 u N/ha | Non appliqué | Appliqué, avec contrôles |
| Calendrier d'épandage | Libre | Périodes d'interdiction |
| Distances réglementaires | Non | 35 m cours d'eau, 100 m habitations |
| Digestat | Même valeur que le fumier | Azote plus assimilable (+15% d'efficacité) |
| Excédent structurel | Non modélisé | Coût d'exportation 4-8 €/t |
| Échange entre joueurs | Non | Oui (le céréalier reçoit, l'éleveur exporte) |
| Valeur fertilisante affichée | Globale | Détaillée par élément |

---

## 10. Équilibrage et scénarios chiffrés

### 10.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| La qualité de terre a un impact significatif mais pas écrasant | ±25-35% de rendement entre bonne et pauvre terre |
| Le drainage est rentable mais pas obligatoire | ROI 6-10 ans |
| L'analyse de sol est toujours rentable | ROI < 1 campagne |
| Un joueur en sol pauvre peut compenser (rotation, irrigation) | Écart réduit à ±15% avec bonnes pratiques |
| Le mode Normal ne punit jamais | Fertilité remonte toujours avec engrais simple |
| Le mode Expert récompense la connaissance | 10-20% de marge en plus avec fertilisation raisonnée |

### 10.2 Scénario chiffré — Comparaison blé sur limon profond vs sol caillouteux

**Hypothèses communes :**
```
Culture       : blé tendre, variété identique
Intrants      : fertilisation optimale (pas de carence)
Climat        : année normale (pas de sécheresse)
Mode          : Expert
Prix de vente : 220 €/t
```

**Parcelle A — Limon profond, bien gérée (pH 6,8, MO 2,8%, structure bonne)**
```
Rendement de base blé         : 85 q/ha
f_sol (limon profond, optimal): ×1,00
f_nutrition (pas de carence)  : ×1,00
f_eau (RU 200 + MO bonus)    : ×1,00
f_structure (bonne)           : ×1,00
f_précédent (après colza)     : ×1,06
─────────────────────────────────────
Rendement final               : 90 q/ha

Produit brut                  : 90 × 22 €/q = 1 980 €/ha
Charges culture (semences, engrais, phytos, méca) : -850 €/ha
Fermage (250 €/ha)            : -250 €/ha
─────────────────────────────────────
Marge nette                   : 880 €/ha
```

**Parcelle B — Sol caillouteux, mal gérée (pH 5,8, MO 1,6%, structure moyenne)**
```
Rendement de base blé         : 85 q/ha
f_sol (caillouteux, blé)      : ×0,80 (-20% inadapté)
f_nutrition (P bloqué par pH) : ×0,88
f_eau (RU 65, déficit moyen)  : ×0,85
f_structure (moyenne)         : ×0,92
f_précédent (blé sur blé)    : ×0,90
─────────────────────────────────────
Rendement final               : 40 q/ha

Produit brut                  : 40 × 22 €/q = 880 €/ha
Charges culture               : -680 €/ha (moins d'engrais N, mais même base)
Fermage (90 €/ha, zone élevage): -90 €/ha
─────────────────────────────────────
Marge nette                   : 110 €/ha
```

**Parcelle B corrigée — Mêmes cailloux mais bien gérée (pH 6,8, MO 2,4%, structure bonne)**
```
Rendement de base blé         : 85 q/ha
f_sol (caillouteux)           : ×0,80
f_nutrition (corrigé)         : ×1,00
f_eau (RU 65, toujours faible): ×0,85
f_structure (bonne)           : ×1,00
f_précédent (après luzerne)   : ×1,10
─────────────────────────────────────
Rendement final               : 63 q/ha

Produit brut                  : 63 × 22 €/q = 1 386 €/ha
Charges culture               : -780 €/ha (+ chaulage amorti, + compost)
Fermage                       : -90 €/ha
─────────────────────────────────────
Marge nette                   : 516 €/ha
```

**Synthèse du scénario :**

| Parcelle | Rendement | Marge/ha | vs. Limon optimal |
|----------|:---------:|:--------:|:-----------------:|
| A — Limon profond, bien gérée | 90 q/ha | 880 €/ha | Référence |
| B — Caillouteux, mal gérée | 40 q/ha | 110 €/ha | -87% |
| B — Caillouteux, bien gérée | 63 q/ha | 516 €/ha | -41% |

**Enseignements gameplay :**
1. Le type de sol compte énormément (+750 €/ha entre limon et cailloux mal géré)
2. Mais les bonnes pratiques compensent une partie du handicap (+406 €/ha)
3. Le joueur en sol pauvre a intérêt à adapter ses cultures (luzerne, tournesol) plutôt que forcer le blé
4. Le drainage n'aide pas ici (sol drainant naturellement) → l'irrigation serait la solution (GDD à venir)

---

## 11. Mockups d'interface

### 11.1 Fiche parcelle — Mode Normal

```
┌─ Parcelle "Les Music" — 18 ha ────────────────────────────────┐
│                                                                │
│  📍 Zone 4 (15 min du siège)                                   │
│  🏷️  Fermage — 175 €/ha/an                                     │
│                                                                │
│  ── Qualité de terre ──                                        │
│  ★★★☆☆  Terre moyenne                                         │
│                                                                │
│  ── Fertilité ──                                               │
│  ████████████████░░░░  78%                                     │
│  💡 Bon niveau. Apportez de l'engrais pour maintenir.          │
│                                                                │
│  ── Culture en place ──                                        │
│  🌾 Blé tendre — Semé le 15 oct — Récolte prévue : juil.      │
│     Rendement estimé : ~68 q/ha                                │
│                                                                │
│  ── Améliorations disponibles ──                               │
│  🔧 Drainage (3 000 €/ha) → passe en Terre bonne              │
│  🧪 Amendement (200 €/ha) → fertilité +20%                    │
│                                                                │
│  ── Historique (3 dernières campagnes) ──                      │
│  2025 : Colza — 31 q/ha — Marge 720 €/ha                     │
│  2024 : Blé   — 65 q/ha — Marge 580 €/ha                     │
│  2023 : Orge  — 62 q/ha — Marge 490 €/ha                     │
│                                                                │
│  [ Fertiliser ]  [ Améliorer ]  [ Voir sur la carte ]         │
└────────────────────────────────────────────────────────────────┘
```

### 11.2 Fiche parcelle — Mode Expert (avec analyse de sol)

```
┌─ Parcelle "Les Music" — 18 ha ────────────────────────────────────────────┐
│                                                                            │
│  📍 Zone 4 │ Pente légère (4%) │ Forme régulière │ Fermage 175 €/ha       │
│  🗺️  Type de sol : Limon-argileux │ RU mesurée : 162 mm │ Drainée : Non    │
│                                                                            │
│  ══════════════════════════════════════════════════════════════════════     │
│  📋 ANALYSE DE SOL (réalisée le 12/03/2025 — valide jusqu'en 2030)        │
│  ══════════════════════════════════════════════════════════════════════     │
│                                                                            │
│  ── Éléments nutritifs (u/ha) ──                                           │
│          Valeur    Optimal     État                                         │
│  N :      92       80-120      ✅ Correct                                   │
│  P :      38       60-100      ⚠️  Carence (rendement -12%)                │
│  K :      105      80-120      ✅ Correct                                   │
│  Ca :     78       100-150     ⚠️  Faible (lié au pH bas)                  │
│  Mg :     42       30-60       ✅ Correct                                   │
│  S :      25       20-40       ✅ Correct                                   │
│                                                                            │
│  ── Indicateurs ──                                                         │
│  pH :             6,1          Optimal 6,5-7,5    ⚠️  Acide → chaulage     │
│  Matière org. :   2,1%         Optimal 2,5-3,0%   ⚠️  Faible              │
│  Structure :      Moyenne      ──────────────────  ⚠️  Semelle détectée    │
│  CEC :            12,5 meq     (sol à capacité moyenne)                    │
│                                                                            │
│  ── Bilan hydrique (campagne en cours) ──                                  │
│  RU sol :         162 mm                                                   │
│  Remplissage :    ████████████████░░░░░░  72% (117 mm)                     │
│  Besoin restant : 180 mm (floraison → récolte)                             │
│  ⚠️  Risque de stress si < 50 mm de pluie d'ici juin                      │
│                                                                            │
│  ── Recommandations ──                                                     │
│  1. Chaulage 3 t/ha amendement calcaire (180 €/ha) → pH 6,5 en 2 ans      │
│  2. Apport phosphore 60 u/ha (superphosphate, 85 €/ha) → corriger carence │
│  3. Sous-solage (80 €/ha) → casser la semelle de labour                   │
│  4. Envisager couvert CIPAN cet automne → MO +0,02%/an                    │
│  💰 Coût total correction : 345 €/ha │ Gain estimé : +180 €/ha/an         │
│                                                                            │
│  ── Historique parcellaire ──                                              │
│  2025 : Colza — 31 q/ha — N 180, P 40, K 50 apportés — Paille enfouie    │
│  2024 : Blé   — 65 q/ha — N 160, P 0, K 0 apportés — Paille exportée     │
│  2023 : Blé   — 61 q/ha — N 155, P 0, K 0 apportés — Paille exportée     │
│  📉 P en baisse depuis 3 ans (pas d'apport)                                │
│                                                                            │
│  [ Plan de fumure ]  [ Chauler ]  [ Décompacter ]  [ Drainer ]            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 12. Équilibrage final et paramètres

### 12.1 Checklist playtest

**Test recette SimAgri en mode Normal (ADR-002) — bloquant**
- [ ] Le joueur comprend la jauge de fertilité sans doc ?
- [ ] Acheter de l'engrais suffit toujours à remonter la fertilité ?
- [ ] Le drainage est un choix optionnel, jamais obligatoire ?
- [ ] Aucune parcelle ne donne un rendement nul (même sol pauvre + fertilité basse) ?
- [ ] Le joueur peut ignorer totalement le sol et rester viable ?
- [ ] Les améliorations sont des bonus, pas des prérequis ?

**Test mode Expert**
- [ ] L'analyse de sol est perçue comme utile (économie visible) ?
- [ ] Le bilan hydrique crée-t-il une tension intéressante en année sèche ?
- [ ] Le joueur peut-il compenser un sol pauvre par de bonnes pratiques ?
- [ ] Le tassement est-il perçu comme un risque gérable, pas une frustration ?
- [ ] La loi du minimum (élément limitant) est-elle intuitive avec l'affichage ?

### 12.2 Points à valider en playtest

- [ ] Écart de rendement bonne/pauvre terre ressenti comme juste (pas décourageant)
- [ ] Le fermage de sol caillouteux (90 €/ha) compense partiellement le handicap de rendement
- [ ] Le joueur qui soigne ses terres sur 5 ans voit une progression claire
- [ ] Le drainage est un moment satisfaisant (investissement → résultat visible)

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Types de sol | 3 qualités (bonne/moyenne/pauvre) | 6 types détaillés |
| Fertilité | Jauge unique 0-100% | 6 éléments (N, P, K, Ca, Mg, S) |
| pH | Non modélisé | 4,5-8,5, chaulage nécessaire |
| Matière organique | Non modélisée | 0,8-4,5%, bilan humique |
| Structure/tassement | Non modélisé | 3 niveaux, risque au passage |
| Réserve en eau | Implicite (qualité terre) | RU explicite, bilan hydrique hebdo |
| Analyse de sol | Jauge + conseil (150 €) | Tableau complet 6 éléments + pH + MO (150 €) |
| Drainage | +1 niveau qualité (3 000 €/ha) | +30-50 mm RU (3 000 €/ha) |
| Amendement | +20% jauge (200 €/ha) | Par élément, doses précises |
| Effet sécheresse | Malus global par qualité terre | Bilan hydrique, RU déterminante |
| Rendement min possible | ×0,35 (sol épuisé + sécheresse) | ×0,25 (cumul de tous les facteurs) |
| Perte définitive de la parcelle | **Impossible** | **Impossible** (mais correction très coûteuse) |
| Faillite liée au sol | **Non** | Non (mais manque à gagner important) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Ajout §3.6 Écume de sucrerie — itinéraire épandage complet | Audit couverture fonctionnelle — système 4.13 partiel |
