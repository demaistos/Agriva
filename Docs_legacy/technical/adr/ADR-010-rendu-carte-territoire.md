# ADR-010 — Rendu de la carte territoire (département / région)

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Le joueur choisit son territoire selon une hiérarchie Région → Département → Ville (decisions log : "Carte France : 6-8 macro-régions agroclimatiques"). La carte doit être interactive (clic pour sélectionner) mais n'est pas une carte géographique précise — c'est un outil de sélection de contexte agroclimatique. La stack retenue dans le plan d'implémentation mentionne PixiJS pour le rendu des parcelles, mais la carte territoire est un écran distinct.

Contraintes : pas de WebGL requis, navigateur desktop + mobile responsive (375 px min), pas de client lourd.

## Options considérées

### Option A — SVG statique avec zones cliquables

Un fichier SVG des régions/départements français (simplifié, ~50 Ko) avec des `<path>` cliquables. Les interactions (hover, sélection, highlight) sont gérées en CSS + JavaScript vanilla ou React.

- ✅ Léger (< 100 Ko), pas de dépendance supplémentaire
- ✅ Accessible nativement (ARIA, keyboard navigation possible)
- ✅ Responsive sans effort (SVG scale naturellement)
- ✅ Cohérent avec la contrainte "pas de WebGL"
- ✅ Facile à styliser (couleurs agroclimatiques par région via CSS classes)
- ❌ Animations complexes difficiles (ex. : zoom fluide sur un département)
- ❌ Le SVG des 96 départements français peut être verbeux — nécessite une simplification géométrique

### Option B — Canvas PixiJS avec données GeoJSON simplifiées

Les contours géographiques sont chargés depuis un GeoJSON simplifié et rendus sur un canvas PixiJS. Les interactions sont gérées par PixiJS (hit testing sur les polygones).

- ✅ Animations fluides (zoom, transitions)
- ✅ PixiJS déjà dans la stack (rendu parcelles) — pas de nouvelle dépendance
- ❌ GeoJSON France complet = 500 Ko+ même simplifié ; nécessite un pipeline de simplification
- ❌ Accessibilité nulle nativement (canvas = boîte noire pour les lecteurs d'écran)
- ❌ Complexité disproportionnée pour un écran de sélection utilisé une seule fois (choix de région au démarrage)
- ❌ Performances mobiles dégradées sur canvas avec polygones complexes

### Option C — Carte tileset 2D stylisée

Une carte illustrée (non géographique) avec des zones cliquables superposées. Style "jeu de plateau" cohérent avec l'esthétique farming.

- ✅ Liberté artistique totale, cohérence visuelle forte
- ✅ Peut être très léger (image + overlay HTML)
- ❌ Nécessite un asset graphique dédié (coût de production artistique)
- ❌ Pas de correspondance avec la géographie réelle → confusion pour les joueurs français
- ❌ Difficile à maintenir si les régions agroclimatiques évoluent

## Décision

**Option A — SVG statique avec zones cliquables.**

### Implémentation retenue

**Source SVG** : carte France simplifiée par département (topojson → SVG via `mapshaper`, simplification à 5 % des points). Chaque `<path>` porte un `data-dept-id` et un `data-region-id`.

**Hiérarchie d'interaction** :
1. Affichage initial : 6-8 macro-régions agroclimatiques colorées (palette distincte par climat)
2. Clic sur une région → zoom CSS (`transform: scale`) sur la région, affichage des départements
3. Clic sur un département → sélection, affichage des villes disponibles (liste déroulante, pas de carte)
4. Sélection ville → confirmation

**Intégration React** : composant `<TerritoryMap>` qui charge le SVG inline (pas d'`<img>` — nécessaire pour manipuler le DOM SVG). Les états (hover, selected, available) sont gérés via des classes CSS.

**Mobile** : le SVG est contenu dans un `viewBox` responsive. Sur mobile (< 768 px), la sélection de région se fait via une liste déroulante en fallback si le SVG est trop petit pour être cliqué précisément.

**Accessibilité** : chaque `<path>` reçoit `role="button"`, `aria-label="[Nom région/département]"`, `tabindex="0"`. Navigation clavier supportée.

**Données agroclimatiques** : les 6-8 macro-régions sont définies dans un fichier JSON statique (`regions-agro.json`) qui mappe `dept_id → { region_agro, climate_type, risk_intensity_default }`. Ce fichier est la source de vérité pour le seeding BDD.

## Conséquences

**Positives :**
- Zéro dépendance supplémentaire (SVG + CSS + React)
- Accessible et responsive sans effort supplémentaire
- Le SVG simplifié est < 80 Ko — négligeable dans le bundle
- La carte n'est utilisée qu'une fois (choix de région au démarrage + consultation) — pas besoin d'animations complexes

**Négatives / points de vigilance :**
- Le zoom CSS sur une région peut être saccadé sur mobile bas de gamme — tester sur iPhone SE (375 px). Fallback : liste déroulante si `window.innerWidth < 480`.
- Le SVG simplifié ne sera pas géographiquement précis — acceptable car la carte est un outil de sélection, pas une référence géographique.
- Si V2+ ajoute des régions ou modifie les macro-zones agroclimatiques, le SVG et `regions-agro.json` doivent être mis à jour conjointement.
- PixiJS (déjà dans la stack pour les parcelles) n'est **pas** utilisé pour la carte territoire — les deux contextes sont distincts et ne partagent pas de canvas.

## Références

- `2026-05-07-plan-implementation-v1.md` — §1.1 stack ("Rendu carte/parcelles : PixiJS"), §Sprint 4 (carte France, 6-8 macro-régions)
- `2026-05-07-tech-liveops-v1.md` — §6 compatibilité (pas de WebGL, responsive 375 px, touch targets ≥ 44 px)
- `agriva_decisions_log_compact.md` — "Carte France : Région → département → ville ; 6-8 macro-régions agroclimatiques"
