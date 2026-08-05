# Agriva — Development Guide

> Guide de travail pour l'équipe multi-agent IA. Phase actuelle : game design.

---

## Démarrage dev local

```bash
# 1. Démarrer la DB
docker compose up -d postgres

# 2. Migrations + seed (première fois ou après reset)
cd api
npx prisma migrate dev
npx prisma db seed

# 3. Lancer l'API (terminal 1)
DATABASE_URL=postgresql://agriva:dev@localhost:5432/agriva \
JWT_SECRET=dev-secret JWT_REFRESH_SECRET=dev-refresh-secret \
npx tsx src/index.ts

# 4. Lancer le frontend (terminal 2)
cd frontend && npm run dev
# → http://localhost:5173
```

## Tests automatisés (Playwright)

Les tests réutilisent l'API et le frontend s'ils tournent déjà (`reuseExistingServer: true`).
Les données de test sont isolées (emails `e2e_TIMESTAMP@` / `ui_TIMESTAMP@`) — elles ne polluent pas les données manuelles.

```bash
# Tests API (sans frontend)
cd api
DATABASE_URL=... npx playwright test

# Tests UI (avec frontend)
cd frontend
DATABASE_URL=... npx playwright test

# Tests unitaires
cd api && npx vitest run
```

## Reset DB (si besoin)

```bash
docker compose down -v   # supprime le volume postgres
docker compose up -d postgres
cd api && npx prisma migrate dev && npx prisma db seed
```

## Lancer les agents

```bash
# Lead (coordinateur)
kiro chat --agent lead
# Raccourci : Ctrl+Shift+G

# Agents spécialistes
kiro chat --agent core-design       # Vision, piliers, cohérence
kiro chat --agent systems-farming   # Cultures, élevage, sols, météo
kiro chat --agent economy-markets   # Bot, marché, stockage, classements
kiro chat --agent ui-onboarding     # Écrans, workflows, onboarding
kiro chat --agent social-meta       # Social, difficulté, succès
kiro chat --agent tech-liveops      # Technique, télémétrie, releases
kiro chat --agent doc-qa            # Documentation, QA, scénarios

# Agents lecture seule
kiro chat --agent reviewer          # Revue de design — Ctrl+Shift+R
kiro chat --agent onboarding        # Exploration projet — Ctrl+Shift+N
```

## Workflow de design (nouvelle feature)

1. **Ouvrir le lead** : `kiro chat --agent lead`
2. **Décrire la feature** — le lead explore le contexte et propose des approches
3. **Valider l'approche** — le lead écrit la spec dans `Docs/specs/YYYY-MM-DD-<topic>.md`
4. **Dispatcher** — le lead délègue aux agents spécialistes concernés
5. **Revue** — ouvrir le reviewer (`Ctrl+Shift+R`) pour valider la spec
6. **Consolider** — le doc-qa intègre et met à jour la documentation

## Workflow de revue

```bash
# Ouvrir le reviewer
kiro chat --agent reviewer
# → Donner le chemin de la spec à réviser
# → Le reviewer produit un rapport avec sévérités : 🔴 BLOQUANT | 🟠 ATTENTION | 🟡 SUGGESTION | ✅ OK
```

## Structure des outputs

```
Docs/specs/YYYY-MM-DD-<topic>.md    # Spec détaillée d'un système
Docs/plans/YYYY-MM-DD-<feature>.md  # Plan d'implémentation
.kiro/state/<agent>.json            # État persistant d'un agent
.kiro/logs/                         # Logs d'activité (JSONL)
```

## Références clés

| Fichier | Usage |
|---------|-------|
| `Docs/external-refinement/agriva_document_complet_long.md` | Source de vérité complète |
| `Docs/external-refinement/agriva_decisions_log.md` | Décisions V1 figées |
| `Docs/external-refinement/agriva_agents_roles.md` | Rôles et responsabilités agents |
| `Docs/MEMORY.md` | Contexte persistant inter-sessions |
| `Docs/ARCHITECTURE.md` | Architecture des systèmes de jeu |

## Règles de travail

- **Ne jamais modifier** `agriva_decisions_log.md` sans validation lead + core-design.
- **Toujours marquer V2+** les features hors scope V1.
- **Citer les sources** (fichier + section) quand on affirme une décision V1.
- **Specs** dans `Docs/specs/`, **plans** dans `Docs/plans/` — jamais dans `external-refinement/`.
- **Commits** : uniquement sur demande explicite.

## Reprise de contexte après compaction

Si un agent a sauvé son état dans `.kiro/state/<agent>.json` :
```bash
cat .kiro/state/lead.json
# → Reprendre depuis last_completed_step
```
