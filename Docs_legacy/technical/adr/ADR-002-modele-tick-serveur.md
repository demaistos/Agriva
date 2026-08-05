# ADR-002 — Modèle de tick serveur (simulation quotidienne)

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Chaque jour in-game déclenche une résolution batch côté serveur : météo, avancement des cultures, élevage, travaux, stocks, prix bots, coûts fixes, classements. Avec 1 mois = 5 jours réels, un tick se produit toutes les ~4h48. À l'échelle V1 (3 000 fermes actives), le tick doit s'exécuter en < 60 s total (< 500 ms/ferme). Le modèle de déclenchement conditionne l'architecture du module `tick` dès le Sprint 1.

## Options considérées

### Option A — Tick synchrone bloquant (cron fixe, traitement séquentiel)

Un cron job s'exécute à heure fixe (ex. 02h00 UTC), traite toutes les fermes séquentiellement, bloque le serveur pendant la durée du tick.

**Avantages** : simple à implémenter, état cohérent à un instant T, facile à déboguer.  
**Inconvénients** : bloque les requêtes joueurs pendant le tick (latence inacceptable à l'échelle), pas de rattrapage si un joueur se connecte après l'heure fixe, risque de timeout sur 3 000 fermes en séquentiel pur.

### Option B — Tick asynchrone par queue (cron + worker queue)

Le cron enqueue les fermes dans une queue Redis (Bull/BullMQ), des workers traitent les fermes en parallèle par batch.

**Avantages** : non-bloquant, scalable horizontalement, retry automatique en cas d'erreur par ferme, monitoring natif de la queue.  
**Inconvénients** : complexité opérationnelle accrue (gestion de la queue, workers séparés), cohérence inter-fermes plus difficile à garantir (ex. transactions marché joueur↔joueur pendant le tick), surcharge pour V1 avec < 3 000 fermes.

### Option C — Tick hybride (cron fixe + rattrapage à la connexion)

Le cron s'exécute à heure fixe en batch parallèle (par tranches de 100 fermes). Si un joueur se connecte et que le tick du jour n'a pas encore été appliqué à sa ferme, le rattrapage est déclenché à la connexion avant de servir l'état.

**Avantages** : non-bloquant (traitement par batch, pas de lock global), rattrapage transparent pour le joueur, cohérent avec le modèle asynchrone retenu dans les specs, simple à implémenter sans queue externe, gère le cas "joueur absent plusieurs jours".  
**Inconvénients** : légère latence à la connexion si rattrapage nécessaire (acceptable : < 500 ms/ferme), cohérence inter-fermes à surveiller (les transactions marché sont résolues dans le tick, pas en temps réel).

## Décision

**Option retenue : C — Tick hybride (cron fixe + rattrapage à la connexion)**

Justification : l'Option C correspond exactement au modèle décrit dans `tech-liveops-v1.md` §2 et `plan-implementation-v1.md` §1.4. Elle évite la complexité d'une queue externe (Option B injustifiée à l'échelle V1) tout en éliminant le blocage global de l'Option A. Le traitement par batch de 100 fermes en parallèle (Promise.all sur des transactions PostgreSQL indépendantes) tient dans la cible < 60 s pour 3 000 fermes. Le rattrapage à la connexion garantit qu'un joueur voit toujours un état à jour, même s'il s'est absenté plusieurs jours.

Paramètre configurable : l'intervalle du cron est stocké en variable d'environnement (`TICK_CRON`, défaut `0 2 * * *` = 02h00 UTC) pour faciliter les tests en accéléré.

## Conséquences

- Le module `tick` implémente deux points d'entrée : `runDailyTick()` (cron) et `catchUpFarm(farmId)` (connexion).
- La table `GameClock` (singleton) stocke `current_game_date` et `last_tick_at` ; chaque ferme stocke `last_tick_game_date` pour le rattrapage.
- Les transactions marché joueur↔joueur sont résolues dans le tick (pas en temps réel) — les ordres sont enqueués dans `MarketOrder` et matchés lors de la séquence ÉCONOMIE du tick.
- Benchmark obligatoire à chaque sprint : durée du tick loggée dans `tick_completed`, alerte si > 30 s (seuil d'alerte précoce avant la limite de 60 s).
- La mise à l'échelle horizontale (workers distribués) est reportée en V2+.

## Références

- `Docs/specs/2026-05-07-tech-liveops-v1.md` §2 (tick quotidien, durée cible, charge estimée)
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §1.4 (séquence du tick, déclenchement)
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §3 Risques — "Tick trop lent à l'échelle" et "Synchronisation tick asynchrone"
- `Docs/external-refinement/agriva_decisions_log_compact.md` — Temporalité (1 mois = 5j réels)
