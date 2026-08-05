> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Système de cultures

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-cultures.md`, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`

---

## 1. Vision et gameplay loop cultures

### 1.1 Intention de design

Les cultures sont le cœur d'Agriva. C'est ce que le joueur fait le plus souvent, ce qui structure son année, et ce qui génère l'essentiel de ses revenus au démarrage.

**Le plaisir des cultures dans SimAgri** vient de trois choses :
1. **Le rythme** — chaque saison a ses travaux, on suit le calendrier
2. **La visibilité** — on voit la parcelle évoluer (semée → levée → épiaison → mûre)
3. **La récompense** — la moisson, c'est le moment de vérité et de paie

**Ce qu'on garde** (ADR-002) : la séquence d'actions simple, le calendrier lisible, la satisfaction de la récolte.
**Ce qu'on ajoute** : la rotation qui compte vraiment, l'effet précédent, et en Expert, la finesse agronomique.

### 1.2 Gameplay loop

```
┌───────────────────────────────────────────────────────────┐
│  CYCLE D'UNE CULTURE (exemple : blé d'hiver)              │
└───────────────────────────────────────────────────────────┘

  AOÛT-SEPT   Déchaumage / Labour        [1-2 actions]
              ↓
  OCT-NOV     SEMIS                      [1 action, fenêtre 3 sem.]
              ↓
  NOV-DÉC     Levée (observation)        [0 action]
              ↓
  JAN-FÉV     Repos hivernal             [0 action]
              ↓
  FÉV-MARS    Fertilisation 1 (tallage)  [1 action]
              ↓
  MARS-AVR    Désherbage                 [1 action]
              ↓
  AVRIL       Fertilisation 2 (montaison)[1 action]
              ↓
  MAI         Fongicide (protection)     [1 action]
              ↓
  JUIN        Maturation (observation)   [0 action]
              ↓
  JUILLET     RÉCOLTE                    [1 action, fenêtre 2 sem.]
              ↓
  JUILLET     Pressage paille (option)   [1 action]
              ↓
              → Vente ou stockage

TOTAL : 7 à 9 actions sur 11 mois
```

**Rythme de jeu** : un joueur avec 120 ha en 3 cultures effectue 3-8 actions par mois. Cela correspond à 10-20 minutes de jeu par session, quelques fois par semaine.

### 1.3 Les décisions du joueur

| Décision | Quand | Impact Normal | Impact Expert |
|----------|-------|:-------------:|:-------------:|
| Quelle culture sur quelle parcelle ? | Automne | Rotation = bonus | Effet précédent = ±15% rendement |
| Quelle technique de travail du sol ? | Automne | Coût vs rendement | + structure du sol, adventices |
| Quelle date de semis ? | Fenêtre 3 sem. | Fenêtre large, pénalité douce | Fenêtre serrée, -1%/jour de retard |
| Quelle dose d'engrais ? | Hiver-printemps | Dose recommandée auto | N-P-K fractionné, analyse de sol |
| Traiter ou pas ? | Printemps | 1 passage recommandé | Seuils d'intervention, résistances |
| Quand récolter ? | Fenêtre 2 sem. | Fenêtre large | Humidité, risque météo, qualité |
| Vendre ou stocker la paille ? | Après moisson | Revenu vs restitution sol | + bilan humique |

### 1.4 Différence Normal / Expert

| Aspect | Normal (recette SimAgri) | Expert |
|--------|--------------------------|--------|
| **Nombre d'actions** | 6-7 par culture | 8-12 par culture |
| **Fenêtres de travaux** | Larges (3-4 semaines), pénalité douce | Serrées (1-2 semaines), pénalité forte |
| **Fertilisation** | 1-2 apports, dose suggérée | 3-4 apports fractionnés, N-P-K séparés |
| **Traitements** | 1-2 passages "traitement" | Herbicide/fongicide/insecticide distincts, seuils |
| **Météo** | Influence le rendement (jauges) | Bloque les travaux (sol détrempé, vent) |
| **Rotation** | Bonus si respectée | Effet précédent obligatoire (+8% / -15%) |
| **Variétés** | Non (1 blé = 1 blé) | 3-4 variétés/culture (précoce, résistante, productive) |
| **Qualité** | 3 niveaux | Protéines, PS, humidité → primes continues |
| **Sol** | Fertilité globale (jauge) | N-P-K-Ca-Mg-S + pH + matière organique |
| **Échec possible** | Non (rendement min garanti 40%) | Oui (culture perdue si négligée) |

---

## 2. Itinéraire technique — le cycle d'une culture

### 2.1 Structure commune à toutes les cultures

Chaque culture suit 5 phases :

```
1. PRÉPARATION   → travail du sol (0 à 3 actions selon technique)
2. IMPLANTATION  → semis ou plantation (1 action)
3. CONDUITE      → fertilisation + protection (2 à 6 actions)
4. MATURATION    → passive (0 action, le joueur observe)
5. RÉCOLTE       → moisson/arrachage (1 action) + résidus (0-1 action)
```

### 2.2 Techniques de travail du sol

| Technique | Actions | Coût carburant | Rendement | Disponibilité |
|-----------|:-------:|:--------------:|:---------:|:-------------:|
| **Labour** | Labour + herse | 35 L/ha | Référence (100%) | Toutes cultures |
| **TCS** | Déchaumage ×2 + herse | 22 L/ha | -2% (Normal) / -3% (Expert) | Toutes cultures |
| **Semis direct** | Aucun (semoir SD requis) | 8 L/ha | -6% (Normal) / -10% (Expert) | Sauf PDT, betterave |

**Mode Normal** : le joueur choisit sa technique, l'effet est simple et lisible.

**Mode Expert** — effets additionnels :
```
Labour        : détruit 80% des adventices, casse la structure (-2% MO/an)
TCS           : détruit 50% des adventices, préserve la structure
Semis direct  : ne détruit pas les adventices (herbicide obligatoire),
                améliore la structure (+3% MO sur 5 ans), 
                pénalité rendement forte les 3 premières années puis s'estompe
```

### 2.3 Calendrier des cultures principales

| Culture | Semis | Récolte | Actions Normal | Actions Expert |
|---------|-------|---------|:--------------:|:--------------:|
| Blé tendre hiver | 5 oct - 15 nov | 5 - 25 juil | 7 | 10 |
| Orge hiver | 25 sept - 5 nov | 25 juin - 15 juil | 7 | 9 |
| Colza | 15 - 31 août | 1 - 20 juil | 8 | 11 |
| Maïs grain | 15 avr - 10 mai | 10 oct - 15 nov | 6 | 9 |
| Maïs ensilage | 15 avr - 10 mai | 1 - 30 sept | 5 | 8 |
| Tournesol | 1 - 25 avr | 1 - 25 sept | 6 | 8 |
| Betterave | 15 mars - 10 avr | 1 oct - 30 nov | 9 | 12 |
| Pois protéagineux | 20 fév - 20 mars | 1 - 20 juil | 6 | 8 |
| Orge printemps | 15 fév - 20 mars | 10 - 30 juil | 6 | 8 |
| Pomme de terre | 1 - 30 avr | 20 août - 10 oct | 10 | 14 |
| Prairie temporaire | Mars ou sept | 3-4 coupes/an | 4/coupe | 5/coupe |

### 2.4 Exemple détaillé — Blé tendre d'hiver

**Mode Normal (7 actions)** :
```
1. [Sept]  Déchaumage ou labour
2. [Oct]   Herse rotative (préparation)      ← combinable avec le semis
3. [Oct]   SEMIS (dose auto : 180 kg/ha)
4. [Fév]   Engrais azoté (dose auto : 180 u)
5. [Mars]  Désherbage
6. [Mai]   Fongicide
7. [Juil]  MOISSON
   [Juil]  Presser la paille (optionnel)

Affichage parcelle :
┌─ Parcelle "Les Sables" — 18 ha ──────────────┐
│ 🌾 Blé tendre                                 │
│ Stade : Épiaison                              │
│ ████████████░░░░  Maturité 72%                │
│                                               │
│ ☀️ Ensoleillement  ████████░░  Bon            │
│ 💧 Pluviométrie    ██████░░░░  Un peu sec     │
│                                               │
│ Rendement estimé : 74 q/ha                    │
│ 📅 Récolte prévue : 12 juillet                │
│                                               │
│ Prochaine action : Fongicide (recommandé)     │
│ [ Traiter ]  [ Voir détails ]                 │
└───────────────────────────────────────────────┘
```

**Mode Expert (10 actions)** :
```
1. [Août]  Déchaumage (gestion repousses)
2. [Sept]  Labour ou 2e déchaumage
3. [Oct]   Herse rotative + SEMIS combiné
           → choix variété (Rubisko / Chevignon / Complice)
           → choix densité (280-380 grains/m²)
4. [Oct]   Herbicide anti-graminées (si SD ou TCS)
5. [Fév]   Azote 1 : tallage (40-60 u)
6. [Mars]  Herbicide dicotylédones + régulateur
7. [Mars]  Azote 2 : épi 1cm (80-100 u)
8. [Avril] Fongicide T1 (relais septoriose)
9. [Mai]   Azote 3 : dernière feuille (40-50 u) → qualité protéines
10.[Mai]   Fongicide T2 (protection épi)
11.[Juil]  MOISSON (humidité 14-15% cible)
   [Juil]  Presser paille ou broyer (bilan humique)

Affichage parcelle (Expert) :
┌─ Parcelle "Les Sables" — 18 ha ─────────────────────────────┐
│ 🌾 Blé tendre — Variété Rubisko (précoce, PS élevé)          │
│ Semé le 14/10 (dans la fenêtre optimale ✅)                  │
│ Densité : 320 gr/m² — Peuplement estimé : 285 pl/m²         │
│                                                              │
│ Stade : Épiaison (BBCH 55)                                   │
│ ████████████░░░░  Maturité 72%                               │
│                                                              │
│ ── Bilan hydrique ──                                         │
│ Cumul pluie depuis semis : 385 mm (référence 420 mm)         │
│ Réserve utile du sol : 62% ⚠️                                │
│ Déficit estimé : -18 mm sur la période critique              │
│                                                              │
│ ── Nutrition ──                                              │
│ Azote apporté : 170 u / 190 u conseillé                      │
│ Reliquat estimé : 25 u                                       │
│ ⚠️ Dernier apport possible : 22 mai (après = sans effet)     │
│                                                              │
│ ── Pression sanitaire ──                                     │
│ Septoriose : 🟠 modérée (T1 fait le 08/04)                   │
│ Rouille brune : 🟢 faible                                    │
│ Fusariose : 🟡 risque si pluie à floraison                   │
│                                                              │
│ ── Rendement prévisionnel ──                                 │
│ Potentiel variété      : 92 q/ha                             │
│ - Déficit hydrique     : -8 q                                │
│ - Azote insuffisant    : -3 q                                │
│ + Effet précédent colza: +5 q                                │
│ ─────────────────────────────                                │
│ Estimation             : 86 q/ha                             │
│ Protéines estimées     : 11,4% (⚠️ seuil meunier 11,5%)      │
│                                                              │
│ 💡 Un apport de 30 u d'azote avant le 22 mai permettrait     │
│    d'atteindre 11,8% de protéines (+8 €/t de prime)          │
│                                                              │
│ [ Fertiliser ]  [ Traiter ]  [ Irriguer ]  [ Historique ]    │
└──────────────────────────────────────────────────────────────┘
```

### 2.5 Combinés (gain de temps)

Reprise du système SimAgri (excellent) :

| Combiné | Outils | Actions économisées | Bonus |
|---------|--------|:-------------------:|-------|
| Herse + semoir | Herse rotative + semoir | 1 action | — |
| Déchaumage + semis | Cultivateur frontal + herse + semoir | 2 actions | — |
| Rouleau + semis | Rouleau frontal + herse + semoir | 2 actions | +3% rendement (rappuyage) |
| Fauche double | Faucheuse avant + arrière | -50% temps | — |
| Pulvé + cuve frontale | Cuve avant + pulvérisateur | -25% temps | Autonomie doublée |

**Condition** : le tracteur doit avoir un relevage avant (installé par un concessionnaire).


---

## 3. Calcul du rendement

### 3.1 Principe

Le rendement est le résultat de tout ce que le joueur a fait (ou pas). C'est **le feedback central** du système de cultures.

**Règle de design (ADR-002)** : en Normal, un joueur qui fait les actions de base obtient un bon rendement (85-95% du potentiel). L'optimisation apporte les 5-15% restants. **On ne punit pas, on récompense.**

### 3.2 Mode Normal — Formule simple

```
rendement = potentiel_base
          × f_terre
          × f_fertilisation
          × f_protection
          × f_meteo
          × f_rotation
          × f_technique

Plancher : 40% du potentiel (jamais de récolte nulle en Normal)
```

**Détail des facteurs :**

| Facteur | Valeurs | Comment le joueur l'influence |
|---------|---------|-------------------------------|
| `potentiel_base` | Défini par culture × région | Choix de culture et de localisation |
| `f_terre` | 0,85 / 1,00 / 1,10 (3 niveaux de qualité) | Achat/location de bonnes parcelles |
| `f_fertilisation` | 0,70 (rien) → 1,00 (dose conseillée) → 1,02 (excès) | Épandre l'engrais |
| `f_protection` | 0,80 (rien) → 1,00 (1 passage) → 1,03 (2 passages) | Traiter |
| `f_meteo` | 0,80 → 1,10 (selon jauges soleil/pluie) | Non contrôlable (sauf irrigation) |
| `f_rotation` | 0,95 (monoculture) → 1,00 (correcte) → 1,05 (optimale) | Planifier ses rotations |
| `f_technique` | 0,94 (SD) / 0,98 (TCS) / 1,00 (labour) | Choix de travail du sol |

**Exemple — blé en Normal, joueur qui fait tout correctement** :
```
Potentiel base (blé, Beauce)         : 85 q/ha
× f_terre (bonne terre)               : ×1,10
× f_fertilisation (dose conseillée)   : ×1,00
× f_protection (1 fongicide)          : ×1,00
× f_meteo (année correcte)            : ×0,98
× f_rotation (après colza)            : ×1,05
× f_technique (labour)                : ×1,00
─────────────────────────────────────────────
RENDEMENT                             : 96 q/ha ✅
```

**Exemple — joueur négligent (oublie l'engrais et le traitement)** :
```
85 × 1,10 × 0,70 × 0,80 × 0,98 × 1,05 × 1,00 = 54 q/ha
```
→ Rendement réduit mais **récolte quand même correcte**. Le joueur comprend qu'il a raté quelque chose sans être ruiné.

### 3.3 Mode Expert — Formule agronomique

```
rendement = min(
    potentiel_variété × f_sol × f_climat,     ← potentiel réalisable
    limitation_azote,                          ← loi du minimum
    limitation_eau,
    limitation_sanitaire
  )
  × f_implantation
  × f_rotation_precedent
  × f_structure_sol
  - pertes_recolte

Plancher : 0 (une culture peut être perdue)
```

**a) Potentiel de la variété**
```
Chaque culture propose 3-4 variétés :

BLÉ TENDRE
┌─────────────┬──────────┬─────────┬──────────┬─────────────┐
│ Variété     │ Potentiel│ Précocité│ Résistance│ Protéines  │
├─────────────┼──────────┼─────────┼──────────┼─────────────┤
│ Rubisko     │ 92 q/ha  │ Précoce │ ★★★☆    │ 11,2%      │
│ Chevignon   │ 98 q/ha  │ Moyen   │ ★★☆☆    │ 10,8%      │
│ Complice    │ 88 q/ha  │ Tardif  │ ★★★★    │ 12,0%      │
│ Izalco (BAF)│ 82 q/ha  │ Moyen   │ ★★★☆    │ 13,5%      │
└─────────────┴──────────┴─────────┴──────────┴─────────────┘

Arbitrage joueur :
  Chevignon = rendement max mais fragile (fongicides obligatoires)
  Complice  = sécurité (résistant) mais récolte tardive (risque météo)
  Izalco    = protéines élevées → prime meunier +25 €/t
```

**b) Loi du minimum (Liebig)** — le facteur limitant détermine le rendement
```
limitation_azote = (azote_disponible / azote_besoin) × potentiel
  azote_besoin = 3,0 u/q pour le blé  (ex: 90 q → 270 u dont 30 u du sol)

limitation_eau = (eau_disponible / eau_besoin) × potentiel
  eau_besoin = 450 mm pour le blé sur le cycle

limitation_sanitaire = potentiel × (1 - pression_maladie_non_traitée)

Le rendement est le PLUS PETIT des trois → le joueur doit équilibrer.
```

**c) Facteur d'implantation**
```
f_implantation = f_date_semis × f_densité × f_qualité_lit_semence

f_date_semis :
  Dans la fenêtre optimale (10 j)      : 1,00
  1-7 jours avant/après                : 0,98
  8-14 jours de décalage               : 0,93
  15-21 jours de décalage              : 0,85
  > 21 jours                           : 0,70

f_densité (blé, cible 300 gr/m²) :
  250-350 gr/m²                        : 1,00
  200-250 ou 350-400                   : 0,97
  < 200 ou > 400                       : 0,90  (trop clair ou concurrence)

f_qualité_lit_semence :
  Sol bien préparé (herse rotative)    : 1,00
  Préparation grossière                : 0,96
  Semis dans mauvaises conditions      : 0,88
```

**d) Pertes à la récolte**
```
pertes = pertes_base + pertes_retard + pertes_conditions

pertes_base        : 2% (inévitable)
pertes_retard      : +1,5%/semaine après maturité (égrenage, verse)
pertes_conditions  : +3% si récolte en conditions humides
                     +8% si culture versée (excès azote + orage)
```

### 3.4 Comparaison des deux modes — même parcelle

**Situation** : blé, bonne terre, 18 ha, année météo moyenne, joueur compétent.

| Étape | Normal | Expert |
|-------|:------:|:------:|
| Potentiel de départ | 85 q/ha (culture) | 92 q/ha (variété Rubisko) |
| Qualité de terre | ×1,10 | Intégré dans f_sol (×1,08) |
| Azote | ×1,00 (dose auto) | Limitation : 190 u apportés / 276 u besoin → 88 q max |
| Eau | Dans f_meteo | Limitation : 385/450 mm → 79 q max ⚠️ facteur limitant |
| Sanitaire | ×1,00 | Limitation : 1 fongicide sur 2 → 84 q max |
| Implantation | — | ×0,98 (semis à J+5) |
| Rotation | ×1,05 | ×1,06 (précédent colza) |
| Pertes récolte | — | -2,5% |
| **RÉSULTAT** | **96 q/ha** | **80 q/ha** |

**Analyse** : en Expert, le joueur découvre que **l'eau était son facteur limitant** — apporter plus d'azote n'aurait servi à rien. Il aurait fallu irriguer (si équipé) ou choisir une variété plus précoce (qui échappe au stress de fin de cycle).

C'est exactement le raisonnement d'un agronome. Le mode Expert enseigne l'agronomie réelle.

### 3.5 Feedback au joueur

**Normal** — après la récolte :
```
┌─ Récolte terminée — Les Sables (18 ha) ───────┐
│                                                │
│  🌾 Blé tendre : 96 q/ha                       │
│     Total récolté : 172,8 tonnes               │
│     Qualité : Bonne                            │
│                                                │
│  📊 Comparaison :                              │
│     Votre rendement    : 96 q/ha  ████████████ │
│     Moyenne du serveur : 82 q/ha  ██████████   │
│     Votre record       : 94 q/ha                │
│                                                │
│  🏆 Nouveau record personnel !                 │
│                                                │
│  Valeur estimée : 38 016 € (220 €/t)           │
│  [ Vendre ]  [ Stocker au silo ]               │
└────────────────────────────────────────────────┘
```

**Expert** — analyse post-récolte :
```
┌─ Bilan de campagne — Les Sables (18 ha) ──────────────────┐
│                                                            │
│  🌾 Blé tendre Rubisko : 80 q/ha                           │
│     Protéines : 11,6% ✅  PS : 78,2 ✅  Humidité : 14,1% ✅ │
│     → Classement : Meunier (prime +12 €/t)                 │
│                                                            │
│  ── Décomposition du rendement ──                          │
│  Potentiel variété                        92 q/ha          │
│  Facteur sol (bonne terre)               +7 q              │
│  ⚠️ LIMITATION EAU (385/450 mm)          -18 q  ← limitant │
│  Limitation azote (190/276 u)             -2 q             │
│  Pression septoriose (1 T sur 2)          -3 q             │
│  Semis tardif (J+5)                       -2 q             │
│  Effet précédent colza                    +6 q             │
│  Pertes à la récolte (2,5%)               -2 q             │
│  ─────────────────────────────────────────────             │
│  RÉALISÉ                                  80 q/ha          │
│                                                            │
│  💡 Analyse : le déficit hydrique a coûté 18 q/ha.         │
│     Pistes pour l'an prochain :                            │
│     • Variété plus précoce (échappe au stress de juin)     │
│     • Irrigation (2 tours d'eau = +12 q estimés)           │
│     • Semis 5 jours plus tôt                               │
│                                                            │
│  💰 Marge brute : 1 142 €/ha (référence région : 1 080 €)  │
│                                                            │
│  [ Exporter l'analyse ]  [ Planifier 2027 ]                │
└────────────────────────────────────────────────────────────┘
```

### 3.6 Potentiels de base par culture et région (paramétrage)

| Culture | Nord/Picardie | Beauce/IdF | Ouest | Sud-Ouest | Est | Montagne |
|---------|:-------------:|:----------:|:-----:|:---------:|:---:|:--------:|
| Blé tendre | 92 q | 85 q | 78 q | 68 q | 80 q | 55 q |
| Orge hiver | 85 q | 78 q | 72 q | 62 q | 74 q | 52 q |
| Colza | 40 q | 36 q | 32 q | 26 q | 34 q | 22 q |
| Maïs grain (irrigué) | 105 q | 100 q | 95 q | 110 q | 98 q | — |
| Maïs ensilage | 16 t MS | 15 t MS | 14 t MS | 17 t MS | 14 t MS | 11 t MS |
| Tournesol | — | 28 q | 26 q | 25 q | 26 q | — |
| Betterave | 95 t | 88 t | 80 t | — | 82 t | — |
| Pois | 45 q | 42 q | 38 q | 32 q | 40 q | — |
| Pomme de terre | 48 t | 45 t | 42 t | 38 t | 43 t | — |
| Prairie (foin) | 8 t MS | 7 t MS | 9 t MS | 6 t MS | 7,5 t MS | 5 t MS |

**Bio** : ×0,60 à ×0,70 selon culture (compensé par le prix de vente).


---

## 4. Rotation et effet précédent

### 4.1 Intention de design

C'est **la principale amélioration par rapport à SimAgri**. Dans SimAgri, la rotation est une contrainte administrative (« vous ne pouvez pas resemer du blé cette année »). Dans Agriva, c'est un **levier stratégique** : bien tourner ses cultures rapporte de l'argent.

Le joueur doit se poser la question : « quelle culture après quelle culture ? »

### 4.2 Effet précédent

**Mode Normal** — bonus/malus simple :

| Précédent | Culture suivante | Effet |
|-----------|-----------------|:-----:|
| Légumineuse (pois, féverole, luzerne) | Blé, orge, colza | **+5%** |
| Colza | Blé, orge | **+4%** |
| Betterave, pomme de terre | Blé, orge | **+3%** |
| Maïs | Blé, orge | **+1%** |
| Prairie retournée | Toute culture | **+6%** (1ère année) |
| Blé | Blé | **-5%** |
| Blé | Blé (3e année consécutive) | **-12%** |
| Orge | Orge | **-5%** |
| Colza | Colza | **-8%** (interdit en Expert) |

**Mode Expert** — effet décomposé :

```
effet_precedent = effet_azote + effet_structure + effet_sanitaire + effet_adventices

Exemple : pois → blé
  effet_azote      : +45 u d'azote résiduel (économie de 45 u = 63 €/ha)
  effet_structure  : +2% (racines pivotantes = décompactage)
  effet_sanitaire  : +3% (rupture du cycle des maladies du blé)
  effet_adventices : 0% (le pois est peu couvrant)
  ─────────────────────────────
  Total : +5% rendement + 63 €/ha économisés

Exemple : blé → blé (2e année)
  effet_azote      : -10 u (le blé est exigeant, épuise le sol)
  effet_structure  : -1% (racines fasciculées, pas de décompactage)
  effet_sanitaire  : -6% (piétin-échaudage s'installe)
  effet_adventices : -2% (vulpin, ray-grass se multiplient)
  ─────────────────────────────
  Total : -9% rendement + herbicide supplémentaire nécessaire
```

### 4.3 Pression maladie cumulative (Expert)

```
Chaque parcelle a un compteur de pression sanitaire par famille de maladie :

pression_piétin = f(nombre de céréales consécutives)
  1ère céréale  : 0%
  2e céréale    : 15%
  3e céréale    : 35%
  4e céréale    : 55%  → rendement -20% minimum
  Décroît de 20 points par année de culture non-hôte

pression_sclérotinia (colza) = f(fréquence colza)
  Colza tous les 4 ans : 5%
  Colza tous les 3 ans : 15%
  Colza tous les 2 ans : 40%  → risque majeur
```

### 4.4 Rotations types (suggérées au joueur)

**Mode Normal** — le jeu suggère des rotations :
```
┌─ Planifier mes rotations ─────────────────────────────────┐
│                                                            │
│  Parcelle "Les Sables" (18 ha)                             │
│  Historique : Colza (2024) → Blé (2025) → Orge (2026)      │
│                                                            │
│  Cultures conseillées pour 2027 :                          │
│                                                            │
│  ✅ Colza          Bonus rotation +4%   Marge est. 1 140 € │
│  ✅ Pois           Bonus rotation +5%   Marge est.   800 € │
│  ⚠️ Blé            Malus rotation -2%   Marge est. 1 095 € │
│  ❌ Orge           Malus rotation -5%   Marge est.   890 € │
│                                                            │
│  💡 Le colza est un excellent précédent pour le blé        │
│     que vous pourrez semer en 2028.                        │
│                                                            │
│  [ Choisir colza ]  [ Voir toutes les cultures ]           │
└────────────────────────────────────────────────────────────┘
```

**Mode Expert** — vue rotation pluriannuelle :
```
┌─ Assolement 2027-2032 — 120 ha ───────────────────────────────────┐
│                                                                    │
│ Parcelle    2027    2028    2029    2030    2031    2032          │
│ ─────────────────────────────────────────────────────────         │
│ Sables 18ha COLZA   Blé     Orge    COLZA   Blé     Orge          │
│ Plaine 25ha Blé     Orge    POIS    Blé     Orge    COLZA         │
│ Bas 22ha    Maïs    Blé     Blé⚠️   COLZA   Blé     Orge          │
│ Côte 20ha   Orge    COLZA   Blé     POIS    Blé     Orge          │
│ Vallée 35ha Blé     POIS    Blé     Orge    COLZA   Blé           │
│                                                                    │
│ ⚠️ Alerte : Parcelle "Bas" — 2 blés consécutifs en 2028-2029       │
│    Pression piétin estimée : 15% → perte 8 q/ha                    │
│    Suggestion : intercaler du pois ou de l'orge de printemps        │
│                                                                    │
│ ── Équilibre de l'assolement ──                                    │
│ Céréales    : 62% (max conseillé 66%) ✅                            │
│ Oléagineux  : 23% ✅                                                │
│ Protéagineux: 15% ✅ (bonus PAC aide protéines : +1 800 €)          │
│ Diversité   : 4 cultures ✅ (éco-régime voie pratiques validé)       │
│                                                                    │
│ [ Simuler cette rotation ]  [ Optimiser automatiquement ]           │
└────────────────────────────────────────────────────────────────────┘
```

### 4.5 Contraintes de rotation

| Contrainte | Normal | Expert |
|-----------|:------:|:------:|
| Monoculture stricte (même culture 4+ ans) | Autorisée mais -12% | **Interdite** (BCAE) |
| Colza sur colza | Autorisé (-8%) | **Interdit** |
| Délai de retour colza | Aucun | 3 ans minimum |
| Délai de retour betterave | 3 ans | 4 ans (nématodes) |
| Délai de retour pois | 3 ans | 5 ans (aphanomyces) |
| Délai de retour PDT | 3 ans | 4 ans |
| Diversité minimum (BCAE) | Non | 3 cultures, aucune > 60% |

---

## 5. Fertilisation

### 5.1 Mode Normal — Un engrais, une dose conseillée

**Principe** : le jeu calcule la dose optimale, le joueur valide.

```
┌─ Fertiliser — Les Sables (18 ha, blé) ────────────┐
│                                                    │
│  Dose conseillée : 180 unités d'azote/ha           │
│                                                    │
│  ○ Économique     140 u   →  -6% rendement         │
│  ● Conseillée     180 u   →  rendement optimal     │
│  ○ Intensive      210 u   →  +1% rendement         │
│                                                    │
│  Coût : 180 u × 18 ha × 1,40 €/u = 4 536 €         │
│  Stock d'engrais : 8,2 t (suffisant ✅)             │
│                                                    │
│  ⏱️ Temps : 1,2 h                                  │
│                                                    │
│  [ Épandre ]                                       │
└────────────────────────────────────────────────────┘
```

**Un seul apport** en Normal (le jeu répartit automatiquement l'effet sur le cycle).

**Fertilisation organique** : si le joueur a du fumier ou du lisier, il peut l'épandre. Le jeu déduit automatiquement la quantité d'azote minéral nécessaire.

```
Fumier bovin  : 25 t/ha → apporte 125 u N + 75 u P + 175 u K
Lisier bovin  : 30 m³/ha → apporte 90 u N + 45 u P + 120 u K
→ Le conseil d'azote minéral est réduit d'autant
```

### 5.2 Mode Expert — N-P-K fractionné + analyse de sol

**a) Analyse de sol** (150 €, valable 5 ans)
```
┌─ Analyse de sol — Les Sables ─────────────────────────┐
│                                                        │
│  Texture : Limon argileux                              │
│  pH : 6,8 ✅ (optimal 6,5-7,5)                         │
│  Matière organique : 2,1% ⚠️ (faible, cible 2,5%)      │
│  CEC : 14 meq/100g (moyenne)                           │
│                                                        │
│  ── Éléments disponibles ──                            │
│  Azote (reliquat sortie hiver) : 32 u/ha               │
│  Phosphore (P2O5)  : 68 ppm  🟡 (correct, entretien)   │
│  Potassium (K2O)   : 145 ppm ✅ (bon)                   │
│  Magnésium (MgO)   : 78 ppm  🟠 (à surveiller)         │
│  Calcium (CaO)     : 2 100 ppm ✅                       │
│  Soufre (SO3)      : 12 ppm  🔴 (carence probable)     │
│                                                        │
│  ── Recommandations ──                                 │
│  • Azote blé : 248 u (280 besoin - 32 reliquat)        │
│  • Phosphore : 45 u (entretien)                        │
│  • Potasse : 0 u (réserve suffisante)                  │
│  • Soufre : 50 u ⚠️ (impact direct sur protéines)      │
│  • Magnésie : 40 u (tous les 3 ans)                    │
│  • Chaulage : non nécessaire (pH correct)              │
└────────────────────────────────────────────────────────┘
```

**b) Fractionnement de l'azote**
```
BLÉ — 248 u à apporter en 3 apports :

Apport 1 — Tallage (février)         : 50 u
  → Objectif : assurer le tallage
  → Fenêtre : 1er fév - 10 mars
  → Si oublié : -8 q/ha (moins de talles = moins d'épis)

Apport 2 — Épi 1cm (mi-mars)         : 120 u
  → Objectif : nombre d'épis (le plus important)
  → Fenêtre : 5 mars - 5 avril
  → Si oublié : -18 q/ha ⚠️ apport critique

Apport 3 — Dernière feuille (mai)    : 78 u
  → Objectif : remplissage du grain + PROTÉINES
  → Fenêtre : 1er - 25 mai (après = inefficace)
  → Si oublié : -6 q/ha et -0,8% protéines (perte de la prime meunier)

⚠️ Le fractionnement est obligatoire : apporter 248 u en une fois
   entraîne des pertes par lessivage (-30% d'efficacité) et un
   risque de verse (culture couchée = -15% rendement + pertes récolte).
```

**c) Efficience et pertes**
```
azote_efficace = azote_apporté × coefficient_efficience

coefficient_efficience :
  Apport fractionné, sol frais, pluie sous 5 jours    : 0,90
  Apport fractionné, conditions moyennes              : 0,80
  Apport unique massif                                : 0,60
  Apport sur sol sec sans pluie sous 10 jours         : 0,55 (volatilisation)
  Apport avant forte pluie (> 30 mm)                  : 0,50 (lessivage)

→ Le joueur Expert doit regarder la météo avant d'épandre.
```

**d) Plafond réglementaire (Directive Nitrates)**
```
azote_organique_max = 170 kg N/ha/an (moyenne exploitation)

Si le joueur a beaucoup d'animaux :
  azote_total_effluents / surface_épandable ≤ 170 u
  
Sinon : il doit exporter ses effluents (coût) ou augmenter sa surface
→ Crée un vrai lien élevage ↔ cultures
```

### 5.3 Coûts de référence

| Engrais | Prix | Unités apportées | Coût/unité |
|---------|:----:|:----------------:|:----------:|
| Ammonitrate 33,5% | 420 €/t | 335 u N/t | 1,25 €/u N |
| Solution azotée 39% | 350 €/t | 390 u N/t | 0,90 €/u N |
| Urée 46% | 480 €/t | 460 u N/t | 1,04 €/u N |
| DAP (18-46-0) | 680 €/t | 180 N + 460 P | — |
| Super 45 (0-45-0) | 450 €/t | 450 u P/t | 1,00 €/u P |
| Chlorure de potasse | 400 €/t | 600 u K/t | 0,67 €/u K |
| Kiésérite (Mg) | 320 €/t | 250 u Mg/t | 1,28 €/u Mg |
| Fumier bovin | 0 € (produit) | 5 N + 3 P + 7 K /t | Gratuit |
| Lisier bovin | 0 € (produit) | 3 N + 1,5 P + 4 K /m³ | Gratuit |

### 5.4 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Nombre d'apports | 1 | 3-4 (azote) + 1 (P-K) |
| Éléments gérés | N seulement | N, P, K, Mg, S, pH |
| Analyse de sol | Non | 150 €, valable 5 ans |
| Dose conseillée | Affichée et applicable en 1 clic | Calculée mais à répartir |
| Pénalité oubli | -6 à -10% | -8 à -18 q/ha selon l'apport |
| Efficience météo | Non | 0,50 à 0,90 |
| Plafond N organique | Non | 170 u/ha |
| Coût moyen/ha (blé) | 250 €/ha | 280-320 €/ha (mais rendement supérieur) |


---

## 6. Traitements et protection des cultures

### 6.1 Mode Normal — Un bouton "Traiter"

**Principe** : le jeu identifie le besoin, le joueur valide. Pas de connaissance phytosanitaire requise.

```
┌─ Traiter — Les Sables (18 ha, blé) ───────────────┐
│                                                    │
│  🔍 Besoin détecté : protection fongicide          │
│     Stade : dernière feuille étalée                │
│     Pression maladie : modérée                     │
│                                                    │
│  Effet attendu : +6% de rendement                  │
│  Coût : 62 €/ha × 18 ha = 1 116 €                  │
│  ⏱️ Temps : 0,8 h                                  │
│                                                    │
│  ⚠️ Vent modéré aujourd'hui — traitement            │
│     moins efficace (-15%)                          │
│     Attendre demain ? (météo prévue : calme)       │
│                                                    │
│  [ Traiter maintenant ]  [ Attendre ]              │
└────────────────────────────────────────────────────┘
```

**Nombre de passages recommandés par culture (Normal)** :

| Culture | Passages | Effet cumulé si tous faits |
|---------|:--------:|:--------------------------:|
| Blé, orge | 2 (1 herbicide + 1 fongicide) | +18% vs aucun traitement |
| Colza | 3 (1 herbicide + 1 insecticide + 1 fongicide) | +25% |
| Maïs | 1 (herbicide) | +15% |
| Tournesol | 1 (herbicide) | +12% |
| Betterave | 4 (3 herbicides + 1 fongicide) | +30% |
| Pois | 2 (1 herbicide + 1 fongicide) | +20% |
| Pomme de terre | 6 (1 herbicide + 5 fongicides mildiou) | +40% |

**Le joueur n'est jamais obligé de traiter.** Ne pas traiter = rendement réduit mais récolte quand même. C'est un choix économique (coût du produit vs gain de rendement).

### 6.2 Mode Expert — Seuils, familles, résistances

**a) Trois familles distinctes**

| Type | Cible | Timing | Coût/ha |
|------|-------|--------|:-------:|
| **Herbicide** | Adventices (mauvaises herbes) | Automne ou printemps précoce | 35-70 € |
| **Fongicide** | Maladies (septoriose, rouille, mildiou) | Selon stade + pression | 40-90 € |
| **Insecticide** | Ravageurs (pucerons, altises, méligèthes) | Selon seuil de nuisibilité | 12-30 € |
| **Régulateur** | Éviter la verse | Montaison | 15-30 € |
| **Molluscicide** | Limaces | Après semis si humide | 15-25 € |

**b) Seuils d'intervention (le joueur décide)**
```
Le jeu affiche l'observation, le joueur décide s'il traite.

EXEMPLE — Colza, altises d'hiver (octobre)
┌─ Observation parcelle ─────────────────────────────┐
│  🐛 Altises adultes détectées                       │
│                                                     │
│  Comptage : 8 pieds attaqués sur 20 observés (40%) │
│  Seuil de nuisibilité : 8 pieds sur 10 (80%)       │
│                                                     │
│  → Sous le seuil : traitement NON justifié          │
│                                                     │
│  Si vous traitez quand même :                       │
│    Coût : 22 €/ha (396 € au total)                  │
│    Gain estimé : +1% rendement (+62 €)              │
│    → Perte nette de 334 €                           │
│                                                     │
│  💡 Surveillez à nouveau dans 5 jours               │
│  [ Ne pas traiter ]  [ Traiter quand même ]         │
└─────────────────────────────────────────────────────┘
```

**c) Pression maladie dynamique**
```
pression_maladie évolue selon :
  + Humidité (pluie, rosée persistante)
  + Température (optimum de chaque champignon)
  + Variété sensible (Chevignon ★★☆☆ = plus sensible)
  + Précédent identique (inoculum dans les résidus)
  + Densité de semis élevée (microclimat humide)
  - Traitement fongicide (protection 3-4 semaines)
  - Variété résistante

Si pression > 60% et non traitée pendant 2 semaines :
  → dégâts irréversibles (perte définitive de potentiel)
```

**d) Résistances (apparition progressive)**
```
Chaque matière active a un compteur d'utilisation par exploitation :

Utilisations consécutives    Efficacité
1-3                          100%
4-6                          90%
7-10                         75%
11+                          55%   → il faut changer de mode d'action

→ Le joueur Expert doit alterner les familles chimiques
→ Le désherbage mécanique (binage) réinitialise partiellement le compteur
```

**e) Alternatives non chimiques (Expert)**
```
Désherbage mécanique :
  Binage (maïs, tournesol, betterave, colza)   : 25 €/ha, efficacité 70%
  Herse étrille (céréales)                     : 18 €/ha, efficacité 50%
  Houe rotative                                : 22 €/ha, efficacité 60%
  → Conditions : sol sec, stade adventices jeune
  → Obligatoire en bio

Prophylaxie :
  Faux-semis (déchaumage répété avant semis)   : -30% stock d'adventices
  Décalage de la date de semis (+10 jours)     : -25% vulpin
  Rotation diversifiée                         : -40% pression globale
```

### 6.3 Mode bio (les deux modes)

```
Contraintes :
  ❌ Aucun produit de synthèse (herbicide, fongicide, insecticide)
  ✅ Cuivre et soufre autorisés (limités : 4 kg Cu/ha/an)
  ✅ Désherbage mécanique obligatoire (2-4 passages)
  ✅ Rotation allongée (+1 an minimum, 5-7 cultures)
  ✅ Fertilisation organique uniquement
  ⏳ Conversion : 2 ans (rendement bio, prix conventionnel pendant la conversion)

Rendement : -30 à -40% selon culture
Prix : +40 à +80%
Aides : conversion 350 €/ha (5 ans), maintien 100 €/ha
Charges : -60% en intrants, +40% en temps de travail (mécanique)

Bilan économique bio (blé) :
  Rendement 50 q/ha × 380 €/t          = 1 900 €/ha
  Charges opérationnelles              =  -280 €/ha
  Aide bio maintien                    =  +100 €/ha
  ──────────────────────────────────────────────
  Marge brute                          = 1 720 €/ha
  
  vs conventionnel : 75 q × 220 € - 510 € = 1 140 €/ha
  → Le bio est plus rentable à l'hectare mais demande plus de temps
```

---

## 7. Météo et fenêtres de travaux

### 7.1 Système météo

**Structure commune aux deux modes** :
```
4 zones météo (Nord-Ouest, Nord-Est, Sud-Ouest, Sud-Est)
5 niveaux quotidiens : Très ensoleillé / Ensoleillé / Mitigé / Pluie / Forte pluie
+ événements : vent, gel, grêle, canicule

Données basées sur des moyennes climatiques réelles par région et par mois
+ variabilité aléatoire annuelle (année sèche, année humide)
```

### 7.2 Mode Normal — La météo influence, ne bloque pas

**Deux jauges par parcelle** (reprise de SimAgri) :
```
☀️ Ensoleillement  ████████░░  Bon
💧 Pluviométrie    ██████░░░░  Un peu sec

→ Jauge verte = conditions favorables (bonus rendement jusqu'à +10%)
→ Jauge rouge = trop ou pas assez (malus jusqu'à -20%)
```

**Blocages en Normal** (minimaux, repris de SimAgri) :
| Condition | Effet |
|-----------|-------|
| Forte pluie | Impossible de travailler dans les parcelles (comme SimAgri) |
| Vent | Impossible de pulvériser |
| Autres | Aucun blocage |

**Le joueur n'est jamais bloqué longtemps** : la forte pluie dure 1-2 jours max, et les fenêtres de travaux sont larges (3-4 semaines).

### 7.3 Mode Expert — Fenêtres serrées et praticabilité

**a) Praticabilité du sol**
```
ressuyage_sol = f(pluie_cumulée_7j, type_sol, drainage, saison)

Impraticable si :
  Sol argileux  : > 25 mm de pluie sur 7 jours
  Sol limoneux  : > 35 mm sur 7 jours
  Sol sableux   : > 50 mm sur 7 jours
  
Conséquence si le joueur force :
  → Tassement du sol (-5% rendement l'année suivante)
  → Consommation carburant +30%
  → Risque d'embourbement (immobilisation 1 jour)
```

**b) Conditions par type de travaux**

| Travail | Conditions requises (Expert) |
|---------|------------------------------|
| Labour | Sol ressuyé, pas de gel profond |
| Semis | Sol ressuyé, T° sol > 5°C (céréales) ou > 10°C (maïs) |
| Fertilisation solide | Sol portant, pas de vent > 30 km/h |
| Fertilisation liquide | Pas de gel, pas de pluie forte prévue sous 48h |
| Pulvérisation | Vent < 19 km/h, T° < 25°C, hygrométrie > 60% |
| Récolte céréales | Humidité grain < 16%, pas de pluie en cours |
| Fenaison | 3 jours consécutifs sans pluie |
| Épandage effluents | Calendrier réglementaire + sol portant |

**c) Événements climatiques (Expert)**

| Événement | Probabilité/an | Effet | Protection |
|-----------|:-------------:|-------|------------|
| Sécheresse printanière | 25% | -15 à -35% rendement | Irrigation, variété précoce |
| Excès d'eau automne | 20% | Semis retardé ou impossible | Drainage |
| Gel tardif (avril) | 15% | -10 à -30% (colza, arbo) | Variété tardive |
| Échaudage (canicule juin) | 20% | -8 à -20% (céréales) | Variété précoce, irrigation |
| Grêle | 5% | -30 à -90% sur la parcelle touchée | Assurance |
| Verse (orage + excès N) | 15% | -15% + pertes récolte | Régulateur, dose N maîtrisée |
| Année exceptionnelle | 10% | +15 à +25% rendement | — (bonus) |

**d) Affichage prévisionnel (Expert)**
```
┌─ Météo — Zone Nord-Ouest ─────────────────────────────────┐
│                                                            │
│  Aujourd'hui  Mer   Jeu   Ven   Sam   Dim   Lun            │
│      ☀️        ☀️    ⛅    🌧️    🌧️    ⛅    ☀️              │
│     22°C      24°C  21°C  17°C  16°C  19°C  23°C           │
│     0 mm      0 mm  2 mm  18 mm 12 mm 3 mm  0 mm           │
│     Vent      Vent  Vent  Vent  Vent  Vent  Vent           │
│     8 km/h    12    25⚠️   35    28    15    10             │
│                                                            │
│  ── Fenêtres de travaux ──                                 │
│  🌾 Moisson blé : ✅ AUJOURD'HUI et demain                  │
│     ⚠️ Pluie vendredi (30 mm) → risque de germination       │
│     💡 Priorité : moissonner 40 ha aujourd'hui              │
│                                                            │
│  💊 Pulvérisation : ✅ aujourd'hui, ❌ jeudi (vent 25 km/h)  │
│                                                            │
│  🚜 Travail du sol : ✅ jusqu'à jeudi, ❌ après (sol saturé) │
│     Reprise estimée : mardi prochain                        │
│                                                            │
│  ── Bilan de la campagne ──                                │
│  Cumul pluie depuis semis : 385 mm (normale 420 mm) 🟡      │
│  Somme de température : 1 842 °Cj (normale 1 780) ✅        │
│  Nombre de jours de travail perdus : 12 j                   │
└────────────────────────────────────────────────────────────┘
```

### 7.4 Irrigation

| Aspect | Normal | Expert |
|--------|:------:|:------:|
| Déclenchement | Bouton "irriguer" quand la jauge est basse | Bilan hydrique calculé, doses précises |
| Quantité | Automatique (remplit la jauge) | Le joueur choisit (mm) selon le stade |
| Coût | 40 €/ha/tour d'eau | Énergie (kWh) + eau (m³) selon le matériel |
| Contraintes | Source disponible | Quotas, restrictions sécheresse, débit source |
| Matériel | Enrouleur ou pivot | + calcul de la surface couverte par unité de temps |

**Expert — restrictions sécheresse** :
```
Si sécheresse déclarée sur la zone :
  Niveau 1 (vigilance)  : pas de restriction
  Niveau 2 (alerte)     : irrigation interdite 1 jour/semaine
  Niveau 3 (renforcée)  : irrigation interdite 3 jours/semaine
  Niveau 4 (crise)      : irrigation totalement interdite
  
→ Le joueur qui a misé sur le maïs irrigué prend un risque réel
```


---

## 8. Récolte, qualité et stockage

### 8.1 Mode Normal — Une action, trois niveaux de qualité

```
┌─ Moissonner — Les Sables (18 ha, blé) ─────────────┐
│                                                     │
│  Maturité : ████████████████░░  92%                 │
│  💡 Optimal à 100% (dans 4 jours)                   │
│                                                     │
│  Si vous récoltez maintenant : 92 q/ha              │
│  Si vous attendez 4 jours    : 96 q/ha              │
│                                                     │
│  ⚠️ Météo : pluie annoncée dans 5 jours              │
│                                                     │
│  Matériel : Moissonneuse Claas Lexion 5300          │
│  ⏱️ Temps : 4,2 h  |  ⛽ Carburant : 28 L/ha         │
│                                                     │
│  [ Moissonner ]  [ Attendre ]                       │
└─────────────────────────────────────────────────────┘
```

**Qualité en Normal — 3 niveaux** :

| Niveau | Conditions d'obtention | Effet prix |
|--------|------------------------|:----------:|
| **Excellente** | Récolte à maturité optimale (95-100%) + 2 traitements + fertilisation complète | +10% |
| **Bonne** | Récolte à maturité correcte (85-95%) + itinéraire standard | 0% |
| **Moyenne** | Récolte trop tôt/tard, ou itinéraire incomplet | -8% |

### 8.2 Mode Expert — Critères de qualité réels

**a) Critères par culture**

| Culture | Critères | Seuils de classement |
|---------|----------|---------------------|
| **Blé tendre** | Protéines, PS, humidité, mycotoxines | Meunier : prot ≥ 11,5% + PS ≥ 76 |
| **Blé dur** | Mitadinage, protéines, moucheture | Semoulier : prot ≥ 14% |
| **Orge** | Calibrage, protéines | Brassicole : calibre ≥ 90%, prot 9,5-11,5% |
| **Colza** | Teneur en huile, impuretés | Base 40% huile, prime +1,5%/point |
| **Tournesol** | Teneur en huile | Base 44%, prime/malus |
| **Maïs** | Humidité, grains cassés | Séchage requis si > 15% |
| **Betterave** | Richesse en sucre, tare terre | Base 16°S |
| **Pomme de terre** | Calibre, taux de sucres réducteurs, défauts | Selon débouché |

**b) Impact des décisions sur la qualité**
```
BLÉ — Protéines (%)
  Base variété                      : 10,8% (Chevignon) à 13,5% (Izalco)
  + Azote 3e apport bien positionné : +0,6%
  + Soufre apporté                  : +0,3%
  - Rendement élevé (effet dilution): -0,4% si > 90 q/ha
  - Apport azoté tardif oublié      : -0,8%
  
  → Le joueur peut viser le rendement OU les protéines (arbitrage réel)

BLÉ — Poids spécifique (PS)
  Base variété                      : 76-80
  - Récolte en conditions humides   : -2 points
  - Échaudage (canicule)            : -3 points
  - Verse                           : -4 points
  
BLÉ — Mycotoxines (DON)
  + Précédent maïs                  : risque ×3
  + Pluie à floraison               : risque ×2
  - Fongicide anti-fusariose à floraison : risque ÷4
  → Si DON > 1250 ppb : DÉCLASSEMENT TOTAL (fourrager, -35% prix)
```

**c) Humidité et séchage**
```
Humidité à la récolte selon la date et la météo :

Blé   : 14-15% (optimal, pas de séchage)
        > 15% → séchage 0,80 €/t par point d'humidité
Maïs  : 25-32% à la récolte → séchage obligatoire
        Coût : 14 €/t pour passer de 30% à 15%
Colza : 9% optimal, > 9,5% → séchage

Le joueur Expert doit arbitrer :
  Récolter tôt (humide) = sécurité météo mais coût de séchage
  Récolter tard (sec) = pas de séchage mais risque de pluie/verse
```

### 8.3 Résidus de récolte

| Option | Effet économique | Effet agronomique (Expert) |
|--------|-----------------|---------------------------|
| **Presser la paille** | +120 à 180 €/ha (vente) ou stock litière | -30 u K, -8 u P, -0,05% MO/an |
| **Broyer et enfouir** | 0 € (coût du broyage : 18 €/ha) | +30 u K, +8 u P, +0,03% MO/an |
| **Pâturer les chaumes** | Économie de fourrage | Neutre |

**Mode Normal** : le joueur choisit, l'effet est visible sur la fertilité de la parcelle (jauge).
**Mode Expert** : bilan humique calculé, impact sur la matière organique à long terme.

### 8.4 Stockage

| Aspect | Normal | Expert |
|--------|:------:|:------:|
| Capacité | Silo (tonnes) | Idem + cellules séparées par qualité |
| Pertes | Aucune si en silo | 0,5%/mois (respiration) |
| Ventilation | Non modélisée | Requise, 0,50 €/t/mois |
| Insectes | Non | Risque si > 6 mois sans traitement |
| Mélange qualités | Autorisé | Déclasse tout le lot au niveau le plus bas ⚠️ |
| Perte extérieur | Aire non couverte : -8%/an | -12%/an + dégradation qualité |

### 8.5 Récolte en céréale immature (ensilage de blé/orge)

Le joueur peut choisir de récolter une céréale **avant maturité** pour la transformer en ensilage d'herbe-céréale (ou méteil immature). C'est un fourrage de haute valeur nutritive pour les ruminants.

#### Conditions et paramètres

| Paramètre | Valeur |
|-----------|--------|
| Stade de récolte | 60-80% de maturité (épiaison → grain laiteux-pâteux) |
| Cultures éligibles | Blé, orge, triticale, méteil (céréale + protéagineux) |
| Matériel requis | Ensileuse + remorques + tracteurs (charroi) |
| Rendement matière sèche | 8-12 t MS/ha (vs 7-8 t grain à maturité) |
| Valeur fourragère | 0,85-0,92 UFL/kg MS (supérieure à l'ensilage de maïs de qualité moyenne) |
| Stockage | Silo taupe ou silo couloir (obligatoire, fermentation lactique) |

#### Calcul du rendement et de la valeur (ADR-004)

```
Récolte à 70% de maturité (stade grain pâteux) :
  Rendement grain (si attendu maturité) : 80 q/ha = 8 t/ha
  Rendement plante entière immature    : 35 t brut/ha à 35% MS = 12,25 t MS/ha

Valeur alimentaire :
  12,25 t MS × 0,88 UFL/kg MS = 10 780 UFL/ha
  vs maïs ensilage : 15 t MS × 0,90 UFL = 13 500 UFL/ha
  → 80% de la valeur du maïs ensilage, MAIS pas besoin d'irrigation ni de désherbage

Valeur économique (achat équivalent) :
  Ensilage immature acheté : 45 €/t brut × 35 = 1 575 €/ha de valeur fourragère
  vs grain vendu : 80 q × 22 €/q = 1 760 €/ha

  → Le joueur « perd » 185 €/ha en valeur de vente…
  → …mais économise l'achat de fourrage (1 575 €) et libère la parcelle tôt pour un couvert
```

#### Temps de travail (ADR-004)

```
Récolte immature 10 ha (ensileuse 6 rangs, débit 3,5 ha/h) :
  Ensileuse : 10 ÷ 3,5 = 2,9 h
  Charroi (3 remorques) : 2,9 h × 3 chauffeurs = 8,7 h MO totale
  Tassage silo : 2,5 h
  Bâchage : 1,5 h
  Total : 15,6 h (répartis sur 1 journée)
```

#### Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Décision | Bouton « Récolter en immature » si maturité 60-80% | + choix du stade précis (impact valeur UFL) |
| Rendement | Forfait 12 t MS/ha affiché | Calculé : f(stade, variété, fertilisation, météo) |
| Valeur fourragère | Qualité « bonne » automatique | Variable : 0,80-0,95 UFL selon conditions de récolte |
| Intérêt principal | Fournir du fourrage sans maïs | + rotation améliorée (libération parcelle tôt), + CIVE possible après |

### 8.6 Quotas de production

Certaines cultures sont soumises à des **quotas** qui limitent la surface ou le volume par exploitation.

#### Tableau des quotas

| Culture | Quota | Calcul | Conséquence dépassement | Mode |
|---------|-------|--------|------------------------|:----:|
| Betterave sucrière | 2 ha minimum ou 10% de la SAU (le plus grand) | SAU × 0,10, plancher 2 ha | Excédent non collecté par la sucrerie → vente à -40% (alimentation animale) | Normal + Expert |
| Tabac | 2 ha maximum par exploitation | Fixe | Impossible de planter au-delà (refus système) | Normal + Expert |
| Pomme de terre féculière | 20% de la SAU maximum | SAU × 0,20 | Excédent non pris en contrat féculerie → vente libre à prix bas | Expert uniquement |
| Lin textile | 15% de la SAU maximum | SAU × 0,15 | Pas de rouissage possible pour l'excédent | Expert uniquement |

#### Mécanique de quota betterave

```
Exemple — Exploitation 120 ha SAU :
  Quota betterave = max(2 ha, 120 × 0,10) = 12 ha
  
  Si le joueur plante 15 ha :
    12 ha → collectés par la sucrerie au prix normal (32 €/t à 16°S)
    3 ha → excédent, proposé au marché à 19 €/t (alimentation animale)
    
  Le quota est recalculé chaque année en fonction de la SAU du joueur.
  Acheter des terres = augmenter son quota.
```

#### Mécanique de quota tabac

```
Le tabac est une culture de niche très rentable (marge 4 000-6 000 €/ha)
mais limitée à 2 ha pour éviter la spécialisation excessive.

Conditions d'accès :
  - Région à tradition tabacole (zone climatique ≥ 3)
  - Contrat avec le négociant (automatique en Normal, négociable en Expert)
  
Paramètres :
  Rendement : 2,5-3,5 t/ha
  Prix contrat : 4 500 €/t (garanti)
  Temps de travail : 250 h/ha/an (culture très exigeante en MO)
  Matériel spécifique : séchoir à tabac (8 000 €) + effeuilleuse (12 000 €)
```


---

## 8.6 Quotas de production

> Système 4.15 — Couverture fonctionnelle

Certaines cultures sont soumises à des quotas de surface, reflétant les contraintes réelles de filière et d'équilibre de marché.

### Règles de quota

| Culture | Quota maximum | Base de calcul | Conséquence dépassement |
|---------|:-------------:|:--------------:|------------------------|
| **Betterave sucrière** | 10% de la SAU ou 2 ha minimum | Surface cultivée N-1 (dernière année IG) | Surproduction non achetée par la coop — vente joueur uniquement à prix libre (souvent sous le plancher) |
| **Tabac** | 2 ha maximum par exploitation | Fixe | Semis refusé au-delà de 2 ha. Message : « Quota tabac atteint (2 ha max). » |
| **Pomme de terre** | 20% de la SAU | Surface cultivée N-1 | Coop refuse l'excédent. Vente joueur à prix libre. |
| **Lin textile** | 15% de la SAU | Surface cultivée N-1 | Coop refuse l'excédent. |

### Mécaniques

```
Vérification au moment du SEMIS :
  si culture.a_quota :
    surface_deja_en_culture = somme(parcelles.surface WHERE culture == cette_culture)
    quota_max = SAU × culture.quota_pct  (ou fixe si type = "fixe")
    
    si surface_deja + parcelle.surface > quota_max :
      Normal : avertissement + semis autorisé (mais excédent non achetable coop)
      Expert : semis BLOQUÉ au-delà du quota
```

### Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Affichage | Indicateur « quota X/Y ha » dans le panneau cultures | Même indicateur, pas d'alerte proactive |
| Dépassement | Autorisé avec avertissement (coop refuse l'excédent) | Interdit (semis bloqué) |
| Sanction | Aucune — juste la difficulté de vendre | Pénalité conditionnalité PAC (-5% aides) |

### Gameplay

Le quota n'est pas une contrainte punitive — c'est un incitateur à la **diversification**. Le joueur qui veut maximiser la betterave (très rentable) doit élargir sa SAU pour augmenter son quota proportionnel.

---

## 8.7 Engrais verts et CIPAN (Cultures Intermédiaires)

> Système 4.16 — Couverture fonctionnelle

Les couverts végétaux d'interculture (CIPAN) sont semés après la récolte d'été et détruits avant le semis suivant. Ils protègent le sol, fixent l'azote, et améliorent la structure.

### Espèces disponibles

| Espèce | Type | Semis | Destruction | Effet sol | Coût semence |
|--------|------|:-----:|:-----------:|-----------|:------------:|
| **Moutarde blanche** | Crucifère | Août-Sept | Nov-Déc (gel) | +2 MO, piège nitrates | 25 €/ha |
| **Phacélie** | Hydrophyllacée | Août-Sept | Nov-Déc | +2 MO, +1 Structure, mellifère | 40 €/ha |
| **Seigle** | Graminée | Sept-Oct | Février (broyage) | +3 MO, +2 Structure (racines) | 30 €/ha |
| **RGI (Ray-grass italien)** | Graminée | Août-Sept | Mars (broyage) | +2 MO, +1 N (si légumineuse assoc.) | 35 €/ha |
| **Trèfle incarnat** | Légumineuse | Août | Mars | +3 N (fixation), +2 MO | 45 €/ha |
| **Vesce** | Légumineuse | Août-Sept | Février | +4 N (fixation), +1 MO | 50 €/ha |
| **Avoine de printemps** | Graminée | Août | Nov-Déc (gel) | +1 MO, +1 Structure, rapide | 20 €/ha |

### Mécaniques de gameplay

```
SEMIS CIPAN :
  Conditions : parcelle récoltée (culture précédente terminée), pas de culture active
  Fenêtre : Août à Octobre (variable selon espèce)
  Coût HT : identique au semis (débit semoir × surface)
  Coût : semence (tableau) + HT semis

CROISSANCE :
  Le couvert pousse passivement (pas d'engrais, pas de traitement, pas d'irrigation)
  Durée : 2-4 mois IG selon espèce
  Pas de récolte — jamais vendu

DESTRUCTION :
  Gel naturel (moutarde, avoine) : automatique quand T° < -3°C (tick météo)
  Broyage mécanique (seigle, RGI, trèfle, vesce) : action joueur, 0.5 HT/ha (broyeur)
  Fenêtre : Novembre à Mars selon espèce

EFFET SUR LE SOL (appliqué au tick suivant la destruction) :
  MO (Matière Organique) : +apport selon tableau (cumul dans sol.MO, cap 100)
  N (Azote) : +apport pour légumineuses (fixation biologique, crédit N gratuit)
  Structure : +apport (améliore le score de structure du sol)
  Piège nitrates : réduit la perte de N hivernal de 50%
```

### Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Effet | Affiché comme bonus simple (« +2 fertilité ») | Détaillé par élément (MO +2, N +3, Structure +1) |
| Obligation | Facultatif | Requis pour éco-régime PAC (60 €/ha d'aide supplémentaire) |
| Destruction | Automatique à la bonne date | Manuelle (broyage = action + HT) |
| Choix espèce | 3 recommandées selon le précédent cultural | Toutes visibles, pas de suggestion |

### CIVE (Culture Intermédiaire à Vocation Énergétique)

Les CIVE sont un cas particulier de couvert : au lieu d'être détruites, elles sont **récoltées pour la méthanisation** (cf. `GDD-transformation` §3 et `GDD-cooperatives-car` §4.4).

| Espèce CIVE | Rendement | Pouvoir méthanogène | Prix vente méthaniseur |
|--------------|:---------:|:-------------------:|:----------------------:|
| Seigle CIVE | 6-8 t MS/ha | 280 Nm³ CH4/t MS | 15 €/t MS |
| RGI CIVE | 4-6 t MS/ha | 300 Nm³ CH4/t MS | 18 €/t MS |
| Triticale CIVE | 7-9 t MS/ha | 270 Nm³ CH4/t MS | 14 €/t MS |

Les CIVE nécessitent une récolte (action + HT ensilage) au lieu d'une destruction. Le joueur choisit au moment de la maturité : détruire (effet sol) ou récolter (vente au méthaniseur, effet sol réduit de moitié).

### Gameplay stratégique

Le CIPAN est un choix économique :
- **Ne rien faire** : le sol perd du N en hiver (lessivage -5 points N/an sans couvert)
- **Couvrir** : investissement 20-50 €/ha + HT semis/destruction → récupérer +2-4 MO et protéger le N
- **CIVE** : plus cher en HT mais génère un revenu via la méthanisation

C'est un gameplay d'optimisation inter-saison : le bon joueur ne laisse jamais un sol nu en hiver.

---

## 9. Équilibrage et scénarios

### 9.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| Un joueur Normal qui fait les actions de base | 85-95% du potentiel |
| Un joueur Normal négligent | 55-70% du potentiel (jamais < 40%) |
| Un joueur Expert optimal | 100-110% du potentiel |
| Un joueur Expert négligent | 30-60% (échec possible) |
| Écart entre cultures (marge/ha) | Max 40% entre la meilleure et la moins bonne |
| Temps de jeu nécessaire | 10-20 min/session, 3-4 sessions/semaine |

### 9.2 Scénario A — Blé en mode Normal, joueur appliqué

```
Parcelle : 18 ha, bonne terre, Beauce
Itinéraire : labour, semis 15/10, 180 u N, 1 herbicide, 1 fongicide
Précédent : colza

CALCUL
  Potentiel base (blé, Beauce)      85 q/ha
  × terre (bonne)                   ×1,10
  × fertilisation (dose conseillée) ×1,00
  × protection (2 passages)         ×1,03
  × météo (année normale)           ×1,00
  × rotation (après colza)          ×1,04
  × technique (labour)              ×1,00
  ─────────────────────────────────────────
  RENDEMENT                         100 q/ha

ÉCONOMIE (18 ha)
  Recette : 180 t × 220 €/t              39 600 €
  Paille  : 18 ha × 150 €                 2 700 €
  ─────────────────────────────────────────────
  Produit brut                           42 300 €

  Semences (180 kg × 0,42 €)             -1 361 €
  Engrais (180 u × 1,25 € × 18 ha)       -4 050 €
  Herbicide (45 €/ha)                      -810 €
  Fongicide (62 €/ha)                    -1 116 €
  Carburant (95 L/ha × 1,00 €)           -1 710 €
  ─────────────────────────────────────────────
  Charges opérationnelles                -9 047 €
  
  MARGE BRUTE                            33 253 €  = 1 847 €/ha
```
✅ **Validé** : marge confortable, progression assurée. Le joueur Normal réussit sans expertise.

### 9.3 Scénario B — Blé en mode Expert, joueur optimisant

```
Même parcelle. Choix du joueur :
  Variété Izalco (potentiel 82 q mais protéines 13,5%)
  Semis 8/10 (fenêtre optimale), densité 300 gr/m²
  Analyse de sol faite : reliquat 32 u, soufre carencé
  Azote fractionné 3 apports : 50 + 120 + 78 = 248 u
  Soufre 50 u apporté
  2 fongicides (T1 + T2 anti-fusariose)
  Régulateur (évite la verse)
  Précédent colza

CALCUL (loi du minimum)
  Potentiel variété Izalco             82 q/ha
  × f_sol (bonne terre, pH ok)         ×1,08  → 88,6 q
  Limitation azote : 248+32 = 280 u
    280 u / 3,1 u/q = 90 q             → non limitant ✅
  Limitation eau : 425/450 mm          → 84 q  ⚠️ légèrement limitant
  Limitation sanitaire : 2 fongicides  → 88 q  → non limitant
  ────────────────────────────────────────────
  Potentiel réalisable                 84 q
  × f_implantation (date + densité ok)  ×1,00
  × f_precedent (colza)                 ×1,06  → 89 q
  - pertes récolte (2%)                        → 87 q

  RENDEMENT                            87 q/ha
  Protéines                            13,1% ✅
  PS                                   79 ✅
  → Classement : Blé Amélioration Française (BAF)
  → Prime qualité : +32 €/t

ÉCONOMIE (18 ha)
  Recette : 156,6 t × (220 + 32) €/t     39 463 €
  Paille                                  2 700 €
  ─────────────────────────────────────────────
  Produit brut                           42 163 €

  Semences (variété BAF, plus chère)     -1 620 €
  Engrais N (248 u × 1,25 €)             -5 580 €
  Soufre (50 u × 0,90 €)                   -810 €
  Analyse de sol (amortie sur 5 ans)        -30 €
  Herbicide + régulateur                 -1 350 €
  Fongicides ×2                          -2 232 €
  Carburant (110 L/ha, plus de passages) -1 980 €
  ─────────────────────────────────────────────
  Charges opérationnelles               -13 602 €
  
  MARGE BRUTE                            28 561 €  = 1 587 €/ha
```

⚠️ **Analyse** : le joueur Expert a un rendement inférieur (87 vs 100 q) et une marge inférieure (1 587 vs 1 847 €/ha) ! Il a misé sur la qualité (protéines) mais le gain de prime (+32 €/t) ne compense pas la perte de rendement.

**C'est un résultat correct en termes de design** : le joueur Expert a fait un **mauvais arbitrage**. Il aurait dû :
- Choisir Chevignon (98 q de potentiel) au lieu d'Izalco (82 q) s'il visait le rendement
- Ou vendre en filière BAF avec un contrat à prime plus élevée (+50 €/t au lieu de +32)

**Scénario B-bis — même joueur avec le bon arbitrage** :
```
Variété Chevignon (potentiel 98 q), mêmes soins
  Potentiel                     98 q × 1,08 = 105,8 q
  Limitation eau                → 84 q ⚠️ toujours limitant
  → Le joueur irrigue 2 tours (60 mm) : 40 €/ha
  Limitation eau levée          → 100 q
  × précédent colza             ×1,06 → 106 q
  - pertes                              → 104 q

  RENDEMENT : 104 q/ha (+4 q vs Normal)
  Protéines : 11,6% (juste meunier, prime +12 €/t)

  Recette : 187,2 t × 232 €/t            43 430 €
  Paille                                  2 700 €
  Charges (dont irrigation 720 €)       -14 322 €
  ─────────────────────────────────────────────
  MARGE BRUTE                            31 808 €  = 1 767 €/ha
```

Toujours légèrement inférieur au Normal (1 847 €/ha) à cause des charges supplémentaires.

**Correction d'équilibrage nécessaire** : le mode Expert doit permettre de dépasser le Normal. Ajustements retenus :
1. **Rendement Normal réduit** : plafonner le rendement Normal à 92% du potentiel maximal (le joueur Normal ne peut pas atteindre l'excellence sans les leviers Expert)
2. **Primes qualité renforcées** en Expert : BAF +50 €/t (au lieu de 32), brassicole +40 €/t
3. **Effet précédent plus fort** en Expert : jusqu'à +10% (au lieu de +6%)

**Recalcul Normal avec plafond 92%** :
```
Rendement Normal : 100 q → plafonné à 85 × 1,10 × 0,92 = 86 q/ha
Marge brute      : 28 000 € = 1 555 €/ha
```

**Comparaison finale** :
| Mode | Rendement | Marge/ha |
|------|:---------:|:--------:|
| Normal appliqué | 86 q/ha | 1 555 € |
| Expert bien optimisé | 104 q/ha | 1 767 € (+14%) ✅ |
| Expert mal arbitré | 87 q/ha | 1 587 € (+2%) |
| Normal négligent | 58 q/ha | 890 € |

✅ **Équilibrage validé** : Expert bien joué = +14%. Expert mal joué = à peine mieux que Normal. Normal = confortable et sans risque.

### 9.4 Scénario C — Comparaison de marges par culture (Normal)

| Culture | Rendement | Prix | Produit | Charges | **Marge/ha** |
|---------|:---------:|:----:|:-------:|:-------:|:------------:|
| Blé tendre (+paille) | 86 q | 220 €/t | 2 042 € | 487 € | **1 555 €** |
| Orge hiver (+paille) | 79 q | 195 €/t | 1 690 € | 445 € | **1 245 €** |
| Colza | 37 q | 470 €/t | 1 739 € | 520 € | **1 219 €** |
| Maïs grain irrigué | 102 q | 200 €/t | 2 040 € | 1 150 € | **890 €** |
| Tournesol | 27 q | 410 €/t | 1 107 € | 380 € | **727 €** |
| Pois protéagineux | 42 q | 270 €/t | 1 134 € | 290 € | **844 €** |
| Betterave | 88 t | 33 €/t | 2 904 € | 780 € | **2 124 €** |
| Prairie (foin vendu) | 7 t MS | 110 €/t | 770 € | 220 € | **550 €** |

**Écart max** : betterave (2 124 €) vs prairie (550 €) = ×3,9. Acceptable car :
- La betterave nécessite un quota et un contrat (accès limité)
- La prairie sert à nourrir les animaux (valorisation indirecte)
- Sans betterave : blé (1 555) vs tournesol (727) = ×2,1 ✅

### 9.5 Points à valider en playtest

**Recette SimAgri (ADR-002) — bloquant**
- [ ] Le cycle d'une culture est-il aussi fluide que dans SimAgri ?
- [ ] Le joueur Normal peut-il réussir sans lire de documentation ?
- [ ] Les fenêtres de travaux sont-elles assez larges pour un joueur occasionnel ?
- [ ] La récolte procure-t-elle la même satisfaction ?
- [ ] Un joueur qui oublie une action est-il pénalisé sans être découragé ?

**Profondeur Expert**
- [ ] Le joueur Expert comprend-il pourquoi son rendement est ce qu'il est ?
- [ ] La loi du minimum est-elle lisible (le facteur limitant est-il identifiable) ?
- [ ] Les arbitrages (rendement vs qualité, variétés) sont-ils intéressants ?
- [ ] L'effet précédent incite-t-il vraiment à planifier ses rotations ?
- [ ] Le mode Expert rapporte-t-il plus que Normal quand bien joué ?

---

## Annexe — Récapitulatif des paramètres

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Actions par culture | 6-7 | 8-12 |
| Plafond de rendement | 92% du potentiel | 110% du potentiel |
| Plancher de rendement | 40% (garanti) | 0% (échec possible) |
| Variétés | Non | 3-4 par culture |
| Fertilisation | 1 apport, N global | 3-4 apports, N-P-K-Mg-S |
| Analyse de sol | Non | 150 €, 5 ans |
| Traitements | 1 bouton "Traiter" | 5 familles, seuils, résistances |
| Fenêtre de semis | 3-4 semaines | 10 jours optimaux |
| Pénalité retard semis | -3% max | -1%/jour puis -30% |
| Météo | Jauges + blocage forte pluie/vent | Praticabilité, 7 événements climatiques |
| Effet précédent | +5% / -12% | +10% / -20% (4 composantes) |
| Pression maladie | Non | Cumulative par parcelle |
| Qualité | 3 niveaux | Critères réels (protéines, PS, huile...) |
| Séchage | Non | Coût selon humidité |
| Pertes récolte | Non | 2% + retard + conditions |
| Pertes stockage | Non | 0,5%/mois |
| Irrigation | Bouton, 40 €/ha | Bilan hydrique, doses, restrictions |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Plafond rendement Normal à 92%, primes qualité Expert renforcées, effet précédent Expert à +10% | Scénario B révélait qu'Expert rapportait moins que Normal |
| 2026-08-04 | Ajout §8.5 Céréale immature + §8.6 Quotas de production | Audit couverture fonctionnelle — systèmes 4.11 et 4.15 partiels |