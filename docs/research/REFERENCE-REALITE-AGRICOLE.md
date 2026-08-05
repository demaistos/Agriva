# RÉFÉRENCE RÉALITÉ AGRICOLE — Synthèse pour Game Design

> **Document de synthèse Agriva** — Consolidation des 5 documents de recherche (cultures, élevage, matériel, économie, métiers annexes) en un guide opérationnel pour le game design.
>
> Date : Août 2026
> Statut : Validé
> Usage : référence permanente pour tout le game design Agriva

---

## 1. Vue d'ensemble et méthodologie

### 1.1 Objectif de cette recherche

Produire une base de données factuelle sur la réalité agricole française 2024-2026, comparée au modèle SimAgri, pour guider les décisions de game design d'Agriva. Chaque recommandation est classée par priorité (V1/V2/V3) et assignée à un mode de jeu (Normal/Expert/les deux).

### 1.2 Sources

| Document | Lignes | Contenu |
|----------|:------:|---------|
| `reality-vs-simagri-cultures.md` | ~3 700 | 14 cultures, rotations, itinéraires techniques, économie |
| `reality-vs-simagri-elevage.md` | 2 253 | 7 espèces, alimentation, reproduction, santé, effluents |
| `reality-vs-simagri-materiel.md` | 1 741 | 15 catégories de matériel, GPS, entretien, commerce |
| `reality-vs-simagri-economie.md` | 1 238 | Marchés, coopératives, banque, PAC, fiscalité, foncier |
| `reality-vs-simagri-metiers.md` | 696 | ETA, concessionnaire, fromagerie, méthanisation, CAR |
| **Total** | **~9 600** | |

### 1.3 Méthodologie

Pour chaque domaine :
1. **Réalité terrain** : données chiffrées France 2024 (sources officielles)
2. **Modèle SimAgri** : ce qui est implémenté (SDD, règles, GAME_DESIGN)
3. **Comparaison** : correct / simplifié / faux / manquant
4. **Recommandation Agriva** : priorisé V1 (lancement) → V2 (profondeur) → V3 (polissage)
5. **Mode** : assignation Normal / Expert / les deux

---

## 2. Bilan SimAgri par domaine

### 2.1 Notes par domaine

| Domaine | Note /10 | Commentaire |
|---------|:--------:|-------------|
| **Cultures** | 7/10 | Bon système (météo, sol N-P-K, qualité récolte, techniques). Manque rotations, effet précédent, variétés. |
| **Élevage** | 5/10 | Base correcte (gestation, races, rations). Manque poulet chair, portée, IC, maladies, saisonnalité repro. |
| **Matériel** | 6,5/10 | Catalogue exhaustif (50+ outils). Manque largeur/débit, ETA, CUMA, fenêtre météo. |
| **Économie** | 4/10 | Log financier et marché offre/demande OK. Manque charges (0%), PAC (0%), fermage, volatilité. |
| **Métiers annexes** | 7/10 | Point fort (concessionnaire 9/10, fromagerie 8/10, CAR 8/10). Manque PV, vente directe. |
| **Moyenne** | **5,9/10** | |

### 2.2 Ce que SimAgri fait BIEN (à garder dans Agriva)

| Élément | Domaine | Qualité |
|---------|---------|---------|
| Concessionnaire joueur | Métiers | Hall + atelier + GPS + pièces + dépôt-vente = métier complet |
| Fromagerie | Métiers | 6 compétences, affinage, DLC, marchés = gameplay riche |
| CAR multi-joueurs | Métiers | Parts sociales, sous-activités, emprunts = social fort |
| Fenaison (4 étapes) | Matériel | Fauche → fanage → andainage → pressage = séquence réaliste |
| Combinés (9 attelages) | Matériel | Avant+arrière = optimisation temps = satisfaisant |
| Tick prix offre/demande | Économie | Variation ±15% selon l'activité des joueurs = dynamique |
| Sol 6 éléments | Cultures | N-P-K-Ca-Mg-S = base agronomique solide |
| Météo 4 zones + vent/pluie | Cultures | Impact récolte + blocage pulvé = tension |
| Usure + pannes | Matériel | Probabilité liée à l'état = risque gérable |
| Maniabilité (1-5) | Matériel | Adéquation outil/parcelle = choix tactique |
| PA comme unité de temps | Core | Limite le joueur, rend chaque action coûteuse |
| Géographie par zones | Core | Distance = coût de transport = dimension spatiale |
| Labels bio (+20%) | Élevage/Cultures | Choix stratégique avec contraintes |
| Génétique IVRAD | Élevage | Sélection animale avec indices = profondeur long terme |

### 2.3 Ce que SimAgri fait MAL (à corriger dans Agriva)

| Élément | Domaine | Problème | Impact |
|---------|---------|----------|--------|
| 0% de charges sociales | Économie | Le joueur garde 100% de ses revenus | Fausse toute la rentabilité |
| 0% d'aides PAC | Économie | Bovin allaitant/ovin non-viables | Filières déséquilibrées |
| Pas de fermage | Économie | Achat obligatoire (3000€/ha) | Barrière d'entrée irréaliste |
| Pas de poulet de chair | Élevage | 70% de la volaille réelle absente | Filière manquante |
| Pas de largeur/débit | Matériel | Le temps ne dépend pas de la taille de l'outil | Pas de choix stratégique |
| Pas d'ETA | Matériel | Le joueur DOIT tout acheter | Bloque un modèle économique majeur |
| Pas de portée réaliste | Élevage | Porc sans 14 porcelets/portée | Le porc perd sa mécanique centrale |
| Prix non saisonniers | Économie | Pas de "quand vendre" | Supprime la dimension temporelle |
| Pas de fenêtre météo | Matériel | Travaux possibles n'importe quand | Pas de pression temporelle |
| IC absent | Élevage | L'alimentation ne corrèle pas avec la croissance | Pas d'optimisation en élevage |


---

## 3. Modes Normal vs Expert — Grille par système

> Références : ADR-001 (`docs/decisions/ADR-001-modes-de-jeu.md`) et **ADR-002 (`docs/decisions/ADR-002-recette-simagri-en-normal.md`)**
> Principe : même monde, mêmes prix. Expert = profondeur additionnelle, pas du contenu bloqué.
>
> ⚠️ **Contrainte prioritaire (ADR-002)** : le mode Normal reproduit la recette SimAgri qui a fait son succès depuis 2005. Chaque nouveauté en Normal doit **ajouter du choix, pas de la contrainte**. Pas de frein à la progression, pas de complexité obligatoire, pas de perte définitive.

### 3.1 Cultures

| Système | Mode Normal | Mode Expert |
|---------|-------------|-------------|
| **Semis** | 1 date optimale, pénalité hors fenêtre large | Fenêtre serrée (±5j), densité ajustable, variétés |
| **Fertilisation** | "Engrais" = 1 produit, dose recommandée auto | N-P-K séparés, analyse sol, modulation, timing apports |
| **Traitements** | "Traitement" = 1 passage automatique | Herbicide/fongicide/insecticide séparés, seuils, météo |
| **Rotations** | Bonus si bonne rotation (+5%) | Effet précédent obligatoire (+8% / -15%), pression maladie |
| **Récolte** | Fenêtre large (7j), pas de perte | Fenêtre serrée (3j), humidité, pertes si retard |
| **Rendement** | f(engrais, météo) simple | f(sol, rotation, variété, date semis, densité, phytos, météo) complet |
| **Qualité** | 3 niveaux (bon/moyen/mauvais) | Protéines, PS, humidité, mycotoxines → primes continues |
| **Bio** | +20% prix, pas de phyto | Cahier des charges complet (rotation +1, fumure organique, désherbage méca) |
| **Irrigation** | Si besoin = arroser | Bilan hydrique, doses calculées, coût énergie, quotas |

### 3.2 Élevage

| Système | Mode Normal | Mode Expert |
|---------|-------------|-------------|
| **Alimentation** | 1 ration/espèce, auto-distribution | Formulation (foin/ensilage/concentré), qualité fourrage, IC |
| **Reproduction** | Automatique si mâle+femelle, toute l'année | Saisonnalité (ovin/caprin), détection chaleurs, synchronisation |
| **Portée** | Réaliste (14 porcelets, 1-3 agneaux) | Idem + prolificité comme indice génétique sélectionnable |
| **Santé** | Jauge santé, vaccins préventifs, mortalité de fond | Maladies spécifiques, contagion, biosécurité, parasitisme |
| **Abattage** | Au poids cible (pas à l'âge) | Idem + TMP (porc), grille EUROP (bovin), classement carcasse |
| **Génétique** | Indices visibles, croisement simplifié | Génomique, évaluation génomique, semence sexée, transplantation |
| **Effluents** | Production auto, épandage = engrais gratuit | Plafond 170 kg N/ha, calendrier, stockage min, distances |
| **Labels** | Bio = +20% prix | Label Rouge, AOP (cahier des charges), plein-air, IGP |
| **Traite** | Action "traire" = lait | Courbe de lactation, tarissement, monotraite, robot = auto |
| **Poulet chair** | Lot → poids cible → vente | Labels (35j standard vs 81j Label), bandes, vide sanitaire, IC |

### 3.3 Matériel

| Système | Mode Normal | Mode Expert |
|---------|-------------|-------------|
| **Débit de chantier** | Largeur → temps/ha (calculé auto) | Idem + vitesse, conditions sol, rendement machine |
| **Consommation** | Forfait L/ha par opération | L/h réel × temps, variable selon charge |
| **Usure** | Compteur horaire, pannes probabilistes | Idem + pièces d'usure détaillées, maintenance préventive |
| **GPS** | Bonus débit -10% + économie intrants -5% | Niveaux (barre/DGPS/RTK), modulation VRA, coupure tronçons |
| **ETA** | Option "faire faire" à prix/ha fixe | Choix prestataire (joueur), file d'attente en pointe, contrat annuel |
| **CUMA** | Matériel partagé (coût ÷ N) | Planning de réservation, ordre de passage, cotisation |
| **Achat** | Neuf ou occasion (argus) | Crédit-bail, location courte durée, enchères |
| **Fenêtre météo** | Bonus/malus si mauvais timing | Blocage strict (pas de labour si sol saturé, pas de pulvé si vent) |
| **Combinés** | Gain de temps affiché | Calcul exact du gain (largeur × vitesse × nombre d'opérations) |

### 3.4 Économie

| Système | Mode Normal | Mode Expert |
|---------|-------------|-------------|
| **Charges sociales** | Forfait 12% du bénéfice (ADR-002) | MSA réaliste 35-40% + IR progressif |
| **Aides PAC** | DPB auto (~150€/ha) + couplées animales | Éco-régime (conditions), MAEC (engagement 5 ans), ICHN |
| **Prix marché** | Variation ±15%, saisonnalité légère | Volatilité ±30-50%, cycles pluriannuels, événements macro |
| **Foncier** | Achat (5-10k€/ha) OU fermage (200€/ha/an) | Prix variable selon zone/qualité, bail 9 ans, SAFER |
| **Contrats** | Vente au prix du jour (spot) | Contrats anticipés (fixe/indexé), engagement volume, pénalités |
| **Comptabilité** | Solde + historique + bénéfice net | EBE, bilan, amortissement, ratios (annuités/EBE), simulation |
| **Employés** | Coût = salaire × 1,3 (charges incluses) | Compétences, formation, saisonniers, pénurie |
| **Assurance** | Matériel (existant) + récolte (option) | MRC modulable (franchise), bétail, perte exploitation |
| **Labels** | Bio (+20%) | AOP/IGP/LR : cahier des charges + survaleur (+30-200%) |
| **Banque** | Emprunts simples (taux fixe, durée) | Crédit-bail, crédit campagne, taux variable, refus si surendetté |

### 3.5 Métiers annexes

| Système | Mode Normal | Mode Expert |
|---------|-------------|-------------|
| **ETA** | PNJ (prestation au prix/ha affiché) | Joueur prestataire, file d'attente, contrat annuel |
| **Concessionnaire** | Achat neuf/occasion + réparation PNJ | Joueur concessionnaire (hall, atelier, GPS, pièces) |
| **Fromagerie** | Transformation lait → fromage (simplifié) | Compétences fromagers, affinage, DLC, AOP, marchés |
| **Coopérative** | PNJ (achat/vente au prix catalogue) | CAR multi-joueurs (parts sociales, gouvernance) |
| **Méthanisation** | Investissement → revenu passif | Gestion substrats, panne/usure, CIVE, dimensionnement |
| **Photovoltaïque** | Investissement → revenu passif | Orientation, puissance, autoconsommation vs revente |
| **Vente directe** | Option marge ×2, coûte du temps | Marchés (jours fixes), AMAP, drive, saisonnalité demande |

### 3.6 Principe d'implémentation

```
Si mode == Normal :
  → Utiliser les valeurs par défaut / forfaitaires
  → Masquer les paramètres avancés dans l'UI
  → Résultat = f(paramètres simples)

Si mode == Expert :
  → Exposer tous les paramètres
  → Ajouter les contraintes (météo bloquante, plafond N, etc.)
  → Résultat = f(paramètres détaillés)
  → Bonus possible si optimisation poussée

Architecture :
  → La couche de calcul Expert EST le moteur de simulation
  → Le mode Normal = le mode Expert avec des paramètres verrouillés aux valeurs optimales
  → Pas deux moteurs séparés, un seul moteur avec des overrides
```


---

## 4. TOP 20 ajouts critiques pour Agriva (tous domaines)

> Classement global par impact gameplay × faisabilité. Chaque ajout est assigné à un mode (N = Normal, E = Expert, N+E = les deux) et une phase.

| # | Ajout | Domaine | Mode | Phase | Impact | Complexité |
|:-:|-------|---------|:----:|:-----:|:------:|:----------:|
| 1 | **Charges sociales** (~20% N, ~35% E) | Économie | N+E | V1 | ★★★★★ | ★☆☆ |
| 2 | **Fermage** (location de terres) | Économie | N+E | V1 | ★★★★★ | ★☆☆ |
| 3 | **ETA / prestation** (faire faire les travaux) | Matériel | N+E | V1 | ★★★★★ | ★☆☆ |
| 4 | **Aides PAC** (DPB + couplées) | Économie | N+E | V1 | ★★★★★ | ★☆☆ |
| 5 | **Largeur de travail = débit** (heures/ha) | Matériel | N+E | V1 | ★★★★★ | ★☆☆ |
| 6 | **Poulet de chair** (filière cycle court) | Élevage | N+E | V1 | ★★★★★ | ★★☆ |
| 7 | **Portée réaliste** (14 porcelets, 1-3 agneaux) | Élevage | N+E | V1 | ★★★★★ | ★☆☆ |
| 8 | **IC** (indice de consommation) | Élevage | E | V1 | ★★★★★ | ★☆☆ |
| 9 | **Poids d'abattage** (pas l'âge) | Élevage | N+E | V1 | ★★★★☆ | ★☆☆ |
| 10 | **Consommation carburant/opération** | Matériel | N+E | V1 | ★★★★☆ | ★☆☆ |
| 11 | **Saisonnalité des prix** | Économie | N+E | V1-V2 | ★★★★☆ | ★☆☆ |
| 12 | **Fenêtre météo** (blocage travaux) | Matériel | E | V1-V2 | ★★★★☆ | ★★☆ |
| 13 | **Prix dynamiques** (volatilité élevée) | Économie | E | V2 | ★★★★☆ | ★★☆ |
| 14 | **Labels** (Bio, LR, AOP) + survaleur | Multi | E | V2 | ★★★★☆ | ★★☆ |
| 15 | **Contrats de vente anticipés** | Économie | E | V2 | ★★★★☆ | ★★☆ |
| 16 | **Robot de traite** | Élevage/Mat. | N+E | V2 | ★★★★☆ | ★★☆ |
| 17 | **Classes de machines** (petit/moyen/grand) | Matériel | N+E | V2 | ★★★★☆ | ★★☆ |
| 18 | **Fromagerie fermière** (caprin/ovin) | Métiers | N+E | V2 | ★★★☆☆ | ★★☆ |
| 19 | **Maladies spécifiques + biosécurité** | Élevage | E | V2 | ★★★☆☆ | ★★★ |
| 20 | **Photovoltaïque toiture** (revenu passif) | Métiers | N+E | V2 | ★★★☆☆ | ★☆☆ |

### 4.1 Regroupement par phase

**V1 (lancement — indispensable pour que le jeu soit crédible) :**
1. Charges sociales forfaitaires
2. Fermage (louer des terres)
3. ETA (prestation par tiers)
4. Aides PAC (DPB + couplées animales)
5. Largeur = débit de chantier
6. Poulet de chair (filière cycle court)
7. Portée réaliste par espèce
8. IC (mode Expert)
9. Poids d'abattage (pas l'âge)
10. Consommation carburant par opération
11. Saisonnalité des prix (légère en Normal, forte en Expert)

**V2 (profondeur — rend le jeu riche et rejouable) :**
12. Fenêtre météo bloquante (Expert)
13. Prix très volatils + cycles (Expert)
14. Labels (Bio/LR/AOP) avec cahier des charges
15. Contrats anticipés (Expert)
16. Robot de traite
17. Classes de machines
18. Fromagerie fermière
19. Maladies + biosécurité (Expert)
20. Photovoltaïque

### 4.2 Répartition Normal vs Expert

| Mode | Nombre d'ajouts | Philosophie |
|------|:---------------:|-------------|
| **Normal + Expert** (les deux) | 14/20 | Mécaniques de base accessibles à tous |
| **Expert seulement** | 6/20 | Complexité additionnelle pour les optimiseurs |

Les 6 ajouts "Expert only" :
- IC (indice de consommation)
- Fenêtre météo bloquante
- Prix très volatils + cycles
- Contrats anticipés
- Maladies spécifiques + biosécurité
- Labels AOP/LR (cahier des charges détaillé)

→ En mode Normal, ces systèmes existent mais sous forme simplifiée (pas de blocage, pas de contagion, pas de crash de prix).


---

## 5. Chiffres clés de référence (pour le balancing)

> Données France 2024 utilisables directement pour le paramétrage du jeu.

### 5.1 Prix de vente (€/t sauf mention contraire)

| Produit | Prix Normal (base) | Fourchette Expert | Saisonnalité |
|---------|:------------------:|:-----------------:|:------------:|
| Blé meunier | 220 | 160-380 | Bas juillet, haut mars |
| Orge | 195 | 140-330 | Bas juillet |
| Maïs grain | 200 | 150-350 | Bas novembre |
| Colza | 470 | 360-830 | Variable |
| Tournesol | 410 | 300-700 | Variable |
| Lait vache | 0,43 €/L | 0,30-0,55 | Cycle 3-4 ans |
| Lait chèvre | 0,85 €/L | 0,65-1,00 | Stable |
| Porc (carcasse) | 1,75 €/kg | 1,20-2,10 | Cycle 3-4 ans |
| JB viande | 5,10 €/kg carc. | 4,00-6,00 | Stable |
| Agneau | 7,50 €/kg carc. | 5,50-9,50 | Pic Pâques +20% |
| Poulet standard | 1,00 €/kg vif | 0,80-1,30 | Variable |
| Œuf plein-air | 0,18 €/unité | 0,12-0,30 | Variable |

### 5.2 Coûts de production (€/ha ou €/tête/an)

| Production | Charges opérationnelles | Charges totales | Seuil rentabilité |
|-----------|:-----------------------:|:---------------:|:-----------------:|
| Blé (75 q/ha) | 510 €/ha | 1 230 €/ha | 164 €/t |
| Maïs irrigué (100 q/ha) | 1 195 €/ha | 1 895 €/ha | 190 €/t |
| Vache laitière | 1 800-2 500 €/an | 3 000-4 000 €/an | 350 €/1000L |
| Place porc engraissement | 230-300 €/an | 350-450 €/an | 1,50 €/kg carc. |
| Brebis viande | 115-190 €/an | 200-300 €/an | Déficitaire sans PAC |
| Poulet standard (20k) | 25 000-35 000 €/lot | 35 000-50 000 €/lot | 0,95 €/kg vif |

### 5.3 Rendements de référence

| Culture | Rendement moyen France | Top 25% | Bio |
|---------|:---------------------:|:-------:|:---:|
| Blé tendre | 75 q/ha | 90-100 | 45-55 |
| Orge hiver | 70 q/ha | 85 | 40-50 |
| Maïs grain (irrigué) | 100 q/ha | 120 | 70-80 |
| Colza | 34 q/ha | 42-45 | 20-25 |
| Betterave | 85 t/ha | 95-100 | 60-70 |
| Herbe (foin) | 6-8 t MS/ha | 10-12 | 5-7 |
| Lait vache (PH) | 8 800 L/an | 11 000+ | 6 500 |

### 5.4 Investissements de référence

| Investissement | Prix 2024 | Durée vie | Amortissement/an |
|---------------|:---------:|:---------:|:----------------:|
| Terre (achat) | 6 200 €/ha | ∞ | 0 (patrimoine) |
| Fermage | 175 €/ha/an | — | — |
| Tracteur 150 CV | 150 000 € | 12 ans | 12 500 € |
| Moissonneuse classe 6 | 400 000 € | 12 ans | 33 000 € |
| Stabulation 60 VL | 400 000 € | 18 ans | 22 000 € |
| Robot de traite | 180 000 € | 10 ans | 18 000 € |
| Poulailler 400 m² | 200 000 € | 15 ans | 13 000 € |
| Méthaniseur 150 kW | 1 800 000 € | 15 ans | 120 000 € |
| PV toiture 100 kWc | 100 000 € | 25 ans | 4 000 € |

### 5.5 Revenus de référence (€/UTANS/an)

| Filière | Revenu moyen | Fourchette | Aides PAC (% revenu) |
|---------|:----------:|:----------:|:--------------------:|
| Grandes cultures 200 ha | 45 000 | 20k-80k | 40-60% |
| Bovin laitier 80 VL | 40 000 | 20k-65k | 20-35% |
| Bovin allaitant 100 VA | 20 000 | 5k-35k | 50-70% |
| Porc 200 truies NE | 45 000 | -10k-100k | 5-10% |
| Ovin 500 brebis | 20 000 | 10k-30k | 40-60% |
| Caprin fromager 300 | 35 000 | 20k-55k | 15-25% |
| Volaille standard | 30 000 | 15k-50k | 5-10% |

### 5.6 Charges fixes annuelles (exploitation type)

| Poste | Montant | À modéliser |
|-------|:-------:|:-----------:|
| MSA (charges sociales) | 12 000-22 000 € | ✅ V1 |
| Fermage (150 ha) | 25 000-45 000 € | ✅ V1 |
| Électricité | 5 000-15 000 € | ✅ (existe SimAgri) |
| Assurance | 5 000-12 000 € | V2 |
| Annuités emprunts | 20 000-60 000 € | ✅ (existe SimAgri) |
| Salariés (1 UTH) | 26 000-30 000 € | ✅ V1 |
| Carburant | 10 000-25 000 € | ✅ V1 |
| Entretien matériel | 10 000-20 000 € | ✅ (existe SimAgri) |
| Comptable + divers | 5 000-10 000 € | V3 |


---

## 6. Prochaines étapes (game design)

### 6.1 Ordre de conception recommandé

La phase de recherche est terminée. La prochaine phase est le **game design détaillé** de chaque système. Ordre recommandé (aligné avec la ROADMAP) :

| Priorité | Système à designer | Document de sortie | Prérequis recherche |
|:--------:|-------------------|-------------------|---------------------|
| 1 | **Modèle économique de base** (charges, aides, fermage, prix) | `docs/design/GDD-economie-base.md` | `economie.md` sections 1-6 |
| 2 | **Cultures V1** (itinéraire technique complet, rotation, rendement) | `docs/design/GDD-cultures.md` | `cultures.md` + `materiel.md` |
| 3 | **Matériel V1** (largeur/débit, ETA, consommation, usure) | `docs/design/GDD-materiel.md` | `materiel.md` sections 1-6, 11 |
| 4 | **Élevage bovin laitier** (traite, alimentation, reproduction) | `docs/design/GDD-bovin-laitier.md` | `elevage.md` section 1 |
| 5 | **Élevage poulet de chair** (lot, IC, cycle court) | `docs/design/GDD-poulet-chair.md` | `elevage.md` section 6 |
| 6 | **Marché et coopérative** (prix dynamiques, vente, achat) | `docs/design/GDD-marche.md` | `economie.md` sections 1-2, 9 |

### 6.2 Pour chaque GDD, spécifier

Chaque document de game design devra contenir :
1. **Mécanique en mode Normal** (comment ça marche pour le joueur moyen)
2. **Mécanique en mode Expert** (paramètres additionnels, contraintes)
3. **Données de référence** (valeurs numériques issues de cette recherche)
4. **Gameplay loop** (ce que le joueur fait concrètement au quotidien/mensuel/annuel)
5. **Feedback** (ce que le joueur voit, quand, comment il sait si ça va bien ou mal)
6. **Équilibrage** (seuils, courbes, limites)
7. **Interactions avec les autres systèmes** (dépendances)

### 6.3 Principes de game design retenus (issus de la recherche)

1. **Le temps est la ressource la plus rare** — les PA limitent tout, la météo/saison compresse les fenêtres
2. **Chaque euro compte** — les marges sont serrées (5-20% net), chaque décision a un coût visible
3. **Pas de stratégie dominante** — grandes cultures, élevage, mixte, bio, intensif = tous viables mais différents
4. **Le risque se gère** — contrats, assurance, stockage, diversification = outils anti-risque
5. **L'investissement a un ROI** — chaque achat (matériel, bâtiment, terre) a un temps de retour calculable
6. **Le social multiplie** — CUMA, CAR, ETA, marché joueurs = le multijoueur EST le gameplay économique
7. **Expert = récompense la connaissance** — savoir quand semer, quoi mettre dans la ration, quel précédent choisir = avantage réel
8. **Normal = fun sans frustration** — le jeu guide, pardonne les erreurs, donne des résultats corrects sans optimisation

---

*Document de synthèse complété le 4 août 2026.*
*Total du corpus de recherche : ~9 600 lignes + ce document de synthèse (~350 lignes) = ~10 000 lignes de référence disponibles pour le game design.*