# ADR-008 — Format des logs de télémétrie

**Date** : 2026-05-07  
**Statut** : Accepté
**Environnement** : Dev local Docker Compose  
**Décideurs** : Lead, Tech

## Contexte

La télémétrie V1 est figée à un niveau "moyen" (decisions log + tech-liveops §1) : rétention, progression, points de friction, économie. ~50 événements/joueur actif/jour, négligeable jusqu'à ~10 000 joueurs actifs. Le format de stockage doit être opérationnel dès Sprint 1 sans surcoût infrastructure, et compatible avec le dashboard admin interne.

## Options considérées

### Option A — Logs JSON structurés vers fichier + rotation

Chaque événement est sérialisé en JSON sur une ligne (NDJSON) et écrit dans un fichier local. Rotation quotidienne avec `winston` ou `pino` + `rotating-file-stream`. Rétention 90 jours de fichiers bruts, puis agrégats mensuels.

- ✅ Zéro dépendance externe, zéro coût
- ✅ Lisible directement (`jq`, `grep`), exportable facilement
- ✅ Cohérent avec la décision tech-liveops : "JSON structuré, envoi batch toutes les 5 min"
- ✅ Suffisant jusqu'à ~10 000 joueurs actifs (volume négligeable)
- ❌ Pas de requêtes analytiques natives (nécessite un script ou import ponctuel)
- ❌ Pas de dashboard temps réel sans couche supplémentaire

### Option B — Envoi vers service externe (Datadog / Grafana Cloud)

Les événements sont envoyés en temps réel ou en batch vers un SaaS de monitoring.

- ✅ Dashboard et alertes prêts à l'emploi
- ✅ Requêtes analytiques puissantes
- ❌ Coût mensuel non nul dès le lancement (Datadog : ~$15+/mois minimum)
- ❌ Dépendance externe critique — si le service est indisponible, les logs sont perdus sans buffer local
- ❌ Données joueurs envoyées à un tiers (RGPD : consentement, DPA à signer)
- ❌ Surdimensionné pour le volume V1 et les moyens d'un petit studio

### Option C — Table PostgreSQL dédiée avec TTL

Les événements sont insérés dans une table `telemetry_events` dans la base principale. Un job de purge supprime les entrées de plus de 90 jours.

- ✅ Requêtes SQL analytiques directes (agrégats, jointures avec `Player`, `Farm`)
- ✅ Pas de dépendance externe
- ✅ Cohérent avec la stack existante (PostgreSQL déjà présent)
- ❌ Risque de contention sur la base principale si le volume augmente (insertions fréquentes)
- ❌ La table grossit vite : ~50 événements × 3 000 joueurs × 90 jours = ~13,5 M de lignes
- ❌ Pas de séparation entre données opérationnelles et analytiques

## Décision

**Option A — Logs JSON structurés vers fichier + rotation**, avec une couche d'agrégation légère pour le dashboard admin.

### Implémentation retenue

**Librairie** : `pino` (performant, NDJSON natif, faible overhead) + `pino-roll` pour la rotation.

**Format d'un événement** :
```json
{
  "ts": "2026-05-07T14:32:00.000Z",
  "event": "transaction_market",
  "user_id": "u_123",
  "product": "ble",
  "qty": 50,
  "price": 180.5,
  "side": "sell",
  "counterpart": "bot"
}
```

**Rotation** : fichier quotidien `logs/telemetry/YYYY-MM-DD.ndjson`. Rétention 90 jours (cron de purge). Agrégats mensuels conservés indéfiniment (script de résumé JSON).

**Dashboard admin** : les métriques clés (DAU, volumes transactions, taux bot) sont calculées par des requêtes SQL sur la base principale — les données agrégées nécessaires (ex. : `transaction_market` count par jour) sont stockées dans une table `telemetry_daily_summary` mise à jour lors du tick quotidien. Les logs bruts restent dans les fichiers.

**Évolution V2+** : si le volume dépasse ~10 000 joueurs actifs, migrer vers Grafana Cloud (Loki pour les logs, Prometheus pour les métriques) en réutilisant le format NDJSON existant sans changer le code d'émission.

## Conséquences

**Positives :**
- Opérationnel dès Sprint 1 sans infrastructure supplémentaire
- Zéro coût, zéro dépendance externe
- Le format NDJSON est directement compatible avec Loki/Grafana si migration V2+
- La table `telemetry_daily_summary` alimente le dashboard admin sans requêtes analytiques lourdes

**Négatives / points de vigilance :**
- Les logs bruts ne sont pas interrogeables en temps réel sans outil externe (`jq` en ligne de commande suffit pour le debug)
- Le disque du VPS doit être dimensionné : ~50 événements × 200 octets × 3 000 joueurs × 90 jours ≈ 2,7 Go max — acceptable sur un SSD de 80 Go+
- Les `user_id` dans les logs sont des identifiants internes (pas d'email ni de données personnelles directes) — conformité RGPD simplifiée

## Références

- `2026-05-07-tech-liveops-v1.md` — §1 télémétrie (liste des événements, format JSON, rétention 90 jours, volume estimé)
- `2026-05-07-plan-implementation-v1.md` — §1.1 stack (Monitoring : "Logs JSON structurés → fichier/stdout + dashboard admin maison")
- `agriva_decisions_log_compact.md` — "Télémétrie minimale V1 (décision figée)"
