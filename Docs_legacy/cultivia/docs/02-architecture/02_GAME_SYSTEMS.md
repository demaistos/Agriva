# 02 — GAME SYSTEMS — Spécifications Techniques

> **Cultivia Clone — Document de Systems Design**
> Chaque formule est spécifiée pour être codée directement.
> Source : GDD (00-05) + règles officielles (v. 20/04/2021)

> **NOTE:** Les coûts HT par action sont définis dans les specs de phase (docs/03-specs/phases/). Les formules ci-dessous sont des approximations — en cas de conflit, les specs de phase font autorité.

---

## 1. SYSTÈME DE TEMPS

### 1.1 Mapping temps réel → temps jeu

```
REAL_DAY        = 1 jour réel
CULTIVIA_DAY         = 1 jour Cultivia = 1 REAL_DAY
CULTIVIA_MONTH       = 7 REAL_DAY (1 semaine réelle)
CULTIVIA_YEAR        = 12 CULTIVIA_MONTH = 84 REAL_DAY
CULTIVIA_SEASON      = 3 CULTIVIA_MONTH = 21 REAL_DAY
```

### 1.2 Cycle des saisons

```
enum Season { WINTER, SPRING, SUMMER, AUTUMN }

SEASON_MAP = {
  WINTER:  [December, January, February],   // jours 1-21 de l'année
  SPRING:  [March, April, May],             // jours 22-42
  SUMMER:  [June, July, August],            // jours 43-63
  AUTUMN:  [September, October, November],  // jours 64-84
}

// Chaque mois Cultivia = 7 jours réels (lundi → dimanche)
function getSeason(sim_day_of_year: int) -> Season:
    if sim_day_of_year <= 21: return WINTER
    if sim_day_of_year <= 42: return SPRING
    if sim_day_of_year <= 63: return SUMMER
    return AUTUMN

function getSimMonth(sim_day_of_year: int) -> int:  // 1-12
    return ceil(sim_day_of_year / 7)

function getDayOfWeek(sim_day_of_year: int) -> int:  // 1=lundi, 7=dimanche
    return ((sim_day_of_year - 1) % 7) + 1
```

### 1.3 Effets des saisons

| Système | Hiver | Printemps | Été | Automne |
|---|---|---|---|---|
| Herbe | Ne pousse pas | Repousse | Pousse max | Ralentit |
| Pluie | Élevée | Moyenne | Faible | Élevée |
| Soleil | Faible | Moyen | Élevé | Moyen |
| Énergie bâtiments | Surconsommation | Normal | Surconsommation légère | Normal |
| Animaux au pré | Non (sauf allaitants) | Oui (Avril+) | Oui | Oui (→ Oct/Nov) |
| Marchés (foie gras) | ~10 kg/marché (fin année) | ~1 kg | ~1 kg | ~1 kg |

### 1.4 Tick journalier (Daily Update)

Chaque jour à minuit serveur, exécuter dans cet ordre :

```
function dailyTick():
    1. advanceDate()                    // +1 jour, vérifier changement mois/saison/année
    2. resetPlayerPA()                  // HT = 35 pour chaque joueur (reset EN PREMIER, aligné sur PHASE0)
    // + reset vehicle.hours_today = 0 pour tous les véhicules
    3. updateWeather()                  // Nouvelle météo par canton
    4. updateCropGrowth()               // +pousse% sur chaque parcelle semée
    // Appliquer bonus santé sol : growth_rate × soil_health_bonus (×1.0 à ×1.25)
    // Mettre à jour soil_health_index selon actions du jour
    5. updateAnimalAging()              // +1 jour âge, transitions état, mort naturelle si age >= max_lifespan
    6. updateAnimalHealth()             // Vérifier nourriture/eau/litière → maladie/mort (→ F011)
    // Mettre à jour welfare_index selon actions du jour (nourri, abreuvé, litière, vaccin...)
    // Appliquer bonus bien-être sur production : milk/eggs/wool × welfare_bonus (×1.0 à ×1.25)
    7. updateAnimalProduction()         // Lait, œufs, laine, duvet, croissance poids
    8. updateEquipmentWear()            // Usure quotidienne matériels + bâtiments
    // Usure naturelle : +0.5%/mois (0.017%/jour) même sans utilisation. Non abrité : ×1.5
    // Vérifier fin de vie : si hours_used >= max_lifetime_hours → marquer irréparable
    // Vérifier usure 100% outils tractés → marquer irréparable
    9. updateEquipmentBreakdowns()      // Jet de panne selon usure
    10. updateEnergyConsumption()       // Facture énergie bâtiments
    11. updateEconomy()                 // Intérêts, remboursements, salaires (si 1er du mois)
    12. updateIrrigation()              // Jauges eau parcelles irriguées
    // Formule irrigation → rendement : irrigation_factor = 0.60 + (rain_gauge / 100) × 0.40
    // rain_gauge=100 → factor=1.0 (optimal), rain_gauge=50 → 0.80, rain_gauge=0 → 0.60 (sécheresse -40%)
    13. updateComposting()              // Avancement compostage (14 jours)
    14. updateMethanisation()           // Digestion 7 jours, production biogaz
    15. updateCheeseAging()             // Affinage fromages, vérifier DLC
    16. processDeliveries()             // Livraisons en transit : animaux (F048), marchandises (F050), matériel (F049)
    17. processAutoFeeding()            // Nourrissage auto (F010) : déduit stock, nourrit animaux
    18. processLitterAccumulation()     // Accumulation fumier/lisier quotidienne (F052/F075)
    19. processWaterConsumption()       // Consommation eau quotidienne (F053)
    20. processSavingsInterest()        // Intérêts épargne + maturité (F066)
    21. processInsuranceExpiry()        // Expiration assurance matériel (F063)
    22. processMarketPrices()           // Variation cours marché (F077)
    23. processResourceAlerts()         // Alertes HVC bas, surpopulation, trésorerie (F076)
    24. processBirths()                 // Naissances animaux gestantes (F020)
```

> **Note transport** : **Coût minimum 20€** sur tout transport (même à 0km). Formule : `transport_cost = MAX(20, distance_km × rate_per_km)`. Exception : produits animaux (lait, œufs, laine) = collecte ferme **5€ minimum**. Voir `docs/reports/AUDIT_REALISME_TRANSPORT.md`.

---

## 2. SYSTÈME DE POINTS D'ACTION (HT)

### 2.1 Attribution quotidienne

```
HT_BASE             = 40        // par joueur par jour
HT_EMPLOYEE         = variable  // employé agricole (embauche 1 600 €/mois)
HT_MECHANICIEN      = 25        // par mécanicien par jour
HT_INSEMINATEUR     = 25        // par inséminateur par jour
HT_CHAUFFEUR        = 32        // par chauffeur par jour (64 si double équipage)
HT_CHIEN_TROUPEAU   = 35        // dédié déplacement animaux
HT_OUVRIER_MARAICH  = 22        // par ouvrier maraîchage

// Les HT non utilisés sont PERDUS (pas de cumul)
```

### 2.2 Coût de déplacement

```
HT_PER_CANTON         = 0.25      // par canton traversée
HT_CHANGE_DEPT      = 3.0       // changement de département
HT_MARCHE_CENTRAL     = 1.0       // trajet fixe vers Le Marché Central

function costDeplacement(zone_depart: int, zone_arrivee: int, same_dept: bool) -> float:
    if !same_dept:
        return HT_CHANGE_DEPT
    return abs(zone_arrivee - zone_depart) * HT_PER_CANTON
```

### 2.3 Coût travaux parcelle

```
// Le coût HT d'un travail dépend de :
// - surface de la parcelle (ha)
// - largeur de travail du matériel (m)
// - maniabilité du matériel (1-5)
// - GPS (oui/non)
// - combiné (oui/non)

function costTravailParcelle(
    surface_ha: float,
    largeur_travail_m: float,
    maniabilite: int,          // 1-5
    has_gps: bool,
    is_combine: bool
) -> float:
    // HT de base proportionnel à surface / largeur
    ht_base = surface_ha / (largeur_travail_m / 100)  // normalisé

    // Bonus maniabilité (petites parcelles)
    if surface_ha < 10:
        maniabilite_factor = 1.0 + (3 - maniabilite) * 0.05  // maniab 1→+10%, 5→-10%
    else:
        maniabilite_factor = 1.0

    // Bonus GPS : réduction HT
    gps_factor = 0.85 if has_gps else 1.0

    // Bonus combiné : réduction HT (2 opérations en 1 passage)
    combine_factor = 0.6 if is_combine else 1.0

    return ht_base * maniabilite_factor * gps_factor * combine_factor
```

### 2.4 Coût HT élevage

```
// Nourrissage : variable selon espèce et nombre d'animaux
// Traite : jusqu'à 4 fois/jour
// Litière : variable
// Gavage foie gras : 0.27 HT/oie, 0.0625 HT/canard
// Abattage : 0.25 HT/animal
// Tonte laine : variable
// Duvet oies : 0.025 HT/animal
// Duvet canards : 0.020 HT/animal

HT_ENTRETIEN_BATIMENT  = 0.3    // par mois par bâtiment
HT_ENTRETIEN_MATERIEL  = 1.0    // par mois par matériel
HT_ENTRETIEN_METHAN    = 1.0    // par mois par élément (digesteur/module)
HT_MARCHE              = 1 to 4 // par marché visité
HT_MARCHE_MAX_JOUR     = 16     // hors déplacements
```

### 2.5 Achat/Vente de HT

```
HT_PRICE        = 10    // €/HT, prix fixe
HT_SCOPE        = REGIONAL  // même région uniquement
```

---

## 3. SYSTÈME DE CULTURES (State Machine)

### 3.1 États de la parcelle

```
enum PlotState {
    FALLOW,         //  — pas de culture
    PREPARED,       // Sol travaillé (labouré/déchaumé/hersé)
    SOWN,           // Semé — graine en terre
    GROWING,        // Pousse — croissance en cours (0-100%)
    MATURE,         // Mature — pousse = 100%, prêt à récolter
    HARVESTED       // Récolté — retour vers FALLOW ou PREPARED
}

// Transitions :
// FALLOW → PREPARED      : labour/déchaumage/hersage
// PREPARED → SOWN        : semis (dans la fenêtre de semis de la culture)
// SOWN → GROWING         : automatique (tick journalier, pousse > 0%)
// GROWING → MATURE       : automatique (pousse >= 100%)
// MATURE → HARVESTED     : action joueur (moisson/récolte)
// HARVESTED → FALLOW     : automatique
// HARVESTED → PREPARED   : si déchaumage post-récolte

// Cas spécial herbe : MATURE → GROWING (repousse après fauche)
// Cas spécial céréale immature : GROWING (60-80%) → HARVESTED
```

### 3.2 Croissance quotidienne

```
// Chaque jour, la pousse avance d'un pourcentage
// Herbe normale : +4%/jour, avec herse de prairie : +5%/jour
// Herbe en hiver : 0%/jour
// Autres cultures : durée totale = nb jours entre semis et récolte

function dailyGrowth(plot: Plot) -> float:
    if plot.crop == GRASS:
        if currentSeason == WINTER: return 0.0
        if plot.has_herse_prairie: return 5.0
        return 4.0
    else:
        // Durée de pousse = nb de jours entre date semis et date récolte
        total_days = plot.crop.harvest_month_end - plot.crop.sow_month_start  // en jours sim
        return 100.0 / total_days
```

### 3.3 Formule de rendement

```
function calculateYield(plot: Plot) -> float:
    // Rendement de base par région (T/ha) — voir tables GDD 02_VEGETAUX §5
    base = YIELD_TABLE[plot.region][plot.crop]

    // Facteur qualité du sol (bonne=1.0, moyenne=0.85, mauvaise=0.70)
    soil_quality_factor = SOIL_QUALITY_MAP[plot.soil_quality]

    // Facteur éléments nutritifs (0.5 à 1.0)
    // Compare les réserves du sol aux besoins de la culture
    nutrient_factor = calculateNutrientFactor(plot.nutrients, plot.crop.needs)

    // Facteur engrais (1.0 si pas d'engrais, jusqu'à 1.15 si optimal)
    fertilizer_factor = 1.0 + plot.fertilizer_bonus  // 0.0 à 0.15

    // Facteur traitement phyto (1.0 si traité, 0.7-0.9 si maladie non traitée)
    treatment_factor = 1.0
    if plot.has_disease and !plot.treated:
        treatment_factor = 0.7 + random(0.0, 0.2)

    // Facteur météo — jauges eau et soleil (0.5 à 1.0)
    // Vert = 1.0, Rouge = 0.5-0.7
    water_factor = plot.water_gauge_factor    // 0.5 à 1.0
    sun_factor = plot.sun_gauge_factor        // 0.5 à 1.0
    weather_factor = (water_factor + sun_factor) / 2.0

    // Facteur irrigation (améliore water_factor si irrigation active)
    irrigation_factor = 1.0
    if plot.irrigated:
        irrigation_factor = min(1.0, water_factor + 0.2) / water_factor

    // Bonus rouleau (+3% à +5% pour céréales et herbe)
    roller_bonus = 1.0
    if plot.rolled and plot.crop.is_cereal_or_grass:
        roller_bonus = 1.03 + random(0.0, 0.02)  // 1.03 à 1.05

    // Malus pierres (jusqu'à -5%)
    stone_malus = 1.0
    if plot.has_stones:
        stone_malus = 0.95

    // Bonus haie (amélioration rendement si haie présente)
    hedge_bonus = 1.0
    if plot.has_hedge:
        hedge_bonus = 1.03  // ~+3%

    // Bonus maturation (100% = optimal, <100% = proportionnel)
    maturity_factor = plot.growth_percent / 100.0

    yield = base
          * soil_quality_factor
          * nutrient_factor
          * fertilizer_factor
          * treatment_factor
          * weather_factor
          * irrigation_factor
          * roller_bonus
          * stone_malus
          * hedge_bonus
          * maturity_factor

    return yield  // T/ha
```

### 3.4 Qualité de récolte

```
enum CropQuality { BAD = 1, AVERAGE = 2, GOOD = 3 }

function determineCropQuality(plot: Plot) -> CropQuality:
    // Principalement déterminée par la qualité du sol
    score = 0
    if plot.soil_quality == GOOD: score += 2
    elif plot.soil_quality == AVERAGE: score += 1

    if plot.treated: score += 1
    if plot.weather_factor > 0.8: score += 1

    if score >= 3: return GOOD
    if score >= 1: return AVERAGE
    return BAD
```

### 3.5 Rotation des cultures

```
// Chaque culture a une durée de rotation minimale (en années Cultivia)
ROTATION = {
    BLE: 1, ORGE: 1, AVOINE: 1, TRITICALE: 1,
    ORGE_PRINTEMPS: 2, AVOINE_PRINTEMPS: 2,
    MAIS_GRAIN: 2, MAIS_ENSILE: 2, SORGHO: 2, FEVEROLE: 2,
    COLZA: 2, LENTILLE: 2,
    TOURNESOL: 3, POIS: 3, SOJA: 3, EPINARD: 3, TABAC: 3,
    BETTERAVE: 4, PDT: 4,
    HARICOT_VERT: 5,
    LIN: 6,
    CHANVRE: 0,  // pas de rotation
}

// En BIO : rotation += 1 an
function getRotation(crop: Crop, is_bio: bool) -> int:
    rot = ROTATION[crop]
    if is_bio: rot += 1
    return rot

// Vérification : la même culture ne peut pas être semée sur la même parcelle
// avant que `rotation` années Cultivia se soient écoulées
function canSow(plot: Plot, crop: Crop, is_bio: bool) -> bool:
    required_gap = getRotation(crop, is_bio)
    last_sow_year = plot.last_sow_year[crop]
    return (current_sim_year - last_sow_year) >= required_gap
```

### 3.6 Système BIO

```
BIO_CONVERSION_DURATION = 2  // saisons Cultivia (168 jours)
BIO_PRICE_BONUS         = 1.20  // +20% sur le cours conventionnel
BIO_PARCEL_PREMIUM      = 1.50  // +50% prix achat parcelle BIO

// Règles BIO :
// - Pas de traitements phytosanitaires
// - Pas d'engrais chimiques (fumier/lisier/compost autorisés)
// - Rotation +1 an
// - Cultures exclues : chanvre, lin, coton, tabac, miscanthus
// - Pendant conversion (2 saisons) : mode BIO mais pas de label
```

### 3.7 Céréale immature

```
// Cultures éligibles : blé, orge, avoine, triticale, seigle
// Récolte entre 60% et 80% de pousse, au plus tard le 7 mai
// Récolte par ensileuse → silo taupe
// Rendement = 150% du rendement grain de base

function immatureCerealYield(base_grain_yield: float, growth_pct: float) -> float:
    if growth_pct < 60 or growth_pct > 80: return 0  // hors fenêtre
    return base_grain_yield * 1.50 * (growth_pct / 100.0)
```

### 3.8 Techniques culturales

```
enum TechCulturale { TRADITIONNELLE, TCS, SEMIS_DIRECT }

TECH_YIELD_FACTOR = {
    TRADITIONNELLE: 1.00,   // rendement optimal
    TCS:            0.95,   // bon/moyen
    SEMIS_DIRECT:   0.85,   // moyen/faible
}

TECH_HT_FACTOR = {
    TRADITIONNELLE: 1.00,   // coût élevé (charrue + herse + semoir)
    TCS:            0.75,   // coût modéré
    SEMIS_DIRECT:   0.50,   // coût faible (semoir direct uniquement)
}

// Semis direct : impossible pour maïs grain, maïs ensilé, PDT
// Semis direct : 3 traitements phyto supplémentaires nécessaires
```

---

## 4. SYSTÈME DE TRANSPORT

### 4.1 Principe
Toute action physique (achat/vente animaux, aliments, récolte, déplacement au pré) consomme du carburant HVC, applique de l'usure véhicule, et peut déclencher une panne.

### 4.2 Formules
```
function calculateTransport(origin_pref, dest_pref, type):
    distance_km = haversine(origin_pref.lat, origin_pref.lng, dest_pref.lat, dest_pref.lng)
    
    TRANSPORT_RATES = {
        animal:      { cost_km: 0.50, hvc_km: 0.15, ht_per_100km: 1.0, speed: 50 },
        merchandise: { cost_km: 0.30, hvc_km: 0.20, ht_per_100km: 1.0, speed: 50 },
        milk:        { cost_km: 0.30, hvc_km: 0.20, ht_per_100km: 1.0, speed: 50 },
        dealer:      { cost_km: 0.80, hvc_km: 0,    ht_per_100km: 0,   speed: 60 },
    }
    
    rate = TRANSPORT_RATES[type]
    return {
        cost: distance_km × rate.cost_km,
        hvc:  distance_km × rate.hvc_km,
        ht:   0.5 + distance_km / 100 × rate.ht_per_100km,
        delay_hours: distance_km / rate.speed,
        wear: distance_km × 0.02
    }
```

### 4.3 Délai de transit
Les biens achetés ne sont pas instantanément disponibles. Ils transitent via la table `delivery` (marchandises), `animal.status='in_transit'` (animaux), ou `vehicle.status='in_delivery'` (matériel). Trois ticks worker (F048, F049, F050) vérifient les arrivées.

---

## 5. SYSTÈME DE LIVRAISON

### 5.1 Statuts
```
enum DeliveryStatus { IN_TRANSIT, DELIVERED }
enum AnimalStatus { AVAILABLE, IN_TRANSIT }
enum VehicleStatus { AVAILABLE, IN_DELIVERY }
```

### 5.2 Ticks d'arrivée (worker step 2)
Chaque tick quotidien vérifie :
- `animal WHERE status='in_transit' AND arrival_at <= NOW()` → status='available'
- `vehicle WHERE status='in_delivery' AND arrival_at <= NOW()` → status='available'
- `delivery WHERE status='in_transit' AND arrival_at <= NOW()` → transfert vers inventory

---

## 6. SYSTÈME D'USURE & PANNES

### 6.1 Usure véhicule
```
function applyWear(vehicle, usage_type, value):
    if usage_type == 'transport': wear_delta = value × 0.02  // value = km
    if usage_type == 'field_work': wear_delta = value × 0.5  // value = ha
    vehicle.wear_pct = min(100, vehicle.wear_pct + wear_delta)
    
    // Jet de panne
    if vehicle.wear_pct > 80:
        if random() < 0.15:
            vehicle.is_broken = true
```

### 6.2 Entretien
```
MONTHLY_MAINTENANCE = { ht: 1.0, cost: 0,   wear_reduction: 5  }
ANNUAL_MAINTENANCE  = { ht: 2.0, cost: 500, wear_reduction: 15 }
```

### 6.3 Usure bâtiment
+0.5%/mois (tick F067). Pas de panne bâtiment.

---

## 7. SYSTÈME D'ASSURANCE MATÉRIEL

### 7.1 Souscription (F062)
```
premium = argus × 0.03  // 3% de l'argus annuel
argus = prix_neuf × (1 - wear_pct/100) × 0.85 × 0.60
```

### 7.2 Expiration (F063)
Tick worker vérifie `vehicle_insurance WHERE expires_at <= NOW()` → status='expired' + notification.

---

## 8. SYSTÈME D'IRRIGATION

### 8.1 Forage (F057)
```
function drill(parcel):
    source_level = random(0, 10)  // 0 = pas de source
    parcel.source_level = source_level
    cost = 150€, ht = 0.5
```

### 8.2 Irrigation (F058)
```
function irrigate(parcel, hours):
    water_available = parcel.source_level × 100000  // L/jour
    water_needed = hours × 10000 × parcel.area_ha   // 10m³/ha/h
    parcel.rain_gauge = min(100, rain_gauge + hours)
    // Requires: enrouleur + tractor + HVC
```

---

## 9. SYSTÈME DE COMPOSTAGE

### 9.1 Processus (F078)
```
function compost(quantity_tonnes):
    // 3T fumier → 1T compost, durée 14 jours
    result = quantity_tonnes / 3
    INSERT compost_batch(quantity_in=qty, quantity_out=result, ready_at=NOW()+14d)
```

### 9.2 Tick compostage
Dans le tick quotidien (étape 13), vérifier `compost_batch WHERE ready_at <= NOW()` → status='ready', transférer vers inventory.

---

## 10. SYSTÈME DE PIÈCES DÉTACHÉES

### 10.1 Usure pièces (F061)
```
function pieceCost(vehicle, piece_num):
    age_years = (NOW() - vehicle.bought_at) / (84 days)  // 84j = 1 an Cultivia
    return base_piece_cost × (1 + age_years × 0.02)
```

Chaque véhicule a 1-5 pièces (selon `vehicle_type.piece_count`). Les pièces s'usent indépendamment.

---

## 11. SYSTÈME DE NÉGOCIANT EN BESTIAUX

### 11.1 Appel (F071)
```
function callNegociant(player):
    // 1 appel max par mois Cultivia (7 jours réels)
    CHECK last_call_at IS NULL OR last_call_at + 7d < NOW()
    // Génère 4 offres aléatoires
    offers = generateOffers(player.species_preference, count=4)
    // Prix = cours marché × 1.20 (+20%)
    // Animaux adultes, génétique moyenne
    // Restriction : negociant_origin=true → non revendable entre joueurs
```

### 11.2 Achat (F071)
```
function buyFromNegociant(player, offer_id, building_id):
    CHECK building has space
    CHECK balance >= offer.price
    // Pas de transport joueur — le négociant livre
    INSERT animal (negociant_origin=true, sell_to_player_locked=true)
```

---

## 12. SYSTÈME D'AMÉLIORATION / DESTRUCTION BÂTIMENTS

### 12.1 Amélioration (F069)
```
function upgradeBuilding(building):
    CHECK building.level < 5
    CHECK building is empty (no animals, no stock)
    cost = base_cost_per_unit × size × 0.50
    building.level += 1
    // Réduit la consommation énergie mensuelle
    building.energy_monthly = recalculate(level)
```

### 12.2 Destruction (F070)
```
function destroyBuilding(building):
    CHECK building is empty
    recovery = total_invested × 0.10  // 10% récupéré
    DELETE building
    player.balance += recovery
```

---

## 13. SYSTÈME DE REMBOURSEMENT ANTICIPÉ

### 13.1 Prêt (F079)
```
function earlyRepayLoan(loan):
    penalty = loan.remaining × 0.03  // 3% pénalité
    total = loan.remaining + penalty
    CHECK player.balance >= total
    player.balance -= total
    loan.status = 'repaid_early'
    loan.closed_at = NOW()
```

### 13.2 Épargne (F065)
```
function earlyCloseSavings(savings):
    // Clôture anticipée : capital restitué, 0€ intérêts
    player.balance += savings.amount  // capital seul
    savings.status = 'closed_early'
    savings.closed_at = NOW()
```