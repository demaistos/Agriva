# Cultivia — Index Documentation

> Simulateur agricole multijoueur web — 199 flows (138 MVP), 8 boucles de gameplay

---

## 📁 Structure

```
docs/
├── 00-reference/              # Sources SimAgri (règles originales)
│   ├── regle sim.txt          # Règles complètes SimAgri (source de vérité)
│   └── extracted_rules.txt    # Règles extraites et formatées
│
├── 02-architecture/           # Architecture technique
│   ├── 01_DATA_MODEL.md       # 152 tables SQL + diagramme ER
│   ├── 02_GAME_SYSTEMS.md     # Formules, tick journalier (24 étapes), temps
│   ├── 03_CONTENT_DATA.md     # Catalogue contenu (cultures, races, matériels)
│   ├── 04_PRODUCT_ROADMAP.md  # Roadmap produit
│   ├── 05_SCALABILITY.md      # Architecture scalable (PgBouncer, Redis, WS)
│   ├── 06_SDD_COMPLEMENTS.md  # DoD, ~140 codes erreur, mapping tables, anti-triche
│   ├── 07_PLAN_ACTION_AGILE_V2.md  # Plan agile Élevage First (16 sprints)
│   ├── 08_EQUILIBRAGE_ECONOMIQUE.md # 3 kits démarrage, prix, formules
│   ├── 09_METHODOLOGIE_DEPLOIEMENT.md # Branches, PR, sprints, déploiement, rollback
│   └── 10_PLAN_EXECUTION_SPRINTS.md  # Tâches dev + tests + validation par sprint # Branches, PR, sprints, déploiement, rollback
│
├── 03-specs/                  # Spécifications fonctionnelles
│   ├── ACTION_FLOW_REGISTRY.yaml  # ⭐ 199 flows (138 MVP) (source de vérité)
│   ├── BOUCLES_GAMEPLAY.md    # ⭐ 8 boucles détaillées (OÙ/VOIT/SAISIT/RÉSULTAT)
│   ├── MATRICE_ESPECES.md     # Matrice transport/bâtiment/production par espèce
│   ├── BACKLOG_AMELIORATIONS.md # 37 améliorations UX/Design par sprint
│   ├── FLOWS_POST_MVP.md      # 61 flows post-MVP (Sprint 14-20+)
│   ├── API_ROUTES.md           # 86 routes API générées
│   ├── openapi.yaml            # Spec OpenAPI 3.0 (importable Swagger/Postman)
│   ├── 06_SPEC_TECHNIQUE_MUTATIONS.md  # 77 mutations, règles universelles
│   ├── GAMEPLAY_VALIDATION.md # Validation gameplay vs SimAgri
│   ├── phases/                # Specs par phase (0-6)
│   ├── sprints/               # 12 specs end-to-end (Sprint 01-12)
│   └── ux/                    # Specs UX par phase
│
├── 05-design/                 # Design & UX
│   ├── 01_IDENTITE_VISUELLE.md
│   ├── 02_QOL_UX.md
│   ├── 03_IDENTITE_CULTIVIA.md
│   ├── 04_AUDIT_UX_SIMAGRI.md
│   ├── 05_COMPLEMENTS_UX_AUDIT.md
│   ├── 06_CATALOGUE_COMPOSANTS.md  # 20 composants UI + 5 composables
│   └── 07_MAQUETTES_ASCII.md       # Wireframes dashboard, inscription, animal, parcelle
│
├── 06-guide-joueur/
│   └── GUIDE_COMPLET.md       # Guide joueur (à synchroniser)
│
├── reports/                   # 18 rapports (audits + playtests + reviews)
│   ├── METHODOLOGY_FLOWS.md   # Méthodologie d'audit des flows
│   ├── AUDIT_BOUCLE_*.md      # 4 audits par boucle
│   ├── AUDIT_DEPENDANCES_CROISEES.md
│   ├── AUDIT_ESPECES_COMPLETUDE.md
│   ├── AUDIT_INTERFACE_UX.md
│   ├── AUDIT_MISE_A_JOUR_SDD.md
│   ├── AUDIT_REALISME_TRANSPORT.md
│   ├── REVIEW_COMPLETE_REGISTRY.md
│   └── REVIEW_GLOBALE_DOCS.md
│
├── 99-export/                 # Référence SimAgri
│   ├── INDEX_PAGES_SIMAGRI.md # Index des 240 pages SimAgri
│   ├── all_extracted.txt      # Texte extrait de toutes les pages
│   └── extracted_rules.txt    # Règles extraites
│
├── assets/screenshots/        # Captures flow-editor
├── _archive/                  # Anciens docs (v1, sections temp)
└── CONTRIBUTING.md            # Guide contribution
```

## 📊 Chiffres clés

| Métrique | Valeur |
|----------|--------|
| Flows MVP (complets) | 138 |
| Flows post-MVP (définis) | 61 |
| Flows total | 199 |
| Routes API (OpenAPI) | 86 |
| Boucles de gameplay | 8 MVP + 8 post-MVP = 16 |
| Tables SQL | 152 |
| Codes erreur | ~140 |
| Sprints E2E | 12 |
| Types véhicules (seed) | 90 |
| Types bâtiments (seed) | 30 |
| Cultures (seed) | 24 |
| Espèces animales | 16 |
| Rapports | 27 |
| Améliorations UX/Design backlog | 37 |
| Problèmes playtest corrigés | 61 |
| Composants UI catalogués | 20 |
| Prompts agents | 13 |
| Docs actifs | 77 |

## 🔑 Documents clés (par ordre de lecture)

1. **`03-specs/BOUCLES_GAMEPLAY.md`** — Parcours utilisateur complet par boucle
2. **`03-specs/ACTION_FLOW_REGISTRY.yaml`** — Source de vérité des 199 flows (138 MVP)
3. **`02-architecture/01_DATA_MODEL.md`** — Modèle de données complet
4. **`02-architecture/02_GAME_SYSTEMS.md`** — Formules et tick journalier
5. **`02-architecture/08_EQUILIBRAGE_ECONOMIQUE.md`** — Kits et équilibrage
6. **`02-architecture/07_PLAN_ACTION_AGILE_V2.md`** — Plan de développement
7. **`03-specs/sprints/SPRINT_XX_END_TO_END.md`** — Specs par sprint

## 🛠️ Outils

- **Flow Editor** : `tools/flow-editor/` — Visualisation interactive des 199 flows (138 MVP)
  - Mode Macro : vue globale + highlight dépendances
  - Mode Parcours : graphe par boucle
  - Mode Boucles : parcours métier narratif + recherche globale
  - Lancer : `cd tools/flow-editor && npm run dev` → http://localhost:5555
