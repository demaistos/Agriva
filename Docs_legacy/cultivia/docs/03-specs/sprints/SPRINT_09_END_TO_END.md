# Sprint 09 — Dashboard complet + Finances + Messagerie — Spec End-to-End

> Prérequis : Sprint 08. Toutes les données existent pour alimenter le dashboard.
> Ce sprint assemble : dashboard 10 widgets, relevé bancaire, épargne, prêts, messagerie, paramètres.

---

## Flux 1 : Dashboard complet (`/dashboard`)

### → API unique

```http
GET /api/dashboard
```

### → Backend — Agrégation en 1 requête (ou parallèle)

```sql
-- Finances
SELECT balance, 
  balance - LAG(balance) OVER (ORDER BY date) as yesterday_delta
FROM ledger_daily_snapshot WHERE player_id=$1 ORDER BY date DESC LIMIT 30;

-- HT
SELECT ht_today, ht_max FROM player WHERE id=$1;

-- Alertes élevage
SELECT COUNT(*) FILTER (WHERE last_fed_at < CURRENT_DATE) as not_fed,
       COUNT(*) FILTER (WHERE is_sick) as sick,
       COUNT(*) FILTER (WHERE location_type='arrival') as in_arrival,
       COUNT(*) as total
FROM animal WHERE farm_id=$1 AND life_stage!='dead';

-- Alertes parcelles
SELECT COUNT(*) FILTER (WHERE status='ready_harvest') as to_harvest,
       COUNT(*) FILTER (WHERE status='fallow') as not_worked,
       COUNT(*) as total, SUM(size_ha) as total_ha
FROM parcel WHERE farm_id=$1;

-- Bâtiments
SELECT COUNT(*) as total,
       AVG(c.animal_count::float / NULLIF(c.max_capacity,0) * 100) as avg_capacity
FROM building b LEFT JOIN building_animal_capacity c ON b.id=c.building_id
WHERE b.farm_id=$1;

-- Matériels
SELECT COUNT(*) as total,
       COUNT(*) FILTER (WHERE is_broken) as broken,
       COUNT(*) FILTER (WHERE NOT is_sheltered) as unsheltered
FROM vehicle WHERE farm_id=$1;

-- Météo
SELECT * FROM weather WHERE zone_id=$zone AND date >= CURRENT_DATE ORDER BY date LIMIT 3;

-- Notifications
SELECT * FROM notification WHERE player_id=$1 ORDER BY created_at DESC LIMIT 10;

-- Actualités
SELECT * FROM news ORDER BY created_at DESC LIMIT 5;
```

### Rendu — Chaque widget est un composant Vue

| Widget | Composant | Données | Boutons |
|--------|-----------|---------|---------|
| Bienvenue | `<WelcomeBanner>` | username, prefecture, date, saison | — |
| Finances | `<FinanceWidget>` | solde, delta hier, delta mois | [Relevé bancaire] |
| HT | `<HtWidget>` | ht_today/ht_max, barre, détail | [Détail] → modale |
| Alertes | `<AlertWidget>` | not_fed, sick, to_harvest, broken | [Voir tout] → `/notifications` |
| Graphique solde | `<BalanceChart>` | 30 points (date, balance) | — |
| Élevage | `<LivestockWidget>` | total, not_fed, sick, in_arrival | [Voir animaux], [Placer auto] |
| Parcelles | `<ParcelsWidget>` | total, ha, to_harvest, not_worked | [Voir parcelles] |
| Bâtiments | `<BuildingsWidget>` | total, avg_capacity | [Voir bâtiments] |
| Matériels | `<EquipmentWidget>` | total, broken, unsheltered, fuel% | [Voir matériels] |
| Notifications | `<NotifWidget>` | 10 dernières | [Tout marquer lu], [Voir toutes] |
| Actualités | `<NewsWidget>` | 5 dernières | [Voir toutes] |
| Guide débutant | `<GuideWidget>` | visible si ancienneté < 84j | [Guide], [Masquer] |

Chaque bouton de widget = navigation simple (pas de mutation, 0 HT).

**Exception — "Placer auto" :** `POST /api/animals/auto-place` (mutation, voir Sprint 06).

**Exception — "Tout marquer lu" :** `POST /api/notifications/read-all` (mutation légère, pas de ledger).

---

## Flux 2 : Relevé bancaire (`/finances/ledger`)

### Écran

```
┌─────────────────────────────────────────────────────────────────┐
│ 💳 Relevé bancaire [Solde: 88 200 €]                            │
│ Filtres: [Catégorie ▼] [Du __/__] [Au __/__] [📥 Exporter CSV] │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Évolution du solde (graphique 30j)                            │
├─────────────────────────────────────────────────────────────────┤
│ Date       | Catégorie  | Libellé                | Débit|Crédit │
│ 7 Avr 14:30| 🟢 sale    | Vente 32.4L lait       |      |+12.31│
│ 7 Avr 10:00| 🔴 purchase| Achat 2t Foin          |-160  |      │
│ 7 Avr 08:00| 🔴 health  | Soin Marguerite        |-100  |      │
│ 6 Avr 03:00| 🔵 salary  | Salaire Jean           |-600  |      │
│ 5 Avr 12:00| 🟢 sale    | Vente abattoir Taureau |      |+2749 │
├─────────────────────────────────────────────────────────────────┤
│ [← Précédent] Page 1/8 [Suivant →]                              │
└─────────────────────────────────────────────────────────────────┘
```

### → API

```http
GET /api/finances/ledger?category=all&from=2026-03-01&to=2026-04-07&page=1&limit=20
```

### Bouton "Exporter CSV"

```http
GET /api/finances/ledger/export?category=all&from=...&to=...
Content-Type: text/csv
```

Téléchargement direct. Pas de mutation.

---

## Flux 3 : Souscrire une épargne

### Page `/finances/savings`

```
┌─────────────────────────────────────────────────────────────────┐
│ 💰 Mes épargnes                                                  │
│ [Souscrire une épargne]                                         │
├─────────────────────────────────────────────────────────────────┤
│ (aucune épargne en cours)                                        │
└─────────────────────────────────────────────────────────────────┘
```

### Clic "Souscrire" → Modale

```
┌─────────────────────────────────────────────┐
│ 💰 Souscrire une épargne                     │
│                                              │
│ Montant : [____10 000____] €                 │
│           (min 1 000€, max: solde)           │
│                                              │
│ Durée : ○ 1 mois (7j) — 1%                  │
│         ● 3 mois (21j) — 3%                  │
│         ○ 6 mois (42j) — 6%                  │
│                                              │
│ Simulation :                                 │
│ Capital : 10 000 €                           │
│ Intérêts : 300 €                             │
│ Total à l'échéance : 10 300 €                │
│ Date échéance : 28 Avril An 2                │
│                                              │
│ ⚠️ Retrait anticipé : 0% intérêts            │
│                                              │
│ [Annuler]              [Souscrire]           │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= montant` ET `montant >= 1000` ET durée choisie |
| 🔘 Grisé "Solde insuffisant" | `balance < montant` |
| 🔘 Grisé "Minimum 1 000€" | `montant < 1000` |

### → API + Backend

```http
POST /api/finances/savings
Headers: X-Idempotency-Key: {uuid}
Body: { "amount": 10000, "duration_months": 3 }
```

```
1-5. Vérifs standard + FOR UPDATE player
6. Calculer taux : 1 mois=1%, 3 mois=3%, 6 mois=6%
7. Calculer échéance : NOW() + (duration × 7 jours)
8. UPDATE player SET balance -= 10000
9. INSERT INTO savings (player_id, amount, rate, maturity_date, status='active')
10. INSERT INTO ledger ('savings_deposit', 'Épargne 10000€ à 3%', -10000)
11. COMMIT + WS
```

### Tick — Échéance épargne

```
SELECT * FROM savings WHERE maturity_date <= NOW() AND status='active';
Pour chaque :
  interests = amount × rate
  UPDATE player SET balance += amount + interests
  UPDATE savings SET status='matured'
  INSERT INTO ledger ('savings_withdraw', 'Épargne arrivée + 300€ intérêts', +10300)
  Notification "💰 Votre épargne de 10 000€ est arrivée à échéance ! +300€ d'intérêts"
```

---

## Flux 4 : Demander un prêt

### Page `/finances/loans`

Même spec que UX_PHASE0_1 §6 (déjà détaillé). Résumé :
- Slider montant (max 150k€ - prêts en cours)
- Durée : 6/12/24/36/48 mois
- Taux + mensualité calculés temps réel
- `POST /api/finances/loans` → FOR UPDATE → balance += montant → ledger
- Tick mensuel : prélèvement auto mensualité

---

## Flux 5 : Messagerie

### Page `/messages`

```
┌─────────────────────────────────────────────────────────────────┐
│ ✉️ Messagerie [Nouveau message]                                  │
│ [📥 Reçus (3)] [📤 Envoyés]                                     │
├─────────────────────────────────────────────────────────────────┤
│ ☐ | Sujet                    | De        | Date       | Lu     │
│ ☐ | Bienvenue sur Cultivia ! | SYSTÈME   | 1 Avr      | ✅     │
│ ☐ | Proposition contrat      | Fermier42 | 6 Avr      | ❌     │
│ ☐ | Décision CAR : Prix blé  | CULTIVIA  | 7 Avr      | ❌     │
├─────────────────────────────────────────────────────────────────┤
│ [Supprimer sélection]                                            │
└─────────────────────────────────────────────────────────────────┘
```

### Clic sur un message → Lecture

```
┌─────────────────────────────────────────────────────────────────┐
│ ← Retour | Proposition contrat                                   │
│ De : Fermier42 | 6 Avril An 2, 18:30                            │
├─────────────────────────────────────────────────────────────────┤
│ Bonjour, je vous propose un contrat de vente de 5t de blé       │
│ à 95€/t. Intéressé ?                                            │
├─────────────────────────────────────────────────────────────────┤
│ [Répondre] [Supprimer] [Signaler]                                │
└─────────────────────────────────────────────────────────────────┘
```

### "Nouveau message" → Modale

```
┌─────────────────────────────────────────────┐
│ ✉️ Nouveau message                           │
│                                              │
│ Destinataire : [____Fermier42____]           │
│                (autocomplete joueurs)        │
│ Sujet : [____________________]               │
│ Message :                                    │
│ ┌──────────────────────────────────────────┐│
│ │                                          ││
│ │                                          ││
│ └──────────────────────────────────────────┘│
│                                              │
│ [Annuler]              [Envoyer ✉️]          │
└─────────────────────────────────────────────┘
```

**Bouton "Envoyer" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Destinataire valide + sujet non vide + message non vide |
| 🔘 Grisé "Joueur introuvable" | Destinataire pas dans la DB |
| 🔘 Grisé "Sujet requis" | Sujet vide |
| 🔘 Grisé "Message requis" | Corps vide |

### → API

```http
POST /api/messages
Body: { "to_player_id": "{uuid}", "subject": "...", "body": "..." }
```

Pas de coût HT ni €. Rate limit : 10 messages/heure.

WS → notification au destinataire : "✉️ Nouveau message de {pseudo}".

---

## Flux 6 : Paramètres (`/settings`)

4 onglets, chacun = `PUT /api/player/preferences` :

| Onglet | Champs | Type |
|--------|--------|------|
| Profil | Email (modifiable), Mot de passe (ancien+nouveau+confirm) | Formulaire |
| Notifications | Toggle par type (animaux, parcelles, commerce, météo, messages, système) | Toggles |
| Affichage | Mode sol (simple/expert), Thème (clair/sombre) | Toggles |
| Confidentialité | Profil public (oui/non), Disponibilités visibles (oui/non) | Toggles |

Chaque toggle = `PUT /api/player/preferences { key: value }` immédiat (pas de bouton sauvegarder).

---

## Dépendances + Tests

```
Sprint 08 → Sprint 09
  ├── Tables : savings, news, notification (enrichie), ledger_daily_snapshot
  ├── Services : DashboardService, SavingsService, MessageService, PreferenceService
  ├── Routes : GET /dashboard, GET/POST /finances/*, GET/POST /messages, PUT /player/preferences
  ├── Pages : /dashboard (complet), /finances/ledger, /savings, /loans, /messages, /settings
  └── Composants : 12 widgets dashboard, BalanceChart, LedgerTable, SavingsModal, LoanSimulator, MessageComposer
```
