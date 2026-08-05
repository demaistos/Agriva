# CULTIVIA — Steering Document (Document de Pilotage)
## Version 2.2 — Mis à jour le 2026-04-09

---

# 1. RÉSUMÉ PROJET

| Élément | Valeur |
|---------|--------|
| **Nom** | Cultivia |
| **Type** | Jeu de simulation agricole multijoueur par navigateur |
| **Inspiré de** | SimAgri (2005-2026) |
| **Modèle économique** | 100% gratuit, aucun paiement |
| **Serveur** | 1 seul (France) |
| **Infra** | Docker Compose, local en dev, VPS en prod |
| **Stack** | Next.js 15 / tRPC / PostgreSQL 16 / Redis 7 / Socket.io |
| **Localisation** | Préfectures/sous-préfectures réelles de France (~340 communes) |
| **Météo** | Dynamique par département via Open-Meteo (min/max réels) |
| **Ressource principale** | HT (Heures Travaillées) — 35/jour |

---

# 2. DOCUMENTATION COMPLÈTE

| # | Document | Lignes | Contenu |
|---|----------|--------|---------|
| 01 | `GDD_vision_systeme.md` | 115 | Vision, HT, temps, météo dynamique Open-Meteo, localisation 2 263 communes |
| 02 | `GDD_activites_elevage.md` | 200 | 11 activités, 14 espèces, ration standard+libre (24 ingrédients, 9 profils), reproduction, 14 indices génétiques, IVRAD |
| 03 | `GDD_commerce_cultures_materiel.md` | 264 | Commerce (8 canaux), 26+ cultures, bonus rendement +65% (5 types parcelle), réglage coupe, 9 familles matériel, 25+ bâtiments |
| 04 | `GDD_finance_transport_social.md` | 190 | Finance, transport (8 types semi), 13 types employés, social, 9 activités secondaires |
| 05 | `TDD_architecture.md` | 521 | Docker Compose, BDD 62 tables, moteur de jeu, ~230 API routes, WebSocket |
| 06 | `UIUX_specs.md` | 694 | Layout, 21 pages wireframe, DataTable (27 tableaux, groupes déroulants), 7 flows, inscription carte SVG |
| 07 | `staffing_competences.md` | 172 | 5.5→9.5 personnes, 50+ compétences, 10 phases, risques |
| 08 | `ACTIONS_DETAILLEES.md` | 7 039 | **324 actions** step-by-step avec prérequis, étapes, validations, impacts |
| **09** | **`STEERING.md` (ce fichier)** | — | Pilotage, 24 décisions, roadmap |
| 10 | `DEPLOYMENT_PLAN.md` | 1 480+ | **137 features**, 10 phases, ~51 semaines, 324 actions couvertes |
| 11 | `AUDIT_UX.md` | 209 | 18 problèmes UX, 10 manques, comparaison concurrence, recommandations |

---

# 3. DÉCISIONS CLÉS PRISES

| # | Décision | Détail |
|---|----------|--------|
| D1 | **Pas de zones** | Localisation par préfecture/sous-préfecture réelle, distances en km (Haversine) |
| D2 | **Météo dynamique** | API Open-Meteo, fetch toutes les 6h par département, min/max réels |
| D3 | **100% gratuit** | Aucun SimPass, aucun pack payant, aucun Stripe, toutes activités accessibles |
| D4 | **1 seul serveur** | France uniquement, pas de multi-serveur |
| D5 | **Infra locale** | Docker Compose identique dev/prod, pas de K8s, pas de staging |
| D6 | **Pas de supervision en dev** | Grafana/MinIO uniquement en prod (docker-compose.prod.yml) |
| D7 | **HT remplace PA** | Heures Travaillées, 35/jour, même mécanique |
| D8 | **DataTable universel** | TanStack Table v8, groupes déroulants par catégorie, tri/filtres/colonnes/recherche |
| D9 | **Bonnes pratiques strictes** | TypeScript strict, Zod, CSRF, rate limiting, anti-triche serveur, audit log |
| D10 | **Renommages identité Cultivia** | GénétiSim→Salon Génétique, GénétiVrad→Salon des Races Rares, VitiSim→Concours Viticole, CESA→CECA, CFSA→CFCA |
| D11 | **Événements météo extrêmes** | Canicule, gel tardif, inondation, grêle — alertes + décisions urgentes joueur |
| D12 | **Réputation joueur** | Score fiabilité (livraisons, qualité, délais) visible publiquement |
| D13 | **Prix dynamiques offre/demande** | Fluctuation réelle selon activité joueurs, saisonnalité, pénurie/surplus régional |
| D14 | **Fil d'actualité régional** | Feed social : ventes, concours, naissances des joueurs de la région |
| D15 | **Objectifs personnels** | Jalons individuels avec récompenses ("100 vaches", "500T blé") |
| D16 | **Taxe plus-value parcelles** | Anti-spéculation : 90% (<1 an) à 50% (>5 ans) sur revente parcelles |
| D17 | **Desktop-first** | Responsive de base, pas de mobile-first/PWA pour le MVP |
| D18 | **Ration standard + libre** | Ration standard (achetable, 100% baseline) + ration libre (composée, +10/20/30% bonus selon couverture 4 besoins nutritionnels) |
| D19 | **Suppression qualité ⭐ récoltes** | Pas de qualité ⭐ sur les récoltes/fruits. Le rendement (T/ha) est le seul indicateur. Prix de vente = offre/demande × saison × bio |
| D20 | **Bonus rendement parcelles +65%** | 5 tableaux de bonus par type de parcelle (champ, pré, verger, vigne, maraîchage). Réglage de coupe à la moisson (haute/standard/basse). Appauvrissement sol si export matière |
| D21 | **Carte SVG France** | Inscription : carte SVG avec vrais contours GeoJSON (13 régions métro). Clic région → départements → communes. Pas de Leaflet/MapLibre. |
| D22 | **Thème agricole** | Light par défaut (beige paille, vert prairie, or blé). Dark optionnel (terre nuit). Toggle 🌙/☀️ persisté localStorage. Variables CSS --input-bg/--input-border pour contraste. |
| D23 | **2 263 communes jouables** | 101 préfectures + 2 162 sous-préfectures (> 5 000 hab ou top 8/dept). 2.5M distances Haversine précalculées. |
| D24 | **Tests systématiques** | Cycle obligatoire : Code → Test unit (Vitest) → Test E2E (Playwright) → Test func → Verify all → Commit. Aucun commit si test échoue. |
| D25 | **3 packs de départ** | Bovin (5 PH), Ovin (20 Lacaune), Aviculteur (50 Sussex). Chaque pack inclut : bâtiment élevage + hangar + cuve eau + tracteur + benne + pailleuse + parcelle pré + stock ration 30j + paille. Suffisant pour tenir ~1 mois Cultivia sans achat. |
| D26 | **Tutoriel overlay** | 6 étapes au premier login (animaux, parcelles, coop, HT, démarrage). Skip possible. Marqueur tutorial_completed (0→1→2). |
| D27 | **API Routes avant tRPC** | MVP utilise Next.js API Routes (/api/*) pour simplifier. Migration tRPC prévue Phase 3. 7 routes implémentées. |
| D28 | **Modales confirmation bâtiments** | Chaque action (entretenir, améliorer, agrandir, accessoire, détruire) a sa modale avec avant/après, coût, solde, énergie. Accessoires filtrés par compatibilité bâtiment. Tailles max en BDD. |
| D29 | **Accessoires indépendants** | Tous les accessoires (cuve eau, cuve lait, salle traite, cuve HVC, bac eau, corral, parc volailles, abris porcins, etc.) sont des constructions indépendantes, jamais rattachées à un bâtiment. Pas de parent_building_id. |

---

# 4. MÉTRIQUES DU JEU

| Métrique | Valeur |
|----------|--------|
| Actions documentées | **324** |
| Espèces animales | 14 |
| Races | 30 |
| Cultures | 25 |
| Types de bâtiments | 25+ |
| Types d'accessoires | 15+ |
| Familles de matériel | 9 |
| Modèles matériel (seed) | 29 |
| Activités jouables | 11 |
| Types d'employés | 13 |
| Indices génétiques | 14 |
| Tables BDD | 62 |
| Communes jouables | 2 263 |
| Distances précalculées | ~2.5M |
| Routes API estimées | ~230 |
| Pages UI implémentées | 7 |
| Composants UI | 10 |
| Tests automatisés | 51 |
| Commits | 68 |

---

# 5. ROADMAP DÉVELOPPEMENT

## Phase 0 — Mise en place (2 semaines)
- [ ] Repo monorepo (frontend / api / shared)
- [ ] Docker Compose (5 containers dev)
- [ ] PostgreSQL schema initial + seed géographie (geo.api.gouv.fr)
- [ ] Auth (NextAuth.js v5)
- [ ] Système de design (Shadcn/UI + TailwindCSS)
- [ ] Composant DataTable (TanStack Table v8)
- [ ] CI (lint + type-check + tests)

## Phase 1 — Ferme de base (8 semaines)
- [ ] Système HT (35/jour, reset quotidien, embauche employé)
- [ ] Bâtiments (construire, agrandir, détruire, entretenir, énergie)
- [ ] Élevage base (nourrir, abreuver, pailler, retirer fumier/lisier)
- [ ] Animaux (acheter, vendre abattoir, déplacer, mettre au pré)
- [ ] Traite + collecte œufs + tondre laine
- [ ] Soins (vétérinaire, vacciner)
- [ ] Robot alimentation + nourrissage auto 15j
- [ ] Tableau de bord (alertes, notifications, solde)
- [ ] DAILY_UPDATE worker (aging, hunger, births, growth)

## Phase 2 — Cultures (6 semaines)
- [ ] Parcelles (acheter, louer, Partcel, vendre)
- [ ] Cycle cultural complet (déchaumer → labourer → semer → récolter)
- [ ] 3 techniques culturales
- [ ] Sol (analyse, éléments nutritifs, pierres)
- [ ] Météo dynamique (Open-Meteo, jauges eau/soleil)
- [ ] Épandages (engrais, fumier, lisier, compost, digestat)
- [ ] Irrigation (forage, enrouleur, pivot, retenue collinaire)
- [ ] Paille/foin (faucher, faner, andainer, presser, ramasser)

## Phase 3 — Matériel + Commerce (6 semaines)
- [ ] Catalogue matériel (neuf, occasion, enchères)
- [ ] Usure, entretien, pannes, assurance, pièces
- [ ] HVC (acheter, stocker, plein)
- [ ] GPS, relevage avant, combinés
- [ ] Coopérative Cultivia (acheter/vendre tout)
- [ ] Marché régional/national (animaux)
- [ ] Annonces, appels d'offres

## Phase 4 — Reproduction + Génétique (4 semaines)
- [ ] Insémination (3 modes : Cultivia, CIA, naturelle)
- [ ] Gestation, naissances, saisonnalité
- [ ] Indices génétiques (14 indices)
- [ ] IVRAD (races rares, objectifs génétiques)
- [ ] Salon Génétique, Salon des Races Rares (salons)
- [ ] Labels (bio, plein-air, allaitement)

## Phase 5 — Social + Finance (4 semaines)
- [ ] Amis (3 niveaux), messagerie, MP-Live, forums
- [ ] Compte bancaire, prêts, épargne
- [ ] Employés (embaucher, licencier, salaires)
- [ ] CECA (élections, votes, taxes, primes)
- [ ] Formation CFCA, garde de ferme
- [ ] Challenges, badges, classements, loterie

## Phase 6 — Transport (3 semaines)
- [ ] Licences, chauffeurs, matériel routier
- [ ] Demandes, accepter, charger, livrer
- [ ] Favoris transporteurs/clients

## Phase 7 — Activités secondaires (8 semaines)
- [ ] Concessionnaire (hall, licences, atelier, dépôt-vente, GPS)
- [ ] CIA (labo, contrats, prélèvements, inséminations)
- [ ] Fromagerie (artisanale/industrielle, affinage, marchés/grossistes)
- [ ] ETA (licence, tarifs, commandes)

## Phase 8 — Activités avancées (6 semaines)
- [ ] Maraîchage (serres, cultures, marchés)
- [ ] Viticulture (domaine, vigne, vinification, cave)
- [ ] Forêts/ETF (stations, travaux, vente bois)
- [ ] CAR (huilerie, sucrerie, laiterie, magasin)
- [ ] Méthanisation (digesteur, biogaz, électricité, HVC)
- [ ] Foie gras (gavage, transformation, vente)

## Phase 9 — Finitions (4 semaines)
- [ ] Vue isométrique ferme 3D
- [ ] Animations, micro-interactions
- [ ] Performance (pagination serveur, cache Redis)
- [ ] Mobile responsive
- [ ] Tests E2E (Playwright)
- [ ] Documentation utilisateur

**Total : ~51 semaines (~12 mois)**
