# ADR-006 : Toute action déclenche la cascade complète de ses effets

> Date : 2026-08-04
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Impacte : l'architecture du moteur d'action, tous les GDD, le moteur de ticks

## Contexte

Le joueur ne fait rien « dans le vide ». Quand il laboure une parcelle, il ne consomme pas juste du temps : il use un tracteur et une charrue, il consomme du carburant, il fatigue un salarié, il modifie l'état du sol, il réduit la durée de vie des pièces d'usure. Chaque action est un nœud dans un réseau de conséquences.

**Principe fondamental** : quand le système exécute une action, il doit propager **toutes** les conséquences sur **toutes** les ressources impliquées. Pas de raccourci, pas d'effet oublié.

## Décision

### Règle absolue

```
TOUTE action qui engage une ressource (matériel, temps, intrant, animal, bâtiment)
DOIT produire TOUS les effets de bord sur TOUTES les ressources impliquées.

Aucune action ne peut avoir un coût partiel.
```

### Modèle d'exécution : tout est résolu INSTANTANÉMENT au clic

La cascade d'effets n'est pas progressive — elle est atomique et immédiate :

```
Joueur clique "Labourer 30 ha" :
  → EN UNE TRANSACTION, instantanément :
    1. Budget heures : −30,6 h
    2. Réservoir tracteur : −1 230 L de GNR
    3. Compteur tracteur : +30,6 h
    4. Compteur charrue (socs) : +30,6 h
    5. Parcelle : état → labourée, structure → bonne
    6. Trésorerie : −1 169 € (carburant)
    7. Alerte si socs < 50 h restantes
  → FAIT. La parcelle est labourée. Le joueur peut enchaîner.
```

Il n'y a pas de "chantier en cours" ni de progression partielle. L'action est soit faite, soit impossible (budget insuffisant).

### Matrice des effets — Actions de parcelle

| Action | Temps | Carburant | Usure tracteur | Usure outil | Sol | Intrant | Stock |
|--------|:-----:|:---------:|:--------------:|:-----------:|:---:|:-------:|:-----:|
| Labourer | ✅ | ✅ | ✅ | ✅ charrue | ✅ structure | | |
| Semer | ✅ | ✅ | ✅ | ✅ semoir | | ✅ semences (−stock) | |
| Fertiliser (épandeur) | ✅ | ✅ | ✅ | ✅ épandeur | ✅ NPK | ✅ engrais (−stock) | |
| Traiter (pulvé) | ✅ | ✅ | ✅ | ✅ pulvérisateur | | ✅ phyto (−stock) | |
| Récolter | ✅ | ✅ | ✅ | ✅ moissonneuse | ✅ résidus | | ✅ grain (+stock) |
| Transporter | ✅ | ✅ | ✅ | ✅ remorque | | | ✅ (−stock départ, +stock arrivée) |
| Irriguer (pivot) | ✅ | | | ✅ pivot | ✅ eau | ✅ eau (−réserve) | |
| Broyer paille | ✅ | ✅ | ✅ | ✅ broyeur | ✅ MO | | |

### Matrice des effets — Actions d'élevage

| Action | Temps | Carburant | Usure tracteur | Usure outil | Stock | Animal | Bâtiment |
|--------|:-----:|:---------:|:--------------:|:-----------:|:-----:|:------:|:--------:|
| Nourrir (mélangeuse) | ✅ | ✅ | ✅ | ✅ mélangeuse | ✅ aliment (−) | ✅ ration | |
| Nourrir (manuel) | ✅ | | | | ✅ aliment (−) | ✅ ration | |
| Traire | ✅ | | | ✅ salle de traite | | ✅ production | ✅ tank (+lait) |
| Pailler | ✅ | ✅ | ✅ | ✅ pailleuse | ✅ paille (−) | ✅ confort | ✅ litière |
| Curer fumier | ✅ | ✅ | ✅ | ✅ godet | | | ✅ fosse (+fumier) |
| Soigner | ✅ | | | | ✅ médicament (−) | ✅ santé | |
| Inséminer | ✅ | | | | ✅ dose (−) | ✅ gestation | |
| Déplacer (bétaillère) | ✅ | ✅ | ✅ | ✅ bétaillère | | ✅ localisation | |

### Matrice des effets — Actions de transformation

| Action | Temps | Énergie | Usure équipement | Stock entrant | Stock sortant | Bâtiment |
|--------|:-----:|:-------:|:----------------:|:-------------:|:-------------:|:--------:|
| Transformer (fromagerie) | ✅ | ✅ élec/gaz | ✅ cuve, presse | ✅ lait (−) | ✅ fromage (+) | ✅ hygiène |
| Transformer (méthanisation) | ✅ | | ✅ digesteur | ✅ effluents (−) | ✅ biogaz (+), digestat (+) | ✅ entretien |
| Conditionner | ✅ | ✅ | ✅ machine | ✅ produit brut (−) | ✅ produit conditionné (+) | |

## Détail du calcul de chaque effet

### 1. Temps de travail (ADR-004)

```
durée = surface / débit_de_chantier
débit = largeur_m × vitesse_km/h × 0.1 × rendement_machine × f_conditions
```

Consomme `durée` heures du pool disponible (exploitant ou salarié affecté).

### 2. Carburant

```
carburant_litres = puissance_CV × consommation_spécifique × durée_heures × charge_moteur

Valeurs de référence :
  consommation_spécifique = 0,22 L/CV/h (diesel agricole)
  charge_moteur :
    - labour = 0,85 (effort maximal)
    - transport = 0,45 (route)
    - semis = 0,55 (effort modéré)
    - pulvérisation = 0,35 (effort faible)
    - récolte (automoteur) = formule spécifique par type

Coût = litres × prix_GNR (≈ 0,90 €/L)
```

**Effet** : débite le réservoir du tracteur. Si réservoir vide → action impossible (le joueur doit ravitailler ou basculer sur un autre tracteur).

### 3. Usure du tracteur

```
usure_heures = durée_heures × facteur_charge

Le tracteur a un compteur horaire :
  heures_cumulées += usure_heures

Seuils d'usure (sur un total défini par modèle, ex: 10 000 h) :
  0-30% : état neuf, pas d'effet
  30-50% : risque de panne mineur (0,5%/tick)
  50-70% : risque panne modéré (2%/tick), -5% efficacité
  70-90% : risque panne élevé (5%/tick), -10% efficacité
  90-100% : panne quasi certaine, réforme recommandée
```

**Effet** : incrémente le compteur horaire du tracteur. Peut déclencher un seuil de panne ou de maintenance obligatoire.

### 4. Usure de l'outil attelé

```
Chaque outil a des PIÈCES D'USURE avec un compteur :
  pièce.heures_restantes -= durée_heures

Si pièce.heures_restantes ≤ 0 :
  → L'outil perd en efficacité (-20% par pièce usée)
  → Alerte joueur : "Socs de charrue à remplacer"
  → Remplacement possible : coût pièce + 1 h de travail (ou atelier concessionnaire)

Exemples de pièces et durées de vie :
  Socs de charrue : 200 h
  Disques de semoir : 500 h
  Buses de pulvérisateur : 300 h
  Couteaux de broyeur : 150 h
  Pneus de remorque : 2 000 h
  Chaîne de moissonneuse : 400 h
```

### 5. Effets sur le sol (parcelle)

```
Selon l'opération :
  Labour → structure ↑, compaction reset, résidus enfouis
  Semis → état "semé", culture associée
  Fertilisation → stock_N ↑, stock_P ↑, stock_K ↑ (selon produit)
  Récolte → résidus générés, stock_N ↓ (exportation)
  Broyage paille → MO ↑, résidus = 0
  Passage de roue → compaction ↑ (dépend du poids et de la pression pneu)
```

### 6. Consommation de stock (intrants)

```
Le stock est décrémenté AVANT le début de l'action.
Si stock insuffisant → action impossible.

Exemples :
  Semer 30 ha de blé à 150 kg/ha → besoin 4,5 t de semence en stock
  Fertiliser 30 ha à 180 u N (ammonitrate 33,5%) → besoin 16,1 t d'engrais
  Traiter 30 ha à 2 L/ha → besoin 60 L de produit
```

### 7. Production vers le stock

```
Récolte : quantité = surface × rendement_final
  → Ajouté au stock du silo/bâtiment de destination
  → Si capacité silo insuffisante → perte de l'excédent (ou action bloquée)

Traite : quantité = nb_vaches × production_jour × jours
  → Ajouté au tank à lait
  → Si tank plein → collecte forcée (vente au prix du jour)
```

## Le contrat d'une action — structure de données

```typescript
interface ActionResult {
  // Ce qui a été consommé
  temps_heures: number;
  carburant_litres: number;
  intrants_consommés: { item: string; quantité: number }[];

  // Ce qui a été produit
  production: { item: string; quantité: number; destination: string }[];

  // Ce qui a été modifié
  usure_tracteur: { matériel_id: string; heures_ajoutées: number; nouvel_état: number };
  usure_outil: { matériel_id: string; heures_ajoutées: number; pièces_à_changer: string[] };
  sol_modifié: { parcelle_id: string; modifications: Record<string, number> };
  animaux_modifiés: { lot_id: string; modifications: Record<string, number> }[];

  // Ce qui a été déclenché
  alertes: string[];       // "Socs à changer", "Tank à lait plein", etc.
  pannes: string[];        // Si un seuil d'usure a déclenché une panne
}
```

**Règle** : si un seul effet ne peut pas être appliqué (pas assez de carburant, stock insuffisant, bâtiment plein, matériel en panne), l'action **ne démarre pas**. Le joueur reçoit un message clair expliquant ce qui bloque.

## Pré-vérification complète (avant lancement)

```
Avant toute action, le système vérifie EN UNE PASSE :

✅ Temps disponible ≥ durée de l'action (sinon action refusée)
✅ Tracteur disponible (pas en panne, pas affecté à un autre chantier)
✅ Outil disponible (pas en panne, attelé ou attelable)
✅ Carburant suffisant dans le réservoir (ou ravitaillement possible)
✅ Stock d'intrants suffisant (semences, engrais, phyto, aliment...)
✅ Capacité de stockage de sortie suffisante (silo, tank, fosse...)
✅ Conditions météo compatibles (Expert : pas de travail par forte pluie)
✅ Fenêtre calendaire valide (pas de semis hors fenêtre)
✅ Parcelle dans le bon état (pas de récolte sans culture mature)

Si UNE condition échoue → message précis + suggestion :
  "Réservoir du JD 6215R : 12 L restants, besoin estimé 45 L.
   → Ravitailler maintenant (15 min, coût 30 €)"
```

## Traçabilité — le joueur peut voir la décomposition

Conformément aux GDD (le joueur comprend ce qui se passe), chaque action terminée produit un **résumé consultable** :

```
┌─ Labour « Les Sables » (18 ha) — TERMINÉ ──────────────────────┐
│                                                                  │
│  ⏱️  Temps consommé : 18 h 20                                    │
│  ⛽ Carburant : 187 L de GNR (168 €)                             │
│  🔧 Usure tracteur JD 6215R : +18 h (total 2 847 h — 28%)       │
│  🔧 Usure charrue Kuhn 5c : +18 h (socs : 42 h restantes ⚠️)    │
│  🌱 Sol : structure améliorée, résidus enfouis                    │
│                                                                  │
│  Coût total de l'opération : 168 € (carburant)                   │
│  + usure estimée : 85 € (amortissement horaire)                  │
│  = Coût complet : 253 € soit 14,05 €/ha                         │
│                                                                  │
│  [ Détail du calcul ]                                            │
└──────────────────────────────────────────────────────────────────┘
```

## Conséquences sur l'architecture

### 1. Le service d'exécution d'action est le point central

```
ActionExecutor.execute(action, context) → ActionResult

Il orchestre dans l'ordre :
  1. Pré-vérification (toutes les conditions)
  2. Réservation des ressources (verrouillage optimiste)
  3. Calcul de la durée (WorkDurationService)
  4. Application de tous les effets (en une transaction)
  5. Émission des événements (pour UI, alertes, logs)
  6. Retour du résumé complet
```

### 2. Chaque effet est un « handler » indépendant mais OBLIGATOIRE

```
ActionExecutor appelle une liste de EffectHandlers :
  - TimeHandler          → consomme les heures
  - FuelHandler          → consomme le carburant
  - TractorWearHandler   → incrémente l'usure du tracteur
  - ToolWearHandler      → incrémente l'usure de l'outil + vérifie les pièces
  - SoilHandler          → modifie l'état du sol
  - StockHandler         → consomme/produit les stocks
  - CompactionHandler    → ajoute la compaction selon le poids
  - AlertHandler         → émet les alertes (seuils, pannes)

AUCUN handler ne peut être omis. L'action échoue si un handler ne peut pas s'appliquer.
```

### 3. La transaction est atomique

```
Soit TOUS les effets s'appliquent, soit AUCUN.
Pas d'état intermédiaire où le carburant est consommé mais l'usure n'est pas comptée.
```

### 4. Extensibilité

Quand on ajoute un nouveau système (ex : compaction du sol par le poids, émissions CO₂, bruit pour voisinage), on ajoute un handler. Tous les anciens chantiers le prendront automatiquement en compte.

## Ce que cela interdit

```
❌ Une action "labourer" qui ne consomme que du temps
❌ Un tracteur qui travaille sans consommer de carburant
❌ Un outil qui travaille sans s'user
❌ Un semis qui ne décrémente pas le stock de semences
❌ Une récolte qui apparaît sans vérifier la capacité du silo
❌ Un transport qui n'use pas la remorque
❌ Une traite qui ne vérifie pas la capacité du tank
❌ Un effet appliqué sans que tous les autres le soient aussi
```

## Exemples complets — chaîne de bout en bout

### Exemple 1 : Semer 30 ha de blé

```
DÉCLENCHEUR : joueur clique "Semer" sur parcelle "Plaine Nord" (30 ha)

PRÉ-VÉRIFICATION :
  ✅ Tracteur JD 6215R disponible (pas en chantier, pas en panne)
  ✅ Semoir Amazone 4 m disponible et attelé
  ✅ Carburant : réservoir 180 L, besoin estimé 38 L → OK
  ✅ Stock semences blé : 6,2 t en hangar, besoin 4,5 t (150 kg/ha × 30) → OK
  ✅ Temps disponible : 8 h restantes aujourd'hui, durée totale 9,4 h → chantier sur 2 jours
  ✅ Fenêtre de semis : octobre = OK pour blé d'hiver
  ✅ Parcelle labourée et affinée → état compatible

EXÉCUTION (jour 1, 8 h) :
  Temps : −8 h du pool joueur → reste 4 h (exploitant)... non, 0 h restantes
  Carburant : 120 CV × 0,22 L/CV/h × 0,55 charge × 8 h = 116 L... 
    → Correction : carburant = proportionnel à la durée du jour
    → 38 L × (8/9.4) = 32 L consommés jour 1
  Usure tracteur : +8 h au compteur
  Usure semoir : +8 h (disques : 412 h → 404 h restantes)
  Stock semences : −4,5 t × (8/9.4) = −3,83 t (proportionnel à l'avancement)
  Sol : 25,5 ha semés (30 × 8/9.4)
  Compaction : +0,3 (semoir léger sur sol meuble)

EXÉCUTION (jour 2, 1 h 24) :
  Temps : −1,4 h du pool joueur
  Carburant : 6 L
  Usure tracteur : +1,4 h
  Usure semoir : +1,4 h
  Stock semences : −0,67 t (reste du besoin)
  Sol : 4,5 ha restants semés → parcelle 100% semée
  Compaction : +0,05

RÉSULTAT FINAL :
  Parcelle "Plaine Nord" : état = semée, culture = blé, date_semis = jour 1
  Stock semences blé : 6,2 − 4,5 = 1,7 t
  Réservoir JD 6215R : 180 − 38 = 142 L
  Compteur JD 6215R : +9,4 h (total : 2 856 h)
  Compteur semoir : +9,4 h (disques : 403 h restantes)
  Heures joueur jour 2 : 12 − 1,4 = 10,6 h restantes pour autre chose
  Coût total : 38 L × 0,90 € = 34 € (carburant) + amortissement horaire
```

### Exemple 2 : Nourrir 60 vaches laitières (mélangeuse)

```
DÉCLENCHEUR : joueur lance "Distribuer ration" (quotidien, ou automatisé)

PRÉ-VÉRIFICATION :
  ✅ Tracteur disponible
  ✅ Mélangeuse 18 m³ disponible
  ✅ Stock maïs ensilage : 12 t, besoin 3,6 t (60 vaches × 60 kg/j ensilage) → OK
  ✅ Stock correcteur azoté : 800 kg, besoin 420 kg (60 × 7 kg) → OK
  ✅ Stock minéraux : 60 kg, besoin 12 kg → OK
  ✅ Temps : besoin estimé 2 h 15

EXÉCUTION :
  Temps : −2,25 h
  Carburant : 100 CV × 0,22 × 0,60 × 2,25 = 30 L → −27 €
  Usure tracteur : +2,25 h
  Usure mélangeuse : +2,25 h (couteaux : 312 h → 310 h)
  Stock ensilage maïs : −3,6 t
  Stock correcteur : −420 kg
  Stock minéraux : −12 kg
  Animaux : ration_reçue = oui, qualité_ration = calcul nutritionnel
  → Si ration déséquilibrée (Expert) : alerte "Déficit protéique -2%"

COÛT TOTAL :
  Carburant : 27 €
  Aliments : 3 600 kg × 0,05 €/kg + 420 kg × 0,35 €/kg + 12 kg × 0,80 €/kg = 337 €
  Total quotidien alimentation : 364 €
  → Par vache par jour : 6,07 €
```

### Exemple 3 : Transport de grain au silo coopérative

```
DÉCLENCHEUR : joueur vend 60 t de blé, distance 8 km

PRÉ-VÉRIFICATION :
  ✅ Tracteur + benne 18 t disponibles
  ✅ Stock blé en silo : 62 t → OK (besoin 60 t)
  ✅ Carburant suffisant pour 4 A/R
  ✅ Nb trajets : ⌈60/18⌉ = 4

EXÉCUTION :
  Durée : (8 km / 25 km/h) × 2 × 4 + 4 × 10 min (chargement) = 3 h 13
  Temps : −3,22 h
  Carburant : 100 CV × 0,22 × 0,45 × 3,22 = 32 L → −29 €
  Usure tracteur : +3,22 h
  Usure benne : +3,22 h
  Stock blé (silo exploitation) : −60 t
  Trésorerie : +60 t × prix_du_jour (ex: 220 €/t) = +13 200 €
  Compaction chemin : aucun (route)
```

## Lien avec les GDD existants

| GDD | Ce qui est déjà documenté | Ce que cet ADR formalise |
|-----|--------------------------|--------------------------|
| GDD-materiel §3 | Formule de consommation carburant | ✅ Obligatoire à chaque action motorisée |
| GDD-materiel §4 | Usure par heure, pièces, pannes | ✅ Obligatoire, pas optionnel |
| GDD-cultures §6 | Consommation intrants par dose/ha | ✅ Stock décrémenté, pas juste un coût affiché |
| GDD-parcelles-sol §3 | Structure, compaction, MO | ✅ Modifié à chaque passage d'outil |
| GDD-bovin-laitier §5 | Ration quotidienne détaillée | ✅ Stock décrémenté chaque jour |
| GDD-batiments-stockage §4 | Capacité, remplissage | ✅ Vérifié avant action, bloquant si plein |
| ADR-004 | Temps calculé | ✅ Premier effet, jamais le seul |

## Résumé en une phrase

**Dans Agriva, il n'y a pas d'action gratuite. Tout ce qui bouge use, consomme, et produit — et le joueur voit exactement quoi.**
