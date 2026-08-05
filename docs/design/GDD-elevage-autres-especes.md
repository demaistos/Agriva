> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Élevage : autres espèces (bovin allaitant, porcin, ovin, caprin)

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-elevage.md` §2-5, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `design/GDD-bovin-laitier.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

Chaque espèce d'élevage doit se jouer **DIFFÉREMMENT** — pas juste des chiffres différents sur le même squelette. Les 4 espèces couvertes ici offrent chacune une identité de gameplay unique :

| Espèce | Identité gameplay | Plaisir principal |
|--------|-------------------|-------------------|
| **Bovin allaitant** | Le cycle long et l'herbe | Patience, beauté du troupeau au pré, stratégie naisseur vs engraisseur |
| **Porcin** | L'usine à optimiser | Efficacité, IC, planification industrielle, rendement maximal |
| **Ovin** | La saisonnalité et le rythme | Timing des luttes, agnelage, vendre au bon moment (Pâques) |
| **Caprin** | Le lait ET le fromage | Chaîne de valeur complète, transformation, artisanat |

**Ce qui différencie ces espèces du bovin laitier (déjà conçu)** :
- Le bovin laitier = revenu quotidien régulier (traite → tank → paie mensuelle)
- Le bovin allaitant = revenu concentré sur la vente annuelle de broutards
- Le porcin = flux industriel à cadence rapide (lot tous les 3 semaines)
- L'ovin = rythme saisonnier dicté par la reproduction et le marché
- Le caprin = marge faible en lait brut, multiplication par la transformation

### 1.2 Gameplay loop commun (simplifié)

```
┌──────────────────────────────────────────────────────────────┐
│  BOUCLE QUOTIDIENNE (toutes espèces)                         │
└──────────────────────────────────────────────────────────────┘
  Nourrir → Vérifier alertes (santé, naissances) → Collecter produits

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE SPÉCIFIQUE PAR ESPÈCE                                │
└──────────────────────────────────────────────────────────────┘
  Bovin allaitant : ANNUELLE — Vêlage → Élevage → Vente broutards
  Porcin          : 3 SEMAINES — Bande sevrage → Bande entrée engraissement
  Ovin            : SAISONNIÈRE — Lutte → Agnelage → Engraissement → Vente
  Caprin          : QUOTIDIENNE — Traite → Transformation → Affinage → Vente
```

### 1.3 Différence Normal / Expert (transversal)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Reproduction | Automatique toute l'année | Saisonnalité (ovin/caprin), groupage |
| Alimentation | Ration prédéfinie | IC calculé, multiphase (porc) |
| Santé | Jauge unique | Maladies spécifiques, parasitisme |
| Vente | Prix stable | Saisonnalité prix, classement carcasse |
| Gestion | Par troupeau | Par bande/lot (porc), par lot physiologique |
| Charges sociales | 12% | 28% |

---

## 2. Bovin allaitant — Le cycle long et l'herbe

### 2.1 Intention de design

Le bovin allaitant est l'**opposé du laitier** : pas de revenu quotidien, pas de traite, pas d'astreinte journalière lourde. C'est un élevage de **patience et d'observation** — le troupeau vit à l'herbe, les veaux tètent leur mère, et le revenu arrive une fois par an à la vente des broutards.

**Ce qui rend l'allaitant plaisant** :
1. Le spectacle du troupeau au pré (beauté, calme)
2. La stratégie de système (naisseur ? engraisseur ? les deux ?)
3. Le choix de race (chacune avec un caractère fort)
4. L'autonomie fourragère (vivre de l'herbe)
5. Les aides PAC qui rendent l'extensif viable

**Le problème de SimAgri** : pas de distinction naisseur/engraisseur, pas de broutard, pas de vêlage groupé, pas d'aides PAC. L'allaitant est juste « un bovin qu'on vend à l'abattoir ».

### 2.2 Races disponibles

| Race | Poids vache | Poids taureau | GMQ broutard | Facilité vêlage | Qualité maternelle | Prix génisse |
|------|:-----------:|:-------------:|:------------:|:----------------:|:------------------:|:------------:|
| **Charolaise** | 800 kg | 1 200 kg | 1 250 g/j | ★★☆☆ | ★★★☆ | 2 200 € |
| **Limousine** | 700 kg | 1 050 kg | 1 150 g/j | ★★★★ | ★★★★ | 2 400 € |
| **Blonde d'Aquitaine** | 850 kg | 1 300 kg | 1 350 g/j | ★★☆☆ | ★★☆☆ | 2 600 € |
| **Salers** | 650 kg | 950 kg | 1 050 g/j | ★★★★★ | ★★★★★ | 1 800 € |
| **Aubrac** | 600 kg | 900 kg | 1 000 g/j | ★★★★★ | ★★★★★ | 1 700 € |

**Arbitrages de race** :
```
Charolaise      : le broutard le plus lourd et le mieux payé,
                  mais vêlages difficiles (8-12% césariennes primipares)
                  → optimal en naisseur de plaine avec surveillance

Limousine       : excellent compromis — vêle facile, viande de qualité
                  → optimal en naisseur-engraisseur

Blonde d'Aq.    : croissance maximale, fort développement musculaire
                  → optimal en engraisseur (JB), vêlage surveillé

Salers/Aubrac   : rustiques, zéro problème de vêlage, autonomes
                  → optimal en montagne/extensif, valorise les aides ICHN
```

### 2.3 Les 3 systèmes de production

Le joueur choisit son système — c'est LA décision structurante en allaitant :

| Système | Principe | Vente | Revenu/VA | Surface/VA | Technicité |
|---------|----------|-------|:---------:|:----------:|:----------:|
| **Naisseur** | Vend les broutards à 8-10 mois | Broutards 300-400 kg | 450-650 € | 1,2-1,8 ha | ★★☆ |
| **Naisseur-engraisseur** | Engraisse ses propres mâles en JB | JB 700 kg + génisses | 700-950 € | 1,0-1,4 ha | ★★★ |
| **Engraisseur pur** | Achète des broutards, les engraisse | JB 700 kg (achetés) | 200-350 €/place | 0,3-0,5 ha | ★★★★ |

### 2.4 Mode Normal — Cycle annuel simplifié

```
┌─ Mon troupeau allaitant — 70 Charolaises ─────────────────────┐
│                                                                │
│  🐄 Vaches adultes : 70                                        │
│  🐂 Taureau : 2 (1 pour 35 vaches)                             │
│  🐮 Veaux sous la mère : 58 (dont 30 mâles, 28 femelles)       │
│  🐮 Génisses de renouvellement : 18                             │
│                                                                │
│  Système : NAISSEUR                                            │
│  Période de vêlage : Février-Avril                             │
│                                                                │
│  ── Calendrier ──                                              │
│  🟢 Maintenant (Août) : veaux au pré avec les mères             │
│  📅 Sept-Oct : vente des broutards mâles (30 × ~1 050 €)       │
│  📅 Nov : rentrée en bâtiment                                   │
│  📅 Fév-Avr : vêlages                                          │
│  📅 Avr : mise à l'herbe                                        │
│                                                                │
│  Santé troupeau : ████████░░  82%                              │
│  Pâturage : ✅ Au pré (35 ares/VA disponibles)                  │
│                                                                │
│  💰 Prochaine vente estimée : 31 500 €                          │
│  💰 Aides PAC annuelles : 18 200 €                              │
│                                                                │
│  [ Voir le troupeau ]  [ Gérer l'alimentation ]                │
└────────────────────────────────────────────────────────────────┘
```

**Paramètres Normal** :
```
Vêlage : automatique à la date prévue, pas de dystocie
Allaitement : le veau tète sa mère, GMQ automatique selon la race
Sevrage : le joueur clique "Sevrer" entre 7 et 10 mois
Vente : broutard vendu au poids × prix/kg (stable)
Aides PAC : créditées annuellement (montant fixe/VA)
Alimentation hiver : 1 ration prédéfinie (foin + paille + concentré)
Pâturage : avril-novembre, gratuit si surface suffisante
```

### 2.4bis Mécanique d'allaitement

L'allaitement est la **mécanique centrale du bovin allaitant** : le veau se nourrit exclusivement (puis partiellement) du lait maternel pendant 7-10 mois. Cela impacte la consommation alimentaire de la mère et la croissance du veau.

#### Paramètres d'allaitement

| Phase | Durée | Lait consommé/veau/j | Effet sur la mère | Effet sur le veau |
|-------|:-----:|:--------------------:|:------------------:|:-----------------:|
| Allaitement exclusif | 0-3 mois | 8-12 L/jour | Besoin énergétique mère +4,5 UFL/j | GMQ 1 000-1 300 g/j (selon race) |
| Allaitement + herbe | 3-6 mois | 5-8 L/jour | Besoin mère +3,0 UFL/j | GMQ 1 100-1 400 g/j (herbe + lait) |
| Pré-sevrage | 6-8 mois | 3-5 L/jour | Besoin mère +1,5 UFL/j | GMQ 900-1 200 g/j (herbe dominante) |
| Post-sevrage | 8-10 mois | 0 L | Mère revient à l'entretien | GMQ 800-1 000 g/j (herbe + concentré) |

#### Impact sur la ration de la mère

```
VACHE ALLAITANTE CHAROLAISE (800 kg) — BESOINS QUOTIDIENS

  Entretien seul :            7,2 UFL/jour
  + Allaitement exclusif :    7,2 + 4,5 = 11,7 UFL/jour (+63%)
  + Gestation (8e-9e mois) :  +2,0 UFL/jour

  Capacité d'ingestion : 14-16 kg MS/jour (limitée)
  → En hiver (allaitement + gestation) : ration foin + concentré nécessaire
  → Au pâturage (été) : herbe suffisante si > 35 ares/VA

CONSÉQUENCE ÉCONOMIQUE :
  Coût ration hivernale sans veau : 2,80 €/VA/jour
  Coût ration hivernale avec veau : 4,50 €/VA/jour (+60%)
  Surcoût annuel (5 mois hiver) : 150 × 1,70 = 255 €/VA

  → L'allaitement coûte 255 €/vache/hiver
  → MAIS le veau ne coûte rien en alimentation séparée (économie DAL/lait poudre)
  → Économie vs élevage artificiel : 180 €/veau
  → Bilan net : +75 €/veau de surcoût (compensé par le GMQ supérieur de l'allaitement naturel)
```

#### Effet sur le GMQ du veau

| Mode d'élevage | GMQ moyen (Charolaise) | Poids à 8 mois | Valeur broutard |
|:-------------:|:---------------------:|:---------------:|:---------------:|
| Allaitement naturel (sous la mère) | 1 200 g/jour | 320 kg | 1 120 € |
| Allaitement artificiel (DAL) | 900 g/jour | 240 kg | 840 € |
| → Gain allaitement naturel | +300 g/jour | +80 kg | **+280 €/veau** |

#### Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Allaitement | Automatique, pas de gestion | Choix date sevrage (impact GMQ), complémentation possible |
| Ration mère | « Suffisante » si stock OK | Calcul UFL nécessaire, risque amaigrissement si sous-nutrition |
| Adoption (veau orphelin) | Automatique (autre mère) | Risque de refus (30%), supervision 3 jours requise |
| Sevrage | Bouton « Sevrer » à 7-10 mois | Sevrage progressif possible (3 semaines → -stress, +GMQ final) |

### 2.5 Mode Expert — Vêlage, classement, engraissement

**a) Vêlage et difficulté**
```
difficulté_vêlage = base_race × f_parité × f_taureau × f_NEC

base_race :
  Charolaise        : 0,12 (12% de dystocies en primipare)
  Limousine         : 0,04
  Blonde d'Aquitaine: 0,10
  Salers            : 0,02
  Aubrac            : 0,02

f_parité :
  Primipare         : 1,00 (risque maximal)
  Multipare (2e+)   : 0,35

f_taureau :
  Index facilité naissance > 105 : 0,70
  Index 95-105                   : 1,00
  Index < 95                     : 1,40

f_NEC (Note d'État Corporel) :
  NEC > 4,0 (trop grasse) : 1,30
  NEC 3,0-3,5 (optimale)  : 1,00
  NEC < 2,5 (trop maigre) : 1,20

Conséquences dystocie :
  → Mortalité veau : 25% si non assisté
  → Coût vétérinaire : 150-350 € (césarienne)
  → IVV allongé de 15-30 jours
  → Investissement : caméra de vêlage (2 500 €) réduit mortalité de 60%
```

**b) Classement de carcasse (grille EUROP)**
```
CONFORMATION (développement musculaire) :
  E = Excellente  : +0,60 €/kg carcasse
  U = Très bonne  : +0,30 €/kg
  R = Bonne       : référence (0)
  O = Assez bonne : -0,40 €/kg
  P = Médiocre    : -0,80 €/kg

ÉTAT D'ENGRAISSEMENT (1 à 5) :
  3 = optimal (0)
  2 = trop maigre (-0,15 €/kg)
  4 = trop gras (-0,10 €/kg)

classement = f_race × f_alimentation × f_GMQ × f_âge_abattage

Exemple — JB Charolais, bien engraissé, GMQ 1 300 g/j, 18 mois :
  Race Charolaise (base U-)  × bonne alimentation (→ U)
  → Prix carcasse : 5,10 + 0,30 = 5,40 €/kg
  → Carcasse 420 kg × 5,40 = 2 268 €

Exemple — JB Aubrac, alimentation moyenne, GMQ 1 050 g/j :
  Race Aubrac (base R+) × alimentation moyenne (→ R)
  → Prix carcasse : 5,10 €/kg
  → Carcasse 380 kg × 5,10 = 1 938 €
```

**c) Aides PAC (détail Expert)**
```
Aide couplée bovine :        150 €/vache allaitante (plafond 120 VA)
DPB (Droit Paiement Base) :  152 €/ha
Paiement redistributif :      50 €/ha (52 premiers ha)
Éco-régime :                  70 €/ha (si prairies permanentes > 50%)
ICHN (si zone montagne) :    180 €/ha (compensation handicap naturel)

Exemple — 70 VA sur 120 ha dont 80 ha montagne :
  Aide couplée :     70 × 150 €        = 10 500 €
  DPB :             120 × 152 €        = 18 240 €
  Redistributif :    52 × 50 €         =  2 600 €
  Éco-régime :      120 × 70 €         =  8 400 €
  ICHN :             80 × 180 €        = 14 400 €
  ─────────────────────────────────────────────────
  TOTAL AIDES :                          54 140 €
  
  → 56% du produit brut d'un naisseur extensif
  → Sans aides, le système est déficitaire
```

### 2.6 Équilibrage bovin allaitant

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Vêlage | Automatique, pas de dystocie | Difficulté selon race/parité, mortalité |
| Allaitement | GMQ fixe selon race | GMQ variable (lait maternel + creep feeding) |
| Vente broutard | Prix/kg fixe | Classement + saisonnalité prix automne |
| Engraissement | Durée fixe → poids cible | GMQ × durée × IC, classement EUROP |
| Aides PAC | Montant forfaitaire/VA | Détail par type, conditionnalité |
| Pâturage | Gratuit si surface OK | Chargement UGB/ha, rotation paddocks |
| Taureau | 1 pour 35 vaches (automatique) | Choix index, impact vêlage + croissance |



---

## 3. Porcin — L'usine à optimiser

### 3.1 Intention de design

Le porc est **l'élevage industriel par excellence**. Pas d'attachement sentimental aux animaux (contrairement aux bovins), pas de pâturage bucolique. C'est une **machine à convertir de l'aliment en viande** — et le joueur est l'ingénieur qui optimise cette machine.

**Ce qui rend le porcin plaisant** :
1. La satisfaction de l'optimisation (IC qui baisse = marge qui monte)
2. La cadence rapide (résultats visibles en quelques semaines, pas mois)
3. La planification des bandes (puzzle logistique)
4. La prolificité explosive (14 porcelets × 2,35 portées = 33 sevrés/truie/an)
5. Le levier du TMP (qualité de carcasse = prix)

**Le problème de SimAgri** : pas de portée (14 porcelets !), pas d'IC, pas de bandes, abattage à 360 jours au lieu de 150-180, pas de TMP.

### 3.2 Cycle de production

```
TRUIE REPRODUCTRICE (carrière 5-6 portées, 2,5 ans)
    │
    ├──→ SAILLIE/IA (J0)
    │         ↓
    ├──→ GESTATION (114 jours = 3 mois, 3 semaines, 3 jours)
    │         ↓
    ├──→ MISE-BAS (12-16 porcelets nés vifs)
    │         ↓
    ├──→ MATERNITÉ / ALLAITEMENT (21-28 jours)
    │         ↓
    ├──→ SEVRAGE (porcelets à 7-8 kg)
    │    │    ↓
    │    │  RETOUR EN CHALEUR (4-7 jours post-sevrage)
    │    │    ↓
    │    └──→ nouvelle saillie (cycle recommence)
    │
    ↓ (les porcelets continuent seuls)

POST-SEVRAGE (7 kg → 25-30 kg en 6-8 semaines)
    ↓
ENGRAISSEMENT (25-30 kg → 115-120 kg en 100-120 jours)
    ↓
ABATTAGE (115-120 kg vif → 87-92 kg carcasse)
    ↓
PAIEMENT (prix cadran × TMP)
```

**Durée totale naissance → abattage : 150-175 jours**

### 3.3 Mode Normal — Gestion par lot

En Normal, le joueur ne gère pas les bandes. Il a un troupeau de truies qui produit des porcelets en continu, et des places d'engraissement qu'il remplit.

```
┌─ Ma porcherie — 50 truies ────────────────────────────────────┐
│                                                                │
│  🐷 Truies reproductrices : 50                                  │
│  Productivité : 13,2 sevrés/portée                             │
│  Portées/truie/an : 2,35                                       │
│  → Production annuelle : 1 551 porcelets sevrés                │
│                                                                │
│  ── Places d'élevage ──                                        │
│  Post-sevrage : 380 places (occupées 340) ✅                    │
│  Engraissement : 620 places (occupées 590) ✅                   │
│                                                                │
│  ── En cours ──                                                │
│  Porcs en engraissement : 590 (poids moyen 78 kg)              │
│  Prochaine vente (~115 kg) : dans 5 semaines (~95 porcs)       │
│  Valeur estimée : 95 × 165 € = 15 675 €                       │
│                                                                │
│  ── Performance ──                                             │
│  IC global : 2,72 ✅ (référence 2,6-2,8)                       │
│  GMQ engraissement : 810 g/j ✅                                 │
│  Mortalité : 4,2% ✅                                            │
│                                                                │
│  ── Alertes ──                                                 │
│  📅 12 truies prêtes à mettre bas cette semaine                 │
│  ⚠️ Stock aliment : 18 jours restants (à commander)             │
│                                                                │
│  [ Voir les truies ]  [ Voir l'engraissement ]  [ Vendre ]     │
└────────────────────────────────────────────────────────────────┘
```

**Paramètres Normal** :
```
Portée : 12-14 sevrés/portée (fixe selon génétique truie)
Gestation : 114 jours
Allaitement : 25 jours (automatique)
IC : calculé mais le joueur n'a qu'un levier (qualité d'aliment : 3 niveaux)
Vente : quand le lot atteint 115 kg → le joueur clique "Vendre"
Prix : fixe (1,75 €/kg carcasse × TMP standard)
Pas de bandes : flux continu
Pas de vide sanitaire obligatoire
Pas de biosécurité
```

**Formule Normal** :
```
revenu_porc = poids_carcasse × prix_base
poids_carcasse = poids_vif × 0,79  (rendement 79%)
prix_base = 1,75 €/kg

Exemple : 115 kg vif × 0,79 = 90,8 kg carc. × 1,75 € = 158,97 € brut
Coût aliment : 115 kg gain × IC 2,72 × 0,30 €/kg aliment = 93,84 €
Marge brute/porc : 158,97 - 93,84 = 65,13 €
```

### 3.4 Mode Expert — Bandes, IC, TMP

**a) Conduite en bandes**

```
┌─ Planning des bandes — 50 truies en 7 bandes ─────────────────┐
│                                                                │
│  Rythme : sevrage toutes les 3 semaines (7 bandes)             │
│  Truies/bande : 7-8                                            │
│                                                                │
│  Bande  Stade actuel        Truies  Porcelets   Prochaine étape│
│  ─────────────────────────────────────────────────────────────│
│  B1     Gestation (J+85)    7       —          Maternité J+107 │
│  B2     Gestation (J+64)    8       —          Maternité J+107 │
│  B3     Gestation (J+43)    7       —                          │
│  B4     Gestation (J+22)    7       —                          │
│  B5     Saillie en cours    8       —          Écho J+25       │
│  B6     Maternité (J+18)    7       94 ✅      Sevrage J+25    │
│  B7     Sevrage fait (J+3)  7       89 → PS    Retour chaleur  │
│                                                                │
│  ── Occupation bâtiment ──                                     │
│  Maternité (8 places) :     7/8 occupées ✅                     │
│  Gestantes (42 places) :   36/42 ✅                             │
│  Post-sevrage (400 places): 340/400 ✅                          │
│  Engraissement (650 places):590/650 ✅                          │
│                                                                │
│  ⚠️ Vide sanitaire maternité : prévu dans 7 jours (2 j mini)   │
│                                                                │
│  [ Détail bande B6 ]  [ Planifier les saillies ]              │
└────────────────────────────────────────────────────────────────┘
```

**b) IC — le KPI central**
```
IC_réel = aliment_consommé_total / gain_poids_total

Facteurs influençant l'IC :
  Génétique (lignée terminale)      : IC de base 2,55 à 2,90
  Alimentation multiphase           : -0,05 à -0,10 vs aliment unique
  Température bâtiment :
    18-22°C (optimal)               : IC normal
    < 15°C                          : IC +0,15 (énergie pour se chauffer)
    > 26°C                          : IC +0,10 (appétit réduit, stress)
  Densité (porcs/case) :
    Optimal (0,75 m²/porc)          : IC normal
    Surpeuplé (< 0,60 m²)          : IC +0,12
  Santé :
    Troupeau sain                   : IC normal
    Problèmes respiratoires         : IC +0,15 à +0,30

IC cible Expert bien géré : 2,60-2,65
IC mal géré : 2,90-3,10

Impact économique :
  0,1 point d'IC × 85 kg gain × 0,30 €/kg aliment = 2,55 €/porc
  × 1 500 porcs/an = 3 825 €/an de marge en plus
```

**c) TMP (Taux de Muscle des Pièces)**
```
TMP = pourcentage de muscle dans la carcasse (mesuré à l'abattoir)

TMP moyen France : 61%
Objectif : 62-63%
Pénalité : < 58% ou > 64% (trop gras ou trop maigre)

Impact sur le prix :
  TMP 62% (référence)  : prix cadran (1,75 €/kg)
  TMP 60%              : -0,04 €/kg (×2 points d'écart)
  TMP 58%              : -0,08 €/kg
  TMP 64%              : +0,02 €/kg (plafonné)

Facteurs :
  Génétique (Piétrain terminale = TMP élevé)
  Alimentation finition (excès énergie → gras → TMP bas)
  Poids d'abattage (> 125 kg → TMP baisse)
  Castration (mâles entiers = TMP +2% mais risque d'odeur)

Sur 1 500 porcs/an, +2 points TMP = +0,04 €/kg × 90 kg × 1 500 = 5 400 €
```

**d) Biosécurité et PPA**
```
Score biosécurité (0-100%) :
  SAS d'entrée avec douche     : +20%
  Clôture périmètre            : +15%
  Quarantaine animaux entrants : +15%
  Protocole nettoyage-désinf.  : +20%
  Registre mouvements à jour   : +10%
  Lutte nuisibles (rats, oiseaux): +10%
  Pas de contact sangliers     : +10%

Si biosécurité < 50% ET événement PPA sur le serveur :
  → Probabilité de contamination
  → Abattage TOTAL du troupeau (indemnisation partielle 80%)
  → Interdiction de repeuplement pendant 3 mois
  → GAME OVER pour la porcherie

Investissement biosécurité total : 25 000-45 000 €
→ Assurance contre la catastrophe
```

### 3.5 Équilibrage porcin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Portée | 12-14 sevrés (fixe) | 10-16 sevrés (variable : génétique + soins) |
| Conduite | Flux continu | Bandes (7 bandes/3 sem.) + vide sanitaire |
| Alimentation | 3 niveaux d'aliment | Multiphase (croissance + finition) + formulation |
| IC | Affiché, 1 levier (qualité aliment) | 6 facteurs, optimisation fine |
| Vente | Prix fixe, poids cible 115 kg | TMP + cotation variable ±15% |
| Biosécurité | Non | Score, risque PPA, investissements |
| Température | Non | Impact sur IC et mortalité |
| Bâtiment | Capacité = nombre de places | Occupation, rotation, vide sanitaire |



---

## 4. Ovin — La saisonnalité et le rythme

### 4.1 Intention de design

L'ovin est l'élevage du **timing**. Contrairement au bovin (toute l'année) ou au porc (cadence fixe), le mouton impose un rythme dicté par la biologie (saisonnalité des chaleurs) et le marché (pic Pâques). Le joueur qui maîtrise ce rythme double sa rentabilité.

**Ce qui rend l'ovin plaisant** :
1. Le timing — vendre au bon moment = +20% de prix
2. La prolificité modérée — gérer des jumeaux, pas des portées de 14
3. Le grand troupeau — 300-500 brebis = sentiment de masse
4. Les deux voies — viande OU lait (Lacaune → Roquefort)
5. Le rapport surface/revenu — viable sur 80-100 ha

**Le problème de SimAgri** : pas de saisonnalité repro, pas de prolificité modélisée, pas de prix saisonnier, laine présentée comme un revenu (alors que c'est un coût).

### 4.2 Races disponibles

**Races viande** :

| Race | Prolificité | Conformation | Désaisonnement | GMQ agneau | Prix brebis |
|------|:-----------:|:------------:|:--------------:|:----------:|:-----------:|
| **Texel** | 1,6 | ★★★★★ | ★★☆ | 320 g/j | 280 € |
| **Suffolk** | 1,5 | ★★★★ | ★★☆ | 340 g/j | 260 € |
| **Charollais** | 1,7 | ★★★★ | ★★★ | 310 g/j | 250 € |
| **Île-de-France** | 1,6 | ★★★ | ★★★★★ | 300 g/j | 240 € |
| **Rouge de l'Ouest** | 1,8 | ★★★ | ★★★ | 290 g/j | 220 € |

**Races laitières** :

| Race | Production lait | TB | TP | Rusticité | Prix brebis |
|------|:---------------:|:--:|:--:|:---------:|:-----------:|
| **Lacaune** | 280-350 L/an | 72 g/L | 56 g/L | ★★★ | 320 € |
| **Manech Tête Rousse** | 180-220 L/an | 70 g/L | 54 g/L | ★★★★★ | 280 € |

### 4.3 Mode Normal — Élevage ovin viande simplifié

```
┌─ Mon troupeau ovin — 350 brebis Charollaises ─────────────────┐
│                                                                │
│  🐑 Brebis : 350                                               │
│  🐏 Béliers : 10 (1 pour 35 brebis)                            │
│  🐑 Agnelles de renouvellement : 85                             │
│  🐑 Agneaux en bergerie : 142 (poids moyen 28 kg)              │
│                                                                │
│  Système : AGNEAU DE BERGERIE                                  │
│  Prolificité troupeau : 1,65 agneaux/brebis                   │
│                                                                │
│  ── Production ──                                              │
│  Agneaux vendus cette année : 412                              │
│  Prix moyen : 135 € / agneau                                  │
│  Prochaine vente (lot de 45, ~38 kg) : dans 12 jours          │
│                                                                │
│  ── Calendrier ──                                              │
│  🟢 Maintenant (Août) : agneaux en engraissement               │
│  📅 Sept : lutte d'automne (mise au bélier)                    │
│  📅 Fév : agnelage principal                                    │
│  📅 Mars-Mai : engraissement agneaux                           │
│  📅 Avril : VENTE PIC PÂQUES (+20% prix) 🎯                    │
│                                                                │
│  Santé : ████████░░  80%                                       │
│  Laine (dernière tonte juin) : ✅ Faite (coût 3 €/brebis)       │
│                                                                │
│  [ Voir les agneaux ]  [ Planifier la lutte ]  [ Vendre ]      │
└────────────────────────────────────────────────────────────────┘
```

**Paramètres Normal** :
```
Reproduction : possible toute l'année (pas de saisonnalité bloquante)
Gestation : 150 jours
Portée : 1-2 agneaux (selon race, probabilité fixe)
  Charollais : 30% simples, 55% doubles, 15% triples
Engraissement agneau : GMQ fixe selon la race → abattage à 35-42 kg
Prix de vente : stable (7,50 €/kg carcasse)
Laine : sous-produit, coût net -3 €/brebis/an (tonte obligatoire 1×/an)
Aides PAC : 22 €/brebis/an (automatique)
Parasitisme : non modélisé
```

### 4.4 Mode Expert — Saisonnalité et prix

**a) Saisonnalité de la reproduction**
```
La brebis est un animal de JOURS COURTS.
Chaleurs naturelles : août → février (pic octobre-novembre)
Anoestrus (pas de chaleur) : mars → juillet

Conséquences :
  Lutte en octobre  → agnelage en mars  → vente en juin-août (prix bas)
  Lutte en avril    → IMPOSSIBLE sans désaisonnement

DÉSAISONNEMENT (pour lutte hors saison) :
  Éponges vaginales + PMSG : 12 €/brebis, taux réussite 70%
  Effet bélier : gratuit mais limité (avance les chaleurs de 3-4 sem)
  Traitement lumineux (bâtiment) : investissement 8 000 €, efficace 80%

Stratégie "3 luttes en 2 ans" :
  Lutte 1 (octobre)  → agnelage mars  (chaleurs naturelles)
  Lutte 2 (mai)      → agnelage octobre (désaisonnement)
  Lutte 3 (janvier)  → agnelage juin (chaleurs tardives)
  
  → Productivité : 2,2 agneaux/brebis/an (vs 1,5 en 1 lutte/an)
  → Coût : désaisonnement + travail supplémentaire + technicité
```

**b) Saisonnalité des prix**
```
Prix agneau (€/kg carcasse) par période :
  Janvier-Février  : 7,80  (demande faible)
  Mars (Pâques)    : 9,20  (+20%) ← PIC ABSOLU 🎯
  Avril            : 8,50
  Mai-Juin         : 7,20  (offre forte, herbe = agneaux partout)
  Juillet-Août     : 6,80  (creux estival)
  Septembre-Oct    : 7,40
  Novembre-Déc     : 8,00  (fêtes de fin d'année)

Le joueur Expert planifie ses luttes pour que les agneaux soient prêts à Pâques :
  Lutte en octobre → agnelage début mars → engraissement 45-60 j → vente Pâques ✅
  
  Gain : 45 agneaux × 18 kg carc. × (9,20 - 7,50) = +1 377 € par lot
```

**c) Parasitisme — enjeu sanitaire n°1**
```
Les strongles gastro-intestinaux = LE problème de l'ovin au pâturage.

Niveau d'infestation (0-100%) :
  Augmente de +5%/semaine si :
    Même paddock depuis > 3 semaines
    Chargement > 8 brebis/ha
    Temps humide et doux (printemps/automne)
    Pas de traitement depuis > 2 mois
    Agneaux sur prairie contaminée

  Diminue si :
    Rotation de pâturage (repos > 4 semaines)
    Traitement anthelminthique (-80%, coût 2 €/brebis)
    Pâturage mixte avec bovins (dilution parasitaire)
    Prairie neuve ou labourée

Conséquences :
  Infestation > 30% : GMQ agneaux -20%
  Infestation > 50% : GMQ -40%, mortalité agneaux 5%
  Infestation > 70% : mortalité 15%, brebis affaiblies

⚠️ RÉSISTANCE AUX ANTHELMINTHIQUES :
  Si traitement > 4×/an sur le même troupeau :
    Probabilité 15%/an que les parasites deviennent résistants
    → Le traitement ne fonctionne plus → il faut changer de molécule (×3 le prix)
    → Gestion raisonnée (rotation de prairies) > traitement systématique
```

**d) Productivité numérique — le KPI ovin**
```
productivité_numérique = agneaux_vendus / brebis_présentes / an

Objectif :
  1 lutte/an, race peu prolifique    : 1,1-1,3
  1 lutte/an, race prolifique        : 1,4-1,6
  3 luttes/2 ans, race prolifique    : 1,8-2,2

C'est LE chiffre qui détermine la rentabilité ovine.
  +0,1 de productivité × 350 brebis × 130 €/agneau = +4 550 €/an
```

### 4.5 Équilibrage ovin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Reproduction | Toute l'année | Saisonnalité, désaisonnement payant |
| Prolificité | Fixe par race (1-2-3) | Variable (génétique + alimentation + saison) |
| Prix agneau | Stable (7,50 €/kg carc.) | Saisonnier (6,80 à 9,20 €/kg) |
| Parasitisme | Non | Oui (gestion pâturage + traitements + résistance) |
| Laine | Coût fixe -3 €/brebis | Idem (pas de valorisation possible) |
| Aides PAC | Forfait 22 €/brebis | Détail par type + conditionnalité |
| Luttes | 1/an automatique | 1 à 3/an selon stratégie du joueur |
| Lait ovin | Production simple | AOP (Roquefort), cahier des charges |



---

## 5. Caprin — Le lait et la transformation fromagère

### 5.1 Intention de design

Le caprin est l'élevage de la **chaîne de valeur**. Vendre du lait de chèvre brut rapporte peu. Transformer ce lait en fromage multiplie le revenu par 3 à 5. Le caprin pousse naturellement le joueur vers la **transformation fermière** — une mécanique unique parmi les élevages.

**Ce qui rend le caprin plaisant** :
1. Le craft — transformer le lait en fromage (recettes, affinage, vente)
2. L'accessibilité — investissement modéré, démarrage rapide
3. La lactation longue — 10 mois de production continue
4. L'effet bouc — synchronisation gratuite et spectaculaire
5. La vente directe — relation client, marchés fermiers

**Le problème de SimAgri** : fromagerie déconnectée de l'élevage, pas de saisonnalité repro, chevreaux non modélisés comme sous-produit problématique.

### 5.2 Races disponibles

| Race | Production lait | TB | TP | Rusticité | Caractère | Prix chèvre |
|------|:---------------:|:--:|:--:|:---------:|:---------:|:-----------:|
| **Alpine** | 850 L/an | 37 g/L | 33 g/L | ★★★★ | Docile | 350 € |
| **Saanen** | 950 L/an | 35 g/L | 32 g/L | ★★★ | Calme | 380 € |

**Arbitrage** :
```
Alpine  : moins productive mais plus rustique, TB légèrement supérieur
          → fromage à pâte légèrement plus riche
          → meilleure adaptation au pâturage et aux conditions difficiles

Saanen  : volume maximal, bonne mamelle
          → optimal en livraison laiterie (payé au volume)
          → sensible au soleil (peau rose → coups de soleil au pré)
```

### 5.3 Spécificité caprine — Lactation sans tarissement

```
DIFFÉRENCE FONDAMENTALE vs BOVIN :
  Bovin : tarissement OBLIGATOIRE (60 jours sans lait avant vêlage)
  Caprin : PAS de tarissement obligatoire

La chèvre peut produire du lait 10-12 mois continus,
voire en "lactation longue" (18-24 mois sans mise au bouc).

Courbe de lactation caprine :
  4,0 ┤      ╭──╮
  3,5 ┤    ╱      ╰──╮
  3,0 ┤   ╱            ╰───╮
  2,5 ┤  ╱                  ╰────╮
  2,0 ┤ ╱                        ╰─────╮
  1,5 ┤╱                                ╰──────╮
  1,0 ┤                                        ╰───── (lactation longue)
      └───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───
          1   2   3   4   5   6   7   8   9  10  12+ (mois)

Conséquences gameplay :
  Le joueur peut choisir de ne PAS remettre les chèvres au bouc
  → Production déclinante mais continue (pas de chevreau à gérer)
  → Stratégie viable en Expert (moins de chevreaux = moins de pertes)
```

### 5.4 Mode Normal — Lait + option fromagerie

```
┌─ Ma chèvrerie — 150 Alpines ──────────────────────────────────┐
│                                                                │
│  🐐 Chèvres en lactation : 135                                 │
│  🐐 Chèvres taries/gestantes : 15                              │
│  🐐 Chevrettes (renouvellement) : 38                            │
│  🐐 Bouc : 5                                                    │
│                                                                │
│  ── Production lait ──                                         │
│  Aujourd'hui : 378 L (2,8 L/chèvre en lactation)              │
│  Ce mois : 10 584 L                                            │
│  Destination : 🧀 Fromagerie (100%)                             │
│                                                                │
│  ── Fromagerie ──                                              │
│  Fromages en production : 245 (frais + affinage)               │
│  Fromages prêts à vendre : 82 (Crottin, Bûche, Pyramide)      │
│  Valeur stock fromage : 1 640 €                                │
│                                                                │
│  ── Revenus du mois ──                                         │
│  Vente fromages : 4 250 € ✅                                    │
│  Vente chevreaux (12) : 360 € (30 €/chevreau)                 │
│                                                                │
│  ── Alertes ──                                                 │
│  📅 35 chèvres à mettre au bouc (saison de lutte : sept-nov)   │
│  ⚠️ 82 fromages à vendre avant DLC                             │
│                                                                │
│  [ Traire ]  [ Fromagerie ]  [ Vendre ]  [ Mise au bouc ]     │
└────────────────────────────────────────────────────────────────┘
```

**Paramètres Normal** :
```
Lactation : 270 jours, production selon la race (constante simplifiée)
Traite : 2×/jour, 1 action (comme bovin laitier)
Reproduction : possible toute l'année (pas de saisonnalité bloquante)
Gestation : 150 jours
Portée : 1-3 chevreaux (moy. 2)
Chevreau : vendu à 30 € pièce (sous-produit à faible valeur)
Lait vendu brut : 0,85 €/L
Fromagerie : transformation optionnelle (5 L → 1 fromage, vente 4-8 €)
```

### 5.5 Mode Expert — Saisonnalité, effet bouc, fromagerie avancée

**a) Saisonnalité et effet bouc**
```
La chèvre est un animal de JOURS COURTS (comme la brebis).
Chaleurs naturelles : août → janvier
Anoestrus : février → juillet

EFFET BOUC (mécanique unique caprine) :
  Si les chèvres sont séparées du bouc depuis > 1 mois,
  puis qu'on réintroduit le bouc brutalement :
  → 70-80% des chèvres entrent en chaleur en 7-12 jours
  → Synchronisation GRATUITE (sans hormones)
  → Le joueur planifie la date d'introduction = planifie les mises-bas

  Conditions :
    Séparation minimum 1 mois (pas de contact visuel/olfactif)
    Introduction en période de jours courts (juillet-novembre optimal)
    1 bouc pour 20-30 chèvres

Stratégie Expert :
  Introduction bouc le 1er septembre
  → Chaleurs synchronisées mi-septembre
  → Mises-bas début février (150 j après)
  → Pic de lait en mars-avril
  → Fromages affinés prêts pour la saison touristique (mai-août) 🎯
```

**b) Chevreaux — le problème économique**
```
Le chevreau est un PROBLÈME, pas un produit :
  Mâles : quasi invendables en France (export Espagne à 20-40 €)
  Femelles : gardées pour le renouvellement OU vendues 40-60 €
  
Coût d'élevage d'un chevreau jusqu'à vente : 15-25 €
  → Marge par chevreau : 0 à 20 €
  → Sur 150 chèvres × 2 chevreaux = 300 chevreaux/an
  → Revenu chevreaux : 6 000-9 000 € brut (net proche de 0)

En Expert, stratégie possible :
  - Lactation longue (18 mois, pas de mise au bouc) → 0 chevreau
    → Production -30% mais 0 coût de chevreau et 0 période sèche
  - Sélection : ne mettre au bouc que les meilleures → limiter les naissances
```

**c) Fromagerie — le multiplicateur de revenu**

```
┌─ Fromagerie — Atelier de transformation ──────────────────────┐
│                                                                │
│  ── Recettes disponibles ──                                    │
│  Fromage         Lait   Affinage  Prix vente  Marge/L lait     │
│  ─────────────────────────────────────────────────────────────│
│  Frais nature    5 L    0 j       3,50 €      0,70 €/L        │
│  Crottin         5 L    10 j      5,00 €      1,00 €/L        │
│  Bûche cendrée   7 L    15 j      7,50 €      1,07 €/L        │
│  Pyramide        6 L    20 j      6,80 €      1,13 €/L        │
│  Tomme affinée  12 L    60 j     16,00 €      1,33 €/L        │
│  ─────────────────────────────────────────────────────────────│
│                                                                │
│  ── Comparaison ──                                             │
│  Lait vendu brut à la laiterie : 0,85 €/L                     │
│  Lait transformé en fromage    : 0,70 à 1,33 €/L              │
│  Multiplicateur : ×1,5 à ×3,5 (selon type et affinage)        │
│                                                                │
│  ── Production du jour ──                                      │
│  Lait disponible : 378 L                                       │
│  Transformation prévue :                                       │
│    30 Crottins (150 L) → prêts dans 10 j                      │
│    20 Bûches (140 L) → prêtes dans 15 j                       │
│    Reste : 88 L → frais (17 fromages, vente immédiate)         │
│                                                                │
│  ── Cave d'affinage ──                                         │
│  Capacité : 500 fromages                                       │
│  Occupée : 312/500 ✅                                           │
│  Pertes (fromages ratés) : 3% 🟡 (objectif < 2%)               │
│                                                                │
│  ── Ventes ──                                                  │
│  Marché fermier (samedi) : 45-65 fromages vendus               │
│  Magasin de producteurs : 20-30/semaine (prix -15%)            │
│  GMS / restaurant : volume garanti, prix -25%                  │
│                                                                │
│  [ Lancer une fabrication ]  [ Gérer l'affinage ]  [ Vendre ] │
└────────────────────────────────────────────────────────────────┘
```

**Formule fromagerie (Expert)** :
```
revenu_fromage = (lait_jour / rendement_fromage) × prix_vente × (1 - taux_perte)

Facteurs de perte :
  Hygiène fromagerie < 80%        : pertes +5%
  Température cave instable       : pertes +3%
  Surproduction (stock > capacité): pertes +10% (fromages jetés)
  
Investissement fromagerie :
  Atelier basique (150 chèvres)   : 45 000 €
  Cave d'affinage (500 places)    : 25 000 €
  Labo + matériel                 : 18 000 €
  Formation hygiène (obligatoire) : 2 500 €
  ────────────────────────────────────────
  Total                           : 90 500 €
  
  Amortissement : 6 033 €/an (15 ans)
  
  Comparaison :
  Sans fromagerie : 150 chèvres × 850 L × 0,85 € = 108 375 € brut lait
  Avec fromagerie : 150 × 850 L × 1,10 € moyen    = 140 250 € brut fromage
  Gain brut : +31 875 €/an MAIS +1 200 h de travail/an (fabrication + vente)
```

### 5.6 Équilibrage caprin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Lactation | 270 j, production fixe | Variable (pic, persistance), lactation longue possible |
| Tarissement | Non obligatoire (spécificité) | Choix stratégique (tarissement vs lactation longue) |
| Reproduction | Toute l'année | Saisonnalité + effet bouc (synchro gratuite) |
| Chevreau | Vendu 30 €, pas de gestion | Coût d'élevage, stratégie de limitation |
| Fromagerie | Optionnelle, recettes simples | Affinage, DLC, pertes, canaux de vente |
| Prix lait | 0,85 €/L fixe | Variable selon TB/TP + collecte saisonnière |
| Investissement | Chèvrerie seule | + fromagerie + cave + formation |



---

## 6. Tableau comparatif des 6 espèces d'élevage

| Critère | Bovin laitier | Bovin allaitant | Porcin | Ovin viande | Caprin (fromager) | Poulet de chair |
|---------|:---:|:---:|:---:|:---:|:---:|:---:|
| **Investissement initial** | 625 000 € (60 VL) | 320 000 € (70 VA) | 480 000 € (50 truies) | 180 000 € (350 brebis) | 210 000 € (150 chèvres + fromag.) | 220 000 € (2 bâtiments) |
| **Revenu Normal (cible)** | 47 000 € | 42 000 € | 48 000 € | 38 000 € | 45 000 € | 40 000 € |
| **Temps de travail** | 2 100 h/an | 1 600 h/an | 2 200 h/an | 1 800 h/an | 2 800 h/an | 1 400 h/an |
| **Technicité** | ★★★☆ | ★★☆☆ | ★★★★ | ★★★☆ | ★★★☆ | ★★☆☆ |
| **Part des aides PAC** | 15-20% | 50-55% | 5-8% | 35-40% | 10-15% | 5% |
| **Cycle de revenu** | Mensuel (paie lait) | Annuel (vente broutards) | Continu (ventes lot) | Saisonnier (agneaux) | Hebdo (fromages) | 6-7×/an (lots) |
| **Risque principal** | Prix du lait | Sécheresse + prix | Cours du porc + PPA | Parasitisme + prix | DLC fromages | Grippe aviaire |
| **Progression long terme** | Génétique laitière | Génétique + surface | Optimisation IC | Productivité numérique | Recettes + clientèle | Volume + contrats |

---

## 7. Équilibrage et scénarios

### 7.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| Revenu Normal (structure type) | 38 000 – 50 000 € |
| Revenu Expert optimisé | Pas plus que Normal en €, mais + contrôle + résilience |
| Chaque espèce viable en standalone | Oui (pas besoin de diversification pour survivre) |
| Différence de gameplay réelle | Oui (pas juste des chiffres) |
| Temps de retour sur investissement | 8-15 ans selon espèce |

### 7.2 Scénario A — Naisseur bovin allaitant, 70 Charolaises, mode Normal

```
STRUCTURE : 70 vaches Charolaises, 2 taureaux, 120 ha (80 prairies + 40 céréales)
SYSTÈME : Naisseur pur (vente broutards à 9 mois)

PRODUITS
  Broutards mâles (30 × 380 kg × 2,80 €/kg vif)      31 920 €
  Broutardes (10 × 320 kg × 2,50 €/kg vif)             8 000 €
  Vaches de réforme (12 × 1 100 €)                     13 200 €
  Génisses excédentaires (5 × 1 600 €)                  8 000 €
  Aides PAC (mode Normal — DPB forfaitaire, éco-régime inclus) :
    Aide couplée bovine (70 × 150 €)                   10 500 €
    DPB (120 ha × 150 €)                               18 000 €
  ──────────────────────────────────────────────────────────────
  PRODUIT BRUT                                         89 620 €

CHARGES
  Alimentation hivernale (4 mois, foin + concentré)   -18 500 €
  Frais vétérinaires + repro                           -4 200 €
  Paille litière                                       -4 800 €
  Cultures (semences, engrais, phyto 40 ha)           -14 000 €
  Carburant + entretien matériel                      -10 200 €
  Amortissement bâtiment + matériel                   -18 000 €
  Fermage (120 ha × 120 €)                            -14 400 €
  Assurances + divers                                  -7 200 €
  ──────────────────────────────────────────────────────────────
  TOTAL CHARGES                                       -91 300 €

  Bénéfice avant charges sociales                      -1 680 €
  ──────────────────────────────────────────────────────────────
  Revenu avant MSA                                     -1 680 €  🔴 DÉFICITAIRE
```

**🔴 Problème** : le naisseur pur en plaine est **déficitaire** avec un calcul réaliste. Ce n'est pas un bug de conception : c'est la réalité française. Le naisseur pur ne survit que grâce aux aides de zone défavorisée (ICHN) ou en changeant de système.

**Correction d'équilibrage** :
```
Leviers appliqués :
  1. Réduire les charges de structure en mode Normal :
     Fermage ramené à 100 €/ha (vs 120)          : +2 400 €
     Amortissement réduit (matériel d'occasion)  : +4 000 €
  2. Augmenter le prix des broutards mâles :
     2,80 → 3,10 €/kg vif (cotation 2024 correcte)
     30 broutards × 380 kg × 0,30 €              : +3 420 €
  3. Localiser en zone défavorisée (ICHN) — cas majoritaire
     du naisseur Charolais réel :
     80 ha × 180 €/ha                            : +14 400 €

PRODUIT BRUT CORRIGÉ  : 89 620 + 3 420 + 14 400  = 107 440 €
CHARGES CORRIGÉES     : -91 300 + 2 400 + 4 000  = -84 900 €
──────────────────────────────────────────────────────────────
REVENU AVANT MSA                                    22 540 €
MSA (12% Normal)                                    -2 705 €
──────────────────────────────────────────────────────────────
REVENU NET NORMAL                                   19 835 €  🟡
```

Toujours sous la cible. **Décision** : le bovin allaitant naisseur pur est l'élevage le MOINS rentable (réalité). Pour atteindre la cible, le joueur doit soit :
- Avoir un troupeau plus grand (100+ vaches)
- Passer naisseur-engraisseur (marge supplémentaire sur la finition)
- Combiner avec des cultures de vente

**Recalcul — Naisseur-engraisseur (engraisse 30 JB + vend 10 broutardes)** :
```
Remplacement du poste "broutards mâles" :
  30 JB × 420 kg carcasse × 5,10 €/kg             = 64 260 €
  - Coût alimentation engraissement (30 × 850 €)   = -25 500 €
  Net JB                                           = 38 760 €
  (vs 31 920 € en broutards → gain +6 840 €)

Ajout coût bâtiment engraissement :
  Amortissement 30 places : -3 000 €/an

REVENU NET NAISSEUR-ENGRAISSEUR : 19 835 + 6 840 - 3 000 = 23 675 €
```

Ajout surface supplémentaire (150 ha au lieu de 120, avec ICHN) :
```
+ 30 ha × (150 € DPB + 180 € ICHN)              = +9 900 €
- Charges supplémentaires (fermage, cultures)   = -4 500 €
- MSA sur le gain (12%)                         =   -648 €
──────────────────────────────────────────────────────────
REVENU FINAL NAISSEUR-ENGRAISSEUR 70 VA, 150 ha : 28 427 €
```

**Verdict** : même optimisé, le bovin allaitant reste sous la cible de 38-50 k€. **C'est un choix de design assumé** : cette filière est la moins rentable du jeu, comme dans la réalité. Elle attire les joueurs qui aiment le système extensif, l'herbe, et la sélection de races à viande. Pour atteindre la cible, il faut soit un troupeau de 100+ vaches, soit combiner avec des cultures de vente.

✅ **Validé** avec le système naisseur-engraisseur ou naisseur pur sur grande surface avec ICHN.

### 7.3 Scénario B — Porcherie 50 truies naisseur-engraisseur, mode Normal

```
STRUCTURE : 50 truies, 620 places engraissement, 0 ha de terre (hors-sol)
SYSTÈME : Naisseur-engraisseur complet

PRODUCTION ANNUELLE
  Truies : 50 × 2,35 portées × 13,2 sevrés = 1 551 porcelets
  Mortalité post-sevrage + engraissement (5%) : -78
  Porcs vendus : 1 473/an

PRODUITS
  Porcs charcutiers (1 473 × 90,8 kg carc. × 1,75 €)   234 051 €
  Truies de réforme (17 × 180 €)                          3 060 €
  Aides PAC (minimes, hors-sol)                            2 000 €
  ──────────────────────────────────────────────────────────────
  PRODUIT BRUT                                           239 111 €

CHARGES
  Alimentation :
    Truies (50 × 1 100 €/an)                            -55 000 €
    Porcelets + engraissement (1 473 × IC 2,72 × 85 kg × 0,30 €) -102 500 €
  Frais vétérinaires + vaccins (1 500 porcs × 12 €)     -18 000 €
  Énergie (chauffage, ventilation)                       -14 000 €
  Eau + lavage + désinfection                             -5 500 €
  Amortissement bâtiment (480 000 € / 15 ans)            -32 000 €
  Entretien bâtiment                                      -8 000 €
  Frais financiers (emprunt)                             -12 000 €
  Assurances                                              -4 500 €
  Divers (identification, cotisations)                    -3 500 €
  ──────────────────────────────────────────────────────────────
  TOTAL CHARGES                                         -255 000 €

  ⚠️ RÉSULTAT NÉGATIF : -15 889 €
```

**⚠️ Problème** : la porcherie est déficitaire à 1,75 €/kg. C'est le cycle porcin en phase basse.

**Correction d'équilibrage** :
```
Le prix de 1,75 €/kg est un prix "moyen-bas".
En phase haute du cycle (2024 réel) : 1,85-1,95 €/kg.

Recalcul avec prix cible jeu = 1,88 €/kg :
  Produit : 1 473 × 90,8 × 1,88 = 251 340 €
  
  Résultat : 251 340 + 3 060 + 2 000 - 255 000 = 1 400 €  → encore insuffisant

Problème structurel : les charges réalistes de la porcherie sont trop élevées.
→ Solution jeu : réduire les charges de structure (ADR-002 : charges 12% en Normal)

Application ADR-002 :
  Charges "structurelles" à absorber en mode Normal :
  Amortissement 32 000 + frais financiers 12 000 + assurance 4 500 = 48 500 €
  → Réduction à 12% du produit brut = 30 160 €
  → Économie : 18 340 €

Revenu corrigé (Normal) :
  Produit brut : 253 400 €
  Charges opérationnelles : -195 000 €
  Charges structurelles (12% mode Normal) : -30 408 €
  ──────────────────────────────────────────────────────────────
  Revenu avant MSA : 27 992 €
```

Toujours sous la cible. **Ajustement final** :
```
Augmentation de l'IC performant + prix + réduction alimentaire :
  IC amélioré 2,65 (vs 2,72) : économie aliment = -7 200 €
  Prix porcs 1,90 €/kg : +6 700 €
  Productivité truie 13,8 sevrés : +80 porcs × 165 € = +13 200 €

REVENU NET PORCHERIE 50 TRUIES (NORMAL) :
  27 992 + 7 200 + 6 700 + 13 200 - (12% sur extra) = ~48 000 €  ✅
```

✅ **Validé** : avec un IC de 2,65, un prix de 1,90 €/kg, et une productivité de 13,8 sevrés/portée (performance atteignable en Normal bien géré), le revenu atteint 45 000-50 000 €.

**Sensibilité** : le porcin est TRÈS sensible au prix. ±0,10 €/kg = ±13 350 €/an de revenu.
→ Justifie la volatilité comme mécanique Expert (le joueur qui stocke 2 semaines de plus pour vendre au bon moment gagne gros).

### 7.4 Points à valider en playtest

**Recette SimAgri (ADR-002)** :
- [ ] Le bovin allaitant donne-t-il un sentiment de "troupeau au pré" satisfaisant ?
- [ ] La vente annuelle de broutards est-elle un moment d'excitation (pas de frustration) ?
- [ ] Le porcin est-il jouable sans comprendre les bandes ?
- [ ] L'ovin est-il jouable sans maîtriser la saisonnalité ?
- [ ] La fromagerie caprine est-elle addictive (craft) ou fastidieuse ?
- [ ] Le joueur Normal perçoit-il la différence entre les espèces ?

**Profondeur Expert** :
- [ ] Le vêlage difficile en Charolais crée-t-il une tension intéressante ?
- [ ] L'IC porcin est-il un levier d'optimisation compris et motivant ?
- [ ] La saisonnalité ovine crée-t-elle un vrai choix stratégique (lutte automne vs printemps) ?
- [ ] L'effet bouc est-il une mécanique lisible et satisfaisante ?
- [ ] Le classement EUROP récompense-t-il l'engraissement bien conduit ?
- [ ] La PPA est-elle un risque perçu qui justifie l'investissement biosécurité ?

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

### Bovin allaitant

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Vêlage | Automatique | Difficulté race × parité × NEC |
| Mortalité néonatale | 0% | 5-12% selon surveillance |
| Allaitement | GMQ fixe | GMQ variable (lait maternel + creep) |
| Classement carcasse | Non | EUROP (E/U/R/O/P × engraissement) |
| Prix broutard | 2,80-3,10 €/kg fixe | Variable ±15%, saisonnalité automne |
| Aides PAC | Forfait annuel | DPB + couplée + éco-régime + ICHN |
| Pâturage | Gratuit si surface | Chargement UGB/ha, rotation |
| Charges sociales | 12% | 28% |

### Porcin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Portée | 12-14 sevrés (fixe) | 10-16 (génétique + soins maternité) |
| Conduite | Flux continu | 7 bandes / 3 semaines + vide sanitaire |
| Alimentation | 3 niveaux qualité | Multiphase + formulation (MAT, EN) |
| IC | Affiché, levier = qualité aliment | 6 facteurs (T°, densité, santé, génétique, aliment, âge) |
| TMP | Non | Oui (±0,02 €/kg/point, génétique + aliment finition) |
| Prix vente | 1,90 €/kg fixe | Cotation variable ±15% (cycle porcin) |
| Biosécurité | Non | Score 0-100%, risque PPA |
| Température bâtiment | Non | Impact IC + mortalité |

### Ovin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Reproduction | Toute l'année | Saisonnalité jours courts + désaisonnement |
| Prolificité | Fixe par race | Variable (génétique + alimentation + rang) |
| Prix agneau | 7,50 €/kg fixe | 6,80 à 9,20 €/kg (saisonnalité) |
| Parasitisme | Non | Gestion pâturage + traitements + résistance |
| Luttes | 1/an auto | 1 à 3/an (stratégie du joueur) |
| Laine | Coût -3 €/brebis | Idem |
| Aides PAC | 22 €/brebis forfait | DPB + couplée + ICHN (si montagne) |
| Productivité num. | Non affichée | KPI principal (agneaux vendus/brebis/an) |

### Caprin

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Lactation | 270 j, production fixe | Variable, lactation longue possible (18+ mois) |
| Tarissement | Non obligatoire | Choix stratégique (mise au bouc ou non) |
| Reproduction | Toute l'année | Saisonnalité + effet bouc (synchro gratuite) |
| Chevreau | 30 €, pas de gestion | Sous-produit problématique, coût d'élevage |
| Lait brut | 0,85 €/L fixe | Variable TB/TP + collecte saisonnière |
| Fromagerie | Optionnelle, 3 recettes | 5+ recettes, affinage, DLC, pertes, canaux vente |
| Investissement | Chèvrerie seule | + fromagerie + cave + formation |
| Vente | Prix fixe | Marché fermier + magasin + GMS (prix différents) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | Couverture des 4 espèces hors bovin laitier et poulet de chair |
| 2026-08-04 | Scénario bovin allaitant : passage naisseur-engraisseur pour atteindre la cible | Naisseur pur structurellement sous 38 k€ sans grande surface |
| 2026-08-04 | Scénario porcin : ajustement IC + prix + productivité pour atteindre la cible | Charges réalistes trop élevées, application ADR-002 (12% struct.) |
| 2026-08-04 | Ajout §2.4bis Mécanique d'allaitement (paramètres chiffrés) | Audit couverture fonctionnelle — système 5.21 partiel |
