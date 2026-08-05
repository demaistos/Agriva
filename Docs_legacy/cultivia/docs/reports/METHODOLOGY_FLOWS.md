# Cultivia — Méthodologie d'Audit & Design des Flows

> **Ce document est le guide de référence pour tout travail sur les flows du jeu.**
> Il doit être suivi systématiquement pour chaque nouveau flow, chaque modification, et chaque revue.

## 1. Principes fondamentaux

### 1.1 Chaque flow est une boucle complète
Un flow n'est pas juste une action backend. C'est **l'expérience complète** du joueur :
1. **Préconditions** — Que doit posséder/avoir fait le joueur AVANT ?
2. **Interface** — Comment le joueur découvre et déclenche l'action (page, bouton, états, filtres, tooltips)
3. **Validation frontend** — Quels checks côté client avant l'appel API ?
4. **Appel API** — Route, méthode, body, headers
5. **Validation backend** — Idempotency, auth, checks métier
6. **Transaction** — SQL atomique (FOR UPDATE, checks, updates, inserts)
7. **Effets secondaires** — Usure, panne, consommation HVC, ledger, notifications WS
8. **Feedback UI** — Toast, animation header, mise à jour composants, redirect
9. **Postconditions** — Quel est l'état du jeu APRÈS ? Quels nouveaux flows sont débloqués ?

### 1.2 Réalisme SimAgri
Toute action physique respecte la chaîne :
- Véhicule requis (type spécifique, fonctionnel, non en panne)
- Carburant HVC consommé (proportionnel à distance ou surface)
- Usure véhicule augmentée
- Risque de panne (si usure > 80% → 15% chance)
- Distance calculée (haversine entre préfectures)
- Délai de transit (biens pas instantanément disponibles)
- Écriture ledger (toute opération financière tracée)
- Idempotency (toute mutation POST protégée contre double-clic)

### 1.3 Interface complète
Chaque flow doit spécifier :
- **Page** où l'action est accessible
- **Composant déclencheur** (bouton, lien, toggle, inline edit, modal)
- **États du bouton** : actif (condition), disabled (condition + tooltip explicatif)
- **Filtres** disponibles sur la page (si liste/tableau)
- **Colonnes** du tableau (si DataTable)
- **Modales** de confirmation (si action destructive ou coûteuse)
- **Feedback** après action (toast, animation, redirect, mise à jour inline)

## 2. Checklist de validation d'un flow

### 2.1 Complétude
- [ ] `id` unique (F0XX)
- [ ] `name` descriptif en français
- [ ] `sprint` assigné
- [ ] `status` (spec/dev/done/tested/deployed)
- [ ] `trigger` complet (type, label, page, states.active, states.disabled avec tooltips)
- [ ] `chain` complète (toutes les étapes de 1 à 9 ci-dessus)
- [ ] `depends_on` (dépendances macro entre flows)
- [ ] `requires` (micro-dépendances : véhicules, infra, stock, animaux)
- [ ] `tests` (au moins 1 cas nominal + 1 cas d'erreur par condition disabled)
- [ ] `note` (si décision de design non évidente)

### 2.2 Réalisme
- [ ] Si action physique → véhicule + HVC + usure + panne
- [ ] Si achat/vente → transport + distance + délai transit
- [ ] Si mutation financière → ledger
- [ ] Si mutation POST → idempotency
- [ ] Si action quotidienne → check "déjà fait aujourd'hui"

### 2.3 Interface
- [ ] Page identifiée
- [ ] Bouton/déclencheur avec label dynamique
- [ ] Tous les états disabled avec tooltips explicatifs
- [ ] Feedback utilisateur (toast avec message dynamique)
- [ ] Animation header si balance/HT modifiés
- [ ] Redirect si changement de page après action

### 2.4 Cohérence inter-flows
- [ ] Les requires sont satisfaits par d'autres flows (ex: requires vehicle:tractor → F043 permet d'acheter)
- [ ] Les depends_on forment un graphe acyclique
- [ ] Les ticks worker couvrent les effets différés (transit, usure quotidienne, santé, économie)

## 3. Catégories de requires

```
# Véhicules (fonctionnels, non en panne)
vehicle:tractor, vehicle:trailer, vehicle:benne, vehicle:plateau
vehicle:moissonneuse, vehicle:citerne_lait, vehicle:epandeur
vehicle:outil_sol, vehicle:semoir, vehicle:epandeur_engrais
vehicle:pulverisateur, vehicle:presse, vehicle:broyeur
vehicle:rouleau, vehicle:foreuse, vehicle:any

# Carburant
fuel:hvc

# Bâtiments
building:stabulation, building:silo, building:hangar
building:entrepot, building:fosse_fumier

# Infrastructure
infra:salle_traite, infra:cuve_lait, infra:cuve_eau
infra:fosse_fumier, infra:fosse_lisier, infra:aire_chargement

# Stock
stock:aliments, stock:paille, stock:lait, stock:semences
stock:engrais, stock:traitement, stock:recolte
stock:piece_detachee, stock:hvc

# Animaux
animal:any, animal:male, animal:female
animal:gestante, animal:vache_laitiere

# Terrain
parcel, parcel:pre, parcel:foree

# Personnel
employee

# Kit de démarrage
kit:eleveur|polyvalent, kit:cultivateur|polyvalent
```

## 4. Formules de référence

| Action | Coût €/km | HVC L/km | HT/100km | Usure/km | Vitesse | Coût min |
|--------|-----------|----------|----------|----------|---------|----------|
| Transport bétaillère | 0.50 | 0.15 | 1.0 | 0.02% | 50 km/h | 20€ |
| Transport benne/plateau | 0.30 | 0.20 | 1.0 | 0.02% | 50 km/h | 20€ |
| Transport citerne lait | 0.30 | 0.20 | 1.0 | 0.02% | 50 km/h | 20€ |
| Livraison concessionnaire | 0.80 | — | — | — | 60 km/h | 20€ |
| Travail sol (par ha) | — | 8-15L | 0.5-2.0 | 0.3-0.8% | — | — |
| Récolte (par ha) | — | 20L | 1.0 | 0.5% | — | — |
| Épandage (par ha) | — | 5L | 0.3 | 0.2% | — | — |

> **Coût minimum 20€** sur tout transport, même à 0km. Exception : produits animaux (lait, œufs, laine) = collecte à la ferme **5€ minimum** (le Marché Central vient chercher).

## 5. Process pour les futures demandes

### 5.1 Ajout d'un nouveau flow
1. Vérifier la checklist §2
2. Identifier les requires en remontant la chaîne (de quoi ai-je besoin ?)
3. Identifier les flows qui en dépendent (qui est débloqué après ?)
4. Ajouter au registry YAML
5. Ajouter au dependency_graph
6. Mettre à jour les stats
7. Sync vers flow-editor
8. Mettre à jour les docs impactées (plan agile, specs phase, SDD si nouveau champ DB)

### 5.2 Revue d'une boucle de gameplay
1. Lister toutes les étapes de la boucle (du début à la fin)
2. Pour chaque étape : appliquer la checklist §2
3. Comparer avec SimAgri (docs/00-reference/regle sim.txt)
4. Identifier les manques (flows absents, requires manquants, interface incomplète)
5. Produire un rapport d'audit dans docs/reports/
6. Appliquer les corrections
7. Vérifier la cohérence globale (pas de dépendances cassées)

### 5.3 Lancement d'agents spécialisés
```bash
# Template de commande pour lancer un agent expert
kiro-cli chat --trust-all-tools --no-interactive "Tu es l'expert [DOMAINE].
Lis d'abord docs/reports/METHODOLOGY_FLOWS.md pour comprendre la méthodologie.
Puis analyse [BOUCLE] en suivant la checklist.
Sources : docs/00-reference/regle sim.txt + docs/03-specs/ACTION_FLOW_REGISTRY.yaml
Produis un rapport dans docs/reports/AUDIT_[DOMAINE].md
Applique les corrections dans le registry et les docs.
Sync le registry après modification."
```


---

## 6. Leçons apprises (2026-04-06)

### 6.1 Toujours vérifier la matrice espèces

Avant d'implémenter un flow lié aux animaux, consulter `docs/03-specs/MATRICE_ESPECES.md`. Le véhicule de transport, le bâtiment, la production et la ration varient par espèce. Un flow générique qui ne distingue pas les espèces est un bug.

### 6.2 Seeds = contrat avec les flows

Chaque `requires: vehicle:X` ou `requires: building:Y` dans le registry DOIT avoir un type correspondant dans les seeds SQL. Si le seed n'existe pas, le joueur ne pourra jamais satisfaire le prérequis.

Vérification systématique : lister les requires du registry, croiser avec les catégories des seeds.

### 6.3 Construire la matrice AVANT de coder

Pour chaque boucle de gameplay, construire d'abord la matrice complète (quelles actions, quels prérequis, quels véhicules, quels bâtiments) en comparant avec SimAgri. Puis seulement créer les flows et les seeds.

### 6.4 Itérer, pas foncer

"Le vite est l'ennemi du bien." Pour chaque feature :
1. Poser les bonnes questions en équipe (discussion simulée)
2. Vérifier dans SimAgri ce qui existe
3. Construire la matrice
4. Créer les flows
5. Vérifier les seeds
6. Relire et corriger

### 6.5 Boucles de gameplay = unité de travail

Ne pas raisonner par flow individuel mais par boucle complète. Une boucle est complète quand le joueur peut faire le cycle entier sans blocage (acheter → nourrir → produire → vendre).

### 6.6 Le flow-editor est l'outil de vérification

Utiliser le mode "Boucles" du flow-editor pour vérifier visuellement que chaque boucle est complète. La recherche globale permet de trouver rapidement un flow par n'importe quel critère.
