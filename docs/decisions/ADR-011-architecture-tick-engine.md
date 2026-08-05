# ADR-011 : Architecture du Tick Engine

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décisions ouvertes #17, #18, #19, #20
> Impacte : Architecture technique, couche données, scaling, infrastructure

## Contexte

Le tick quotidien (minuit heure FR) traite TOUS les joueurs et assets d'un serveur en une seule passe : croissance cultures, production animale, consommation aliment, usure matériel, météo, gestation, santé. À 1 000 joueurs avec fermes matures (50 parcelles, 200 animaux, 30 équipements chacun), c'est des centaines de milliers d'entités.

Quatre questions architecturales sont indissociables :
1. Comment structurer le pipeline de calcul (#17)
2. Quel ORM/accès données pour le tick (#18)
3. Comment empêcher les conflits joueur/tick (#19)
4. Comment mapper serveur de jeu → infrastructure (#20)

Les traiter séparément créerait des incohérences. Cette ADR les consolide.

---

## Décision #17 — Pipeline READ → COMPUTE → WRITE

### Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Tick séquentiel simple | 1 worker itère sur tous les joueurs | Ne scale pas > 200 joueurs matures |
| **B — Pipeline READ→COMPUTE→WRITE** | Snapshot → partition par joueur → N workers → bulk write | ✅ **Retenue** |
| C — Tick distribué par sous-système | Chaque sous-système est un job indépendant | Dépendances inter-systèmes critiques |
| D — Tick événementiel (lazy eval) | Pas de batch, tick par entité à la consultation | Cohérence temporelle impossible |

### Architecture retenue

```
┌──────────────────────────────────────────────────────────┐
│                    TICK PIPELINE                          │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  1. READ (Snapshot)                                      │
│     └─ Lecture bulk de l'état global serveur             │
│        (joueurs + parcelles + animaux + matériel + sol)  │
│     └─ Résultat : GlobalSimState (immutable)            │
│                                                          │
│  2. COMPUTE (pur, sans I/O)                             │
│     └─ Partition par joueur → PlayerSimState[]          │
│     └─ Chaque joueur = calcul indépendant              │
│        (cultures, élevage, usure, charges, météo)       │
│     └─ Sortie : PlayerTickResult[] (delta à appliquer)  │
│                                                          │
│  3. WRITE (Bulk apply)                                   │
│     └─ Transaction unique par serveur                    │
│     └─ Applique tous les deltas en batch                │
│     └─ Commit ou rollback atomique                      │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Principes

| Principe | Règle |
|----------|-------|
| **Pureté du COMPUTE** | Aucun accès DB/réseau dans la phase COMPUTE — fonctions pures testables unitairement |
| **Idempotence** | Un tick rejoué sur le même snapshot produit le même résultat |
| **Parallélisme opt-in** | Phase 1 : 1 worker séquentiel. Phase 5+ : N workers (la structure le permet sans refactoring) |
| **Observabilité** | Chaque phase loggue : durée, nombre d'entités, erreurs |

### Budget de performance

| Métrique | Cible Phase 1 | Cible Phase 5+ |
|----------|--------------|----------------|
| Joueurs | 100 | 1 000 |
| Temps tick total | < 30 s | < 5 min |
| Temps COMPUTE/joueur | < 200 ms | < 300 ms |
| Workers | 1 | 4-8 |

---

## Décision #18 — Couche d'accès données : Prisma API + Drizzle tick

### Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Prisma partout | API et tick avec Prisma | Performance dégradée dès Phase 3 |
| **B — Prisma API + raw SQL tick** | Prisma endpoints, SQL natif pour le tick | ✅ **Retenue (variante Drizzle)** |
| C — Prisma + vues matérialisées | Vues PostgreSQL pré-joignent | Limites sur les writes |
| D — Abandon Prisma → Drizzle partout | Migration complète | Prématuré |

### Architecture retenue

```
┌─────────────────────────────────────────┐
│              APPLICATION                 │
├──────────────────┬──────────────────────┤
│   API REST/WS    │    TICK ENGINE       │
│   (Prisma ORM)   │    (Drizzle ORM)     │
│   • CRUD joueur  │    • Bulk SELECT     │
│   • Actions      │    • Batch INSERT    │
│   • Requêtes     │    • Raw SQL quand   │
│     paginées     │      nécessaire      │
├──────────────────┴──────────────────────┤
│          PostgreSQL (par serveur)        │
└─────────────────────────────────────────┘
```

### Pourquoi Drizzle et non du raw SQL pur

- Type-safety maintenue (pas de `string` SQL non typé)
- Migrations partagées avec Prisma (même schéma)
- Bulk operations natives (`drizzle.insert(...).values([...])`)
- Requêtes complexes lisibles sans string templates
- Pas de N+1 par design (jointures explicites)

### Interfaces structurantes (à poser dès Phase 1)

```typescript
// Snapshot global immutable lu en phase READ
interface GlobalSimState {
  tick: number;
  date_ig: Date;
  meteo: MeteoState;
  prix_marche: Map<ProduitId, number>;
  joueurs: PlayerSimState[];
}

// État d'un joueur snapshot pour le COMPUTE
interface PlayerSimState {
  joueur_id: string;
  parcelles: ParcelleState[];
  animaux: AnimalState[];
  materiel: MaterielState[];
  stock: StockState;
  finances: FinanceState;
  employes: EmployeState[];
}

// Résultat du COMPUTE pour un joueur (delta)
interface PlayerTickResult {
  joueur_id: string;
  mutations: Mutation[];  // liste d'opérations à appliquer
  events: GameEvent[];    // notifications, logs
  erreurs: TickError[];   // problèmes non-bloquants
}
```

---

## Décision #19 — Verrouillage tick/actions : Tick Window global

### Options

| Option | Description | Verdict |
|--------|-------------|---------|
| **A — Tick Window (blocage global)** | API 503 + Retry-After pendant le tick | ✅ **Retenue** |
| B — Lock par joueur granulaire | Lock individuel par ferme | Complexe, deadlock marché |
| C — Snapshot + replay | Queue les actions, rejoue après | Conflits post-tick |
| D — Optimistic + conflict resolution | Détection/résolution post-hoc | Edge cases ingérables |

### Mécanisme

```
23:58:00  ─── Tick programmé dans 2 min ───
23:59:00  ─── LOCK : API refuse les mutations (HTTP 503 + Retry-After: 120) ───
            │  Lectures restent autorisées (GET)
            │  Header indique temps estimé restant
00:00:00  ─── TICK démarre (READ → COMPUTE → WRITE) ───
00:01:30  ─── TICK terminé ───
00:01:30  ─── UNLOCK : API accepte les mutations ───
```

### Contrat

| Aspect | Règle |
|--------|-------|
| **Durée max window** | 2 minutes (au-delà = alerte ops, investigation) |
| **API pendant lock** | `503 Service Unavailable` + header `Retry-After` + header `X-Tick-Progress` |
| **Lectures** | Toujours autorisées (GET) — données peuvent être stale d'un tick |
| **Feedback client** | Bannière « Passage de nuit en cours… » avec countdown |
| **Évolution** | Phase 5+ : si le tick < 30s, passage en lock par joueur (Option B) sans changement d'API |

### Gestion des cas limites

| Cas | Comportement |
|-----|-------------|
| Joueur soumet une action à 23:59:30 | 503, le client retry automatiquement après unlock |
| Tick échoue (crash) | Rollback complet, unlock immédiat, alerte, retry au prochain créneau |
| Tick dépasse 2 min | Continue mais log warning ; ne coupe PAS en plein calcul |

---

## Décision #20 — Mapping serveur → infrastructure : 1 PostgreSQL par serveur de jeu

### Options

| Option | Description | Verdict |
|--------|-------------|---------|
| **A — 1 BDD par serveur de jeu** | PostgreSQL séparé par serveur | ✅ **Retenue** |
| B — Schéma multi-tenant | 1 PostgreSQL, colonne `server_id` partout | Fuite cross-server, index lourds |
| C — Hybride (auth central + jeu shardé) | BDD auth séparée + BDD jeu par serveur | Complexité prématurée |

### Architecture

```
┌─────────────────────────────────────────────────┐
│                  INFRASTRUCTURE                   │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐    ┌──────────────┐           │
│  │  PostgreSQL   │    │  PostgreSQL   │           │
│  │  france_normal│    │  france_expert│           │
│  │  (port 5432) │    │  (port 5433) │           │
│  └──────┬───────┘    └──────┬───────┘           │
│         │                    │                   │
│  ┌──────┴───────┐    ┌──────┴───────┐           │
│  │  API + Tick   │    │  API + Tick   │           │
│  │  Worker       │    │  Worker       │           │
│  └──────────────┘    └──────────────┘           │
│                                                  │
│  ┌──────────────────────────────────────┐       │
│  │  Auth Service (partagé)              │       │
│  │  • Comptes utilisateur               │       │
│  │  • Sessions                          │       │
│  │  • Choix serveur                     │       │
│  └──────────────────────────────────────┘       │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Principes

| Principe | Règle |
|----------|-------|
| **Isolation totale** | Aucune donnée de jeu partagée entre serveurs |
| **Auth partagée** | 1 compte utilisateur → choix de serveur à l'inscription |
| **Même schéma** | Les BDD de jeu ont le même schéma, mêmes migrations |
| **Scaling horizontal** | Nouveau serveur = nouvelle BDD + nouveau worker |
| **Backups indépendants** | Chaque BDD sauvegardée séparément |

### Pourquoi pas multi-tenant

- Le tick doit traiter 100% d'un serveur atomiquement — un `WHERE server_id = X` sur chaque requête est un risque de fuite et un coût d'index
- L'isolation empêche un bug d'un serveur de contaminer l'autre
- Le scaling est trivial (ajouter un VPS)
- Les migrations sont identiques (même schéma) donc pas de surcoût ×N en pratique

### Service Auth

L'authentification est le SEUL composant partagé :
- Table `users` (email, mot de passe, préférences)
- Table `user_servers` (user_id, server_id, created_at)
- Un joueur peut avoir un compte sur chaque serveur (progression séparée)

---

## Conséquences globales

### À implémenter Phase 1

- [ ] Interface `GlobalSimState` / `PlayerSimState` / `PlayerTickResult`
- [ ] Pipeline READ→COMPUTE→WRITE séquentiel (1 worker)
- [ ] Drizzle configuré pour le tick engine, Prisma pour l'API
- [ ] Tick window avec 503 + Retry-After
- [ ] 1 BDD PostgreSQL par serveur + auth service séparé
- [ ] Logging/métriques sur chaque phase du tick

### À implémenter Phase 5+

- [ ] Parallélisme COMPUTE (N workers via worker_threads ou process pool)
- [ ] Évaluer passage en lock par joueur si tick < 30s
- [ ] Monitoring : durée tick, mémoire, latence write

### Interdits

- ❌ Ne pas utiliser Prisma dans le tick engine (trop lent pour le bulk)
- ❌ Ne pas faire d'I/O dans la phase COMPUTE (fonctions pures uniquement)
- ❌ Ne pas partager de données de jeu entre serveurs
- ❌ Ne pas dépasser 2 min de tick window sans investigation
- ❌ Ne pas faire de multi-tenant « pour économiser » — c'est une optimisation prématurée
- ❌ Ne pas couper un tick en cours (toujours aller au bout ou rollback complet)
