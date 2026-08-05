# ADR-007 — Stratégie de test (unit / intégration / gameplay)

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Petit studio, budget test limité. Le plan d'implémentation (§5 ADR table) identifie la stratégie de test comme une décision à trancher avant Sprint 1. La couverture de test doit être suffisante pour détecter les régressions critiques (arbitrage bot, tick défaillant, auth compromise) sans ralentir le développement.

Trois niveaux de couverture ont été évalués.

## Options considérées

### Option A — Tests unitaires sur la simulation uniquement

Couvrir uniquement les modules `tick`, `crops`, `economy` (calculs de rendement, prix bot, aides). Outil : **Vitest** (compatible TypeScript, rapide, même écosystème que Vite/React).

- ✅ Rapide à écrire, rapide à exécuter
- ✅ Couvre les algorithmes les plus critiques (simulation, économie)
- ✅ Faible coût de maintenance
- ❌ Ne détecte pas les régressions d'intégration (ex. : tick qui écrit en BDD de façon incorrecte)
- ❌ Ne couvre pas les endpoints API (bot, marché, auth)

### Option B — Tests unitaires + tests d'intégration sur les endpoints critiques

Unitaires sur la simulation (Option A) + tests d'intégration sur les endpoints : `POST /auth/login`, `POST /market/order`, `POST /tick/run`, `GET /farm/:id`. Outil : Vitest + **Supertest** (HTTP assertions sur Express sans serveur réel).

- ✅ Couvre les chemins critiques de bout en bout (BDD incluse via base de test)
- ✅ Détecte les régressions d'intégration sans infrastructure lourde
- ✅ Coût raisonnable pour un petit studio
- ❌ Nécessite une base PostgreSQL de test (Docker ou in-memory via `pg-mem`)
- ❌ Plus lent que les tests unitaires seuls (~30–60 s pour la suite complète)

### Option C — Tests end-to-end sur les workflows joueur

Couvrir les workflows complets : inscription → onboarding → première vente → classement. Outil : **Playwright**.

- ✅ Teste l'expérience réelle du joueur
- ❌ Très lent (minutes par suite), fragile aux changements UI
- ❌ Coût de maintenance élevé pour un petit studio
- ❌ Inadapté à la phase de développement rapide (Sprint 1–6)

## Décision

**Option B — Tests unitaires + tests d'intégration sur les endpoints critiques.**

Outil retenu : **Vitest** pour les deux niveaux (unitaires et intégration). Supertest pour les assertions HTTP. Base PostgreSQL de test via **`pg-mem`** (in-memory, pas de Docker requis en CI).

### Périmètre de couverture minimal viable

| Module | Type | Couverture cible | Priorité |
|--------|------|-----------------|----------|
| `tick` — séquences 1–8 | Unitaire | ≥ 80 % | P0 |
| `economy` — spread bot, anti-arbitrage | Unitaire | ≥ 80 % | P0 |
| `crops` — calcul rendement, rotation | Unitaire | ≥ 70 % | P0 |
| `auth` — JWT, refresh, logout | Intégration | Chemins nominaux + erreurs | P0 |
| `POST /market/order` | Intégration | Achat, vente, stock plein, arbitrage | P0 |
| `POST /tick/run` | Intégration | Tick complet sans erreur, idempotence | P0 |
| `GET /farm/:id` | Intégration | Auth requise, isolation entre comptes | P1 |
| `livestock` — cycle production | Unitaire | ≥ 60 % | P1 |
| UI / onboarding | Manuel (bêta) | — | P2 |

### Test anti-arbitrage (P0 bloquant en CI)

Un test automatisé vérifie à chaque commit que `achat_bot + revente_immédiate_bot = perte nette`. Ce test est bloquant pour le merge.

### Tests E2E (Playwright)

Reportés à la **bêta fermée** uniquement, sur les 2 workflows critiques : inscription→première vente, et souscription Stripe. Pas de suite E2E complète en V1.

## Conséquences

**Positives :**
- La CI (GitHub Actions ou équivalent) tourne en < 2 min sur les tests unitaires, < 5 min avec l'intégration
- Le test anti-arbitrage est un filet de sécurité permanent sur l'économie
- `pg-mem` évite la dépendance à Docker en CI locale

**Négatives / points de vigilance :**
- `pg-mem` ne supporte pas toutes les fonctionnalités PostgreSQL (ex. : certaines extensions). Si un blocage survient, basculer vers une base PostgreSQL Docker dédiée CI.
- Les tests d'intégration doivent être isolés (transactions rollback après chaque test) pour éviter les effets de bord entre tests.
- La couverture UI reste manuelle jusqu'à la bêta — documenter les cas de test manuels dans `Docs/tests/`.

## Références

- `2026-05-07-plan-implementation-v1.md` — §Sprint 1 critères de done (couverture ≥ 70 % sur `tick` et `auth`), §3 risques (arbitrage bot)
- `2026-05-07-tech-liveops-v1.md` — §5 plan de releases, critères bêta fermée
- `agriva_decisions_log_compact.md` — "Économie : bot filet de sécurité, jamais arbitrage profitable"
