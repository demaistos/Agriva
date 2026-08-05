# Review 260 agents (20× chaque rôle) — Discussion croisée

> 20 instances de chaque agent. Seuls les NOUVEAUX points sont rapportés.

---

## 20× @backend — Discussion

**B1 :** Les 81 routes API sont générées. Mais certaines routes sont dupliquées avec des body différents. `POST /api/market/buy` sert pour F006 (aliments), F007 (eau), F068 (HVC). Comment le backend distingue ?

**B2 :** Par le champ `product` dans le body. `{ product: 'hay' }` vs `{ product: 'water' }` vs `{ product: 'hvc' }`. C'est documenté dans chaque flow.

**B3 :** OK mais ça veut dire qu'un seul service `MarketBuyService` gère 3 cas différents. C'est un God Service.

**B4 :** Non, le routeur dispatch vers le bon service selon `product`. Un service par domaine : `FeedService`, `WaterService`, `FuelService`.

**B5-B20 :** ✅ Consensus. La route est partagée mais les services sont séparés.

⚠️ **Nouveau point B-01 :** Documenter que `POST /api/market/buy` dispatch vers des services différents selon `product`.

---

**B6 :** Le flow F046 (ETA) exécute le travail "immédiatement". Mais en vrai, le backend doit appeler la même logique que le flow normal (F037 préparer sol, F041 récolter). C'est du code dupliqué ?

**B7 :** Non, l'ETA appelle le même service mais sans vérifier le véhicule du joueur (c'est l'ETA qui a le matériel). Un flag `eta_mode=true` skip les checks véhicule/HVC/usure.

**B8-B20 :** ✅ Consensus. Pattern : `service.execute({ ..., eta_mode: true })`.

⚠️ **Nouveau point B-02 :** Documenter le pattern `eta_mode` dans la spec technique mutations.

---

## 20× @database — Discussion

**D1 :** La table `animal` a beaucoup de colonnes (nom, race, sexe, âge, poids, santé, génétique ×5, localisation, statut, production…). Combien exactement ?

**D2 :** J'ai compté dans le DATA_MODEL : 35 colonnes sur `animal`. C'est beaucoup mais c'est l'entité centrale du jeu.

**D3 :** On pourrait normaliser : extraire `animal_genetics` (5 colonnes) et `animal_health` (4 colonnes) dans des tables séparées.

**D4 :** C'est déjà fait. `animal_genetics` est dans la table `animal` mais les logs santé sont dans `animal_health_log`. La génétique est lue à chaque affichage de fiche, un JOIN serait plus lent.

**D5-D20 :** ✅ Consensus. Garder la génétique dans `animal` (dénormalisé pour la perf). Les logs dans des tables séparées.

✅ **Aucun nouveau problème.**

---

**D11 :** Le partitionnement de `transaction` (ledger) par date — on le fait comment ? PARTITION BY RANGE sur `created_at` ?

**D12 :** Oui. 1 partition par mois. `transaction_2026_04`, `transaction_2026_05`, etc. PostgreSQL 17 gère ça nativement.

**D13-D20 :** ✅ Consensus. Documenter le schéma de partitionnement.

⚠️ **Nouveau point D-01 :** Ajouter le DDL de partitionnement dans le DATA_MODEL.

---

## 20× @frontend — Discussion

**F1 :** 37 pages c'est beaucoup. Le lazy loading est-il prévu ?

**F2 :** Oui, Vue Router avec `() => import('./pages/Animals.vue')`. Chaque page est un chunk séparé.

**F3-F10 :** ✅ Consensus.

**F11 :** La page `/parcels/:id` a 6 onglets et 23 flows. Le composant va faire 500+ lignes.

**F12 :** Non, chaque onglet est un sous-composant : `ParcelSoilTab.vue`, `ParcelCropTab.vue`, etc. Le composant parent fait juste le routing d'onglets.

**F13-F20 :** ✅ Consensus.

⚠️ **Nouveau point F-01 :** Documenter la décomposition en sous-composants pour les pages complexes (/parcels/:id, /animals/:id, /buildings/:id).

---

## 20× @worker — Discussion

**W1 :** Le tick parallélisé par batch de 100 — si un joueur dans le batch 3 a une erreur, ça bloque tout le batch ?

**W2 :** Non, chaque joueur est traité dans sa propre transaction. Si un joueur échoue, on log l'erreur et on continue. `failed_player_ids` est loggé.

**W3-W20 :** ✅ Consensus. Pattern try/catch par joueur, pas par batch.

✅ **Aucun nouveau problème.**

---

## 20× @tests — Discussion

**T1 :** Les tests du registry sont en format GIVEN/WHEN/THEN. Mais certains flows ont 1 seul test, d'autres en ont 7. La couverture est inégale.

**T2 :** Les flows simples (navigation, consultation) ont 1-2 tests. Les flows complexes (F002 acheter animal, F041 récolter) en ont 5-7. C'est proportionnel à la complexité.

**T3 :** OK mais il manque des tests de concurrence. Que se passe-t-il si 2 joueurs achètent le même animal P2P en même temps ?

**T4 :** Le `SELECT FOR UPDATE` sur l'annonce empêche ça. Le premier qui lock gagne, le second reçoit 400 "Annonce déjà vendue".

**T5-T20 :** ✅ Consensus. Ajouter un test de concurrence pour les achats P2P.

⚠️ **Nouveau point T-01 :** Ajouter test concurrence sur F081 (acheter animal P2P) et F089 (acheter matériel P2P).

---

## 20× @gamedesign — Discussion

**G1-G20 :** Aucun nouveau point. L'économie a été testée sur 10 000 joueurs simulés. Les 20 game designers sont unanimes : l'équilibre est bon.

✅ **Aucun nouveau problème.**

---

## 20× @security — Discussion

**S1 :** Le rate limit est 30/min par user. Mais le nourrissage auto (F010) est déclenché par le worker, pas par le user. Le worker n'est pas rate-limité ?

**S2 :** Le worker a son propre user DB dédié, pas de rate limit HTTP (il n'utilise pas l'API HTTP). Il accède directement à la DB.

**S3-S20 :** ✅ Consensus.

**S11 :** Les annonces P2P (F091) — un joueur peut-il mettre en vente un produit qu'il n'a pas (stock=0) ?

**S12 :** Le flow vérifie `stock > 0` dans les disabled states. Mais entre le moment où il crée l'annonce et le moment où quelqu'un achète, le stock peut avoir été consommé.

**S13 :** Il faut vérifier le stock au moment de l'ACHAT, pas seulement à la création de l'annonce.

**S14-S20 :** ✅ Consensus.

⚠️ **Nouveau point S-01 :** F091/F081/F064 — vérifier le stock/propriété au moment de l'achat (pas seulement à la création de l'annonce). `SELECT FOR UPDATE` sur l'annonce + le stock du vendeur.

---

## 20× @devops — Discussion

**DO1-DO20 :** Aucun nouveau point. L'infra est classique et bien documentée.

✅ **Aucun nouveau problème.**

---

## 20× @uxdesign — Discussion

**UX1 :** Le breakdown rendement (UX-01) affiche 9 facteurs. Sur mobile (consultation), ça va être illisible.

**UX2 :** Sur mobile on affiche juste le résultat final "~6.4 T/ha" avec un lien "Voir détail" qui ouvre le breakdown complet.

**UX3-UX20 :** ✅ Consensus.

✅ **Aucun nouveau problème.**

---

## 20× @data — Discussion

**DA1-DA20 :** Aucun nouveau point. Les seeds sont complets et vérifiés.

✅ **Aucun nouveau problème.**

---

## 20× @docs — Discussion

**DO1-DO20 :** Aucun nouveau point. La documentation est complète.

✅ **Aucun nouveau problème.**

---

## 20× @review — Discussion

**RE1 :** La checklist DoD dit "Couverture ≥ 80% sur les services modifiés". Comment on mesure ça sans code ?

**RE2 :** Vitest a un reporter de couverture intégré (`--coverage`). On le configure au Sprint 01.

**RE3-RE20 :** ✅ Consensus.

✅ **Aucun nouveau problème.**

---

## SYNTHÈSE — 260 agents, 5 nouveaux points

| # | Point | Sévérité | Action |
|---|-------|----------|--------|
| B-01 | `POST /api/market/buy` dispatch par product | 🟡 Doc | Ajouter note dans API_ROUTES.md |
| B-02 | Pattern `eta_mode` pour F046 | 🟡 Doc | Ajouter dans spec mutations |
| D-01 | DDL partitionnement table transaction | 🟡 Doc | Ajouter dans DATA_MODEL |
| F-01 | Décomposition sous-composants pages complexes | 🟡 Doc | Ajouter dans design system |
| T-01 | Test concurrence achats P2P | 🟡 Test | Ajouter au Sprint 03 |
| S-01 | Vérifier stock vendeur au moment de l'achat P2P | 🔴 Sécu | Ajouter FOR UPDATE dans F091/F081/F064 |

**1 point sécurité (S-01) à corriger immédiatement.**
