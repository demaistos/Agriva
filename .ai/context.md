# Agriva — Contexte Projet

> À fournir au début de chaque session IA pour établir le contexte.

## Le projet

Agriva est un jeu de simulation agricole multijoueur par navigateur. On reconstruit SimAgri (simagri.com) sur une stack moderne. Même profondeur, même couverture fonctionnelle, meilleure UX.

## État actuel

- Phase : **Cadrage terminé, prêt pour Phase 1**
- 119 sous-systèmes inventoriés depuis les règles SimAgri
- 10 phases de développement définies (~43-57 sprints, ~1.5-2 ans)
- Phase 3 = premier prototype jouable (cultures complètes)
- Phase 5 = alpha multijoueur

## Structure

```
K:/GIT/Agriva/
├── .ai/                      # Environnement IA
│   ├── context.md            # CE FICHIER — contexte rapide
│   ├── rules.md              # Règles et conventions
│   ├── project-management.md # Framework de gestion de projet
│   ├── prompts/              # Prompts par rôle (game-designer, architect, developer, reviewer)
│   └── workflows/            # Workflows type
├── docs/
│   ├── foundation/
│   │   ├── FOUNDATION.md     # Source de vérité — vision du projet
│   │   └── ROADMAP.md        # Phases, dépendances, estimations
│   ├── sprints/
│   │   └── CURRENT.md        # Sprint actif
│   ├── design/               # Game design documents
│   ├── specs/                # Spécifications techniques
│   └── decisions/            # ADR (Architecture Decision Records)
├── Docs_legacy/              # Archives (lecture seule)
│   └── SimAgri/              # Règles originales SimAgri + inventaire
│       ├── regles/           # Règles brutes (1.5 Mo)
│       ├── docs/sdd/         # SDD structurés par système
│       ├── GAME_DESIGN.md    # Synthèse game design
│       └── INVENTAIRE_SYSTEMES.md  # Inventaire exhaustif (119 systèmes)
└── src/                      # Code source (futur)
```

## Documents clés à lire selon le contexte

| Tu travailles sur... | Lis d'abord... |
|---------------------|----------------|
| N'importe quoi | `.ai/rules.md` |
| Game design | `.ai/prompts/game-designer.md` + `Docs_legacy/SimAgri/GAME_DESIGN.md` |
| Architecture | `.ai/prompts/architect.md` + `docs/foundation/ROADMAP.md` |
| Code | `.ai/prompts/developer.md` + sprint en cours |
| Review | `.ai/prompts/reviewer.md` |
| Planification | `.ai/project-management.md` + `docs/sprints/CURRENT.md` |

## Règles fondamentales

1. SimAgri est le modèle — "est-ce que SimAgri le faisait ?" → alors on le fait
2. Tout le dev est fait par IA, supervisé par humain
3. Chaque session produit un livrable concret
4. TDD obligatoire
5. On ne sort pas de la phase en cours (pas de scope creep)
