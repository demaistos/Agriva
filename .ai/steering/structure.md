# Structure — Agriva

## Organisation du repo

```
K:/GIT/Agriva/
├── .ai/                    # Environnement IA (ce dossier)
│   ├── steering/           # Agent steering (product, structure, tech)
│   ├── prompts/            # Prompts par rôle
│   ├── workflows/          # Workflows de travail
│   ├── context.md          # Contexte rapide pour chaque session
│   ├── rules.md            # Règles projet
│   ├── best-practices.md   # Meilleures pratiques IA
│   └── project-management.md
├── docs/
│   ├── foundation/         # Vision + Roadmap (source de vérité)
│   ├── research/           # Documents réalité vs SimAgri
│   ├── design/             # Game Design Documents
│   ├── specs/              # Spécifications techniques
│   ├── decisions/          # ADR
│   └── sprints/            # Suivi sprints (CURRENT.md)
├── Docs_legacy/            # Archives lecture seule
│   └── SimAgri/            # Règles originales + inventaire
└── src/                    # Code source (futur)
    └── modules/            # Monolithe modulaire par domaine
        ├── auth/
        ├── player/
        ├── culture/
        ├── market/
        └── ...
```

## Conventions fichiers

- Documentation : français, markdown
- Code : anglais, TypeScript
- Fichiers code : kebab-case.ts
- Modules : 1 domaine métier = 1 dossier
- Tests : colocalisés dans `__tests__/`
