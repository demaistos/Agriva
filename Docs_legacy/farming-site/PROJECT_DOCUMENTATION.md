# 🌿 Farming Site - Project Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Directory Structure](#directory-structure)
4. [Database Schema](#database-schema)
5. [API Endpoints](#api-endpoints)
6. [Frontend Components](#frontend-components)
7. [Business Logic](#business-logic)
8. [Development Workflow](#development-workflow)

---

## Project Overview

**Farming Site** is a garden management application with five main pages:
- **Mon Jardin** (`/garden`): Visual garden planner — drag beds, place plants, tracking, notes
- **Catalogue** (`/catalog`): Plant catalog (families + varieties) + cultural calendar
- **Journal** (`/plants`): Personal plant journal
- **Tâches** (`/tasks`): Task calendar
- **Profil** (`/profile`): Account, location, garden shape

### Tech Stack
- **Frontend**: React 19 + Vite, React Router, Axios — served by Nginx in prod (gzip, cache)
- **Backend**: FastAPI + SQLAlchemy + PostgreSQL + JWT + BeautifulSoup (scraping)
- **AI**: Ollama (qwen2.5:3b) — local, no cloud dependency
- **Climate data**: Open-Meteo Climate API (normals 1990-2020)
- **Deployment**: Docker Compose (4 containers: db, backend, frontend, ollama)

### Navigation
Unified sidebar on all pages. Collapsed (icons only, 54px) on `/garden` to maximize canvas space, expanded (220px with labels) on all other pages.

---

## Architecture

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  React (Nginx)   │    │  FastAPI :8000   │    │  PostgreSQL      │
│  :5173           │◄──►│                  │◄──►│                  │
│                  │    │  /auth /gardens  │    │  users           │
│  GardenMap       │    │  /catalog /tasks │    │  gardens         │
│  CatalogPage     │    │  /plants /ai     │    │  plants_catalog  │
│  PlantTracker    │    │                  │    │  plants / tasks  │
│  TaskCalendar    │    │                  │    │                  │
└──────────────────┘    └──────────────────┘    └──────────────────┘
        │                       │
        │               ┌───────┴───────────┐
        │               │  Ollama :11434    │
        │               │  qwen2.5:3b       │
        │               └───────────────────┘
        │
        ├── Open-Meteo Climate API (températures + radiation solaire)
        ├── Nominatim / OpenStreetMap (géocodage ville)
        └── Sites horticoles français (scraping fiches plantes + images)
```

---

## Directory Structure

```
farming-site/
├── backend/
│   ├── app/
│   │   ├── models/__init__.py     # User, Garden, Plant, PlantCatalog, Task
│   │   ├── routers/
│   │   │   ├── auth.py            # /auth/register /login /me
│   │   │   ├── ai.py              # /ai/catalog/{id}/fill + scraping 6 sources + images + localisation
│   │   │   ├── catalog.py         # /catalog CRUD + upload image
│   │   │   ├── gardens.py         # /gardens CRUD
│   │   │   ├── plants.py          # /plants CRUD
│   │   │   └── tasks.py           # /tasks CRUD
│   │   ├── schemas/__init__.py    # Pydantic models (CatalogBase, FillRequest, etc.)
│   │   ├── auth.py                # JWT utils
│   │   ├── config.py              # Settings (env vars)
│   │   ├── database.py            # SQLAlchemy engine
│   │   └── main.py                # App init + inline migrations + seeding
│   ├── .env                       # Secrets (gitignored)
│   └── requirements.txt
├── frontend/
│   └── src/
│       ├── api/client.js          # Axios + JWT header + 401 interceptor
│       ├── components/
│       │   ├── garden/
│       │   │   ├── Bed.jsx            # Bed render + resize/rotate/polygon + context menu
│       │   │   ├── BedVisual.jsx      # WoodenFence SVG, BedTypeIcon, pxToSize
│       │   │   ├── BedContextMenu.jsx # Right-click menu (type, lock, rename, reset shape, delete)
│       │   │   ├── BedPolygonEditor.jsx # Polygon shape editor (draw, fill, rectangle)
│       │   │   ├── GardenCanvas.jsx   # Canvas with zoom scale transform
│       │   │   ├── GardenSidebar.jsx  # Per-instance plant list + planted_at editor
│       │   │   ├── GardenCalendar.jsx # Garden tracking + alerts + day summary panel
│       │   │   ├── WeatherBanner.jsx  # 5-day forecast + frost alerts for planted crops
│       │   │   ├── DrawingToolsSidebar.jsx  # Plant palette + favorites + varieties
│       │   │   ├── PlantRows.jsx      # Absolute plant placement + drag + context menu
│       │   │   ├── PlantListTab.jsx   # Plant list with filters/sort/select/bulk actions
│       │   │   ├── PlantingCalendar.jsx # Cultural calendar Gantt (outdoor/greenhouse)
│       │   │   ├── CatalogTab.jsx     # Catalog CSS grid + resize/reorder columns + AI creation
│       │   │   ├── PlantSheet.jsx     # Plant detail modal (info/varieties/edit/AI/family change)
│       │   │   ├── PlannerTabs.jsx    # Tabs: Plan | Plantes | Suivi | Notes
│       │   │   ├── PlannerToolbar.jsx # Undo/redo/zoom/save toolbar
│       │   │   └── NotesTab.jsx       # Garden notes (uses useAuth gardenConfig)
│       │   └── ui/
│       │       ├── PlantIcon.jsx      # Plant icon with image/emoji fallback
│       │       └── SearchSelect.jsx   # Dropdown with search filter
│       ├── hooks/
│       │   ├── useAuth.jsx        # Auth context (JWT + gardenConfig + location)
│       │   ├── useCatalog.jsx     # Catalog context (all plants)
│       │   └── useFavorites.jsx   # Favorites (uses useAuth gardenConfig)
│       ├── pages/
│       │   ├── GardenMap.jsx      # Mon Jardin page
│       │   ├── CatalogPage.jsx    # Catalogue page (Fiches + Calendrier tabs)
│       │   ├── PlantTracker.jsx   # Journal page
│       │   ├── TaskCalendar.jsx   # Tâches page
│       │   ├── Profile.jsx        # Profil + location + garden shape
│       │   └── Login.jsx          # Login/register
│       ├── utils/
│       │   ├── garden.js          # parseBed, encodeMeta, uid(), snap(), getMinBedSize()
│       │   └── months.js          # parseMonthRange, estimateHarvest()
│       └── constants/index.js     # PLANT_TYPES, TASK_TYPES, GRID, SNAP
├── docker-compose.yml
├── README.md
└── PROJECT_DOCUMENTATION.md
```

---

## Database Schema

### users
```sql
id, email (unique), hashed_password, display_name,
garden_config TEXT  -- JSON: {
  canvasW, canvasH, polygon, notes,
  favorites: [plantId],
  location: {
    city, lat, lon, usda_zone,
    monthly_temps: [{min, max}] x12,
    monthly_sunshine: [number] x12
  }
}
```

### gardens (= bacs)
```sql
id, user_id (indexed), name, x, y, w, h,
meta TEXT  -- JSON: {
  label, plants: [{uid, id, x, y, planted_at, harvested_at}],
  locked, hideLabel, bedType,
  rotation: number,
  points: [[x,y]] | null   -- null = rectangle, array = polygone custom
}
```

### plants_catalog
```sql
id, name (indexed), icon, color, type, family,
scientific_name,  -- nom latin (ex: Solanum lycopersicum)
semis, recolte, semis_serre, recolte_serre,
espacement, soleil, arrosage, conseil, image_url,
parent_id INTEGER (indexed) REFERENCES plants_catalog(id),
temp_germination INTEGER, temp_frost INTEGER
```

**Organisation hiérarchique :**
- `parent_id = NULL` → Famille (conteneur organisationnel) ou plante indépendante
- `parent_id = X` → Variété rattachée à la famille X
- Les familles avec variétés n'ont pas de données culturales (juste nom, icône, type, couleur)

### plants (journal personnel)
```sql
id, user_id (indexed), name, type, sown_at, harvest_at, notes
```

### tasks
```sql
id, user_id (indexed), title, type, due_at, done
```

---

## API Endpoints

### Auth `/auth`
| Method | Path | Description |
|--------|------|-------------|
| POST | `/auth/register` | Inscription |
| POST | `/auth/login` | Connexion → JWT |
| GET | `/auth/me` | Profil courant (gardenConfig inclus) |
| PUT | `/auth/me` | Mise à jour profil + garden_config |

### Gardens `/gardens`
| Method | Path | Description |
|--------|------|-------------|
| GET | `/gardens` | Liste des bacs (filtré par user) |
| POST | `/gardens` | Créer un bac |
| PUT | `/gardens/{id}` | Modifier un bac (404 si inexistant) |
| DELETE | `/gardens/{id}` | Supprimer un bac |

### Catalog `/catalog`
| Method | Path | Description |
|--------|------|-------------|
| GET | `/catalog` | Liste toutes les plantes |
| POST | `/catalog` | Créer une plante |
| GET | `/catalog/{id}` | Détail d'une plante |
| PUT | `/catalog/{id}` | Modifier une plante (y compris parent_id) |
| DELETE | `/catalog/{id}` | Supprimer |
| GET | `/catalog/{id}/varieties` | Variétés d'une plante |
| POST | `/catalog/{id}/upload-image` | Upload image |

### AI `/ai`
| Method | Path | Description |
|--------|------|-------------|
| POST | `/ai/catalog/{id}/fill` | Remplir fiche via scraping + Ollama + localisation |
| GET | `/ai/catalog/{id}/images` | Images candidates scrapées depuis sites français |
| GET | `/ai/status` | Statut Ollama + modèles disponibles |

**Body `/ai/catalog/{id}/fill`** :
```json
{
  "location": { "city", "lat", "lon", "usda_zone", "monthly_temps", "monthly_sunshine" },
  "url": "https://www.example.com/product-page"
}
```

**Query params `/ai/catalog/{id}/fill`** :
- `force_icon=true` — remplacer l'icône même si déjà renseignée
- `force_image=true` — remplacer l'image même si déjà renseignée
- `force_all=true` — remplacer tous les champs + icône + image

**Query params `/ai/catalog/{id}/images`** :
- `url=...` — URL directe à scraper pour les images en priorité

---

## Frontend Components

### App.jsx (navigation)
- Sidebar unifiée sur toutes les pages (composant `Sidebar` dans App.jsx)
- Prop `collapsed` : icônes seulement (54px) sur `/garden`, étendue (220px) ailleurs
- 5 liens : 🏡 Mon Jardin, 📚 Catalogue, 📓 Journal, ✅ Tâches, 👤 Profil
- Bouton 🚪 Déconnexion en bas
- Tooltips sur les icônes en mode collapsed

### CatalogTab.jsx (fiches catalogue)
- Organisation hiérarchique : Familles (▶/▼ dépliables) → Variétés
- Familles = conteneurs organisationnels (pas de données culturales)
- Recherche intelligente : filtre familles + variétés, ouvre automatiquement les familles avec résultats
- **Layout CSS grid** : `grid-template-columns` dynamique, `width: fit-content`, `minWidth: 100%`
- Colonnes configurables (⚙️ menu, sauvegardé `localStorage catalog-columns`)
- Colonnes redimensionnables (drag séparateurs, sauvegardé `localStorage catalog-col-widths`)
- Colonnes réordonnables (drag & drop headers, sauvegardé `localStorage catalog-col-order`)
- Colonne "Plante" aussi redimensionnable (stockée dans `colWidths._plant`, défaut 400px)
- Colonnes : Espacement, Calendrier, Conseil, Nom latin, Famille bot., Exposition, Arrosage, Type, Semis, Récolte
- Modal création IA : nom + famille parente + lien produit + checkbox "tout remplacer"
- Modal nouvelle famille : nom, icône, type, couleur

### PlantSheet.jsx (fiche plante)
- 3 onglets : Information | Variétés | Édition
- Onglet Info : données en lecture seule, calendrier, image, nom latin en header
- Onglet Variétés : ajout/suppression de variétés (si plante = famille)
- Onglet Édition : tous les champs éditables + changement de famille (dropdown parent_id)
- Boutons IA : 🤖 Remplir avec IA, 🎭 Icône IA, 🔍 Image IA
- Champ URL 🔗 : lien produit optionnel (partagé entre Remplir IA et Image IA)
- Checkbox "Tout remplacer" : force_all pour écraser les valeurs existantes
- Upload image + sélecteur d'images scrapées
- Champs éditables : nom, nom latin, icône, famille bot., type, exposition, arrosage, espacement, semis/récolte (plein air + serre), germination, gel, conseil, couleur, image

### GardenMap.jsx (Mon Jardin)
- State : `beds`, `selected`, `zoom`, `history`, `tab`
- Onglets : Plan | Plantes | Suivi | Notes
- Resize des bacs avec `getMinBedSize` (contraint par les plantes)
- `useAuth().gardenConfig` pour la config jardin (un seul appel /auth/me)
- `useCatalog().getPlant` pour les infos plantes

### Bed.jsx
- Structure : wrapper (positionnement, overflow visible) → div fond (texture, clipPath, pointerEvents none) → contenu
- Poignées de resize sur les 8 coins/bords (toujours visibles, même polygone custom)
- Rotation via poignée ↻ (Shift = snap 15°)
- Bouton ⬡ → BedPolygonEditor
- Menu contextuel : type, verrouiller, renommer, dupliquer, revenir au rectangle, supprimer
- `React.memo` pour éviter les re-renders inutiles

### BedPolygonEditor.jsx
- Éditeur de forme polygonale en modal
- Boutons : Redessiner (libre), Rectangle (null), Remplir (tout le bac)
- Glisser sommets, double-clic bord = ajouter, double-clic sommet = supprimer

### PlantListTab.jsx
- Tableau avec filtres (recherche, bac SearchSelect, type SearchSelect, planté/non planté)
- Tris : nom, bac, date plantation, récolte estimée
- Sélection multiple + action groupée (définir plantation/récolte en masse)
- Bouton 📖 fiche plante sur chaque ligne
- Vues : Individuel | Résumé

### GardenCalendar.jsx (onglet Suivi)
- **Alertes retard** : bandeau rouge si plantes en retard (basé sur périodes semis/recolte du catalogue)
  - 🌱 À semer maintenant (orange) : pas planté, période de semis en cours
  - ⚠️ Semis en retard (rouge) : pas planté, période de semis dépassée
  - ⚠️ Récolte en retard (rouge) : planté, pas récolté, période de récolte dépassée
- Vue calendrier mensuel (grille par jour, navigation ◀ ▶)
- Événements : 📅 Semis prévu, 🌱 Planté, 📅 Récolte prévue, 🌾 Récolté
- **Clic jour → panneau résumé latéral** :
  - Badges compteurs groupés par type (ex: 🌱 3 planté)
  - Sections par action avec liste des plantes (icône, nom, bac)
  - Clic sur une plante → ouvre PlantSheet
- Vue liste : filtres, tris, sélection multiple, action groupée
- Bordure gauche rouge/orange sur les lignes en retard

### WeatherBanner.jsx (bandeau météo)
- Affiché sous les onglets de Mon Jardin (tous les onglets)
- Appelle **Open-Meteo Forecast API** (5 jours, coordonnées du profil)
- Affiche : icône WMO, jour, min°/max°, précipitations
- **Alertes gel** : compare temp min prévue avec `temp_frost` de chaque plante plantée
  - `temp_frost` renseigné → utilise comme seuil
  - Non renseigné → seuil par défaut 5°C
  - Affiche "🥶 X° prévu" + plantes à risque avec seuil
- Se masque si pas de localisation dans le profil

### PlantingCalendar.jsx (onglet Calendrier du Catalogue)
- Vue Gantt 12 mois, toutes les plantes du catalogue
- Toggle serre (bleu) / plein air (vert)
- Mois incompatibles grisés selon climat local (gel, germination)
- En-tête températures + ensoleillement

### DrawingToolsSidebar.jsx
- Palette de plantes avec drag & drop vers le canvas
- Filtres : recherche, type (pills), favoris uniquement
- Variétés affichées sous leur parent avec indentation
- Boutons ☆/★ favoris + 📖 fiche plante

### SearchSelect.jsx (composant UI réutilisable)
- Dropdown avec champ de recherche intégré
- Filtre la liste en temps réel
- Fermeture au clic extérieur

### useAuth.jsx
- Charge `gardenConfig` une seule fois via `/auth/me`
- Expose : `user`, `login`, `register`, `logout`, `gardenConfig`, `location`, `reloadConfig`
- `useFavorites` et `GardenMap` consomment `gardenConfig` sans refaire d'appel

### useCatalog.jsx
- Charge toutes les plantes via `GET /catalog` au démarrage
- Expose : `plants`, `loading`, `getPlant(idOrName)`, `reload()`
- `FALLBACK_PLANT` retourné si plante non trouvée

### useFavorites.jsx
- Stocke les favoris dans `gardenConfig.favorites` via useAuth
- Migration automatique localStorage → DB au premier chargement
- Expose : `favorites`, `toggle(id)`, `clear()`

---

## Business Logic

### Organisation du catalogue
- **Famille** (`parent_id = NULL`, a des variétés) : conteneur organisationnel, pas de données culturales
- **Variété** (`parent_id = X`) : plante avec toutes les données culturales
- **Plante indépendante** (`parent_id = NULL`, pas de variétés) : plante avec données culturales
- Changement de famille possible via PlantSheet onglet Édition

### Scraping IA
- 6 sites français : Promesse de Fleurs, Ferme de Sainte Marthe, Graines Baumaux, Kokopelli, Willemse, Gamm Vert
- Scraping parallèle (ThreadPoolExecutor, 6 workers, timeout 20s)
- Scoring de pertinence des résultats (nom de la plante en début de titre)
- Noms courts/ambigus (≤6 chars) : enrichis avec "+graines+potager"
- Extraction : texte descriptif + données structurées (tableaux clé/valeur) + image produit
- Support URL directe : `_scrape_direct_url()` scrape une page produit spécifique avec tous les sélecteurs
- Extraction images : sélecteurs CSS e-commerce courants + fallback plus grande image (heuristique taille)
- Résolution URLs relatives : `urljoin()` pour chemins sans `/` (ex: `Files/img/photo.jpg`)
- Filtrage images : blacklist URL (ensachage, sachet, packaging, logo, banner, popup, emballage)
- Filtrage pertinence images : rejet si le nom de fichier contient un autre légume avant le nom cherché
- Session requests avec CA custom pour le scraping HTTPS (certificat entreprise)

### Ollama — Modèle texte
- Modèle : qwen2.5:3b (configurable via `OLLAMA_MODEL`)
- System prompt : botaniste expert, réponse JSON strict
- Options : temperature 0.1, top_p 0.9, repeat_penalty 1.1
- Timeout : 120s (configurable via `OLLAMA_TIMEOUT`)
- `OLLAMA_KEEP_ALIVE=24h` pour garder le modèle en mémoire

### Validation des données IA
- `extract_json()` : parse robuste avec 3 tentatives (direct, regex champ par champ, réparation)
- `validate_data()` : normalise espacement (Xcm), mois (Mois-Mois), températures (sanity check), soleil, arrosage, type
- `normalize_month_range()` : gère abréviations, séparateurs alternatifs (à, au, /, virgule)

### Inline migrations (main.py)
Au démarrage, tente d'ajouter les colonnes manquantes :
- `gardens.meta`, `users.display_name`, `users.garden_config`
- `plants_catalog.image_url`, `parent_id`, `temp_germination`, `temp_frost`
- `plants_catalog.semis_serre`, `recolte_serre`, `scientific_name`
- `plants.type`

### Seed catalog (main.py)
Si la table `plants_catalog` est vide au démarrage, insère 16 plantes de base :
Tomate, Carotte, Laitue, Concombre, Poivron, Courgette, Oignon, Ail, Fraise, Basilic, Pomme de terre, Citrouille, Haricot, Maïs, Radis, Petit pois.

### Format plante dans un bac
```javascript
{ uid, id, x, y, planted_at, harvested_at }
```
- `planted_at` futur = prévisionnel semis, passé = planté
- `harvested_at` futur = prévisionnel récolte, passé = récolté

### Taille minimum bac (getMinBedSize)
- Calcule le min w/h basé sur la position + taille de chaque plante
- Prend en compte fenceInset (surélevé) et labelHeight
- Taille plante dérivée de l'espacement : `Math.max(14, Math.min(60, Math.round((cm / 100) * GRID)))`

### Resize avec polygone
- Les points sont mis à l'échelle : `newPoint = initPoint * (newSize / initSize)`

### Anti-chevauchement (resolvePosition)
- Spirale pixel par pixel autour de la position cible
- Vérifie les collisions avec toutes les autres plantes du bac

### Estimation récolte (estimateHarvest)
- À partir de `planted_at` et `recolte` (période), estime la prochaine date de récolte
- Retourne `{ label, delay, date }`

### Localisation & Climat
- Nominatim pour le géocodage ville
- Open-Meteo Climate API pour les normales 1990-2020 (daily agrégé par mois)
- Radiation solaire → heures d'ensoleillement : `h = radiation_MJ / 3.6`
- Zone USDA calculée depuis la température minimale annuelle

---

## Development Workflow

```bash
docker-compose up -d
docker exec farming-site-ollama-1 ollama pull qwen2.5:3b  # première fois
docker-compose up -d --build frontend  # rebuild frontend
docker-compose up -d --build backend   # rebuild backend
docker-compose logs backend --tail=30
```

- Frontend : http://localhost:5173
- Backend API docs : http://localhost:8000/docs
- Secrets dans `backend/.env` (gitignored)
