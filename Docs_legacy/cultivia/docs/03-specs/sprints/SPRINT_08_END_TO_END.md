# Sprint 08 — Déplacements + Employés + Météo — Spec End-to-End

> Prérequis : Sprint 07 (MVP élevage complet).
> Ce sprint ajoute : déplacer animaux bâtiment↔pré, employés (+HT), météo, événements saisonniers.

---

## Tables SQL nouvelles

```sql
employee, weather, weather_event
-- Modif : player (ht_max), animal (parcel_id, location_type='pasture')
```

---

## Flux 1 : Embaucher un employé

### Page `/employees`

```
┌─────────────────────────────────────────────────────────────────┐
│ 👷 Mes employés [Coût mensuel: 0 €/mois] [HT bonus: +0/jour]   │
│ [Embaucher un employé]                                          │
├─────────────────────────────────────────────────────────────────┤
│ Aucun employé. Embauchez pour augmenter vos HT quotidiens.      │
└─────────────────────────────────────────────────────────────────┘
```

### Clic "Embaucher" → Modale

```
┌─────────────────────────────────────────────┐
│ 👷 Embaucher un employé                      │
│                                              │
│ Spécialité : [Polyvalent ▼]                  │
│   • Polyvalent : +4 HT/jour — 600 €/mois    │
│   • Cultures : +4 HT/jour — 600 €/mois      │
│   • Élevage : +4 HT/jour — 600 €/mois       │
│                                              │
│ Nom : [____Jean____] (auto-généré, éditable) │
│                                              │
│ Coût embauche : 500 € (unique)               │
│ Salaire mensuel : 600 €/mois (auto-prélevé)  │
│ HT bonus : +4 HT/jour                        │
│                                              │
│ Après embauche : 40 + 4 = 44 HT/jour         │
│                                              │
│ [Annuler]              [Embaucher 500 €]     │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= 500` |
| 🔘 Grisé "Solde insuffisant" | `balance < 500` |
| 🔘 Grisé "Maximum 3 employés" | `employee_count >= 3` |

### → API

```http
POST /api/employees
Headers: X-Idempotency-Key: {uuid}
Body: { "specialty": "polyvalent", "name": "Jean" }
```

### → Backend

```
1. Idempotency
2. Vérifier nb employés < 3
3. BEGIN
4. SELECT balance FROM player WHERE id=$1 FOR UPDATE
5. Vérifier balance >= 500
6. UPDATE player SET balance -= 500, ht_max = ht_max + 4
7. INSERT INTO employee (farm_id, name, specialty, ht_bonus, salary_monthly)
   VALUES ($farm, 'Jean', 'polyvalent', 4, 600)
8. INSERT INTO ledger ('purchase', 'Embauche Jean (polyvalent)', -500)
9. COMMIT
10. WS: balance_update, ht_update (ht_max changed)
```

### ← Frontend

Toast "👷 Jean embauché ! +4 HT/jour". Header HT : "35/44" au lieu de "35/40".

### Licencier — Bouton dans la liste

ConfirmModal : "Licencier Jean ? Vous perdrez 4 HT/jour."

```http
DELETE /api/employees/{id}
```

```
UPDATE player SET ht_max = ht_max - 4
DELETE FROM employee WHERE id=$1
```

### Tick mensuel — Salaires

```
Pour chaque employee :
  UPDATE player SET balance -= employee.salary_monthly
  INSERT INTO ledger ('salary', 'Salaire Jean', -600)
  Si balance < -30000 après : notification "⚠️ Faillite imminente"
```

---

## Flux 2 : Météo

### Page `/weather`

```
┌─────────────────────────────────────────────────────────────────┐
│ 🌤️ Météo — Clermont-Ferrand (zone Centre)                      │
├────────────────┬────────────────┬───────────────────────────────┤
│ AUJOURD'HUI    │ DEMAIN         │ APRÈS-DEMAIN (prévision)      │
│ ☀️ Ensoleillé   │ 🌧️ Pluie       │ ⛈️ Forte pluie                │
│ 14°C           │ 11°C           │ 8°C                           │
├────────────────┴────────────────┴───────────────────────────────┤
│ 🚨 ALERTES ACTIVES                                              │
│ (aucune)                                                        │
├─────────────────────────────────────────────────────────────────┤
│ HISTORIQUE (7 derniers jours)                                    │
│ Jour  | Météo | Temp | Précip. | Événement                     │
│ 6 Avr | ☀️    | 15°C | 0mm     | —                              │
│ 5 Avr | 🌧️    | 12°C | 8mm     | —                              │
│ 4 Avr | ⛈️    | 9°C  | 22mm    | Forte pluie                    │
└─────────────────────────────────────────────────────────────────┘
```

### → API

```http
GET /api/weather?prefecture_id={id}
```

Retourne : today, tomorrow, day_after (prévision), history 7j, active_events.

### Tick quotidien — Génération météo

```
Pour chaque zone climatique (4 zones) :
  1. Générer type météo : weighted random selon saison
     Printemps : 30% ensoleillé, 25% mitigé, 25% pluie, 15% forte pluie, 5% gel
     Été : 40% ensoleillé, 20% très ensoleillé, 20% mitigé, 15% pluie, 5% sécheresse
     Automne : 20% ensoleillé, 30% mitigé, 30% pluie, 15% forte pluie, 5% tempête
     Hiver : 15% ensoleillé, 20% mitigé, 25% pluie, 20% forte pluie, 20% gel
  2. Générer température : base_saison ± random(5)
  3. INSERT INTO weather (zone_id, date, type, temperature, precipitation)
  4. Événements saisonniers (probabilité par saison) :
     Si gel ET cultures en croissance : notification "🥶 Gel — risque perte cultures"
     Si sécheresse > 3 jours : notification "🏜️ Sécheresse — irriguer recommandé"
     Si tempête : notification "🌪️ Tempête — matériels non abrités endommagés"
```

### Header météo

Toujours visible : icône + temp aujourd'hui → icône + temp demain. Clic → `/weather`.

---

## Flux 3 : Déplacer animaux au pré

### Déclencheur

Fiche animal → "Déplacer" ou action groupée.

### Modale

```
┌─────────────────────────────────────────────────────┐
│ 🚜 Déplacer Marguerite                              │
│                                                      │
│ Lieu actuel : Stabulation Nord                       │
│                                                      │
│ Destination :                                        │
│ ○ Stabulation Nord (19/20 places) — 0.3 HT          │
│ ● Pré #1 — 7ha (0/15 places) — 0.5 HT              │
│   └ Distance : 12 km — Bétaillère requise ✅        │
│   └ Saison : Printemps — Mise au pré autorisée ✅   │
│                                                      │
│ HT total : 0.5                                       │
│                                                      │
│ [Annuler]              [Déplacer 🚜]                 │
└─────────────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Destination choisie + place + HT OK + (si pré: bétaillère + saison OK) |
| 🔘 Grisé "Sélectionnez une destination" | Rien choisi |
| 🔘 Grisé "Pas de place ({X}/{Y})" | Destination pleine |
| 🔘 Grisé "Bétaillère requise pour le pré" | Pré + pas de bétaillère |
| 🔘 Grisé "Mise au pré interdite en hiver (bovins)" | Pré + saison hiver + espèce bovine |
| 🔘 Grisé "HT insuffisants" | HT < coût |

### → API + Backend

```http
POST /api/animals/move
Headers: X-Idempotency-Key: {uuid}
Body: { "animal_ids": ["{uuid}"], "destination_type": "pasture", "destination_id": "{parcel_uuid}" }
```

```
1-5. Vérifs standard (idempotency, ownership, vivant)
6. Si destination=pasture :
   Vérifier saison autorisée : species.pasture_start_month <= current_month <= pasture_end_month
   Vérifier bétaillère possédée et non cassée
   Calculer HT : 0.3 + (distance_km / 30)
7. BEGIN + FOR UPDATE sur player + destination capacity
8. UPDATE animal SET location_type='pasture', parcel_id=$dest, building_id=NULL
9. UPDATE building_animal_capacity SET animal_count -= 1 (ancien lieu)
10. UPDATE player SET ht_today -= $ht
11. COMMIT + WS
```

---

## Dépendances + Tests

```
Sprint 07 → Sprint 08
  ├── Tables : employee, weather, weather_event
  ├── Services : EmployeeService, WeatherService, MoveService (enrichi pré)
  ├── Worker : tick météo, tick salaires, tick événements saisonniers
  ├── Routes : POST/DELETE /employees, GET /weather, POST /animals/move (enrichi)
  ├── Pages : /employees, /weather
  └── Composants : EmployeeList, WeatherCard, WeatherPage, MoveModal (enrichi)
```

Tests clés :
```
GIVEN joueur 0 employés, balance >= 500
WHEN POST /api/employees { polyvalent }
THEN ht_max = 44, balance -= 500

GIVEN 3 employés
WHEN POST /api/employees
THEN 400 "Maximum 3 employés"

GIVEN tick mensuel, employé salaire 600€
THEN balance -= 600, ledger entry

GIVEN vache en stabulation, pré avec place, printemps, bétaillère
WHEN POST /api/animals/move { destination: pasture }
THEN animal.location_type = 'pasture', ht déduit

GIVEN hiver, tentative mise au pré bovin
THEN 400 "Mise au pré interdite en hiver"
```
