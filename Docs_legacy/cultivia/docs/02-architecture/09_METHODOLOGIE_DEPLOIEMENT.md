# Méthodologie de déploiement — Cultivia

> Process complet : branches, sprints, PR, déploiement, rollback.

---

## 1. Stratégie de branches Git

```
main          ─────●─────────────●─────────────●──── (production)
                   ↑             ↑             ↑
develop       ──●──●──●──●──●───●──●──●──●────●──── (staging)
               ↑  ↑  ↑  ↑  ↑       ↑  ↑  ↑
feature/      ──●──┘  │  │  │       │  │  │
               F001   │  │  │       │  │  │
feature/      ────────●──┘  │       │  │  │
               F002         │       │  │  │
hotfix/       ──────────────────────────●──┘
               fix-login
```

| Branche | Usage | Merge vers | Protection |
|---------|-------|-----------|------------|
| `main` | Production | — | PR obligatoire, 2 approbations, CI verte, pas de force push |
| `develop` | Staging, intégration | `main` (fin de sprint) | PR obligatoire, 1 approbation, CI verte |
| `feature/FXXX-nom` | 1 feature = 1 branche | `develop` | PR obligatoire, 1 approbation |
| `hotfix/description` | Fix urgent prod | `main` + `develop` | PR obligatoire, 1 approbation |

### Nommage des branches
```
feature/F001-construire-batiment
feature/F002-acheter-animal
fix/F008-nourrir-stock-check
hotfix/jwt-refresh-crash
```

### Nommage des commits (Conventional Commits)
```
feat(F001): add building construction endpoint
fix(F008): check stock before feeding
refactor(auth): extract JWT middleware
test(F002): add animal purchase integration tests
docs: update BOUCLES_GAMEPLAY with F113
chore: upgrade vitest to 2.1
```

---

## 2. Process de PR (Pull Request)

### Création
1. Créer branche `feature/FXXX-nom` depuis `develop`
2. Développer (migration → service → route → tests → store → composant)
3. Vérifier la checklist DoD localement
4. Pousser et créer la PR vers `develop`

### Template PR (.github/PULL_REQUEST_TEMPLATE.md)
```markdown
## Flow(s) implémenté(s)
- [ ] FXXX — Nom du flow

## Checklist
- [ ] Migration SQL réversible
- [ ] Service + route + tests unitaires + tests intégration
- [ ] Store Pinia + composant Vue
- [ ] Boutons grisés + tooltips
- [ ] Toast feedback + animate header
- [ ] Idempotency key (si POST)
- [ ] SELECT FOR UPDATE (si déduction solde/stock)
- [ ] Ownership check
- [ ] Registry YAML mis à jour
- [ ] 0 warning TypeScript, 0 ESLint error

## Tests ajoutés
- GIVEN ... WHEN ... THEN ...

## Screenshots (si UI)
```

### Review
- **feature → develop** : 1 approbation requise (n'importe quel dev)
- **develop → main** : 2 approbations requises (dont 1 senior)
- Le reviewer utilise la checklist de `docs/CONTRIBUTING.md §2.5`
- CI doit être verte (lint + typecheck + tests)

### Merge
- Squash merge pour les features (1 commit propre par feature)
- Merge commit pour develop → main (historique des sprints)

---

## 3. Environnements

| Env | URL | BDD | Déploiement | Usage |
|-----|-----|-----|------------|-------|
| **dev** | localhost:3001/5173 | locale (docker) | Manuel (`npm run dev`) | Développement quotidien |
| **staging** | staging.cultivia.fr | PostgreSQL staging | Auto (push sur `develop`) | Test intégration, démo PO |
| **prod** | cultivia.fr | PostgreSQL prod | Manuel (merge `develop` → `main`) | Joueurs réels |

### Données
- **dev** : seeds complets + 5 joueurs test
- **staging** : seeds complets + données anonymisées de prod (si existantes)
- **prod** : seeds complets + données réelles

---

## 4. Cycle d'un sprint (2 semaines)

### Semaine 1 — Développement

| Jour | Activité |
|------|---------|
| Lun | Sprint planning : review des flows du sprint, découpage en tâches |
| Mar-Ven | Développement : 1 feature branch par flow, PR quotidiennes |
| Ven | Code freeze : toutes les PR mergées dans `develop` |

### Semaine 2 — Stabilisation + Livraison

| Jour | Activité |
|------|---------|
| Lun | Déploiement staging. Test intégration complet sur staging. |
| Mar | Fix des bugs trouvés en staging. Re-test. |
| Mer | Démo PO sur staging. Validation ou retour. |
| Jeu | Si validé : merge `develop` → `main`. Déploiement prod. |
| Ven | Sprint review + rétrospective. Mise à jour docs/reports/. |

### Critères de passage au sprint suivant
- [ ] Tous les flows du sprint sont implémentés et testés
- [ ] CI verte sur `develop`
- [ ] Staging stable 24h sans erreur 500
- [ ] PO a validé la démo
- [ ] Docs mises à jour (registry, boucles, changelog)
- [ ] Couverture tests ≥ 80% sur les services du sprint

---

## 5. Process de déploiement

### Staging (automatique)
```
Push sur develop → GitHub Actions :
  1. Lint + typecheck
  2. Tests unitaires + intégration
  3. Build Docker images
  4. Deploy sur staging (docker compose pull + up)
  5. Run migrations
  6. Smoke test (health check + 3 scénarios E2E)
```

### Production (manuel, après validation PO)
```
Merge develop → main → GitHub Actions :
  1. Lint + typecheck + tests (re-run)
  2. Build Docker images (tag = version semver)
  3. Backup BDD prod (pg_dump)
  4. Deploy sur prod (docker compose pull + up)
  5. Run migrations
  6. Smoke test prod
  7. Si échec smoke test → rollback automatique
```

### Rollback
```
En cas de problème post-déploiement :
  1. docker compose down
  2. docker compose pull (image précédente, tag N-1)
  3. docker compose up -d
  4. Si migration irréversible → restaurer backup pg_dump
  5. Créer hotfix branch depuis main
```

---

## 6. Versioning (SemVer)

```
v0.1.0  — Sprint 01 (Auth + Shell)
v0.2.0  — Sprint 02 (Ferme + Géo + Temps)
v0.3.0  — Sprint 03 (Bâtiments + Premier animal)
...
v0.12.0 — Sprint 12 (Matériels + ETA)
v1.0.0  — MVP complet (Sprint 12 validé, beta publique)
v1.1.0  — Sprint 13 (Commerce)
...
```

Patch versions pour les hotfixes : `v0.3.1`, `v0.3.2`...

---

## 7. Feature flags

Pour les features en cours de développement qui ne doivent pas être visibles en prod :

```typescript
// src/shared/flags.ts
export const FLAGS = {
  TRANSPORT: false,      // Sprint 15
  VITICULTURE: false,    // Post-MVP
  DARK_MODE: false,      // Sprint 14
  ENCHERES: false,       // Sprint 15
} as const;
```

Usage :
```vue
<template>
  <TransportPage v-if="flags.TRANSPORT" />
</template>
```

Les flags sont activés par environnement (`FLAGS_TRANSPORT=true` dans `.env`).

---

## 8. Monitoring post-déploiement

Après chaque déploiement prod, surveiller pendant 2h :

| Métrique | Seuil alerte | Action |
|----------|-------------|--------|
| Erreurs 500 | > 5/min | Rollback |
| Latence API p95 | > 500ms | Investiguer |
| Tick journalier | > 10min | Investiguer |
| Connexions BDD | > 80% pool | Scale PgBouncer |
| Mémoire Redis | > 80% | Purger cache |
| Inscriptions | 0 en 1h (si attendu) | Vérifier auth |
