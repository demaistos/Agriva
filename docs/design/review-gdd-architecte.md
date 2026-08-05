> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# Review Architecture Technique — Faisabilité du Design Agriva

> Date : 2026-08-04
> Statut : Review critique
> Auteur : Architecte technique (spécialiste jeux web multijoueur temps réel)
> Scope : Faisabilité technique globale du projet Agriva

---

## Contexte de la review

Agriva est un jeu de simulation agricole multijoueur par navigateur visant la parité fonctionnelle avec SimAgri (119 sous-systèmes). L'architecture retenue est un **monolithe modulaire** avec tick-based simulation sur une stack TypeScript/Fastify/PostgreSQL/Redis/React, hébergé sur VPS (Hetzner/OVH).

Ce document évalue la **faisabilité technique** de ce design à l'échelle visée (centaines à milliers de joueurs simultanés).

---

## 1. Questions critiques sur la faisabilité technique

### Q1 — Quelle est la durée cible du tick et comment la garantir sous charge ?

Le tick quotidien (06:00 UTC) doit traiter **tous les joueurs et tous leurs assets** en une seule passe : cultures, animaux, météo, usure matériel, charges, prix marché, régénération heures. Avec 1000 joueurs, chacun ayant potentiellement 50 parcelles, 200 animaux, 30 équipements, et 10 bâtiments — on parle de **centaines de milliers d'entités à traiter en un seul tick**.

**Question** : Quelle est la durée maximale acceptable du tick ? Que se passe-t-il si le tick prend plus de temps que prévu (30 min ? 1 h ? 4 h ?) ? Existe-t-il un mécanisme de dégradation gracieuse (traitement partiel, file d'attente, priorités) ?

### Q2 — Comment le worker de tick est-il parallélisé ?

Le document mentionne un "worker Redis traite les ticks" mais ne spécifie pas la stratégie de parallélisation. Un seul worker Node.js single-threaded ne pourra pas traiter 1000 joueurs × 10 sous-systèmes dans un délai raisonnable.

**Question** : Le tick est-il découpé en sous-tâches parallélisables ? Par joueur ? Par sous-système ? Les deux ? Quelle est la stratégie de partitionnement (sharding par joueur, par serveur, par sous-système) ? Utilise-t-on des worker threads, des processus séparés, ou une queue distribuée ?

### Q3 — Comment l'état partagé est-il géré entre ticks et actions joueur ?

Le joueur peut agir à tout moment pendant la journée (acheter, vendre, semer). Le tick se déclenche à heure fixe. Si un joueur est en train de faire une transaction au moment du tick, l'état est-il cohérent ?

**Question** : Quelle est la stratégie de verrouillage/isolation ? Le tick bloque-t-il les actions joueurs ? Utilise-t-on des transactions PostgreSQL avec isolation level approprié ? Redis comme lock distribué ? Ou une approche optimiste avec retry ?

### Q4 — Quelle est la stratégie de persistence de l'état de simulation ?

Avec 119 sous-systèmes, l'état de chaque joueur est massif (cultures avec stades, animaux avec santé/alimentation/génétique, sols avec 6 éléments, stockages, finances...). Prisma est un ORM performant mais génère des requêtes N+1 facilement.

**Question** : L'état est-il maintenu en mémoire entre les ticks (state in-memory + periodic flush) ou entièrement rechargé depuis PostgreSQL à chaque tick ? Quels sont les benchmarks prévus pour les requêtes de chargement d'état d'un joueur complet ? Quelle est la taille estimée de la BDD à 1000 joueurs actifs après 6 mois de jeu ?

### Q5 — Comment le temps réel (WebSocket) coexiste-t-il avec le tick-based ?

Le design mentionne WebSocket pour le chat et les notifications. Mais le marché joueurs, les prix dynamiques, et le résultat du tick nécessitent aussi des push temps réel.

**Question** : Quel est le volume de messages WebSocket par joueur connecté par minute ? Comment éviter que le broadcast du résultat du tick à 1000 joueurs connectés simultanément ne sature le serveur ? Les WebSocket sont-ils sur le même process que l'API Fastify ou un service dédié ?

### Q6 — Comment migrer la BDD avec 119 sous-systèmes évoluant en parallèle ?

Prisma migrations est excellent pour le développement, mais en production avec des joueurs actifs, les migrations de schéma sur une base avec des millions de lignes (équipements, animaux, parcelles) peuvent prendre des minutes voire des heures.

**Question** : Quelle est la stratégie de migrations zero-downtime ? Utilise-t-on des colonnes temporaires, des vues de compatibilité, du expand-and-contract pattern ? Comment gère-t-on le fait que le tick quotidien ne peut pas être interrompu par une migration ?

### Q7 — Quelle est la stratégie de dégradation quand le nombre de joueurs explose ?

L'objectif va de "centaines" à "milliers" — un facteur 10×. L'architecture VPS unique ne scale pas horizontalement par défaut.

**Question** : À quel seuil de joueurs le monolithe unique atteint-il ses limites ? Le concept de "serveur de jeu" (France, Belgique...) est-il aussi un shard technique ? Peut-on ajouter un VPS et répartir les serveurs de jeu dessus ? Ou faut-il un refactoring architectural complet ?

### Q8 — Comment le calcul de rendement et les formules complexes sont-ils testés à l'échelle ?

Le rendement d'une culture dépend de ~15 multiplicateurs (sol, météo, engrais, rotation, GPS, date de semis, technique culturale, canicule, gel, variété...). La génétique animale a 14 indices. Ces calculs sont le cœur du jeu.

**Question** : Existe-t-il un framework de test de simulation qui vérifie que 1000 fermes évoluant pendant 1 année de jeu (84 ticks) ne produisent pas d'états aberrants (soldes négatifs infinis, rendements impossibles, crashes de formules) ? Comment détecte-t-on les déséquilibres économiques avant la mise en production ?

### Q9 — Quel est le coût de l'event-driven entre 119 modules ?

L'architecture prévoit un découplage event-driven entre modules. Mais avec 119 sous-systèmes, le graphe d'événements peut devenir un labyrinthe. Un événement "récolte terminée" peut déclencher : mise à jour stock, calcul rendement, ajustement prix, paille disponible, impact rotation, journal financier, classement...

**Question** : Comment tracer un événement à travers la chaîne ? Quelle est la stratégie pour éviter les cascades infinies (A → B → C → A) ? Les événements sont-ils synchrones (dans le tick) ou asynchrones (queue Redis) ? Quel est l'overhead de performance d'un système d'événements à 100+ handlers ?

### Q10 — Comment le Prisma ORM résiste-t-il à la complexité des requêtes de tick ?

Le tick doit effectuer des calculs qui nécessitent des jointures complexes : charger une culture avec sa parcelle, son sol (6 éléments), la météo du jour, le matériel utilisé, l'historique de rotation, les traitements appliqués. Prisma encourage les `include` imbriqués qui génèrent des requêtes inefficaces.

**Question** : À quel moment Prisma devient-il un goulot d'étranglement ? Prévoit-on de tomber vers du SQL brut pour les requêtes du tick ? Utilise-t-on des vues matérialisées pour pré-calculer l'état de simulation ? Quelle est la stratégie pour les bulk operations (UPDATE 5000 cultures en un tick) ?

---

## 2. Risques techniques majeurs

### R1 — ⚠️ CRITIQUE : Explosion du temps de tick avec la croissance

**Risque** : Le tick est un goulot d'étranglement unique et non-parallélisable par défaut. Le temps de traitement croît linéairement avec le nombre de joueurs et d'entités. À 1000 joueurs actifs avec des fermes matures (après 6 mois de jeu), le tick pourrait prendre 30+ minutes.

**Pourquoi c'est critique** : 
- Un tick qui dépasse sa fenêtre (24h) est catastrophique — les ticks s'empilent.
- Les joueurs voient un décalage entre leur action et le résultat du tick.
- Aucune mention dans les documents d'un budget de performance cible pour le tick.
- La complexité du tick augmente avec chaque phase (passage de 10 sous-systèmes en Phase 1 à 92+ en Phase 10).

**Impact** : Blocage complet du jeu si non-adressé. Refactoring majeur nécessaire en cours de route.

**Probabilité** : Élevée. Le problème est inévitable à l'échelle visée sans architecture de tick distribuée dès le départ.

---

### R2 — ⚠️ ÉLEVÉ : Prisma comme ORM pour une simulation à haute intensité de données

**Risque** : Prisma est excellent pour les CRUD apps mais devient problématique pour les workloads de simulation :
- Pas de bulk update natif efficace (Prisma `updateMany` est limité).
- Les nested includes explosent en nombre de requêtes (N+1 déguisé).
- Pas de support natif pour les requêtes de streaming (cursor-based iteration sur 100k lignes).
- Le client Prisma a un overhead par rapport au SQL brut (sérialisation/désérialisation).

**Pourquoi c'est un risque** : Le tick doit lire et écrire des dizaines de milliers d'entités. Chaque sous-système (cultures, animaux, usure...) fait des calculs qui nécessitent des jointures complexes. La DX de Prisma va progressivement sacrifier la performance.

**Impact** : Lenteur du tick, consommation mémoire excessive, besoin de contourner Prisma avec du SQL brut (perte de l'avantage type-safety).

**Probabilité** : Élevée. Dès la Phase 3 (cultures actives × météo × sol × matériel), les requêtes du tick seront trop complexes pour le modèle Prisma.

---

### R3 — ⚠️ ÉLEVÉ : Incohérence d'état entre actions temps réel et tick batch

**Risque** : Le jeu a deux modes de mutation de l'état :
1. **Synchrone** : le joueur agit (achète, vend, sème) via l'API REST → mutation immédiate en BDD.
2. **Batch** : le tick quotidien avance toute la simulation → mutations massives.

Si les deux se chevauchent (joueur agit pendant le tick) ou si le tick lit un état incohérent (transaction en cours), les résultats sont imprévisibles : animal vendu mais tick le nourrit quand même, culture semée mais tick ne la voit pas, etc.

**Pourquoi c'est un risque** : Le tick est déclenchée à 06:00 UTC. Si des joueurs sont connectés à ce moment, il y a un conflit potentiel. Le document ne mentionne aucune stratégie de verrouillage ou de fenêtre de maintenance.

**Impact** : Bugs de simulation subtils, perte de données joueurs, économie déséquilibrée.

**Probabilité** : Moyenne-élevée. Le problème se manifestera dès que le tick prend plus de quelques secondes.

---

### R4 — ⚠️ ÉLEVÉ : Scalabilité horizontale impossible sans refactoring

**Risque** : L'architecture monolithe modulaire sur VPS unique ne scale pas horizontalement. Les documents mentionnent explicitement "pas de microservices" et une infra prod sur VPS (Hetzner/OVH).

Quand le serveur unique atteint ses limites (CPU pour le tick, mémoire pour les connexions WebSocket, I/O PostgreSQL), il n'y a pas de plan B documenté.

**Pourquoi c'est un risque** : 
- Un VPS typique (8 cores, 32 GB RAM) peut gérer ~500 connexions WebSocket et un tick de quelques minutes.
- À 1000+ joueurs avec des fermes matures, ce VPS est saturé.
- Le concept de "serveur de jeu" (France, Belgique, Expert) n'est pas clairement mappé à une infrastructure technique (1 BDD par serveur ? Schéma partagé ? VPS séparé ?).

**Impact** : Plateau de joueurs à ~500, impossibilité de croître sans rearchitecture majeure.

**Probabilité** : Moyenne. Le risque ne se matérialise qu'au succès — mais le succès est l'objectif.

---

### R5 — ⚠️ MODÉRÉ : Dette technique accélérée par la vélocité requise (10 phases, 92 groupes)

**Risque** : Le roadmap prévoit 43-57 sprints pour 92 groupes de systèmes. Chaque phase ajoute de la complexité au tick, au schéma BDD, et aux interactions entre modules. La pression pour livrer chaque phase peut forcer des raccourcis :
- Tests de simulation insuffisants.
- Couplage entre modules (événements ad-hoc plutôt que contrats d'interface).
- Optimisations reportées ("on verra quand ça ralentit").
- Migrations de schéma accumulées non-optimisées.

**Pourquoi c'est un risque** : Les 119 sous-systèmes ne sont pas indépendants. Le graphe de dépendances montre des couplages forts (cultures → élevage via paille/foin, matériel → tout, économie → tout). Chaque ajout peut casser un invariant d'un module précédent.

**Impact** : Refactoring massif nécessaire entre Phase 5 et Phase 6, potentiellement 2-3 sprints de "dette technique" non-planifiés.

**Probabilité** : Élevée. C'est le risque classique des projets ambitieux en solo/petite équipe.

---

## 3. Recommandations d'architecture prioritaires

### REC-1 — Concevoir le Tick Engine comme un pipeline parallélisable dès le jour 1

**Le problème** : Un tick monolithique (fonction `processTick()` qui itère séquentiellement sur les joueurs et sous-systèmes) ne tiendra pas l'échelle.

**La recommandation** :

```
Architecture du Tick Engine :

┌─────────────────────────────────────────────────────────────────┐
│                     TICK ORCHESTRATOR (Redis)                     │
├─────────────────────────────────────────────────────────────────┤
│  1. Snapshot de l'état (READ phase) — bloque les mutations       │
│  2. Partition par joueur → N jobs dans une queue Redis            │
│  3. N workers traitent en parallèle (1 worker = 1 joueur)        │
│  4. Chaque worker exécute les sous-systèmes dans l'ORDRE         │
│  5. Résultats écrits en batch (WRITE phase)                      │
│  6. Déblocage des mutations                                      │
│  7. Broadcast résultats via WebSocket                            │
└─────────────────────────────────────────────────────────────────┘
```

**Principes clés** :
- **Phase READ** : snapshot de l'état global (prix, météo) + état par joueur. Aucune mutation pendant cette phase.
- **Traitement parallèle par joueur** : chaque ferme est indépendante pour 90% des calculs. Les interactions inter-joueurs (marché, prix) sont pré-calculées dans l'état global.
- **Workers Node.js multiples** : utiliser `worker_threads` ou BullMQ avec concurrency. Cible : 4-8 workers simultanés.
- **Phase WRITE** : un bulk INSERT/UPDATE PostgreSQL par worker terminé. Utiliser `COPY` ou `INSERT ... ON CONFLICT` pour les performances.
- **Budget de tick** : définir un SLA (ex: tick < 5 minutes pour 1000 joueurs) et monitorer avec des métriques.

**Pourquoi maintenant** : Si le tick est conçu séquentiellement en Phase 1, le refactoring sera douloureux. La structure du pipeline (READ → COMPUTE → WRITE) doit être posée dès le départ, même si le parallélisme n'est activé qu'à Phase 5.

---

### REC-2 — Introduire une couche d'accès données optimisée pour le tick (bypass Prisma)

**Le problème** : Prisma est parfait pour les endpoints REST (CRUD classique). Mais le tick nécessite des patterns incompatibles avec un ORM :
- Chargement de l'état complet d'un joueur en 1 requête (pas 15 includes imbriqués).
- Bulk updates de milliers de lignes (pas `updateMany` avec ses limites).
- Streaming de résultats (pas de chargement de 50 000 lignes en mémoire).

**La recommandation** :

```typescript
// Deux couches d'accès données coexistent :

// 1. Prisma — pour les endpoints REST (90% du code)
// CRUD standard, type-safe, excellent DX
const player = await prisma.player.findUnique({
  where: { id },
  include: { exploitation: true }
});

// 2. SimulationDataLayer — pour le tick engine (10% du code, 90% de la charge)
// SQL brut optimisé, bulk operations, streaming
class SimulationDataLayer {
  // Charge tout l'état d'un joueur en 1 requête (JOIN massif ou vue matérialisée)
  async loadPlayerState(playerId: string): Promise<PlayerSimState> { ... }
  
  // Écrit tous les résultats d'un tick en batch
  async writeTickResults(results: TickResult[]): Promise<void> {
    // INSERT ... ON CONFLICT DO UPDATE (upsert bulk)
    // ou COPY pour les inserts massifs
  }
  
  // Pré-calcule l'état global (météo, prix) une seule fois par tick
  async loadGlobalState(): Promise<GlobalSimState> { ... }
}
```

**Pourquoi** :
- Le type-safety de Prisma reste pour 90% du code (endpoints API).
- Le 10% critique (tick) utilise du SQL optimisé, potentiellement avec des `pg` natif ou `@pgtyped` pour garder un minimum de type-safety.
- Les vues matérialisées PostgreSQL pré-joinent les données fréquemment accédées par le tick.
- Le pattern est clair : Prisma = temps réel (joueur agit), SimulationDataLayer = batch (tick tourne).

**Action immédiate** : Dès Phase 1, concevoir les types `PlayerSimState` et `GlobalSimState` qui représentent tout ce dont le tick a besoin. Même si l'implémentation utilise Prisma initialement, le contrat est posé.

---

### REC-3 — Implémenter un mécanisme de verrouillage tick/action dès Phase 1

**Le problème** : Le conflit entre les actions temps réel du joueur et le tick batch est un bug garanti si non-adressé.

**La recommandation** :

```
Stratégie : "Tick Window" avec verrouillage léger

┌──────────────────────────────────────────────────────────────┐
│  Cycle quotidien                                              │
│                                                               │
│  05:59:00 — PRE_TICK signal (Redis pub/sub)                  │
│    → Refus des nouvelles mutations (API retourne 503 + ETA)  │
│    → Actions en cours finissent (timeout 60s)                 │
│                                                               │
│  06:00:00 — TICK START                                        │
│    → Snapshot + traitement (voir REC-1)                       │
│                                                               │
│  06:XX:XX — TICK END                                          │
│    → Déblocage mutations                                      │
│    → POST_TICK signal                                         │
│    → Push résultats aux joueurs connectés                     │
│                                                               │
│  06:XX:XX → 05:59:00 — PLAY WINDOW                           │
│    → Actions normales, pas de conflit                         │
└──────────────────────────────────────────────────────────────┘
```

**Détails d'implémentation** :

1. **Flag Redis** : `tick:status` = `idle | draining | running | done`
2. **Middleware Fastify** : vérifie le flag avant toute mutation. Si `draining` ou `running`, retourne `503 Service Unavailable` avec un header `Retry-After`.
3. **Frontend** : affiche un bandeau "Tick en cours, le monde avance..." pendant la fenêtre.
4. **Durée de la fenêtre** : objectif < 2 minutes. Si le tick prend plus, c'est un signal d'alerte (cf. REC-1).
5. **Idempotence** : les actions queued pendant le tick sont rejouées après, pas perdues.

**Alternative considérée** : verrouillage au niveau de l'entité (lock par joueur). Plus granulaire mais plus complexe. Recommandé pour Phase 5+ si le tick devient assez rapide pour ne bloquer que quelques secondes.

**Pourquoi maintenant** : C'est un choix structurant. Si le code Phase 1 suppose que les mutations peuvent arriver à tout moment, corriger a posteriori nécessite un audit de chaque endpoint.

---

## 4. Synthèse et verdict

### Le design est-il faisable ?

**Oui, mais avec des conditions non-négociables** :

| Aspect | Verdict | Condition |
|--------|---------|-----------|
| Stack (TS/Fastify/PG/Redis) | ✅ Solide | Aucune — bon choix |
| Monolithe modulaire | ✅ Adapté en V1 | Interfaces strictes entre modules |
| Tick-based simulation | ⚠️ Faisable mais fragile | Pipeline parallélisable dès Phase 1 |
| 119 sous-systèmes | ⚠️ Ambitieux mais phasé | Discipline stricte par phase |
| Centaines de joueurs | ✅ Atteignable | Architecture tick correcte |
| Milliers de joueurs | ⚠️ Nécessite préparation | Sharding par serveur de jeu dès Phase 1 |
| Prisma partout | ❌ Ne tiendra pas | Couche SQL optimisée pour le tick |
| VPS unique | ⚠️ Suffisant pour le lancement | Plan de scalabilité documenté |

### Priorité d'action

1. **Sprint 0** : ADR sur le Tick Engine (pipeline, parallélisme, budget de perf). C'est le cœur technique du jeu.
2. **Sprint 1** : Prototype du tick avec 1000 joueurs simulés (données faker). Mesurer le temps. Itérer.
3. **Sprint 2** : Mécanisme de verrouillage tick/action + SimulationDataLayer (interface, même si implémentation Prisma d'abord).

### Ce que ce design fait BIEN

- Le ratio 1:7 et le tick quotidien sont un excellent choix de game design ET technique (1 calcul/jour au lieu de calculs continus).
- Le monolithe modulaire est le bon choix pour une équipe réduite — évite la complexité opérationnelle des microservices.
- Les phases de roadmap suivent les dépendances techniques — pas de saut en avant dangereux.
- L'event-driven entre modules prépare une future extraction en services si nécessaire.
- Le choix VPS pour le MVP est pragmatique (coût maîtrisé, pas de cloud lock-in).

### Ce que ce design doit clarifier AVANT de coder

1. Architecture interne du tick worker (parallélisme, partitioning, budget perf).
2. Stratégie de données pour le tick (Prisma vs SQL brut vs hybride).
3. Mécanisme de cohérence tick/actions.
4. Mapping "serveur de jeu" → infrastructure technique (1 DB par serveur ? schema multi-tenant ?).
5. Plan de test de charge (combien de joueurs simulés, quels scénarios, quels seuils d'alerte).

---

*Ce document doit être discuté et transformé en ADRs concrets avant le début de Phase 1.*
