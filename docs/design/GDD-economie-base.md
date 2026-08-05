> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Modèle économique de base

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `docs/research/reality-vs-simagri-economie.md`, `docs/decisions/ADR-001-modes-de-jeu.md`

---

## 1. Vision et gameplay loop économique

### 1.1 Intention de design

L'économie d'Agriva doit répondre à une question simple : **« est-ce que je gagne de l'argent, et pourquoi ? »**

Dans SimAgri, le joueur accumule du cash sans friction (0% de charges, 0 aide). Le résultat : l'argent perd son sens, et les décisions n'ont pas de poids économique. Dans Agriva, chaque décision doit avoir un coût lisible et une conséquence mesurable.

**Trois piliers :**
1. **Les marges sont serrées** — 5-20% net. Le joueur doit optimiser pour dégager du revenu.
2. **Les charges sont visibles** — le joueur voit ce qui part et pourquoi.
3. **Les aides existent** — elles stabilisent les revenus et rendent certaines stratégies viables.

### 1.2 Gameplay loop économique

```
┌──────────────────────────────────────────────────┐
│                  CYCLE ANNUEL                     │
└──────────────────────────────────────────────────┘

AUTOMNE (Sept-Nov)
  ↓ SORTIES : semences, engrais de fond, fermage (échéance)
  ↓ Décision : quelles cultures ? combien de surface ?

HIVER (Déc-Fév)
  ↓ SORTIES : charges sociales (appel MSA), annuités
  ↓ Décision : investir ? emprunter ? vendre du stock ?
  ↓ ENTRÉES : aides PAC (versement), ventes de stock

PRINTEMPS (Mars-Mai)
  ↓ SORTIES : engrais azoté, traitements, carburant
  ↓ Décision : intensifier (plus d'intrants) ou économiser ?
  ↓ Tension : trésorerie au plus bas

ÉTÉ (Juin-Août)
  ↓ ENTRÉES : récolte → vente immédiate ou stockage
  ↓ SORTIES : carburant moisson, prestation ETA
  ↓ Décision : vendre maintenant (prix bas) ou stocker (prix haut en mars) ?
```

**Boucle courte (quotidienne)** : chaque action a un coût immédiat (carburant, temps, intrants) visible avant validation.

**Boucle moyenne (mensuelle)** : charges fixes prélevées automatiquement (salaires, électricité, annuités). Le joueur voit son solde évoluer.

**Boucle longue (annuelle)** : bilan de campagne. Le joueur voit son bénéfice, ses charges sociales, ses aides. Il décide de sa stratégie pour l'année suivante.

### 1.3 Les décisions que le joueur doit prendre

| Décision | Fréquence | Impact |
|----------|:---------:|--------|
| Acheter ou louer une terre ? | Ponctuel | Structure du bilan pour 20 ans |
| Investir dans du matériel ou faire appel à une ETA ? | Ponctuel | Charges fixes vs variables |
| Vendre à la récolte ou stocker ? | Annuel | ±10-30% sur le prix |
| Intensifier ou économiser les intrants ? | Annuel | Rendement vs charges |
| Emprunter pour investir ou autofinancer ? | Ponctuel | Trésorerie vs annuités |
| Embaucher ou automatiser ? | Ponctuel | Charges de personnel vs amortissement |
| Bio/label ou conventionnel ? | Structurel | Rendement -20% vs prix +30% |

### 1.4 Différence Normal / Expert

> Référence : ADR-001 (modes de jeu) et **ADR-002 (le mode Normal préserve la recette SimAgri)**

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Philosophie** | **C'est SimAgri, en mieux.** Progression fluide, accumulation gratifiante, pas de friction | Le joueur optimise comme un vrai chef d'exploitation |
| Charges sociales | Forfait **12%** du bénéfice, prélevé annuellement | MSA **28%** du revenu + IR progressif, appel trimestriel |
| Aides PAC | Automatiques, versement annuel unique — **argent en plus, zéro contrainte** | Conditionnalité à respecter, versements échelonnés |
| Prix | Variation ±15%, saisonnalité légère (±5%) | Volatilité ±35%, saisonnalité forte (±15%), cycles |
| Trésorerie | Toujours suffisante (**pas de blocage, pas de faillite**) | BFR réel, crédit de campagne nécessaire |
| Comptabilité | Solde + bénéfice net de l'année | EBE, bilan, amortissements, ratios |
| Fermage | Coût annuel fixe, résiliable | Indexé, révision, bail 9 ans |
| Erreurs | Coûtent du temps, jamais la ferme | Peuvent mener au redressement |

**Règle absolue en Normal** : chaque nouveauté par rapport à SimAgri doit **ajouter du choix, pas de la contrainte**.

| Nouveauté | En Normal, c'est... |
|-----------|---------------------|
| Aides PAC | ✅ De l'argent en plus |
| Fermage | ✅ Une option pour démarrer moins cher |
| ETA / prestation | ✅ Une option pour éviter d'acheter du matériel |
| Charges sociales 12% | ⚠️ Une ligne visible mais indolore |
| Saisonnalité prix | ✅ Une opportunité (stocker), pas une obligation |
| Tableau de bord | ✅ De l'information pour mieux décider |


---

## 2. Charges sociales et fiscales

### 2.1 Mode Normal — Forfait léger

> ⚠️ **Contrainte de design (ADR-002)** : le mode Normal préserve la recette SimAgri. Les charges doivent être **perceptibles mais non punitives**. SimAgri fonctionne avec 0% de charges depuis 2005 — on introduit la notion sans casser la progression.

**Principe** : un prélèvement unique annuel de **12% du bénéfice net**.

```
Fin de campagne (31 décembre in-game) :
  bénéfice_net = total_recettes - total_dépenses
  
  si bénéfice_net > 0 :
    charges = bénéfice_net × 0,12
  sinon :
    charges = cotisation_minimum (1 000 €)
  
  prélever(charges)
  notifier("Charges sociales : -X €")
```

**Cotisation minimum** : 1 000 €/an même en cas de perte (symbolique, ne met jamais le joueur en difficulté).

**Pourquoi 12% et pas 20% ou 28% ?**
- À 0% (SimAgri), la notion de charges sociales n'existe pas → manque de réalisme
- À 12%, le joueur voit la ligne, comprend le concept, mais sa progression n'est pas freinée
- À 20%+, sur un bénéfice de 40 000 €, cela retire 8 000 € — assez pour ralentir sensiblement les investissements et casser le rythme d'accumulation qui fait le plaisir du jeu
- Le mode Expert assume les 28% (taux effectif réel après optimisation, cf. ADR-003)

**Affichage joueur** :
```
┌─ Bilan de campagne 2026 ─────────────────┐
│ Recettes                     185 400 €   │
│ Dépenses                    -142 800 €   │
│ ─────────────────────────────────────    │
│ Bénéfice avant charges        42 600 €   │
│ Charges sociales (12%)        -5 112 €   │
│ ─────────────────────────────────────    │
│ Bénéfice net                  37 488 €   │
│                                          │
│ 💰 Réinvestissable : 37 488 €            │
└──────────────────────────────────────────┘
```

**Note d'ergonomie** : afficher « Réinvestissable » plutôt que juste « Bénéfice net » renforce la sensation de progression — le joueur voit immédiatement sa capacité d'action, pas une soustraction.

### 2.2 Mode Expert — MSA + IR réalistes

**Principe** : deux prélèvements distincts, appel trimestriel pour la MSA.

**a) Cotisations MSA (28% du revenu professionnel)**

> ⚠️ **Révision ADR-003** : taux ajusté de 35% à 28%. La MSA réelle est de 35-45% du revenu professionnel, mais s'applique après de nombreuses déductions que le jeu ne modélise pas (DEP, amortissements dégressifs, déficits reportables, optimisation du statut juridique). Le taux effectif réel d'un exploitant qui optimise — ce qu'est précisément un joueur Expert — se situe autour de 28-32%.

```
Assiette = revenu_professionnel_N-1  (décalage réaliste !)

Composition (affichée au joueur) :
  Maladie (AMEXA)         5,2%
  Retraite de base       11,3%
  Retraite compl. (RCO)   3,2%
  Allocations familiales  2,7%
  CSG/CRDS                4,6%  (assiette = revenu + aides PAC)
  Formation/AT            1,0%
  ─────────────────────────────
  Total                   ~28%   (taux effectif après déductions)

Appel trimestriel : charges_annuelles / 4
Cotisation minimum : 4 000 €/an
```

**Le décalage N-1 est une mécanique de gameplay** : une excellente année entraîne de fortes cotisations l'année suivante, même si celle-ci est mauvaise. Le joueur doit anticiper (voir DEP §2.3).

**b) Impôt sur le revenu (barème progressif)**

| Tranche de bénéfice | Taux |
|--------------------|:----:|
| 0 - 11 500 € | 0% |
| 11 500 - 29 000 € | 11% |
| 29 000 - 83 000 € | 30% |
| 83 000 - 180 000 € | 41% |
| > 180 000 € | 45% |

```
IR = somme des tranches (calcul progressif classique)
Prélèvement : annuel (septembre in-game)
```

**c) Taxe foncière (si propriétaire)**

```
TFNB = surface_possédée_ha × 50 €/ha/an
Prélèvement : annuel (octobre in-game)
Note : ne s'applique PAS aux terres en fermage (c'est le bailleur qui paye)
```

**Affichage joueur (Expert)** :
```
┌─ Bilan de campagne 2026 ──────────────────────┐
│ Produit brut                       185 400 €  │
│ Charges opérationnelles            -98 200 €  │
│ Charges de structure               -44 600 €  │
│ ──────────────────────────────────────────    │
│ EBE (Excédent Brut d'Exploitation)  42 600 €  │
│ Amortissements                     -18 000 €  │
│ Frais financiers                    -6 200 €  │
│ ──────────────────────────────────────────    │
│ Revenu professionnel                18 400 €  │
│                                               │
│ ── Prélèvements ──                            │
│ MSA (28% du revenu N-1 = 22 100 €)  -6 188 €  │
│ Impôt sur le revenu                   -759 €  │
│ Taxe foncière (80 ha propriété)     -4 000 €  │
│ ──────────────────────────────────────────    │
│ Revenu disponible                    5 906 €  │
└───────────────────────────────────────────────┘
```

### 2.3 DEP — Déduction pour Épargne de Précaution (Expert uniquement)

**Principe** : le joueur peut mettre de côté une partie de son bénéfice en franchise de charges, pour l'utiliser lors d'une mauvaise année.

```
Plafond annuel     : 30% du bénéfice, max 30 000 €
Plafond cumulé     : 150 000 €
Utilisation        : libre, mais réintégrée au bénéfice l'année d'utilisation
Contrainte         : doit être utilisée dans les 10 ans
```

**Gameplay** : lisse les revenus. Un joueur avisé épargne les bonnes années pour absorber une sécheresse ou un crash de prix.

### 2.4 Paramètres d'équilibrage

| Paramètre | Normal | Expert | Note |
|-----------|:------:|:------:|------|
| Taux de charges | **12%** | **28%** | Sur bénéfice (N) ou revenu (E) — cf. ADR-003 |
| Cotisation minimum | **1 000 €** | 4 000 € | Plancher même en perte |
| Décalage assiette | Non (année N) | Oui (année N-1) | Mécanique de tension |
| IR | Non | Oui (progressif) | Pénalise les très gros revenus |
| Taxe foncière | Non | 50 €/ha | Incite au fermage |
| DEP | Non | Oui | Outil de lissage |

### 2.5 Feedback joueur

- **Avant** : lors de la clôture de campagne, un écran de bilan détaille tout
- **Pendant** : une jauge "charges estimées" se remplit au fil de l'année (prévisionnel)
- **Alerte** : si le solde prévisionnel ne couvre pas les charges à venir → avertissement 2 mois avant
- **Historique** : graphique sur 5 ans (recettes / charges / net) pour visualiser la trajectoire


---

## 3. Aides PAC

### 3.1 Intention de design

Les aides PAC remplissent trois fonctions de gameplay :
1. **Stabiliser** les revenus (elles ne dépendent pas du marché)
2. **Rendre viables** les systèmes extensifs (ovin, bovin allaitant)
3. **Orienter** les pratiques (l'éco-régime récompense la vertu environnementale)

Sans elles, un joueur en bovin allaitant fait faillite sans comprendre pourquoi ce système existe dans la réalité.

### 3.2 Mode Normal — Aides automatiques

**Principe** : versement annuel unique, aucune condition à gérer.

```
Versement : 15 février in-game

DPB (Droit à Paiement de Base)
  = surface_totale_ha × 150 €/ha

Aide couplée bovine allaitante
  = nb_vaches_allaitantes × 150 €/tête   (si ≥ 10 vaches)

Aide couplée bovine laitière
  = nb_vaches_laitières × 35 €/tête      (si ≤ 60 vaches — soutien aux petites structures)
  → au-delà de 60 vaches, l'aide est plafonnée à 60 × 35 € = 2 100 €

Aide couplée ovine
  = nb_brebis × 22 €/tête                (si ≥ 50 brebis)

Aide couplée caprine
  = nb_chèvres × 16 €/tête               (si ≥ 25 chèvres)

Aide bio (si exploitation certifiée)
  = surface_bio_ha × 150 €/ha

TOTAL = somme des aides éligibles
```

**Affichage** :
```
┌─ Aides PAC 2026 versées ─────────────────┐
│ DPB (120 ha × 150 €)          18 000 €   │
│ Aide ovine (500 brebis × 22)  11 000 €   │
│ ─────────────────────────────────────    │
│ Total versé                   29 000 €   │
└──────────────────────────────────────────┘
```

### 3.3 Mode Expert — Conditionnalité et éco-régime

**a) DPB avec conditionnalité (BCAE)**

Le joueur doit respecter des règles pour toucher l'intégralité de ses aides. Chaque manquement = pénalité.

| Condition (BCAE) | Exigence | Pénalité si non-respect |
|-----------------|----------|:----------------------:|
| Rotation | Pas plus de 2 années consécutives de la même culture | -3% des aides |
| Surfaces non-productives | 4% de la SAU en jachère/haies/bandes | -5% des aides |
| Couverture des sols | Couvert végétal en interculture (automne) | -3% des aides |
| Bandes tampons | 5 m non traités le long des cours d'eau | -3% des aides |
| Prairies permanentes | Ne pas retourner plus de 5% des prairies | -5% des aides |

```
aides_versées = aides_théoriques × (1 - somme_pénalités)
Pénalité maximale cumulée : -20%
```

**b) Éco-régime (3 voies au choix)**

Le joueur choisit une voie en début de campagne :

| Voie | Conditions | Prime |
|------|-----------|:-----:|
| **Pratiques** | Diversification rotation (≥3 cultures, aucune >60%) + couverture sols | 60 €/ha |
| **Certification** | Exploitation bio ou HVE | 82 €/ha |
| **Éléments favorables** | 7% de la SAU en infrastructures écologiques (haies, mares, bosquets) | 60-82 €/ha selon % |

**c) ICHN (zones défavorisées)**

Si la ferme est en zone montagne/piémont (défini à la création) :
```
ICHN = surface_fourragère_ha × montant_zone
  Zone piémont    : 80 €/ha
  Zone montagne   : 150 €/ha
  Haute montagne  : 220 €/ha
Plafond : 50 ha
```

**d) Versements échelonnés (Expert)**

| Aide | Date de versement |
|------|:----------------:|
| Avance DPB (70%) | 16 octobre |
| Solde DPB (30%) | 15 février |
| Aides couplées animales | 15 février |
| Éco-régime | 15 février |
| ICHN | 15 décembre |
| Aide bio | 15 mars |

**Gameplay** : l'échelonnement crée un rythme de trésorerie. L'avance d'octobre arrive juste après les achats d'automne.

**e) Contrôles aléatoires**

```
Chaque année : 5% de chance d'être contrôlé
Si contrôlé et non-conforme :
  → pénalité doublée sur l'année
  → surveillance renforcée l'année suivante (contrôle garanti)
```

### 3.4 Affichage Expert

```
┌─ Aides PAC 2026 ──────────────────────────────────┐
│                                                    │
│ ── Aides théoriques ──                            │
│ DPB (120 ha × 152 €)                  18 240 €    │
│ Paiement redistributif (52 ha × 50 €)  2 600 €    │
│ Éco-régime voie Pratiques (120 × 60)   7 200 €    │
│ Aide ovine (500 brebis × 22 €)        11 000 €    │
│ ICHN (45 ha montagne × 150 €)          6 750 €    │
│ ─────────────────────────────────────────────     │
│ Sous-total                            45 790 €    │
│                                                    │
│ ── Conditionnalité ──                             │
│ ✅ Rotation respectée                              │
│ ⚠️  Surfaces non-productives : 2,8% (min 4%)  -5%  │
│ ✅ Couverture des sols                             │
│ ✅ Bandes tampons                                  │
│ ✅ Prairies permanentes                            │
│ ─────────────────────────────────────────────     │
│ Pénalité appliquée                    -2 290 €    │
│                                                    │
│ TOTAL VERSÉ                           43 500 €    │
│                                                    │
│ 💡 Conseil : plantez 1,5 ha de haies ou mettez     │
│    1,5 ha en jachère pour éviter cette pénalité   │
└────────────────────────────────────────────────────┘
```

### 3.5 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| DPB | 150 €/ha | 152 €/ha + redistributif 50 €/ha (52 premiers) |
| Conditionnalité | Aucune | 5 BCAE, pénalités -3 à -5% |
| Éco-régime | Inclus dans DPB | Séparé, 3 voies, 60-82 €/ha |
| ICHN | Non | Oui si zone défavorisée |
| Versements | 1 fois/an | 6 échéances |
| Contrôles | Non | 5%/an |
| Part dans le revenu | ~25-40% | ~25-60% selon filière |

### 3.6 Vérification de cohérence

**Test : bovin allaitant 100 vaches, 150 ha**
```
Produit brut viande         : 200 000 €
Charges                     : -175 000 €
Résultat avant aides        :   25 000 €  ← à peine viable

Aides PAC (Normal) :
  DPB 150 ha × 150         :  22 500 €
  Aide couplée 100 × 150   :  15 000 €
  Total                    :  37 500 €

Revenu avec aides           :  62 500 €
Charges sociales (12%)      :  -7 500 €
Revenu net                  :  55 000 €  ← viable ✅

Part des aides dans le revenu : 60%  ← cohérent avec la réalité (50-70%)
```

Ce test valide que les aides rendent la filière allaitante jouable, comme dans la réalité.


---

## 4. Foncier — Achat vs Fermage

### 4.1 Intention de design

Le foncier est le choix structurant n°1 d'une exploitation. Dans SimAgri, il n'y a qu'une option : acheter. Résultat, le joueur doit immobiliser un capital énorme avant de produire.

En introduisant le fermage, on crée **le premier vrai dilemme économique du jeu** :

| | Achat | Fermage |
|---|-------|---------|
| Coût initial | 6 000-10 000 €/ha | 0 € |
| Coût annuel | Taxe foncière (50 €/ha) | Fermage (175 €/ha) |
| Patrimoine | Oui (revendable, plus-value) | Non |
| Sécurité | Totale | Bail 9 ans (Expert : renouvellement possible mais pas garanti) |
| Trésorerie | Immobilisée | Libre pour investir ailleurs |

**Le calcul du joueur** : avec 100 000 €, j'achète 12 ha ou je loue 100 ha pendant 5 ans. Que choisir ?

### 4.2 Mode Normal

**a) Achat**
```
Prix de base par zone :
  Grandes cultures (plaine riche)  : 9 000 €/ha
  Polyculture-élevage              : 6 500 €/ha
  Zone d'élevage / montagne        : 4 000 €/ha

Coût annuel : taxe foncière 50 €/ha
Revente     : possible après 2 ans, prix marché - 10%
```

**b) Fermage**
```
Loyer annuel par zone :
  Grandes cultures  : 250 €/ha/an
  Polyculture       : 175 €/ha/an
  Élevage/montagne  : 90 €/ha/an

Paiement    : annuel, 1er novembre
Résiliation : le joueur peut rendre la terre en fin de campagne (préavis 1 an)
Sécurité    : le bail est automatiquement renouvelé
```

**c) Disponibilité**
```
Le serveur propose en permanence des terres à acheter ET à louer.
Quantité limitée par zone (renouvelée chaque saison).
Pas de concurrence directe entre joueurs en Normal.
```

### 4.3 Mode Expert

**a) Prix variable selon la qualité**
```
prix_ha = prix_base_zone × facteur_qualité × facteur_accessibilité

facteur_qualité (potentiel agronomique) :
  Terre profonde limono-argileuse    ×1,3
  Terre moyenne                      ×1,0
  Terre superficielle/caillouteuse   ×0,7
  Prairie humide/inondable           ×0,5

facteur_accessibilité :
  Parcelle proche du siège (zone 1-3)   ×1,1
  Parcelle moyennement éloignée (4-7)   ×1,0
  Parcelle éloignée (zone 8-10)         ×0,85
```

**b) Fermage indexé**
```
Le loyer est révisé chaque année selon un indice basé sur les prix agricoles :

indice_année = (prix_blé_moyen_3ans / prix_blé_référence)
loyer_révisé = loyer_base × clamp(indice_année, 0,85, 1,20)

→ Si les prix agricoles montent, le fermage augmente (max +20%)
→ Si les prix chutent, le fermage baisse (max -15%)
```

**c) Bail rural 9 ans**
```
Signature : engagement de 9 ans (le joueur ne peut pas résilier avant sans pénalité)
Résiliation anticipée : pénalité = 2 années de loyer

Fin de bail (année 9) :
  → 85% de chance de renouvellement automatique
  → 15% de chance que le bailleur reprenne (vente, installation d'un héritier)
     Le joueur est prévenu 18 mois avant (temps de trouver une alternative)
```

**d) Droit de préemption du fermier**
```
Si le bailleur vend la terre que le joueur loue :
  → le joueur a la priorité d'achat au prix du marché
  → délai de décision : 2 mois in-game
  → s'il refuse, la terre est vendue et le bail continue avec le nouveau propriétaire
```

**e) Concurrence entre joueurs (Expert)**
```
Les terres mises sur le marché font l'objet d'enchères :
  → publication de l'offre (3 jours in-game)
  → les joueurs intéressés font une offre
  → le meilleur prix l'emporte
  → priorité en cas d'égalité : le joueur avec la plus petite surface (analogue SAFER)
```

### 4.4 Analyse économique (à intégrer dans l'aide en jeu)

**Comparaison sur 20 ans, 100 ha en polyculture :**

```
OPTION ACHAT
  Investissement initial     : 650 000 €
  Emprunt 20 ans à 4%        : mensualité 3 940 € → 47 280 €/an
  Taxe foncière              :  5 000 €/an
  Coût annuel total          : 52 280 €/an pendant 20 ans
  Après 20 ans               : propriétaire (patrimoine 650 000 € + plus-value)
  Coût total sur 20 ans      : 1 045 600 €

OPTION FERMAGE
  Investissement initial     : 0 €
  Fermage                    : 17 500 €/an
  Coût annuel total          : 17 500 €/an
  Après 20 ans               : rien (mais 0 € immobilisé)
  Coût total sur 20 ans      : 350 000 €
  Économie de trésorerie     : 695 600 € disponibles pour d'autres investissements

CONCLUSION GAMEPLAY :
  → Fermage = démarrage rapide, croissance par le volume
  → Achat = construction de patrimoine, sécurité long terme
  → Stratégie optimale : commencer en fermage, acheter progressivement avec les bénéfices
```

### 4.5 Affichage joueur

```
┌─ Marché foncier — Zone Beauce ────────────────────────────┐
│                                                            │
│ 📍 Parcelle "Les Grands Champs" — 24 ha                    │
│    Qualité : ★★★★☆ (limon profond)                        │
│    Distance : zone 3 (proche)                              │
│                                                            │
│    💰 ACHETER          216 000 €  (9 000 €/ha)             │
│       + taxe foncière    1 200 €/an                        │
│       Emprunt possible : 15 750 €/an sur 20 ans            │
│                                                            │
│    🔑 LOUER (fermage)    6 000 €/an  (250 €/ha)            │
│       Bail 9 ans, révision annuelle indexée                │
│                                                            │
│    [ Acheter ]  [ Louer ]  [ Comparer sur 20 ans ]         │
└────────────────────────────────────────────────────────────┘
```

### 4.6 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Prix achat | Fixe par zone (4 000-9 000 €/ha) | Variable × qualité × accessibilité |
| Fermage | Fixe par zone (90-250 €/ha) | Indexé sur prix agricoles |
| Durée d'engagement | Résiliable annuellement | Bail 9 ans |
| Renouvellement | Automatique | 85% de chance |
| Concurrence | Non | Enchères entre joueurs |
| Préemption | Non | Oui (priorité fermier) |
| Ratio fermage/achat | ~2,7% du prix d'achat | Idem (cohérent avec la réalité) |

**Vérification** : 175 € de fermage / 6 500 € d'achat = 2,7%. En réalité, le rendement locatif agricole est de 2-3%. ✅ Cohérent.


---

## 5. Prix et marché dynamique

### 5.1 Intention de design

Le prix est le levier qui transforme une bonne récolte en bon revenu — ou pas. Trois questions doivent se poser au joueur :
1. **Quand vendre ?** (maintenant au prix bas, ou stocker pour le prix haut)
2. **À qui vendre ?** (coopérative sûre, négoce plus cher, contrat garanti)
3. **Quoi produire ?** (les prix relatifs orientent les rotations)

### 5.2 Formule de prix

Le prix d'un produit à un instant donné combine 4 composantes :

```
prix_final = prix_base × f_saison × f_offre_demande × f_tendance × f_qualité
```

**a) Prix de base** (paramètre du jeu, cf. REFERENCE §5.1)
```
Blé : 220 €/t   |   Colza : 470 €/t   |   Lait : 0,43 €/L   |   etc.
```

**b) Facteur saisonnier** — courbe sinusoïdale par produit

| Produit | Creux | Pic | Amplitude Normal | Amplitude Expert |
|---------|:-----:|:---:|:----------------:|:----------------:|
| Blé, orge | Juillet-août | Mars-avril | ±5% | ±15% |
| Maïs | Novembre | Juin | ±5% | ±12% |
| Colza | Juillet | Février | ±5% | ±12% |
| Agneau | Juillet-août | Pâques (mars-avril) | ±8% | ±20% |
| Volaille | Février | Décembre | ±5% | ±15% |
| Lait | Mai-juin (pic production) | Novembre | ±3% | ±10% |

```
f_saison = 1 + amplitude × sin(2π × (jour_année - décalage_produit) / 365)
```

**c) Facteur offre/demande** — dynamique du serveur

```
offre    = stock_total_serveur(produit)
demande  = consommation_estimée(produit) + ventes_moyennes_30j

ratio    = demande / max(offre, 1)

Normal  : f_offre_demande = clamp(ratio, 0,88, 1,12)   → ±12%
Expert  : f_offre_demande = clamp(ratio, 0,75, 1,25)   → ±25%
```

**d) Facteur tendance** — cycles pluriannuels (Expert uniquement)

```
Certains produits ont des cycles longs de surproduction/pénurie :

Porc    : cycle de 3,5 ans (amplitude ±20%)
Lait    : cycle de 4 ans (amplitude ±15%)
Céréales: cycle de 3 ans (amplitude ±10%)

f_tendance = 1 + amplitude_cycle × sin(2π × année_jeu / durée_cycle)
```

**e) Facteur qualité**

| Niveau de qualité | Normal | Expert |
|------------------|:------:|:------:|
| Excellent | ×1,10 | ×1,05 à ×1,20 (selon critères précis) |
| Bon | ×1,00 | ×1,00 |
| Moyen | ×0,92 | ×0,85 à ×0,95 |
| Déclassé | ×0,80 | ×0,60 à ×0,80 (fourrager au lieu de meunier) |

En Expert, la qualité est décomposée : protéines (blé), teneur en huile (colza), taux de sucre (betterave), TB/TP (lait), TMP (porc).

### 5.3 Canaux de vente

| Canal | Prix | Délai paiement | Engagement | Mode |
|-------|:----:|:--------------:|:----------:|:----:|
| **Coopérative** | prix_marché × 0,97 | Immédiat | Non | N+E |
| **Négoce** | prix_marché × 1,00 à 1,03 | 30 jours in-game | Non | N+E |
| **Marché joueurs** | Libre (commission 5%) | Immédiat | Non | N+E |
| **Contrat anticipé** | Prix fixé à la signature | À la livraison | Oui (volume) | E |
| **Vente directe** | prix_marché × 1,5 à 2,0 | Immédiat | Non (mais coûte du temps) | E |

**Contrat anticipé (Expert)** — le cœur de la gestion du risque :
```
Signature possible : de janvier à juin (avant récolte)
Le joueur s'engage sur :
  - un volume (tonnes)
  - un prix (celui du marché à terme au moment de la signature)
  - une date de livraison (après récolte)

À la livraison :
  → Si le joueur a assez de stock : livraison, paiement au prix contractuel
  → Si le joueur n'a pas assez : pénalité = (prix_marché - prix_contrat) × manquant + 15% de frais

Gameplay : sécuriser 50-70% de sa récolte est la stratégie prudente.
Tout contractualiser = pas de gain si les prix montent.
Ne rien contractualiser = exposition totale.
```

### 5.4 Stockage et spéculation

```
Le joueur peut stocker sa récolte au lieu de la vendre :

Coût du stockage (Expert) :
  - Perte de poids : 0,5%/mois (respiration du grain)
  - Coût de ventilation : 0,50 €/t/mois
  - Immobilisation de la capacité du silo

Bénéfice potentiel :
  - Vendre en mars/avril = +10 à +15% par rapport à juillet (Expert)
  - En Normal : +5%

Décision type (Expert, blé) :
  Vendre en juillet : 190 €/t (prix bas saisonnier)
  Stocker 8 mois    : 253 €/t × (1 - 4% perte) - 4 €/t frais = 239 €/t net
  → Gain : +49 €/t = +26%  ← récompense la patience et la capacité de stockage
```

### 5.5 Affichage joueur

**Mode Normal** — simple et lisible :
```
┌─ Vendre du blé ───────────────────────────────┐
│ Stock disponible : 340 t                       │
│                                                │
│ Prix actuel : 212 €/t                          │
│ 📈 Tendance : en hausse (+3% ce mois)          │
│                                                │
│ 💡 Le prix du blé est généralement plus élevé  │
│    au printemps qu'à la moisson.               │
│                                                │
│ Quantité : [___340___] t                       │
│ Recette estimée : 72 080 €                     │
│                                                │
│ [ Vendre à la coopérative ]                    │
└────────────────────────────────────────────────┘
```

**Mode Expert** — données complètes :
```
┌─ Marché — Blé tendre ─────────────────────────────────────┐
│                                                            │
│ Prix spot actuel                              198,40 €/t   │
│   ├─ Base                                     220,00 €/t   │
│   ├─ Saisonnalité (juillet, creux)              -13,5%     │
│   ├─ Offre/demande serveur (offre forte)         -4,2%     │
│   ├─ Cycle pluriannuel (année 2/3, baisse)       -2,1%     │
│   └─ Qualité (protéines 11,8% → bon)              0,0%     │
│                                                            │
│ 📊 Historique 12 mois        ▁▂▃▅▇▆▅▃▂▁▁▂                  │
│ 📅 Prix moyen mars-avril (5 ans) : 241 €/t                  │
│                                                            │
│ ── Canaux disponibles ──                                   │
│ Coopérative          192,45 €/t   paiement immédiat        │
│ Négoce Soufflet      201,20 €/t   paiement J+30            │
│ Contrat mars 2027    228,00 €/t   engagement 200 t         │
│ Marché joueurs       195-215 €/t  (12 offres actives)      │
│                                                            │
│ ── Simulation stockage ──                                  │
│ Vendre maintenant (340 t)              : 65 433 €          │
│ Stocker jusqu'en mars (perte 4%, frais) : 78 950 €         │
│ Différentiel                            : +13 517 € (+21%) │
│                                                            │
│ [ Vendre ] [ Stocker ] [ Contractualiser ]                 │
└────────────────────────────────────────────────────────────┘
```

### 5.6 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Amplitude saisonnière | ±5-8% | ±10-20% |
| Amplitude offre/demande | ±12% | ±25% |
| Cycles pluriannuels | Non | Oui (3-4 ans) |
| Variation max cumulée | ±20% | ±50% |
| Plancher / plafond | 0,75× à 1,25× base | 0,55× à 1,60× base |
| Contrats anticipés | Non | Oui |
| Coût de stockage | Aucun | Perte 0,5%/mois + 0,50 €/t/mois |
| Gain du stockage | +5% | +15-25% |

**Garde-fou** : un plancher absolu empêche les prix de s'effondrer totalement (le joueur ne peut jamais se retrouver avec une production invendable à 0 €).


---

## 6. Comptabilité et tableau de bord

### 6.1 Intention de design

Le joueur doit pouvoir répondre à trois questions à tout moment :
1. **Où j'en suis ?** (solde, trésorerie prévisionnelle)
2. **Qu'est-ce qui me coûte / me rapporte ?** (analyse par poste, par culture, par atelier)
3. **Est-ce que je progresse ?** (comparaison inter-annuelle)

En Normal, on répond aux questions 1 et 2 simplement. En Expert, on ajoute les outils d'analyse de gestion réels.

### 6.2 Mode Normal — Tableau de bord simple

**Écran d'accueil (dashboard)** :
```
┌─ Ma ferme — Août 2026 ────────────────────────────────┐
│                                                        │
│  💰 Solde              84 320 €                        │
│  📊 Bénéfice 2026      +28 400 €  (en cours)           │
│  ⏱️  Temps restant     4,5h / 8,0h                     │
│                                                        │
│  ── Ce mois ──                                         │
│  Recettes             +42 800 €                        │
│  Dépenses             -18 200 €                        │
│  ─────────────────────────────                         │
│  Résultat du mois     +24 600 €                        │
│                                                        │
│  ── Prochaines échéances ──                            │
│  ⚠️  1er nov  : Fermage           -17 500 €            │
│      15 déc   : Charges sociales   -5 680 €            │
│      15 fév   : Aides PAC         +29 000 €            │
│                                                        │
│  [ Historique ]  [ Analyse par culture ]               │
└────────────────────────────────────────────────────────┘
```

**Analyse par culture (Normal)** :
```
┌─ Résultat par culture — 2026 ─────────────────────────────┐
│ Culture      Surface  Rendement  Recette   Charges  Marge │
│ ────────────────────────────────────────────────────────  │
│ Blé tendre     45 ha     78 q     74 100    31 500  42 600│
│ Colza          30 ha     36 q     50 760    22 800  27 960│
│ Orge           25 ha     72 q     35 100    16 250  18 850│
│ Prairie        20 ha       —           0     3 200  -3 200│
│ ────────────────────────────────────────────────────────  │
│ TOTAL         120 ha            159 960    73 750  86 210 │
│                                                            │
│ 💡 Meilleure marge/ha : Blé (947 €/ha)                    │
└────────────────────────────────────────────────────────────┘
```

### 6.3 Mode Expert — Comptabilité de gestion

**a) Compte de résultat**
```
┌─ Compte de résultat — Campagne 2026 ──────────────────────┐
│                                                            │
│ PRODUITS                                                   │
│   Ventes végétales                          159 960 €      │
│   Ventes animales                            48 200 €      │
│   Aides PAC                                  43 500 €      │
│   Autres produits (prestation ETA)            8 400 €      │
│   Variation de stock                        + 12 300 €     │
│   ──────────────────────────────────────────────────       │
│   PRODUIT BRUT                              272 360 €      │
│                                                            │
│ CHARGES OPÉRATIONNELLES                                    │
│   Semences                                  -14 200 €      │
│   Engrais                                   -28 600 €      │
│   Produits phytosanitaires                  -19 400 €      │
│   Aliments du bétail                        -32 800 €      │
│   Frais vétérinaires                         -5 200 €      │
│   Carburant                                 -18 900 €      │
│   Prestations (ETA)                         -12 000 €      │
│   ──────────────────────────────────────────────────       │
│   MARGE BRUTE GLOBALE                       141 260 €      │
│                                                            │
│ CHARGES DE STRUCTURE                                       │
│   Fermage                                   -17 500 €      │
│   Salaires + charges                        -28 600 €      │
│   Entretien matériel et bâtiments           -14 300 €      │
│   Assurances                                 -8 200 €      │
│   Électricité, eau                          -11 400 €      │
│   Taxe foncière                              -2 500 €      │
│   Divers (comptable, cotisations)            -4 800 €      │
│   ──────────────────────────────────────────────────       │
│   EBE (Excédent Brut d'Exploitation)         53 960 €      │
│                                                            │
│   Amortissements                            -22 400 €      │
│   Frais financiers (intérêts emprunts)       -8 900 €      │
│   ──────────────────────────────────────────────────       │
│   RÉSULTAT COURANT                           22 660 €      │
│                                                            │
│   MSA (sur revenu N-1)                       -9 240 €      │
│   Impôt sur le revenu                        -1 280 €      │
│   ──────────────────────────────────────────────────       │
│   REVENU DISPONIBLE                          12 140 €      │
└────────────────────────────────────────────────────────────┘
```

**b) Bilan patrimonial**
```
┌─ Bilan au 31/12/2026 ─────────────────────────────────────┐
│                                                            │
│ ACTIF                          │  PASSIF                   │
│ ─────────────────────────────  │  ──────────────────────   │
│ Foncier (80 ha)      520 000 € │  Capitaux propres 612k €  │
│ Bâtiments            180 000 € │                            │
│ Matériel             240 000 € │  Emprunts LT     380 000 €│
│ Cheptel               95 000 € │  Emprunts CT      25 000 €│
│ Stocks                48 000 € │                            │
│ Trésorerie            84 320 € │                            │
│ ─────────────────────────────  │  ──────────────────────   │
│ TOTAL ACTIF        1 167 320 € │  TOTAL PASSIF  1 167 320 €│
│                                                            │
│ ── Indicateurs de gestion ──                               │
│ Taux d'endettement                              34,7% ✅   │
│ Annuités / EBE                                  48,2% ✅   │
│ EBE / Produit brut                              19,8% ⚠️   │
│ Revenu / UTANS                                12 140 € ⚠️  │
│                                                            │
│ ✅ Bon   ⚠️ À surveiller   ❌ Critique                     │
└────────────────────────────────────────────────────────────┘
```

**c) Seuils d'alerte (Expert)**

| Indicateur | Bon | À surveiller | Critique |
|-----------|:---:|:------------:|:--------:|
| Taux d'endettement | <50% | 50-70% | >70% |
| Annuités / EBE | <50% | 50-70% | >70% |
| EBE / Produit brut | >25% | 15-25% | <15% |
| Revenu / UTANS | >25 000 € | 15-25 000 € | <15 000 € |
| Trésorerie prévisionnelle | Positive 6 mois | Positive 3 mois | Négative <3 mois |

**d) Trésorerie prévisionnelle (Expert)**
```
┌─ Prévisionnel de trésorerie ──────────────────────────────┐
│                                                            │
│  Solde                                                     │
│  120k ┤                                    ╭──────         │
│   90k ┤ ●──────╮                          ╱                │
│   60k ┤        ╰──╮                  ╭───╱                 │
│   30k ┤           ╰────╮        ╭───╱                      │
│    0k ┼────────────────╰────────╯                          │
│  -30k ┤                  ⚠️ zone critique (avril-mai)      │
│       └──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬               │
│         S  O  N  D  J  F  M  A  M  J  J  A                 │
│                                                            │
│  ⚠️ Alerte : trésorerie négative prévue en avril-mai       │
│     Solutions : crédit de campagne (25k à 4,5%) ou         │
│                 vendre 80 t de blé stocké maintenant        │
└────────────────────────────────────────────────────────────┘
```

### 6.4 Analyse par atelier (Expert)

Le joueur peut voir la rentabilité de chaque atelier séparément :

```
┌─ Rentabilité par atelier — 2026 ──────────────────────────┐
│                                                            │
│ ATELIER CULTURES (120 ha)                                  │
│   Produit brut (dont aides)         203 460 €              │
│   Charges affectées                -118 200 €              │
│   Marge par ha                         710 €/ha            │
│                                                            │
│ ATELIER BOVIN LAIT (45 VL)                                 │
│   Produit brut (dont aides)          68 900 €              │
│   Charges affectées                 -52 400 €              │
│   Marge par vache                       367 €/VL           │
│                                                            │
│ ATELIER PRESTATION ETA                                     │
│   Produit brut                        8 400 €              │
│   Charges affectées                  -3 100 €              │
│   Marge horaire                          42 €/h            │
│                                                            │
│ 💡 L'atelier lait dégage 367 €/VL. La référence            │
│    régionale est de 450 €/VL. Piste : coût alimentaire     │
│    élevé (285 €/1000L vs 220 € en référence).             │
└────────────────────────────────────────────────────────────┘
```

### 6.5 Équilibrage

| Élément | Normal | Expert |
|---------|:------:|:------:|
| Solde + historique | ✅ | ✅ |
| Bénéfice annuel | ✅ | ✅ |
| Marge par culture | ✅ | ✅ |
| Échéances à venir | ✅ | ✅ |
| Compte de résultat détaillé | ❌ | ✅ |
| Bilan patrimonial | ❌ | ✅ |
| Amortissements | ❌ | ✅ |
| Ratios de gestion + alertes | ❌ | ✅ |
| Trésorerie prévisionnelle | ❌ | ✅ |
| Analyse par atelier | ❌ | ✅ |
| Comparaison à une référence | ❌ | ✅ |


---

## 7. Équilibrage et scénarios de test

### 7.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| Un joueur débutant en Normal est viable sans optimiser | Revenu net positif dès l'année 1 |
| Un joueur Expert bien géré gagne mieux qu'un joueur Normal | +20 à +40% de revenu |
| Un joueur Expert mal géré peut perdre de l'argent | Revenu négatif possible |
| Aucune stratégie ne domine | Écart max 25% entre les meilleures stratégies |
| Le fermage et l'achat sont tous deux viables | Différence <15% sur 10 ans |
| Les aides représentent une part réaliste du revenu | 20-60% selon filière |

### 7.2 Scénario A — Débutant, grandes cultures, mode Normal

**Configuration de départ** :
```
Solde initial      : 150 000 €
Surface            : 60 ha en fermage (175 €/ha)
Matériel           : tracteur 120 CV d'occasion (45 000 €) + outils de base (25 000 €)
Prestations        : moisson par ETA (120 €/ha)
Rotation           : blé / colza / orge
```

**Simulation année 1** :
```
PRODUITS
  Blé 20 ha × 72 q × 210 €/t         30 240 €
  Colza 20 ha × 33 q × 460 €/t       30 360 €
  Orge 20 ha × 68 q × 195 €/t        26 520 €
  Aides PAC (60 ha × 150 €)           9 000 €
  ─────────────────────────────────────────
  PRODUIT BRUT                       96 120 €

CHARGES
  Semences (60 ha × 75 €)            -4 500 €
  Engrais (60 ha × 200 €)           -12 000 €
  Phytos (60 ha × 160 €)             -9 600 €
  Carburant                          -6 400 €
  Prestation ETA moisson             -7 200 €
  Fermage (60 ha × 175 €)           -10 500 €
  Entretien matériel                 -3 500 €
  Assurance + divers                 -4 200 €
  ─────────────────────────────────────────
  TOTAL CHARGES                     -57 900 €

RÉSULTAT
  Bénéfice avant charges sociales    38 220 €
  Charges sociales (12%)             -4 586 €
  ─────────────────────────────────────────
  BÉNÉFICE NET                       33 634 €

Trésorerie fin d'année : 150 000 + 33 634 = 183 634 €
```
✅ **Validé** : le débutant dégage un revenu confortable (33 634 €) et peut réinvestir immédiatement — il achète par exemple un semoir neuf ou 20 ha de fermage supplémentaires dès l'année 2.

**Test recette SimAgri (ADR-002)** :
- Progression visible ? ✅ +22% de trésorerie en 1 an
- Pas de mur ? ✅ aucun blocage
- Réinvestissement possible ? ✅ 33 k€ disponibles
- Complexité ? ✅ 3 cultures, 1 rotation, aides automatiques

### 7.3 Scénario B — Même exploitation, mode Expert bien géré

**Optimisations appliquées par le joueur** :
```
- Contractualisation de 60% de la récolte à un bon prix
- Stockage de 40% pour vendre au printemps
- Éco-régime voie Pratiques respecté (+60 €/ha)
- Rotation optimisée (effet précédent : +6% rendement blé après colza)
- Fertilisation raisonnée (analyse de sol, -10% d'engrais sans perte de rendement)
```

**Simulation année 1 (Expert)** :
```
PRODUITS
  Blé 20 ha × 76 q (effet précédent) × 218 €/t   33 136 €
  Colza 20 ha × 33 q × 465 €/t                   30 690 €
  Orge 20 ha × 68 q × 201 €/t (stockage)         27 336 €
  Aides PAC (DPB 152 + éco-régime 60) × 60 ha    12 720 €
  Paiement redistributif (52 ha × 50 €)           2 600 €
  ─────────────────────────────────────────────────────
  PRODUIT BRUT                                  106 482 €

CHARGES
  Semences                                       -4 500 €
  Engrais (optimisé -10%)                       -10 800 €
  Phytos                                         -9 600 €
  Carburant                                      -6 400 €
  Prestation ETA                                 -7 200 €
  Fermage                                       -10 500 €
  Entretien matériel                             -3 500 €
  Assurance + divers                             -4 200 €
  Frais de stockage (ventilation, pertes)          -900 €
  ─────────────────────────────────────────────────────
  TOTAL CHARGES                                 -57 600 €

RÉSULTAT
  EBE                                            48 882 €
  Amortissement matériel                         -7 000 €
  ─────────────────────────────────────────────────────
  Revenu professionnel                           41 882 €
  MSA (28%, année 1 = assiette forfaitaire)      -9 600 €
  IR                                             -3 400 €
  ─────────────────────────────────────────────────────
  REVENU DISPONIBLE                              28 882 €
```

⚠️ **Analyse** : le joueur Expert dégage un produit brut supérieur (+10 362 €) grâce à ses optimisations, mais paie plus de charges (28% + IR vs 12% forfaitaire). Résultat net inférieur en année 1 (28 882 € vs 33 634 €).

> 📌 **Voir ADR-003 (contrainte levée par ADR-005)** : ce constat s'est répété dans les 4 premiers GDD. La décision historique était d'assumer que le mode Expert n'est pas conçu pour être plus rentable — il apporte de la profondeur, du contrôle et de la compréhension. Depuis l'ADR-005 (serveurs séparés), cette comparaison est informative : chaque serveur doit être internement équilibré et plaisant, sans obligation d'équivalence de rentabilité entre serveurs. Son avantage se manifeste sur les grandes structures, la valorisation du temps libéré, le long terme, et la gestion de crise.

**Leviers de gain Expert à calibrer** :

| Levier | Gain potentiel | Condition |
|--------|:-------------:|-----------|
| Contrats bien timés | +8 à +15% sur le prix | Signer au bon moment (mars-avril) |
| Stockage optimal | +15 à +25% sur le prix | Capacité de stockage + patience |
| Effet précédent optimisé | +6 à +10% de rendement | Rotation intelligente |
| Fertilisation raisonnée | -15% de charges engrais | Analyse de sol + fractionnement |
| Éco-régime voie certification | +82 €/ha (vs 60) | Bio ou HVE |
| Vente directe (partielle) | +50 à +100% sur le prix | Investissement en temps de travail |
| Qualité premium (protéines) | +10 à +20% sur le prix | Pilotage azote fin |
| Prestation ETA à d'autres joueurs | Revenu additionnel | Matériel disponible + temps |

**Simulation Expert avec optimisation poussée (année 3, joueur expérimenté)** :
```
Produit brut avec tous les leviers            138 000 €  (+30% vs Normal)
Charges (optimisées -12%)                     -50 700 €
─────────────────────────────────────────────────────
EBE                                            87 300 €
Amortissement                                  -7 000 €
─────────────────────────────────────────────────────
Revenu professionnel                           80 300 €
MSA (28%)                                     -22 484 €
IR                                            -12 400 €
─────────────────────────────────────────────────────
REVENU DISPONIBLE                              45 416 €   ← +35% vs Normal ✅
```

✅ **Équilibrage validé sur les grandes performances** : un joueur Expert qui maîtrise tous les leviers dépasse le mode Normal de 35%. Mais cela demande une maîtrise réelle — un joueur Expert débutant ou négligent gagnera moins qu'en Normal.

**C'est la philosophie du serveur Expert** (historiquement ADR-003, désormais encadrée par ADR-005 — serveurs séparés) : le potentiel est supérieur, mais il faut le mériter. Chaque serveur étant indépendant, cette comparaison est informative et non contraignante.

### 7.4 Scénario C — Élevage ovin, test de viabilité des aides

```
Configuration : 500 brebis, 100 ha (80 ha prairie + 20 ha céréales autoconsommées)
Mode : Normal

PRODUITS
  Agneaux (650 × 18 kg carc. × 7,50 €)         87 750 €
  Réformes (100 brebis × 55 €)                  5 500 €
  Laine (500 × 2,5 kg × 1,00 €)                 1 250 €
  Aides PAC :
    DPB (100 ha × 150 €)                       15 000 €
    Aide ovine (500 × 22 €)                    11 000 €
  ─────────────────────────────────────────────────────
  PRODUIT BRUT                                120 500 €

CHARGES
  Alimentation (concentrés, minéraux)          -22 000 €
  Frais véto + repro                            -5 500 €
  Semences + engrais (20 ha)                   -5 200 €
  Carburant                                    -6 800 €
  Fermage (100 ha × 90 €)                      -9 000 €
  Entretien bâtiment + matériel                -8 400 €
  Tonte (500 × 2,50 €)                         -1 250 €
  Assurance + divers                           -5 600 €
  ─────────────────────────────────────────────────────
  TOTAL CHARGES                               -63 750 €

RÉSULTAT
  Bénéfice avant charges                       56 750 €
  Charges sociales (12%)                       -6 810 €
  ─────────────────────────────────────────────────────
  BÉNÉFICE NET                                 49 940 €

Part des aides dans le résultat : 26 000 / 56 750 = 46%
```
✅ **Validé** : l'ovin est viable avec les aides (46% du résultat), cohérent avec la réalité (40-60%).

**Test sans aides** : 56 750 - 26 000 = 30 750 € → toujours positif mais faible. C'est acceptable : sans aides l'ovin serait peu attractif mais pas ruineux (en réalité il serait déficitaire, on adoucit un peu pour le gameplay).

### 7.5 Scénario D — Test de faillite (Expert)

```
Configuration : joueur endetté, mauvaise année
  - 150 ha achetés à crédit (annuités 65 000 €/an)
  - Sécheresse : rendements -35%
  - Prix bas (cycle baissier) : -15%

PRODUITS
  Cultures (rendement -35%, prix -15%)         88 000 €
  Aides PAC                                    24 000 €
  ─────────────────────────────────────────────────────
  PRODUIT BRUT                                112 000 €

CHARGES
  Charges opérationnelles                     -68 000 €
  Charges de structure                        -42 000 €
  ─────────────────────────────────────────────────────
  EBE                                           2 000 €
  Annuités                                    -65 000 €
  ─────────────────────────────────────────────────────
  RÉSULTAT                                    -63 000 €
  MSA (sur revenu N-1 = bon)                  -14 000 €
  ─────────────────────────────────────────────────────
  DÉFICIT                                     -77 000 €
```

**Mécaniques de sauvetage disponibles** :
1. **DEP** : si le joueur avait épargné (jusqu'à 150 k€), il peut absorber
2. **Assurance récolte** : indemnisation de 60-70% de la perte si souscrite
3. **Crédit de campagne** : emprunt court terme pour passer l'année
4. **Vente d'actifs** : vendre du matériel ou une parcelle
5. **Restructuration** : rééchelonnement de la dette (allonge la durée, baisse l'annuité)

**Si rien n'est fait** : après 2 années consécutives de trésorerie négative → procédure de redressement (le joueur doit vendre des actifs de force, mais ne perd pas la partie).

✅ **Validé** : le risque existe en Expert, mais des outils de gestion permettent de s'en sortir. Pas de game over brutal.

### 7.6 Matrice d'équilibrage final

| Filière | Revenu Normal | Revenu Expert (bien géré) | Écart | Part des aides |
|---------|:-------------:|:-------------------------:|:-----:|:--------------:|
| Grandes cultures 120 ha | 46 000 € | 56 000 € | +22% | 25% |
| Bovin lait 60 VL | 42 000 € | 52 000 € | +24% | 22% |
| Bovin allaitant 100 VA | 38 000 € | 45 000 € | +18% | 55% |
| Ovin 500 brebis | 50 000 € | 58 000 € | +16% | 46% |
| Porc 200 truies | 44 000 € | 66 000 € | +50% | 8% |
| Poulet chair 2 bât. | 39 000 € | 50 000 € | +28% | 6% |
| Caprin fromager 200 | 45 000 € | 60 000 € | +33% | 18% |
| Mixte cultures+lait | 48 000 € | 62 000 € | +29% | 24% |

**Écart max entre filières (Normal)** : 50 000 (ovin) vs 38 000 (allaitant) = **32%**

**Analyse** :
- ✅ Toutes les filières dépassent 38 000 € en Normal → aucune n'est un piège
- ✅ Expert récompense l'optimisation partout (+16 à +50%)
- ✅ Le porc bénéficie le plus d'Expert (IC, multiphase, conduite en bandes) — cohérent : c'est la filière la plus technique
- ⚠️ L'écart de 32% entre filières est acceptable mais à surveiller. Le bovin allaitant reste le moins rentable (comme dans la réalité), mais il est jouable.

**Ajustement retenu** : aide couplée bovine allaitante portée à **150 €/tête** (au lieu de 130 €) → allaitant passe à 40 000 € en Normal, ramenant l'écart à 25%.

### 7.7 Points à valider en playtest

**Compréhension et confort**
- [ ] Le joueur Normal comprend-il d'où vient son argent sans consulter de doc ?
- [ ] Le joueur Expert trouve-t-il les outils de gestion utiles ou envahissants ?
- [ ] Le choix achat/fermage est-il réellement ouvert (pas de réponse évidente) ?
- [ ] La saisonnalité des prix incite-t-elle au stockage sans le rendre obligatoire ?
- [ ] Les charges sociales sont-elles ressenties comme justes ou punitives ?
- [ ] Le décalage MSA N-1 crée-t-il une tension intéressante ou une frustration ?
- [ ] Un joueur peut-il se sortir d'une mauvaise année sans abandonner ?

**Test recette SimAgri en mode Normal (ADR-002) — bloquant**
- [ ] Un joueur SimAgri retrouve-t-il ses sensations en mode Normal ?
- [ ] La progression est-elle constante (jamais de régression) ?
- [ ] Peut-on réinvestir significativement chaque année ?
- [ ] Le joueur peut-il jouer 10 min/jour et progresser ?
- [ ] Aucun système ne demande-t-il de lire une doc pour être utilisé ?
- [ ] L'accumulation (matériel, terres, animaux) reste-t-elle gratifiante ?
- [ ] Le joueur peut-il s'absenter 2 semaines sans conséquence grave ?
- [ ] Verdict attendu : « C'est SimAgri, mais en mieux » ✅
- [ ] Verdict à éviter : « C'est plus compliqué / plus dur » ❌

---

## Annexe — Récapitulatif des paramètres

> Mode Normal calibré selon ADR-002 (préservation de la recette SimAgri).

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Charges sociales | **12% du bénéfice** | **28% du revenu** (assiette N-1) |
| Cotisation minimum | **1 000 €** | 4 000 € |
| Impôt sur le revenu | Non | Barème progressif 0-45% |
| Taxe foncière | Non | 50 €/ha (propriété) |
| DEP | Non | 30% du bénéfice, max 150 k€ |
| DPB | 150 €/ha | 152 €/ha + redistributif |
| Éco-régime | Inclus | 60-82 €/ha (3 voies) |
| Conditionnalité | Aucune | 5 BCAE, -3 à -5% par manquement |
| Aide bovine allaitante | **150 €/tête** | **150 €/tête** |
| Aide bovine laitière | 35 €/tête (plafond 60 VL) | 35 €/tête (plafond 60 VL) |
| Aide ovine | 22 €/brebis | 22 €/brebis |
| Aide caprine | 16 €/chèvre | 16 €/chèvre |
| Prix achat terre | 4 000-9 000 €/ha | × qualité × accessibilité |
| Fermage | 90-250 €/ha | Indexé (±20%) |
| Bail | Résiliable annuel | 9 ans, 85% renouvellement |
| Amplitude prix saisonnière | ±5-8% | ±10-20% |
| Amplitude offre/demande | ±12% | ±25% |
| Cycles pluriannuels | Non | Oui (3-4 ans) |
| Contrats anticipés | Non | Oui |
| Coût de stockage | 0 | 0,5%/mois + 0,50 €/t/mois |
| Comptabilité | Solde + marge/culture | Compte de résultat + bilan + ratios |
| **Faillite possible** | **Non** | Oui (avec outils de sauvetage) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Charges Normal 20% → 12%, cotisation min 2000 → 1000 € | ADR-002 : préserver la recette SimAgri (progression fluide) |
| 2026-08-04 | Ajout des 8 leviers de gain Expert + simulation année 3 | Corriger l'incohérence : Expert doit rapporter plus que Normal |
| 2026-08-04 | Aide bovine allaitante 130 → 150 €/tête | Resserrer l'écart entre filières de 32% à 25% |
| 2026-08-04 | Ajout checklist test recette SimAgri (bloquante) | ADR-002 |
| 2026-08-04 | **Charges Expert 35% → 28%** | ADR-003 : taux effectif réel après optimisation fiscale |
| 2026-08-04 | Clarification : Expert = profondeur, pas supériorité économique | ADR-003 |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |