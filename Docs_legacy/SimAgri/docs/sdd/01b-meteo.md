# SDD 01b — Système Météo

> Système météo enrichi avec températures réalistes, précipitations, gel, prévisions 7 jours, alertes, et carte de France.

## 1. Modèle de données

### Table `weather`
```sql
weather (
  id              SERIAL PRIMARY KEY,
  server_id       INT REFERENCES servers,
  meteo_zone      VARCHAR(20) NOT NULL,   -- 'océanique', 'océanique-dégradé', 'semi-continental', 'continental', 'méditerranéen'
  game_day        INT NOT NULL,
  level           INT CHECK (level BETWEEN 1 AND 5),  -- 1=très ensoleillé, 2=ensoleillé, 3=mitigé, 4=pluie, 5=orage
  wind            BOOLEAN DEFAULT FALSE,
  hail            BOOLEAN DEFAULT FALSE,
  temp_min        DECIMAL(4,1),           -- température minimale (°C)
  temp_max        DECIMAL(4,1),           -- température maximale (°C)
  precipitation_mm DECIMAL(5,1) DEFAULT 0, -- précipitations en mm
  frost           BOOLEAN DEFAULT FALSE,   -- gel (auto-détecté si temp_min < 0)
  UNIQUE(server_id, meteo_zone, game_day)
)
```

### Icônes météo par level
| Level | Icône | Label |
|-------|-------|-------|
| 1 | ☀️ | Très ensoleillé |
| 2 | ⛅ | Ensoleillé |
| 3 | 🌥️ | Mitigé |
| 4 | 🌧️ | Pluie |
| 5 | ⛈️ | Orage |

### Icônes complémentaires
| Condition | Icône |
|-----------|-------|
| Vent | 💨 |
| Grêle | 🧊 |
| Gel | 🥶 |
| Précipitations | 💧 |

---

## 2. Zones climatiques françaises

5 zones climatiques réalistes remplacent les 4 zones abstraites (nord-ouest, etc.) :

| Zone climatique | Icône | Régions |
|----------------|-------|---------|
| `océanique` | 🌊 | Bretagne, Normandie, Pays de la Loire, Nouvelle-Aquitaine |
| `océanique-dégradé` | 🌫️ | Hauts-de-France, Île-de-France, Centre-Val de Loire |
| `semi-continental` | 🌾 | Bourgogne-Franche-Comté, Auvergne-Rhône-Alpes |
| `continental` | ❄️ | Grand Est |
| `méditerranéen` | ☀️ | Occitanie, PACA, Corse |

### Mapping `regions.meteo_zone`
Chaque région a son `meteo_zone` mis à jour dans la table `regions`.

---

## 3. Profils de température par climat × saison

Températures réalistes [min, max] en °C :

| Zone | Hiver | Printemps | Été | Automne |
|------|-------|-----------|-----|---------|
| océanique | [2, 8] | [7, 16] | [14, 24] | [8, 17] |
| océanique-dégradé | [0, 6] | [5, 15] | [13, 25] | [6, 15] |
| semi-continental | [-2, 5] | [4, 16] | [13, 27] | [5, 15] |
| continental | [-4, 3] | [3, 17] | [12, 28] | [4, 14] |
| méditerranéen | [3, 12] | [8, 20] | [18, 32] | [10, 22] |

### Ajustements par level météo
| Level | Ajustement temp |
|-------|----------------|
| 1 (très ensoleillé) | +3°C |
| 2 (ensoleillé) | +1°C |
| 3 (mitigé) | 0°C |
| 4 (pluie) | -2°C |
| 5 (orage) | -4°C |

### Précipitations par level
| Level | Précipitations (mm) |
|-------|-------------------|
| 1 | 0 |
| 2 | 0 |
| 3 | 1-5 |
| 4 | 8-20 |
| 5 | 15-40 |

### Gel
Auto-détecté : `frost = (temp_min < 0)`

---

## 4. Génération des prévisions (Worker)

### Fréquence
Le worker génère la météo à chaque tick horaire (toutes les heures).

### Logique 7 jours
- **J+0 à J+2** : prévisions "fiables" — générées une fois, jamais écrasées
- **J+3 à J+6** : prévisions "incertaines" — régénérées à chaque tick

### Probabilités par climat × saison
Chaque zone climatique a des poids différenciés par saison pour les 5 niveaux météo.

Exemple (océanique, automne) : `[10, 20, 30, 25, 15]` → plus de pluie en automne.

### Vent et grêle
- Vent : probabilité variable par zone (océanique 18%, méditerranéen 15%, autres 10%)
- Grêle : probabilité variable (continental 4%, autres 2%)

---

## 5. API

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | `/game/weather` | Météo du jour courant, toutes zones |
| GET | `/game/weather/forecast` | Prévisions 7 jours, toutes zones, triées par jour puis zone |
| GET | `/game/weather/history` | Historique (35 derniers enregistrements) |

### Client API
```typescript
getWeatherForecast(): Promise<WeatherForecast[]>
```

---

## 6. Interface

### Dashboard — Widget météo 3 jours
- Affiché dans la card "Météo" du dashboard
- Montre uniquement la zone climatique du joueur
- Format : grille 3 colonnes (Auj., J+1, J+2)
- Chaque colonne : icône météo, temp min/max, précipitations, icônes vent/grêle/gel
- Lien "Voir tout →" vers `/meteo`

### Alertes météo (dans Notifications)
Intégrées dans la card Notifications du dashboard :
- 🥶 **Gel** : si `frost = true` dans les 3 prochains jours
- 🧊 **Grêle** : si `hail = true` dans les 3 prochains jours
- 🌡️ **Canicule** : si `temp_max > 35°C` dans les 3 prochains jours

### Page /meteo
Route : `/meteo`

#### Carte de France SVG
- 13 régions métropolitaines
- Chaque région colorée selon le level météo du jour :
  - Level 1-2 : jaune/orange (soleil)
  - Level 3 : gris clair (mitigé)
  - Level 4-5 : bleu (pluie/orage)
- Région du joueur surlignée (bordure verte)
- Icônes météo et températures affichées sur la carte
- Labels régions avec zone climatique

#### Tableau prévisions 7 jours
- 5 lignes (une par zone climatique)
- 7 colonnes (Auj. à J+6)
- Chaque cellule : icône météo + temp min/max + précipitations + icônes vent/grêle/gel
- Colonnes J+3 à J+6 affichées avec opacité réduite (prévisions incertaines, marquées `~`)
- Ligne de la zone du joueur surlignée

#### Légende
Barre horizontale avec tous les symboles : ☀️ ⛅ 🌥️ 🌧️ ⛈️ 💨 🧊 🥶 💧 ~

---

## 7. Départements, préfectures et communes

### Table `departments`
Colonne `chef_lieu` ajoutée avec les 96 préfectures métropolitaines.

### Table `communes`
324 communes (préfectures + sous-préfectures) pour les 96 départements. Le joueur choisit sa commune à l'inscription.

### Table `players`
Colonne `department_id` et `commune_id` ajoutées (en plus de `region_id`).

### Affichage
- **Dashboard** : `Caen · Calvados (14) / Normandie`
- **Inscription** : sélecteur Région → Département → Commune (🏛️ préfecture / 🏘️ sous-préfecture)

---

## 8. Priorité d'implémentation

1. ✅ DB + Worker : enrichir le schéma weather, générer température + précipitations + gel, générer 7 jours
2. ✅ API : exposer météo multi-jours avec filtre par zone
3. ✅ Dashboard widget : météo 3 jours compact pour la zone du joueur
4. ✅ Page /meteo : carte + tableau 7 jours toutes zones
5. ✅ Alertes météo : intégration dans le système d'alertes existant
6. ⬜ Impact gameplay : gel/canicule/pluie forte sur cultures, animaux, actions

---

## 9. Impact gameplay (à implémenter)

### Cultures
- **Gel** : dégâts sur cultures en croissance (printemps/automne)
- **Canicule** (temp_max > 35°C) : stress hydrique, baisse rendement
- **Pluie forte** (précipitations > 20mm) : empêche certains travaux aux champs (semis, récolte)
- **Orage + grêle** : dégâts directs sur cultures matures

### Animaux
- **Canicule** : stress thermique, baisse production lait, mortalité si pas d'abri
- **Gel** : consommation accrue de nourriture
- **Vent fort** : animaux au pré rentrent automatiquement

### Actions
- **Pluie/orage** : malus sur travaux de sol, semis, récolte
- **Gel** : impossible de labourer (sol gelé)
- **Vent fort** : impossible de traiter (pulvérisation)

---

## Fichiers modifiés

| Fichier | Modification |
|---------|-------------|
| `prisma/init.sql` | Schéma weather enrichi, zones climatiques, chef_lieu, department_id |
| `worker/src/jobs/weather.ts` | Réécriture complète : 7 jours, températures, précipitations, gel |
| `server/src/routes/game.ts` | Ajout endpoint `/weather/forecast` |
| `server/src/routes/players.ts` | Expose department_name, department_code, chef_lieu |
| `client/src/api/client.ts` | Ajout `getWeatherForecast()` |
| `client/src/views/Dashboard.vue` | Widget météo 3 jours + alertes |
| `client/src/views/Meteo.vue` | Nouvelle page carte France + tableau 7 jours |
| `client/src/views/france-map.ts` | Ajout mapping `keyToClimate` |
| `client/src/router.ts` | Ajout route `/meteo` |
