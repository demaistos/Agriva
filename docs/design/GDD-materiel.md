> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Système de matériel

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-materiel.md`, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`

---

## 1. Vision et gameplay loop matériel

### 1.1 Intention de design

Le matériel est **le principal poste d'investissement** et **le principal plaisir de collection** du jeu. Dans SimAgri, acheter un nouveau tracteur est un événement. C'est cette sensation qu'il faut préserver.

**Le plaisir du matériel dans SimAgri** :
1. **La collection** — voir son parc grandir, avoir « le beau matériel »
2. **La progression** — passer d'un 90 CV d'occasion à un 200 CV neuf
3. **L'optimisation** — les combinés, la maniabilité, le GPS
4. **Le social** — le concessionnaire joueur, l'achat en commun

**Le problème de SimAgri** : le matériel est un catalogue d'outils, mais **acheter plus gros ne rend pas plus productif**. La maniabilité donne un bonus de HT, mais la largeur de travail n'existe pas. Résultat : le choix du matériel est esthétique plus que stratégique.

**Ce qu'Agriva ajoute** : la largeur de travail détermine le débit de chantier. Un semoir de 6 m sème deux fois plus vite qu'un semoir de 3 m. **L'investissement devient un choix de productivité.**

### 1.2 Gameplay loop

```
┌─────────────────────────────────────────────────────────────┐
│  BOUCLE COURTE (chaque action)                              │
└─────────────────────────────────────────────────────────────┘
  Choisir la parcelle → sélectionner l'outil → voir le temps
  et le coût estimés → valider
        ↓
  Le temps dépend de : largeur × vitesse × surface × conditions
  Le coût dépend de : carburant + usure + intrants

┌─────────────────────────────────────────────────────────────┐
│  BOUCLE MOYENNE (chaque saison)                             │
└─────────────────────────────────────────────────────────────┘
  Entretien du matériel → révisions → remplacement de pièces
        ↓
  Décision : réparer ou remplacer ?

┌─────────────────────────────────────────────────────────────┐
│  BOUCLE LONGUE (chaque année)                               │
└─────────────────────────────────────────────────────────────┘
  Bilan : mon parc est-il adapté à ma surface ?
        ↓
  Décisions structurantes :
    • Acheter plus grand (gagner du temps)
    • Passer par une ETA (économiser du capital)
    • Rejoindre une CUMA (partager le coût)
    • Vendre du matériel sous-utilisé
```

### 1.3 Les décisions du joueur

| Décision | Impact Normal | Impact Expert |
|----------|:-------------:|:-------------:|
| Quelle largeur d'outil ? | Temps de travail | + coût/ha, adéquation puissance |
| Acheter ou faire appel à une ETA ? | Capital vs charge | + disponibilité en pointe |
| Neuf ou occasion ? | Prix vs fiabilité | + heures restantes, décote |
| Entretenir ou attendre ? | Risque de panne | + coût progressif, immobilisation |
| Rejoindre une CUMA ? | Coût partagé | + planning, ordre de passage |
| Investir dans le GPS ? | Bonus temps/intrants | + niveaux de précision, modulation |
| Quelle puissance de tracteur ? | Compatibilité outils | + consommation, débit réel |

### 1.4 Différence Normal / Expert

| Aspect | Normal (recette SimAgri) | Expert |
|--------|--------------------------|--------|
| **Débit de chantier** | Largeur → temps affiché, calcul auto | + vitesse variable, conditions, rendement machine |
| **Consommation** | Forfait L/ha par opération | L/h réel × durée, variable selon charge |
| **Usure** | Compteur d'heures, pannes probabilistes | + pièces d'usure détaillées, maintenance préventive |
| **Entretien** | 1 action, coût fixe, remet à neuf | Révisions programmées, coût croissant avec l'âge |
| **Pannes** | Immobilisation 1-2 jours, réparation immédiate | Délai de pièce, gravité variable, perte de fenêtre |
| **ETA** | Prestation PNJ au prix affiché | Prestataire joueur, file d'attente, contrat |
| **CUMA** | Coût divisé, disponibilité garantie | Planning de réservation, ordre de passage |
| **GPS** | 1 niveau, bonus fixe | 3 niveaux, modulation, coupure de tronçons |
| **Achat** | Neuf ou occasion, argus simple | + crédit-bail, location, enchères |
| **Adéquation puissance** | Blocage si CV insuffisants | + surconsommation si sous-dimensionné |

---

## 2. Largeur et débit de chantier

### 2.1 Principe — la mécanique centrale

C'est **l'ajout n°1 du GDD matériel**. Le temps de travail dépend désormais du matériel choisi.

```
Formule de base :

  débit (ha/h) = largeur (m) × vitesse (km/h) × 0,1 × rendement_machine

  temps (h) = surface (ha) / débit (ha/h)
```

Le facteur 0,1 convertit : 1 m × 1 km/h = 0,1 ha/h.

**Exemple** :
```
Charrue 5 corps (1,75 m) à 7 km/h, rendement 0,80
  débit = 1,75 × 7 × 0,1 × 0,80 = 0,98 ha/h
  → 18 ha = 18,4 heures

Charrue 8 corps (2,80 m) à 8 km/h, rendement 0,82
  débit = 2,80 × 8 × 0,1 × 0,82 = 1,84 ha/h
  → 18 ha = 9,8 heures  (presque 2× plus rapide)
```

### 2.2 Mode Normal — Le temps est affiché, c'est tout

Le joueur voit le temps estimé avant d'agir. Il comprend intuitivement que « plus large = plus rapide ».

```
┌─ Labourer — Les Sables (18 ha) ───────────────────┐
│                                                    │
│  Matériel disponible :                             │
│                                                    │
│  ● Charrue Kuhn 5 corps (1,75 m)                   │
│    ⏱️ 18,4 h  |  ⛽ 630 L  |  Coût : 745 €          │
│                                                    │
│  ○ Charrue Grégoire 8 corps (2,80 m)               │
│    ⏱️ 9,8 h   |  ⛽ 612 L  |  Coût : 724 €          │
│    ⚠️ Nécessite 280 CV (votre tracteur : 150 CV)   │
│                                                    │
│  💡 Une charrue plus large diviserait votre temps   │
│     de travail par 2                               │
│                                                    │
│  [ Labourer avec la 5 corps ]                      │
└────────────────────────────────────────────────────┘
```

**Vitesses et rendements fixes en Normal** (paramètres du jeu, invisibles pour le joueur) :

| Opération | Vitesse | Rendement machine |
|-----------|:-------:|:-----------------:|
| Labour | 7 km/h | 0,80 |
| Déchaumage | 10 km/h | 0,85 |
| Herse rotative | 8 km/h | 0,82 |
| Semis céréales | 10 km/h | 0,80 |
| Semis monograine | 8 km/h | 0,75 |
| Épandage engrais | 14 km/h | 0,85 |
| Pulvérisation | 12 km/h | 0,85 |
| Moisson | 5,5 km/h | 0,75 |
| Fauche | 12 km/h | 0,85 |
| Fanage | 12 km/h | 0,88 |
| Andainage | 11 km/h | 0,85 |
| Pressage | 9 km/h | 0,70 |

### 2.3 Mode Expert — Débit variable selon les conditions

```
débit_réel = largeur × vitesse_effective × 0,1 × rendement_effectif

vitesse_effective = vitesse_base × f_sol × f_relief × f_puissance
rendement_effectif = rendement_base × f_parcelle × f_operateur
```

**a) Facteur sol**
```
Sol sec et portant          : ×1,00
Sol ressuyé normal          : ×0,95
Sol humide (limite)         : ×0,80
Sol lourd argileux          : ×0,85
Sol caillouteux             : ×0,90
```

**b) Facteur relief**
```
Plaine (pente < 3%)         : ×1,00
Coteau (3-8%)               : ×0,92
Pente forte (8-15%)         : ×0,80
Montagne (> 15%)            : ×0,65
```

**c) Facteur puissance (adéquation tracteur/outil)**
```
puissance_requise = f(largeur, profondeur, type de sol)

ratio = puissance_tracteur / puissance_requise

ratio ≥ 1,25   : ×1,05  (confort, vitesse optimale)
ratio 1,00-1,25: ×1,00  (adapté)
ratio 0,85-1,00: ×0,88  (limite, vitesse réduite, surconsommation +20%)
ratio < 0,85   : blocage (impossible d'atteler)
```

**d) Facteur parcelle (géométrie)**
```
Grande parcelle rectangulaire (> 15 ha)  : ×1,00
Parcelle moyenne (5-15 ha)               : ×0,93
Petite parcelle (< 5 ha)                 : ×0,82
Forme irrégulière                        : ×0,88
Obstacles (arbres, poteaux)              : ×0,92

→ Remplace la "maniabilité" de SimAgri par un système plus lisible
→ Un outil de 12 m dans une parcelle de 3 ha perd son avantage
```

**e) Affichage Expert**
```
┌─ Labourer — Les Sables (18 ha) ─────────────────────────────┐
│                                                              │
│  Attelage : John Deere 6215R (215 CV) + Kuhn Vari-Master 5   │
│                                                              │
│  ── Calcul du débit ──                                       │
│  Largeur de travail              1,75 m                      │
│  Vitesse de base                 7,0 km/h                    │
│  × Sol ressuyé normal            ×0,95                       │
│  × Relief plaine                 ×1,00                       │
│  × Puissance (215/168 = 1,28)    ×1,05  ✅ confort           │
│  ─────────────────────────────────────                       │
│  Vitesse effective               6,98 km/h                   │
│                                                              │
│  Rendement machine de base       0,80                        │
│  × Parcelle 18 ha rectangulaire  ×1,00                       │
│  ─────────────────────────────────────                       │
│  Rendement effectif              0,80                        │
│                                                              │
│  DÉBIT                           0,98 ha/h                   │
│  TEMPS pour 18 ha                18,4 h                      │
│                                                              │
│  ── Coûts ──                                                 │
│  Carburant : 26 L/h × 18,4 h    478 L → 478 €                │
│  Usure tracteur : 18,4 h        → 22 € (amortissement)       │
│  Usure charrue : 18,4 h         → 14 € + socs 8 €            │
│  ─────────────────────────────────────                       │
│  COÛT TOTAL                     522 € = 29 €/ha              │
│  (Référence ETA : 110 €/ha)                                  │
│                                                              │
│  💡 Avec une charrue 8 corps : 9,8 h et 28 €/ha              │
│     Votre tracteur (215 CV) serait sous-dimensionné (280 CV) │
│                                                              │
│  [ Labourer ]  [ Comparer les attelages ]                    │
└──────────────────────────────────────────────────────────────┘
```

### 2.4 Catalogue de largeurs (paramétrage)

| Outil | Petit | Moyen | Grand | Très grand |
|-------|:-----:|:-----:|:-----:|:----------:|
| Charrue | 3 corps (1,05 m) | 5 corps (1,75 m) | 7 corps (2,45 m) | 9 corps (3,15 m) |
| Déchaumeur | 3 m | 4,5 m | 6 m | 8 m |
| Herse rotative | 3 m | 4 m | 5 m | 6 m |
| Semoir céréales | 3 m | 4 m | 6 m | 8 m |
| Semoir monograine | 4 rangs (3 m) | 6 rangs (4,5 m) | 8 rangs (6 m) | 12 rangs (9 m) |
| Épandeur engrais | 12 m | 18 m | 24 m | 36 m |
| Pulvérisateur | 12 m | 18 m | 28 m | 40 m |
| Moissonneuse (coupe) | 4,5 m | 6 m | 7,5 m | 10,5 m |
| Faucheuse | 2,4 m | 3,2 m | 6 m (double) | 9 m (triple) |
| Faneuse | 4,5 m | 6,5 m | 8,5 m | 11 m |
| Andaineur | 3,5 m | 6,5 m | 8,5 m | 12 m |

### 2.5 Puissance requise (règle simple)

```
Charrue        : 32 CV par corps (labour 25 cm, sol moyen)
Déchaumeur     : 28 CV par mètre
Herse rotative : 32 CV par mètre
Semoir seul    : 12 CV par mètre
Combiné H+S    : 45 CV par mètre
Épandeur       : 60 CV (fixe, indépendant de la largeur)
Pulvérisateur  : 5 CV par mètre + 40 CV (cuve pleine)
Faucheuse      : 22 CV par mètre
Presse         : 90 CV (balle ronde), 160 CV (grosse carrée)
Benne          : 15 CV par tonne de charge utile

Ajustements Expert :
  Sol lourd argileux : ×1,25
  Sol sableux        : ×0,85
  Labour profond 30cm: ×1,20
  Pente > 8%         : ×1,15
```

### 2.6 Équilibrage — dimensionnement du parc

**Question centrale du joueur** : « quelle taille de matériel pour ma surface ? »

| Surface | Tracteur principal | Charrue | Semoir | Pulvé | Moisson |
|:-------:|:-----------------:|:-------:|:------:|:-----:|:-------:|
| 50 ha | 100-120 CV | 3 corps | 3 m | 12 m | ETA |
| 100 ha | 130-150 CV | 4 corps | 4 m | 18 m | ETA ou CUMA |
| 150 ha | 160-180 CV | 5 corps | 4 m | 24 m | CUMA |
| 250 ha | 200-220 CV | 6 corps | 6 m | 28 m | Classe 6 propre |
| 400 ha | 250-300 CV | 8 corps | 8 m | 36 m | Classe 7-8 |
| 600 ha+ | 2 tracteurs 300 CV | 9 corps | 8 m | 40 m | Classe 8-9 |

**Indicateur affiché au joueur (les deux modes)** :
```
┌─ Adéquation de mon parc ──────────────────────────┐
│  Surface exploitée : 145 ha                        │
│                                                    │
│  Tracteur (150 CV)      ✅ Adapté                  │
│  Charrue (5 corps)      ✅ Adapté                  │
│  Semoir (3 m)           ⚠️ Sous-dimensionné        │
│    → 48 h de semis (un 4 m ferait 36 h)            │
│  Pulvérisateur (18 m)   ✅ Adapté                  │
│  Moissonneuse           ❌ Absente → ETA (110 €/ha)│
│                                                    │
│  Coût de mécanisation : 385 €/ha                   │
│  Référence pour 145 ha : 350-450 €/ha ✅            │
└────────────────────────────────────────────────────┘
```


---

## 3. Consommation et coûts d'usage

### 3.1 Intention de design

Dans SimAgri, la consommation suit une formule abstraite (L/CV/HT) que personne ne comprend intuitivement. Dans Agriva, on utilise **des litres par heure** — l'unité que tout agriculteur connaît.

Objectif : le joueur doit comprendre que **labourer coûte cher en carburant, semer coûte peu**. Cela oriente le choix labour vs TCS.

### 3.2 Mode Normal — Forfait par opération

```
carburant = consommation_par_ha × surface

Le joueur voit directement : "630 L pour 18 ha"
```

**Table de consommation (L/ha)** :

| Opération | Conso (L/ha) | Coût à 1,00 €/L |
|-----------|:------------:|:---------------:|
| Labour | 32 | 32 €/ha |
| Déchaumage | 12 | 12 €/ha |
| Herse rotative | 14 | 14 €/ha |
| Semis (combiné herse+semoir) | 18 | 18 €/ha |
| Semis seul | 6 | 6 €/ha |
| Semis direct | 8 | 8 €/ha |
| Épandage engrais | 4 | 4 €/ha |
| Pulvérisation | 5 | 5 €/ha |
| Moisson céréales | 26 | 26 €/ha |
| Moisson maïs | 32 | 32 €/ha |
| Ensilage maïs | 45 | 45 €/ha |
| Arrachage betterave | 55 | 55 €/ha |
| Fauche | 10 | 10 €/ha |
| Fanage | 6 | 6 €/ha |
| Andainage | 6 | 6 €/ha |
| Pressage (par balle) | 0,8 L/balle | — |
| Transport (par trajet) | 12 L/trajet | — |

**Comparaison des itinéraires (le joueur peut le voir)** :
```
┌─ Coût carburant par itinéraire — blé, 18 ha ──────┐
│                                                    │
│  LABOUR (traditionnel)                             │
│    Labour 32 + Herse 14 + Semis 6                  │
│    + Engrais 4 + Pulvé 5×2 + Moisson 26            │
│    = 92 L/ha → 1 656 L → 1 656 €                   │
│                                                    │
│  TCS                                               │
│    Déchaumage 12×2 + Semis combiné 18              │
│    + Engrais 4 + Pulvé 5×2 + Moisson 26            │
│    = 82 L/ha → 1 476 L → 1 476 €  (-11%)           │
│                                                    │
│  SEMIS DIRECT                                      │
│    Semis direct 8 + Engrais 4                      │
│    + Pulvé 5×3 + Moisson 26                        │
│    = 53 L/ha → 954 L → 954 €  (-42%)               │
│                                                    │
│  💡 Le semis direct économise 702 € de carburant   │
│     mais réduit le rendement de 6%                 │
│     (soit -1 100 € de recette) → moins rentable    │
└────────────────────────────────────────────────────┘
```

### 3.3 Mode Expert — L/h selon la charge moteur

```
carburant = consommation_horaire × temps_travail

consommation_horaire = puissance_CV × conso_spécifique × taux_charge
  conso_spécifique = 0,22 L/CV/h (moteur moderne Stage V)
  
taux_charge selon l'opération :
  Labour, sous-solage           : 0,85-0,95  (moteur à pleine charge)
  Déchaumage, herse rotative    : 0,70-0,80
  Semis, épandage               : 0,45-0,55
  Pulvérisation                 : 0,35-0,45
  Transport à vide              : 0,25-0,35
  Transport chargé              : 0,50-0,65
  Ralenti / manœuvres           : 0,15
```

**Exemple** :
```
Tracteur 215 CV, labour (taux de charge 0,88)
  conso_horaire = 215 × 0,22 × 0,88 = 41,6 L/h
  temps = 18,4 h
  carburant = 765 L → 765 €

Le même tracteur en pulvérisation (taux de charge 0,40)
  conso_horaire = 215 × 0,22 × 0,40 = 18,9 L/h
```

**Surconsommation si sous-dimensionné (Expert)** :
```
Si ratio puissance/besoin < 1,00 :
  surconsommation = +20 à +35%
  (le moteur travaille en surrégime, mauvais rendement)

→ Un tracteur trop petit consomme PLUS pour faire MOINS
→ Incite à un dimensionnement correct
```

**Prix du carburant (les deux modes)** :
```
GNR (Gazole Non Routier) : 0,95 €/L (base)
  Variation : ±25% selon les cours pétroliers (Expert)
  
HVC (bio-carburant produit par méthanisation) : 0,55 €/L
  → Le joueur qui a un méthaniseur économise 40% sur son carburant
  → Reprise de l'idée SimAgri (excellente)
```

### 3.4 Coût de possession complet (Expert)

```
coût_horaire_total = carburant + amortissement + entretien + réparations

Exemple — tracteur 215 CV acheté 180 000 €, 700 h/an, durée 12 ans :

  Carburant (moyenne 30 L/h)            30,00 €/h
  Amortissement (180 000 / 8 400 h)     21,43 €/h
  Entretien programmé                    4,50 €/h
  Réparations imprévues (provision)      3,20 €/h
  Assurance                              1,80 €/h
  ─────────────────────────────────────────────
  COÛT HORAIRE TOTAL                    60,93 €/h

Pour 18,4 h de labour : 1 121 € = 62 €/ha
  → à comparer avec le tarif ETA de 110 €/ha
  → conclusion : posséder est plus économique SI le matériel est assez utilisé
```

**Seuil de rentabilité de la possession (affiché au joueur en Expert)** :
```
┌─ Rentabilité de mes équipements ──────────────────────────┐
│                                                            │
│  Charrue Kuhn 5 corps (achetée 32 000 €)                   │
│    Utilisation : 145 ha/an → 148 h/an                      │
│    Coût de possession : 28 €/ha                            │
│    Tarif ETA équivalent : 110 €/ha                         │
│    ✅ RENTABLE (économie 11 890 €/an)                       │
│                                                            │
│  Presse balle ronde (achetée 42 000 €)                     │
│    Utilisation : 280 balles/an → 12 h/an                   │
│    Coût de possession : 24 €/balle                         │
│    Tarif ETA équivalent : 11 €/balle                       │
│    ❌ NON RENTABLE (surcoût 3 640 €/an)                     │
│    💡 Piste : faire du travail pour d'autres joueurs        │
│       (il faudrait 700 balles/an pour être rentable)       │
│                                                            │
│  Moissonneuse (non possédée)                               │
│    ETA : 145 ha × 110 € = 15 950 €/an                      │
│    Achat classe 6 (400 000 €) : 48 000 €/an de charges     │
│    ✅ L'ETA reste plus économique jusqu'à 380 ha            │
└────────────────────────────────────────────────────────────┘
```

---

## 4. Usure, pannes et entretien

### 4.1 Compteur d'heures (les deux modes)

**Remplace le système de pourcentage d'usure de SimAgri** — plus intuitif :

```
Chaque matériel a :
  heures_totales    : compteur cumulé (comme un vrai compteur)
  heures_de_vie     : durée de vie théorique
  état              : heures_totales / heures_de_vie
```

**Durées de vie (paramétrage)** :

| Matériel | Heures de vie | Équivalent |
|----------|:-------------:|------------|
| Tracteur | 10 000 h | 12-15 ans à 700 h/an |
| Moissonneuse | 4 000 h | 12 ans à 330 h/an |
| Ensileuse | 5 000 h | 10 ans |
| Télescopique | 9 000 h | 12 ans |
| Charrue | 3 000 h | 20 ans |
| Déchaumeur | 2 500 h | 15 ans |
| Semoir | 2 000 h | 15 ans |
| Pulvérisateur | 2 500 h | 12 ans |
| Presse | 1 800 h ou 40 000 balles | 12 ans |
| Faucheuse | 1 500 h | 12 ans |
| Benne, plateau | 5 000 h | 25 ans |

### 4.2 Mode Normal — Entretien simple

```
Paliers d'état :
  0-50% des heures    : ✅ Bon état, pas de panne
  50-75%              : 🟡 Usé, 2% de risque de panne/mois
  75-90%              : 🟠 Très usé, 5% de risque/mois, -5% de débit
  90-100%             : 🔴 En fin de vie, 12% de risque/mois, -12% de débit
  100%+               : ⚫ Hors service (réparation majeure ou remplacement)
```

**Action « Entretenir »** :
```
┌─ Entretenir — Tracteur JD 6215R ──────────────────┐
│                                                    │
│  Compteur : 5 240 h / 10 000 h (52%)  🟡           │
│  Dernier entretien : il y a 480 h                  │
│                                                    │
│  Entretien complet :                               │
│    Vidange + filtres + graissage                   │
│    Coût : 720 €                                    │
│    ⏱️ Temps : 2 h                                  │
│    Effet : remise à zéro du risque de panne        │
│            pour 500 h                              │
│                                                    │
│  [ Entretenir ]  [ Faire faire (concession, 950 €) ]│
└────────────────────────────────────────────────────┘
```

**Pannes en Normal** :
```
Si panne :
  Immobilisation : 1-2 jours
  Coût réparation : 2 à 5% de la valeur du matériel
  Si assuré : réparation gratuite
  
Le joueur n'est jamais bloqué longtemps (ADR-002).
```

### 4.3 Mode Expert — Maintenance programmée et pièces d'usure

**a) Échéances d'entretien**
```
TRACTEUR
  Toutes les 250 h  : graissage + contrôles         → 80 €, 0,5 h
  Toutes les 500 h  : vidange moteur + filtres      → 380 €, 2 h
  Toutes les 1000 h : vidange transmission + hydro  → 850 €, 3 h
  Toutes les 2000 h : révision complète             → 2 400 €, 1 jour (concession)

Si une échéance est dépassée de plus de 20% :
  → risque de panne ×3
  → usure accélérée ×1,3
```

**b) Pièces d'usure**

| Pièce | Matériel | Durée | Coût |
|-------|----------|:-----:|:----:|
| Pneus avant | Tracteur | 4 000 h | 1 800 € |
| Pneus arrière | Tracteur | 3 500 h | 4 200 € |
| Socs | Charrue | 400 ha | 850 € |
| Disques | Déchaumeur | 800 ha | 1 200 € |
| Dents | Herse rotative | 600 ha | 950 € |
| Couteaux | Faucheuse | 500 ha | 480 € |
| Buses | Pulvérisateur | 3 ans | 320 € |
| Courroies | Moissonneuse | 800 h | 1 400 € |
| Batteur/contre-batteur | Moissonneuse | 2 000 h | 3 800 € |
| Chaînes | Presse | 15 000 balles | 900 € |

```
Si une pièce d'usure atteint 100% :
  → performance dégradée (-15% de débit, +20% de consommation)
Si elle atteint 130% :
  → matériel inutilisable jusqu'au remplacement
```

**c) Gravité des pannes (Expert)**

| Gravité | Probabilité | Immobilisation | Coût | Délai pièce |
|---------|:-----------:|:--------------:|:----:|:-----------:|
| Mineure | 60% | 2-6 h | 150-600 € | Immédiat |
| Moyenne | 30% | 1-2 jours | 800-3 000 € | 1 jour |
| Majeure | 8% | 3-7 jours | 4 000-12 000 € | 2-5 jours |
| Critique (moteur, boîte) | 2% | 1-3 semaines | 15 000-35 000 € | 1-2 semaines |

**Le vrai risque en Expert** : une panne majeure **en pleine moisson** peut faire perdre la fenêtre de récolte.

```
┌─ ⚠️ PANNE — Moissonneuse Claas Lexion ────────────┐
│                                                    │
│  🔴 Panne majeure : rupture du variateur de batteur│
│                                                    │
│  Diagnostic : 3 200 € de pièces + 6 h de MO         │
│  Pièce disponible : sous 3 jours (concession)       │
│  Immobilisation estimée : 4 jours                   │
│                                                    │
│  ⚠️ CONSÉQUENCE : 62 ha de blé non récoltés         │
│     Météo prévue : pluie dans 2 jours (25 mm)       │
│     Risque de germination sur pied : -25% de valeur │
│                                                    │
│  ── Solutions ──                                    │
│  1. Attendre la réparation (4 j) → perte estimée 8 400 € │
│  2. Faire moissonner par une ETA (110 €/ha = 6 820 €) │
│     ⚠️ ETA disponible dans 2 jours seulement         │
│  3. Louer une moissonneuse (concession, 1 400 €/j)  │
│  4. Demander de l'aide à un joueur voisin          │
│                                                    │
│  💡 Votre assurance bris de machine couvre 2 880 €  │
│                                                    │
│  [ Voir les ETA ]  [ Louer ]  [ Attendre ]         │
└────────────────────────────────────────────────────┘
```

**Ce moment de crise est le cœur du gameplay Expert** : il oblige à improviser, à utiliser le réseau social, à évaluer les coûts.

### 4.4 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Compteur | Heures | Heures + pièces d'usure |
| Entretien | 1 action, 500 h d'effet | 4 échéances programmées |
| Coût entretien annuel | ~2% de la valeur | 2,5-4% (croissant avec l'âge) |
| Probabilité de panne | 0-12%/mois selon l'état | Idem + ×3 si entretien négligé |
| Gravité des pannes | Uniforme (1-2 jours) | 4 niveaux (2 h à 3 semaines) |
| Délai de pièce | Aucun | 0 à 14 jours |
| Perte de fenêtre | Rare | Possible et impactante |
| Dégradation performance | -5 à -12% | -15% si pièce HS |
| Assurance | Couvre tout | Franchise + plafond |

### 4.5 Système de pièces détachées — Seuils et alertes

Le remplacement de pièces d'usure est déclenché par un **seuil d'utilisation** (en heures ou hectares). Le joueur reçoit des alertes progressives et doit planifier le remplacement.

#### Seuils de remplacement et temps de travail (ADR-004)

| Pièce | Seuil d'alerte (%) | Seuil critique (%) | Hors-service (%) | Temps remplacement | Outillage requis |
|-------|:-------------------:|:------------------:|:-----------------:|:------------------:|:----------------:|
| Pneus avant (tracteur) | 75% (3 000 h) | 90% (3 600 h) | 100% (4 000 h) | 1 h 30 | Cric + clé |
| Pneus arrière (tracteur) | 75% (2 625 h) | 90% (3 150 h) | 100% (3 500 h) | 2 h 00 | Cric + clé |
| Socs (charrue) | 70% (280 ha) | 90% (360 ha) | 100% (400 ha) | 1 h 00 | Clé plate |
| Disques (déchaumeur) | 70% (560 ha) | 90% (720 ha) | 100% (800 ha) | 1 h 30 | Clé + maillet |
| Dents (herse rotative) | 70% (420 ha) | 90% (540 ha) | 100% (600 ha) | 2 h 00 | Clé à choc |
| Couteaux (faucheuse) | 70% (350 ha) | 85% (425 ha) | 100% (500 ha) | 0 h 45 | Clé + tournevis |
| Buses (pulvérisateur) | 80% (2,4 ans) | 95% (2,85 ans) | 100% (3 ans) | 0 h 30 | Clé buse |
| Courroies (moissonneuse) | 75% (600 h) | 90% (720 h) | 100% (800 h) | 3 h 00 | Outillage spécialisé |
| Batteur (moissonneuse) | 80% (1 600 h) | 95% (1 900 h) | 100% (2 000 h) | 6 h 00 | Outillage spécialisé |
| Chaînes (presse) | 70% (10 500 b.) | 90% (13 500 b.) | 100% (15 000 b.) | 2 h 30 | Outillage spécialisé |

#### Système d'alertes

```
┌─ Alertes pièces d'usure ──────────────────────────────────────┐
│                                                                │
│  SEUIL ALERTE (jaune) :                                        │
│    "💡 Les socs de votre charrue Kuhn sont usés à 75%.         │
│     Remplacement recommandé avant la prochaine campagne.       │
│     Coût : 850 € | Temps : 1 h | Stock concessionnaire : ✅"   │
│                                                                │
│  SEUIL CRITIQUE (orange) :                                     │
│    "⚠️ Socs à 92% d'usure ! Performance dégradée (-15%).       │
│     Risque de casse imminente. Remplacer dans les 48h.         │
│     [ Commander la pièce ]  [ Remplacer maintenant ]"          │
│                                                                │
│  HORS-SERVICE (rouge) :                                        │
│    "🔴 Socs HS — Charrue INUTILISABLE.                         │
│     Remplacement obligatoire avant toute utilisation.          │
│     Pièce en stock chez le concessionnaire : OUI               │
│     Délai : immédiat | Coût : 850 € + 1 h de travail"         │
└────────────────────────────────────────────────────────────────┘
```

#### Approvisionnement en pièces

| Source | Disponibilité | Délai | Surcoût |
|--------|:-------------:|:-----:|:-------:|
| Stock joueur (préacheté) | Si en stock | Immédiat | 0% |
| Concessionnaire joueur (local) | 85% des pièces | 0-1 jour | +5% |
| Concessionnaire PNJ | 100% des pièces | 1-3 jours | +10% |
| Commande spéciale (pièce rare) | Batteur, variateur | 5-14 jours | +0% |

**Mode Normal** : alerte claire, pièce toujours disponible immédiatement chez le concessionnaire PNJ. Le joueur ne peut pas oublier (rappel persistant). Pas de matériel hors-service sauf si le joueur ignore l'alerte critique pendant 7+ jours.

**Mode Expert** : le joueur doit anticiper (acheter à l'avance). Les pièces rares ont un vrai délai. Un matériel hors-service en pleine saison = perte de fenêtre.

#### Impact économique des pièces

```
Coût annuel pièces d'usure (exploitation 145 ha, parc complet) :
  Socs charrue (145 ha/400 ha cycle)      : 850 × 0,36 = 306 €/an
  Disques déchaumeur (145 ha/800 ha)      : 1 200 × 0,18 = 216 €/an
  Dents herse (145 ha/600 ha)             : 950 × 0,24 = 228 €/an
  Couteaux fauche (80 ha fourrages/500 ha): 480 × 0,16 = 77 €/an
  Courroies moissonneuse (330 h/800 h)    : 1 400 × 0,41 = 574 €/an
  Buses pulvérisateur (1 an/3 ans)        : 320 × 0,33 = 107 €/an
  ─────────────────────────────────────────────────────────
  TOTAL PIÈCES D'USURE ANNUEL             ≈ 1 508 €/an (10,4 €/ha)
```

### 4.6 Assurance matériel

Le joueur peut souscrire une assurance « bris de machine » pour se protéger contre les pannes majeures et critiques.

#### Formules d'assurance

| Formule | Prime annuelle | Couverture | Franchise | Condition |
|---------|:--------------:|:----------:|:---------:|-----------|
| Essentielle | 1,2% de la valeur du parc | Pannes majeures + critiques | 1 500 € | Entretien à jour |
| Confort | 1,8% de la valeur du parc | Toutes pannes (mineures incluses) | 500 € | Entretien à jour |
| Tous risques | 2,5% de la valeur du parc | Pannes + vol + incendie + intempéries | 300 € | Aucune |

#### Mécanique de souscription

| Paramètre | Valeur |
|-----------|--------|
| Souscription | Annuelle, renouvelée tacitement chaque 1er janvier |
| Résiliation | Possible à tout moment, effet fin de mois en cours |
| Condition d'entretien | Si entretien en retard > 20%, l'assurance refuse la prise en charge |
| Plafond annuel (Essentielle/Confort) | 2× la prime annuelle |
| Plafond annuel (Tous risques) | 4× la prime annuelle |
| Délai indemnisation | Immédiat (paiement au moment de la réparation) |

#### Exemple chiffré

```
Parc matériel : 558 000 € de valeur assurable

Formule Essentielle : 558 000 × 1,2% = 6 696 €/an
  → Couvre les pannes > 1 500 € (majeure : 4 000-12 000 € ; critique : 15 000-35 000 €)
  → Plafond : 13 392 €/an

Espérance de panne/an (145 ha, parc moyen) :
  Majeures : 0,8 × 8 000 € = 6 400 €
  Critiques : 0,1 × 25 000 € = 2 500 €
  Total attendu : 8 900 €/an → l'assurance est rentable à partir de 150 ha

En Normal : l'assurance "couvre tout" par défaut (comportement simplifié).
En Expert : choix de formule, franchise réelle, condition d'entretien vérifiée.
```


---

## 5. ETA et prestation

### 5.1 Intention de design

C'est **l'ajout n°2 du GDD matériel** (après la largeur). L'ETA change fondamentalement l'économie du jeu : le joueur n'est plus obligé d'acheter une moissonneuse à 400 000 € pour récolter 80 ha.

**Trois bénéfices de gameplay** :
1. **Accessibilité** — un débutant peut cultiver 100 ha sans parc matériel complet
2. **Choix stratégique** — capital immobilisé vs charge variable
3. **Social** — les joueurs équipés peuvent prester pour les autres (revenu additionnel)

### 5.2 Mode Normal — Prestation PNJ au tarif affiché

```
┌─ Moissonner — Les Sables (18 ha) ─────────────────┐
│                                                    │
│  ❌ Vous n'avez pas de moissonneuse                │
│                                                    │
│  ── Options ──                                     │
│                                                    │
│  🚜 Faire appel à une ETA                          │
│     Tarif : 110 €/ha → 1 980 €                     │
│     Délai : 2 jours                                │
│     ⏱️ Votre temps : 0 h (l'ETA fait tout)         │
│     ✅ Disponible                                   │
│                                                    │
│  👤 Prestataires joueurs (2 disponibles)           │
│     • Ferme des Trois Chênes : 95 €/ha (1 710 €)   │
│       Délai : 3 jours — ⭐ 4,8/5 (12 prestations)   │
│     • GAEC du Moulin : 105 €/ha (1 890 €)          │
│       Délai : 1 jour — ⭐ 4,5/5 (8 prestations)      │
│                                                    │
│  🛒 Acheter une moissonneuse                       │
│     À partir de 185 000 € (occasion classe 5)      │
│     💡 Rentable à partir de 380 ha/an              │
│                                                    │
│  [ Commander à l'ETA ]  [ Voir les joueurs ]       │
└────────────────────────────────────────────────────┘
```

**Tarifs ETA de référence (PNJ, toujours disponible)** :

| Prestation | Tarif |
|-----------|:-----:|
| Labour | 110 €/ha |
| Déchaumage | 45 €/ha |
| Herse rotative | 50 €/ha |
| Semis céréales (combiné) | 75 €/ha |
| Semis monograine | 65 €/ha |
| Épandage engrais | 18 €/ha |
| Pulvérisation | 20 €/ha |
| Moisson céréales | 110 €/ha |
| Moisson maïs | 145 €/ha |
| Ensilage maïs (avec charroi) | 48 €/t MS |
| Arrachage betterave | 250 €/ha |
| Arrachage PDT | 380 €/ha |
| Fauche | 50 €/ha |
| Pressage balle ronde | 11 €/balle |
| Pressage grosse carrée | 13 €/balle |
| Enrubannage | 8 €/balle |
| Épandage fumier | 7 €/t |
| Épandage lisier | 4 €/m³ |

**Principe Normal** : l'ETA PNJ est **toujours disponible** sous 1-3 jours. Le joueur n'est jamais bloqué (ADR-002).

### 5.3 Mode Expert — Prestataires joueurs, file d'attente, contrats

**a) Devenir prestataire (joueur)**
```
Conditions : posséder le matériel + avoir du temps de travail disponible

Le joueur publie son offre :
┌─ Proposer mes services ───────────────────────────┐
│  Prestation : Moisson céréales                     │
│  Matériel : Claas Lexion 5300 (6 m)                │
│  Tarif : [___105___] €/ha                          │
│  Zone d'intervention : [ Ma zone + 2 zones ▼ ]     │
│  Capacité max : [___250___] ha/campagne            │
│  Délai d'intervention : [___2___] jours            │
│                                                    │
│  💡 Tarif moyen du serveur : 108 €/ha              │
│     Votre coût de revient : 62 €/ha                │
│     Marge estimée : 43 €/ha                        │
│                                                    │
│  [ Publier l'offre ]                               │
└────────────────────────────────────────────────────┘
```

**b) File d'attente en période de pointe**
```
En moisson, tous les joueurs veulent récolter en même temps :

capacité_ETA = débit_machine × heures_disponibles_par_jour

Exemple : moissonneuse 6 m, 4,8 ha/h, 12 h/jour = 58 ha/jour
  → 10 clients de 50 ha chacun = 500 ha = 9 jours de travail

Le prestataire priorise :
  1. Contrats annuels signés (priorité absolue)
  2. Ordre de commande (premier arrivé)
  3. Proximité géographique (moins de déplacement)

→ Le client qui commande tard attend → risque de perdre sa fenêtre
```

**c) Contrats annuels (Expert)**
```
Le client peut sécuriser sa prestation à l'avance :

┌─ Contrat de prestation annuel ────────────────────┐
│  Prestataire : Ferme des Trois Chênes              │
│  Prestation : Moisson 145 ha                       │
│  Tarif contractuel : 102 €/ha (au lieu de 110)     │
│  Priorité : Garantie (intervention sous 2 j)       │
│  Engagement : 1 an, renouvelable                   │
│                                                    │
│  ✅ Avantages client : -8% de tarif, priorité       │
│  ✅ Avantages prestataire : volume garanti          │
│  ⚠️ Pénalité si le client annule : 15 €/ha          │
│  ⚠️ Pénalité si le prestataire fait défaut : 25 €/ha│
│                                                    │
│  [ Signer ]                                        │
└────────────────────────────────────────────────────┘
```

**d) Réputation (Expert)**
```
Chaque prestataire a une note (1-5 étoiles) basée sur :
  + Respect des délais annoncés
  + Volume réalisé sans incident
  - Retards
  - Annulations

Effet : les prestataires bien notés attirent plus de clients
        et peuvent facturer 5-10% plus cher
```

**e) Qualité de prestation (Expert)**
```
qualité_prestation = f(état_matériel, expérience_prestataire)

Effet sur le résultat du client :
  Excellente : pertes récolte 1,5%, travail impeccable
  Bonne      : pertes 2,5% (référence)
  Moyenne    : pertes 4%, qualité de travail dégradée (-2% rendement)

→ Le client a intérêt à choisir un bon prestataire, pas juste le moins cher
```

### 5.4 Équilibrage ETA

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| ETA PNJ disponible | ✅ Toujours (1-3 j) | ✅ Mais tarif +15% vs joueurs |
| Prestataires joueurs | ✅ Visibles, prix libre | ✅ + réputation, capacité, délais |
| File d'attente | Non | Oui (pointe = tension) |
| Contrats annuels | Non | Oui (-8% tarif, priorité) |
| Qualité de prestation | Uniforme | Variable selon prestataire |
| Marge prestataire | ~40% | 30-50% selon coût de revient |
| Blocage possible | Jamais | Oui si commandé trop tard |

**Point clé** : en Normal, l'ETA est un **filet de sécurité** (toujours dispo). En Expert, c'est une **ressource limitée** qu'il faut réserver.

---

## 6. CUMA et matériel partagé

### 6.1 Intention de design

La CUMA est **la mécanique sociale la plus puissante** du monde agricole réel : 1 exploitation sur 2 est adhérente, et cela divise les coûts par 3 à 5.

Dans le jeu, elle permet aux joueurs de **mutualiser du matériel coûteux** qu'aucun n'utiliserait assez seul.

SimAgri a un « achat en commun » (5 joueurs max) mais sans gestion de planning. On garde l'idée et on l'enrichit.

### 6.2 Mode Normal — Achat en commun simple

```
┌─ Créer un achat en commun ────────────────────────┐
│                                                    │
│  Matériel : Moissonneuse Claas Lexion 6 m          │
│  Prix : 320 000 €                                  │
│                                                    │
│  Participants (max 5) :                            │
│  ● Moi                        40%  →  128 000 €    │
│  ● Ferme des Trois Chênes     30%  →   96 000 €    │
│  ● GAEC du Moulin             30%  →   96 000 €    │
│  ○ [ Inviter un joueur ]                           │
│                                                    │
│  Règles :                                          │
│  • Chacun paie sa part à l'achat                   │
│  • Frais partagés au prorata de l'utilisation      │
│  • Priorité d'usage : au tour de rôle              │
│  • Revente : accord de tous les participants       │
│                                                    │
│  💡 Votre coût pour 145 ha : 128 000 € d'apport    │
│     + 2 900 €/an de frais (au lieu de 48 000 €/an  │
│     en achat seul)                                 │
│                                                    │
│  [ Proposer l'achat groupé ]                       │
└────────────────────────────────────────────────────┘
```

**Disponibilité en Normal** : le matériel partagé est **toujours disponible** quand le joueur en a besoin (pas de conflit géré). Simplification volontaire (ADR-002).

### 6.3 Mode Expert — CUMA avec planning

**a) Structure CUMA**
```
Une CUMA est une entité collective :
  - 3 à 20 adhérents
  - Un ou plusieurs matériels
  - Un budget commun (cotisations)
  - Un planning de réservation
  - Un responsable élu (gère le planning, les litiges)
```

**b) Modèle économique**
```
À l'adhésion :
  Parts sociales : 5-15% de la valeur du matériel (récupérables en partant)

Chaque année :
  Cotisation fixe : couvre l'amortissement (part égale ou au prorata surface)
  Facturation à l'usage : €/ha ou €/h utilisé
    → couvre carburant, entretien, réparations

Exemple — CUMA moissonneuse (8 adhérents, 1 200 ha au total) :
  Machine : 380 000 €, financée par emprunt CUMA sur 8 ans
  Annuité : 54 000 €/an
  Frais d'exploitation : 22 000 €/an
  ──────────────────────────────
  Coût total : 76 000 €/an pour 1 200 ha = 63 €/ha
  
  → Un adhérent de 145 ha paie 9 135 €/an
  → vs ETA (110 €/ha) : 15 950 €/an
  → vs achat seul : 48 000 €/an
  → Économie : 6 815 €/an vs ETA, 38 865 €/an vs achat seul ✅
```

**c) Planning de réservation**
```
┌─ CUMA du Val — Planning moissonneuse ─────────────────────────┐
│                                                                │
│  Juillet 2027                                                  │
│  ─────────────────────────────────────────────────             │
│  Lun 5  │ Ferme Trois Chênes  │ 48 ha │ ✅ Terminé             │
│  Mar 6  │ Ferme Trois Chênes  │ 32 ha │ ✅ Terminé             │
│  Mer 7  │ GAEC du Moulin      │ 55 ha │ 🔄 En cours           │
│  Jeu 8  │ GAEC du Moulin      │ 40 ha │ 📅 Réservé            │
│  Ven 9  │ MOI                 │ 58 ha │ 📅 Réservé            │
│  Sam 10 │ MOI                 │ 45 ha │ 📅 Réservé            │
│  Dim 11 │ — (repos)           │       │                        │
│  Lun 12 │ Ferme du Bois       │ 62 ha │ 📅 Réservé            │
│                                                                │
│  ⚠️ Météo : pluie annoncée jeudi 8 (18 mm)                      │
│     → Le planning risque de décaler de 1-2 jours                │
│     → Votre créneau pourrait passer au dimanche 11              │
│                                                                │
│  ── Ordre de priorité de la CUMA ──                            │
│  Rotation annuelle : cette année vous êtes 3e sur 8             │
│  (l'an prochain vous serez 1er)                                │
│                                                                │
│  [ Modifier ma réservation ]  [ Échanger avec un adhérent ]     │
└────────────────────────────────────────────────────────────────┘
```

**d) Tension de gameplay (Expert)**
```
Le risque CUMA : si la météo se dégrade, tous les adhérents
veulent la machine en même temps.

Mécaniques de résolution :
  • Ordre de priorité tournant (équitable sur plusieurs années)
  • Échange de créneaux entre adhérents (négociation sociale)
  • Location d'une machine d'appoint (frais partagés)
  • Appel à une ETA en complément

→ Crée de l'interaction entre joueurs (l'objectif !)
```

**e) Matériels typiquement en CUMA**

| Matériel | Pertinence CUMA | Raison |
|----------|:---------------:|--------|
| Moissonneuse | ★★★★★ | Très cher, utilisé 3 semaines/an |
| Ensileuse | ★★★★★ | Très cher, 2 semaines/an |
| Arracheuse betterave | ★★★★★ | Très cher, très spécialisé |
| Presse grosse carrée | ★★★★☆ | Cher, usage saisonnier |
| Semoir monograine | ★★★★☆ | Cher, 2 semaines/an |
| Tonne à lisier + pendillards | ★★★★☆ | Cher, usage ponctuel |
| Sous-soleuse | ★★★★☆ | Usage tous les 3-5 ans |
| Épandeur à fumier | ★★★☆☆ | Usage ponctuel |
| Tracteur | ★★☆☆☆ | Usage quotidien → possession préférable |
| Charrue | ★☆☆☆☆ | Usage étalé, pas cher |

### 6.4 Équilibrage CUMA

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Nombre max de participants | 5 | 20 |
| Planning | Non (toujours dispo) | Oui, avec conflits possibles |
| Cotisation annuelle | Frais au prorata | Parts sociales + cotisation + usage |
| Ordre de priorité | Aucun | Rotation annuelle équitable |
| Conflit météo | Non | Oui (tension sociale) |
| Sortie de la CUMA | Libre | Préavis 1 an, remboursement des parts |
| Économie vs achat seul | -70% | -75 à -80% |
| Économie vs ETA | -20% | -25 à -40% |


---

## 7. Achat, occasion et financement

### 7.1 Canaux d'acquisition

| Canal | Prix | Garantie | Mode |
|-------|:----:|:--------:|:----:|
| **Neuf (concession PNJ)** | Prix catalogue | 2 ans (0 panne) | N+E |
| **Neuf (concession joueur)** | Prix négocié (-5 à -12%) | 2 ans | N+E |
| **Occasion (concession)** | Argus +8% | 6 mois | N+E |
| **Occasion (entre joueurs)** | Prix libre | Aucune | N+E |
| **Location courte durée** | 1,2-1,8% de la valeur/jour | — | E |
| **Crédit-bail** | Loyer mensuel 1,4% de la valeur | 2 ans | E |
| **Enchères** | Variable (-15 à +5% vs argus) | Aucune | E |

### 7.2 Calcul de l'argus (les deux modes)

```
valeur_argus = prix_neuf × f_âge × f_heures × f_état

f_âge :
  Année 1  : 0,80    (forte décote initiale)
  Année 2  : 0,70
  Année 3  : 0,63
  Année 5  : 0,50
  Année 8  : 0,34
  Année 12 : 0,20
  Année 15+: 0,12

f_heures = 1 - (heures_utilisées / heures_de_vie) × 0,35

f_état (Expert seulement) :
  Entretien à jour, pièces neuves     : 1,08
  Entretien correct                   : 1,00
  Entretien négligé                   : 0,88
  Pièces d'usure à remplacer          : 0,78
```

**Exemple** :
```
Tracteur 215 CV, prix neuf 180 000 €, 5 ans, 3 800 h, bien entretenu

f_âge (5 ans)     : 0,50
f_heures          : 1 - (3800/10000) × 0,35 = 0,867
f_état            : 1,00
─────────────────────────────
Argus : 180 000 × 0,50 × 0,867 = 78 030 €
```

### 7.3 Mode Normal — Achat comptant ou emprunt simple

```
┌─ Acheter — Tracteur John Deere 6155M (155 CV) ────┐
│                                                    │
│  Prix neuf : 132 000 €                             │
│  Votre solde : 84 320 €                            │
│                                                    │
│  ○ Payer comptant           ❌ Solde insuffisant   │
│                                                    │
│  ● Emprunt sur 7 ans à 4,2%                        │
│    Apport : 20 000 €                               │
│    Mensualité : 1 495 €/mois                       │
│    Coût total du crédit : 13 580 €                 │
│                                                    │
│  ○ Occasion équivalente (2019, 4 200 h)            │
│    Prix : 68 000 € — Garantie 6 mois               │
│                                                    │
│  💡 Ce tracteur vous permettrait d'utiliser une     │
│     charrue 5 corps (au lieu de 4) : -22% de temps │
│                                                    │
│  [ Emprunter ]  [ Voir les occasions ]             │
└────────────────────────────────────────────────────┘
```

### 7.4 Mode Expert — Financement et arbitrages

**a) Crédit-bail (leasing)**
```
Principe : le joueur loue avec option d'achat. Pas de capital immobilisé.

Loyer mensuel : 1,4% de la valeur du bien
Durée : 3 à 7 ans
Option d'achat finale : 5-15% de la valeur initiale

Exemple — tracteur 132 000 € sur 5 ans :
  Loyer : 1 848 €/mois × 60 = 110 880 €
  Option d'achat : 13 200 €
  Coût total : 124 080 €
  
  vs achat comptant : 132 000 €
  vs emprunt 5 ans : 132 000 + 14 200 € d'intérêts = 146 200 €
  
  ✅ Le crédit-bail est le moins cher MAIS le joueur n'est pas
     propriétaire pendant la durée (pas d'actif au bilan)
```

**b) Location courte durée**
```
Cas d'usage : remplacer un matériel en panne, absorber un pic

Tarifs (par jour) :
  Tracteur 150 CV        : 220 €/jour
  Tracteur 250 CV        : 350 €/jour
  Moissonneuse classe 6  : 1 400 €/jour
  Télescopique           : 280 €/jour
  Presse                 : 180 €/jour
  Pulvérisateur traîné   : 150 €/jour

Inclus : le matériel. Non inclus : carburant, chauffeur (= le joueur).
Caution : 10% de la valeur (rendue si pas de dégât)
```

**c) Enchères (Expert)**
```
Ventes aux enchères mensuelles (liquidation, fin de CUMA, cessation) :

  Lots publiés 5 jours avant
  Les joueurs enchérissent
  Prix de départ : 60% de l'argus
  
  Résultat typique : 80-105% de l'argus
  → Bonne affaire possible, mais risque (pas de garantie, état variable)
```

**d) Vente de son matériel**
```
| Canal | Prix obtenu | Délai |
|-------|:-----------:|:-----:|
| Reprise concession | Argus × 0,82 | Immédiat |
| Annonce entre joueurs | Prix libre (généralement argus × 0,95) | 1-30 jours |
| Enchères | Argus × 0,80 à 1,05 | Prochaine vente |
| Casse (fin de vie) | 3% du prix neuf | Immédiat |
```

### 7.5 Progression matérielle type (les deux modes)

Le joueur doit sentir une progression claire. Parcours suggéré :

```
ANNÉE 1-2 : DÉMARRAGE (60-100 ha)
  Tracteur 110 CV d'occasion (35 000 €)
  Outils de base d'occasion (25 000 €)
  Moisson et ensilage en ETA
  → Investissement : 60 000 €

ANNÉE 3-5 : CONSOLIDATION (100-150 ha)
  + Tracteur 150 CV (occasion récente, 70 000 €)
  + Outils plus larges (charrue 5 corps, semoir 4 m)
  + Entrée en CUMA moissonneuse
  → Investissement cumulé : 180 000 €

ANNÉE 6-10 : DÉVELOPPEMENT (150-250 ha)
  + Tracteur 200 CV neuf (170 000 €)
  + Pulvérisateur 28 m, semoir 6 m
  + GPS autoguidage
  + Moissonneuse en propre ou CUMA renforcée
  → Investissement cumulé : 450 000 €

ANNÉE 10+ : OPTIMISATION (250 ha+)
  + Second tracteur
  + Matériel de grande largeur
  + GPS RTK avec modulation
  + Prestation ETA pour les autres joueurs (rentabiliser le parc)
  → Investissement cumulé : 700 000 €+
```

---

## 8. GPS et agriculture de précision

### 8.1 Mode Normal — Un GPS, des bonus clairs

```
┌─ Installer un GPS — Tracteur JD 6215R ────────────┐
│                                                    │
│  Système d'autoguidage RTK                         │
│  Prix : 18 000 € (installé par la concession)      │
│  Abonnement correction : 1 200 €/an                │
│                                                    │
│  ── Bénéfices ──                                   │
│  ⏱️ Temps de travail        -12%                   │
│  🌱 Économie semences       -5%                    │
│  💊 Économie engrais/phytos -8%                    │
│  🌙 Travail de nuit possible                       │
│                                                    │
│  💡 Sur votre exploitation (145 ha) :              │
│     Économie estimée : 4 850 €/an                  │
│     Retour sur investissement : 3,7 ans            │
│                                                    │
│  [ Installer ]                                     │
└────────────────────────────────────────────────────┘
```

### 8.2 Mode Expert — Trois niveaux + modulation

**a) Niveaux de guidage**

| Niveau | Précision | Prix | Abonnement | Gains |
|--------|:---------:|:----:|:----------:|-------|
| **Barre de guidage** | ±30 cm | 3 500 € | 0 € | Temps -5%, intrants -3% |
| **Autoguidage DGPS** | ±15 cm | 11 000 € | 400 €/an | Temps -9%, intrants -5% |
| **Autoguidage RTK** | ±2 cm | 22 000 € | 1 200 €/an | Temps -12%, intrants -8% |
| **RTK + coupure tronçons** | ±2 cm | 34 000 € | 1 200 €/an | Temps -12%, intrants -14% |

**b) Coupure automatique de tronçons**
```
Le pulvérisateur ou le semoir coupe automatiquement en bout de champ
et dans les zones déjà couvertes.

Économie réelle :
  Parcelle rectangulaire grande (20 ha)  : -4% d'intrants
  Parcelle moyenne (8 ha)                : -8%
  Parcelle petite/irrégulière (3 ha)     : -15%
  
→ Plus la parcelle est petite et tordue, plus la coupure est rentable
```

**c) Modulation intraparcellaire (VRA)**
```
Prérequis :
  1. Carte de rendement (générée automatiquement à chaque récolte si GPS)
  2. Ou carte de sol (analyse par zones : 25 €/ha, valable 10 ans)
  3. Console de modulation (+6 000 €)

Principe : la dose varie automatiquement selon le potentiel de chaque zone

┌─ Carte de modulation azote — Les Sables ──────────┐
│                                                    │
│   ████████░░░░░░░░  Zone A (5,2 ha) : 210 u        │
│   ████████████████  Zone B (8,1 ha) : 250 u        │
│   ██████░░░░░░░░░░  Zone C (4,7 ha) : 180 u        │
│                                                    │
│  Dose moyenne : 218 u/ha (vs 248 u en dose unique) │
│  Économie : 30 u × 18 ha × 1,25 € = 675 €          │
│  Rendement : +2,5% (mieux réparti)                 │
│                                                    │
│  Gain total : 675 € + 1 150 € = 1 825 €            │
└────────────────────────────────────────────────────┘
```

**d) Cartographie de rendement**
```
À chaque récolte avec une moissonneuse équipée GPS :
  → génération automatique d'une carte de rendement de la parcelle
  → identification des zones faibles (compaction, mauvais drainage, ombre)
  
Utilisation par le joueur :
  • Adapter la fertilisation (modulation)
  • Identifier les problèmes à corriger (drainage, chaulage)
  • Décider de sortir une zone improductive (jachère, haie → éco-régime)
```

**e) Retour sur investissement (Expert)**
```
┌─ Rentabilité du GPS — 145 ha ─────────────────────────────┐
│                                                            │
│  Niveau           Coût     Gain/an    ROI                  │
│  ──────────────────────────────────────────                │
│  Barre guidage    3 500 €   1 850 €   1,9 an  ✅            │
│  DGPS            11 000 €   3 200 €   3,4 ans ✅            │
│  RTK             22 000 €   4 850 €   4,5 ans ✅            │
│  RTK + coupure   34 000 €   7 100 €   4,8 ans ✅            │
│  + Modulation    40 000 €   9 400 €   4,3 ans ✅            │
│                                                            │
│  💡 Pour votre surface, le RTK + coupure est optimal.      │
│     En dessous de 80 ha, la barre de guidage suffit.       │
└────────────────────────────────────────────────────────────┘
```

### 8.3 Réseau de balises (reprise SimAgri — à conserver)

L'idée SimAgri du concessionnaire joueur qui installe des balises est excellente et sociale. On la garde en l'adaptant :

```
Mode Normal :
  Le signal de correction RTK est disponible partout (abonnement satellite)
  Prix : 1 200 €/an

Mode Expert :
  Deux options :
  a) Abonnement satellite : 1 200 €/an, disponible partout
  b) Balise locale (installée par un concessionnaire joueur) :
     - Le concessionnaire investit 25 000 € par balise
     - Couvre une zone (rayon 15 km)
     - Il revend l'abonnement 700-900 €/an aux joueurs de la zone
     - Précision légèrement meilleure (±1,5 cm) et pas de perte de signal
     → Rentable pour le concessionnaire à partir de 8 abonnés
```

### 8.4 Équilibrage GPS

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Niveaux disponibles | 1 (RTK) | 4 (barre → RTK+coupure) |
| Prix | 18 000 € | 3 500 à 40 000 € |
| Gain temps | -12% fixe | -5 à -12% selon niveau |
| Gain intrants | -8% fixe | -3 à -14% selon niveau et parcellaire |
| Modulation VRA | Non | Oui (+6 000 €, gain +2,5% rendement) |
| Cartographie rendement | Non | Oui (automatique) |
| Travail de nuit | Oui | Oui |
| Balises joueurs | Non | Oui (concessionnaire) |


---

## 9. Équilibrage et scénarios

### 9.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| Le coût de mécanisation reste réaliste | 300-500 €/ha selon la surface |
| Aucune stratégie ne domine | Écart max 20% entre tout-propriété, tout-ETA, mixte |
| L'ETA est viable jusqu'à une certaine surface | Rentable jusqu'à ~350 ha pour la moisson |
| La CUMA est toujours la moins chère | -20 à -40% vs ETA, mais avec contrainte de planning |
| Acheter plus large gagne vraiment du temps | Doubler la largeur ≈ -45% de temps |
| Le GPS est rentable au-delà d'une surface | Seuil ~80 ha |
| Progression matérielle sur 10 ans | 60 000 € → 700 000 € de parc |

### 9.2 Scénario A — Trois stratégies comparées (145 ha, mode Normal)

**Stratégie 1 — Tout en propriété**
```
PARC
  Tracteur 180 CV (neuf)                 155 000 €
  Tracteur 110 CV (occasion)              38 000 €
  Charrue 5 corps                          34 000 €
  Déchaumeur 4,5 m                         26 000 €
  Herse rotative 4 m + semoir              48 000 €
  Épandeur 24 m                            18 000 €
  Pulvérisateur 24 m                       42 000 €
  Moissonneuse classe 5 (occasion)        165 000 €
  Benne + plateau                          32 000 €
  ─────────────────────────────────────────────────
  TOTAL PARC                              558 000 €

CHARGES ANNUELLES
  Amortissement (moyenne 9 ans)            62 000 €
  Carburant (145 ha × 92 L × 0,95 €)       12 673 €
  Entretien + réparations                  14 500 €
  Assurance                                 5 600 €
  ─────────────────────────────────────────────────
  TOTAL                                    94 773 €
  COÛT DE MÉCANISATION                     654 €/ha  ❌ TROP ÉLEVÉ
```

**Stratégie 2 — Mixte (propriété + ETA pour la récolte)**
```
PARC (sans moissonneuse)                  393 000 €

CHARGES ANNUELLES
  Amortissement                            44 000 €
  Carburant (145 ha × 66 L)                 9 095 €
  Entretien                                 9 800 €
  Assurance                                 3 900 €
  ETA moisson (145 ha × 110 €)             15 950 €
  ─────────────────────────────────────────────────
  TOTAL                                    82 745 €
  COÛT DE MÉCANISATION                     571 €/ha  ⚠️ ÉLEVÉ
```

**Stratégie 3 — Minimaliste (tracteur + outils de base, reste en ETA/CUMA)**
```
PARC
  Tracteur 150 CV (occasion 3 ans)         78 000 €
  Charrue 4 corps (occasion)               18 000 €
  Herse + semoir 4 m (occasion)            28 000 €
  Épandeur 18 m                            12 000 €
  Benne                                    16 000 €
  Parts CUMA (moissonneuse + pulvé)        28 000 €
  ─────────────────────────────────────────────────
  TOTAL PARC                              180 000 €

CHARGES ANNUELLES
  Amortissement                            22 000 €
  Carburant                                 7 200 €
  Entretien                                 5 400 €
  Assurance                                 2 200 €
  CUMA moisson (145 ha × 63 €)              9 135 €
  CUMA pulvé (145 ha × 14 €)                2 030 €
  ETA déchaumage (145 ha × 45 €)            6 525 €
  ─────────────────────────────────────────────────
  TOTAL                                    54 490 €
  COÛT DE MÉCANISATION                     376 €/ha  ✅ OPTIMAL
```

**Analyse comparative** :

| Stratégie | Capital | Coût/ha | Temps de travail | Autonomie |
|-----------|:-------:|:-------:|:----------------:|:---------:|
| Tout propriété | 558 000 € | 654 €/ha | 620 h | ★★★★★ |
| Mixte | 393 000 € | 571 €/ha | 480 h | ★★★★☆ |
| Minimaliste | 180 000 € | 376 €/ha | 380 h | ★★☆☆☆ |

✅ **Équilibrage validé** : la stratégie minimaliste est la plus économique mais **dépend des autres** (CUMA, ETA). C'est un arbitrage coût/autonomie réel.

⚠️ **Point d'attention** : la stratégie « tout propriété » est trop pénalisée (654 €/ha vs référence 350-450 €/ha). Cela pourrait frustrer le joueur qui aime collectionner du matériel (plaisir SimAgri !).

**Correction retenue (ADR-002)** :
```
En mode Normal :
  • Réduire l'amortissement affiché de 20% (durées de vie allongées)
  • Le joueur qui possède beaucoup de matériel peut le rentabiliser
    en faisant de la prestation ETA pour les autres joueurs
  • Afficher le "capital investi" comme un actif valorisant, pas
    seulement comme une charge

→ Recalcul stratégie 1 : 94 773 - 12 400 = 82 373 € = 568 €/ha
→ Avec 40 ha de prestation ETA (110 €/ha = 4 400 € de revenu) : 538 €/ha
→ Toujours plus cher, mais l'écart passe de 74% à 43% : acceptable
```

### 9.3 Scénario B — Impact de la largeur (mode Normal)

```
Semer 145 ha de céréales

Semoir 3 m (combiné herse+semoir)
  débit = 3 × 10 × 0,1 × 0,80 = 2,4 ha/h
  temps = 60,4 h
  Prix du matériel : 36 000 €

Semoir 4 m
  débit = 4 × 10 × 0,1 × 0,80 = 3,2 ha/h
  temps = 45,3 h  (-25%)
  Prix : 48 000 € (+12 000 €)

Semoir 6 m
  débit = 6 × 10 × 0,1 × 0,80 = 4,8 ha/h
  temps = 30,2 h  (-50%)
  Prix : 74 000 € (+38 000 €)
  ⚠️ Nécessite 270 CV (contre 180 CV pour le 4 m)

ARBITRAGE :
  Le 6 m fait gagner 30 heures par an.
  Coût supplémentaire : 38 000 € + un tracteur plus puissant (+60 000 €)
  → 98 000 € pour gagner 30 h/an = 3 267 € par heure gagnée
  → NON RENTABLE à 145 ha
  
  Le 4 m fait gagner 15 heures pour 12 000 € = 800 €/heure gagnée
  → Rentable si le temps est le facteur limitant (fenêtre de semis serrée)
```

✅ **Validé** : la largeur crée un vrai arbitrage. Le sur-dimensionnement est puni économiquement.

### 9.4 Scénario C — Panne critique en moisson (mode Expert)

```
SITUATION
  Joueur : 220 ha de blé, moissonneuse classe 6 en propre
  Jour 3 de moisson, 85 ha récoltés
  Panne majeure : variateur de batteur (3 200 € + 4 jours de délai)
  Météo : pluie annoncée dans 48 h (30 mm), puis 5 jours humides

ENJEU : 135 ha non récoltés, risque de germination sur pied

OPTIONS
  1. Attendre la réparation (4 jours)
     → Le blé prend la pluie
     → Qualité déclassée : PS -4, germination
     → Perte : 135 ha × 82 q × 220 € × 0,25 = 60 885 € ❌

  2. ETA en urgence
     → Disponibilité : 2 jours d'attente (les ETA sont saturées)
     → Récolte de 135 ha à 110 €/ha = 14 850 €
     → 40 ha prennent la pluie : perte 18 000 €
     → Coût total : 32 850 € ⚠️

  3. Location d'une moissonneuse (concession)
     → Disponible sous 24 h : 1 400 €/jour × 3 j = 4 200 €
     → + carburant 3 500 €
     → Récolte terminée avant la pluie
     → Coût total : 7 700 € + réparation 3 200 € = 10 900 € ✅

  4. Demander de l'aide à un joueur voisin
     → Négociation : il vient avec sa machine
     → Prix négocié : 95 €/ha = 12 825 €
     → Récolte en 2 jours ✅
     → Coût : 12 825 € + réparation
     → Bonus : relation sociale renforcée

  5. Assurance bris de machine (si souscrite)
     → Couvre la réparation : -2 880 €
     → Ne couvre pas la perte de récolte

MEILLEURE DÉCISION : option 3 (location) ou 4 (aide d'un joueur)
```

✅ **Validé** : la crise crée une décision intéressante avec plusieurs solutions valables, dont une sociale. C'est le cœur du gameplay Expert.

### 9.5 Scénario D — Rentabilité du GPS selon la surface

| Surface | Barre (3 500 €) | DGPS (11 000 €) | RTK (22 000 €) | RTK+coupure (34 000 €) |
|:-------:|:---------------:|:---------------:|:--------------:|:----------------------:|
| 50 ha | ROI 3,2 ans ✅ | ROI 8,1 ans ⚠️ | ROI 14 ans ❌ | ROI 19 ans ❌ |
| 100 ha | ROI 1,6 an ✅ | ROI 4,2 ans ✅ | ROI 6,8 ans ⚠️ | ROI 7,1 ans ⚠️ |
| 150 ha | ROI 1,1 an ✅ | ROI 2,9 ans ✅ | ROI 4,5 ans ✅ | ROI 4,8 ans ✅ |
| 250 ha | ROI 0,7 an ✅ | ROI 1,8 an ✅ | ROI 2,7 ans ✅ | ROI 2,9 ans ✅ |
| 400 ha | ROI 0,4 an ✅ | ROI 1,1 an ✅ | ROI 1,7 an ✅ | ROI 1,8 an ✅ |

✅ **Validé** : la progressivité du GPS suit logiquement la surface. Un petit joueur commence par la barre de guidage, un gros va directement au RTK.

### 9.6 Points à valider en playtest

**Recette SimAgri (ADR-002) — bloquant**
- [ ] Acheter du matériel reste-t-il un moment gratifiant ?
- [ ] Le joueur qui aime collectionner du matériel est-il pénalisé ?
- [ ] Le calcul du temps est-il compris intuitivement (largeur = rapidité) ?
- [ ] L'ETA est-elle perçue comme une option pratique (et non comme un aveu d'échec) ?
- [ ] Le joueur Normal est-il déjà bloqué par une panne ?
- [ ] La progression matérielle sur 10 ans est-elle lisible et motivante ?

**Profondeur Expert**
- [ ] Le dimensionnement du parc est-il un puzzle intéressant ?
- [ ] La CUMA génère-t-elle de l'interaction entre joueurs ?
- [ ] Les crises (pannes) créent-elles de la tension sans frustration ?
- [ ] La modulation GPS est-elle compréhensible ?
- [ ] Le coût de possession est-il visible et exploitable pour décider ?

---

## Annexe — Récapitulatif des paramètres

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Débit de chantier | largeur × vitesse fixe × rendement | + sol, relief, puissance, parcelle |
| Consommation | Forfait L/ha par opération | L/h × taux de charge moteur |
| Surconsommation sous-dimensionné | Non | +20 à +35% |
| Usure | Compteur d'heures, 4 paliers | + 10 pièces d'usure |
| Entretien | 1 action, effet 500 h | 4 échéances (250/500/1000/2000 h) |
| Pannes | 1-2 jours, réparation immédiate | 4 gravités, délai de pièce 0-14 j |
| ETA PNJ | Toujours disponible (1-3 j) | Disponible mais +15% vs joueurs |
| ETA joueurs | Prix libre | + file d'attente, contrats, réputation |
| CUMA | 5 joueurs max, toujours dispo | 20 max, planning, priorité tournante |
| Financement | Comptant ou emprunt | + crédit-bail, location, enchères |
| GPS | 1 niveau (18 000 €) | 4 niveaux (3 500 à 40 000 €) |
| Modulation VRA | Non | Oui (+6 000 €) |
| Cartographie rendement | Non | Automatique |
| Coût de mécanisation cible | 380-570 €/ha | 350-500 €/ha (optimisable) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Amortissement Normal -20%, prestation ETA pour rentabiliser son parc | Le scénario A montrait que "tout posséder" était trop pénalisé (654 €/ha), ce qui casse le plaisir de collection (ADR-002) |
| 2026-08-04 | Ajout §4.5 Pièces détachées (seuils/alertes) + §4.6 Assurance matériel | Audit couverture fonctionnelle — systèmes 6.5 et 6.15 partiels |