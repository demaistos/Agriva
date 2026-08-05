# 🌿 Farming Site

Application de gestion de jardin — 5 interfaces : Plan du jardin, Catalogue, Mes Plantes, Tâches, Profil.

## Stack
- **Frontend:** React + Vite (Nginx en prod)
- **Backend:** Python (FastAPI)
- **Database:** PostgreSQL
- **Auth:** JWT
- **AI:** Ollama (qwen2.5:3b) — local
- **Climate:** Open-Meteo Climate API

---

## Local Development

```bash
docker-compose up -d
docker exec farming-site-ollama-1 ollama pull qwen2.5:3b  # première fois
```

Open http://localhost:5173

---

## Navigation

| Route | Page | Description |
|-------|------|-------------|
| `/garden` | Planificateur | Plan du jardin + liste plantes + calendrier jardin + notes |
| `/catalog` | Catalogue | Catalogue des plantes + calendrier cultural (référence globale) |
| `/plants` | Mes Plantes | Journal personnel de suivi |
| `/tasks` | Tâches | Calendrier des tâches |
| `/profile` | Profil | Compte + localisation + forme du jardin |

---

## Garden Map — Notes techniques

### Format des plantes dans un bac
Les plantes sont stockées dans `meta.plants` au format `{ uid, id, x, y, planted_at, harvested_at }`.
- `uid` : identifiant unique de l'instance
- `id` : référence vers `plants_catalog.id`
- `x`, `y` : coordonnées locales dans le bac (pixels)
- `planted_at` : date ISO string ou null (passé = planté, futur = semis prévu)
- `harvested_at` : date ISO string ou null (passé = récolté, futur = récolte prévue)

### Statuts dérivés automatiquement
- 📅 **Semis prévu** — `planted_at` dans le futur
- 🌱 **À planter** — rien de renseigné
- 🌿 **En croissance** — `planted_at` passé, pas récolté
- 📅 **Récolte prévue** — `harvested_at` dans le futur
- 🌾 **Récoltée** — `harvested_at` passé

### Onglets du planificateur
- **🗺️ Plan** — canvas avec bacs, plantes, drag & drop
- **🌱 Liste des plantes** — tableau avec filtres, tri, sélection multiple, action groupée, fiche plante
- **📅 Calendrier** — vue calendrier mensuel (événements par jour) + vue liste éditable
- **📝 Notes** — notes libres du jardin

### Drag & drop des plantes
- **Ajout** : drag HTML5 depuis la sidebar → drop sur le canvas
- **Repositionnement** : drag custom `mousemove` sur `document`, delta / zoom
- **Anti-chevauchement** : `resolvePosition()` spirale pixel par pixel
- **Double-clic** : suppression avec confirmation
- **Clic droit** : popup détails + dates éditables

### Bacs — Redimensionnement & Forme
- **Resize** : 8 poignées (N/S/E/W/NE/NW/SE/SW), taille minimum contrainte par les plantes
- **Polygone custom** : bouton ⬡ → éditeur de forme (dessiner, glisser sommets, ajouter/supprimer points)
  - **Remplir** : polygone couvrant tout le bac, modifiable ensuite
  - **Rectangle** : supprime le polygone, revient au bac classique
  - Le resize met à l'échelle les points du polygone proportionnellement
- **Rotation** : poignée ↻ au-dessus du bac (Shift = snap 15°)
- **Menu contextuel** : clic droit → type, verrouiller, renommer, dupliquer, revenir au rectangle, supprimer

### Zoom
Canvas `transform: scale(zoom)`, défaut 1.5 (150%). Ctrl+molette pour zoomer.

### Variétés de plantes
Entrées `plants_catalog` avec `parent_id` non null. Gérées dans PlantSheet.

### Favoris
Stockés dans `garden_config.favorites` via `useFavorites` hook.

---

## Catalogue & Calendrier Cultural

Page dédiée `/catalog` avec 2 onglets.

### Catalogue
- Organisation hiérarchique : **Familles** (conteneurs) → **Variétés** (plantes avec données culturales)
- Familles dépliables/repliables (▶/▼), boutons "Tout déplier/replier"
- Recherche intelligente : filtre sur familles ET variétés (si une variété matche, sa famille s'ouvre)
- Colonnes configurables : ⚙️ menu pour choisir les colonnes visibles (sauvegardé en localStorage)
- Colonnes redimensionnables : drag sur les séparateurs de colonnes
- Colonnes disponibles : Espacement, Calendrier, Conseil, Nom latin, Famille bot., Exposition, Arrosage, Type, Semis, Récolte
- Ajout via IA (Ollama) avec choix de la famille parente + lien produit optionnel
- Ajout de famille (conteneur organisationnel : nom, icône, type, couleur)
- Fiche plante détaillée (PlantSheet) avec édition, variétés, images IA, changement de famille

### Calendrier cultural (référence globale)
- Vue Gantt 12 mois, toutes les plantes du catalogue
- Toggle **🌤️ Plein air / 🏡 Serre** (couleurs vertes vs bleues)
- Champs séparés : `semis`/`recolte` (plein air) et `semis_serre`/`recolte_serre` (serre)
- Adaptation au climat local : mois incompatibles grisés (gel, germination)
- En-tête avec températures et ensoleillement par mois

---

## Calendrier du Jardin

Onglet 📅 dans le planificateur — suivi des plantes réellement dans les bacs.

### Vue Calendrier
- Grille mensuelle avec cases par jour (comme le calendrier des tâches)
- Navigation ◀ ▶ par mois + bouton "Aujourd'hui"
- Événements par jour : 📅 Semis prévu, 🌱 Planté, 📅 Récolte prévue, 🌾 Récolté
- Clic sur un jour → panneau latéral avec détails
- Compteurs par type d'événement

### Vue Liste
- Tableau éditable avec filtres et tris
- **Filtres** : recherche, bac (dropdown avec recherche), statut
- **Tris** : nom, bac, statut, plantation, récolte
- **Sélection multiple** : checkbox par ligne + tout sélectionner
- **Action groupée** : définir plantation ou récolte pour toutes les plantes sélectionnées
- **Fiche plante** : bouton 📖 sur chaque ligne
- Dates futures affichées en bleu avec mention "prévu"

---

## IA — Remplissage des fiches plantes

### Sources de données
1. **Scraping parallèle** de 6 sites français spécialisés (3 premiers résultats retenus) :
   - 🥇 Expert : Promesse de Fleurs, Ferme de Sainte Marthe, Graines Baumaux
   - 🌿 Compléments : Kokopelli, Willemse
   - 📚 Pédagogique : Gamm Vert
2. **Ollama** (qwen2.5:3b) — génère le JSON avec les données botaniques
3. **Localisation** du jardinier — températures et ensoleillement mensuels

### Scraping
- Recherche → suit le meilleur résultat (scoring pertinence) → extrait texte + données structurées + image produit
- Exécution parallèle (ThreadPoolExecutor, 6 workers, timeout 20s global)
- Retourne les 3 premières sources avec du contenu exploitable
- Support URL directe : coller un lien produit pour scraper une page spécifique en priorité
- Noms courts/ambigus (≤6 chars, 1 mot) : enrichis avec "+graines+potager" pour cibler le potager
- Scoring pertinence résultats : nom plante en début de titre, exclut catégories/collections/ornement
- Extraction images : sélecteurs CSS e-commerce + fallback plus grande image + résolution URLs relatives (urljoin)
- Filtrage images : blacklist URL (ensachage, sachet, packaging, logo, banner, popup, emballage)
- Filtrage pertinence images : rejet si le nom de fichier contient un autre légume avant le nom cherché
- Session requests avec CA custom (certificat entreprise) pour le scraping HTTPS

### Options IA
- **Compléter** (défaut) : remplit uniquement les champs vides
- **Tout remplacer** : checkbox pour écraser toutes les valeurs + icône + image
- **Lien produit** : URL optionnelle pour cibler une page produit spécifique

### Adaptation locale
L'IA reçoit les 12 mois de températures min/max + ensoleillement et adapte les périodes de semis/récolte (plein air et serre).

---

## Localisation & Météo

Configuré dans le profil (`/profile`).

- Recherche ville via **Nominatim** (OpenStreetMap)
- Données climatiques via **Open-Meteo Climate API** (normales 1990-2020)
  - Températures min/max mensuelles
  - Ensoleillement moyen (h/jour) via radiation solaire
- Zone USDA calculée automatiquement
- 2 graphiques : températures + ensoleillement
- Données stockées dans `garden_config.location` et exposées via `useAuth().location`
