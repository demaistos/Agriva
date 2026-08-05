# Spécification Technique Transversale — Toutes les mutations du jeu

> Date : 2026-04-05
> S'applique à : CHAQUE endpoint POST/PUT/DELETE de Cultivia
> Un développeur backend doit appliquer ces règles à TOUTE mutation sans exception.

---

## 1. RÈGLES UNIVERSELLES (toute mutation)

### 1.1 Idempotency

**TOUTE mutation** (POST qui modifie un état) DOIT :
- Accepter le header `X-Idempotency-Key: {uuid-v4}`
- Stocker la clé + résultat en Redis (TTL 24h)
- Si clé déjà vue → retourner le résultat précédent (200, pas de re-exécution)
- Le frontend génère un UUID v4 par clic de bouton

```typescript
// Middleware idempotency (Fastify)
async function idempotencyCheck(req, reply) {
  const key = req.headers['x-idempotency-key'];
  if (!key) return; // optionnel pour les GET
  const cached = await redis.get(`idempotency:${key}`);
  if (cached) { reply.send(JSON.parse(cached)); return reply; }
}
```

**Exceptions** (pas d'idempotency requise) :
- GET (lecture seule)
- PUT sur des champs idempotents par nature (renommer un animal)
- DELETE qui est déjà idempotent (supprimer un message déjà supprimé = 200)

### 1.2 Concurrence — SELECT FOR UPDATE

**TOUTE mutation qui déduit du solde, des HT, ou du stock** DOIT :
- Utiliser `SELECT ... FOR UPDATE` sur la ligne player/building/inventory AVANT la déduction
- Vérifier la condition APRÈS le lock (pas avant)
- Transaction SQL atomique (BEGIN → SELECT FOR UPDATE → vérifs → UPDATE → COMMIT)

```sql
BEGIN;
SELECT balance, ht_today FROM player WHERE id = $1 FOR UPDATE;
-- Vérifier balance >= coût ET ht_today >= ht_cost
UPDATE player SET balance = balance - $cost, ht_today = ht_today - $ht WHERE id = $1;
-- Autres INSERT/UPDATE
COMMIT;
```

### 1.3 Ownership check

**TOUT endpoint avec un :id de ressource** DOIT :
- Vérifier que la ressource appartient au joueur authentifié
- Retourner 403 "Cette ressource ne vous appartient pas" sinon
- JAMAIS exposer l'existence d'une ressource d'un autre joueur (403, pas 404)

### 1.4 Ledger (relevé bancaire)

**TOUTE mutation qui modifie le solde** DOIT :
- Insérer une ligne dans la table `ledger`
- Colonnes : `player_id, category, label, amount, balance_after, created_at`

Categories standardisées :
| Category | Exemples |
|----------|----------|
| `purchase` | Achat matériel, bâtiment, animal, semences, engrais |
| `sale` | Vente récolte, animal abattoir, lait, matériel |
| `maintenance` | Entretien bâtiment, matériel, énergie mensuelle |
| `salary` | Salaire employé |
| `loan_credit` | Réception prêt |
| `loan_debit` | Mensualité prêt |
| `savings_deposit` | Dépôt épargne |
| `savings_withdraw` | Retrait épargne + intérêts |
| `tax` | Taxe foncière, énergie |
| `transport` | Coût transport marchandises |
| `car` | Capital CAR, dividendes |
| `health` | Soins, vaccins animaux |
| `market` | Transactions Marché Central |

### 1.5 WebSocket notifications

**TOUTE mutation qui change un état visible** DOIT émettre un event WS :

| Event | Déclenché par |
|-------|--------------|
| `balance_update` | Toute modification solde |
| `ht_update` | Toute consommation HT |
| `notification` | Alertes, messages, événements |
| `animal_alert` | Changement état animal (nourri, malade, mort, naissance) |
| `parcel_alert` | Changement état parcelle (récolte prête, météo) |
| `equipment_alert` | Panne, entretien dû |
| `building_alert` | Remplissage, entretien dû |
| `market_update` | Cours changé, annonce vendue |

### 1.6 Rate limiting

- 100 req/min par IP
- 30 req/min par user authentifié
- Mutations sensibles (achat, vente, prêt) : 10 req/min par user

### 1.7 Anti double-clic frontend

**TOUT bouton d'action** DOIT :
- Passer en `loading=true` + `disabled` au clic
- Afficher un Spinner inline
- Revenir à l'état normal après réponse API (succès ou erreur)
- Générer un nouveau `X-Idempotency-Key` à chaque clic

```vue
<CultiviaButton 
  :loading="isLoading" 
  :disabled="!canAct" 
  :tooltip="disabledReason"
  @click="handleAction"
/>
```

---

## 2. INVENTAIRE COMPLET DES MUTATIONS

### 2.1 Phase 0 — Infrastructure (18 mutations)

| # | Action | Endpoint | Coût € | Coût HT | Lock | Ledger | WS |
|---|--------|----------|--------|---------|------|--------|-----|
| 1 | S'inscrire | `POST /api/auth/register` | 0 | 0 | — | — | — |
| 2 | Se connecter | `POST /api/auth/login` | 0 | 0 | — | — | — |
| 3 | Créer ferme | `POST /api/farms` | 0 | 0 | — | `loan_credit` (100k) | `balance_update` |
| 4 | Choisir kit | `POST /api/farms/kit` | Variable | 0 | player | `purchase` | `balance_update` |
| 5 | Construire bâtiment | `POST /api/buildings` | Variable | 2.0 | player | `purchase` | `balance_update`, `ht_update`, `building_alert` |
| 6 | Agrandir bâtiment | `POST /api/buildings/:id/upgrade` | Variable | 1.0 | player | `purchase` | `balance_update`, `ht_update` |
| 7 | Entretenir bâtiment | `POST /api/buildings/:id/maintain` | 0 | 0.3 | player | — | `ht_update`, `building_alert` |
| 8 | Détruire bâtiment | `POST /api/buildings/:id/destroy` | +recovery | 1.0 | player, building | `sale` | `balance_update`, `ht_update`, `building_alert` |
| 9 | Acheter matériel neuf | `POST /api/vehicles/buy` | Variable | 1.0 | player | `purchase` | `balance_update`, `ht_update`, `equipment_alert` |
| 10 | Vendre matériel | `POST /api/vehicles/:id/sell` | +argus | 0.5 | player | `sale` | `balance_update`, `ht_update` |
| 11 | Entretenir matériel | `POST /api/vehicles/:id/maintain` | 0 | 1.0 | player | — | `ht_update`, `equipment_alert` |
| 12 | Réparer matériel | `POST /api/vehicles/:id/repair` | 5% prix neuf | 2.0 | player | `maintenance` | `balance_update`, `ht_update`, `equipment_alert` |
| 13 | Acheter HVC | `POST /api/hvc/buy` | Variable | 1.5 | player, cuve | `purchase` | `balance_update`, `ht_update` |
| 14 | Demander prêt | `POST /api/loans` | 0 | 0 | player | `loan_credit` | `balance_update` |
| 15 | Rembourser prêt | `POST /api/loans/:id/repay` | -montant | 0 | player | `loan_debit` | `balance_update` |
| 15b | Rembourser prêt anticipé | `POST /api/loans/:id/early-repay` | -capital×1.03 | 0 | player | `loan_early_repay` | `balance_update` |
| 16 | Souscrire épargne | `POST /api/savings` | -montant | 0 | player | `savings_deposit` | `balance_update` |
| 17 | Retirer épargne | `POST /api/savings/:id/withdraw` | +montant+intérêts | 0 | player | `savings_withdraw` | `balance_update` |
| 17b | Clôturer épargne anticipée | `POST /api/savings/:id/close` | +capital (0 intérêts) | 0 | player | `savings_early_close` | `balance_update` |
| 18 | Embaucher employé | `POST /api/employees` | Variable | 0 | player | `purchase` | `balance_update` |
| 18b | Licencier employé | `DELETE /api/employees/:id` | 0 | 0 | player | `salary` | `ht_update` |
| 18c | Améliorer bâtiment | `POST /api/buildings/:id/upgrade` | Variable | 1.0 | player, building | `purchase` | `balance_update`, `ht_update`, `building_alert` |
| 18d | Détruire bâtiment | `DELETE /api/buildings/:id` | +10% coût | 1.0 | player, building | `sale` | `balance_update`, `ht_update`, `building_alert` |
| 18e | Souscrire assurance | `POST /api/vehicles/:id/insure` | Variable | 0 | player | `insurance` | `balance_update` |
| 18f | Acheter pièce détachée | `POST /api/vehicles/:id/buy-piece` | Variable | 0.5 | player | `maintenance` | `balance_update`, `ht_update` |

### 2.2 Phase 1 — Cultures (14 mutations)

| # | Action | Endpoint | Coût € | Coût HT | Lock | Ledger | WS |
|---|--------|----------|--------|---------|------|--------|-----|
| 19 | Acheter parcelle | `POST /api/parcels/buy` | Variable | 2.0 | player | `purchase` | `balance_update`, `ht_update` |
| 20 | Vendre parcelle | `POST /api/parcels/:id/sell` | +50% prix | 1.0 | player | `sale` | `balance_update`, `ht_update` |
| 21 | Analyser sol | `POST /api/parcels/:id/analyze-soil` | 50 | 0.5 | player | `purchase` | `balance_update`, `ht_update` |
| 22 | Déchaumer | `POST /api/parcels/:id/prepare` (stubble) | 0 | Variable | player, hvc | — | `ht_update`, `parcel_alert` |
| 23 | Labourer | `POST /api/parcels/:id/prepare` (plow) | 0 | Variable | player, hvc | — | `ht_update`, `parcel_alert` |
| 24 | Préparer terre | `POST /api/parcels/:id/prepare` (harrow) | 0 | Variable | player, hvc | — | `ht_update`, `parcel_alert` |
| 25 | Semer | `POST /api/parcels/:id/sow` | Semences | Variable | player, hvc, stock | `purchase` | `balance_update`, `ht_update`, `parcel_alert` |
| 26 | Épandre engrais | `POST /api/parcels/:id/fertilize` | Engrais | Variable | player, hvc, stock | `purchase` | `balance_update`, `ht_update` |
| 27 | Traiter | `POST /api/parcels/:id/treat` | Produit | Variable | player, hvc, stock | `purchase` | `balance_update`, `ht_update` |
| 28 | Passer rouleau | `POST /api/parcels/:id/roll` | 0 | Variable | player, hvc | — | `ht_update` |
| 29 | Récolter | `POST /api/parcels/:id/harvest` | 0 | Variable | player, hvc, stock_dest | — | `ht_update`, `parcel_alert` |
| 30 | Presser paille | `POST /api/parcels/:id/bale` | 0 | Variable | player, hvc | — | `ht_update` |
| 31 | Vendre récolte | `POST /api/market/sell` | +revenu | 0.5 | player, stock | `sale` | `balance_update`, `ht_update`, `market_update` |
| 32 | Épandre fumier | `POST /api/parcels/:id/spread-manure` | 0 | Variable | player, hvc, stock | — | `ht_update` |
| 32b | Épandre lisier | `POST /api/parcels/:id/spread-slurry` | 0 | Variable | player, hvc, stock | — | `ht_update` |
| 32c | Forer parcelle | `POST /api/parcels/:id/drill` | 150 | 0.5 | player | `purchase` | `balance_update`, `ht_update` |
| 32d | Irriguer parcelle | `POST /api/parcels/:id/irrigate` | 0 | 0.5 | player, hvc | — | `ht_update` |
| 32e | Broyer paille | `POST /api/parcels/:id/mulch-straw` | 0 | Variable | player, hvc | — | `ht_update` |

### 2.3 Phase 2 — Élevage (18 mutations)

| # | Action | Endpoint | Coût € | Coût HT | Lock | Ledger | WS |
|---|--------|----------|--------|---------|------|--------|-----|
| 33 | Acheter animal | `POST /api/animals/buy` | Variable | 0.5 | player | `purchase` | `balance_update`, `ht_update`, `animal_alert` |
| 34 | Nourrir (manuel) | `POST /api/buildings/:id/feed` | 0 | 0.5-2.0 | player, stock | — | `ht_update`, `animal_alert` |
| 35 | Nourrir (auto config) | `POST /api/buildings/:id/auto-feed` | 0 | 0 | — | — | — |
| 36 | Abreuver | `POST /api/animals/water` | 0 | 0.3 | player, cuve_eau | — | `ht_update`, `animal_alert` |
| 37 | Soigner | `POST /api/animals/:id/heal` | Variable | Variable | player | `health` | `balance_update`, `ht_update`, `animal_alert` |
| 38 | Soigner (batch) | `POST /api/animals/batch-heal` | Variable | Variable | player | `health` | `balance_update`, `ht_update`, `animal_alert` |
| 39 | Vacciner | `POST /api/animals/:id/vaccinate` | 50 | 0.5 | player | `health` | `balance_update`, `ht_update` |
| 40 | Inséminer (naturel) | `POST /api/animals/:id/inseminate` | 0 | 1.0 | player | — | `ht_update`, `animal_alert` |
| 41 | Inséminer (CIA) | `POST /api/animals/:id/inseminate` | 200 | 1.0 | player | `health` | `balance_update`, `ht_update`, `animal_alert` |
| 42 | Traire | `POST /api/animals/milk` | 0 | 1.0 | player, cuve_lait | — | `ht_update`, `animal_alert` |
| 43 | Vendre abattoir | `POST /api/animals/slaughter` | +revenu | 0.5×N | player | `sale` | `balance_update`, `ht_update`, `animal_alert` |
| 44 | Déplacer | `POST /api/animals/move` | 0 | 0.2-0.5×N | player, dest | — | `ht_update`, `animal_alert` |
| 45 | Renommer | `PUT /api/animals/:id` | 0 | 0 | — | — | — |
| 46 | Placer auto (arrivage) | `POST /api/animals/auto-place` | 0 | 0.2×N | player | — | `ht_update`, `animal_alert` |
| 47 | Mettre paille | `POST /api/buildings/:id/bedding` | 0 | 0.5 | player, stock | — | `ht_update` |
| 48 | Retirer fumier | `POST /api/buildings/:id/manure` | 0 | 0.5 | player, fosse | — | `ht_update` |
| 49 | Retirer lisier | `POST /api/buildings/:id/slurry` | 0 | 0.5 | player, fosse | — | `ht_update` |
| 50 | Vendre lait/œufs/laine | `POST /api/market/sell` | +revenu | 0.5 | player, stock | `sale` | `balance_update`, `ht_update`, `market_update` |
| 50b | Remplir bacs eau pré | `POST /api/parcels/:id/fill-water` | 0 | 0.5 | player, cuve_eau, vehicle | — | `ht_update` |
| 50c | Appeler négociant | `POST /api/market/negociant/call` | 0 | 0 | player (rate limit 1/mois) | — | — |
| 50d | Acheter au négociant | `POST /api/market/negociant/buy` | Variable (×1.20) | 0.5 | player, building_capacity | `purchase` | `balance_update`, `ht_update`, `animal_alert` |

### 2.4 Phase 3 — Économie & Commerce (22 mutations)

| # | Action | Endpoint | Coût € | Coût HT | Lock | Ledger | WS |
|---|--------|----------|--------|---------|------|--------|-----|
| 51 | Créer CAR | `POST /api/car` | Capital | 0 | player×N | `car` | `balance_update` |
| 52 | Voter CAR | `POST /api/car/:id/votes/:vid/ballot` | 0 | 0 | — | — | `notification` |
| 53 | Proposer vote CAR | `POST /api/car/:id/votes` | 0 | 0 | — | — | `notification` |
| 54 | Démissionner CAR | `POST /api/car/:id/resign` | 0 | 0 | player | `car` | `balance_update` |
| 55 | Emprunter CAR | `POST /api/car/:id/loans` | +montant | 0 | player, car | `car` | `balance_update` |
| 56 | Rembourser CAR | `POST /api/car/:id/loans/:lid/repay` | -montant | 0 | player, car | `car` | `balance_update` |
| 57 | Acheter parts CAR | `POST /api/car/:id/shares/buy` | -montant | 0 | player, car | `car` | `balance_update` |
| 58 | Créer annonce | `POST /api/market/listings` | 0 | 0.5 | player, stock | — | `ht_update`, `market_update` |
| 59 | Acheter annonce | `POST /api/market/listings/:id/buy` | Variable | 0.5 | player×2, stock | `market` | `balance_update`, `ht_update`, `market_update` |
| 60 | Supprimer annonce | `DELETE /api/market/listings/:id` | 0 | 0 | stock | — | `market_update` |
| 61 | Créer contrat | `POST /api/contracts` | 0 | 0 | — | — | `notification` |
| 62 | Accepter contrat | `POST /api/contracts/:id/accept` | 0 | 0 | — | — | `notification` |
| 63 | Livrer contrat | `POST /api/contracts/:id/deliver` | 0 | Variable | player, stock | `market` | `balance_update`, `ht_update` |
| 64 | Créer appel d'offres | `POST /api/tenders` | 0 | 0 | — | — | `notification` |
| 65 | Répondre AO | `POST /api/tenders/:id/bid` | 0 | 0 | — | — | `notification` |
| 66 | Accepter réponse AO | `POST /api/tenders/:id/bids/:bid/accept` | 0 | 0 | — | — | `notification` |
| 67 | Commander transport | `POST /api/transport/orders` | Variable | Variable | player | `transport` | `balance_update`, `ht_update` |
| 68 | Ajouter ami | `POST /api/friends` | 0 | 0 | — | — | `notification` |
| 69 | Retirer ami | `DELETE /api/friends/:id` | 0 | 0 | — | — | — |
| 70 | Envoyer message | `POST /api/messages` | 0 | 0 | — | — | `notification` |
| 71 | Supprimer message | `DELETE /api/messages/:id` | 0 | 0 | — | — | — |
| 72 | Embaucher employé | `POST /api/employees` | Variable | 0 | player | `salary` | `balance_update` |

### 2.5 Phase 3 — Marché à terme (5 mutations)

| # | Action | Endpoint | Coût € | Coût HT | Lock | Ledger | WS |
|---|--------|----------|--------|---------|------|--------|-----|
| 73 | Acheter contrat terme | `POST /api/futures/buy` | Marge | 0 | player | `market` | `balance_update`, `market_update` |
| 74 | Vendre contrat terme | `POST /api/futures/sell` | +/-PnL | 0 | player | `market` | `balance_update`, `market_update` |
| 75 | Clôturer position | `POST /api/futures/:id/close` | +/-PnL | 0 | player | `market` | `balance_update`, `market_update` |
| 76 | Placer ordre limite | `POST /api/futures/orders` | 0 | 0 | — | — | `market_update` |
| 77 | Annuler ordre | `DELETE /api/futures/orders/:id` | 0 | 0 | — | — | `market_update` |
| 77b | Vendre matériel entre joueurs | `POST /api/vehicles/:id/list-for-sale` | 0 | 0.5 | player | — | `ht_update` |

### 2.6 Tick automatique (worker — pas d'action joueur)

| # | Action tick | Effet | Lock | Ledger |
|---|-----------|-------|------|--------|
| T1 | Reset HT | `ht_today = 40` pour tous | player batch | — |
| T2 | Nourrissage auto | Déduit stock, nourrit animaux | stock, animal | — |
| T3 | Croissance cultures | Avance progression | parcel | — |
| T4 | Vieillissement animaux | Changement stade | animal | — |
| T5 | Santé animaux | Maladie si pas nourri/abreuvé | animal | — |
| T6 | Production lait/œufs | Ajoute au stock cuve | building | — |
| T7 | Usure matériels | +usure/jour | vehicle | — |
| T8 | Entretien auto bâtiments | -0.3 HT + coût € | player, building | `maintenance` |
| T9 | Mensualité prêts | Prélèvement auto | player | `loan_debit` |
| T10 | Salaires employés | Prélèvement auto | player | `salary` |
| T11 | Énergie bâtiments | Prélèvement auto | player | `tax` |
| T12 | Météo | Génération météo J+1 | — | — |
| T13 | Fatigue sol | +fatigue si monoculture | parcel | — |
| T14 | Événements saisonniers | Gel/sécheresse/tempête | — | — |
| T15 | Intérêts épargne | Versement intérêts + maturité | player | `savings_withdraw` |
| T16 | Accumulation fumier | Fumier/lisier quotidien bâtiments | building | — |
| T17 | Alertes ressources | HVC bas, surpopulation, trésorerie | — | — |
| T18 | Variation cours marché | Bruit + offre/demande | — | — |
| T19 | Expiration assurance | Assurance matériel expirée | vehicle | — |
| T20 | Compostage | Avancement compost 14j | compost_batch | — |

---

## 3. MATRICE BOUTON → TECHNIQUE

Pour chaque bouton du jeu, voici la checklist technique complète :

```
□ Endpoint défini (méthode + route + body)
□ X-Idempotency-Key header (si POST mutation)
□ Contrôles frontend (conditions d'activation, tooltip si grisé)
□ Loading state (disabled + spinner pendant appel)
□ Contrôles backend numérotés (ownership, état, solde, HT, stock)
□ SELECT FOR UPDATE (si déduction solde/HT/stock)
□ Transaction atomique (BEGIN...COMMIT)
□ INSERT INTO ledger (si modification solde)
□ Event WebSocket émis (si changement d'état visible)
□ Toast succès (icône + message + données)
□ Toast erreur (message backend exact)
□ Animation header (solde, HT si modifiés)
□ Mise à jour DataTable/widget sans rechargement page
□ ConfirmModal (si action irréversible : abattoir, détruire, vendre)
```

---

## 4. RÉSUMÉ

| Métrique | Valeur |
|----------|--------|
| Total mutations joueur | 93 |
| Total ticks worker | 20 |
| Mutations avec lock (SELECT FOR UPDATE) | 64 |
| Mutations avec ledger | 48 |
| Mutations avec WebSocket | 70 |
| Mutations avec ConfirmModal | 8 |
| Mutations idempotentes par nature (PUT/DELETE) | 12 |
| Mutations nécessitant X-Idempotency-Key | 80 |
