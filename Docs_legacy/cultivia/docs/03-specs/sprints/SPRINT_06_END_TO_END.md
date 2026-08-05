# Sprint 06 — Reproduction + Naissances — Spec End-to-End

> Prérequis : Sprint 05. Le joueur a des animaux en bonne santé.
> Ce sprint ajoute : insémination (naturelle/CIA), gestation, naissance, arbre généalogique.

---

## Tables SQL nouvelles

```sql
-- animal_reproduction_log
-- Modif : animal (pregnant_until, mate_id, insemination_method)
-- Existantes : animal (parent_father_id, parent_mother_id, genetics)
```

---

## Flux 1 : Inséminer une vache (mâle de la ferme)

### Déclencheur

Fiche animal `/animals/:id` → femelle adulte → bouton "Inséminer" vert.

### Écran — Modale

```
┌──────────────────────────────────────────────────────────────┐
│ 🧬 Inséminer Marguerite                                      │
│                                                               │
│ Race : Prim'Holstein (Laitière) | Âge : 2 ans | ♀             │
│ État : Prête ✅ (période insémination : toute l'année)        │
│                                                               │
│ MÉTHODE                                                       │
│ ● Mâle de la ferme (0 € + 1.0 HT)                           │
│   [Taureau Royal ▼]                                          │
│   Génétique : Crois. 85 | Lait 70 | QL 75 | Prol. 60 | All. 72│
│                                                               │
│ ○ Insémination CIA (200 € + 1.0 HT)                          │
│   Génétique CIA : Crois. 90 | Lait 88 | QL 85 | Prol. 70 | All. 80│
│                                                               │
│ COMPARAISON                                                   │
│           | Marguerite | Taureau Royal | Descendance estimée   │
│ Croissance|    78      |     85        |    ~81 (±5)           │
│ Lait      |    91      |     70        |    ~80 (±5)           │
│ Qual. Lait|    72      |     75        |    ~73 (±5)           │
│ Prolific. |    52      |     60        |    ~56 (±5)           │
│ Allure    |    63      |     72        |    ~67 (±5)           │
│ TOTAL     |   356      |    362        |   ~357                │
│                                                               │
│ Gestation estimée : 9 mois Cultivia (63 jours réels)          │
│                                                               │
│ [Annuler]                    [Inséminer 1.0 HT]              │
└──────────────────────────────────────────────────────────────┘
```

**Bouton "Inséminer" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Femelle + adulte + pas gestante + en période + méthode choisie + HT >= 1.0 + (si CIA: solde >= 200) |
| 🔘 Grisé "Trop jeune (adulte requis)" | `life_stage != 'adult'` |
| 🔘 Grisé "Déjà gestante (mise bas dans {X}j)" | `pregnant_until IS NOT NULL` |
| 🔘 Grisé "Hors période ({mois_début}-{mois_fin})" | Mois Cultivia hors période espèce |
| 🔘 Grisé "Sélectionnez un mâle ou CIA" | Aucune méthode choisie |
| 🔘 Grisé "Aucun mâle {race} dans votre ferme" | Méthode naturelle + 0 mâle compatible |
| 🔘 Grisé "Solde insuffisant (besoin 200€)" | CIA + balance < 200 |
| 🔘 Grisé "HT insuffisants" | HT < 1.0 |

### → API

```http
POST /api/animals/{id}/inseminate
Headers: X-Idempotency-Key: {uuid}
Body: { "method": "natural", "male_id": "{uuid}" }
```

### → Backend

```
1. Idempotency
2. SELECT * FROM animal WHERE id=$1 AND farm_id=$farm FOR UPDATE
3. Vérifier sex='F', life_stage='adult', pregnant_until IS NULL
4. Vérifier période insémination : charger animal_species.insemination_months, comparer avec server.current_month
5. Si method=natural :
   SELECT * FROM animal WHERE id=$male_id AND farm_id=$farm AND sex='M' AND breed_id=$breed_id
   Vérifier existe et vivant
6. Si method=cia : vérifier balance >= 200
7. SELECT ht_today FROM player WHERE id=$1 FOR UPDATE
8. Vérifier ht >= 1.0
9. Calculer date mise bas : NOW() + (species.gestation_months × 7 jours)
10. Calculer génétique descendance (stocké, pas révélé) :
    Pour chaque indice :
      offspring[i] = (mother.genetics[i] + father.genetics[i]) / 2 + random(-5, +5)
      Clamp entre 0 et 100
11. BEGIN
12. UPDATE player SET ht_today -= 1.0, balance -= $cost (0 ou 200)
13. UPDATE animal SET pregnant_until = $due_date, mate_id = $male_id, insemination_method = $method
14. INSERT INTO animal_reproduction_log (animal_id, event, male_id, method, due_date, offspring_genetics)
15. INSERT INTO ledger (si CIA : -200€)
16. COMMIT
17. WS: ht_update, balance_update (si CIA), animal_alert
18. Retourner 200 { pregnant_until, estimated_due_date, method }
```

### ← Frontend

Toast "🧬 Marguerite inséminée ! Mise bas estimée : {date}". Badge 🤰 apparaît. Bouton Inséminer → grisé "Déjà gestante".

---

## Flux 2 : Le tick déclenche une naissance

### Worker — Tick quotidien, étape "Naissances"

```
SELECT * FROM animal 
WHERE pregnant_until IS NOT NULL 
AND pregnant_until <= CURRENT_TIMESTAMP
AND life_stage = 'adult';

Pour chaque animal gestante arrivée à terme :
  1. Charger reproduction_log → offspring_genetics
  2. Déterminer nb petits : random entre breed.offspring_min et breed.offspring_max
  3. Pour chaque petit :
     - sex = random 50/50
     - genetics = offspring_genetics + random_variation(-2, +2)
     - weight = breed.birth_weight_kg + random(-10%, +10%)
     - INSERT INTO animal (
         farm_id, breed_id, sex, birth_date=NOW(), weight_kg,
         life_stage='newborn', location_type='arrival',
         parent_father_id=$mate_id, parent_mother_id=$mother_id,
         genetics=$genetics, genetic_value=sum(genetics)
       )
  4. UPDATE animal SET pregnant_until=NULL, mate_id=NULL, is_lactating=true, nursing_until=NOW()+21days
     WHERE id=$mother_id
  5. Notification : "🐄 Marguerite a donné naissance à {N} veau(x) !"
  6. WS: animal_alert (in_arrival count updated)
```

### Ce que le joueur voit

**Notification :** "🐄 Marguerite a donné naissance à 1 veau femelle !"

**Dashboard élevage :** "📥 En arrivage: 1 [Placer auto]"

**Page `/animals` :** Nouveau veau dans la DataTable avec `location_type = 'arrival'`, badge "📥 Arrivage".

---

## Flux 3 : Placer un veau depuis l'enclos d'arrivage

### Déclencheur

Dashboard élevage → "📥 En arrivage: 1 [Placer auto]" ou fiche animal → "Déplacer".

### Bouton "Placer auto" → Backend

```http
POST /api/animals/auto-place
Headers: X-Idempotency-Key: {uuid}
```

```
1. SELECT * FROM animal WHERE farm_id=$1 AND location_type='arrival'
2. Pour chaque animal en arrivage :
   Trouver un bâtiment compatible (même espèce) avec place :
   SELECT b.id FROM building b
   JOIN building_animal_capacity c ON b.id = c.building_id
   WHERE b.farm_id=$1 AND c.animal_count < c.max_capacity
   ORDER BY c.animal_count ASC LIMIT 1
3. Si trouvé :
   UPDATE animal SET building_id=$building, location_type='building'
   UPDATE building_animal_capacity SET animal_count += 1
4. Si pas trouvé :
   Notification "⚠️ Pas de place pour {nom}. Construisez un bâtiment."
5. HT : 0.2 par animal placé
```

### ← Frontend

Toast "🏠 1 veau placé dans Stabulation Nord". Ou warning "⚠️ Pas de place — construisez un bâtiment".

### Placement manuel (modale Déplacer)

Même flux que Sprint 03 Flux "Déplacer" mais depuis l'arrivage. Le joueur choisit le bâtiment.

---

## Flux 4 : Consulter l'arbre généalogique

### Déclencheur

Fiche animal → onglet "Généalogie" ou bouton "Voir généalogie".

### → API

```http
GET /api/animals/{id}/pedigree?depth=3
```

### → Backend

```sql
WITH RECURSIVE pedigree AS (
  -- Niveau 0 : animal actuel
  SELECT id, name, breed_id, sex, genetics, genetic_value,
         parent_father_id, parent_mother_id, life_stage,
         0 as depth
  FROM animal WHERE id = $1
  
  UNION ALL
  
  -- Niveaux 1-3 : parents
  SELECT a.id, a.name, a.breed_id, a.sex, a.genetics, a.genetic_value,
         a.parent_father_id, a.parent_mother_id, a.life_stage,
         p.depth + 1
  FROM animal a
  JOIN pedigree p ON a.id = p.parent_father_id OR a.id = p.parent_mother_id
  WHERE p.depth < 3
)
SELECT * FROM pedigree;
```

### ← Frontend — Composant `<PedigreeTree>`

```
              [GP paternel ♂]──[GM paternelle ♀]
              Crois:90 Lait:75     Crois:70 Lait:85
                       └──────┬──────┘
                    [Taureau Royal ♂]
                    Crois:85 Lait:70
                                        [GP maternel ♂]──[GM maternelle ♀]
                                        ❓ Inconnu         ❓ Inconnu
                                                 └──────┬──────┘
                                              [Mère ♀]
                                              Crois:78 Lait:91
                          └────────────┬────────────┘
                              [Veau ♀ — "sans nom"]
                              Crois:81 Lait:80
```

Chaque nœud :
- 🟢 = vivant dans la ferme → clic → `/animals/:id`
- 🔵 = vendu → clic → popup info (nom, race, génétique)
- ⚫ = mort → clic → popup info
- ❓ = inconnu (acheté en coop) → tooltip "Parent inconnu"

Barres génétiques miniatures au hover.

---

## Flux 5 : La mère allaite le veau

### Automatique (tick)

```
Si animal.is_nursing = true ET nursing_until > NOW() :
  Le veau n'a pas besoin d'être nourri manuellement
  La mère consomme +30% de ration (calculé dans le nourrissage)
  
Si nursing_until <= NOW() :
  UPDATE animal SET is_nursing = false WHERE id = $mother_id
  Le veau doit maintenant être nourri normalement
  Notification "🍼 Le veau de Marguerite est sevré"
```

### Ce que le joueur voit

Fiche mère : "🍼 Allaitement en cours (sevrage dans {X} jours)"
Fiche veau : "🍼 Allaité par Marguerite — pas besoin de nourrissage"
DataTable : badge 🍼 sur mère et veau

---

## Dépendances techniques Sprint 06

```
Sprint 05 (soins, vaccins)
  └→ Sprint 06 (reproduction)
       ├── Tables : animal_reproduction_log
       ├── Modif : animal (pregnant_until, mate_id, insemination_method, is_lactating, is_nursing, nursing_until)
       ├── Services : InseminationService, BirthService, PedigreeService, AutoPlaceService
       ├── Worker : tick étape "naissances" + "sevrage"
       ├── Routes : POST /animals/:id/inseminate, GET /animals/:id/pedigree, POST /animals/auto-place
       ├── Stores : useReproductionStore
       ├── Pages : modale insémination, onglet généalogie
       └── Composants : InseminateModal, PedigreeTree (SVG), GeneticComparison, ArrivalBanner
```

## Tests Sprint 06

```
GIVEN vache adulte, taureau même race, HT >= 1.0
WHEN POST /api/animals/{id}/inseminate { method: natural, male_id }
THEN 200, pregnant_until set, ht -= 1.0

GIVEN vache déjà gestante
WHEN POST /api/animals/{id}/inseminate
THEN 400 "Déjà gestante"

GIVEN vache gestante, pregnant_until = today
WHEN tick naissances
THEN nouveau veau créé, location_type='arrival', mère is_lactating=true

GIVEN veau en arrivage, stabulation avec place
WHEN POST /api/animals/auto-place
THEN veau.building_id set, capacity += 1, ht -= 0.2

GIVEN veau en arrivage, aucun bâtiment avec place
WHEN POST /api/animals/auto-place
THEN notification "Pas de place"

GIVEN mère allaitante, nursing_until = today
WHEN tick sevrage
THEN is_nursing = false, notification "Veau sevré"

GIVEN animal avec parents connus
WHEN GET /api/animals/{id}/pedigree?depth=3
THEN arbre 3 générations retourné avec génétique
```
