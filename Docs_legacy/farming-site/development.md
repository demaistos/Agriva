# Farming Site — Development Rules

## Stack
- Frontend: React 19 + Vite, inline styles, CSS variables in index.css
- Backend: FastAPI + SQLAlchemy + PostgreSQL
- AI: Ollama (qwen2.5:3b, local)
- Deploy: docker-compose up -d --build

## Code Style

### Frontend
- 1 composant = 1 fichier, max ~300 lignes — extraire si plus
- Composants en PascalCase, hooks en useCamelCase, utils en camelCase
- Hooks custom pour la logique partagée (useAuth, useCatalog, useFavorites)
- Utils pour les fonctions pures (months.js, garden.js)
- Constants centralisées dans constants/index.js
- State local (useState) pour l'UI, Context pour le state global
- Inline styles cohérents avec l'existant, variables CSS (--green, --border, etc.)
- Toujours try/catch sur les appels API avec feedback utilisateur
- Pas de catch {} vide — au minimum console.error
- Pas de bibliothèque UI externe (pas de MUI, Tailwind, etc.)
- React.memo sur les composants lourds re-rendus fréquemment (Bed, PlantRows)
- Composants UI réutilisables dans components/ui/ (PlantIcon, SearchSelect)
- Préférences utilisateur (colonnes, largeurs, ordre) sauvegardées en localStorage

### Backend
- snake_case pour fichiers, fonctions, variables
- Schémas Pydantic pour chaque endpoint (entrée + sortie)
- Validation côté backend systématiquement, ne jamais faire confiance au frontend
- HTTPException avec messages clairs en français
- Vérification 404 sur tous les endpoints update/delete
- Migrations inline dans main.py avec try/except (pas d'Alembic)
- Nouvelles colonnes toujours avec valeur par défaut
- JSON dans TEXT pour données flexibles (meta, garden_config)
- Index DB sur les colonnes filtrées (user_id, parent_id, name)
- logging.warning sur les except des API externes, jamais de except silencieux
- Session requests avec CA custom pour le scraping (certificat entreprise)

## Architecture
- Backend = source de vérité
- Codes HTTP cohérents : 200/201/204/400/401/404/422/500
- JWT avec expiration, intercepteur 401 côté frontend (auto-logout)
- Pas de secrets dans le code source — variables d'environnement via .env
- useAuth centralise garden_config — un seul appel /auth/me au démarrage
- useFavorites consomme useAuth, pas d'appel /auth/me séparé

## Navigation
- Sidebar unifiée sur toutes les pages (composant Sidebar dans App.jsx)
- Collapsed (icônes, 54px) sur /garden, étendue (220px) ailleurs
- 5 liens : 🏡 Mon Jardin, 📚 Catalogue, 📓 Journal, ✅ Tâches, 👤 Profil
- Déconnexion en bas de la sidebar

## Pages & Onglets
- /garden : 🏡 Mon Jardin (Plan · Plantes · Suivi · Notes)
- /catalog : 📚 Catalogue (Fiches · Calendrier)
- /plants : 📓 Journal (journal personnel de suivi)
- /tasks : ✅ Tâches (Calendrier · Liste)
- /profile : 👤 Profil + localisation + forme jardin

## Catalogue — Organisation
- Famille (parent_id = NULL, a des variétés) = conteneur organisationnel, pas de données culturales
- Variété (parent_id = X) = plante avec toutes les données culturales
- Plante indépendante (parent_id = NULL, pas de variétés) = plante avec données culturales
- Layout CSS grid avec grid-template-columns dynamique
- Colonnes configurables (localStorage catalog-columns), redimensionnables (catalog-col-widths), réordonnables (catalog-col-order)
- Colonne "Plante" redimensionnable aussi (colWidths._plant, défaut 400px)
- Recherche filtre familles + variétés, ouvre automatiquement les familles avec résultats

## IA — Scraping & Remplissage
- 6 sites français : Promesse de Fleurs, Ferme de Sainte Marthe, Graines Baumaux, Kokopelli, Willemse, Gamm Vert
- Scraping parallèle (ThreadPoolExecutor, 6 workers, timeout 20s)
- Scoring pertinence des résultats (nom plante en début de titre produit)
- Noms courts/ambigus (≤6 chars) : enrichis avec "+graines+potager"
- Extraction : texte + données structurées (tableaux clé/valeur) + image produit
- Support URL directe pour scraper une page produit spécifique
- Filtrage images : blacklist URL (ensachage, sachet, packaging, logo, banner)
- Filtrage pertinence images : rejet si nom fichier contient un autre légume avant le nom cherché
- Options : compléter (défaut) ou tout remplacer (force_all)
- Pas d'API externe pour les images (pas d'iNaturalist, GBIF, Wikimedia, DuckDuckGo)
- Session requests avec CA custom (certificat entreprise)
- Body `/fill` : `{ location, url }` — url optionnelle pour scraping direct
- Query params `/fill` : force_icon, force_image, force_all
- Body parsé via `Body(default=FillRequest())` pour compatibilité avec Query params

## Données plantes dans les bacs
- Format : { uid, id, x, y, planted_at, harvested_at }
- planted_at futur = semis prévu, passé = planté
- harvested_at futur = récolte prévue, passé = récolté
- Statuts dérivés automatiquement, pas de champ status séparé
- Statuts enrichis par les périodes du catalogue (semis/recolte) :
  - sow_now : pas planté + période semis en cours
  - sow_overdue : pas planté + période semis dépassée
  - harvest_overdue : planté + pas récolté + période récolte dépassée

## Météo & Alertes gel
- WeatherBanner.jsx : bandeau météo 5 jours via Open-Meteo Forecast API
- Affiché sous les onglets de Mon Jardin, masqué si pas de localisation
- Alertes gel : compare temp min prévue vs temp_frost de chaque plante plantée
- Seuil par défaut 5°C si temp_frost non renseigné dans le catalogue
- Pas de clé API nécessaire (Open-Meteo gratuit)

## Bacs
- Rectangulaire par défaut, polygone custom optionnel (meta.points)
- Resize met à l'échelle les points du polygone proportionnellement
- Taille minimum contrainte par les plantes (getMinBedSize)
- points = null → rectangle, points = [[x,y]...] → polygone custom

## Langue
- Interface utilisateur en français
- Code (variables, fonctions) en anglais
- Commentaires en français si nécessaire, sinon le code doit être auto-explicatif

## Documentation
- README.md : setup + vue d'ensemble
- PROJECT_DOCUMENTATION.md : doc technique détaillée
- Mettre à jour la doc à chaque changement significatif
