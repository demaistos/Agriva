# SDD — Table des matières

> Données extraites de france3.simagri.com (export Avril 2026) + règles officielles.

## Architecture
- [00-architecture.md](00-architecture.md) — Stack, BDD, déploiement

## Core
- [01-core.md](01-core.md) — Auth, joueurs, temps, heures de travail, serveurs
- [01b-meteo.md](01b-meteo.md) — Météo enrichie : zones climatiques françaises, températures, prévisions 7 jours, carte de France, alertes

## Règles du jeu
- [../RULES_ENGINE.md](../RULES_ENGINE.md) — **Moteur de règles complet** : alimentation, transport, production, santé, météo, bâtiments, matériel, économie, géographie

## Modules (1 fichier = 1 domaine métier)
| # | Fichier | Domaine | Statut |
|---|---------|---------|--------|
| 02 | [02-batiments.md](02-batiments.md) | Bâtiments, accessoires, énergie, stockage, worker ticks | 📐 SDD complet |
| 03 | [03-cultures.md](03-cultures.md) | Parcelles, cultures, sol, irrigation | 📝 Brouillon |
| 04 | [04-elevage.md](04-elevage.md) | Animaux (lots), grossiste+transport, lots (scinder/regrouper/vendre), stades genrés, rations, reproduction, abattoir, **production d'œufs** | 📐 V1 complet |
| 04b | [04-elevage-dashboard.md](04-elevage-dashboard.md) | **Dashboard élevage** : 13 alertes SimAgri, raccourcis nourrir, estimation eau, type élevage, saisons, brainstorm joueur | 📐 SDD complet |
| 05 | [05-materiel.md](05-materiel.md) | Matériel agricole, **transport (règles globales)**, familles remorques/bétaillère, compatibilité CV, trajets multiples, usure | 📝 En cours |
| 06 | [06-economie.md](06-economie.md) | **Coopérative (V1)**, catalogue aliments (feed_items unifié), prix, routes API complètes | 📝 En cours |
| 07 | [07-metiers.md](07-metiers.md) | Concessionnaire, transporteur, CIA, ETA | 📝 Brouillon |
| 08 | [08-transformations.md](08-transformations.md) | Fromagerie, maraîchage, foie gras, viti | 📝 Brouillon |
| 09 | [09-social.md](09-social.md) | Forum, messagerie, classements, salons | 📝 Brouillon |
| 10 | [10-monetisation.md](10-monetisation.md) | SimPass, packs, options | 📝 Brouillon |

## Roadmap
- [ROADMAP.md](ROADMAP.md) — Phases de développement

---

### Convention de nommage
- Chaque fichier est **autonome** : catalogue, règles métier, SQL, API, tout est dedans
- Quand un brouillon est finalisé → passer le statut à `📐 SDD complet`
- Un fichier = un domaine, pas de mélange entre modules
