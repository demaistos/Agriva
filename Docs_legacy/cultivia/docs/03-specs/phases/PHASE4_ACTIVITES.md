# PHASE 4 — ACTIVITÉS SECONDAIRES — Spécifications Techniques

> **Cultivia Clone — Specs détaillées Phase 4**
> Chaque feature est spécifiée pour être codée sans ambiguïté.
> Référence : 01_DATA_MODEL.md, 03_CONTENT_DATA.md, GDD/03_ELEVAGE.md, GDD/01_ECONOMIE.md
> Dépendance : Phases 0-3 (infrastructure, cultures, élevage bovin de base, économie)

---

## Table des matières

1. [Feature 1 — Espèces supplémentaires (caprins, ovins, porcins, volailles)](#feature-1--espèces-supplémentaires)
2. [Feature 2 — Lapins, pintades, oies, canards](#feature-2--lapins-pintades-oies-canards)
3. [Feature 3 — Concessionnaire joueur](#feature-3--concessionnaire-joueur)
4. [Feature 4 — Atelier concessionnaire](#feature-4--atelier-concessionnaire)
5. [Feature 5 — Pannes & pièces détachées](#feature-5--pannes--pièces-détachées)
6. [Feature 6 — GPS](#feature-6--gps)
7. [Feature 7 — CIA (Centre d'Insémination Artificielle)](#feature-7--cia)
8. [Feature 8 — Génétique complète](#feature-8--génétique-complète)
9. [Feature 9 — Fromagerie artisanale](#feature-9--fromagerie-artisanale)
10. [Feature 10 — Fromagerie industrielle](#feature-10--fromagerie-industrielle)
11. [Feature 11 — Marchés](#feature-11--marchés)
12. [Feature 12 — Huilerie CAR](#feature-12--huilerie-car)
13. [Feature 13 — Sucrerie CAR](#feature-13--sucrerie-car)
14. [Feature 14 — Laiterie CAR](#feature-14--laiterie-car)
15. [Feature 15 — Culture BIO](#feature-15--culture-bio)
16. [Feature 16 — Élevage BIO](#feature-16--élevage-bio)
17. [Annexe A — Daily Tick Phase 4](#annexe-a--daily-tick-phase-4)
18. [Annexe B — Constantes Phase 4](#annexe-b--constantes-phase-4)

---

## Feature 1 — Espèces supplémentaires

### 1.1 Description

Ajout de 4 espèces avec toutes leurs races, rations, reproduction, productions et bâtiments dédiés. Les tables `animal_species`, `animal_breed` et `animal_ration` (Phase 3) sont peuplées avec les données ci-dessous. Chaque espèce a son bâtiment dédié (chèvrerie, bergerie, porcherie, poulailler) et ses règles de pâturage.

**Espèces et races :**
- Caprins (12 races) : Alpine, Angora, Corse, Poitevine, Rove, Saanen, Nera Verzasca (CH), Toggenburg (CH), Spanish (US), + 3 races IVRAD
- Ovins (16 races) : 3 laitières (Lacaune Lait, Manech Noire, Manech Rousse) + 11 allaitantes (Île de France, Charollais, Texel, Engadine, Suffolk, Rouge de l'Ouest, Blanche du Massif Central, Mérinos d'Arles, Causses du Lot, Charmoise, Berrichon du Cher) + 2 IVRAD
- Porcins (8 races) : Large White, Landrace Français, Piétrain, Penshire, Duroc, Hereford + 2 IVRAD
- Volailles (6 races) : Charollaise, Gauloise, Coucou des Flandres, Meusienne, Bourbourg, Suisse (CH)

### 1.2 Schéma BDD

Les tables `animal_species`, `animal_breed`, `animal_ration` existent déjà (Phase 3). On insère les données de référence.

```sql
-- Seed caprins species
INSERT INTO animal_species (name, housing_type, gestation_months, max_insem_per_day,
  slaughter_yield_min, slaughter_yield_max, lifespan_years,
  pasture_start_month, pasture_end_month, bio_eligible)
VALUES
  ('goat', 'goatery', 5, 2, 0.45, 0.50, 8, 4, 10, true),
  ('sheep', 'sheepfold', 5, 2, 0.45, 0.50, 8, 4, 10, true),
  ('pig', 'pigsty', 4, 3, 0.72, 0.80, 4, 4, 10, true),
  ('poultry', 'henhouse', 1, 5, 0.60, 0.65, 8, NULL, NULL, true);

-- Seed caprin breeds (12 races)
INSERT INTO animal_breed (species_id, name, category, birth_weight_kg,
  adult_weight_f, adult_weight_m, milk_per_day, wool_per_shear,
  offspring_min, offspring_max, genetic_indices)
VALUES
  -- Alpine
  ((SELECT id FROM animal_species WHERE name='goat'), 'Alpine', 'dairy',
   2.2, 60, 80, 2.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Angora
  ((SELECT id FROM animal_species WHERE name='goat'), 'Angora', 'fiber',
   2.0, 30, 45, 2.4, 2.0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality","wool"]'),
  -- Corse
  ((SELECT id FROM animal_species WHERE name='goat'), 'Corse', 'dairy',
   2.1, 40, 55, 2.4, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Poitevine
  ((SELECT id FROM animal_species WHERE name='goat'), 'Poitevine', 'dairy',
   2.2, 65, 85, 2.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Rove
  ((SELECT id FROM animal_species WHERE name='goat'), 'Rove', 'dairy',
   2.3, 65, 85, 2.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Saanen
  ((SELECT id FROM animal_species WHERE name='goat'), 'Saanen', 'dairy',
   2.4, 70, 90, 2.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Nera Verzasca (Suisse)
  ((SELECT id FROM animal_species WHERE name='goat'), 'Nera Verzasca', 'dairy',
   2.2, 50, 65, 1.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]'),
  -- Toggenburg (Suisse)
  ((SELECT id FROM animal_species WHERE name='goat'), 'Toggenburg', 'fiber',
   2.0, 55, 70, 2.7, 2.0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality","wool"]'),
  -- Spanish (USA)
  ((SELECT id FROM animal_species WHERE name='goat'), 'Spanish', 'dairy',
   2.4, 70, 90, 2.7, 0, 2, 2,
   '["growth","prolificacy","general_appearance","milk","milk_quality"]');
-- + 3 races IVRAD (Porc Gascon, Col Noir du Valais, etc.) insérées avec is_ivrad=true

-- Seed ovin breeds (16 races) — même pattern
-- Laitières : Lacaune Lait (75kg, lait 3L/j), Manech Noire (50kg, 1.5L/j, laine 2kg),
--             Manech Rousse (45kg, 1L/j, laine 2kg)
-- Allaitantes : Île de France (80kg, laine 4kg, 2 agneaux), Charollais (90kg, 0 laine, 2),
--               Texel (90kg, 3kg, 2), Engadine CH (70kg, 4kg, 2), Suffolk (80kg, 0, 2),
--               Rouge de l'Ouest (75kg, 3kg, 2), Blanche MC (65kg, 1kg, 2),
--               Mérinos d'Arles (55kg, 5.5kg, 1-2), Causses du Lot (60kg, 2kg, 1-2),
--               Charmoise (70kg, 0, 1-2), Berrichon du Cher (70kg, 3kg, 1-2)
-- + 2 IVRAD (Blackface, etc.)

-- Seed porcin breeds (8 races)
-- Large White (240kg), Landrace Français (230kg), Piétrain (220kg),
-- Penshire (220kg), Duroc (240kg), Hereford (240kg) + 2 IVRAD
-- Tous : birth_weight=1.5kg, offspring 6-9, gestation 4 mois

-- Seed volaille breeds (6 races)
-- Charollaise (2.5/2.9kg, 3-5 œufs/j), Gauloise (2.5/2.9, 3-5),
-- Coucou des Flandres (2.5/2.9, 3-5), Meusienne (3.9/4.5, 1),
-- Bourbourg (2.75/3.2, 2), Suisse CH (2.4/2.8, 2)
-- Tous : birth_weight=0.05kg, offspring 6-10

-- Seed rations caprins (toutes tranches d'âge)
-- Boucs/chèvres >12 mois : 7 rations de base + compléments (orge 1.6, blé 1.6, min 0.08, eau 20L)
INSERT INTO animal_ration (species_id, age_group, ration_name, components, water_l, total_kg)
VALUES
  ((SELECT id FROM animal_species WHERE name='goat'), 'adult',
   'Maïs ensilé + foin',
   '{"corn_silage":16,"hay":1.2,"barley":1.6,"wheat":1.6,"minerals":0.08}',
   20, 21),
  ((SELECT id FROM animal_species WHERE name='goat'), 'adult',
   'Betterave + foin',
   '{"beet":14,"hay":2,"barley":1.6,"wheat":1.6,"minerals":0.08}',
   20, 19),
  ((SELECT id FROM animal_species WHERE name='goat'), 'adult',
   'Foin seul',
   '{"hay":16,"barley":1.6,"wheat":1.6,"minerals":0.08}',
   20, 19),
  ((SELECT id FROM animal_species WHERE name='goat'), 'adult',
   'Foin + maïs + ensilage herbe',
   '{"hay":1.2,"corn_silage":10,"grass_silage":6,"barley":1.6,"wheat":1.6,"minerals":0.08}',
   20, 20.48),
  ((SELECT id FROM animal_species WHERE name='goat'), 'adult',
   'Sorgho + foin',
   '{"sorghum_silage":16,"hay":1.2,"barley":1.6,"wheat":1.6,"minerals":0.08}',
   20, 21);
-- Jeunes 6-12 mois : compléments (1.4, 1.4, 0.04, eau 12L)
-- Chevreaux 3-6 mois : compléments (1.2, 1.2, 0.04, eau 8L)
-- Chevreaux 0-3 mois : foin 2.8 + orge 1 + blé 1 + min 0.04, eau 4L

-- Seed rations ovins (bergerie + hivernale pré)
-- Béliers/brebis >12 mois : 8 rations base + compléments (orge/blé 1.6, tourteau 1.2, min 0.14, eau 20L)
-- Jeunes 6-12 mois : compléments (1.4, 0.8, 0.08, eau 12L)
-- Agneaux 3-6 mois : compléments (1.2, 0.6, 0.04, eau 8L)
-- Agneaux 0-3 mois : orge/blé 1 + tourteau 0.4 + min 0.04, eau 4L
-- Ration hivernale pré (allaitantes) : foin 4 + orge/blé 1.6 + tourteau 0.6 + min 0.1, eau 20L

-- Seed rations porcins (porcherie)
-- Verrats/truies >12 mois : orge 8 + blé 2 + avoine 2 + tourteau 0.8 + min 0.8, eau 68L, RC=14
-- Jeunes 6-12 mois : orge 6 + blé 1.6 + avoine 1.6 + tourteau 1.4 + min 1.4, eau 48L, RC=10
-- Jeunes 3-6 mois : orge 0.8 + blé 2 + maïs 3.2 + tourteau 1.6 + min 0.4, eau 24L, RC=8
-- Porcelets 1-3 mois : blé 1 + avoine 0.6 + maïs 1.2 + tourteau 1 + min 0.2, eau 12L, RC=4
-- Porcelets 0-1 mois : concentré 0.4, eau 2L

-- Seed rations volailles (poulailler)
-- Coqs/poules >6 mois : blé 0.055 + maïs 0.02 + avoine 0.02 + min 0.005, eau 1L, RC=0.1
-- Jeunes 1-6 mois : blé 0.04 + maïs 0.015 + avoine 0.015 + min 0.003, eau 0.6L, RC=0.075
-- Poussins 0-1 mois : blé 0.03 + maïs 0.01 + avoine 0.01 + min 0.002, eau 0.2L, RC=0.055
```

### 1.3 Logique métier

**Caprins :**
- Bâtiment : chèvrerie. Surfaces : bouc 7m², chèvre 5m², jeune 4m², chevreau 2m²
- Pâturage avril→octobre. Herbe/jour : bouc 68m², chèvre 60m², jeune 52m², chevreau 40m²
- Reproduction : maturité 12 mois, gestation 5 mois, 2 chevreaux, délai 6 mois post-mise-bas, max 2 insém/jour
- Lait : 1.7-2.7 L/jour selon race, traite 4×/jour. Prix QL 550-640 €/1000L
- Laine Mohair (Angora, Toggenburg) : 2 kg/tonte, 2 tontes/an, ~16 €/kg
- Litière : bouc 20kg, chèvre 15kg, jeune 10kg, chevreau 5kg paille/jour

**Ovins :**
- Bâtiment : bergerie. Surfaces : bélier 7m², brebis 5m², jeune 4m², agneau 2m²
- Pâturage avril→octobre (laitières), toute l'année (allaitantes, ration hivernale nov→mars)
- Herbe/jour : bélier 68m², brebis 60m², jeune 52m², agneau 40m²
- Reproduction : maturité 12 mois, gestation 5 mois, 1-2 agneaux, délai 7 mois, max 2 insém/jour
- Lait (races laitières) : 1-3 L/jour, traite 4×/jour. Prix QL 850-940 €/1000L
- Laine : 0-5.5 kg/tonte selon race, ~0.45 €/kg
- Allaitement possible (toutes races) : +0.30 €/kg vente 2e-3e mois, max 3 mois
- Litière : bélier 20kg, brebis 15kg, jeune 10kg, agneau 5kg paille/jour

**Porcins :**
- Bâtiment : porcherie. Surfaces : verrat 5m², truie 4m², jeune 2m², porcelet 0.5m²
- Modes : litière (paille→fumier) ou caillebotis (lisier). Plein-air avril→octobre (abris, 5 porcs/abri)
- Reproduction : maturité 12 mois, gestation 4 mois, 6-9 porcelets, délai 1 mois, max 3 insém/jour
- Lisier (caillebotis) : verrat 50L, truie 50L, jeune 30L, porcelet 5L/jour
- Litière : verrat 15kg, truie 10kg, jeune 5kg, porcelet 5kg paille/jour
- Rendement carcasse : 72-80%

**Volailles :**
- Bâtiment : poulailler. Surfaces : 0.1m² adulte, 0.07m² jeune, 0.01m² poussin
- Modes : intensif (poulailler seul) ou semi-liberté (poulailler + parc 10m²/animal)
- Reproduction : maturité 6 mois, gestation 1 mois, 6-10 poussins, délai 5 jours, max 5 insém/jour
- Œufs : 1-5/jour selon race, calibrage S/M/L/XL selon âge (6m-1an=XL, 6-8ans=S)
- Litière : adulte 0.5kg, jeune 0.3kg, poussin 0.1kg paille/jour

```
Algorithme nourrissage (toutes espèces) :
1. Vérifier animal.last_fed_at < aujourd'hui
2. Vérifier stock aliments suffisant (inventory)
3. Déduire composants ration de l'inventaire
4. Déduire eau de la cuve
5. Mettre à jour animal.last_fed_at = now()
6. Si non nourri : animal.days_unfed += 1
7. Si days_unfed >= 3 : animal.is_sick = true
8. Si days_unfed >= 7 : animal meurt (DELETE)
```

### 1.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| GET | `/api/animals?species=goat` | Lister caprins (paginé) | 0 |
| GET | `/api/animals?species=sheep` | Lister ovins | 0 |
| GET | `/api/animals?species=pig` | Lister porcins | 0 |
| GET | `/api/animals?species=poultry` | Lister volailles | 0 |
| POST | `/api/animals/buy` | Acheter animal (body: species, breed_id, sex, count) | 1 |
| POST | `/api/animals/:id/feed` | Nourrir (body: ration_id) | 0.5-2 selon espèce |
| POST | `/api/animals/:id/milk` | Traire caprin/ovin | 0.5 |
| POST | `/api/animals/:id/shear` | Tondre (laine/mohair) | 0.25 |
| POST | `/api/animals/:id/collect-eggs` | Ramasser œufs volailles | 0.25 |
| POST | `/api/animals/:id/inseminate` | Inséminer | 1 |
| POST | `/api/animals/:id/sell` | Vendre abattoir/joueur | 0.5 |
| POST | `/api/animals/:id/pasture` | Mettre au pré | 0.5 |
| POST | `/api/animals/:id/shelter` | Rentrer en bâtiment | 0.5 |
| POST | `/api/animals/batch/feed` | Nourrir lot (body: building_id, ration_id) | variable |

### 1.5 Tests

```
T1.1 — Achat caprin Alpine à la coop → animal créé, breed_id correct, solde débité
T1.2 — Nourrir chèvre ration "Maïs ensilé + foin" → stock déduit (16kg maïs, 1.2kg foin, 1.6kg orge, 1.6kg blé, 0.08kg min, 20L eau), last_fed_at mis à jour
T1.3 — Traire chèvre Saanen adulte → 2.7L lait ajoutés à cuve, qualité QL calculée
T1.4 — Tondre Angora → 2kg mohair ajoutés à pièce stockage laine
T1.5 — Inséminer chèvre à 12 mois → pregnant_until = now + 5 mois
T1.6 — Inséminer chèvre à 10 mois → ERREUR 400 "Maturité sexuelle non atteinte"
T1.7 — Inséminer chèvre déjà gestante → ERREUR 400
T1.8 — Mise bas caprin → 2 chevreaux créés, sexe aléatoire, poids 2.2kg
T1.9 — Achat ovin Lacaune Lait → animal créé, lait 3L/jour
T1.10 — Nourrir brebis ration bergerie → stock déduit correctement
T1.11 — Traire brebis Lacaune → 3L lait, prix 850-940€/1000L selon QL
T1.12 — Tondre Mérinos d'Arles → 5.5kg laine
T1.13 — Allaitement ovin : activer → nursing=true, pas de traite possible, +0.30€/kg vente
T1.14 — Porcin : nourrir verrat ration porcherie → 14kg déduits
T1.15 — Porcin : mise bas truie → 6-9 porcelets (aléatoire borné par indices prolificité)
T1.16 — Porcin plein-air : mettre au parc → vérifier abri disponible (5 porcs/abri)
T1.17 — Volaille : ramasser œufs poule Charollaise 8 mois → 3-5 œufs calibre XL
T1.18 — Volaille : ramasser œufs poule 5 ans → calibre M
T1.19 — Volaille semi-liberté : vérifier parc 10m²/animal
T1.20 — Animal non nourri 3 jours → is_sick=true
T1.21 — Animal non nourri 7 jours → animal supprimé
T1.22 — Vente abattoir porcin 240kg → carcasse 72-80%, prix calculé
T1.23 — Pâturage caprin hors avril-octobre → ERREUR 400
T1.24 — Ovin allaitant au pré en hiver → ration hivernale requise
```

---

## Feature 2 — Lapins, pintades, oies, canards

### 2.1 Description

Ajout de 4 espèces avec reproduction saisonnière spécifique. Les pintades se reproduisent en mars uniquement (6 cycles mars→août), les oies en janvier-février (3 cycles mars→juin), les canards en avril uniquement. Lapins : reproduction toute l'année, très prolifiques.

**Races :**
- Lapins (12 races) : Argenté de Champagne, Fauve de Bourgogne, Néo Zélandais Blanc, Bleu de Vienne, Chamois de Thuringe, Lièvre Belge, Angora, Alaska, Rex Castor, Rex Blanc, Rex Dalmatien, Rex Bleu
- Pintades (1 race) : Pintade grise
- Oies (8 races) : Blanche du Bourbonnais, Blanche du Poitou, Normande, de Guinée, Flamande (BE), d'Alsace (foie gras), de Toulouse (foie gras), Grise des Landes (foie gras)
- Canards (6 races) : Rouen Clair, Duclair, Pékin Allemand, Pékin Américain (US), Bourbourg, Barbarie (foie gras)

### 2.2 Schéma BDD

```sql
-- Seed espèces
INSERT INTO animal_species (name, housing_type, gestation_months, max_insem_per_day,
  slaughter_yield_min, slaughter_yield_max, lifespan_years,
  pasture_start_month, pasture_end_month, bio_eligible)
VALUES
  ('rabbit', 'hutch', 1, 5, 0.55, 0.63, 6, NULL, NULL, true),
  ('guinea_fowl', 'henhouse', 1, 5, 0.60, 0.65, 8, NULL, NULL, true),
  ('goose', 'henhouse', 0, 4, 0.60, 0.65, 10, NULL, NULL, true),
  ('duck', 'henhouse', 0, 8, 0.60, 0.65, 8, NULL, NULL, true);

-- Seed lapin breeds (12 races)
-- Tous : birth_weight=0.05kg, lifespan 5-6 ans, clapier uniquement
-- Angora : wool_per_shear=0.3, 3 tontes/an, ~20€/kg
INSERT INTO animal_breed (species_id, name, category, birth_weight_kg,
  adult_weight_f, adult_weight_m, wool_per_shear, offspring_min, offspring_max,
  genetic_indices)
VALUES
  ((SELECT id FROM animal_species WHERE name='rabbit'), 'Argenté de Champagne', 'meat',
   0.05, 4.5, 5.0, 0, 6, 7,
   '["growth","prolificacy","general_appearance"]'),
  ((SELECT id FROM animal_species WHERE name='rabbit'), 'Angora', 'fiber',
   0.05, 4.1, 4.5, 0.3, 6, 7,
   '["growth","prolificacy","general_appearance","wool"]');
-- ... (10 autres races même pattern, poids 3.7-4.5kg)

-- Seed pintade breed (1 race)
INSERT INTO animal_breed (species_id, name, category, birth_weight_kg,
  adult_weight_f, adult_weight_m, eggs_per_day, offspring_min, offspring_max,
  genetic_indices)
VALUES
  ((SELECT id FROM animal_species WHERE name='guinea_fowl'), 'Pintade grise', 'meat',
   0.05, 2.5, 2.5, 0, 8, 15,
   '["growth","prolificacy","general_appearance","egg","hatching"]');

-- Seed oie breeds (8 races)
-- Chair : Bourbonnais (7kg), Poitou (6kg), Normande (4kg), Guinée (4kg), Flamande BE (4kg)
-- Foie gras : Alsace (4kg), Toulouse (8kg), Grise des Landes (6kg)
INSERT INTO animal_breed (species_id, name, category, birth_weight_kg,
  adult_weight_f, adult_weight_m, offspring_min, offspring_max,
  genetic_indices)
VALUES
  ((SELECT id FROM animal_species WHERE name='goose'), 'Oie de Toulouse', 'foie_gras',
   0.05, 8, 10, 4, 10,
   '["growth","prolificacy","general_appearance","hatching","fertility","down"]'),
  ((SELECT id FROM animal_species WHERE name='goose'), 'Oie Blanche du Bourbonnais', 'meat',
   0.05, 7, 9, 4, 10,
   '["growth","prolificacy","general_appearance","hatching","fertility","down"]');
-- ... (6 autres races)

-- Seed canard breeds (6 races)
-- Chair : Rouen Clair (3kg), Duclair (2.5kg), Pékin Allemand (3kg),
--         Pékin Américain US (3kg), Bourbourg (3kg)
-- Foie gras : Barbarie (4kg)
-- Tous : eggs_per_day 0-4 (ponte jan→sept hors couvaison)
INSERT INTO animal_breed (species_id, name, category, birth_weight_kg,
  adult_weight_f, adult_weight_m, eggs_per_day, offspring_min, offspring_max,
  genetic_indices)
VALUES
  ((SELECT id FROM animal_species WHERE name='duck'), 'Canard de Barbarie', 'foie_gras',
   0.05, 4, 5, 4, 3, 12,
   '["growth","prolificacy","general_appearance","egg","hatching","down"]');
-- ... (5 autres races)

-- Rations lapins (clapier)
INSERT INTO animal_ration (species_id, age_group, ration_name, components, water_l, total_kg)
VALUES
  ((SELECT id FROM animal_species WHERE name='rabbit'), 'adult',
   'Ration standard',
   '{"hay":0.8,"wheat":0.16,"barley":0.16,"peas":0.16,"oats":0.16,"beet":0.18,"sunflower_meal":0.18}',
   1.2, 1.8),
  ((SELECT id FROM animal_species WHERE name='rabbit'), '1-3m',
   'Ration jeune',
   '{"hay":0.54,"wheat":0.104,"barley":0.104,"peas":0.104,"oats":0.104,"beet":0.12,"sunflower_meal":0.12}',
   1.2, 1.2),
  ((SELECT id FROM animal_species WHERE name='rabbit'), '0-1m',
   'Concentré lapereau',
   '{"concentrate_rabbit":0.04}',
   0.4, 0.04);

-- Rations pintades (poulailler) — identiques volailles
-- Adultes >9 mois : blé 0.055, maïs 0.02, avoine 0.02, min 0.005, eau 1L, RC=0.1
-- Jeunes 1-9 mois : blé 0.05, maïs 0.015, avoine 0.015, min 0.003, eau 0.6L, RC=0.091
-- Pintadeaux 0-1 mois : blé 0.03, maïs 0.01, avoine 0.01, min 0.002, eau 0.2L, RC=0.055

-- Rations oies
-- Jars/oies >6 mois : blé 0.220, maïs 0.08, avoine 0.08, min 0.002, eau 4L, RC=0.382
-- Jeunes 3-6 mois : blé 0.160, maïs 0.06, avoine 0.06, min 0.012, eau 2.4L, RC=0.287
-- Oisons 0-3 mois : blé 0.12, maïs 0.04, avoine 0.04, min 0.008, eau 0.8L, RC=0.210

-- Rations canards
-- Adultes >6 mois : maïs 0.110, blé 0.040, tourteau 0.040, min 0.01, eau 4L, RC=0.191
-- Jeunes 3-6 mois : maïs 0.080, blé 0.030, tourteau 0.030, min 0.006, eau 3L, RC=0.143
-- Canetons 0-3 mois : maïs 0.500, blé 0.200, tourteau 0.200, min 0.100, eau 2L, RC=0.955

-- Table reproduction saisonnière (contrôle des périodes)
CREATE TABLE breeding_season (
  id          SERIAL PRIMARY KEY,
  species_id  INT NOT NULL REFERENCES animal_species(id),
  start_month SMALLINT NOT NULL CHECK (start_month BETWEEN 1 AND 12),
  end_month   SMALLINT NOT NULL CHECK (end_month BETWEEN 1 AND 12),
  cycles      SMALLINT, -- nombre de cycles de ponte/couvaison
  incubation_days SMALLINT, -- durée ponte/couvaison en jours Cultivia
  UNIQUE(species_id)
);

INSERT INTO breeding_season (species_id, start_month, end_month, cycles, incubation_days)
VALUES
  ((SELECT id FROM animal_species WHERE name='guinea_fowl'), 3, 3, 6, 7),  -- mars, 6 cycles×1 mois
  ((SELECT id FROM animal_species WHERE name='goose'), 1, 2, 3, 9),        -- jan-fév, 3 cycles, 9j couvaison
  ((SELECT id FROM animal_species WHERE name='duck'), 4, 4, 1, 7);         -- avril, 7j (domestique) ou 9j (Barbarie)
-- Lapins : pas d'entrée = reproduction toute l'année
```

### 2.3 Logique métier

**Lapins :**
- Clapier uniquement (jamais dehors). Surfaces : adulte 1m², jeune 0.5m², lapereau 0.2m²
- Reproduction : maturité 3 mois, gestation 1 mois, 6-7 lapereaux, délai 1 mois, max 5 insém/jour
- Laine Angora : 0.3 kg/tonte, 3 tontes/an, ~20 €/kg
- Litière : adulte 2kg, jeune 1kg, lapereau 0.5kg paille/jour

**Pintades :**
- Poulailler + parc (semi-liberté, 10m²/animal). Surfaces poulailler : 0.1m² adulte, 0.07m² jeune, 0.01m² pintadeau
- Reproduction SAISONNIÈRE : insémination en mars uniquement, 6 cycles ponte/couvaison (mars→août), 1 mois chacun, 8-15 pintadeaux/cycle
- Maturité 9 mois. Pas de vente d'œufs (reproduction uniquement)
- Litière : adulte 0.5kg, jeune 0.3kg, pintadeau 0.1kg

```
Algorithme reproduction pintade :
1. Vérifier server.current_month == 3 (mars)
2. Vérifier femelle.age_days >= 270 (9 mois)
3. Vérifier mâle.age_days >= 270
4. Lancer insémination → succès basé sur indices génétiques
5. Cycle 1 : ponte/couvaison 1 mois → 8-15 pintadeaux
6. Cycles 2-6 : automatiques chaque mois suivant (avril→août)
7. Pas de nouvelle insémination nécessaire pour cycles 2-6
```

**Oies :**
- Semi-liberté exclusivement (poulailler + parc 10m²/animal). Pas de label plein-air
- Surfaces poulailler : jars/oie 0.5m², jeune 0.3m², oison 0.15m²
- Reproduction SAISONNIÈRE : insémination janvier-février, ponte/couvaison 9 jours Cultivia, 3 cycles mars→juin, 4-10 oisons/cycle
- Indice fertilité : jusqu'à 5 tentatives (auto-insémination au 5e essai)
- Duvet : récolte tous les 14 jours, 30-60g/animal, 0.025 HT/animal, 10 €/kg
- Litière : jars/oie 1kg, jeune 0.6kg, oison 0.2kg

```
Algorithme reproduction oie :
1. Vérifier server.current_month IN (1, 2) (janvier ou février)
2. Vérifier femelle.age_days >= 180 (6 mois)
3. Tenter insémination (indice fertilité)
4. Si échec et tentative < 5 : réessayer
5. Si tentative == 5 : auto-succès
6. Ponte/couvaison : 9 jours Cultivia
7. Naissance : 4-10 oisons (indices prolificité + éclosion)
8. Cycles 2-3 : automatiques mars→juin
```

**Canards :**
- Semi-liberté exclusivement. Pas de label plein-air
- Surfaces poulailler : 0.1m² adulte, 0.08m² jeune, 0.04m² caneton
- Reproduction SAISONNIÈRE : insémination en avril uniquement, ponte 7 jours (domestique) ou 9 jours (Barbarie), 3-12 canetons
- Ponte d'œufs (hors reproduction) : janvier→septembre, 0-4 œufs/jour
- Duvet : récolte en juin et octobre, 20-40g/animal, 0.020 HT/animal, 10 €/kg
- Litière : adulte 0.5kg, jeune 0.3kg, caneton 0.1kg

### 2.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| GET | `/api/animals?species=rabbit` | Lister lapins | 0 |
| GET | `/api/animals?species=guinea_fowl` | Lister pintades | 0 |
| GET | `/api/animals?species=goose` | Lister oies | 0 |
| GET | `/api/animals?species=duck` | Lister canards | 0 |
| POST | `/api/animals/:id/collect-down` | Récolter duvet (oies/canards) | 0.020-0.025 |
| POST | `/api/animals/:id/collect-eggs` | Ramasser œufs canards | 0.25 |
| POST | `/api/animals/:id/inseminate` | Inséminer (vérifie saison) | 1 |
| POST | `/api/animals/batch/feed` | Nourrir lot | variable |

### 2.5 Tests

```
T2.1 — Achat lapin Angora → animal créé en clapier, wool_per_shear=0.3
T2.2 — Nourrir lapin adulte → stock déduit (foin 0.8, blé+orge+pois+avoine 0.64, betterave 0.18, tourteau 0.18, eau 1.2L)
T2.3 — Inséminer lapine 3 mois → gestation 1 mois, 6-7 lapereaux
T2.4 — Inséminer lapine 2 mois → ERREUR 400 "Maturité non atteinte"
T2.5 — Tondre lapin Angora → 0.3kg laine angora
T2.6 — Inséminer pintade en mars, mois 3 → OK, 6 cycles lancés
T2.7 — Inséminer pintade en juin → ERREUR 400 "Hors saison de reproduction"
T2.8 — Cycle pintade : 6 pontes successives mars→août → 8-15 pintadeaux/cycle
T2.9 — Inséminer oie en janvier → OK, indice fertilité vérifié
T2.10 — Inséminer oie en mars → ERREUR 400 "Hors saison"
T2.11 — Oie : 5e tentative insémination → auto-succès
T2.12 — Oie : ponte/couvaison 9 jours → 4-10 oisons
T2.13 — Récolter duvet oie (14 jours écoulés) → 30-60g ajoutés à stockage
T2.14 — Récolter duvet oie (< 14 jours) → ERREUR 400 "Trop tôt"
T2.15 — Inséminer canard en avril → OK, ponte 7j (domestique) ou 9j (Barbarie)
T2.16 — Inséminer canard en juillet → ERREUR 400
T2.17 — Canard : ponte œufs en mars → OK (jan→sept)
T2.18 — Canard : ponte œufs en novembre → ERREUR (hors saison ponte)
T2.19 — Récolter duvet canard en juin → OK, 20-40g
T2.20 — Récolter duvet canard en mars → ERREUR 400 "Hors période (juin/octobre)"
T2.21 — Lapin au pré → ERREUR 400 "Clapier uniquement"
T2.22 — Pintade : vendre œufs → ERREUR 400 "Œufs pintade non vendables"
```

---

## Feature 3 — Concessionnaire joueur

### 3.1 Description

Un joueur peut devenir concessionnaire de matériels agricoles. Il reçoit un hall de 200m², répartit 100 points de licence sur des constructeurs, paie des droits d'entrée annuels, et vend du matériel neuf (régional) et d'occasion (achat national, vente régionale). Un reversement sur le CA annuel est versé par les constructeurs. Des vendeurs employés gèrent les ventes.

**Prérequis :** 90 jours d'ancienneté, Licence Pro actif, déblocage ~1.80€ (durée illimitée).

### 3.2 Schéma BDD

```sql
CREATE TABLE dealership (
  id              SERIAL PRIMARY KEY,
  player_id       INT NOT NULL REFERENCES player(id) UNIQUE,
  hall_m2         INT NOT NULL DEFAULT 200,
  license_points  JSONB NOT NULL DEFAULT '{}',  -- {"brand_name": points, ...} total=100
  balance         DECIMAL(14,2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE dealership_brand (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(80) NOT NULL UNIQUE,
  entry_fee       DECIMAL(10,2) NOT NULL,       -- droit d'entrée annuel
  rebate_pct      DECIMAL(4,2) NOT NULL,         -- % reversement CA annuel
  min_points      SMALLINT NOT NULL DEFAULT 1    -- points minimum pour représenter
);

CREATE TABLE dealership_license (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  brand_id        INT NOT NULL REFERENCES dealership_brand(id),
  points          SMALLINT NOT NULL CHECK (points >= 1),
  valid_until     TIMESTAMPTZ NOT NULL,          -- renouvellement annuel
  UNIQUE(dealership_id, brand_id)
);

-- Contrainte : SUM(points) par dealership_id = 100
-- Vérifiée par trigger ou logique applicative

CREATE TABLE dealership_stock (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  vehicle_type_id INT NOT NULL REFERENCES vehicle_type(id),
  is_new          BOOLEAN NOT NULL DEFAULT true,
  wear_pct        DECIMAL(5,2) NOT NULL DEFAULT 0,  -- 0 si neuf
  buy_price       DECIMAL(12,2) NOT NULL,
  sell_price      DECIMAL(12,2) NOT NULL,
  listed_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE dealership_seller (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  employee_id     INT NOT NULL REFERENCES employee(id),
  UNIQUE(employee_id)
);

-- Dépôt-vente (matériel d'autres joueurs)
CREATE TABLE dealership_consignment (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  vehicle_id      INT NOT NULL REFERENCES vehicle(id),
  owner_id        INT NOT NULL REFERENCES player(id),
  commission_pct  DECIMAL(4,2) NOT NULL,  -- % commission du concessionnaire
  ask_price       DECIMAL(12,2) NOT NULL,
  listed_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sold_at         TIMESTAMPTZ,
  buyer_id        INT REFERENCES player(id)
);
```

### 3.3 Logique métier

```
Création concessionnaire :
1. Vérifier activity_unlock('dealership') existe pour le joueur
2. Vérifier player.seniority_days >= 90
3. Créer dealership avec hall_m2=200
4. Le joueur répartit 100 points sur les constructeurs choisis
5. Payer droits d'entrée pour chaque constructeur sélectionné

Achat matériel neuf (par un client) :
1. Vérifier le concessionnaire a la licence pour la marque
2. Vérifier stock disponible ou commande usine
3. Client paie sell_price au concessionnaire
4. Concessionnaire paie buy_price à l'usine (système)
5. Marge = sell_price - buy_price
6. Vente régionale uniquement (client même région)

Achat matériel occasion :
1. Concessionnaire peut acheter occasion au niveau national
2. Revente régionale uniquement
3. Prix libre, pas de reversement constructeur

Reversement CA annuel :
1. En fin d'année Cultivia (7 Décembre)
2. CA neuf = somme des ventes neuves de l'année
3. Reversement = CA neuf × rebate_pct de chaque constructeur
4. Crédité sur dealership.balance

Droits d'entrée :
1. Prélevés annuellement (1er jour de l'année Cultivia)
2. Montant = entry_fee × (points / 100) pour chaque constructeur
3. Si non payé → licence suspendue

Dépôt-vente :
1. Joueur dépose matériel gratuitement
2. Commission fixée par le concessionnaire (% du prix de vente)
3. Alternative à l'annonce (800€)
```

### 3.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/dealership/create` | Créer concessionnaire | 0 |
| GET | `/api/dealership/me` | Mon concessionnaire | 0 |
| PUT | `/api/dealership/licenses` | Répartir points licences | 0 |
| GET | `/api/dealership/:id/stock` | Stock du concessionnaire | 0 |
| POST | `/api/dealership/:id/buy-new` | Commander matériel neuf à l'usine | 2 |
| POST | `/api/dealership/:id/buy-used` | Acheter occasion (national) | 2 |
| POST | `/api/dealership/:id/sell` | Vendre matériel à un client | 1 |
| POST | `/api/dealership/:id/consign` | Déposer matériel en dépôt-vente | 0 |
| GET | `/api/dealership/:id/consignments` | Liste dépôts-vente | 0 |
| POST | `/api/dealership/:id/hire-seller` | Embaucher vendeur | 0 |

### 3.5 Tests

```
T3.1 — Créer concessionnaire sans 90 jours → ERREUR 403
T3.2 — Créer concessionnaire OK → hall 200m², license_points={}
T3.3 — Répartir 100 points sur 3 constructeurs → OK, droits d'entrée débités
T3.4 — Répartir 105 points → ERREUR 400 "Total doit être 100"
T3.5 — Vendre matériel neuf à client même région → OK, marge calculée
T3.6 — Vendre matériel neuf à client autre région → ERREUR 400 "Vente régionale uniquement"
T3.7 — Acheter occasion national → OK
T3.8 — Reversement CA fin d'année → montant correct (CA × rebate_pct)
T3.9 — Dépôt-vente : déposer matériel → commission_pct enregistrée
T3.10 — Dépôt-vente : vente → propriétaire reçoit (prix - commission), concessionnaire reçoit commission
T3.11 — Licence expirée → vente impossible pour cette marque
T3.12 — Droits d'entrée non payés → licence suspendue
```

---

## Feature 4 — Atelier concessionnaire

### 4.1 Description

L'atelier du concessionnaire emploie des mécaniciens (25 HT/jour, 1 400€/mois) qui entretiennent et réparent les matériels. Chaque mécanicien a 2 compétences (usure et HT, 1-10), peut se former (84 jours), se spécialiser sur 3 marques max, et prend sa retraite à 60 ans. L'atelier propose entretien et dépannage.

### 4.2 Schéma BDD

```sql
CREATE TABLE mechanic (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  employee_id     INT NOT NULL REFERENCES employee(id) UNIQUE,
  skill_wear      SMALLINT NOT NULL DEFAULT 1 CHECK (skill_wear BETWEEN 1 AND 10),
  skill_pa        SMALLINT NOT NULL DEFAULT 1 CHECK (skill_pa BETWEEN 1 AND 10),
  specializations VARCHAR(80)[] DEFAULT '{}',  -- max 3 marques
  training_until  TIMESTAMPTZ,                  -- NULL = pas en formation
  hired_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  birth_date      TIMESTAMPTZ NOT NULL,         -- pour calcul retraite 60 ans
  retired         BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE workshop_job (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  mechanic_id     INT NOT NULL REFERENCES mechanic(id),
  vehicle_id      INT NOT NULL REFERENCES vehicle(id),
  job_type        VARCHAR(20) NOT NULL CHECK (job_type IN ('maintenance','repair','gps_install','front_hitch')),
  pa_cost         DECIMAL(4,2) NOT NULL,
  parts_cost      DECIMAL(10,2) NOT NULL DEFAULT 0,
  labor_cost      DECIMAL(10,2) NOT NULL DEFAULT 0,  -- HT × tarif horaire
  labor_rate      DECIMAL(6,2) NOT NULL,              -- 8-24 €/HT
  discount_pct    DECIMAL(4,2) NOT NULL DEFAULT 0,    -- remise si acheté même concession
  status          VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at    TIMESTAMPTZ
);
```

### 4.3 Logique métier

```
Embauche mécanicien :
1. Créer employee(role='mechanic', salary=1400, pa_per_day=25)
2. Créer mechanic avec skill_wear=1, skill_pa=1, birth_date aléatoire
3. Spécialisations : vide au départ

Formation :
1. Durée : 84 jours Cultivia (1 an)
2. Pendant formation : mécanicien indisponible
3. À la fin : skill_wear += 1 OU skill_pa += 1 (choix)
4. Max 10 pour chaque compétence

Spécialisation :
1. Max 3 marques par mécanicien
2. Bonus efficacité sur les marques spécialisées
3. Ajout d'une spécialisation : 1 mois de pratique

Retraite :
1. Calculée sur birth_date + 60 ans (en jours Cultivia : 60 × 84 = 5040 jours)
2. À la retraite : mechanic.retired = true, employee supprimé
3. Notification au joueur 1 mois avant

Entretien matériel :
1. HT nécessaires selon type : outil 2PA, tracteur 4PA, moissonneuse 5PA
2. Coût pièces : outil 100€, tracteur 300€, moissonneuse 500€
3. Main d'œuvre : HT × labor_rate (8-24 €/HT, fixé par concessionnaire)
4. Majoration pièces : +2%/an d'ancienneté du matériel
5. Effet skill_wear : réduit l'usure récupérée (skill 10 = récupère 2× plus)
6. Effet skill_pa : réduit les HT consommés (skill 10 = -50% HT)

Dépannage :
1. Matériel en panne → réparation obligatoire
2. Coût = entretien × 1.5
3. Pièces cassées remplacées (voir Feature 5)
```

### 4.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/dealership/:id/hire-mechanic` | Embaucher mécanicien | 0 |
| POST | `/api/mechanic/:id/train` | Lancer formation (84j) | 0 |
| POST | `/api/mechanic/:id/specialize` | Ajouter spécialisation marque | 0 |
| POST | `/api/workshop/maintenance` | Demander entretien (body: vehicle_id) | 2-5 |
| POST | `/api/workshop/repair` | Demander réparation | 3-8 |
| GET | `/api/workshop/jobs` | Liste travaux en cours | 0 |
| PUT | `/api/workshop/labor-rate` | Fixer tarif main d'œuvre | 0 |

### 4.5 Tests

```
T4.1 — Embaucher mécanicien → salary=1400, pa=25, skills=1/1
T4.2 — Lancer formation → training_until = now + 84 jours
T4.3 — Mécanicien en formation : demander entretien → ERREUR 400 "Mécanicien indisponible"
T4.4 — Fin formation → skill_wear ou skill_pa += 1
T4.5 — Spécialiser sur 3 marques → OK
T4.6 — Spécialiser sur 4e marque → ERREUR 400 "Max 3 spécialisations"
T4.7 — Entretien tracteur → 4 HT consommés, 300€ pièces, labor_rate × 4 main d'œuvre
T4.8 — Entretien tracteur 5 ans → pièces 300€ × 1.10 (majoration 2%/an × 5)
T4.9 — Mécanicien skill_pa=10 : entretien tracteur → 2 HT au lieu de 4
T4.10 — Retraite mécanicien (60 ans) → retired=true, notification envoyée
T4.11 — Dépannage moissonneuse → 5 HT × 1.5, pièces 500€ × 1.5
```

---

## Feature 5 — Pannes & pièces détachées

### 5.1 Description

Chaque matériel a 1 à 5 pièces détachées (défini par `vehicle_type.piece_count`). Chaque pièce a un seuil HT d'usure. Quand une pièce atteint le seuil, le matériel tombe en panne. Le remplacement se fait en atelier. Un magasin de pièces est disponible. Remise si le matériel a été acheté dans la même concession.

### 5.2 Schéma BDD

```sql
-- Table existante (Phase 3), enrichie
-- vehicle_piece déjà créée dans 01_DATA_MODEL

CREATE TABLE piece_catalog (
  id              SERIAL PRIMARY KEY,
  vehicle_type_id INT NOT NULL REFERENCES vehicle_type(id),
  piece_num       SMALLINT NOT NULL,
  name            VARCHAR(80) NOT NULL,
  base_price      DECIMAL(10,2) NOT NULL,
  pa_threshold    DECIMAL(6,2) NOT NULL,  -- seuil HT d'usure avant panne
  UNIQUE(vehicle_type_id, piece_num)
);

CREATE TABLE piece_stock (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  piece_catalog_id INT NOT NULL REFERENCES piece_catalog(id),
  quantity        INT NOT NULL DEFAULT 0,
  sell_price      DECIMAL(10,2) NOT NULL,
  UNIQUE(dealership_id, piece_catalog_id)
);

-- Ajout colonne sur vehicle pour tracer l'origine d'achat
ALTER TABLE vehicle ADD COLUMN bought_from_dealership_id INT REFERENCES dealership(id);
```

### 5.3 Logique métier

```
Usure des pièces (daily tick) :
1. Pour chaque vehicle utilisé aujourd'hui :
   a. Calculer HT travail effectués
   b. Pour chaque pièce du véhicule :
      - piece.wear_pct += (PA_travail / pa_threshold) × facteur_abri
      - facteur_abri = 1.0 si abrité (hangar), 1.5 si non abrité
   c. Si piece.wear_pct >= 100% :
      - vehicle.is_broken = true
      - Notification "Matériel en panne — pièce N à remplacer"

Remplacement pièce :
1. Vérifier pièce en stock (magasin concessionnaire ou coop)
2. Coût = piece.base_price × (1 + 0.02 × ancienneté_années)
3. Si vehicle.bought_from_dealership_id == dealership.id :
   - Remise 10% sur la pièce
4. HT mécanicien : 1-3 HT selon pièce
5. piece.wear_pct = 0, piece.replaced_at = now()
6. vehicle.is_broken = false (si toutes pièces OK)

Magasin pièces :
1. Concessionnaire commande pièces au catalogue
2. Stock limité par espace hall
3. Vente aux joueurs de la région
```

### 5.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| GET | `/api/vehicles/:id/pieces` | État des pièces du matériel | 0 |
| POST | `/api/workshop/replace-piece` | Remplacer pièce (body: vehicle_id, piece_num) | 1-3 |
| GET | `/api/dealership/:id/pieces` | Stock pièces du concessionnaire | 0 |
| POST | `/api/dealership/:id/order-pieces` | Commander pièces | 0 |

### 5.5 Tests

```
T5.1 — Tracteur avec 3 pièces → vehicle_piece créées (piece_num 1,2,3)
T5.2 — Utilisation intensive → pièce 1 atteint 100% → vehicle.is_broken=true
T5.3 — Matériel en panne : tenter utilisation → ERREUR 400 "Matériel en panne"
T5.4 — Remplacer pièce → wear_pct=0, is_broken=false
T5.5 — Pièce matériel 5 ans → prix × 1.10
T5.6 — Matériel acheté même concession → remise 10% sur pièce
T5.7 — Matériel acheté ailleurs → pas de remise
T5.8 — Matériel non abrité → usure pièces ×1.5
T5.9 — Commander pièces au magasin → stock incrémenté
```

---

## Feature 6 — GPS

### 6.1 Description

Le GPS améliore la précision des travaux agricoles. Composé de balises (20 000€, installées par le concessionnaire), récepteurs (3 000€ achat, installation atelier 150-300€), et abonnement annuel (400-600€/an). Bonus : réduction HT semis/engrais, meilleure précision semences.

### 6.2 Schéma BDD

```sql
CREATE TABLE gps_beacon (
  id              SERIAL PRIMARY KEY,
  dealership_id   INT NOT NULL REFERENCES dealership(id),
  prefecture_id         INT NOT NULL REFERENCES zone(id),
  installed_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  subscription_fee DECIMAL(8,2) NOT NULL CHECK (subscription_fee BETWEEN 400 AND 600),
  UNIQUE(dealership_id, prefecture_id)
);

CREATE TABLE gps_subscription (
  id              SERIAL PRIMARY KEY,
  player_id       INT NOT NULL REFERENCES player(id),
  beacon_id       INT NOT NULL REFERENCES gps_beacon(id),
  valid_until     TIMESTAMPTZ NOT NULL,
  UNIQUE(player_id, beacon_id)
);

-- vehicle.has_gps déjà dans le modèle (Phase 3)
-- Ajout : coût installation récepteur
CREATE TABLE gps_installation (
  id              SERIAL PRIMARY KEY,
  vehicle_id      INT NOT NULL REFERENCES vehicle(id) UNIQUE,
  beacon_id       INT NOT NULL REFERENCES gps_beacon(id),
  installed_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  install_cost    DECIMAL(8,2) NOT NULL  -- 150-300€ (atelier) ou 500€ (Cultivia)
);
```

### 6.3 Logique métier

```
Installation balise GPS :
1. Concessionnaire achète balise : 20 000€
2. Installation dans un canton (1 balise par canton par concessionnaire)
3. Abonnement annuel : 400-600€/an (fixé par concessionnaire)

Installation récepteur :
1. Joueur achète récepteur : 3 000€ (coop) ou prix concessionnaire
2. Installation en atelier : 150-300€ (concessionnaire) ou 500€ (Cultivia)
3. vehicle.has_gps = true

Bonus GPS actif (véhicule avec récepteur + abonnement valide + balise dans le canton) :
- Semis : -10% HT
- Engrais : -10% HT
- Semences : -5% consommation (meilleure précision)
- Traitement : -5% HT

Abonnement :
1. Prélevé annuellement
2. Si expiré : bonus GPS désactivé (récepteur reste installé)
```

### 6.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/dealership/:id/install-beacon` | Installer balise GPS | 2 |
| POST | `/api/gps/subscribe` | S'abonner à une balise | 0 |
| POST | `/api/workshop/install-gps` | Installer récepteur sur véhicule | 2 |
| GET | `/api/gps/beacons?prefecture_id=X` | Balises disponibles dans le canton | 0 |
| GET | `/api/gps/my-subscriptions` | Mes abonnements GPS | 0 |

### 6.5 Tests

```
T6.1 — Installer balise → 20 000€ débités, beacon créée
T6.2 — Installer récepteur en atelier → 150-300€, vehicle.has_gps=true
T6.3 — Installer récepteur Cultivia → 500€
T6.4 — Semer avec GPS actif → HT réduits de 10%
T6.5 — Semer sans GPS → HT normaux
T6.6 — Abonnement expiré → bonus GPS désactivé
T6.7 — Renouveler abonnement → bonus réactivé
T6.8 — Engrais avec GPS → -10% HT, -5% consommation semences
```

---

## Feature 7 — CIA (Centre d'Insémination Artificielle)

### 7.1 Description

Le CIA permet à un joueur de collecter des doses de semence sur des mâles reproducteurs et de les vendre aux éleveurs. Nécessite un labo de 50m², un inséminateur (25 HT/jour, 1 600€/mois), un utilitaire. Deux types de contrats : contrat race (tous les mâles d'une race chez un éleveur) et contrat animal (un mâle spécifique). Le GenBook est l'annuaire génétique régional.

**Prérequis :** 90 jours d'ancienneté, Licence Pro actif, déblocage ~1.80€.

### 7.2 Schéma BDD

```sql
-- Tables existantes dans 01_DATA_MODEL, enrichies

CREATE TABLE cia (
  id          SERIAL PRIMARY KEY,
  player_id   INT NOT NULL REFERENCES player(id) UNIQUE,
  lab_m2      INT NOT NULL DEFAULT 50,  -- 1 m² par animal stocké (doses)
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE cia_contract (
  id              SERIAL PRIMARY KEY,
  cia_id          INT NOT NULL REFERENCES cia(id),
  breeder_id      INT NOT NULL REFERENCES player(id),
  breed_id        INT NOT NULL REFERENCES animal_breed(id),
  animal_id       BIGINT REFERENCES animal(id),  -- NULL = contrat race, NOT NULL = contrat animal
  dose_price      DECIMAL(8,2) NOT NULL,
  cia_share_pct   DECIMAL(4,2) NOT NULL,          -- % pour le CIA
  breeder_share_pct DECIMAL(4,2) NOT NULL,        -- % pour l'éleveur
  status          VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (cia_share_pct + breeder_share_pct = 100)
);

CREATE TABLE cia_dose (
  id              SERIAL PRIMARY KEY,
  cia_id          INT NOT NULL REFERENCES cia(id),
  animal_id       BIGINT NOT NULL REFERENCES animal(id),
  breed_id        INT NOT NULL REFERENCES animal_breed(id),
  doses_left      INT NOT NULL,
  genetics        JSONB NOT NULL,  -- copie des indices génétiques du mâle au moment du prélèvement
  collected_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Doses par prélèvement (référentiel)
CREATE TABLE dose_yield (
  id              SERIAL PRIMARY KEY,
  species_id      INT NOT NULL REFERENCES animal_species(id) UNIQUE,
  min_doses       SMALLINT NOT NULL,
  max_doses       SMALLINT NOT NULL,
  min_price       DECIMAL(8,2) NOT NULL,
  max_price       DECIMAL(8,2) NOT NULL,
  cooldown_days   SMALLINT NOT NULL  -- délai entre prélèvements
);

INSERT INTO dose_yield (species_id, min_doses, max_doses, min_price, max_price, cooldown_days)
VALUES
  ((SELECT id FROM animal_species WHERE name='cattle'), 300, 400, 30, 90, 7),
  ((SELECT id FROM animal_species WHERE name='pig'), 20, 40, 5, 30, 3),
  ((SELECT id FROM animal_species WHERE name='goat'), 15, 25, 15, 35, 5),
  ((SELECT id FROM animal_species WHERE name='sheep'), 10, 15, 10, 25, 5),
  ((SELECT id FROM animal_species WHERE name='rabbit'), 35, 50, 0.5, 4, 2),
  ((SELECT id FROM animal_species WHERE name='poultry'), 35, 50, 0.5, 4, 2),
  ((SELECT id FROM animal_species WHERE name='guinea_fowl'), 35, 50, 0.5, 4, 2),
  ((SELECT id FROM animal_species WHERE name='goose'), 7, 12, 0.5, 4, 3),
  ((SELECT id FROM animal_species WHERE name='duck'), 35, 50, 0.5, 4, 2),
  ((SELECT id FROM animal_species WHERE name='horse'), 20, 30, 30, 120, 7);
```

### 7.3 Logique métier

```
Création CIA :
1. Vérifier activity_unlock('cia')
2. Vérifier seniority >= 90 jours
3. Créer cia avec lab_m2=50
4. Embaucher inséminateur (employee role='inseminator', salary=1750, pa=25)
5. Nécessite utilitaire pour déplacements

Contrat race :
1. CIA propose contrat à un éleveur pour une race
2. L'éleveur accepte → tous ses mâles adultes de cette race sont disponibles
3. Prix dose et répartition CIA/éleveur négociés

Contrat animal :
1. CIA propose contrat pour un mâle spécifique
2. Prix dose et répartition négociés individuellement

Prélèvement :
1. Inséminateur se déplace chez l'éleveur (PA déplacement)
2. Prélèvement sur mâle adulte : 1 HT inséminateur
3. Doses obtenues : random(min_doses, max_doses) selon espèce
4. Génétique copiée dans cia_dose.genetics
5. Cooldown : pas de nouveau prélèvement avant cooldown_days
6. Stockage : 1 m² labo par lot de doses

Insémination (client) :
1. Éleveur commande doses au CIA
2. Inséminateur se déplace (PA déplacement + 1 HT insémination)
3. Dose consommée (doses_left -= 1)
4. Paiement : dose_price réparti selon cia_share_pct / breeder_share_pct

GenBook :
1. Annuaire régional des mâles disponibles dans les CIA
2. Affiche : race, indices génétiques, prix dose, CIA
3. Filtrable par race, espèce, indice
```

### 7.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/cia/create` | Créer CIA | 0 |
| GET | `/api/cia/me` | Mon CIA | 0 |
| POST | `/api/cia/contracts` | Proposer contrat (race ou animal) | 1 |
| PUT | `/api/cia/contracts/:id/accept` | Éleveur accepte contrat | 0 |
| POST | `/api/cia/collect` | Prélever doses (body: animal_id) | 1 |
| GET | `/api/cia/doses` | Mes doses en stock | 0 |
| POST | `/api/cia/inseminate` | Inséminer animal client (body: dose_id, female_id) | 1 |
| GET | `/api/genbook?region_id=X&species=cattle` | GenBook régional | 0 |

### 7.5 Tests

```
T7.1 — Créer CIA sans 90 jours → ERREUR 403
T7.2 — Créer CIA OK → lab_m2=50, inséminateur embauché
T7.3 — Contrat race : proposer → éleveur notifié
T7.4 — Contrat race : accepter → tous mâles de la race disponibles
T7.5 — Prélèvement taureau → 300-400 doses, génétique copiée
T7.6 — Prélèvement taureau avant cooldown → ERREUR 400 "Délai non écoulé"
T7.7 — Inséminer vache avec dose → dose_left -= 1, paiement réparti
T7.8 — Inséminer avec dose épuisée → ERREUR 400 "Plus de doses"
T7.9 — GenBook : lister mâles bovins région → résultats filtrés
T7.10 — Prélèvement verrat → 20-40 doses
T7.11 — Prélèvement jars → 7-12 doses
T7.12 — Prix dose hors bornes → ERREUR 400
```

---

## Feature 8 — Génétique complète

### 8.1 Description

Système de 14 indices génétiques calculés quotidiennement sur les animaux adultes nés à la ferme. Valorisation vente +1 à +10% selon valeur génétique. Nommage possible si indice ≥ 70% du meilleur du serveur. Somme génétique = somme de tous les indices.

### 8.2 Schéma BDD

```sql
-- animal.genetics (JSONB) déjà dans le modèle
-- Exemple : {"growth":65, "prolificacy":42, "general_appearance":58, "milk":71, "milk_quality":55}

-- Référentiel indices par espèce (déjà dans animal_breed.genetic_indices)
-- 14 indices possibles :
-- growth, prolificacy, general_appearance, milk, milk_quality, wool,
-- egg, hatching, resistance, sociability, fertility, down, physical, mental

-- Table pour stocker les seuils de nommage par serveur/race/indice
CREATE TABLE genetic_threshold (
  id              SERIAL PRIMARY KEY,
  server_id       INT NOT NULL REFERENCES server(id),
  breed_id        INT NOT NULL REFERENCES animal_breed(id),
  index_name      VARCHAR(30) NOT NULL,
  max_value       DECIMAL(6,2) NOT NULL DEFAULT 0,  -- meilleur du serveur
  avg_value       DECIMAL(6,2) NOT NULL DEFAULT 0,  -- moyenne serveur
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(server_id, breed_id, index_name)
);

-- Table nommage animaux
CREATE TABLE animal_name_registry (
  id              SERIAL PRIMARY KEY,
  animal_id       BIGINT NOT NULL REFERENCES animal(id) UNIQUE,
  name            VARCHAR(60) NOT NULL,
  farm_suffix     VARCHAR(60) NOT NULL,  -- nom de domaine de la ferme
  full_name       VARCHAR(120) NOT NULL GENERATED ALWAYS AS (name || ' ' || farm_suffix) STORED,
  approved        BOOLEAN NOT NULL DEFAULT false,
  named_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 8.3 Logique métier

```
Calcul génétique (daily tick) :
1. Pour chaque animal adulte né à la ferme (bought_from='born') :
   a. Recalculer chaque indice selon :
      - Génétique parents (héritage)
      - Alimentation (qualité nourriture)
      - Conditions d'élevage (espace, pâturage)
   b. animal.genetics = {index: value, ...}
   c. animal.genetic_value = moyenne pondérée des indices

Héritage génétique (à la naissance) :
1. Pour chaque indice de la race :
   a. base = (père.indice + mère.indice) / 2
   b. mutation = random(-5, +5)
   c. enfant.indice = clamp(base + mutation, 0, 100)
2. Si IA : père = indices de la dose CIA

Valorisation vente :
1. Calculer genetic_value = moyenne de tous les indices
2. Bonus vente abattoir/joueur :
   - genetic_value 0-9 → +1%
   - genetic_value 10-19 → +2%
   - ...
   - genetic_value 90-100 → +10%
3. Valorisation inter-joueurs (€/point au-dessus moyenne serveur) :
   - Bovins/équins/bisons : 2€/point
   - Porcins/caprins/ovins : 0.5€/point
   - Daims : 0.25€/point
   - Oies : 0.03€/point
   - Lapins/volailles/pintades/canards : 0.01€/point

Nommage :
1. Animal adulte né à la ferme
2. Indice le plus fort ≥ 70% du max serveur (même race, même famille M/F)
3. OU somme génétique mâle ≥ seuil minimum
4. Si seuil < moyenne serveur → utiliser la moyenne
5. Nom choisi par joueur + suffixe ferme
6. Validation définitive, non modifiable
7. animal.is_named = true

Mise à jour seuils (daily tick) :
1. Pour chaque race/serveur :
   a. max_value = MAX(indice) parmi tous les animaux adultes nés en ferme
   b. avg_value = AVG(indice)
   c. Mettre à jour genetic_threshold
```

### 8.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| GET | `/api/animals/:id/genetics` | Indices génétiques d'un animal | 0 |
| GET | `/api/genetics/thresholds?breed_id=X` | Seuils serveur pour une race | 0 |
| POST | `/api/animals/:id/name` | Nommer un animal (body: name) | 0 |
| GET | `/api/genetics/rankings?breed_id=X` | Classement génétique | 0 |

### 8.5 Tests

```
T8.1 — Naissance veau : génétique = moyenne parents ± mutation
T8.2 — Naissance via IA : génétique père = dose.genetics
T8.3 — Animal acheté coop : genetics = valeurs aléatoires basses (30-50)
T8.4 — Valorisation vente : genetic_value=75 → +8% prix abattoir
T8.5 — Valorisation inter-joueurs : bovin 10 points au-dessus moyenne → +20€
T8.6 — Nommer animal : indice 72, max serveur 100 → 72% ≥ 70% → OK
T8.7 — Nommer animal : indice 65, max serveur 100 → 65% < 70% → ERREUR 400
T8.8 — Nommer animal acheté coop → ERREUR 400 "Doit être né à la ferme"
T8.9 — Nommer animal déjà nommé → ERREUR 400
T8.10 — Seuils mis à jour quotidiennement → max_value et avg_value corrects
T8.11 — Somme génétique : 14 indices × 70 = 980 → nommable si ≥ seuil
```

---

## Feature 9 — Fromagerie artisanale

### 9.1 Description

Fromagerie artisanale : 20 800-100 000€, transforme 250-1 250L/jour, 25 HT max/jour. Le joueur est le seul fromager (6 compétences 0-100). 4 indices qualité fromage (forme, odeur, goût, couleur). Affinage 4-84 jours selon type. DLC 7-18 jours. Vente sur marchés uniquement.

### 9.2 Schéma BDD

```sql
CREATE TABLE cheese_factory (
  id              SERIAL PRIMARY KEY,
  farm_id         INT NOT NULL REFERENCES farm(id),
  type            VARCHAR(15) NOT NULL CHECK (type IN ('artisan','industrial')),
  model           SMALLINT NOT NULL CHECK (model BETWEEN 1 AND 5),  -- 5 modèles artisanaux
  capacity_l      INT NOT NULL CHECK (capacity_l BETWEEN 250 AND 1250),
  ht_max_day      SMALLINT NOT NULL DEFAULT 25,
  hygiene_pct     SMALLINT NOT NULL DEFAULT 100 CHECK (hygiene_pct BETWEEN 0 AND 100),
  equipment_pct   SMALLINT NOT NULL DEFAULT 100 CHECK (equipment_pct BETWEEN 0 AND 100),
  cost            DECIMAL(12,2) NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(farm_id, type)
);

-- Compétences fromager (artisanal = le joueur lui-même)
CREATE TABLE cheese_maker_skill (
  id              SERIAL PRIMARY KEY,
  factory_id      INT NOT NULL REFERENCES cheese_factory(id),
  employee_id     INT REFERENCES employee(id),  -- NULL = joueur (artisanal)
  skill_curdling  SMALLINT NOT NULL DEFAULT 40 CHECK (skill_curdling BETWEEN 0 AND 100),   -- emprésurage
  skill_cutting   SMALLINT NOT NULL DEFAULT 40 CHECK (skill_cutting BETWEEN 0 AND 100),    -- découpe
  skill_molding   SMALLINT NOT NULL DEFAULT 40 CHECK (skill_molding BETWEEN 0 AND 100),    -- moulage
  skill_draining  SMALLINT NOT NULL DEFAULT 40 CHECK (skill_draining BETWEEN 0 AND 100),   -- égouttage
  skill_salting   SMALLINT NOT NULL DEFAULT 40 CHECK (skill_salting BETWEEN 0 AND 100),    -- salage
  skill_aging     SMALLINT NOT NULL DEFAULT 40 CHECK (skill_aging BETWEEN 0 AND 100),      -- affinage
  UNIQUE(factory_id, employee_id)
);
-- Artisanal : 240 pts répartis aléatoirement (max 300 avec formation 1000€)

CREATE TABLE cheese_type_ref (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(60) NOT NULL UNIQUE,
  category        VARCHAR(40) NOT NULL,  -- 'soft_bloomy','soft_washed','pressed_cooked','pressed_uncooked','blue','goat'
  milk_source     VARCHAR(10) NOT NULL CHECK (milk_source IN ('cow','goat','sheep')),
  aging_min_days  SMALLINT NOT NULL,
  aging_max_days  SMALLINT NOT NULL,
  dlc_days        SMALLINT NOT NULL,
  region_id       INT REFERENCES region(id),      -- NULL = national
  department_id   INT REFERENCES department(id),   -- NULL = pas de contrainte département
  breed_constraint INT REFERENCES animal_breed(id), -- NULL = pas de contrainte race
  ql_min          DECIMAL(5,2)                     -- NULL = pas de contrainte QL
);

INSERT INTO cheese_type_ref (name, category, milk_source, aging_min_days, aging_max_days, dlc_days)
VALUES
  ('Pâte Molle Croûte Fleurie', 'soft_bloomy', 'cow', 4, 10, 7),
  ('Pâte Molle Croûte Lavée', 'soft_washed', 'cow', 4, 10, 7),
  ('Pâte Pressée Cuite', 'pressed_cooked', 'cow', 21, 84, 11),
  ('Pâte Pressée Non Cuite', 'pressed_uncooked', 'cow', 14, 84, 11),
  ('Pâte Persillée', 'blue', 'cow', 14, 42, 7),
  ('Fromage de Chèvre', 'goat', 'goat', 4, 9, 7);

CREATE TABLE cheese_product (
  id              SERIAL PRIMARY KEY,
  factory_id      INT NOT NULL REFERENCES cheese_factory(id),
  cheese_type_id  INT NOT NULL REFERENCES cheese_type_ref(id),
  milk_liters     DECIMAL(10,2) NOT NULL,
  weight_kg       DECIMAL(8,2) NOT NULL,  -- milk_liters × 0.1
  quality_form    SMALLINT NOT NULL DEFAULT 50 CHECK (quality_form BETWEEN 0 AND 100),
  quality_smell   SMALLINT NOT NULL DEFAULT 50 CHECK (quality_smell BETWEEN 0 AND 100),
  quality_taste   SMALLINT NOT NULL DEFAULT 50 CHECK (quality_taste BETWEEN 0 AND 100),
  quality_color   SMALLINT NOT NULL DEFAULT 50 CHECK (quality_color BETWEEN 0 AND 100),
  aging_start     TIMESTAMPTZ,
  aging_end       TIMESTAMPTZ,
  dlc             TIMESTAMPTZ,
  status          VARCHAR(20) NOT NULL DEFAULT 'production',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Crème et beurre
CREATE TABLE dairy_product (
  id              SERIAL PRIMARY KEY,
  factory_id      INT NOT NULL REFERENCES cheese_factory(id),
  product_type    VARCHAR(10) NOT NULL CHECK (product_type IN ('cream','butter')),
  quantity        DECIMAL(10,2) NOT NULL,  -- litres (crème) ou kg (beurre)
  dlc             TIMESTAMPTZ NOT NULL,    -- crème 7j, beurre 18j
  status          VARCHAR(20) NOT NULL DEFAULT 'ready',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 9.3 Logique métier

```
Fabrication fromage :
1. Vérifier lait disponible (cuve à lait, même jour = transformé dans la journée)
2. Lait de votre exploitation uniquement
3. Conversion : 1L lait → 0.1 kg fromage + 0.0375L crème
4. Crème : 1L → 0.480 kg beurre
5. Charges : 0.09 €/L de lait transformé

Calcul qualité (4 indices) :
- Forme = f(skill_cutting, skill_molding, skill_draining)
- Odeur = f(skill_salting, skill_aging, skill_molding)
- Goût = f(skill_curdling, skill_aging, skill_salting)
- Couleur = f(skill_curdling, skill_cutting, skill_aging)
- Formule : indice = (comp1 × 0.4 + comp2 × 0.35 + comp3 × 0.25) × (hygiene_pct/100) × (equipment_pct/100)

Affinage :
1. Fromage en cave d'affinage pendant aging_min → aging_max jours
2. Affinage complet (max) = meilleure qualité (+20% indices)
3. Affinage écourté (min) = qualité de base
4. Interpolation linéaire entre min et max

DLC :
1. Débute après fin d'affinage
2. Durée selon type (7-18 jours)
3. Invendu après DLC = perdu (DELETE)

Hygiène et matériel :
1. Chaque utilisation : hygiene_pct -= 2-5, equipment_pct -= 1-3
2. Nettoyage (fin de journée) : hygiene_pct = 100, fromagerie indisponible jusqu'au lendemain
3. Entretien matériel : equipment_pct += 10-20 (PA + coût)
4. Mauvais niveau → qualité dégradée (multiplicateur)

Compétences fromager (artisanal) :
1. 240 pts répartis aléatoirement sur 6 compétences à la création
2. Formation : 1 000€ → +60 pts (total max 300)
3. Compétences évoluent avec la pratique (+0.1/fromage fabriqué, cap 100)
```

### 9.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/cheese-factory/create` | Créer fromagerie artisanale | 0 |
| GET | `/api/cheese-factory/me` | Ma fromagerie | 0 |
| POST | `/api/cheese-factory/produce` | Fabriquer fromage (body: cheese_type_id, milk_liters) | 2-5 |
| POST | `/api/cheese-factory/make-cream` | Fabriquer crème | 1 |
| POST | `/api/cheese-factory/make-butter` | Fabriquer beurre (à partir de crème) | 1 |
| POST | `/api/cheese-factory/clean` | Nettoyer fromagerie | 1 |
| POST | `/api/cheese-factory/maintain` | Entretenir matériel | 2 |
| POST | `/api/cheese-factory/train` | Formation fromager (1 000€) | 0 |
| GET | `/api/cheese-factory/products` | Mes fromages (en affinage, prêts, etc.) | 0 |

### 9.5 Tests

```
T9.1 — Créer fromagerie artisanale modèle 1 → 20 800€, 250L/j, 25 HT/j
T9.2 — Fabriquer fromage 100L lait → 10kg fromage + 3.75L crème, 9€ charges
T9.3 — Fabriquer avec lait d'un autre joueur → ERREUR 400 "Lait propre uniquement"
T9.4 — Qualité : compétences 80/80/80 + hygiene 100% → indices élevés
T9.5 — Qualité : compétences 80/80/80 + hygiene 30% → indices dégradés
T9.6 — Affinage Pâte Pressée Cuite 84 jours → qualité max (+20%)
T9.7 — Affinage Pâte Pressée Cuite 21 jours → qualité base
T9.8 — DLC expirée → fromage supprimé
T9.9 — Crème → beurre : 1L crème → 0.480 kg beurre, DLC 18j
T9.10 — Nettoyage → hygiene_pct=100, fromagerie indisponible 1 jour
T9.11 — Formation → +60 pts répartis, coût 1 000€
T9.12 — Dépasser capacité 1250L/j → ERREUR 400
T9.13 — Lait non transformé dans la journée → perdu
```

---

## Feature 10 — Fromagerie industrielle

### 10.1 Description

Version grande échelle : 198 000-910 000€, 2 200-11 000 L/jour, 2-10 fromagers employés (22 HT/jour chacun, compétences variables). Vente aux grossistes et centrales d'achat uniquement (pas de marchés). 9 modèles. Déblocage ~1.80€.

### 10.2 Schéma BDD

```sql
-- Réutilise cheese_factory avec type='industrial'
-- Modèles industriels (model 1-9)
-- capacity_l : 2200, 3300, 4400, 5500, 6600, 7700, 8800, 9900, 11000
-- cost : 198000, 286000, 374000, 462000, 550000, 638000, 726000, 814000, 910000
-- ht_max_day : 220

CREATE TABLE cheese_factory_model (
  id          SERIAL PRIMARY KEY,
  type        VARCHAR(15) NOT NULL,
  model       SMALLINT NOT NULL,
  capacity_l  INT NOT NULL,
  cost        DECIMAL(12,2) NOT NULL,
  ht_max_day  SMALLINT NOT NULL,
  max_employees SMALLINT NOT NULL,
  UNIQUE(type, model)
);

INSERT INTO cheese_factory_model (type, model, capacity_l, cost, ht_max_day, max_employees) VALUES
  ('artisan', 1, 250, 20800, 25, 1),
  ('artisan', 2, 500, 39600, 25, 1),
  ('artisan', 3, 750, 58400, 25, 1),
  ('artisan', 4, 1000, 79200, 25, 1),
  ('artisan', 5, 1250, 100000, 25, 1),
  ('industrial', 1, 2200, 198000, 220, 2),
  ('industrial', 2, 3300, 286000, 220, 3),
  ('industrial', 3, 4400, 374000, 220, 4),
  ('industrial', 4, 5500, 462000, 220, 5),
  ('industrial', 5, 6600, 550000, 220, 6),
  ('industrial', 6, 7700, 638000, 220, 7),
  ('industrial', 7, 8800, 726000, 220, 8),
  ('industrial', 8, 9900, 814000, 220, 9),
  ('industrial', 9, 11000, 910000, 220, 10);

-- Fromagers employés (industriel)
-- Réutilise cheese_maker_skill avec employee_id NOT NULL
-- Embauche : compétences aléatoires, salaire variable
-- 22 HT/jour chacun
```

### 10.3 Logique métier

```
Création fromagerie industrielle :
1. Vérifier activity_unlock('cheese_industrial')
2. Choisir modèle (1-9), payer cost
3. Embaucher 2-10 fromagers (employee role='cheese_maker', pa=22)
4. Compétences fromagers : aléatoires à l'embauche, évoluent avec pratique

Vente grossistes/centrales :
1. Max 4 visites/jour, 1-4 HT/visite, max 16 HT total/jour
2. Horaires : 06h-22h
3. Grossistes : négociation prix possible
4. Centrales : prix fixe
5. Paramètres vente : enseigne, météo, saison, fidélisation, moral

Agrandissement :
1. Passer au modèle supérieur (payer différence)
2. Pas de changement artisanale ↔ industrielle (destruction obligatoire)
```

### 10.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/cheese-factory/create-industrial` | Créer fromagerie industrielle | 0 |
| POST | `/api/cheese-factory/upgrade` | Agrandir (modèle supérieur) | 0 |
| POST | `/api/cheese-factory/hire-maker` | Embaucher fromager | 0 |
| POST | `/api/cheese-factory/sell-wholesale` | Vendre à grossiste (body: product_ids, wholesaler_id) | 1-4 |
| GET | `/api/wholesalers` | Liste grossistes/centrales | 0 |

### 10.5 Tests

```
T10.1 — Créer industrielle modèle 1 → 198 000€, 2200L/j, 2 fromagers max
T10.2 — Embaucher 3e fromager modèle 1 → ERREUR 400 "Max 2 employés"
T10.3 — Agrandir modèle 1→2 → payer 88 000€ différence, capacity=3300
T10.4 — Vendre à grossiste → prix négocié, fidélisation incrémentée
T10.5 — 5e visite/jour → ERREUR 400 "Max 4 visites/jour"
T10.6 — Vendre sur marché (industrielle) → ERREUR 400 "Grossistes uniquement"
T10.7 — Fromager compétences évoluent après 30 fabrications → +1 sur compétence principale
```

---

## Feature 11 — Marchés

### 11.1 Description

Marchés physiques pour vente directe (fromage artisanal, œufs, foie gras, légumes). 3 tailles, 3 niveaux de clientèle. Influencés par météo, saison, fidélisation, moral. Max 4 marchés/jour, 1-4 HT chacun. Nécessite utilitaire + kit exposant (2 500€). Redevance annuelle par marché.

### 11.2 Schéma BDD

```sql
-- market déjà dans 01_DATA_MODEL, enrichi
CREATE TABLE market_stand (
  id              SERIAL PRIMARY KEY,
  market_id       INT NOT NULL REFERENCES market(id),
  player_id       INT NOT NULL REFERENCES player(id),
  annual_fee_paid BOOLEAN NOT NULL DEFAULT false,
  loyalty_score   DECIMAL(5,2) NOT NULL DEFAULT 0,  -- fidélisation 0-100
  visits_count    INT NOT NULL DEFAULT 0,
  UNIQUE(market_id, player_id)
);

CREATE TABLE market_sale (
  id              SERIAL PRIMARY KEY,
  stand_id        INT NOT NULL REFERENCES market_stand(id),
  product_type    VARCHAR(30) NOT NULL,  -- 'cheese','eggs','foie_gras','vegetables'
  product_id      INT,                    -- FK polymorphe vers cheese_product, etc.
  quantity        DECIMAL(10,2) NOT NULL,
  unit_price      DECIMAL(10,2) NOT NULL,
  total_price     DECIMAL(12,2) NOT NULL,
  weather_bonus   DECIMAL(4,2) NOT NULL DEFAULT 1.0,
  season_bonus    DECIMAL(4,2) NOT NULL DEFAULT 1.0,
  loyalty_bonus   DECIMAL(4,2) NOT NULL DEFAULT 1.0,
  sold_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE market_visit (
  id              SERIAL PRIMARY KEY,
  player_id       INT NOT NULL REFERENCES player(id),
  market_id       INT NOT NULL REFERENCES market(id),
  pa_spent        DECIMAL(4,2) NOT NULL,
  game_day        INT NOT NULL,
  visited_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 11.3 Logique métier

```
Vente sur marché :
1. Vérifier utilitaire disponible + kit exposant acheté
2. Vérifier redevance annuelle payée pour ce marché
3. Vérifier < 4 marchés aujourd'hui, HT suffisants (1-4 HT)
4. Calculer quantité vendue :
   base = taille_marché × clientèle × qualité_produit
   × weather_bonus (soleil=1.3, pluie=0.7)
   × season_bonus (été=1.2, hiver=0.8 pour fromage ; inverse pour foie gras)
   × loyalty_bonus (1.0 + visits_count × 0.005, max 1.5)
   × moral_bonus (0.8-1.2)
   × position_bonus (arriver tôt = meilleur emplacement)
5. Prix fixé par le joueur (rapport qualité/prix influence la demande)
6. Foie gras : ~10 kg/marché en fin d'année, ~1 kg/marché le reste

Fidélisation :
1. Chaque visite : loyalty_score += 1 (max 100)
2. Absence > 1 mois : loyalty_score -= 5
3. loyalty_bonus = 1.0 + (loyalty_score / 200)

Taille marché (1-3) : multiplicateur base ventes ×1, ×2, ×3
Clientèle (1-3) : pouvoir d'achat ×0.8, ×1.0, ×1.3
```

### 11.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| GET | `/api/markets?prefecture_id=X` | Marchés disponibles | 0 |
| POST | `/api/markets/:id/register` | S'inscrire + payer redevance | 0 |
| POST | `/api/markets/:id/sell` | Vendre produits (body: products[]) | 1-4 |
| GET | `/api/markets/my-stands` | Mes emplacements | 0 |
| GET | `/api/markets/:id/history` | Historique ventes | 0 |

### 11.5 Tests

```
T11.1 — Vendre sans kit exposant → ERREUR 400
T11.2 — Vendre sans redevance → ERREUR 400
T11.3 — Vendre fromage marché taille 3, clientèle 3, soleil → ventes élevées
T11.4 — Vendre fromage marché taille 1, pluie → ventes faibles
T11.5 — 5e marché du jour → ERREUR 400 "Max 4 marchés/jour"
T11.6 — Fidélisation : 50 visites → loyalty_bonus = 1.25
T11.7 — Foie gras fin d'année → ~10 kg vendus
T11.8 — Foie gras hors saison → ~1 kg vendu
T11.9 — Fromage industriel sur marché → ERREUR 400 "Artisanal uniquement"
```

---

## Feature 12 — Huilerie CAR

### 12.1 Description

Gérée par une CAR. Transforme colza ou tournesol en HVC (bio-carburant) + tourteau. Équipements : silo HVC, trieur, vis, presse (à vis ou barreaux), cuve décantation, filtre, stockage. Rendements : colza 0.336-0.420 L HVC/kg, tournesol 0.280-0.350 L/kg.

### 12.2 Schéma BDD

```sql
CREATE TABLE oil_mill (
  id          SERIAL PRIMARY KEY,
  car_id      INT NOT NULL REFERENCES coop_regional(id) UNIQUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE oil_mill_equipment (
  id              SERIAL PRIMARY KEY,
  oil_mill_id     INT NOT NULL REFERENCES oil_mill(id),
  equipment_type  VARCHAR(30) NOT NULL CHECK (equipment_type IN (
    'hvc_silo','sorter','screw','press_screw','press_bar',
    'settling_tank','filter','hvc_storage'
  )),
  capacity        DECIMAL(12,2) NOT NULL,
  wear_pct        DECIMAL(5,2) NOT NULL DEFAULT 0,
  installed_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(oil_mill_id, equipment_type)
);

CREATE TABLE oil_mill_batch (
  id              SERIAL PRIMARY KEY,
  oil_mill_id     INT NOT NULL REFERENCES oil_mill(id),
  input_product   VARCHAR(20) NOT NULL CHECK (input_product IN ('rapeseed','sunflower')),
  input_kg        DECIMAL(12,2) NOT NULL,
  input_quality   SMALLINT NOT NULL CHECK (input_quality BETWEEN 1 AND 3),
  hvc_liters      DECIMAL(12,2) NOT NULL,
  meal_kg         DECIMAL(12,2) NOT NULL,  -- tourteau
  processed_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 12.3 Logique métier

```
Rendements pressage (bonne qualité) :
- Colza : 0.336-0.420 L HVC/kg + 0.496-0.620 kg tourteau/kg
- Tournesol : 0.280-0.350 L HVC/kg + 0.520-0.650 kg tourteau/kg
- Qualité matière première influence rendement :
  Q1 (mauvaise) : rendement × 0.80
  Q2 (moyenne) : rendement × 0.90
  Q3 (bonne) : rendement × 1.00

Prix vente :
- HVC via CAR : 0.36-0.55 €/L (fixé par Chambre Agricole régionale)
- HVC via Le Marché Central : 0.60 €/L
- Tourteau : 150 €/t + prime selon taux MG résiduel

Transport HVC : camion citerne uniquement, chauffeur licence MD
```

### 12.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/car/:id/oil-mill/create` | Créer huilerie | 0 |
| POST | `/api/car/:id/oil-mill/process` | Presser (body: product, quantity_kg) | 2-5 |
| GET | `/api/car/:id/oil-mill/stock` | Stock HVC + tourteau | 0 |
| POST | `/api/car/:id/oil-mill/sell-hvc` | Vendre HVC | 1 |

### 12.5 Tests

```
T12.1 — Presser 1000kg colza Q3 → 336-420L HVC + 496-620kg tourteau
T12.2 — Presser 1000kg tournesol Q3 → 280-350L HVC + 520-650kg tourteau
T12.3 — Presser colza Q1 → rendement × 0.80
T12.4 — Vendre HVC à 0.45€/L → OK (dans fourchette Chambre Agricole)
T12.5 — Vendre HVC à 0.60€/L → ERREUR (prix Chambre Agricole max 0.55)
T12.6 — Transport HVC sans licence MD → ERREUR 400
```

---

## Feature 13 — Sucrerie CAR

### 13.1 Description

Gérée par une CAR. 10 niveaux (3M€ base + 500k/niveau). Transforme betterave en sucre (160 kg/t), pulpe déshydratée (50 kg/t), mélasse (30 kg/t), écume (30 kg/t). Campagne octobre→mars. Délai transformation 7 jours après livraison.

### 13.2 Schéma BDD

```sql
CREATE TABLE sugar_factory (
  id          SERIAL PRIMARY KEY,
  car_id      INT NOT NULL REFERENCES coop_regional(id) UNIQUE,
  level       SMALLINT NOT NULL DEFAULT 1 CHECK (level BETWEEN 1 AND 10),
  capacity_t_day DECIMAL(10,2) NOT NULL,  -- tonnes/jour, augmente avec level
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sugar_batch (
  id              SERIAL PRIMARY KEY,
  factory_id      INT NOT NULL REFERENCES sugar_factory(id),
  input_beet_kg   DECIMAL(12,2) NOT NULL,
  input_quality   SMALLINT NOT NULL CHECK (input_quality BETWEEN 1 AND 3),
  sugar_kg        DECIMAL(12,2) NOT NULL,
  pulp_kg         DECIMAL(12,2) NOT NULL,
  molasses_kg     DECIMAL(12,2) NOT NULL,
  scum_kg         DECIMAL(12,2) NOT NULL,
  delivered_at    TIMESTAMPTZ NOT NULL,
  must_process_by TIMESTAMPTZ NOT NULL,  -- delivered_at + 7 jours
  processed_at    TIMESTAMPTZ,
  status          VARCHAR(20) NOT NULL DEFAULT 'pending'
);
```

### 13.3 Logique métier

```
Investissement :
- Niveau 1 : 3 000 000 €
- Chaque niveau supplémentaire : +500 000 €
- Niveau 10 : 3M + 9×500k = 7 500 000 €

Rendements (par tonne de betterave bonne qualité) :
- Sucre : 160 kg
- Pulpe déshydratée : 50 kg
- Mélasse : 30 kg
- Écume de sucrerie : 30 kg
- Qualité betterave influence rendement (Q1 ×0.80, Q2 ×0.90, Q3 ×1.00)

Campagne : octobre → mars (mois Cultivia 10-3)
Délai : betteraves livrées doivent être transformées sous 7 jours sinon perte

Prix vente :
- Sucre : 670 €/t (contrats usines)
- Mélasse : 120 €/t (contrats usines)
- Pulpe déshydratée : 180 €/t (joueurs)
- Écume : 5.80 €/t (joueurs, épandage calcique)
```

### 13.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/car/:id/sugar-factory/create` | Créer sucrerie (3M€) | 0 |
| POST | `/api/car/:id/sugar-factory/upgrade` | Monter de niveau (+500k) | 0 |
| POST | `/api/car/:id/sugar-factory/process` | Transformer betteraves | 3 |
| GET | `/api/car/:id/sugar-factory/stock` | Stock produits | 0 |
| POST | `/api/car/:id/sugar-factory/sell` | Vendre produits | 1 |

### 13.5 Tests

```
T13.1 — Créer sucrerie → 3 000 000€ débités, level=1
T13.2 — Upgrade level 2 → 500 000€, level=2
T13.3 — Transformer 1000kg betterave Q3 → 160kg sucre, 50kg pulpe, 30kg mélasse, 30kg écume
T13.4 — Transformer betterave Q1 → rendements × 0.80
T13.5 — Betterave non transformée après 7j → status='expired', perte
T13.6 — Transformer en juillet → ERREUR 400 "Hors campagne (oct-mars)"
T13.7 — Vendre sucre → 670 €/t
```

---

## Feature 14 — Laiterie CAR

### 14.1 Description

Gérée par une CAR. Contrats producteurs (volume, QL, prix, durée 1 saison), collecte par transporteur, transformation en yaourt/UHT/frais/fromage/poudre. Commerciaux prospectent clients (restauration, grossiste, industriel). Lignes de production à 3.20€/L de capacité.

### 14.2 Schéma BDD

```sql
CREATE TABLE dairy (
  id              SERIAL PRIMARY KEY,
  car_id          INT NOT NULL REFERENCES coop_regional(id) UNIQUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE dairy_line (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  product         VARCHAR(30) NOT NULL CHECK (product IN ('yogurt','fresh_milk','uht','cheese','powder')),
  capacity_l      INT NOT NULL,          -- max L/jour
  equipment_level SMALLINT NOT NULL DEFAULT 1 CHECK (equipment_level BETWEEN 1 AND 5),
  cost            DECIMAL(12,2) NOT NULL, -- capacity_l × 3.20
  UNIQUE(dairy_id, product)
);

CREATE TABLE dairy_contract (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  producer_id     INT NOT NULL REFERENCES player(id),
  transporter_id  INT REFERENCES player(id),
  volume_monthly  DECIMAL(10,2) NOT NULL,  -- litres/mois
  ql_min          DECIMAL(5,2),
  ql_max          DECIMAL(5,2),
  price_per_1000l DECIMAL(8,2) NOT NULL,
  milk_type       VARCHAR(10) NOT NULL CHECK (milk_type IN ('cow','goat','sheep')),
  is_bio          BOOLEAN NOT NULL DEFAULT false,
  start_at        TIMESTAMPTZ NOT NULL,
  end_at          TIMESTAMPTZ NOT NULL,    -- 1 saison = 84 jours
  status          VARCHAR(20) NOT NULL DEFAULT 'active',
  months_failed   SMALLINT NOT NULL DEFAULT 0,  -- 3 consécutifs ou cumulés = rupture
  UNIQUE(dairy_id, producer_id, milk_type)
);

CREATE TABLE dairy_transport_contract (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  transporter_id  INT NOT NULL REFERENCES player(id),
  duration_months SMALLINT NOT NULL CHECK (duration_months BETWEEN 1 AND 12),
  rate_per_trip   DECIMAL(8,2) NOT NULL,
  start_at        TIMESTAMPTZ NOT NULL,
  status          VARCHAR(20) NOT NULL DEFAULT 'active'
);

CREATE TABLE dairy_product_batch (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  line_id         INT NOT NULL REFERENCES dairy_line(id),
  product         VARCHAR(30) NOT NULL,
  quantity_l      DECIMAL(10,2) NOT NULL,
  quality         SMALLINT CHECK (quality BETWEEN 1 AND 3),
  dlc             TIMESTAMPTZ NOT NULL,
  produced_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  status          VARCHAR(20) NOT NULL DEFAULT 'in_stock'
);
-- DLC : yaourt 7j, frais 5j, UHT 25j, fromage 11j, poudre 84j

CREATE TABLE dairy_client (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  client_type     VARCHAR(20) NOT NULL CHECK (client_type IN ('restaurant','wholesaler','industrial')),
  name            VARCHAR(100) NOT NULL,
  loyalty         DECIMAL(5,2) NOT NULL DEFAULT 0,
  prospected_at   TIMESTAMPTZ
);

CREATE TABLE dairy_sales_contract (
  id              SERIAL PRIMARY KEY,
  dairy_id        INT NOT NULL REFERENCES dairy(id),
  client_id       INT NOT NULL REFERENCES dairy_client(id),
  product         VARCHAR(30) NOT NULL,
  quantity_monthly DECIMAL(10,2) NOT NULL,
  quality_min     SMALLINT,
  price_per_unit  DECIMAL(8,2) NOT NULL,
  duration_months SMALLINT NOT NULL,
  status          VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 14.3 Logique métier

```
Contrat producteur :
1. Durée 1 saison (84 jours)
2. Volume mensuel, QL min/max, prix €/1000L
3. Paiement à la livraison du lait
4. Rupture si 3 mois consécutifs ou 3 mois cumulés de non-respect volume
5. Renégociation possible 1 mois avant terme

Transport lait :
1. Semi citerne lait + tracteur routier, ou porteur citerne lait
2. Contrat transport : 1-12 mois, tarif fixé par laiterie
3. Non-livraison → perte contrat mois suivant

Transformation :
- Ligne de production : coût = capacity_l × 3.20 €
- Max 1 000 000 L/jour par ligne
- DLC : yaourt 7j, frais 5j, UHT 25j, fromage 11j, poudre 84j

Commercialisation :
1. Embaucher commerciaux (2 310 €/mois, 22 HT/jour)
2. Prospection : 4 HT/commercial par tentative
3. Contrat client : création 3 HT, renégociation 2 HT
4. Clients : restauration, grossiste, industriel
5. Contrat = produit, quantité, qualité, durée, prix
```

### 14.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/car/:id/dairy/create` | Créer laiterie | 0 |
| POST | `/api/car/:id/dairy/add-line` | Ajouter ligne production | 0 |
| POST | `/api/car/:id/dairy/contract-producer` | Contrat producteur | 2 |
| POST | `/api/car/:id/dairy/contract-transport` | Contrat transporteur | 1 |
| POST | `/api/car/:id/dairy/process` | Transformer lait | 2-5 |
| POST | `/api/car/:id/dairy/hire-commercial` | Embaucher commercial | 0 |
| POST | `/api/car/:id/dairy/prospect` | Prospecter client | 4 |
| POST | `/api/car/:id/dairy/sell-contract` | Créer contrat vente | 3 |
| GET | `/api/car/:id/dairy/stock` | Stock produits | 0 |

### 14.5 Tests

```
T14.1 — Créer laiterie → OK
T14.2 — Ajouter ligne yaourt 100 000L → coût 320 000€
T14.3 — Contrat producteur : 50 000L/mois, QL 60-100, 320€/1000L → OK
T14.4 — Producteur livre 30 000L (< 50 000) → months_failed += 1
T14.5 — 3 mois failed → contrat rompu automatiquement
T14.6 — Transformer 10 000L lait → yaourt, DLC 7 jours
T14.7 — DLC expirée → produit perdu
T14.8 — Prospecter client → 4 HT commercial, client créé ou refus
T14.9 — Contrat vente : yaourt 5000L/mois, 3 mois → OK
T14.10 — Ligne capacité dépassée → ERREUR 400
```

---

## Feature 15 — Culture BIO

### 15.1 Description

Conversion d'une parcelle en BIO : 2 saisons de conversion (pas de vente BIO pendant), +20% prix de vente après conversion, rotation allongée +1 an, aucun traitement phytosanitaire autorisé (pas d'herbicide, fongicide, insecticide). Engrais chimiques interdits (fumier/lisier/compost uniquement).

### 15.2 Schéma BDD

```sql
-- Colonnes existantes sur parcel : is_bio, bio_conversion_start
-- Ajout table de suivi conversion
CREATE TABLE bio_conversion (
  id                  SERIAL PRIMARY KEY,
  parcel_id           INT NOT NULL REFERENCES parcel(id) UNIQUE,
  started_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  converts_at         TIMESTAMPTZ NOT NULL,  -- started_at + 2 saisons (168 jours)
  completed           BOOLEAN NOT NULL DEFAULT false,
  violation_count     SMALLINT NOT NULL DEFAULT 0  -- traitements interdits appliqués
);

-- Ajout sur crop
-- crop.is_bio déjà dans le modèle
-- Contrainte : si parcel.is_bio = true → crop.treated_* doit rester false
```

### 15.3 Logique métier

```
Conversion BIO parcelle :
1. Joueur lance conversion sur parcelle
2. bio_conversion_start = now()
3. Durée : 2 saisons Cultivia = 168 jours (2 × 84)
4. Pendant conversion : culture normale mais pas de label BIO
5. Après conversion : parcel.is_bio = true

Contraintes BIO cultures :
1. Traitements phyto INTERDITS :
   - Herbicide → ERREUR 400 "Interdit en BIO"
   - Fongicide → ERREUR 400
   - Insecticide → ERREUR 400
2. Engrais chimiques INTERDITS :
   - Seuls autorisés : fumier, lisier, compost, digestat, écume
3. Rotation : +1 an par rapport au conventionnel
   - Blé : 1 an → 2 ans en BIO
   - Maïs : 2 ans → 3 ans en BIO
   - Betterave : 4 ans → 5 ans en BIO
4. Prix vente : +20% par rapport au conventionnel
5. Semences : type GP uniquement (pas de G ou P séparé)

Perte label BIO :
1. Si traitement phyto appliqué → violation_count += 1
2. Si violation_count >= 1 → parcel.is_bio = false, conversion annulée
3. Nouvelle conversion possible après 1 saison de "purge"
```

### 15.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/parcels/:id/convert-bio` | Lancer conversion BIO | 1 |
| GET | `/api/parcels/:id/bio-status` | Statut conversion | 0 |
| POST | `/api/parcels/:id/cancel-bio` | Annuler conversion | 0 |

### 15.5 Tests

```
T15.1 — Lancer conversion → bio_conversion créée, converts_at = +168 jours
T15.2 — Après 168 jours → parcel.is_bio=true, completed=true
T15.3 — Vendre blé BIO → prix × 1.20
T15.4 — Traiter herbicide sur parcelle BIO → ERREUR 400 "Interdit en BIO"
T15.5 — Épandre engrais chimique sur BIO → ERREUR 400
T15.6 — Épandre fumier sur BIO → OK
T15.7 — Rotation blé BIO : semer après 1 an → ERREUR 400 "Rotation BIO = 2 ans"
T15.8 — Rotation blé BIO : semer après 2 ans → OK
T15.9 — Violation (traitement appliqué par erreur) → is_bio=false, conversion annulée
T15.10 — Pendant conversion : vendre récolte → prix conventionnel (pas de prime BIO)
```

---

## Feature 16 — Élevage BIO

### 16.1 Description

Conversion d'animaux en BIO avec contraintes par espèce : âge min/max, pourcentage minimum de plein air, tolérance limitée en jours non-BIO. Alimentation BIO obligatoire (aliments issus de parcelles BIO). Prix lait BIO : +20% (voir grille QL BIO).

### 16.2 Schéma BDD

```sql
CREATE TABLE bio_livestock_rules (
  id              SERIAL PRIMARY KEY,
  species_id      INT NOT NULL REFERENCES animal_species(id) UNIQUE,
  age_min_months  SMALLINT NOT NULL,
  age_max_months  SMALLINT NOT NULL,
  outdoor_min_pct DECIMAL(5,2) NOT NULL,  -- % minimum plein air
  outdoor_type    VARCHAR(20) NOT NULL,    -- 'pasture','park'
  tolerance_days  SMALLINT NOT NULL        -- jours max non-BIO tolérés
);

INSERT INTO bio_livestock_rules (species_id, age_min_months, age_max_months,
  outdoor_min_pct, outdoor_type, tolerance_days)
VALUES
  ((SELECT id FROM animal_species WHERE name='cattle'), 6, 96, 50, 'pasture', 12),
  ((SELECT id FROM animal_species WHERE name='goat'), 3, 60, 25, 'pasture', 6),
  ((SELECT id FROM animal_species WHERE name='sheep'), 3, 60, 50, 'pasture', 6),
  ((SELECT id FROM animal_species WHERE name='pig'), 6, 24, 50, 'park', 4),
  ((SELECT id FROM animal_species WHERE name='rabbit'), 3, 24, 100, 'park', 2),
  ((SELECT id FROM animal_species WHERE name='poultry'), 6, 24, 100, 'park', 4),
  ((SELECT id FROM animal_species WHERE name='guinea_fowl'), 6, 24, 100, 'park', 6),
  ((SELECT id FROM animal_species WHERE name='goose'), 6, 36, 100, 'park', 4),
  ((SELECT id FROM animal_species WHERE name='duck'), 6, 36, 100, 'park', 4);
-- Bisons, daims, chevaux : non éligibles BIO

CREATE TABLE bio_livestock_tracking (
  id              SERIAL PRIMARY KEY,
  animal_id       BIGINT NOT NULL REFERENCES animal(id) UNIQUE,
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  outdoor_days    INT NOT NULL DEFAULT 0,
  indoor_days     INT NOT NULL DEFAULT 0,
  non_bio_days    INT NOT NULL DEFAULT 0,  -- jours avec aliments non-BIO
  is_certified    BOOLEAN NOT NULL DEFAULT false,
  lost_at         TIMESTAMPTZ  -- date perte label si violation
);
```

### 16.3 Logique métier

```
Conversion animal BIO :
1. Vérifier espèce éligible (pas bison, daim, cheval)
2. Vérifier âge dans bornes [age_min_months, age_max_months]
3. Créer bio_livestock_tracking
4. Animal nourri exclusivement avec aliments BIO (issus de parcelles BIO)

Suivi quotidien (daily tick) :
1. Pour chaque animal en conversion BIO :
   a. Si location_type IN ('pasture','park') : outdoor_days += 1
   b. Sinon : indoor_days += 1
   c. Si nourri avec aliments non-BIO : non_bio_days += 1
   d. Vérifier outdoor_pct = outdoor_days / (outdoor_days + indoor_days) × 100
   e. Si outdoor_pct < outdoor_min_pct ET age > 3 mois : avertissement
   f. Si non_bio_days > tolerance_days : perte label BIO
      - animal.is_bio = false
      - bio_livestock_tracking.lost_at = now()

Certification :
1. Après période de conversion (variable, ~1 saison de suivi)
2. Si outdoor_pct >= outdoor_min_pct ET non_bio_days <= tolerance_days :
   - animal.is_bio = true
   - is_certified = true

Prix lait BIO (€/1000L) :
- Bovins : 318-480 (vs 265-400 conventionnel) = +20%
- Caprins : 660-768 (vs 550-640) = +20%
- Ovins : 1020-1128 (vs 850-940) = +20%

Vente viande BIO : +20% prix abattoir
```

### 16.4 API Endpoints

| Méthode | Endpoint | Description | HT |
|---------|----------|-------------|-----|
| POST | `/api/animals/:id/convert-bio` | Lancer conversion BIO | 0 |
| GET | `/api/animals/:id/bio-status` | Statut BIO (outdoor%, non_bio_days) | 0 |
| POST | `/api/animals/:id/cancel-bio` | Annuler conversion | 0 |

### 16.5 Tests

```
T16.1 — Convertir bovin 12 mois → tracking créé, age OK (6-96)
T16.2 — Convertir bovin 3 mois → ERREUR 400 "Âge min 6 mois"
T16.3 — Convertir bison → ERREUR 400 "Espèce non éligible BIO"
T16.4 — Bovin BIO : 60% pâturage → outdoor_pct OK (≥50%)
T16.5 — Bovin BIO : 30% pâturage → avertissement, risque perte label
T16.6 — Nourrir animal BIO avec aliments non-BIO → non_bio_days += 1
T16.7 — Bovin BIO : 13 jours non-BIO → perte label (tolérance 12)
T16.8 — Lapin BIO : 100% parc obligatoire → vérifier outdoor_pct=100
T16.9 — Vendre lait bovin BIO QL 50 → 384 €/1000L (vs 320 conventionnel)
T16.10 — Vendre viande BIO → prix abattoir × 1.20
T16.11 — Porcin BIO : max 24 mois → au-delà, perte éligibilité
```

---

## Annexe A — Daily Tick Phase 4

```
DAILY TICK — Ajouts Phase 4
============================

1. ANIMAUX (toutes espèces Phase 4)
   a. Croissance : poids += f(ration, qualité, génétique)
   b. Vieillissement : age_days += 1
   c. Vérif nourriture : si last_fed_at < hier → days_unfed += 1
      - days_unfed >= 3 → is_sick = true
      - days_unfed >= 7 → animal meurt (DELETE + notification)
   d. Production lait (caprins, ovins) : si adulte + nourri + salle traite
   e. Production œufs (volailles, canards) : si adulte + nourri + conditionnement
   f. Gestation : si pregnant_until <= now() → mise bas
      - Créer petits (nombre = random(offspring_min, offspring_max) × indice prolificité)
      - Génétique héritée (Feature 8)
   g. Reproduction saisonnière :
      - Pintades : cycles automatiques mars→août
      - Oies : cycles automatiques mars→juin
   h. Duvet oies : si last_down_collect + 14 jours → collecte possible
   i. Litière : si paille insuffisante → risque maladie
   j. Usure bâtiments élevage

2. GÉNÉTIQUE
   a. Recalculer genetic_value pour animaux adultes nés à la ferme
   b. Mettre à jour genetic_threshold (max/avg par race/serveur)

3. CONCESSIONNAIRE
   a. Salaires mécaniciens (1 400€/mois, prélevé le 1er du mois)
   b. Salaires vendeurs
   c. Retraite mécaniciens (vérifier âge >= 60 ans Cultivia)
   d. Formation : si training_until <= now() → compétence +1

4. PANNES
   a. Pour chaque véhicule utilisé : usure pièces
   b. Si pièce.wear_pct >= 100% → vehicle.is_broken = true

5. GPS
   a. Vérifier abonnements expirés → désactiver bonus

6. CIA
   a. Salaire inséminateur (1 600€/mois)

7. FROMAGERIE
   a. Affinage : avancer compteur, si aging_end <= now() → status='ready', DLC démarre
   b. DLC : si dlc <= now() → status='expired' (DELETE produit)
   c. Compétences fromager : +0.1 par fromage fabriqué hier (cap 100)
   d. Hygiène/matériel : dégradation quotidienne si utilisée

8. MARCHÉS
   a. Fidélisation : si pas de visite depuis 1 mois → loyalty_score -= 5

9. HUILERIE / SUCRERIE
   a. Sucrerie : vérifier betteraves non transformées > 7j → perte

10. LAITERIE
    a. Vérifier contrats producteurs : volume mensuel atteint ?
    b. DLC produits laitiers : yaourt 7j, frais 5j, UHT 25j, fromage 11j, poudre 84j
    c. Salaires employés/commerciaux

11. BIO
    a. Cultures : vérifier conversion (168 jours écoulés → parcel.is_bio = true)
    b. Élevage : outdoor_days/indoor_days tracking
    c. Élevage : vérifier non_bio_days vs tolérance → perte label si dépassé

12. ÉCONOMIE (fin d'année = 7 Décembre)
    a. Reversement CA concessionnaires (neuf × rebate_pct)
    b. Droits d'entrée constructeurs (prélevés)
    c. Bénéfices CAR (huilerie, sucrerie, laiterie)
```

---

## Annexe B — Constantes Phase 4

```typescript
// === ESPÈCES ===
export const SPECIES_MATURITY = {
  goat: { months: 12, max_insem_day: 2 },
  sheep: { months: 12, max_insem_day: 2 },
  pig: { months: 12, max_insem_day: 3 },
  poultry: { months: 6, max_insem_day: 5 },
  rabbit: { months: 3, max_insem_day: 5 },
  guinea_fowl: { months: 9, max_insem_day: 5 },
  goose: { months: 6, max_insem_day: 4 },
  duck: { months: 6, max_insem_day: 8 },
} as const;

export const GESTATION_MONTHS = {
  goat: 5, sheep: 5, pig: 4, poultry: 1, rabbit: 1,
  guinea_fowl: 1, goose: 0, duck: 0, // oies/canards = ponte/couvaison
} as const;

export const POST_BIRTH_DELAY_MONTHS = {
  goat: 6, sheep: 7, pig: 1, poultry: 0, rabbit: 1,
} as const;

export const SLAUGHTER_YIELD = {
  goat: [0.45, 0.50], sheep: [0.45, 0.50], pig: [0.72, 0.80],
  poultry: [0.60, 0.65], rabbit: [0.55, 0.63],
  guinea_fowl: [0.60, 0.65], goose: [0.60, 0.65], duck: [0.60, 0.65],
} as const;

// === BREEDING SEASONS ===
export const BREEDING_SEASON = {
  guinea_fowl: { months: [3], cycles: 6, incubation_days: 7 },
  goose: { months: [1, 2], cycles: 3, incubation_days: 9 },
  duck: { months: [4], cycles: 1, incubation_days: 7, barbarie_days: 9 },
} as const;

// === SURFACES (m²) ===
export const HOUSING_AREA = {
  goat:   { male: 7, female: 5, young: 4, baby: 2 },
  sheep:  { male: 7, female: 5, young: 4, baby: 2 },
  pig:    { male: 5, female: 4, young: 2, baby: 0.5 },
  poultry:{ male: 0.1, female: 0.1, young: 0.07, baby: 0.01 },
  rabbit: { male: 1, female: 1, young: 0.5, baby: 0.2 },
  guinea_fowl: { male: 0.1, female: 0.1, young: 0.07, baby: 0.01 },
  goose:  { male: 0.5, female: 0.5, young: 0.3, baby: 0.15 },
  duck:   { male: 0.1, female: 0.1, young: 0.08, baby: 0.04 },
} as const;

export const PARK_AREA_PER_ANIMAL = 10; // m² pour semi-liberté

// === LITIÈRE (kg paille/jour) ===
export const LITTER_KG = {
  goat:   { male: 20, female: 15, young: 10, baby: 5 },
  sheep:  { male: 20, female: 15, young: 10, baby: 5 },
  pig:    { male: 15, female: 10, young: 5, baby: 5 },
  poultry:{ male: 0.5, female: 0.5, young: 0.3, baby: 0.1 },
  rabbit: { male: 2, female: 2, young: 1, baby: 0.5 },
  guinea_fowl: { male: 0.5, female: 0.5, young: 0.3, baby: 0.1 },
  goose:  { male: 1, female: 1, young: 0.6, baby: 0.2 },
  duck:   { male: 0.5, female: 0.5, young: 0.3, baby: 0.1 },
} as const;

// === CONCESSIONNAIRE ===
export const DEALERSHIP = {
  HALL_M2: 200,
  LICENSE_POINTS_TOTAL: 100,
  MECHANIC_SALARY: 1400,
  MECHANIC_PA: 25,
  MECHANIC_RETIREMENT_YEARS: 60,
  TRAINING_DAYS: 84,
  MAX_SPECIALIZATIONS: 3,
  MAINTENANCE_PA: { tool: 2, tractor: 4, harvester: 5 },
  PARTS_COST: { tool: 100, tractor: 300, harvester: 500 },
  LABOR_RATE_RANGE: [8, 24],
  PARTS_AGE_SURCHARGE_PCT: 2, // +2%/an
  SAME_DEALER_DISCOUNT_PCT: 10,
} as const;

// === GPS ===
export const GPS = {
  BEACON_COST: 20000,
  RECEIVER_COST: 3000,
  INSTALL_DEALER: [150, 300],
  INSTALL_COOP: 500,
  SUBSCRIPTION_RANGE: [400, 600],
  BONUS_PA_SOWING: 0.10,
  BONUS_PA_FERTILIZER: 0.10,
  BONUS_SEED_SAVING: 0.05,
  BONUS_PA_TREATMENT: 0.05,
} as const;

// === CIA ===
export const CIA_LAB_M2 = 50;
export const INSEMINATOR_SALARY = 1750;
export const INSEMINATOR_PA = 25;

// === GÉNÉTIQUE ===
export const GENETIC = {
  INDICES: ['growth','prolificacy','general_appearance','milk','milk_quality',
    'wool','egg','hatching','resistance','sociability','fertility','down',
    'physical','mental'],
  NAMING_THRESHOLD_PCT: 70,
  MUTATION_RANGE: [-5, 5],
  VALORIZATION_BONUS: [1,2,3,4,5,6,7,8,9,10], // % par tranche de 10
  INTER_PLAYER_EUR_PER_POINT: {
    cattle: 2, horse: 2, bison: 2,
    pig: 0.5, goat: 0.5, sheep: 0.5,
    deer: 0.25, goose: 0.03,
    rabbit: 0.01, poultry: 0.01, guinea_fowl: 0.01, duck: 0.01,
  },
} as const;

// === FROMAGERIE ===
export const CHEESE = {
  MILK_TO_CHEESE_KG: 0.1,    // 1L → 0.1kg
  MILK_TO_CREAM_L: 0.0375,   // 1L → 0.0375L crème
  CREAM_TO_BUTTER_KG: 0.480, // 1L crème → 0.480kg beurre
  CHARGES_PER_LITER: 0.09,
  ARTISAN_INITIAL_SKILL_POINTS: 240,
  ARTISAN_MAX_SKILL_POINTS: 300,
  TRAINING_COST: 1000,
  SKILL_GAIN_PER_CHEESE: 0.1,
  DLC: { soft_bloomy: 7, soft_washed: 7, pressed_cooked: 11,
    pressed_uncooked: 11, blue: 7, goat: 7, cream: 7, butter: 18 },
} as const;

// === MARCHÉS ===
export const MARKET = {
  MAX_VISITS_PER_DAY: 4,
  PA_PER_VISIT: [1, 4],
  KIT_COST: 2500,
  WEATHER_BONUS: { sun: 1.3, cloud: 1.0, rain: 0.7, storm: 0.5 },
  SEASON_BONUS_CHEESE: { spring: 1.0, summer: 1.2, autumn: 1.0, winter: 0.8 },
  FOIE_GRAS_KG: { end_year: 10, normal: 1 },
  LOYALTY_GAIN: 1,
  LOYALTY_DECAY: 5,
  LOYALTY_MAX: 100,
} as const;

// === HUILERIE ===
export const OIL_MILL = {
  RAPESEED_HVC_L_PER_KG: [0.336, 0.420],
  RAPESEED_MEAL_KG_PER_KG: [0.496, 0.620],
  SUNFLOWER_HVC_L_PER_KG: [0.280, 0.350],
  SUNFLOWER_MEAL_KG_PER_KG: [0.520, 0.650],
  QUALITY_FACTOR: { 1: 0.80, 2: 0.90, 3: 1.00 },
} as const;

// === SUCRERIE ===
export const SUGAR = {
  BASE_COST: 3000000,
  LEVEL_COST: 500000,
  MAX_LEVEL: 10,
  YIELD_PER_TON: { sugar_kg: 160, pulp_kg: 50, molasses_kg: 30, scum_kg: 30 },
  PRICES: { sugar: 670, molasses: 120, pulp: 180, scum: 5.80 },
  TRANSFORM_DEADLINE_DAYS: 7,
  CAMPAIGN_MONTHS: [10, 11, 12, 1, 2, 3],
} as const;

// === LAITERIE ===
export const DAIRY = {
  LINE_COST_PER_LITER: 3.20,
  MAX_LINE_CAPACITY: 1000000,
  EMPLOYEE_SALARY: 1750,
  COMMERCIAL_SALARY: 2310,
  COMMERCIAL_PA: 22,
  PROSPECT_PA: 4,
  CONTRACT_CREATE_PA: 3,
  CONTRACT_RENEGOTIATE_PA: 2,
  DLC: { yogurt: 7, fresh_milk: 5, uht: 25, cheese: 11, powder: 84 },
  MAX_FAILED_MONTHS: 3,
} as const;

// === BIO ===
export const BIO_CROP = {
  CONVERSION_DAYS: 168,  // 2 saisons
  PRICE_BONUS_PCT: 20,
  ROTATION_EXTRA_YEARS: 1,
} as const;

export const BIO_MILK_PRICE = {
  cow:   [318,330,342,354,366,384,408,432,456,480],
  goat:  [660,672,684,696,708,720,732,744,756,768],
  sheep: [1020,1032,1044,1056,1068,1080,1092,1104,1116,1128],
} as const;
```

---

> **Cultivia Clone — PHASE4_ACTIVITES.md — v1.0**
> 16 features, ~50 tables nouvelles/enrichies, tick quotidien étendu
> Source : 01_DATA_MODEL.md, 03_CONTENT_DATA.md, GDD/03_ELEVAGE.md, GDD/01_ECONOMIE.md
