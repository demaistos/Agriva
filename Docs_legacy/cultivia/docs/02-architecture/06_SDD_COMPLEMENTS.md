# Cultivia — Compléments SDD

## 0. Mapping noms métier ↔ tables SQL

> Le registry (ACTION_FLOW_REGISTRY.yaml) utilise des noms métier lisibles.
> Le DATA_MODEL utilise les noms techniques SQL. Voici la correspondance.

| Nom dans le registry | Table SQL réelle | Notes |
|---------------------|------------------|-------|
| `ledger` | `transaction` | Toutes les écritures financières |
| `parcel_soil` | `soil_analysis` | Résultats d'analyse de sol |
| `health_log` | `animal_health_log` | Historique soins/maladies |
| `slaughter_log` | `slaughter_record` | Données carcasse abattoir |
| `parcel_bac_eau` | `water_trough` | Bacs à eau dans les prés |
| `fosse` / `fosse_fumier` | `building` (champ `manure_stock`) | Stockage fumier dans le bâtiment fosse |
| `fosse_lisier` | `building` (champ `slurry_stock`) | Stockage lisier dans le bâtiment fosse |
| `reproduction_log` | `insemination` + `gestation` | 2 tables séparées |
| `production_log` | `milk_production` / `egg_production` / `wool_production` | 1 table par type |
| `announcement` | `listing` | Annonces de vente entre joueurs |

## 1. Definition of Done (DoD)

Une feature est "terminée" quand :
- [ ] Migration SQL écrite et réversible (DOWN commenté)
- [ ] Service backend avec logique métier complète
- [ ] Route API avec JSON Schema validation
- [ ] Tests unitaires service (cas nominal + 3 cas limites minimum)
- [ ] Tests intégration API (succès + auth manquante + validation échouée + ownership)
- [ ] Store Pinia + composant Vue fonctionnel
- [ ] Boutons grisés avec tooltip quand action impossible
- [ ] Toast feedback succès/erreur
- [ ] Pas de warning TypeScript
- [ ] Pas de vulnérabilité ESLint security
- [ ] Compte rendu dans docs/reports/
- [ ] PR reviewée et mergée

---

## 2. Catalogue des codes erreur

Tous les codes erreur de l'API. Format: `DOMAIN_ACTION_REASON`.

### Auth
| Code | HTTP | Message |
|------|------|---------|
| AUTH_EMAIL_EXISTS | 409 | Un compte existe déjà avec cet email sur ce serveur |
| AUTH_INVALID_CREDENTIALS | 401 | Email ou mot de passe incorrect |
| AUTH_EMAIL_NOT_VERIFIED | 403 | Vérifiez votre email avant de vous connecter |
| AUTH_TOKEN_EXPIRED | 401 | Session expirée, reconnectez-vous |
| AUTH_TOKEN_INVALID | 401 | Token invalide |
| AUTH_REFRESH_REVOKED | 401 | Session révoquée |

### Joueur
| Code | HTTP | Message |
|------|------|---------|
| PLAYER_NOT_FOUND | 404 | Joueur introuvable |
| PLAYER_INSUFFICIENT_HT | 400 | Points d'action insuffisants (requis: X, disponible: Y) |
| PLAYER_INSUFFICIENT_BALANCE | 400 | Solde insuffisant (requis: X€, disponible: Y€) |
| PLAYER_BALANCE_FLOOR | 400 | Le solde ne peut pas descendre en dessous de -30 000€ |

### Parcelles
| Code | HTTP | Message |
|------|------|---------|
| PARCEL_NOT_OWNED | 403 | Cette parcelle ne vous appartient pas |
| PARCEL_WRONG_SEASON | 400 | Cette culture ne peut pas être semée en cette saison |
| PARCEL_ROTATION_VIOLATED | 400 | Rotation non respectée (dernière culture identique il y a X saisons, minimum Y) |
| PARCEL_ALREADY_SOWN | 400 | Cette parcelle a déjà une culture en cours |
| PARCEL_NOT_READY | 400 | La parcelle n'est pas prête (état actuel: X) |
| PARCEL_CROP_NOT_MATURE | 400 | La culture n'est pas assez mature pour être récoltée |

### Matériels
| Code | HTTP | Message |
|------|------|---------|
| VEHICLE_NOT_OWNED | 403 | Ce matériel ne vous appartient pas |
| VEHICLE_INSUFFICIENT_POWER | 400 | Tracteur pas assez puissant (requis: X CV, disponible: Y CV) |
| VEHICLE_BROKEN | 400 | Ce matériel est en panne |
| VEHICLE_NO_FUEL | 400 | Réservoir HVC vide |
| VEHICLE_MISSING | 400 | Matériel requis manquant: X |

### Bâtiments
| Code | HTTP | Message |
|------|------|---------|
| BUILDING_NOT_OWNED | 403 | Ce bâtiment ne vous appartient pas |
| BUILDING_FULL | 400 | Capacité insuffisante (disponible: X, requis: Y) |
| BUILDING_NOT_EMPTY | 400 | Le bâtiment doit être vidé avant agrandissement |
| BUILDING_UNDER_CONSTRUCTION | 400 | Bâtiment en construction (fin: X) |
| BUILDING_MAX_LEVEL | 400 | Niveau maximum atteint |

### Animaux
| Code | HTTP | Message |
|------|------|---------|
| ANIMAL_NOT_OWNED | 403 | Cet animal ne vous appartient pas |
| ANIMAL_DEAD | 400 | Cet animal est mort |
| ANIMAL_SICK | 400 | Cet animal est malade, appelez le vétérinaire |
| ANIMAL_TOO_YOUNG | 400 | Animal trop jeune pour cette action (âge: X, minimum: Y) |
| ANIMAL_ALREADY_PREGNANT | 400 | Cet animal est déjà en gestation |
| ANIMAL_MAX_INSEMINATIONS | 400 | Nombre maximum d'inséminations atteint aujourd'hui |
| ANIMAL_WRONG_BREED | 400 | Les deux animaux doivent être de la même race |
| ANIMAL_NAME_TOO_LONG | 400 | 30 caractères maximum |
| ANIMAL_NAME_INVALID | 400 | Caractères spéciaux non autorisés |

### Alimentation & Eau
| Code | HTTP | Message |
|------|------|---------|
| FEED_NO_RATION | 400 | Sélectionnez une ration |
| FEED_STOCK_INSUFFICIENT | 400 | Stock insuffisant : manque X kg de Y |
| FEED_ALREADY_FED | 400 | Animaux déjà nourris aujourd'hui |
| FEED_DESILAGE_NO_EQUIPMENT | 400 | Désileuse requise (tracteur + désileuse) |
| WATER_TANK_EMPTY | 400 | Cuve à eau vide |
| WATER_TANK_FULL | 400 | Cuve déjà pleine |
| WATER_ALREADY_WATERED | 400 | Déjà abreuvés aujourd'hui |
| WATER_NO_TANK | 400 | Pas de cuve à eau |
| WATER_NO_TROUGH | 400 | Pas de bac à eau dans ce pré |

### Santé
| Code | HTTP | Message |
|------|------|---------|
| HEAL_NOT_SICK | 400 | Pas malade |
| HEAL_NO_SICK_ANIMALS | 400 | Aucun animal malade |
| VACCINE_ALREADY_VACCINATED | 400 | Déjà vacciné (expire dans X jours) |

### Litière & Fumier
| Code | HTTP | Message |
|------|------|---------|
| BEDDING_NO_STRAW | 400 | Stock paille insuffisant |
| BEDDING_FRESH | 400 | Litière déjà fraîche |
| BEDDING_CAILLEBOTIS | 400 | Bâtiment sur caillebotis (pas de litière) |
| BEDDING_NO_PAILLEUSE | 400 | Tracteur requis pour la pailleuse |
| MANURE_NONE | 400 | Pas de fumier |
| MANURE_PIT_FULL | 400 | Fosse pleine |
| MANURE_NO_PIT | 400 | Pas de fosse à fumier |
| SLURRY_NONE | 400 | Pas de lisier |
| SLURRY_PIT_FULL | 400 | Fosse à lisier pleine |

### Reproduction
| Code | HTTP | Message |
|------|------|---------|
| INSEM_NOT_ADULT | 400 | Trop jeune (adulte requis) |
| INSEM_PREGNANT | 400 | Déjà gestante |
| INSEM_OUT_OF_PERIOD | 400 | Hors période de reproduction |
| INSEM_NO_MALE | 400 | Aucun mâle de cette race dans votre ferme |
| INSEM_BREED_MISMATCH | 400 | Le mâle doit être de la même race |
| INSEM_MAX_DAILY | 400 | Mâle a atteint le max d'inséminations aujourd'hui |
| INSEM_POST_BIRTH | 400 | Délai post-mise-bas non respecté |

### Traite
| Code | HTTP | Message |
|------|------|---------|
| MILK_NO_PARLOR | 400 | Construisez une salle de traite |
| MILK_TANK_FULL | 400 | Cuve pleine — vendez du lait |
| MILK_ALREADY_MILKED | 400 | Déjà traites pour ce créneau |
| MILK_SLOT_PASSED | 400 | Créneau de traite dépassé |

### Abattoir
| Code | HTTP | Message |
|------|------|---------|
| SLAUGHTER_NO_TRAILER | 400 | Bétaillère fonctionnelle requise |
| SLAUGHTER_NO_TRACTOR | 400 | Tracteur fonctionnel requis |

### Employés
| Code | HTTP | Message |
|------|------|---------|
| EMPLOYEE_MAX_REACHED | 400 | Maximum 3 employés |
| EMPLOYEE_NONE | 400 | Aucun employé à licencier |

### Finances
| Code | HTTP | Message |
|------|------|---------|
| SAVINGS_MIN_AMOUNT | 400 | Montant minimum 1 000€ |
| SAVINGS_ALREADY_MATURED | 400 | Épargne déjà arrivée à maturité |
| LOAN_CEILING_REACHED | 400 | Plafond 150 000€ atteint |
| LOAN_EARLY_PENALTY | 400 | Solde insuffisant (capital + 3% pénalité) |

### Messages
| Code | HTTP | Message |
|------|------|---------|
| MESSAGE_NO_RECIPIENT | 400 | Sélectionnez un destinataire |
| MESSAGE_EMPTY | 400 | Rédigez votre message |

### Compost
| Code | HTTP | Message |
|------|------|---------|
| COMPOST_NO_AREA | 400 | Aire de compostage requise |
| COMPOST_BATCH_ACTIVE | 400 | Compostage déjà en cours |
| COMPOST_NO_MANURE | 400 | Fumier insuffisant |

### ETA
| Code | HTTP | Message |
|------|------|---------|
| ETA_WORK_DONE | 400 | Travail déjà effectué sur cette parcelle |

### Assurance
| Code | HTTP | Message |
|------|------|---------|
| INSURANCE_ALREADY_ACTIVE | 409 | Assurance déjà active |

### Négociant
| Code | HTTP | Message |
|------|------|---------|
| NEGOCIANT_ALREADY_CALLED | 400 | Négociant déjà appelé ce mois-ci |

### Stock
| Code | HTTP | Message |
|------|------|---------|
| STOCK_INSUFFICIENT | 400 | Stock insuffisant de X (disponible: Y, requis: Z) |
| STOCK_NO_SILO | 400 | Pas de silo disponible pour stocker X |

### Économie
| Code | HTTP | Message |
|------|------|---------|
| LOAN_MAX_REACHED | 400 | Plafond de prêts atteint (150 000€) |
| LOAN_COOLDOWN | 400 | Vous devez attendre 7 jours entre deux demandes de prêt |
| LISTING_EXPIRED | 400 | Cette annonce a expiré |

### Général
| Code | HTTP | Message |
|------|------|---------|
| RATE_LIMITED | 429 | Trop de requêtes, réessayez dans X secondes |
| VALIDATION_ERROR | 400 | Données invalides (détails dans errors[]) |
| INTERNAL_ERROR | 500 | Erreur interne, réessayez plus tard |

---

## 3. Stratégie anti-triche

### Multi-comptes
- Un seul compte par email par serveur (contrainte UNIQUE BDD)
- Détection IP: alerte si >3 comptes depuis la même IP en 24h
- Détection comportement: alerte si 2 comptes font des transactions exclusivement entre eux
- Sanction: ban permanent, pas de remboursement Licence Pro

### Bots / Automatisation
- Rate limiting strict: 30 req/min par joueur authentifié
- CAPTCHA sur inscription et après 3 échecs de login
- Détection patterns: alerte si un joueur fait exactement les mêmes actions chaque jour à la même seconde
- Les actions critiques (vente, achat, insémination) ont un délai minimum de 1s entre elles

#### Middleware actionThrottle (Réf: REVIEW_FINALE I3)

Délai minimum de 1s entre deux actions critiques du même joueur. Implémenté via Redis `SET NX PX 1000`.

### Règles commerce P2P (playtest 1000 joueurs)

| Règle | Valeur |
|-------|--------|
| Transport P2P | Payé par l'acheteur |
| Annonces actives max | 10 par joueur |
| Expiration annonces | 30 jours Cultivia (30j réels) |
| Vente par lot P2P | Oui — animaux et produits vendables en lot (sélection multiple) |
| Résiliation contrat laiterie | Pénalité = 1 mois de production × prix contrat |
| Collecte produits animaux | Coût minimum 5€ (lait, œufs, laine) au lieu de 20€ |
| Sur-maturité cultures | -2%/jour de rendement après 7j mature (min 50%) |

### Limites achat Marché Central (PNJ)

| Règle | Valeur |
|-------|--------|
| Animaux | Max 5 par espèce par jour (ex: 5 bovins + 5 volailles = OK) |
| Aliments/intrants | Pas de limite (régulé par capacité silo) |
| Matériel neuf | Pas de limite (régulé par le solde) |

> Le Marché Central a un stock illimité mais le joueur est limité à 5 animaux/espèce/jour pour éviter l'achat massif. Le P2P n'a pas cette limite (entre joueurs = libre).

```typescript
// Actions soumises au throttle :
const THROTTLED_ACTIONS = [
  'sow', 'harvest', 'prepare', 'fertilize', 'treat', 'roll',
  'buy_parcel', 'sell_parcel', 'buy_vehicle', 'sell_vehicle',
  'coop_sell', 'buy_hvc', 'spread_manure', 'press_straw',
];

async function actionThrottle(req: FastifyRequest, reply: FastifyReply) {
  const key = `throttle:${req.user.player_id}:action`;
  const acquired = await redis.set(key, '1', 'NX', 'PX', 1000);
  if (!acquired) {
    throw new AppError('RATE_LIMITED', 'Attendez 1 seconde entre chaque action', 429);
  }
}

// Enregistrer sur les routes de mutation gameplay :
fastify.addHook('preHandler', async (req, reply) => {
  if (req.method !== 'GET' && THROTTLED_ACTIONS.some(a => req.url.includes(a))) {
    await actionThrottle(req, reply);
  }
});
```

**Tests d'intégration anti-bot :**
```
✅ 2 actions de semis à <1s d'intervalle → la 2e retourne 429
✅ 2 actions de semis à >1s d'intervalle → les 2 réussissent
✅ 1 action semis + 1 action GET parcelle à <1s → les 2 réussissent (GET non throttlé)
✅ Joueur A et joueur B font la même action à <1s → les 2 réussissent (throttle par joueur)
✅ Vérifier que le rate limit global (30 req/min) et le throttle (1s) sont complémentaires
```

### Manipulation économique
- Prix de vente entre joueurs: borné à ±50% du cours de référence
- Vente de parcelles: taxe plus-value 50-90% (anti-spéculation)
- Transferts d'argent directs: impossibles (tout passe par des transactions commerciales)
- Alerte admin si un joueur gagne >500 000€ en 24h

### Exploitation de bugs
- Toute transaction financière est atomique (BEGIN/COMMIT)
- Double-click protection: idempotency key sur les mutations (header X-Idempotency-Key)
- Vérification côté serveur de TOUTES les règles (jamais faire confiance au client)
- Logs de toutes les actions avec montants pour audit

---

## 4. Politique de mots de passe

```typescript
const PASSWORD_POLICY = {
    minLength: 8,
    maxLength: 128,
    requireUppercase: true,
    requireLowercase: true,
    requireDigit: true,
    requireSpecial: false,  // pas obligatoire mais recommandé
    bcryptRounds: 12,
    // Mots de passe interdits
    blacklist: ['password', '12345678', 'cultivia', 'cultivia'],
};
```

- Pas de limite de tentatives de login (rate limiting suffit: 10/min)
- Pas de reset par question secrète (email uniquement)
- Token de reset expire en 1h, usage unique

---

## 5. Stratégie de migration BDD

### Versioning
```
prisma/migrations/
├── 001_create_servers.sql
├── 002_create_players.sql
├── 003_create_parcels.sql
├── ...
└── migrations.lock    ← fichier lock, ne pas modifier à la main
```

### Format d'une migration
```sql
-- 003_create_parcels.sql
-- UP
CREATE TABLE parcels ( ... );
CREATE INDEX idx_parcels_player ON parcels(player_id);

-- DOWN (commenté, exécuter manuellement si rollback nécessaire)
-- DROP INDEX idx_parcels_player;
-- DROP TABLE parcels;
```

### Règles
- Jamais de DROP COLUMN en production sans migration en 3 étapes:
  1. Déployer le code qui n'utilise plus la colonne
  2. Attendre 1 semaine
  3. DROP COLUMN dans une migration séparée
- Jamais de ALTER TABLE ... ADD COLUMN NOT NULL sans DEFAULT
- Les migrations sont exécutées dans l'ordre numérique
- Chaque migration est testée sur une copie de la BDD prod avant déploiement

### Zero-downtime
```bash
# Déploiement sans interruption:
1. Exécuter les migrations (compatibles avec l'ancien code)
2. Déployer le nouveau code (rolling update, 1 instance à la fois)
3. Vérifier les health checks
4. Si erreur: rollback code, puis rollback migration si nécessaire
```

---

## 6. Runbook incidents

### Tick journalier échoué
```
ALERTE: Tick journalier n'a pas terminé en 5 min / a crashé
1. Vérifier les logs worker: docker logs cultivia-worker
2. Identifier le batch qui a échoué (log "Tick batch failed")
3. Vérifier l'état BDD: SELECT count(*) FROM players WHERE work_hours_reset = false
4. Si < 10% des joueurs affectés: relancer le tick manuellement pour les joueurs manqués
5. Si > 10%: rollback la transaction, corriger le bug, relancer le tick complet
6. Communiquer aux joueurs via notification in-app
```

### BDD down
```
ALERTE: PostgreSQL ne répond plus
1. Vérifier l'espace disque: df -h
2. Vérifier les connexions: SELECT count(*) FROM pg_stat_activity
3. Si connexions saturées: KILL les requêtes longues, vérifier PgBouncer
4. Si crash: redémarrer PostgreSQL, vérifier les WAL
5. Si données corrompues: restaurer le dernier backup
6. Mettre le site en maintenance pendant la restauration
```

### Redis down
```
ALERTE: Redis ne répond plus
1. Le jeu continue de fonctionner (dégradé: pas de cache, pas de rate limit)
2. Redémarrer Redis
3. Les caches se reconstruisent automatiquement (cache-aside pattern)
4. Vérifier que BullMQ reprend les jobs en attente
```

### Pic de charge inattendu
```
ALERTE: Latence API > 500ms
1. Vérifier le nombre de connexions simultanées
2. Si > 2000: scaler horizontalement (ajouter une instance API)
3. Vérifier les slow queries: SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10
4. Si une requête est lente: ajouter un index ou optimiser
5. Activer le rate limiting plus agressif temporairement
```

---

## 7. Conventions de nommage in-game

Le jeu s'appelle **Cultivia**, pas Cultivia. Renommer:

| Cultivia | Cultivia |
|---------|----------|
| Cultivia | Cultivia |
| Licence Pro | Licence Pro |
| Le Marché Central | Le Marché Central |
| GénétiLab | GénétiLab |
| Le Domaine | Le Domaine |
| Chambre Agricole | Chambre Agricole |
| Lycée Agricole | Lycée Agricole |

Les marques de matériels agricoles (Verdant, Aureus, etc.) doivent être remplacées par des noms fictifs pour éviter les problèmes de propriété intellectuelle:

| Réel | Cultivia |
|------|----------|
| Verdant | Verdant |
| Aureus | Aureus |
| Novaterra | Novaterra |
| Fergusson | Fergusson |
| Fendt | Feldmark |
| Castor | Castor |
| Kubota | Kubara |
| Deutmark | Deutmark |

---

## 8. Seed data initial

Script à exécuter au premier lancement pour peupler la BDD avec les données de référence.

```bash
# Ordre d'exécution du seed
npm run db:seed
# Exécute dans l'ordre:
# 1. scripts/seed/01-servers.sql        → 8 serveurs de jeu
# 2. scripts/seed/02-regions.sql        → Régions, départements, zones
# 3. scripts/seed/03-building-types.sql → Types de bâtiments + accessoires
# 4. scripts/seed/04-vehicle-types.sql  → Catalogue matériels
# 5. scripts/seed/05-crop-types.sql     → Cultures + rendements par région
# 6. scripts/seed/06-animal-breeds.sql  → Races animales + rations
# 7. scripts/seed/07-cheese-types.sql   → Types de fromages par région
# 8. scripts/seed/08-base-prices.sql    → Prix de référence coop
# 9. scripts/seed/09-admin-user.sql     → Compte admin
```

Source des données: `docs/02-architecture/03_CONTENT_DATA.md`

---

## 9. Environnements

| Env | URL | BDD | Usage |
|-----|-----|-----|-------|
| dev | localhost:5173 | cultivia_dev (locale) | Développement local |
| test | - | cultivia_test (locale) | Tests automatisés CI |
| staging | staging.cultivia.fr | cultivia_staging (cloud) | Validation avant prod, données anonymisées |
| prod | cultivia.fr | cultivia_prod (cloud) | Production |

### Règles par environnement
- **dev**: logs debug, pas de rate limit, seed data auto, CORS permissif
- **test**: logs error only, BDD reset entre chaque suite de tests
- **staging**: config identique à prod, 100 joueurs fictifs, tick accéléré (1h = 1 jour)
- **prod**: logs info, rate limit strict, backups quotidiens, monitoring alertes

---

## 10. Plan de test formel

### Tests unitaires (Vitest)
- Cible: `src/server/services/**/*.ts`
- Couverture: ≥ 80%
- Exécution: à chaque commit (pre-push hook)

### Tests d'intégration (Supertest)
- Cible: `src/server/routes/**/*.ts`
- BDD: cultivia_test, reset entre chaque fichier de test
- Exécution: CI sur chaque PR

#### Isolation par serveur de jeu (Réf: REVIEW_FINALE R7)

Chaque suite de tests crée son propre serveur de jeu pour éviter les conflits entre tests parallèles sur `server.current_day`, `tick_lock`, etc.

```typescript
// test/helpers/createTestServer.ts
export async function createTestServer(db: Pool): Promise<Server> {
  const id = randomUUID().slice(0, 8);
  const result = await db.query(
    `INSERT INTO server (name, slug, country, difficulty, price_per_ha, ht_base)
     VALUES ($1, $2, 'FR', 2, 4000, 35) RETURNING *`,
    [`test_${id}`, `t_${id}`]
  );
  // Créer le tick_lock pour ce serveur
  await db.query(
    'INSERT INTO tick_lock (server_id) VALUES ($1)',
    [result.rows[0].id]
  );
  return result.rows[0];
}

// Utilisation dans les tests :
describe('Tick journalier', () => {
  let testServer: Server;

  beforeAll(async () => {
    testServer = await createTestServer(db);
  });

  it('should advance the day', async () => {
    await dailyTick(testServer.id);
    // ...assertions sur testServer.current_day
  });
});
```

Avantages :
- Pas de conflit entre tests parallèles
- Chaque test a son propre calendrier, sa propre météo, ses propres joueurs
- Le `tick_lock` est isolé par serveur

### Tests E2E (Playwright)
- Scénarios critiques:
  1. Inscription → connexion → dashboard
  2. Acheter parcelle → semer blé → attendre pousse → récolter → vendre
  3. Acheter animal → nourrir → traire → vendre lait
  4. Créer annonce → autre joueur achète → transport → livraison
- Exécution: CI sur merge vers develop, manuellement avant release

### Tests de charge (k6)
- Scénario: 2000 utilisateurs simultanés pendant 5 min
- Critères: p95 < 200ms, 0 erreur 5xx
- Exécution: avant chaque mise en production

### Tests de sécurité
- OWASP ZAP scan automatisé sur staging (hebdomadaire)
- Revue manuelle des nouvelles routes API (à chaque PR)
- npm audit dans CI (bloque si vulnérabilité critique)


---

## 11. Corrections post-review sécurité

### 11.1 Race condition sur solde (CRITIQUE)

Toute déduction de solde DOIT utiliser `SELECT FOR UPDATE` :

```sql
-- MAUVAIS (race condition si 2 requêtes simultanées)
UPDATE players SET balance = balance - $1 WHERE id = $2;

-- BON (verrouille la ligne pendant la transaction)
BEGIN;
SELECT balance FROM players WHERE id = $1 FOR UPDATE;
-- vérifier solde >= montant + plancher
UPDATE players SET balance = balance - $2 WHERE id = $1;
INSERT INTO ledger (...) VALUES (...);
COMMIT;
```

Appliquer sur: achat parcelle, achat matériel, achat animal, achat coop, paiement transport, salaires, remboursement prêt.

### 11.2 WebSocket — Spec auth complète

```
Connexion: GET /ws?token=<JWT_ACCESS_TOKEN>
1. Serveur vérifie le JWT (signature + expiration)
2. Si invalide → close(4001, "Unauthorized")
3. Si valide → connexion acceptée, associer playerId

Heartbeat (toutes les 5 min):
1. Serveur envoie { event: "ping" }
2. Client répond { event: "pong", token: "<current_jwt>" }
3. Serveur vérifie le token
4. Si expiré → envoie { event: "auth_expired" } → close(4002)
5. Client doit refresh JWT et se reconnecter

Pas de données sensibles dans les messages WS (pas de solde exact, pas de coordonnées).
```

### 11.3 RGPD

```
Données personnelles stockées:
- Email (table account)
- Mot de passe hashé bcrypt (table account)
- Adresse IP (logs, rétention 90 jours)

Droits du joueur:
- Droit d'accès: GET /api/player/me/data (export JSON complet)
- Droit à l'oubli: DELETE /api/player/me (anonymise email, supprime password_hash, soft delete)
- Droit de rectification: PATCH /api/player/me (email)
- Consentement: checkbox obligatoire à l'inscription

Rétention:
- Comptes inactifs >365 jours: email de relance, puis anonymisation après 30j
- Logs avec IP: supprimés après 90 jours
- Ledger financier: conservé (anonymisé si suppression compte)

Mention légale: page /legal avec politique de confidentialité.
```

### 11.4 Startup check serveur

```typescript
// Au démarrage de l'API, vérifier la configuration
function validateConfig() {
    if (!process.env.JWT_SECRET || process.env.JWT_SECRET.length < 32)
        throw new Error('JWT_SECRET must be at least 32 characters');
    if (process.env.JWT_SECRET.includes('change-me'))
        throw new Error('JWT_SECRET contains placeholder value');
    if (!process.env.REDIS_PASSWORD)
        throw new Error('REDIS_PASSWORD is required');
    if (process.env.NODE_ENV === 'production' && !process.env.DATABASE_URL.includes('pgbouncer'))
        console.warn('WARNING: Production should use PgBouncer');
}
```

---

## 12. CSP Headers & WebSocket Auth Protocol

> Ajouté suite à la réunion plénière finale (M34/M36/B4)

### 12.1 Content Security Policy

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data:;
  connect-src 'self' wss://;
```

Header ajouté par le middleware Fastify sur toutes les réponses HTTP.

### 12.2 WebSocket Auth Protocol

```
Connexion : GET /ws?token=<JWT_ACCESS_TOKEN>
1. Serveur vérifie le JWT (signature + expiration)
2. Si invalide → close(4001, "Unauthorized")
3. Si valide → connexion acceptée, associer playerId

Heartbeat (toutes les 5 min) :
1. Serveur envoie { event: "ping" }
2. Client répond { event: "pong", token: "<current_jwt>" }
3. Serveur vérifie le token
4. Si expiré → envoie { event: "auth_expired" } → close(4002, "Token expired")
5. Client doit refresh JWT et se reconnecter

Codes de fermeture :
- 4001 : Token invalide (signature, format)
- 4002 : Token expiré (re-auth nécessaire)
```

### Tutoriel
| Code | HTTP | Message |
|------|------|---------|
| TUTORIAL_ALREADY_COMPLETED | 400 | Tutoriel déjà terminé |


---

## 4. Registre de traitement RGPD (Réf: Review R5)

| Traitement | Données | Base légale | Durée | Destinataire |
|-----------|---------|-------------|-------|-------------|
| Inscription | Email, mot de passe hashé | Contrat (CGU) | Durée du compte | Interne |
| Connexion | IP, user-agent | Intérêt légitime (sécurité) | 90 jours (logs) | Interne |
| Gameplay | Actions de jeu, solde, animaux | Contrat (CGU) | Durée du compte | Interne |
| Notifications email | Email | Consentement (opt-in F105) | Jusqu'au retrait | Interne |
| Messagerie | Messages entre joueurs | Contrat (CGU) | 1 an puis anonymisation | Interne |

**Droits des joueurs :**
- Export : `GET /api/player/me/data` → JSON complet
- Suppression : `DELETE /api/player/me` → anonymisation (pseudo → "Joueur supprimé", email → hash)
- Comptes inactifs >365j → email relance → anonymisation 30j après

---

## 5. KPIs par sprint (Réf: Review R10)

| Sprint | KPI | Objectif |
|--------|-----|---------|
| 01 | Scaffolding complet, `docker compose up` fonctionne | 100% |
| 02 | Inscription + connexion + création ferme fonctionnels | 100% |
| 03 | 1 joueur peut construire + acheter animal + nourrir | E2E testable |
| 04-07 | Boucle élevage complète jouable | Rétention J7 > 50% (test interne) |
| 08-09 | Dashboard + finances + social | Rétention J30 > 30% (test interne) |
| 10-12 | Cultures + matériel + ETA | NPS > +30 (beta fermée) |
| Beta | 100 joueurs beta, 30 jours | Rétention J30 > 25%, NPS > +40 |
| Launch | 1 000 joueurs | Rétention J7 > 40%, NPS > +45 |

---

## 6. Format API standard (Réf: Audit profil Dev)

### Réponse succès
```json
{
  "data": { ... },
  "meta": { "page": 1, "total": 42 }
}
```

### Réponse erreur
```json
{
  "error": {
    "code": "ANIMAL_DEAD",
    "message": "Cet animal est mort",
    "httpStatus": 400
  }
}
```

## 7. Edge cases documentés (Réf: Audit profil QA)

| Cas | Comportement |
|-----|-------------|
| Suppression compte RGPD + annonces P2P actives | Annonces supprimées automatiquement |
| Animal meurt pendant transit (F048) | Pas de tick santé pendant le transit (animal protégé) |
| Plancher -30k€ + tick énergie | Énergie impayée = dette, pas de coupure. Notification "⚠️ Impayé énergie" |
| 2 joueurs achètent même animal P2P | SELECT FOR UPDATE sur listing → premier gagne, second reçoit 400 "Déjà vendu" |
| Joueur déconnecté pendant action | Idempotency key → retry safe |


---

## 8. Système de transport multi-voyages (Réf: capacité remorque)

### Règle universelle

Toute action de transport calcule le nombre de voyages en fonction de la capacité du véhicule :

```
nb_voyages = ceil(quantité / capacité_véhicule)
transport_cost = nb_voyages × MAX(20, distance_km × rate_per_km)
hvc_cost = nb_voyages × distance_km × hvc_rate
ht_cost = nb_voyages × (0.5 + distance_km / 100)
wear = nb_voyages × distance_km × 0.02%
```

Exception : produits animaux (lait, œufs, laine) = collecte ferme 5€ fixe, pas de multi-voyages.

### Capacités véhicules de transport

| Véhicule | Capacité | Transporte |
|----------|----------|-----------|
| Benne 8T | 8 tonnes | Récoltes, aliments, engrais, paille |
| Benne 10T | 10 tonnes | Idem |
| Plateau 6T | 6 tonnes | Marchandises diverses |
| Bétaillère 4T | ~6 bovins | Animaux (bovins/ovins/caprins/porcins) |
| Bétaillère 5T | ~8 bovins | Idem |
| Utilitaire | ~50 volailles | Volailles, pintades, lapins |
| Citerne lait 2500L | 2 500 litres | Lait |
| Citerne lait 5000L | 5 000 litres | Lait |
| Tonne eau 5000L | 5 000 litres | Eau |
| Tonne eau 10000L | 10 000 litres | Eau |
| Épandeur fumier 8T | 8 tonnes | Fumier |
| Tonne lisier 10m³ | 10 000 litres | Lisier |

### Flows impactés

Tous les flows avec transport doivent afficher AVANT l'action :
```
"{quantité} {produit} = {nb_voyages} voyage(s) ({capacité}/voyage)
 Transport : {cost}€ | HVC : {hvc}L | HT : {ht}
 ⚠️ Vous n'avez que {ht_restant} HT" (si insuffisant)
```

| Flow | Transport de | Véhicule |
|------|-------------|----------|
| F002 | Animaux | Bétaillère / utilitaire / van |
| F006 | Aliments (foin, maïs...) | Benne |
| F024 | Lait | Citerne lait |
| F025 | Animaux (abattoir) | Bétaillère / utilitaire |
| F029 | Animaux (déplacement) | Bétaillère / utilitaire |
| F042 | Récolte (vente) | Benne |
| F043 | Matériel neuf (livraison) | Livraison concessionnaire |
| F051 | Eau (bacs au pré) | Tonne eau |
| F055 | Fumier (épandage) | Épandeur fumier |
| F056 | Lisier (épandage) | Tonne lisier |
| F068 | HVC | Livraison directe (pas de multi-voyages) |
| F080/F081 | Animaux P2P | Bétaillère / utilitaire |
| F089 | Matériel P2P | Livraison |


---

## 9. Limites d'utilisation véhicules (Réf: SimAgri)

### Limite quotidienne (HT/jour par véhicule)

Chaque véhicule a un nombre max de HT d'utilisation par jour. Au-delà, il est indisponible jusqu'au lendemain.

| Catégorie | HT max/jour | Exemple |
|-----------|------------|---------|
| Tracteur | 20 HT | 20 HT de travaux/transport par jour |
| Moissonneuse | 15 HT | ~15 ha/jour |
| Ensileuse | 15 HT | ~15 ha/jour |
| Benne/plateau | 25 HT | Beaucoup de voyages possibles |
| Bétaillère/utilitaire | 20 HT | ~10 voyages/jour |
| Outils (charrue, herse...) | 20 HT | Limité par le tracteur |

Si le joueur a 2 tracteurs, il peut utiliser chacun 20 HT/jour = 40 HT de travaux.

### Durée de vie globale (compteur heures)

Chaque véhicule motorisé a un compteur d'heures cumulées. Quand le compteur atteint la durée de vie max, le véhicule est irréparable (réformé).

| Catégorie | Durée de vie | En jours Cultivia (~) |
|-----------|-------------|----------------------|
| Tracteur | 10 000 HT | ~500 jours à 20 HT/jour |
| Moissonneuse | 5 000 HT | ~333 jours à 15 HT/jour |
| Ensileuse | 5 000 HT | ~333 jours |
| Utilitaire | 8 000 HT | ~400 jours |
| Outils tractés | Pas de limite | Usure seule |

Quand le compteur atteint 80% de la durée de vie → notification "⚠️ {véhicule} en fin de vie ({hours}/{max} heures)".
Quand le compteur atteint 100% → véhicule irréparable, ne peut plus être utilisé. Le joueur peut le vendre à l'argus (très bas) ou le détruire.

### Outils tractés (durée de vie, pas de limite quotidienne)

Les outils tractés (charrue, herse, semoir, épandeur, benne, plateau, presse, bétaillère, etc.) ont une durée de vie en heures mais PAS de limite HT/jour (c'est le tracteur qui limite) :

| Catégorie | Durée de vie |
|-----------|-------------|
| Benne | 8 000 HT |
| Plateau | 8 000 HT |
| Bétaillère | 6 000 HT |
| Charrue | 5 000 HT |
| Herse rotative | 5 000 HT |
| Semoir | 6 000 HT |
| Épandeur engrais | 5 000 HT |
| Épandeur fumier | 5 000 HT |
| Pulvérisateur | 6 000 HT |
| Presse | 4 000 HT |
| Faucheuse | 4 000 HT |
| Cultivateur | 5 000 HT |
| Rouleau | 6 000 HT |
| Broyeur | 4 000 HT |
| Citerne lait | 8 000 HT |
| Tonne eau/lisier | 8 000 HT |
| Bineuse | 5 000 HT |
| Enrouleur | 6 000 HT |

Pas de limite HT/jour — l'outil peut être utilisé autant que le tracteur le permet, et changé de tracteur en cours de journée.

### Disabled states véhicule

Chaque flow utilisant un véhicule doit vérifier :
```
- condition: vehicle_daily_limit_reached
  tooltip: "{véhicule} a atteint sa limite quotidienne ({hours_today}/{max} HT). Disponible demain."
- condition: vehicle_end_of_life
  tooltip: "{véhicule} en fin de vie ({hours_used}/{max_hours} heures). Remplacez-le."
```

### Récap coût — infos véhicule

Le récapitulatif coût total (§14.4) doit aussi afficher :
```
Tracteur : 15.2/20 HT utilisés aujourd'hui (reste 4.8 HT)
           8 200/10 000 heures (82% durée de vie)
```

### Impact sur l'argus

```
argus = prix_neuf × (1 - usure/100) × (1 - hours_used/max_hours) × 0.85 × 0.60
```

Un tracteur neuf à 35 000€ avec 50% d'usure et 50% de durée de vie consommée :
`35 000 × 0.50 × 0.50 × 0.85 × 0.60 = 4 463€`


---

## 10. Espérance de vie animale (mort naturelle)

Chaque animal a une espérance de vie. À l'approche de la fin de vie, la production baisse. À la mort naturelle, l'animal est retiré automatiquement.

| Espèce | Espérance de vie (SimAgri) | En jours Cultivia | Alerte à |
|--------|---------------------------|-------------------|----------|
| Bovins | 10-12 ans | 840-1 008j | 80% |
| Bisons | 20-22 ans | 1 680-1 848j | 80% |
| Caprins | 7-8 ans | 588-672j | 80% |
| Ovins | 7-8 ans | 588-672j | 80% |
| Porcins | 3-4 ans | 252-336j | 80% |
| Volailles | 7-8 ans | 588-672j | 80% |
| Pintades | 7-8 ans | 588-672j | 80% |
| Lapins | 5-6 ans | 420-504j | 80% |
| Oies | 8-10 ans | 672-840j | 80% |
| Canards | 6-8 ans | 504-672j | 80% |
| Daims | 18-20 ans | 1 512-1 680j | 80% |
| Chevaux | 25-30 ans | 2 100-2 520j | 80% |

### Mécanique

- L'espérance de vie exacte est tirée aléatoirement à la naissance (entre min et max).
- À 80% de l'espérance → notification "⚠️ {nom} vieillit ({age}/{esperance})"
- À 90% → production -50%, reproduction impossible
- À 100% → mort naturelle. Notification "💀 {nom} est mort de vieillesse ({age})". Animal retiré. Capacité bâtiment libérée.
- Un animal bien nourri et en bonne santé a +10% d'espérance de vie (bonus).

### Tick

Ajouté dans `updateAnimalAging()` (étape 5 du tick journalier) :
```
Si animal.age >= animal.max_lifespan → mort naturelle
Si animal.age >= animal.max_lifespan × 0.90 → production ÷ 2
```

### Colonne DATA_MODEL

```sql
ALTER TABLE animal ADD COLUMN max_lifespan_days INT; -- tiré à la naissance
```


---

## 11. Réponses aux 1000 questions — Edge cases (15 manques)

| # | Question | Réponse | Règle |
|---|----------|---------|-------|
| Q12 | Pseudo en doublon | UNIQUE(username, server_id) | 409 AUTH_USERNAME_EXISTS |
| Q34 | Changer de préfecture | Non. Déménagement = post-MVP (F196 Sprint 20+, coût 50 000€) | Irréversible à l'inscription |
| Q67 | Animal en transit + bâtiment détruit | Animal redirigé vers le premier bâtiment avec place. Si aucun → animal en attente (notification urgente) | Check à l'arrivée (F048) |
| Q78 | Nourrir 1 animal individuellement | Non. Nourrissage par bâtiment ou par lot. Pas individuel. | Simplification gameplay |
| Q91 | Poids animal temps réel | Mis à jour 1×/jour par le tick (étape 5). Affiché = dernière valeur calculée. | Tick journalier |
| Q142 | Mère meurt pendant gestation | Fœtus perdu. Notification "💀 {mère} morte — gestation interrompue" | Tick santé (F011) |
| Q167 | 2 cultures même parcelle | Non. 1 culture par parcelle. Exception : couvert CIPAN (F103) sur jachère. | Règle stricte |
| Q189 | Récolter pendant pluie forte | Interdit si pluie forte (comme vent interdit pulvérisation). Disabled "🌧️ Pluie trop forte pour récolter" | Nouveau check F041 |
| Q223 | Utiliser matériel en livraison | Non. Disabled "Matériel en cours de livraison (arrivée dans {delay})" | Status check |
| Q312 | Multi-voyages = 1 clic | Oui. 1 action, N voyages calculés automatiquement. Le joueur ne clique qu'une fois. | UX |
| Q334 | Panne par voyage ou par action | 1 jet de panne par action (pas par voyage). Sinon 17 voyages = quasi-certain panne. | Équilibrage |
| Q445 | Joueur banni + annonces P2P | Annonces supprimées automatiquement au ban. | Anti-triche |
| Q478 | Pluie remplit jauge eau parcelle | Oui. Tick météo : `rain_gauge += precipitation_mm`. Lié à la météo du jour. | Tick étape 8 |
| Q567 | Parcelles invendues fin de mois | Détruites (expirées). Nouveau stock généré le 1er du mois suivant. | Pas de report |
| Q912 | 0 joueurs dans une ville | Minimum 10 parcelles générées par préfecture même si 0 joueurs. | Plancher |
| Q923 | 0 bâtiments (tout détruit) | Autorisé. Le joueur peut reconstruire. Pas de protection. | Liberté joueur |
| Q934 | 10 000 animaux performance | Tick par batch 100 joueurs. Pagination cursor-based. Index (owner_id, species). | Documenté SCALABILITY |
| Q945 | Changement année (jour 84→1) | Reset : quotas annuels, compteur primes PAC, statistiques annuelles. Pas de reset solde/animaux/parcelles. | Tick advanceDate |


---

## 12. Questions complémentaires — Décisions

### Animaux
| # | Question | Décision |
|---|----------|----------|
| 1 | Animal s'échappe si pré pas clôturé ? | Non. La clôture est un prérequis pour mettre au pré (F029 check). Pas de fuite. |
| 2 | Jumeaux même génétique ? | Non. Chaque petit a sa propre génétique (moyenne parents ± variation aléatoire). |
| 3 | Vendre animal mort à l'équarrissage ? | Non. Animal mort = supprimé. Pas de revenu. C'est la punition. |
| 4 | Lait de vache malade vendable ? | Non. Vache malade → production = 0 (déjà documenté F011). Pas de lait dégradé. |
| 5 | Animaux au pré en hiver consomment plus ? | Oui. Ration hivernale = ×1.3 quantité (froid = plus de calories). Documenter dans GAME_SYSTEMS. |
| 6 | Coq nécessaire pour pondre ? | Non pour les œufs (ponte sans fécondation). Oui pour la reproduction (insémination F018). Réaliste. |

### Cultures
| # | Question | Décision |
|---|----------|----------|
| 7 | Culture non récoltée pourrit ? | Oui. Sur-maturité -2%/jour (déjà documenté P48). Après 30j mature → culture détruite (rendement 0). |
| 8 | Gel détruit cultures semées en hiver ? | Oui si jeunes pousses <20% (F141 événement gel). Les céréales d'hiver (blé, orge) résistent au gel léger. |
| 9 | Labourer un pré → culture ? | Non. Le type de parcelle est fixe (culture/pré/verger/vigne/forêt). Pas de conversion. |
| 10 | Sol se dégrade sans engrais ? | Oui. Chaque récolte exporte des nutriments. Sans engrais, le sol s'appauvrit progressivement. Déjà dans les 9 facteurs rendement. |
| 11 | Semence standard toujours = même rendement ? | Oui. Standard = base. Certifiée = +10%. Pas de dégradation de la standard. |

### Matériel
| # | Question | Décision |
|---|----------|----------|
| 12 | Tracteur en panne bloque les outils attelés ? | Oui. Outils attelés inutilisables tant que le tracteur est en panne. Dételer + atteler à un autre tracteur. |
| 13 | Vendre tracteur avec outil attelé ? | Non. Dételer d'abord. Disabled "Dételez l'outil avant de vendre". |
| 14 | Matériel rouille plus en hiver ? | Non. Usure non abrité = ×1.5 toute l'année. Pas de variation saisonnière (trop complexe). |
| 15 | Prêter matériel gratuitement ? | Non. Location uniquement (F090). Le prêt gratuit = exploit (contourne l'économie). |

### Économie
| # | Question | Décision |
|---|----------|----------|
| 16 | Intérêts sur découvert ? | Non. Le plancher -30k€ est la punition. Pas d'intérêts en plus. Simplification. |
| 17 | Faillite ? | Non. Le joueur ne peut pas descendre sous -30k€. Il est bloqué mais pas éliminé. Il peut toujours vendre du matériel/animaux pour remonter. |
| 18 | Prix Marché Central identiques pour tous ? | Oui. Même cours pour tous les joueurs au même moment. Variation quotidienne (F077). |
| 19 | Refuser négociation P2P ? | Oui. Le vendeur reçoit l'offre et peut accepter ou refuser. Notification WS. |

### Bâtiments
| # | Question | Décision |
|---|----------|----------|
| 20 | Bâtiment s'effondre à 100% usure ? | Non. Usure bâtiment = dégradation progressive (énergie +, capacité -). Pas d'effondrement. Entretien mensuel (F067 tick). |
| 21 | Lait périme dans la cuve ? | Non pour le MVP. Post-MVP : DLC 7 jours SimAgri (F158 fromagerie). |
| 22 | Hangar capacité véhicules ? | 1 véhicule = 10m² de hangar. Hangar 50m² = 5 véhicules abrités. Documenter. |

### Social
| # | Question | Décision |
|---|----------|----------|
| 23 | Bloquer un joueur ? | Oui. Bouton "Bloquer" sur la fiche joueur. Plus de messages ni d'annonces P2P visibles. |
| 24 | Annonces P2P cross-serveur ? | Non. 1 serveur = 1 marché. Pas de cross-serveur. |
| 25 | Signaler un joueur ? | Oui. Bouton "Signaler" → modération. Post-MVP. |

### Temps
| # | Question | Décision |
|---|----------|----------|
| 26 | Action en cours à minuit ? | L'action se termine normalement. Le tick s'exécute APRÈS (pas d'interruption). |
| 27 | Tick > 24h ? | Impossible. Batch 100 joueurs × 5 parallèles. 10 000 joueurs < 5 min. Si > 10 min → alerte monitoring. |

### Divers
| # | Question | Décision |
|---|----------|----------|
| 29 | Renommer sa ferme ? | Oui. Page /settings. Gratuit. 1×/mois. |
| 30 | Avatar/photo profil ? | Post-MVP. Choix parmi 20 avatars prédéfinis (pas d'upload). |
| 31 | Tutoriel cultures ? | Oui. F112 adapte les 5 étapes au kit (cultivateur = étapes cultures). Déjà prévu. |
| 32 | Historique actions (log) ? | Oui. Le ledger (transaction) + notifications (F104) couvrent ça. Pas de log séparé. |


---

## 13. Questions approfondies — 200+ (seuls les manques)

### Animaux — Comportement détaillé

| # | Question | Décision |
|---|----------|----------|
| 33 | Un animal peut-il être transféré entre 2 joueurs sans passer par le marché P2P ? | Non. Tout transfert = annonce P2P (F080/F081). Anti-triche. |
| 34 | Un animal acheté au Marché Central a-t-il un historique (parents inconnus) ? | Oui. Parents = "Inconnu" (pas de pedigree). Seuls les animaux nés sur la ferme ont un arbre. |
| 35 | La production laitière baisse-t-elle avec l'âge ? | Oui. Pic à 3-5 ans, puis -5%/an. Intégré dans updateAnimalProduction. |
| 36 | Un animal peut-il être blessé (pas malade, blessé) ? | Non pour le MVP. Maladie = seul état négatif. Blessure = post-MVP. |
| 37 | Les animaux au pré sont-ils visibles sur la page du pré ou sur /animals ? | Les deux. /animals avec filtre "Lieu = Pré Nord". La fiche parcelle pré montre aussi le nombre d'animaux. |
| 38 | Peut-on voir la génétique d'un animal AVANT de l'acheter au Marché Central ? | Non. Génétique révélée après achat (aléatoire). Au CIA (F019), on voit la génétique de la dose. |
| 39 | Un veau peut-il être vendu à l'abattoir immédiatement ? | Oui. Mais le poids est faible = prix bas. Pas de restriction d'âge minimum pour l'abattoir. |
| 40 | Les animaux stressés (surpopulation) produisent-ils moins ? | Oui. Si bâtiment > 100% capacité → production -20%, santé -5/jour. Notification surpopulation (F076). |
| 41 | Un animal en soins (F012, 3j guérison) peut-il être déplacé ? | Non. Disabled "Animal en soins — attendez la guérison". |
| 42 | Le nourrissage auto (F010) fonctionne-t-il pour les animaux au pré ? | Non. Au pré = herbe (gratuit en été). En hiver = ration hivernale manuelle ou auto SI bâtiment configuré. |
| 43 | Que se passe-t-il si on met un mâle et des femelles dans le même bâtiment sans vouloir de reproduction ? | L'insémination est manuelle (F018). Pas de reproduction automatique. Le mâle ne fait rien tout seul. |
| 44 | Un animal peut-il être "favori" (épinglé en haut de la liste) ? | Oui. Étoile ⭐ sur la fiche. Filtre "Favoris" dans la DataTable. Stocké en localStorage. |

### Cultures — Détails mécaniques

| # | Question | Décision |
|---|----------|----------|
| 45 | Le sol se régénère-t-il naturellement (sans engrais) ? | Très lentement. +1 nutriment/an naturellement. Avec engrais = +50-100/épandage. La jachère aide (+5/mois). |
| 46 | Peut-on semer sur une parcelle non analysée ? | Oui. L'analyse (F036) est optionnelle. Sans analyse, le joueur ne connaît pas les valeurs exactes du sol. |
| 47 | Le rendement est-il visible AVANT la récolte ou seulement après ? | Avant (UX-01 breakdown estimé). Mais c'est une estimation — le rendement réel peut varier ±5%. |
| 48 | La paille au sol (après récolte) disparaît-elle si on ne la presse/broie pas ? | Oui. Après 14 jours, la paille au sol se décompose naturellement (restitution partielle nutriments). |
| 49 | Peut-on épandre du fumier sur un pré ? | Oui. Le pré bénéficie de l'épandage (herbe pousse mieux). Même flow F055. |
| 50 | Le couvert CIPAN (F103) empêche-t-il les mauvaises herbes ? | Oui. C'est un de ses avantages : couverture du sol = moins de mauvaises herbes au printemps. Bonus rendement +5% inclut ça. |
| 51 | Peut-on irriguer un pré ? | Non. L'irrigation (F058) est réservée aux parcelles culture. Les prés dépendent de la pluie. |
| 52 | La rotation est-elle obligatoire ou juste recommandée ? | Obligatoire pour certaines cultures (blé après blé = interdit si rotation_years=1). Le jeu bloque le semis. |
| 53 | Que se passe-t-il si le joueur ne fait aucun traitement (ni fongicide ni herbicide ni insecticide) ? | Rendement ×0.90 par traitement manquant. 0 traitement = rendement ×0.73 (0.9³). Viable mais sous-optimal. |

### Matériel — Cas limites

| # | Question | Décision |
|---|----------|----------|
| 54 | Peut-on avoir 2 outils attelés au même tracteur (avant + arrière) ? | Oui. F127 (arrière) + F132 (avant, relevage). Combiné = 2 actions en 1 passage. Post-MVP Sprint 14. |
| 55 | Un véhicule en livraison (F049) consomme-t-il de l'usure naturelle ? | Non. L'usure naturelle commence quand le véhicule est "available". |
| 56 | Peut-on assurer un véhicule en panne ? | Non. Disabled "Réparez d'abord". L'assurance couvre les pannes futures, pas les pannes existantes. |
| 57 | L'assurance réduit-elle le coût de réparation ou rembourse-t-elle après ? | Réduit le coût : réparation = coût normal ÷ 2 si assuré. Pas de remboursement a posteriori. |
| 58 | Peut-on acheter du matériel d'occasion au Marché Central (PNJ) ? | Non. Le Marché Central vend du neuf uniquement. L'occasion = P2P (F089) ou négociant matériel (post-MVP). |
| 59 | Le GPS (F182, post-MVP) s'use-t-il ? | Non. C'est un accessoire permanent (abonnement annuel 500€). Pas d'usure. |
| 60 | Que se passe-t-il si le joueur vend son SEUL tracteur ? | Il ne peut plus rien faire (pas de labour, pas de transport). Modale de confirmation "⚠️ C'est votre seul tracteur !". |

### Économie — Cas extrêmes

| # | Question | Décision |
|---|----------|----------|
| 61 | Le joueur peut-il donner de l'argent à un autre joueur ? | Non. Pas de transfert direct. Anti-triche. Le commerce P2P est le seul moyen. |
| 62 | Les taxes foncières augmentent-elles avec le nombre de parcelles ? | Oui. Taxe progressive : 5€/ha pour les 50 premiers ha, 8€/ha au-delà. Documenté dans F067. |
| 63 | Le joueur paie-t-il des charges même s'il ne se connecte pas ? | Oui. Le tick mensuel (F067) débite salaires, prêts, énergie, taxes que le joueur soit connecté ou non. |
| 64 | Peut-on avoir plusieurs prêts en même temps ? | Oui. Tant que le total ≤ 150 000€. Chaque prêt a sa propre mensualité. |
| 65 | L'épargne est-elle protégée si le solde est négatif ? | Oui. L'épargne est un compte séparé. Le joueur ne peut pas y toucher sauf clôture volontaire (F065). |
| 66 | Les prix CAR changent-ils dans le temps ? | Non pour le MVP. Prix fixe par CAR. Post-MVP : le président CAR peut ajuster les prix (F190). |
| 67 | Le contrat laiterie (F092) a-t-il une durée minimale ? | Oui. 3 mois Cultivia (21 jours réels). Résiliation avant = pénalité. |

### Bâtiments — Détails

| # | Question | Décision |
|---|----------|----------|
| 68 | Peut-on avoir plusieurs silos pour le même produit ? | Oui. Chaque silo stocke 1 type de produit. 2 silos blé = double capacité. |
| 69 | La salle de traite peut-elle traire des chèvres ET des vaches ? | Oui. La salle de traite est multi-espèce (bovins, caprins, ovins). Même équipement. |
| 70 | Le hangar protège-t-il aussi les stocks (paille, foin) ? | Non. Le hangar protège les véhicules. Les stocks sont dans les silos/entrepôts. |
| 71 | Peut-on construire un bâtiment sur une parcelle ? | Non. Les bâtiments sont sur la ferme (pas sur les parcelles). Les parcelles sont séparées. |
| 72 | L'énergie d'un bâtiment vide est-elle facturée ? | Oui mais réduite. Bâtiment vide = 50% de la consommation normale (chauffage minimum). |

### Transport — Précisions

| # | Question | Décision |
|---|----------|----------|
| 73 | Le transport entre 2 parcelles du joueur coûte-t-il du HVC ? | Non. Les parcelles sont "à côté" de la ferme (même préfecture). Pas de transport intra-ferme. |
| 74 | Le transport vers une parcelle dans une AUTRE ville coûte-t-il ? | Oui. Distance haversine entre les 2 préfectures. Chaque travail sur cette parcelle = transport aller-retour. |
| 75 | Le joueur peut-il stocker du matériel sur une parcelle distante ? | Non. Tout le matériel est à la ferme. Transport aller-retour à chaque utilisation sur parcelle distante. |
| 76 | Le coût transport pour vendre au Marché Central dépend-il du produit ? | Non. Le coût dépend de la distance et du nombre de voyages. Pas du type de produit. |

### Météo — Impacts détaillés

| # | Question | Décision |
|---|----------|----------|
| 77 | La canicule a-t-elle un impact ? | Oui. Été + canicule → animaux stressés (production -10%), cultures irriguées OK, non irriguées -15%. Post-MVP (F141). |
| 78 | La neige a-t-elle un impact ? | Non pour le MVP. La neige = visuel saisonnier, pas de mécanique. |
| 79 | Le brouillard a-t-il un impact ? | Non. Pas de mécanique brouillard. |
| 80 | La météo est-elle la même pour toute la France ? | Non. Par zone climatique (4 zones dans le seed 03bis_climate_zones). Chaque zone a sa propre météo. |

### Interface — Détails UX

| # | Question | Décision |
|---|----------|----------|
| 81 | Le joueur peut-il annuler une action en cours ? | Non. Une fois confirmée, l'action est exécutée. L'idempotency empêche le double-clic mais pas l'annulation. |
| 82 | Le joueur peut-il défaire (undo) une action ? | Non. Pas d'undo. Les modales de confirmation protègent des erreurs. |
| 83 | Les notifications ont-elles un son ? | Non pour le MVP. Option post-MVP dans les préférences. |
| 84 | Le joueur peut-il personnaliser le dashboard (réorganiser les widgets) ? | Non pour le MVP. Post-MVP (backlog). Ordre fixe pour le MVP. |
| 85 | La recherche globale (barre de recherche) cherche dans quoi ? | Animaux (nom, race), parcelles (nom), matériel (type, marque), joueurs (pseudo). Pas dans les finances. |

### Sécurité — Cas supplémentaires

| # | Question | Décision |
|---|----------|----------|
| 86 | Un joueur peut-il inspecter les requêtes API et tricher ? | Les vérifications sont TOUTES côté serveur. Le client peut être modifié mais le serveur rejette. FOR UPDATE + checks. |
| 87 | Le mot de passe a-t-il une politique de complexité ? | Oui. Min 8 chars, 1 majuscule, 1 chiffre. Documenté Sprint 01. |
| 88 | Le joueur peut-il changer son email ? | Oui. Page /settings. Vérification du nouvel email requise. |
| 89 | Le joueur peut-il changer son mot de passe ? | Oui. Page /settings. Ancien mot de passe requis. |
| 90 | Y a-t-il un "mot de passe oublié" ? | Oui. Email de reset avec token 1h. Flow standard, pas dans le registry (infra auth). |

### Gameplay avancé

| # | Question | Décision |
|---|----------|----------|
| 91 | Le joueur peut-il spécialiser ses employés ? | Non pour le MVP. Employé = +4 HT générique. Post-MVP (F161 savoir-faire) : spécialisation. |
| 92 | Les employés peuvent-ils tomber malades / démissionner ? | Non. Les employés sont fiables. Seul le licenciement (F028) ou le non-paiement (F067) les retire. |
| 93 | Le joueur peut-il automatiser la traite (pas juste le nourrissage) ? | Non pour le MVP. La traite est manuelle (choix stratégique : combien de créneaux). Post-MVP : robot de traite. |
| 94 | Le joueur peut-il programmer des actions à l'avance (file d'attente) ? | Non pour le MVP. Chaque action = 1 clic. Post-MVP : file d'actions (backlog UX). |
| 95 | Le joueur gagne-t-il de l'XP ou des niveaux ? | Non pour le MVP. Post-MVP : F161 savoir-faire (3 branches, niveaux 1-10). |
| 96 | Y a-t-il des succès/trophées cachés ? | Non pour le MVP. Post-MVP : F142 achievements. |


### Multi-joueurs — Interactions

| # | Question | Décision |
|---|----------|----------|
| 97 | Deux joueurs peuvent-ils être dans la même préfecture ? | Oui. Pas de limite de joueurs par préfecture. |
| 98 | Un joueur peut-il voir les animaux/parcelles d'un autre ? | Seulement via la fiche joueur publique (F096) et la visite ferme (F153 post-MVP). Pas de détail individuel. |
| 99 | Les classements sont-ils mis à jour en temps réel ? | Non. Cache Redis 300s (5 min). Suffisant. |
| 100 | Un joueur peut-il quitter une CAR ? | Oui. Quitter = perdre les avantages prix. Pas de pénalité. Cooldown 30j avant de rejoindre une autre. |
| 101 | Le président d'une CAR peut-il exclure un membre ? | Post-MVP (F190 décisions CESA). Pour le MVP, pas d'exclusion. |
| 102 | Les messages P2P sont-ils modérés ? | Non pour le MVP. Signalement (Q25) = post-MVP. Filtre mots interdits basique. |

### Parcelles distantes

| # | Question | Décision |
|---|----------|----------|
| 103 | Le joueur voit-il la distance de chaque parcelle dans le listing mensuel ? | Oui. Colonne "Distance" + "Coût transport estimé/voyage". |
| 104 | Les parcelles distantes ont-elles un avantage (moins chères) ? | Oui. Le prix/ha varie par préfecture. Les zones rurales = moins cher. |
| 105 | Le joueur peut-il revendre une parcelle à un autre joueur ? | Oui. F087 (louer) existe. La vente P2P de parcelle = via le listing (le joueur met en vente, un autre achète). Taxe plus-value. |

### Nourriture — Détails

| # | Question | Décision |
|---|----------|----------|
| 106 | Les aliments ont-ils une DLC (péremption) ? | Non pour le MVP. Le foin/maïs ne périme pas dans le silo. Post-MVP : DLC sur produits frais (lait, fromage). |
| 107 | Peut-on fabriquer sa propre nourriture (cultiver du blé pour nourrir les poules) ? | Oui. Le blé récolté va dans le silo. Le silo est utilisable comme source d'aliment pour le nourrissage. Boucle vertueuse. |
| 108 | Le joueur peut-il créer ses propres rations personnalisées ? | Oui. F008 permet de choisir une ration. Les rations sont configurables (% de chaque aliment). |
| 109 | La qualité de la ration impacte-t-elle la génétique des petits ? | Non. La génétique est héritée des parents. La ration impacte la production et la santé, pas la génétique. |
| 110 | Un animal sous-nourri (ration basse qualité) grandit-il moins vite ? | Oui. Qualité ration impacte la croissance pondérale. Ration ★1 = croissance ×0.7, ★5 = ×1.1. |

### Reproduction — Détails

| # | Question | Décision |
|---|----------|----------|
| 111 | Peut-on choisir le sexe du petit ? | Non. Aléatoire 50/50. |
| 112 | Les jumeaux sont-ils plus fréquents chez certaines races ? | Oui. Ovins = 1-2 petits (race dépendante). Porcins = 6-12. Documenté dans MATRICE_ESPECES. |
| 113 | La consanguinité (si on la contournait) aurait-elle un impact négatif ? | Le check empêche la consanguinité (F018). Pas de mécanique "malformation" car c'est bloqué en amont. |
| 114 | Un mâle castré (F125) peut-il être vendu plus cher à l'abattoir ? | Non pour le MVP. En vrai oui (bœuf vs taureau). Post-MVP : bonus carcasse +10% si castré. |

### Vente — Détails

| # | Question | Décision |
|---|----------|----------|
| 115 | Le joueur peut-il fixer un prix minimum pour la vente auto (récolte excédentaire) ? | Non. L'auto-vente se fait au cours du jour. Pas de prix minimum. Le joueur peut stocker et vendre manuellement plus tard. |
| 116 | Les frais d'annonce P2P (100€) sont-ils remboursés si l'annonce expire sans vente ? | Non. 100€ perdus. Ça motive le joueur à fixer un prix réaliste. |
| 117 | Peut-on modifier le prix d'une annonce P2P active ? | Oui. Modifier = gratuit. Pas besoin de supprimer et recréer. |
| 118 | Le vendeur P2P voit-il qui a acheté ? | Oui. Notification "Marcel a acheté votre Montbéliarde pour 1 500€". |

### Bâtiments — Détails

| # | Question | Décision |
|---|----------|----------|
| 119 | Peut-on renommer un bâtiment ? | Oui. Clic sur le nom (inline edit, comme F005 pour les animaux). |
| 120 | Un bâtiment en construction (niv 2+) est-il utilisable pendant les travaux ? | Non. Bâtiment indisponible pendant la construction. Durée = 1j par niveau. |
| 121 | La fosse à fumier déborde-t-elle si pleine ? | Non. Le fumier s'accumule dans le bâtiment si la fosse est pleine. Le bâtiment devient insalubre → animaux malades. |
| 122 | Peut-on avoir une fosse à fumier ET une fosse à lisier ? | Oui. Nécessaire si on a des bâtiments litière ET caillebotis. |

### HT — Détails

| # | Question | Décision |
|---|----------|----------|
| 123 | Les HT non utilisés sont-ils reportés au lendemain ? | Non. Reset à 40 (+ employés) chaque jour. Use it or lose it. |
| 124 | Le nourrissage auto consomme-t-il des HT même si le joueur ne se connecte pas ? | Oui. Le tick déduit les HT du nourrissage auto. Si HT insuffisants (après reset) → skip + notification. |
| 125 | Peut-on "acheter" des HT supplémentaires ? | Non. Les HT sont fixes (40 + employés). Pas de pay-to-win. La Licence Pro donne +5 HT (post-MVP F147). |

### Performance — Limites

| # | Question | Décision |
|---|----------|----------|
| 126 | Nombre max d'animaux par joueur ? | Pas de limite technique. Limité par la capacité des bâtiments. En pratique, 500+ animaux = joueur très avancé. |
| 127 | Nombre max de parcelles par joueur ? | Pas de limite. Limité par le solde et le listing mensuel. |
| 128 | Nombre max de bâtiments par joueur ? | Pas de limite. Les 10 premiers sont instantanés, les suivants ont un délai. |
| 129 | Taille max de la base de données estimée ? | 10 000 joueurs × 50 animaux × 10 parcelles × 365 jours de ledger = ~200M rows/an. Partitionnement documenté. |


### Inscription & Compte

| # | Question | Décision |
|---|----------|----------|
| 130 | Peut-on jouer sur plusieurs serveurs avec le même email ? | Non. 1 email = 1 compte = 1 serveur (pour le MVP, 1 seul serveur France). |
| 131 | Le pseudo peut-il contenir des espaces/accents ? | Oui. 3-20 chars, alphanumérique + accents + tirets + espaces. Regex : `[a-zA-ZÀ-ÿ0-9 '-]+` |
| 132 | Le joueur peut-il supprimer sa ferme et recommencer ? | Non. Suppression = RGPD (anonymisation). Pour recommencer = nouveau compte avec un autre email. |
| 133 | Y a-t-il un mode spectateur (voir le jeu sans jouer) ? | Non. Il faut un compte pour voir quoi que ce soit. Les classements sont publics (sans connexion). |
| 134 | Le joueur reçoit-il un email de bienvenue ? | Oui. Email de vérification à l'inscription + email de bienvenue avec lien vers le tutoriel. |

### Saisons & Temps

| # | Question | Décision |
|---|----------|----------|
| 135 | Le joueur peut-il voir le calendrier des saisons à venir ? | Oui. Page /weather affiche la saison actuelle + les 3 prochaines avec dates. |
| 136 | Les mois Cultivia ont-ils des noms (Janvier, Février...) ou juste des numéros ? | Des noms. Mois 1=Janvier, 2=Février... 12=Décembre. Affichés partout. |
| 137 | Le tick de minuit est-il à minuit UTC ou Europe/Paris ? | Europe/Paris (00:00 CET/CEST). Documenté dans .env (DAILY_TICK_TZ=Europe/Paris). |
| 138 | Que se passe-t-il pendant l'heure de changement d'heure (CET→CEST) ? | Le tick utilise le fuseau Europe/Paris. Le changement d'heure est géré par le système. Pas de double tick. |

### Eau & Irrigation

| # | Question | Décision |
|---|----------|----------|
| 139 | L'eau de la cuve est-elle gratuite (juste le remplissage coûte) ? | Oui. L'eau dans la cuve est gratuite à l'usage. Seul le remplissage (F007) coûte. |
| 140 | La cuve à eau peut-elle geler en hiver ? | Non. Pas de mécanique gel de cuve. Simplification. |
| 141 | Les bacs à eau au pré se vident-ils plus vite en été ? | Oui. Consommation eau animaux ×1.3 en été (chaleur). Documenté dans tick F053. |
| 142 | La source (forage F057) peut-elle se tarir ? | Non. Le niveau de source est permanent. Mais le débit est limité par le niveau (1-10). |

### Génétique — Profondeur

| # | Question | Décision |
|---|----------|----------|
| 143 | Les 5 indices génétiques sont-ils sur 100 ? | Oui. 0-100 par indice. Moyenne du serveur = ~50. Un animal à 80+ est excellent. |
| 144 | La génétique peut-elle muter (amélioration spontanée) ? | Non. La génétique est fixée à la naissance (moyenne parents ± variation ±10). Pas de mutation. |
| 145 | Le joueur peut-il voir la génétique moyenne de sa race sur le serveur ? | Post-MVP. Table `genetic_server_avg` existe dans le DATA_MODEL. Affichage = post-MVP. |
| 146 | La dose CIA (F019) a-t-elle une génétique visible avant achat ? | Oui. Le catalogue CIA montre les indices du taureau. C'est l'avantage du CIA vs mâle ferme. |

### Abattoir — Détails

| # | Question | Décision |
|---|----------|----------|
| 147 | Le rendement carcasse dépend-il de la race ET de l'alimentation ? | Oui. Race = base (55-75% allaitant, 50-55% laitier). Alimentation = ±5% selon qualité ration. |
| 148 | Le joueur peut-il choisir à quel abattoir vendre ? | Non. 1 abattoir PNJ par serveur. Prix = cours du marché × qualité carcasse. |
| 149 | Les frais d'abattoir sont-ils déduits du prix de vente ? | Non. Le prix affiché est net (transport déduit). Pas de frais d'abattoir séparés. Simplification. |

### Marché Central — Détails

| # | Question | Décision |
|---|----------|----------|
| 150 | Le Marché Central est-il ouvert 24h/24 ? | Oui. Pas d'horaires d'ouverture. Le joueur peut acheter/vendre à tout moment. |
| 151 | Le Marché Central a-t-il un stock limité de produits (aliments, semences) ? | Non. Stock illimité pour les produits (aliments, semences, engrais, traitements). Seuls les animaux ont une limite (5/espèce/jour). |
| 152 | Le prix au Marché Central inclut-il le transport ? | Non. Prix = prix produit. Transport = en plus (calculé selon distance + véhicule + voyages). |

### Employés — Détails

| # | Question | Décision |
|---|----------|----------|
| 153 | Les employés ont-ils un nom généré aléatoirement ? | Oui. Prénom + nom français aléatoire. Le joueur peut renommer. |
| 154 | Les employés travaillent-ils le week-end ? | Oui. Pas de week-end dans Cultivia. 7j/7. Les HT sont disponibles chaque jour. |
| 155 | Un employé licencié peut-il être réembauché ? | Non. Licencié = supprimé. Embaucher = nouveau employé (nouveau nom). |
| 156 | Les employés vieillissent-ils / partent-ils à la retraite ? | Non pour le MVP. Post-MVP (SimAgri : mécanicien retraite à 60 ans). |

### Erreurs & Récupération

| # | Question | Décision |
|---|----------|----------|
| 157 | Le joueur peut-il contacter le support in-game ? | Post-MVP. Pour le MVP : email support@cultivia.fr. |
| 158 | Y a-t-il un système de ticket/bug report in-game ? | Post-MVP. Pour le MVP : formulaire contact sur le site. |
| 159 | Le joueur peut-il voir les logs du serveur (maintenance, downtime) ? | Oui. Page /status (publique) avec uptime et prochaine maintenance prévue. |
| 160 | Que se passe-t-il si le serveur crash pendant le tick ? | Le tick lock (10min) expire. Au redémarrage, le tick reprend pour les joueurs non traités. Documenté SCALABILITY. |

### Parcelles — Détails supplémentaires

| # | Question | Décision |
|---|----------|----------|
| 161 | Une parcelle peut-elle avoir des pierres (aléatoire à l'achat) ? | Post-MVP (F178 épierrage). Pour le MVP : pas de pierres. |
| 162 | Le joueur peut-il voir la parcelle sur une carte ? | Post-MVP (F131 plan de ferme). Pour le MVP : liste uniquement. |
| 163 | La taxe plus-value sur la vente de parcelle est-elle progressive ? | Oui. Vente < 1 an = 90% taxe. 1-2 ans = 70%. 2-5 ans = 50%. > 5 ans = 10%. Anti-spéculation. |
| 164 | Le joueur peut-il acheter une parcelle et la revendre immédiatement ? | Oui mais taxe 90% (vente < 1 an). Pas rentable. Anti-spéculation. |

### Divers — Dernières questions

| # | Question | Décision |
|---|----------|----------|
| 165 | Le jeu a-t-il un mode hors-ligne ? | Non. Jeu en ligne uniquement. Pas de mode hors-ligne. |
| 166 | Le jeu fonctionne-t-il sur tous les navigateurs ? | Chrome, Firefox, Safari, Edge (dernières 2 versions). Pas IE. |
| 167 | Le jeu a-t-il un son / musique ? | Non pour le MVP. Post-MVP : sons optionnels (notification, saison). |
| 168 | Le joueur peut-il prendre un screenshot in-game ? | Non. Le navigateur gère ça (Ctrl+Shift+S). Pas de feature in-game. |
| 169 | Y a-t-il un changelog visible par les joueurs ? | Oui. Page /changelog. Mis à jour à chaque sprint. |
| 170 | Le joueur peut-il suggérer des features ? | Post-MVP. Pour le MVP : email/forum. |
| 171 | Les données du joueur sont-elles sauvegardées automatiquement ? | Oui. Chaque action = requête API = sauvegarde immédiate en BDD. Pas de "bouton sauvegarder". |
| 172 | Le joueur peut-il jouer en mode plein écran ? | Oui. F11 navigateur. Pas de bouton in-game. |


### Questions @backend

| # | Question | Décision |
|---|----------|----------|
| 173 | Que retourne POST /api/animals/buy si le transit est de 7h ? L'animal avec status='in_transit' ou juste un message ? | Retourne l'animal complet avec `status: 'in_transit', arrival_at: '...'`. Le frontend affiche "En transit". |
| 174 | Le ledger (table transaction) stocke-t-il le détail des multi-voyages ? | Oui. 1 entrée ledger avec `description: '100T blé, 17 voyages, 408€ transport'`. Pas 17 entrées. |
| 175 | Les WebSocket events sont-ils envoyés DANS la transaction SQL ou APRÈS le commit ? | APRÈS le commit. Si la transaction rollback, pas d'event WS envoyé. |
| 176 | Le refresh token est-il single-use (rotation) ? | Oui. Chaque refresh génère un nouveau refresh token et invalide l'ancien. |
| 177 | Comment gérer les requêtes concurrentes sur le même animal (2 onglets ouverts) ? | FOR UPDATE + idempotency. Le 2ème onglet reçoit 409 ou le même résultat (idempotency). |
| 178 | Les routes GET sont-elles cachées en Redis ? | Oui pour : cours marché (60s), météo (60s), classements (300s), profil public (60s). Non pour : mes animaux, mes parcelles (données personnelles, pas de cache). |

### Questions @database

| # | Question | Décision |
|---|----------|----------|
| 179 | Faut-il un index sur `animal.age` pour le tri DataTable ? | Non. L'âge est calculé (`NOW() - created_at`). Index sur `created_at` suffit. |
| 180 | La table `parcel_listing` va grossir (N préfectures × 10 × 12 mois). Purge ? | Oui. Les listings expirés/vendus > 3 mois sont purgés par un job hebdomadaire. |
| 181 | Faut-il un index sur `vehicle.hours_today` ? | Non. Vérifié uniquement lors d'une action (pas de requête de masse). |
| 182 | La colonne `animal.lot_id` est nullable. Performance sur les JOIN ? | OK. Index partiel `WHERE lot_id IS NOT NULL` pour les requêtes par lot. |

### Questions @frontend

| # | Question | Décision |
|---|----------|----------|
| 183 | Le store Pinia `useAnimalStore` charge-t-il TOUS les animaux ou paginé ? | Paginé. Le store stocke la page courante (20/50/100 items). Pas tout en mémoire. |
| 184 | Le WebSocket reconnecte-t-il automatiquement si le réseau coupe ? | Oui. Socket.io gère la reconnexion auto. À la reconnexion, `GET /api/player/me` pour resync. |
| 185 | Les colonnes personnalisables (⚙️) sont-elles sauvées par page ou globalement ? | Par page. `/animals` a sa config, `/equipment` a la sienne. Stocké localStorage. |
| 186 | Le breadcrumb est-il généré automatiquement depuis le router ? | Oui. Chaque route a un `meta.breadcrumb` dans le router. Le composant CBreadcrumb le lit. |
| 187 | Le mode compact header (<768px) masque-t-il la date/saison ? | Oui. Mobile = solde + HT icône + notifs badge. Pas de date/saison (visible sur /dashboard). |

### Questions @worker

| # | Question | Décision |
|---|----------|----------|
| 188 | Si le tick échoue pour 1 joueur, les autres sont-ils impactés ? | Non. Try/catch par joueur. Le joueur en erreur est loggé dans `failed_player_ids`. Les autres continuent. |
| 189 | Le tick de génération parcelles (1er du mois) est-il dans le tick journalier ou séparé ? | Dans le tick journalier, étape conditionnelle : `if (day_of_month === 1) generateParcelListings()`. |
| 190 | Le nourrissage auto (F010) déduit-il les HT AVANT ou APRÈS les actions manuelles du joueur ? | APRÈS le reset HT (étape 2) et AVANT que le joueur se connecte (étape 17). Le joueur voit ses HT déjà réduits. |
| 191 | Le tick vérifie-t-il la durée de vie des véhicules (fin de vie) à chaque jour ? | Oui. Étape 8 `updateEquipmentWear` vérifie `hours_used >= max_lifetime_hours`. Si oui → marquer irréparable. |

### Questions @gamedesign

| # | Question | Décision |
|---|----------|----------|
| 192 | Un joueur qui ne fait QUE de l'élevage a-t-il besoin de parcelles ? | Oui pour le pré (animaux au pâturage). Non pour les cultures. Mais acheter du foin au marché = viable sans parcelle. |
| 193 | Le jeu est-il jouable sans employé (40 HT/jour seul) ? | Oui. Jusqu'à ~20 vaches ou ~30ha. Au-delà, les employés deviennent nécessaires. |
| 194 | Le joueur peut-il être rentable dès le mois 1 ? | Cultivateur : oui (vente récolte). Éleveur laitier : oui (vente lait dès J2). Éleveur allaitant : non (18 mois). |
| 195 | Y a-t-il un avantage à jouer tôt le matin (après le tick) ? | Oui. Les HT sont reset à minuit. Le joueur qui joue tôt a toute la journée. Celui qui joue tard a moins de temps avant le reset. Mais le nourrissage auto protège. |
| 196 | Le jeu favorise-t-il les joueurs qui jouent beaucoup vs peu ? | Oui modérément. Plus de HT utilisés = plus de revenus. Mais le nourrissage auto + les ticks automatiques protègent les joueurs occasionnels. |

### Questions @security

| # | Question | Décision |
|---|----------|----------|
| 197 | Un joueur peut-il créer un bot qui joue à sa place (API calls automatiques) ? | Le rate limit (30/min user) + le délai 1s entre actions critiques rendent le bot peu efficace. Détection patterns si même actions à la même seconde chaque jour. |
| 198 | Les données financières (solde, transactions) sont-elles chiffrées en BDD ? | Non. Le solde est en clair (DECIMAL). Les mots de passe sont hashés (bcrypt). Les données financières ne sont pas des données sensibles au sens RGPD. |
| 199 | Le JWT contient-il le solde du joueur ? | Non. Le JWT contient uniquement `player_id` et `exp`. Le solde est toujours lu depuis la BDD (source de vérité). |
| 200 | Peut-on rejouer un ancien JWT (replay attack) ? | Non. JWT 15min + refresh rotation. Un JWT expiré est rejeté. Un refresh utilisé est invalidé. |

### Questions @uxdesign

| # | Question | Décision |
|---|----------|----------|
| 201 | Le joueur daltonien peut-il distinguer les états (vert/rouge/orange) ? | Oui. Chaque couleur a aussi un texte/icône (✅/❌/⚠️). WCAG AA. |
| 202 | Les tableaux sont-ils lisibles en mode zoom 200% ? | Oui. Responsive + rem units. À 200% le tableau passe en mode carte. |
| 203 | Le focus clavier est-il visible sur les boutons grisés ? | Oui. `outline: 2px solid` même sur les boutons disabled. Le tooltip s'affiche au focus (pas juste au hover). |
| 204 | Le toast est-il annoncé par les lecteurs d'écran ? | Oui. `role="alert"` + `aria-live="polite"`. |

### Questions @data

| # | Question | Décision |
|---|----------|----------|
| 205 | Les prix des seeds sont-ils en euros courants 2024 ou ajustés ? | Ajustés -10% vs réel 2024 pour maintenir la tension économique. Documenté dans 11_base_prices.sql. |
| 206 | Les coordonnées GPS des préfectures sont-elles exactes ? | Oui. Source INSEE/IGN. Précision 5 décimales (~1m). |
| 207 | Les distances pré-calculées (distance_matrix) couvrent-elles toutes les paires ? | Non. Seulement les paires utiles (même région + régions voisines). Les distances inter-régions = calculées à la volée (haversine). |

### Questions @devops

| # | Question | Décision |
|---|----------|----------|
| 208 | Le backup PostgreSQL est-il incrémental ou full ? | Full (pg_dump) quotidien. Incrémental = post-MVP (WAL archiving). |
| 209 | Le Redis est-il persisté sur disque ? | Non. Redis = cache volatile. Si Redis crash, les sessions sont perdues (re-login) mais pas les données (PostgreSQL). |
| 210 | Le PgBouncer a-t-il un monitoring ? | Oui. `SHOW STATS` via pgbouncer admin console. Alertes si connexions > 80% du pool. |


### Questions croisées équipe — Session 2

**💬 @backend × @gamedesign :**

| # | Question | Décision |
|---|----------|----------|
| 211 | Quand le joueur vend du lait, le prix dépend-il de la qualité (TB, TP, cellules) ? | Oui. Indice Qualité Lait (QL) = facteur prix. QL 50 = base, QL 80 = ×1.15, QL 20 = ×0.85. Calculé depuis la génétique + alimentation. |
| 212 | Le lait de chèvre et le lait de brebis ont-ils le même système QL ? | Oui. Même mécanique, prix de base différent (bovin 0.32€, caprin 0.60€, ovin 0.90€). |
| 213 | La viande a-t-elle aussi un indice qualité ? | Oui. Conformation (A-E) × engraissement (1-5). Déjà dans F025. |
| 214 | Les œufs ont-ils un indice qualité au-delà du calibre ? | Non pour le MVP. Le calibre (S/M/L/XL) suffit. Post-MVP : label plein-air = prix ×1.3. |

**💬 @frontend × @uxdesign :**

| # | Question | Décision |
|---|----------|----------|
| 215 | Le récap coût total (§14.4) est-il une modale ou un panneau inline ? | Panneau inline sous le bouton. Pas de modale (trop de clics). Le panneau apparaît quand le joueur sélectionne la quantité. |
| 216 | Les jauges (santé, usure, HT) sont-elles des barres ou des cercles ? | Barres horizontales. Plus lisibles dans un tableau. Les cercles = dashboard widgets uniquement. |
| 217 | Le joueur peut-il réduire la sidebar (mode icônes seules) ? | Oui. Toggle sidebar : étendue (icône + texte) ou réduite (icône seule). Mémorisé localStorage. |

**💬 @worker × @backend :**

| # | Question | Décision |
|---|----------|----------|
| 218 | Le nourrissage auto déduit-il le HVC (si désileuse configurée) ? | Oui. Si method='desilage' dans la config auto → HVC déduit + usure tracteur/désileuse. |
| 219 | Le tick de naissance (F020) vérifie-t-il la capacité du bâtiment ? | Oui. Si bâtiment plein → naissance quand même mais notification "⚠️ Surpopulation". L'animal naît, le joueur doit agrandir ou déplacer. |
| 220 | Le tick mensuel (F067) débite-t-il l'usure bâtiment même si le joueur est inactif ? | Oui. +0.5% usure/mois sur chaque bâtiment. Inactif ou pas. |

**💬 @security × @qa :**

| # | Question | Décision |
|---|----------|----------|
| 221 | Un joueur peut-il modifier le body d'une requête API (ex: changer le prix d'achat) ? | Le serveur recalcule TOUT. Le prix dans le body est ignoré — le serveur lit le prix depuis la BDD. Le body ne contient que les IDs et quantités. |
| 222 | Le rate limit est-il par route ou global ? | Global par user (30/min). Pas par route. Un joueur qui spam /api/animals ne bloque pas /api/parcels. Sauf si 30 requêtes totales atteintes. |
| 223 | L'idempotency key expire-t-elle ? | Oui. 24h en Redis. Après 24h, la même key peut être réutilisée (mais le joueur en génère une nouvelle à chaque action). |

**💬 @gamedesign × @data :**

| # | Question | Décision |
|---|----------|----------|
| 224 | Le prix du HVC à la CAR est-il fixe ou variable ? | Fixe par CAR (0.36-0.55€/L selon la CAR). Le président peut ajuster post-MVP (F190). |
| 225 | Les semences certifiées sont-elles toujours disponibles au Marché Central ? | Oui. Stock illimité. Le joueur choisit standard ou certifié au moment du semis. |
| 226 | Le compost (F078) est-il meilleur que l'engrais chimique ? | Oui. Compost = apporte TOUS les nutriments (N,P,K,Ca,Mg,S) + améliore la structure du sol. Engrais chimique = 1 nutriment ciblé. |

**💬 @devops × @backend :**

| # | Question | Décision |
|---|----------|----------|
| 227 | Le serveur API est-il stateless ? | Oui. Pas de session en mémoire. JWT + Redis. Scalable horizontalement (2-3 instances). |
| 228 | Le worker peut-il tourner en plusieurs instances ? | Non. 1 seul worker avec tick lock. Sinon double traitement. |
| 229 | Les migrations sont-elles exécutées automatiquement au déploiement ? | Oui. Le pipeline CI/CD exécute `npm run db:migrate` avant de démarrer le serveur. |


---

## 14. Système de bonus "Bonne gestion" (indice de soin)

### Principe
Chaque animal et chaque parcelle a un **indice de soin** (0-100). Le joueur soigneux est récompensé, le joueur négligent n'est que légèrement pénalisé.

### Barème bonus

| Indice | Bonus | Profil joueur |
|--------|-------|---------------|
| 80-100 | **×1.25 (+25%)** | Soigneux (tout bien fait) |
| 50-79 | ×1.10 (+10%) | Correct |
| 20-49 | ×1.00 (base) | Minimum |
| 0-19 | ×0.90 (-10%) | Négligent |

### Ce que le bonus impacte

**Animaux (indice bien-être) :**
- Production lait : ×bonus (vache bien soignée = +25% lait)
- Production œufs : ×bonus
- Production laine : ×bonus
- Croissance poids : ×bonus (veau bien nourri grandit 25% plus vite)
- Qualité lait (QL) : +bonus×10 points (bien-être 100 → QL +12.5 points)
- Qualité carcasse : conformation +1 grade si indice > 80
- Fertilité : taux réussite insémination ×bonus
- Espérance de vie : +10% si indice moyen > 80 sur la vie
- Résistance maladie : risque maladie ÷bonus (bien soigné = moins de maladies)

**Parcelles (indice santé sol) :**
- Rendement récolte : ×bonus (10ème facteur de rendement)
- Qualité récolte : Q1→Q2→Q3 plus facilement si sol bien entretenu
- Pousse herbe (pré) : ×bonus
- Efficacité engrais : sol sain absorbe mieux (+bonus%)

### Actions qui font monter l'indice animal

| Action | Impact/jour |
|--------|------------|
| Nourri (ration ★4-5) | +2 |
| Nourri (ration ★1-3) | +1 |
| Abreuvé | +1 |
| Litière fraîche | +1 |
| Au pré en été | +2 |
| Vacciné (ponctuel) | +5 |
| Vermifugé (ponctuel) | +5 |
| Pas nourri | -3 |
| Pas abreuvé | -3 |
| Litière absente | -2 |
| Surpopulation | -3 |
| Malade non soigné | -5 |

### Actions qui font monter l'indice parcelle

| Action | Impact |
|--------|--------|
| Rotation respectée | +5/récolte |
| Couvert CIPAN | +10/saison |
| Engrais adapté | +3/épandage |
| Fumier/compost (organique) | +5/épandage |
| Chaulage quand pH bas | +5 |
| Jachère (repos) | +3/mois |
| Monoculture | -10/récolte |
| Pas d'engrais | -2/saison |

### Affichage

- Fiche animal : jauge "Bien-être ████████░░ 82/100 → +25% production"
- Fiche parcelle : jauge "Santé sol ██████░░░░ 65/100 → +10% rendement"
- DataTable animaux : colonne "Bien-être" (masquée par défaut, activable via ⚙️)
- Dashboard : widget "Indice moyen bien-être troupeau : 78 → +10%"

### Colonnes DATA_MODEL

```sql
ALTER TABLE animal ADD COLUMN welfare_index SMALLINT NOT NULL DEFAULT 50 CHECK (welfare_index BETWEEN 0 AND 100);
ALTER TABLE parcel ADD COLUMN soil_health_index SMALLINT NOT NULL DEFAULT 50 CHECK (soil_health_index BETWEEN 0 AND 100);
```

### Tick journalier

Ajouté dans `updateAnimalHealth()` (étape 6) et `updateCropGrowth()` (étape 4) :
- Calculer les variations d'indice selon les actions du jour
- Appliquer le bonus sur les productions
