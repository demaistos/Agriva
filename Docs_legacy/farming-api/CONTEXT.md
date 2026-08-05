# Contexte Verdura — À relire au redémarrage de Kiro

## Projet
Verdura — Encyclopédie du Potager & Fruitier. API REST Node.js/Express + frontend SPA vanilla JS. PostgreSQL via Docker (port 5433). GitHub: https://github.com/demaistos/farming-api

## État actuel
- **28913 variétés réelles**, **143 plantes**, **28 zones USDA**
- Données scrapées de : Ferme de Sainte Marthe, Wikipedia FR/EN, Au Jardin, Planfor, Promesse de Fleurs
- Backend : Express + Helmet + CORS + rate limiting + XSS sanitize + API key auth (cache 60s) + asyncHandler
- Frontend : SPA FR/EN, explore avec filtres, favoris, comparateur, calendrier auto-zone, dark mode, toasts, onboarding
- Admin : monitoring temps réel, historique, export/import
- Tests : 49 API + 26 Playwright
- Sécurité : audit complet fait (helmet, path traversal, admin-only plants, email validation, etc.)

## Commandes clés
```bash
docker-compose up -d --build   # Lancer tout
npm run db:full                # Reset + import données réelles
npm run dev                    # Backend seul (port 3000)
npm run frontend               # Frontend seul (port 3001)
npm test                       # Tests API
npm run test:ui                # Tests Playwright
```

## Structure données
- `backend/db/data/*.json` — 18 fichiers de variétés réelles
- `backend/db/import.js` — script d'import (lit les JSON, déduplique)
- `backend/db/seed.js` — données de base (zones, users, 65 variétés manuelles)

## Ce qui reste à faire avec Playwright MCP

### Scraping profond Promesse de Fleurs
Le site charge les produits en JavaScript (pagination AJAX). Le scraping HTML statique n'a récupéré que ~40 produits par page sur les 276 tomates (et pareil pour les autres catégories).

Avec Playwright MCP, il faut :
1. Naviguer sur chaque page "de A à Z" :
   - `https://www.promessedefleurs.com/potager/graines-potageres/graines-de-tomate/tomates-de-a-a-z.html` (276 tomates)
   - `https://www.promessedefleurs.com/potager/graines-potageres/graines-de-carotte.html`
   - `https://www.promessedefleurs.com/potager/graines-potageres/graines-de-courgette.html`
   - `https://www.promessedefleurs.com/fruitiers/fruitiers-de-a-a-z.html`
   - `https://www.promessedefleurs.com/fruitiers/petits-fruits/petits-fruits-de-a-a-z.html`
   - Et toutes les sous-catégories potager + fruitiers
2. Scroller jusqu'en bas pour déclencher le lazy loading (ou cliquer "Charger plus")
3. Extraire les noms de produits (class `product-item-link` ou JSON-LD `"name"`)
4. Sauvegarder dans `backend/db/data/35-promesse-deep.json` au format standard
5. Lancer `npm run db:full` pour réimporter

### Autres sites à scraper avec Playwright
- **Kokopelli** (kokopelli-semences.fr) — bloque le scraping statique, JS requis
- **Graines Baumaux** (graines-baumaux.fr) — même problème
- **Vilmorin** (vilmorin-jardin.fr) — seule la page tomates marchait en statique

### Format JSON attendu pour les données
```json
[{
  "name_fr": "Tomate",
  "name_en": "Tomato", 
  "type": "fruit",
  "lifecycle": "annuelle",
  "companions": {"good": "", "bad": ""},
  "varieties": [{
    "name_fr": "Nom Variété",
    "name_en": "Variety Name",
    "desc_fr": "Description courte.",
    "desc_en": "Short description.",
    "yield": "Moyen",
    "taste": "Douce",
    "resistance": "Bonne",
    "sun": "full",
    "water": "medium",
    "soil": "Riche",
    "spacing": "60cm",
    "sow_start": "02",
    "sow_end": "04",
    "harvest_start": "07",
    "harvest_end": "10",
    "tags": "{potager,été}"
  }]
}]
```

### Nettoyage après import
Toujours lancer le script de nettoyage 3 passes après un nouvel import :
1. Supprimer citations, auteurs, termes scientifiques
2. Déduplication normalisée (accents, tirets, espaces)
3. Quasi-doublons >85% similarité

Le script est dans l'historique git (commit `199e414`), à adapter si besoin.
