# Agriva — Framework de Gestion de Projet

> Date : 2026-08-03
> Statut : Actif

---

## 1. Philosophie

Tout le développement est réalisé par des IA (avec supervision humaine). Le framework doit :
- Permettre aux IA de travailler de session en session sans perte de contexte
- Produire un livrable concret à chaque session
- Garder une trace de chaque décision et de son raisonnement
- Être simple (pas de Jira, pas de ceremonies — des fichiers markdown)

---

## 2. Unités de travail

### Sprint (2 semaines réelles)
- Objectif clair défini à l'avance
- Résultat : code fonctionnel + tests + documentation
- Rétrospective en fin de sprint (ce qui a marché, ce qui bloque)

### Session (1 conversation IA)
- Commence par : relecture du contexte (`.ai/context.md` + sprint en cours)
- Produit au minimum 1 livrable concret
- Termine par : mise à jour du statut dans le sprint

### Tâche (unité atomique)
- Correspond à 1 feature ou 1 fix ou 1 document
- A un statut : `todo` | `in_progress` | `done` | `blocked`
- Est rattachée à un sprint

---

## 3. Structure du suivi

```
docs/sprints/
├── CURRENT.md              # Sprint en cours (pointeur)
├── phase-1/
│   ├── sprint-01.md        # Objectif + tâches + statut
│   ├── sprint-02.md
│   └── ...
├── phase-2/
│   └── ...
└── backlog.md              # Tâches identifiées non planifiées
```

### Format d'un sprint

```markdown
# Sprint N — [Titre]

> Phase : X
> Dates : YYYY-MM-DD → YYYY-MM-DD
> Objectif : [résumé en 1 phrase]
> Statut : planning | in_progress | done

## Tâches

| # | Tâche | Statut | Notes |
|---|-------|--------|-------|
| 1 | ... | todo/in_progress/done/blocked | ... |

## Décisions prises ce sprint
- ...

## Problèmes rencontrés
- ...

## Résultat
[Ce qui a été livré concrètement]
```

---

## 4. Workflow par session IA

### Début de session
1. Lire `.ai/context.md` (vue globale projet)
2. Lire `docs/sprints/CURRENT.md` (sprint actif)
3. Identifier la prochaine tâche à faire
4. Commencer

### Pendant la session
- Travailler sur la tâche
- Si décision importante → documenter dans `docs/decisions/`
- Si bloqué → documenter le blocage, passer à la tâche suivante

### Fin de session
- Mettre à jour le statut de la tâche dans le sprint
- Si la session a produit du code : s'assurer que les tests passent
- Si du contexte critique a émergé : mettre à jour `.ai/context.md`

---

## 5. Workflow par feature

```
┌──────────────┐
│    DESIGN    │  → docs/design/<feature>.md
└──────┬───────┘
       ↓
┌──────────────┐
│    REVIEW    │  → Validation (agent reviewer ou humain)
└──────┬───────┘
       ↓
┌──────────────┐
│    SPECS     │  → docs/specs/<feature>.md
└──────┬───────┘
       ↓
┌──────────────┐
│  IMPLEMENT   │  → src/modules/<domain>/
└──────┬───────┘
       ↓
┌──────────────┐
│    TEST      │  → Tests unitaires + intégration
└──────┬───────┘
       ↓
┌──────────────┐
│   REVIEW     │  → Code review (agent reviewer)
└──────┬───────┘
       ↓
┌──────────────┐
│    MERGE     │  → Intégration dans la branche principale
└──────────────┘
```

---

## 6. Conventions de branches

```
main                    # Code stable, toujours fonctionnel
├── phase-X/sprint-Y   # Branche de sprint
│   ├── feat/<feature>  # Feature en cours
│   └── fix/<issue>     # Correction
```

---

## 7. Knowledge management

### Ce qui est indexé (knowledge bases Kiro)
- `.ai/` — environnement IA (prompts, règles, workflows)
- `docs/` — documentation projet (fondation, design, specs, sprints)

### Ce qui est en lecture seule (référence)
- `Docs_legacy/SimAgri/` — règles originales SimAgri, inventaire

### Mise à jour des KB
Après modification significative des docs, faire un `update` de la KB correspondante.

---

## 8. Critères de "Done" par type

### Feature
- [ ] Design document rédigé et reviewé
- [ ] Specs techniques produites
- [ ] Code implémenté
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Code reviewé
- [ ] Documentation mise à jour si nécessaire

### Document de design
- [ ] Respecte le format défini dans `.ai/workflows/design-system.md`
- [ ] Couvre Normal ET Expert (si applicable)
- [ ] Identifie les interactions avec les autres systèmes
- [ ] Reviewé (pas de trous fonctionnels)

### Sprint
- [ ] Toutes les tâches "done" ou explicitement reportées
- [ ] Code sur main = fonctionnel + tests passent
- [ ] Décisions documentées
- [ ] Sprint suivant planifié

---

## 9. Règles de décision

| Situation | Action |
|-----------|--------|
| Choix technique impactant | ADR dans `docs/decisions/` |
| Choix de game design | Section dans le design doc + review |
| Incertitude technique | Spike (expérimentation timeboxée, max 1 session) |
| Blocage | Documenter, passer à autre chose, signaler en fin de session |
| Scope creep | Refuser. Mettre dans `backlog.md`. On ne sort pas de la phase en cours. |

---

## 10. Outils

| Besoin | Outil |
|--------|-------|
| Suivi de projet | Fichiers markdown dans `docs/sprints/` |
| Knowledge base | Kiro CLI knowledge (indexation sémantique) |
| Versioning | Git |
| Tests | Vitest + Playwright |
| CI | GitHub Actions (à mettre en place Phase 1) |
| Documentation | Markdown dans le repo |
