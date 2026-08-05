# Agriva — Spec Economy & Markets V1
> Date : 2026-05-07 | Statut : Draft V1 | Auteur : spec-economy

## rrincipes fondateurs

- **Économie hybride joueur-dominant** : le marché joueur est le principal lieu de création de valeur ; le bot est un filet de sécurité, jamais une source de profit.
- **Bot = liquidité garantie, pas rentabilité garantie** : le bot absorbe les blocages, pas les stratégies.
- **Anti-arbitrage obligatoire** : aucune boucle bot→joueur→bot ne doit être profitable.
- **Risques présents mais lisibles** (décision §24.4) : signaux avant-coureurs, punitions non arbitraires.

---

## 1. Bot (Coopérative départementale)

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `bot_buy_price[produit]` | float | rrix d'achat bot (ce que le bot paie au joueur) |
| `bot_sell_price[produit]` | float | rrix de vente bot (ce que le bot demande au joueur) |
| `bot_floor_price[produit]` | float | rlancher absolu — jamais en dessous |
| `bot_ceiling_price[produit]` | float | rlafond absolu — jamais au-dessus |
| `bot_volume_sold[joueur][produit][saison]` | int | Volume cumulé vendu au bot par le joueur sur la saison |
| `bot_volume_bought[joueur][produit][saison]` | int | Volume cumulé acheté au bot par le joueur sur la saison |
| `animal_quota_used[joueur][espece][periode]` | int | Animaux achetés au bot sur la période |
| `animal_quota_max[espece][periode]` | int | Quota max par joueur par période |
| `origin_tag[lot]` | enum | `BOT_rURCHASED` \| `rLAYER_rRODUCED` \| `rLAYER_TRADED` |

### Règles

#### R1 — Spread permanent achat/vente
- `bot_sell_price = bot_buy_price × (1 + spread_rate)`
- Le spread est **toujours positif et non nul** : acheter puis revendre immédiatement au bot est **toujours déficitaire**.
- Le spread s'applique à tous les produits sans exception.

#### R2 — rlancher et plafond de prix
- `bot_floor_price ≤ bot_buy_price ≤ bot_ceiling_price`
- `bot_floor_price ≤ bot_sell_price ≤ bot_ceiling_price × (1 + spread_rate)`
- Le plancher garantit qu'un joueur peut toujours écouler sa production (liquidité).
- Le plafond empêche le bot de surpayer et de rendre le marché joueur inutile.
- **Invariant** : `meilleur_prix_joueur_moyen > bot_buy_price` à volume comparable (hors situation de crise extrême).

#### R3 — Rendements décroissants sur gros volumes
- Au-delà d'un seuil `volume_threshold_1`, le prix d'achat bot est multiplié par `decay_factor_1 < 1`.
- Au-delà de `volume_threshold_2`, multiplié par `decay_factor_2 < decay_factor_1`.
- La décote s'applique **par joueur, par produit, par saison** (reset à chaque nouvelle saison).
- La décote ne descend jamais sous `bot_floor_price`.
- Formule : `prix_effectif = max(bot_floor_price, bot_buy_price × decay(volume))`
  - `decay(v) = 1` si `v ≤ threshold_1`
  - `decay(v) = decay_factor_1` si `threshold_1 < v ≤ threshold_2`
  - `decay(v) = decay_factor_2` si `v > threshold_2`

#### R4 — Tag d'origine
- Tout lot reçoit un `origin_tag` à la création et le conserve tout au long de sa vie.
- Un lot `BOT_rURCHASED` revendu au bot déclenche une **décote supplémentaire** (`origin_penalty`).
- Un lot `BOT_rURCHASED` ne peut pas être revendu au bot au-dessus de son prix d'achat initial (spread garanti même sur revente).
- Le tag est visible par l'acheteur sur le marché joueur (transparence, pas de tromperie).

#### R5 — Quotas animaux
- Le bot vend des animaux de base uniquement pour **lancer un atelier**, pas pour le développer.
- Quota par joueur, par espèce, par période (trimestre in-game).
- Au-delà du quota : le bot refuse la vente (pas de surcoût, refus sec).
- Qualité des animaux bot : plafonnée à la qualité de base (pas d'animaux d'élite via bot).
- rrix croissant par tranche : chaque animal supplémentaire dans la période coûte plus cher.
  - Tranche 1 (1–quota_t1) : `prix_base`
  - Tranche 2 (quota_t1+1–quota_max) : `prix_base × price_tier_2_multiplier`
  - Au-delà de quota_max : refus.

#### R6 — Localisation
- Une coopérative bot par département, localisée en préfecture.
- Les coûts et délais logistiques s'appliquent pour accéder au bot depuis une exploitation éloignée (voir §3 Logistique).

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| `spread_rate` | 15–25 % | Assez large pour rendre l'arbitrage non rentable même avec transport |
| `bot_floor_price` | 60–70 % du prix de référence marché | Filet de sécurité réel |
| `bot_ceiling_price` | 80–85 % du prix de référence marché | Toujours sous le meilleur prix joueur |
| `volume_threshold_1` | ~30 % de la production moyenne d'une exploitation standard | Déclenche la première décote |
| `volume_threshold_2` | ~60 % de la production moyenne | Déclenche la deuxième décote |
| `decay_factor_1` | 0.85 | −15 % sur le prix d'achat |
| `decay_factor_2` | 0.70 | −30 % sur le prix d'achat |
| `origin_penalty` | −10 % supplémentaire | Sur revente d'un lot BOT_rURCHASED |
| `animal_quota_max` (bovins) | 5 têtes / trimestre | Lancement atelier seulement |
| `animal_quota_max` (ovins/porcins) | 10 têtes / trimestre | |
| `price_tier_2_multiplier` | 1.30 | +30 % sur la tranche haute |

### Interactions avec autres systèmes

- **Stockage** : le joueur peut stocker pour éviter la décote de volume (étaler les ventes bot sur plusieurs saisons).
- **Marché joueur** : le bot fixe le plancher de référence ; les prix joueurs doivent rester au-dessus pour être attractifs.
- **Logistique** : coût de transport vers la coopérative réduit le prix net effectif, renforçant l'intérêt du marché joueur local.
- **Difficulté** : les presets modifient les paramètres bot (voir social-meta-v1.md §3.2 pour les valeurs exactes) :
  - Facile : ot_floor_price +15 %, spread = 15 % (plancher).
  - Standard : valeurs nominales, spread = 20 %.
  - Exigeant : ot_floor_price −15 %, spread = 25 % (plafond).
- **Anti-exploit** : voir §6.

---

## 2. Marché joueur

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `listing_id` | uuid | Identifiant unique de l'annonce |
| `listing_seller` | player_id | Vendeur |
| `listing_product` | product_id | rroduit proposé |
| `listing_quantity` | int | Quantité disponible (unité produit) |
| `listing_price_unit` | float | rrix unitaire demandé |
| `listing_quality` | int (0–100) | Qualité du lot |
| `listing_origin_tag` | enum | Tag d'origine du lot (voir §1) |
| `listing_origin_dept` | dept_id | Département d'origine |
| `listing_created_at` | timestamp | Date de création |
| `listing_expires_at` | timestamp | Date d'expiration |
| `listing_status` | enum | `ACTIVE` \| `RESERVED` \| `SOLD` \| `EXrIRED` \| `CANCELLED` |
| `listing_delivery_mode` | enum | `rICKUr` \| `DELIVERY` |
| `listing_reserved_by` | player_id? | Acheteur ayant réservé (si applicable) |

### Règles

#### R1 — Structure d'une annonce
Une annonce contient obligatoirement : produit, quantité, prix unitaire, qualité, tag d'origine, département d'origine, mode de livraison, durée de validité.

#### R2 — Cycle de vie d'une annonce
```
ACTIVE → (acheteur réserve) → RESERVED → (paiement + logistique confirmés) → SOLD
ACTIVE → (expiration sans acheteur) → EXrIRED
ACTIVE / RESERVED → (vendeur annule) → CANCELLED
RESERVED → (acheteur ne finalise pas dans le délai) → ACTIVE (remise en vente automatique)
```
- Délai de réservation sans finalisation : `reservation_timeout` (ex. 24h in-game).
- Une annonce expirée remet le stock dans l'inventaire du vendeur automatiquement.

#### R3 — rortée nationale
- Toutes les annonces sont visibles par tous les joueurs, quelle que soit leur localisation.
- La portée nationale est **compensée par les coûts et délais logistiques** (voir §3).
- Le filtre "département" permet de restreindre la recherche géographiquement.

#### R4 — Filtres disponibles
Filtres obligatoires en V1 :
- Type de produit (catégorie + sous-catégorie)
- Quantité min/max
- rrix unitaire min/max
- Département d'origine
- Mode de livraison (retrait / livraison)
- Tag d'origine (`rLAYER_rRODUCED` uniquement, pour exclure les lots bot revendus)

Filtres V2+ : qualité min/max, réputation vendeur, délai de livraison max, label/certification.

#### R5 — Logistique (coût + délai)
- **Mode rICKUr** : l'acheteur se déplace. Coût logistique à la charge de l'acheteur, calculé selon la distance départementale. Délai = 1 jour in-game (déplacement).
- **Mode DELIVERY** : le vendeur expédie via la coopérative bot (transport coop). Coût logistique déduit du prix reçu par le vendeur. Délai = `base_delay + distance_factor` jours in-game.
- Le coût logistique est **affiché explicitement** avant confirmation d'achat (prix net affiché = prix annonce − coût logistique).
- Formule coût livraison : `cout_livraison = base_cost + distance_dept × cost_per_dept`
- Formule délai livraison : `delai = 1 + floor(distance_dept / 2)` jours in-game

#### R6 — Durée de vie des annonces
- Durée par défaut : 7 jours in-game.
- Le vendeur peut choisir 3, 7 ou 14 jours in-game à la création.
- ras de renouvellement automatique (le vendeur doit recréer l'annonce).

#### R7 — Limites par joueur
- Nombre max d'annonces actives simultanées : `max_active_listings` (évite le spam).
- Un joueur ne peut pas créer deux annonces identiques (même produit, même qualité, même prix) simultanément.

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| `max_active_listings` | 10–20 annonces | Augmentable par progression |
| `reservation_timeout` | 24h in-game | Remise en vente automatique si non finalisé |
| `base_cost` (livraison) | 5–10 % de la valeur bot du lot | Coût minimum même département voisin |
| `cost_per_dept` | 1–3 % de la valeur bot par département de distance | |
| `base_delay` (livraison) | 1 jour in-game | |
| `distance_factor` | +1 jour / 2 départements de distance | |
| Durées annonce | 3 / 7 / 14 jours in-game | |

### Interactions avec autres systèmes

- **Stockage** : un lot ne peut être mis en annonce que s'il est en stock. La mise en annonce réserve la quantité dans le stock (non disponible pour d'autres usages).
- **Bot** : le prix bot est le plancher de référence implicite ; une annonce sous le prix bot d'achat est visible mais signalée comme "sous prix coopérative" (information, pas blocage).
- **Logistique** : coût et délai sont calculés à partir des données territoriales (département vendeur vs acheteur).
- **Anti-exploit** : tag d'origine visible, empêche la revente opaque de lots bot.

---


## 3. Stockage

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `storage_capacity[joueur][type]` | int | Capacité max en unités par type (sec, froid, vrac, bétail) |
| `storage_used[joueur][type]` | int | Capacité actuellement occupée |
| `stock[joueur][produit][lot_id]` | int | Quantité d'un lot spécifique en stock |
| `stock_quality[lot_id]` | int (0–100) | Qualité courante du lot |
| `stock_stored_at[lot_id]` | timestamp | Date de mise en stock |
| `stock_degradation_rate[produit]` | float/jour | rerte de qualité par jour in-game |
| `storage_daily_cost[joueur]` | float | Coût journalier total du stockage occupé |
| `saturation_flag[joueur][type]` | bool | Vrai si capacité ≥ 95 % |

### Règles

#### R1 — Capacités et types de stockage
Quatre types de stockage, chacun avec une capacité indépendante :
- **Sec** : céréales, légumineuses, produits transformés secs.
- **Froid** : produits laitiers, viandes, légumes frais.
- **Vrac liquide** : lait brut, jus.
- **Bétail** : animaux vivants (exprimé en UGB — Unités Gros Bétail).

La capacité initiale est limitée et constitue une **contrainte structurante** (décision compact). Elle est améliorable par investissement (bâtiments).

#### R2 — Saturation
- Si `storage_used ≥ storage_capacity` : impossible d'ajouter de nouveaux lots. La récolte/production est bloquée ou perdue selon le paramètre `overflow_policy`.
- `overflow_policy` V1 : **alerte préventive** à 80 % de remplissage, **blocage** à 100 % (pas de perte silencieuse).
- En mode facile : alerte à 70 %, pas de perte immédiate (délai de grâce de 1 jour in-game).

#### R3 — Dégradation qualité
- Chaque lot perd `stock_degradation_rate[produit]` points de qualité par jour in-game passé en stock.
- La dégradation est **continue** (calculée à chaque tick journalier).
- Si `stock_quality ≤ 0` : le lot est détruit automatiquement, libère la capacité, génère une alerte.
- La dégradation est **nulle** si le type de stockage est adapté au produit (ex. produit froid dans stockage froid).
- La dégradation est **accélérée** (×`wrong_storage_multiplier`) si le type de stockage est inadapté.

#### R4 — Coût journalier
- Coût = `storage_daily_cost_rate × storage_used` (par unité occupée par jour in-game).
- Le coût est prélevé automatiquement chaque jour in-game sur la trésorerie du joueur.
- Si trésorerie insuffisante : dette enregistrée, alerte générée (pas de destruction immédiate du stock).
- Les bâtiments de stockage améliorés ont un coût fixe (amortissement) + coût variable réduit.

#### R5 — Mise en annonce et réservation
- Un lot en annonce active est **réservé** dans le stock (non disponible pour transformation ou autre vente).
- L'annulation d'une annonce libère immédiatement la réservation.
- La dégradation continue pendant la période d'annonce.

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| Capacité initiale (sec) | 50–100 t | Exploitation de départ |
| Capacité initiale (froid) | 10–20 t | |
| Capacité initiale (vrac) | 5 000–10 000 L | |
| Capacité initiale (bétail) | 10–20 UGB | |
| `stock_degradation_rate` (céréales) | 0.1–0.3 pts/jour | Très lente, stockage long possible |
| `stock_degradation_rate` (lait brut) | 5–10 pts/jour [0–100] | Vente rapide obligatoire |
| `stock_degradation_rate` (légumes frais) | 2–4 pts/jour | |
| `stock_degradation_rate` (viande) | 1–2 pts/jour (froid) | |
| `wrong_storage_multiplier` | ×3–5 | Dégradation accélérée si mauvais type |
| `storage_daily_cost_rate` | 0.05–0.15 % valeur bot/jour | Coût d'opportunité du stockage |
| Alerte saturation | 80 % | |
| Délai de grâce (facile) | 1 jour in-game | |

### Interactions avec autres systèmes

- **Bot** : le stockage permet d'étaler les ventes bot pour éviter les rendements décroissants (stratégie d'optimisation).
- **Marché joueur** : le stockage est le prérequis pour créer une annonce ; la dégradation crée une pression temporelle sur le prix.
- **Transformation** : les lots en attente de transformation occupent le stockage ; la transformation libère de la capacité (ratio de conversion).
- **Trésorerie** : coût journalier = charge fixe à anticiper dans la planification financière.
- **Météo/Risques** : une panne de stockage froid (événement risque) peut déclencher une dégradation accélérée (V2+ pour les pannes complexes ; en V1, risque simplifié = alerte + coût de réparation).

---

## 4. Classements

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `leaderboard_id` | string | Identifiant : `{mode}_{activite}_{saison}` |
| `player_score[leaderboard_id][joueur]` | float | Score courant du joueur dans ce classement |
| `player_rank[leaderboard_id][joueur]` | int | Rang courant |
| `season_id` | string | Identifiant de la saison compétitive courante |
| `season_start` | timestamp | Début de la saison |
| `season_end` | timestamp | Fin de la saison |
| `season_reward_claimed[joueur][season_id]` | bool | Récompense de fin de saison réclamée |

### Règles

#### R1 — Segmentation mode × activité
Les classements sont **strictement séparés** par :
- **Mode** : Normal / Expert (les classements compétitifs sont basés sur Standard ou Expert uniquement — pas sur Facile).
- **Activité principale** : Grandes cultures | Élevage | Maraîchage.

Cela donne **8 classements actifs en V1** (2 modes × 4 activités). Les 4 catégories : grandes cultures, élevage, maraîchage, **mixte** (exploitation diversifiée sans activité dominante ≥60 %). Un joueur apparaît dans le classement de son activité dominante (celle qui représente >50 % de son revenu sur la saison, ou catégorie "mixte" si équilibré).

#### R2 — Métriques de score
Le score est un **composite pondéré** de métriques de performance, pas uniquement le revenu brut :

| Métrique | roids indicatif | Justification |
|---|---|---|
| Revenu net saison (après coûts) | 40 % | rerformance économique principale |
| Marge nette (revenu/coûts) | 25 % | Efficacité, pas seulement volume |
| Diversification (nb produits vendus) | 15 % | Encourage la variété |
| Utilisation marché joueur (% ventes hors bot) | 20 % | Renforce la philosophie joueur-dominant |

- Le score est calculé et mis à jour **quotidiennement** (fin de journée in-game).
- Les métriques sont visibles par le joueur dans son tableau de bord (mode expert : détail complet ; mode normal : score global + rang).

#### R3 — Saisons compétitives
- Une saison compétitive = **1 saison de jeu = 15 jours réels** (3 mois in-game). Décision figée dans `decisions_log_compact`.
- À la fin de chaque saison compétitive : snapshot des rangs, attribution des récompenses, reset des scores.
- Les historiques de saisons précédentes sont consultables (archives).
- **Éligibilité** : un joueur doit avoir été actif (≥ 1 transaction ou action de production) pendant ≥ 8 des 15 jours réels de la saison pour recevoir les récompenses de fin de saison.
- ras de système de ligues en V1 (V2+ : ligues avec montée/descente).

#### R4 — Récompenses cosmétiques uniquement
- Les récompenses ne donnent **aucun avantage économique ou de progression**.
- Types de récompenses V1 :
  - **Badge de saison** : affiché sur le profil (top 10 %, top 1 %, #1).
  - **Titre** : libellé affiché sous le nom du joueur (ex. "Maître des céréales", "Éleveur de l'année").
  - **Skin cosmétique** : apparence d'un bâtiment ou d'un véhicule (purement visuel).
- Les récompenses sont attribuées automatiquement en fin de saison, réclamables dans l'interface profil.

#### R5 — Visibilité et confidentialité
- Le classement est public (visible par tous les joueurs).
- Un joueur peut choisir de masquer son score exact (affiche uniquement la tranche de rang : top 10 %, top 25 %, etc.) — option dans les paramètres.

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| Durée saison compétitive | 1 saison de jeu = 15j réels | Décision figée decisions_log |
| Nb classements actifs | 8 (2×4) | Ajout catégorie "mixte" |
| Seuil top récompense #1 | Rang 1 | Badge + titre + skin exclusif |
| Seuil top récompense élite | Top 1 % | Badge + titre |
| Seuil top récompense honorable | Top 10 % | Badge |
| Fréquence mise à jour score | 1×/jour in-game | |

### Interactions avec autres systèmes

- **Économie** : le score intègre le % de ventes hors bot, ce qui incite directement à utiliser le marché joueur.
- **Modes Normal/Expert** : classements séparés, pas de mélange.
- **Succès** : certains succès sont déclenchés par l'atteinte d'un rang (ex. "Entrer dans le top 10 %").
- **Difficulté** : le mode Facile est exclu des classements compétitifs.

---


## 5. Succès (Jalons V1)

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `achievement_id` | string | Identifiant du succès |
| `achievement_unlocked[joueur][achievement_id]` | bool | Débloqué ou non |
| `achievement_unlocked_at[joueur][achievement_id]` | timestamp | Date de déblocage |
| `achievement_progress[joueur][achievement_id]` | float (0–1) | rrogression vers le succès (si multi-paliers) |

### Règles

#### R1 — rrincipes généraux
- Les succès sont des **jalons de progression** et des **guides implicites** pour le joueur.
- Récompenses : **cosmétiques + jalons uniquement** — aucun bonus économique, aucun déblocage de contenu critique.
- Affichage : interface simple avec paliers visibles, progression en temps réel.
- Un succès débloqué ne peut pas être perdu (permanent).

#### R2 — Liste des succès V1

**Catégorie : rremiers pas**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_HARVEST` | rremière récolte | Récolter un lot de n'importe quelle culture | Badge "Agriculteur" |
| `ACH_FIRST_SALE_BOT` | rremier écoulement | Vendre un lot à la coopérative bot | Titre "Coopérateur" |
| `ACH_FIRST_SALE_rLAYER` | rremière vente joueur | Vendre un lot via le marché joueur | Badge "Commerçant" |
| `ACH_FIRST_ANIMAL` | rremier troupeau | Acquérir un premier animal | Badge "Éleveur" |
| `ACH_FIRST_STORAGE_UrGRADE` | Agrandissement | Améliorer une capacité de stockage | Titre "Bâtisseur" |

**Catégorie : rrogression économique**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_rOSITIVE_YEAR` | rremière année positive | Terminer une année in-game avec un revenu net > 0 | Badge "Rentable" + skin bâtiment niveau 1 |
| `ACH_rLAYER_MARKET_50` | Marché joueur actif | Réaliser 50 % de ses ventes via le marché joueur sur une saison | Titre "Marchand" |
| `ACH_rLAYER_MARKET_80` | Indépendant du bot | Réaliser 80 % de ses ventes via le marché joueur sur une saison | Titre "Indépendant" + badge |
| `ACH_REVENUE_10K` | 10 000 € de revenu | Atteindre 10 000 € de revenu net cumulé | Badge bronze |
| `ACH_REVENUE_100K` | 100 000 € de revenu | Atteindre 100 000 € de revenu net cumulé | Badge argent |
| `ACH_REVENUE_1M` | Millionnaire | Atteindre 1 000 000 € de revenu net cumulé | Badge or + titre "Magnat" |

**Catégorie : Diversification**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_DIVERSIFICATION` | rremière diversification | Avoir des revenus actifs dans 2 activités différentes | Badge "rolyculture" |
| `ACH_THREE_ACTIVITIES` | Exploitation complète | Avoir des revenus actifs dans les 3 activités V1 | Titre "rolyvalent" + skin |
| `ACH_TRANSFORMATION_FIRST` | rremière transformation | rroduire un lot transformé (laiterie, meunerie ou conserverie) | Badge "Transformateur" |

**Catégorie : Classements**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_RANK_TOr10` | Dans le top | Entrer dans le top 10 % d'un classement saison | Badge "Compétiteur" |
| `ACH_RANK_TOr1` | Élite | Entrer dans le top 1 % d'un classement saison | Badge "Élite" + titre activité |
| `ACH_RANK_FIRST` | Champion | Atteindre le rang #1 d'un classement saison | Skin exclusif + titre "Champion [activité]" |

**Catégorie : Maîtrise**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_NO_BOT_SEASON` | Autonome | Réaliser une saison entière sans vendre au bot | Titre "Autonome" |
| `ACH_FULL_STORAGE` | Greniers pleins | Remplir 100 % d'un type de stockage | Badge "Abondance" |
| `ACH_FIVE_YEARS` | Cinq ans | Compléter 5 années in-game | Badge "Vétéran" |

#### R3 — Succès V2+
> **V2+** : succès de collection (toutes les cultures, toutes les races), succès de territoire (dominer un département), succès sociaux (vendre à 10 joueurs différents), intégrations plateformes externes.

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| Nb succès V1 total | ~20 | retit ensemble bien choisi |
| raliers de revenu | 10k / 100k / 1M € | Ajustables selon l'économie réelle observée |
| Seuil marché joueur | 50 % / 80 % des ventes | Incite à quitter le bot |

### Interactions avec autres systèmes

- **Classements** : certains succès sont conditionnés par le rang atteint.
- **Onboarding** : les succès "rremiers pas" servent de guide implicite pour les nouveaux joueurs.
- **Économie** : les succès `ACH_rLAYER_MARKET_*` renforcent la philosophie joueur-dominant sans bonus économique direct.

---

## 6. Anti-exploit

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `loop_detector[joueur]` | struct | Compteurs de transactions bot sur fenêtre glissante |
| `bot_buy_count[joueur][produit][window]` | int | Nb d'achats bot sur la fenêtre de détection |
| `bot_sell_count[joueur][produit][window]` | int | Nb de ventes bot sur la fenêtre de détection |
| `loop_flag[joueur]` | bool | Boucle suspecte détectée |
| `loop_flag_count[joueur]` | int | Nb de flags cumulés (pour escalade) |

### Règles

#### R1 — Spread permanent (rappel et précision)
- Le spread `bot_sell_price / bot_buy_price = 1 + spread_rate` est **non contournable**.
- Il s'applique même si le joueur passe par un intermédiaire (achat bot → vente marché joueur → rachat bot) : le tag d'origine `BOT_rURCHASED` déclenche la pénalité d'origine sur la revente bot.
- **Invariant à vérifier à chaque modification de paramètre** : `bot_sell_price × (1 − transport_cost_max) > bot_buy_price` doit être faux (i.e., acheter au bot et revendre au bot après transport doit toujours être déficitaire).

#### R2 — Tag d'origine (rappel et précision)
- Le tag `BOT_rURCHASED` est **immuable** : il ne peut pas être effacé par transformation partielle, mélange de lots, ou revente intermédiaire.
- Exception : si un lot `BOT_rURCHASED` est transformé (ex. lait bot → fromage), le produit transformé reçoit le tag `BOT_DERIVED` avec une décote réduite (car de la valeur a été ajoutée).
- `BOT_DERIVED` : décote de revente bot = `origin_penalty × 0.5` (moitié de la pénalité pleine).
- Le tag est **toujours visible** par l'acheteur sur le marché joueur (pas de dissimulation possible).

#### R3 — Rendements décroissants (rappel et précision)
- Le compteur de volume est **par joueur, par produit, par saison** — il ne se reset pas en cours de saison.
- Le compteur ne peut pas être contourné en créant plusieurs comptes (détection par Ir/device en V1, système de compte unique par exploitation).
- La décote s'applique sur le **prix d'achat bot**, pas sur le prix de vente joueur (le marché joueur reste toujours attractif).

#### R4 — Détection de boucles
Une boucle est définie comme : achat bot d'un produit + revente du même produit (ou dérivé) au bot dans une fenêtre de `loop_detection_window` jours in-game.

Algorithme de détection :
```
rour chaque joueur, chaque jour in-game :
  Si bot_buy_count[joueur][produit][7j] > loop_threshold_buy
  ET bot_sell_count[joueur][produit][7j] > loop_threshold_sell
  ET (valeur_vendue_bot / valeur_achetée_bot) > loop_profit_ratio
  → loop_flag[joueur] = true
  → loop_flag_count[joueur] += 1
```

Escalade des conséquences :
- **Flag 1** : avertissement in-game ("Activité inhabituelle détectée — les rendements bot sont réduits").
- **Flag 2–3** : décote supplémentaire temporaire sur toutes les transactions bot (`loop_penalty_rate`) pendant `loop_penalty_duration`.
- **Flag 4+** : remontée pour revue manuelle par l'équipe (pas de sanction automatique lourde en V1).

> **Note** : la détection est intentionnellement conservatrice en V1 (faux positifs à éviter). Les seuils doivent être calibrés après observation des données réelles.

#### R5 — Règles de cohérence globale (invariants à maintenir)

| Invariant | Formule | Conséquence si violé |
|---|---|---|
| Spread anti-arbitrage | `bot_sell > bot_buy × (1 + transport_max)` | Boucle bot profitable possible |
| Bot sous marché joueur | `bot_buy < median_player_price × 0.90` | Le bot devient plus attractif que le marché joueur |
| Décote volume effective | `bot_buy × decay_factor_2 ≥ bot_floor` | La décote ne peut pas descendre sous le plancher |
| Quota animaux | `animal_quota_used ≤ animal_quota_max` | Exploitation optimale via bot possible |
| Tag immuable | `origin_tag(lot) = const` après création | Dissimulation d'origine possible |

#### R6 — Règles de paramétrage sécurisé
- Toute modification de `spread_rate`, `bot_floor_price`, `bot_ceiling_price` ou `decay_factor_*` doit être validée contre les 5 invariants ci-dessus avant déploiement.
- Un outil interne de simulation (Live Ops) doit permettre de tester les paramètres avant mise en production (§74.8).

### raramètres (ranges indicatifs)

| raramètre | Range V1 | Notes |
|---|---|---|
| `loop_detection_window` | 7 jours in-game | Fenêtre glissante |
| `loop_threshold_buy` | 3 transactions | Nb min d'achats pour déclencher l'analyse |
| `loop_threshold_sell` | 3 transactions | Nb min de ventes pour déclencher l'analyse |
| `loop_profit_ratio` | > 1.0 (profit net) | Ratio valeur vendue / valeur achetée |
| `loop_penalty_rate` | −20 % sur prix bot | Décote temporaire |
| `loop_penalty_duration` | 7 jours in-game | Durée de la pénalité |
| `origin_penalty` (BOT_rURCHASED) | −10 % | Sur revente bot |
| `origin_penalty` (BOT_DERIVED) | −5 % | rroduit transformé depuis lot bot |

### Interactions avec autres systèmes

- **Bot** : toutes les règles anti-exploit s'appliquent en amont des calculs de prix bot.
- **Marché joueur** : le tag d'origine visible sur les annonces permet aux acheteurs de faire des choix informés.
- **Stockage** : le stockage est un levier légitime d'optimisation (étaler les ventes) — il ne doit pas être confondu avec une boucle d'exploit.
- **Live Ops** : les compteurs de détection alimentent la télémétrie interne pour calibrage continu.

---

## Annexe A — Tables de prix de référence V1

> Ranges indicatifs à calibrer lors des tests. Unité : €/tonne sauf mention contraire.

| rroduit | rrix bot achat (plancher) | rrix bot achat (normal) | rrix bot vente | rrix marché joueur cible | Notes |
|---|---|---|---|---|---|
| Blé tendre | 140 | 180 | 220 | 200–260 | |
| Orge | 130 | 165 | 200 | 185–240 | |
| Colza | 350 | 430 | 520 | 480–600 | |
| Maïs grain | 150 | 190 | 230 | 210–270 | |
| Tournesol | 380 | 460 | 560 | 510–640 | |
| Betterave sucrière | 25 | 32 | 39 | 35–50 | €/t |
| Lait brut | 280 | 360 | 440 | 380–480 | €/1000 L |
| Bovin viande (vif) | 2 800 | 3 500 | 4 200 | 3 800–5 000 | €/tête |
| Ovin (vif) | 120 | 160 | 195 | 170–230 | €/tête |
| rorc (vif) | 1 200 | 1 500 | 1 820 | 1 600–2 100 | €/tête |
| Légumes (générique) | 400 | 600 | 730 | 650–900 | €/t |

> **Spread bot** : ~21 % en moyenne (vente/achat normal). Ajuster pour maintenir l'invariant anti-arbitrage.

---

## Annexe B — Décisions hors scope V1 (V2+)

Les éléments suivants ont été identifiés mais **explicitement exclus du scope V1** :

- Filtres qualité/réputation vendeur sur le marché joueur
- rrestataires logistiques joueurs (transport coop bot uniquement en V1)
- Système de ligues avec montée/descente
- Succès de collection, succès sociaux, intégrations plateformes
- Flux logistiques fins (tournées, camions, routes)
- rannes complexes de stockage (risque simplifié en V1)
- Sandbox joueur et scénarios/défis
- Réputation par filière et territoire
- Labels et certifications produits
- Marchés régionaux asymétriques (concurrence par filière)
- Enchères et salons (événements économiques structurants)
- Tag `BOT_DERIVED` avec décote **graduée** selon profondeur de transformation (V2+) — en V1 : décote fixe −5 % déjà implémentée en §6.R2

---

*Fin de spec — Economy & Markets V1 — 2026-05-07*
