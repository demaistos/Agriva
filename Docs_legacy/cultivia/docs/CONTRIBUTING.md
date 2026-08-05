# Cultivia — Guide de Contribution & Bonnes Pratiques

> Tout ce qu'un développeur (humain ou IA) doit savoir avant de toucher au projet.

---

## 1. Lire avant de coder

| Quoi | Fichier | Pourquoi |
|------|---------|----------|
| Index complet | `docs/INDEX.md` | Vue d'ensemble de toute la doc |
| Boucles gameplay | `docs/03-specs/BOUCLES_GAMEPLAY.md` | Comprendre le parcours joueur |
| Registry | `docs/03-specs/ACTION_FLOW_REGISTRY.yaml` | Source de vérité des 199 flows (138 MVP) |
| Matrice espèces | `docs/03-specs/MATRICE_ESPECES.md` | Spécificités par espèce animale |
| Méthodologie | `docs/reports/METHODOLOGY_FLOWS.md` | Checklist d'audit des flows |
| SDD | `docs/02-architecture/06_SDD_COMPLEMENTS.md` | Codes erreur, mapping tables, DoD |

---

## 2. Bonnes pratiques — Leçons apprises

### 2.1 🐄 Transport par espèce — NE PAS OUBLIER

Le véhicule de transport dépend de l'espèce. C'est la source d'erreur #1.

| Espèce | Véhicule | Tracteur requis ? |
|--------|----------|-------------------|
| Bovins, ovins, caprins, porcins, bisons, daims | Bétaillère | Oui (tracteur + bétaillère) |
| Volailles, pintades, lapins, oies, canards | Utilitaire | Non (utilitaire = motorisé) |
| Chevaux | Van | Oui (utilitaire + van) |

**Chaque flow qui déplace un animal (F002, F025, F029, F080, F081) DOIT vérifier l'espèce et exiger le bon véhicule.**

### 2.2 🏗️ Bâtiments spécifiques par production

Chaque production animale a ses bâtiments prérequis :

| Production | Bâtiments requis |
|-----------|-----------------|
| Lait (bovins/caprins/ovins) | Salle de traite + Cuve à lait |
| Œufs (volailles/pintades) | Salle de conditionnement + Pièce stockage œufs |
| Laine (ovins) | Aucun bâtiment spécifique |
| Viande (tous) | Aucun (abattoir = externe) |

### 2.3 🔄 Itérer boucle par boucle

Quand on ajoute ou vérifie une feature :
1. Lister TOUTES les actions SimAgri pour cette boucle (`docs/00-reference/regle sim.txt`)
2. Comparer avec nos flows dans le registry
3. Identifier les manques
4. Construire la **matrice complète** AVANT de coder (transport, bâtiment, production, ration, reproduction)
5. Ajouter les flows manquants
6. Vérifier que chaque véhicule/bâtiment référencé existe dans les seeds

### 2.4 🌱 Seeds = contrat

**Chaque type de véhicule ou bâtiment référencé dans un flow DOIT exister dans les seeds.**

Vérification :
```bash
# Lister les véhicules référencés dans les flows
grep "vehicle:" docs/03-specs/ACTION_FLOW_REGISTRY.yaml | sort -u

# Vérifier qu'ils existent dans le seed
grep "category" scripts/seed/05_vehicle_types.sql | sort -u
```

Si un flow référence `vehicle:utilitaire` et que le seed n'a pas de catégorie `utilitaire`, c'est un bug.

### 2.5 ✅ Checklist avant chaque flow

Avant d'implémenter un flow, vérifier :

- [ ] Le flow existe dans `ACTION_FLOW_REGISTRY.yaml`
- [ ] Il a : trigger, states, disabled+tooltips, chain, tests, requires, depends_on
- [ ] Chaque `requires` a un seed correspondant (véhicule, bâtiment)
- [ ] Si mutation POST → idempotency key
- [ ] Si déduction solde/stock → SELECT FOR UPDATE
- [ ] Si action physique → véhicule + HVC + usure + risque panne + **multi-voyages (quantité ÷ capacité véhicule)**
- [ ] Si achat/vente → transport (distance haversine) + délai transit
- [ ] Si modification solde → INSERT INTO transaction (ledger)
- [ ] Si animal → vérifier MATRICE_ESPECES.md (bon véhicule, bon bâtiment)
- [ ] Toast feedback avec message dynamique
- [ ] Récapitulatif coût total AVANT action (€ + HT + HVC + usure + solde/HT/HVC après)
- [ ] Animation header si balance/HT modifiés
- [ ] WS events émis

### 2.6 🏗️ Cycle de développement par feature

```
1. Migration SQL (prisma/migrations/)
2. Service backend (src/server/services/)
3. Route API (src/server/routes/)
4. Tests unitaires + intégration
5. Store Pinia (src/client/stores/)
6. Composant Vue (src/client/pages/)
7. Worker tick (si applicable) (src/worker/ticks/)
8. Review (checklist §2.5)
9. Sync registry → flow-editor
10. Compte rendu dans docs/reports/
```

### 2.7 🎯 Discussion d'équipe avant chaque décision

Avant toute décision technique, simuler une discussion :
```
💬 Backend: "Je propose X"
💬 DBA: "Attention, sans index ça sera lent"
💬 QA: "Et si double-click? Idempotency key"
💬 Frontend: "J'ai besoin du champ Z dans la réponse"
💬 GameDesign: "SimAgri fait Y, on doit être cohérent"
✅ Décision: On fait X avec index, idempotency, champ Z
```

### 2.8 📐 9 facteurs de rendement cultures

Le rendement d'une récolte dépend de 9 facteurs. Ne jamais en oublier un :
1. Base rendement de la culture
2. Qualité semence (certified +10%)
3. Qualité sol (fertilité, structure, oligo)
4. Engrais apportés vs besoins
5. Traitements effectués (fongicide, herbicide, insecticide)
6. Irrigation (si sécheresse)
7. Météo de la saison
8. Roulage (+3-5%)
9. Fatigue sol (rotation +5, monoculture +15)

### 2.9 🔒 Sécurité — toujours

- SQL paramétré ($1,$2), JAMAIS de concaténation
- JWT 15min + refresh 7j httpOnly, bcrypt 12
- SELECT FOR UPDATE sur toute déduction
- Ownership check sur chaque endpoint
- Rate limit 100/min IP, 30/min user
- Pas de PII dans les logs

### 2.10 📝 Nommage in-game

| Terme Cultivia | PAS |
|---------------|-----|
| HT (Heures de Travail) | PA |
| Marché Central | Coopérative |
| Licence Pro | SimPass |
| Chambre Agricole | CESA |
| Lycée Agricole | CFSA |
| GénétiLab | — |
| Le Domaine | — |

---

## 3. Outils

### Flow Editor
```bash
cd tools/flow-editor && npm run dev
# → http://localhost:5555
# 3 modes : Macro (vue globale) / Parcours (graphe par boucle) / Boucles (narratif + recherche)
```

### Sync registry → flow-editor
```bash
cp docs/03-specs/ACTION_FLOW_REGISTRY.yaml tools/flow-editor/public/registry.yaml
# Ou automatiquement via npm run build dans flow-editor
```

### Seeds
```bash
# Ordre d'exécution :
# 01_server → 02_regions → 03_prefectures → 03bis_climate → 04_buildings → 05_vehicles
# → 06_crops → 07_yields → 08_nutrients → 09_breeds → 10_rations → 11_prices → 12_kits
```

---

## 4. Chiffres de référence

| Métrique | Valeur |
|----------|--------|
| Flows | 199 (138 MVP + 61 post-MVP) |
| Boucles gameplay | 8 |
| Tables SQL | 143 |
| Codes erreur | ~140 |
| Types véhicules | 90 |
| Types bâtiments | 30 |
| Cultures | 24 |
| Espèces animales | 16 |
| Sprints E2E | 12 |
| Seeds SQL | 14 |
| Prompts agents | 13 |
| Constantes : HT/jour | 40 (+4/employé, max 3) |
| Constantes : Solde initial | 100 000€ |
| Constantes : Plancher | -30 000€ |
| Constantes : Prêt max | 150 000€ |
| Constantes : 1 an | 84 jours réels |
