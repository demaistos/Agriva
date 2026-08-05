# Spec Territoire & Foncier V1

**Version** : 1.0  
**Date** : 2026-05-07  
**Auteur** : Farming Systems Designer  
**Statut** : Validé V1

---

## Sommaire

1. Carte de France — 8 macro-régions agroclimatiques
2. Choix territoire joueur
3. Structure Parcelle
4. Marché foncier
5. Achat & Location
6. Regroupement (blocs)
7. Fusion physique
8. Contraintes de dispersion

---

## 1. Carte de France — 8 macro-régions agroclimatiques

### Variables d'état

```
region_id         : string  (R1..R8)
nom               : string
profil_meteo      : ProfilMeteo
cultures_favorisees : string[]
elevages          : string[]
specialites       : string[]
difficulte        : enum { facile, standard, exigeant, expert }
prix_foncier_base : int  (€/ha)
disponibilite_foncier : float  [0.0–1.0]
```

### Règles

- Chaque région définit les bornes météo (température, pluviométrie, ensoleillement) utilisées par le moteur météo.
- Les cultures favorisées bénéficient d'un bonus de rendement régional (`rendement_bonus_pct`).
- Les cultures défavorisées subissent une pénalité (`rendement_malus_pct`).
- La difficulté influe sur la fréquence des événements climatiques extrêmes et sur la disponibilité foncière initiale.

### Paramètres (ranges indicatifs)

| ID | Nom              | Temp. moy. (°C) | Pluie (mm/an) | Cultures favorisées              | Elevages                  | Spécialités                  | Difficulté | Prix foncier base (€/ha) |
|----|------------------|-----------------|---------------|----------------------------------|---------------------------|------------------------------|------------|--------------------------|
| R1 | Grand Ouest      | 11–13           | 700–900       | Maïs, blé, colza, prairies       | Bovins lait, porcs, volailles | Bocage, polyculture-élevage | facile     | 5 000–8 000              |
| R2 | Bassin parisien  | 10–12           | 550–700       | Blé tendre, betterave, colza     | Bovins viande (extensif)  | Grandes cultures intensives  | facile     | 7 000–12 000             |
| R3 | Nord/Nord-Est    | 9–11            | 600–800       | Blé, betterave, pomme de terre   | Bovins lait, porcs        | Chicorée, endive, houblon    | standard | 6 000–10 000             |
| R4 | Sud-Ouest        | 13–15           | 600–900       | Maïs irrigué, tournesol, soja    | Canards, bovins Gascons   | Armagnac, foie gras, pruneaux | standard | 4 000–7 000              |
| R5 | Massif central   | 8–11            | 800–1 200     | Prairies, seigle, lentilles      | Bovins allaitants, ovins  | Lentille verte du Puy, fromages AOP | exigeant | 2 000–4 500         |
| R6 | Vallée du Rhône  | 12–14           | 600–800       | Maïs, fruits, légumes, vignes    | Volailles, bovins         | Arboriculture, maraîchage    | standard | 5 000–9 000              |
| R7 | Méditerranée     | 14–17           | 300–600       | Vignes, oliviers, maraîchage     | Ovins, caprins            | Vins AOC, huile d'olive, herbes aromatiques | exigeant | 4 000–8 000  |
| R8 | Montagne         | 5–9             | 900–1 500     | Prairies d'altitude, orge, seigle | Bovins lait (Salers, Abondance), ovins | Fromages AOP, miel | expert | 1 500–3 500          |

### Interactions avec autres systèmes

- **Météo** : les bornes de `ProfilMeteo` alimentent le générateur météo journalier.
- **Cultures** : `rendement_bonus_pct` et `rendement_malus_pct` modifient le calcul de rendement final.
- **Marché foncier** : `prix_foncier_base` et `disponibilite_foncier` initialisent le marché local.
- **Elevage** : les élevages listés ont un coût de démarrage réduit de 15 % dans leur région native.

---

## 2. Choix territoire joueur

### Variables d'état

```
territoire_joueur : {
  region_id        : string         (R1..R8)
  departement_id   : string         (code INSEE, ex. "35")
  departement_nom  : string
  ville_ancrage    : string
  coordonnees      : { lat: float, lon: float }
  meteo_profil     : ProfilMeteo    (hérité de la région, affiné par le département)
  marche_local     : MarcheLocal
}
```

### Règles

1. **Sélection en cascade** : le joueur choisit d'abord la région, puis un département de cette région, puis une ville d'ancrage dans ce département.
2. **Ville d'ancrage** = siège de l'exploitation ; toutes les distances `distance_siege_km` des parcelles sont calculées depuis ce point.
3. **Affinement météo** : le département peut moduler ±10 % les paramètres de `ProfilMeteo` de la région (altitude, proximité côtière, effet de foehn).
4. **Cultures disponibles** : la liste des cultures jouables est filtrée par la région ; certaines cultures nécessitent un département spécifique (ex. betterave sucrière uniquement dans les départements avec sucrerie).
5. **Marché local** : le marché foncier et les prix de vente des productions sont initialisés selon la région et le département.
6. **Irréversibilité V1** : le territoire est choisi en début de partie et ne peut pas être changé en V1.

### Paramètres (ranges indicatifs)

- Nombre de départements par région : 3–8
- Nombre de villes d'ancrage proposées par département : 3–6
- Modulation météo départementale : ±5 % à ±10 % sur température et pluviométrie

### Interactions avec autres systèmes

- **Météo** : `ProfilMeteo` affiné alimente le moteur météo.
- **Marché foncier** : zone d'achat = département du joueur + départements limitrophes.
- **Logistique** : `ville_ancrage` est l'origine de calcul des coûts de dispersion.
- **Cultures & Elevage** : filtre les options disponibles dès la création de l'exploitation.

---

## 3. Structure Parcelle

### Variables d'état

```typescript
interface Parcelle {
  id                  : string          // UUID
  surface_ha          : float           // [0.1 – 500.0]
  qualite_agronomique : int             // [0 – 100]
  acces               : AccesEnum
  statut_propriete    : StatutProprieteEnum
  bloc_id             : string | null   // référence au bloc de gestion
  distance_siege_km   : float           // [0.0 – 150.0]
  historique_cultural : CultureHistorique[]  // liste des cultures passées (année, culture_id)
  fertilite           : int             // [0 – 100]
  humidite            : int             // [0 – 100]
}

enum AccesEnum {
  bon,          // route goudronnée jusqu'à la parcelle
  moyen,        // chemin carrossable
  difficile,    // piste ou chemin étroit
  isole         // accès saisonnier ou très difficile
}

enum StatutProprieteEnum {
  achetable,        // disponible à l'achat sur le marché foncier
  louable,          // disponible à la location (fermage)
  occupee,          // déjà exploitée par un tiers, non disponible
  non_disponible    // hors marché (domaine public, réserve naturelle, etc.)
}

interface CultureHistorique {
  annee      : int
  culture_id : string
}
```

### Règles

- `qualite_agronomique` est fixe à la génération de la parcelle ; elle reflète la nature du sol (texture, profondeur, drainage).
- `fertilite` et `humidite` sont des variables dynamiques modifiées par les pratiques culturales, la météo et les intrants.
- `historique_cultural` est utilisé pour calculer les rotations et les pénalités de monoculture.
- Une parcelle avec `statut_propriete = occupee` peut devenir `achetable` ou `louable` lors d'un rafraîchissement du marché (tous les 30 jours de jeu).
- `bloc_id` est `null` si la parcelle n'est affectée à aucun bloc de gestion.
- `acces = isole` impose un surcoût logistique fixe de 20 % sur toutes les opérations mécanisées.

### Paramètres (ranges indicatifs)

| Variable              | Min  | Max   | Valeur typique |
|-----------------------|------|-------|----------------|
| surface_ha            | 0.5  | 200   | 5–30           |
| qualite_agronomique   | 10   | 95    | 40–70          |
| distance_siege_km     | 0.1  | 80    | 1–20           |
| fertilite (initial)   | 20   | 80    | 50–65          |
| humidite (initial)    | 15   | 85    | 40–60          |

### Interactions avec autres systèmes

- **Cultures** : `fertilite`, `humidite`, `qualite_agronomique` et `historique_cultural` entrent dans le calcul du rendement.
- **Météo** : `humidite` est mis à jour chaque saison selon les précipitations et l'évapotranspiration.
- **Logistique** : `distance_siege_km` et `acces` alimentent le calcul des coûts de dispersion.
- **Marché foncier** : `statut_propriete` détermine si la parcelle apparaît dans les offres du marché.
- **Fusion** : deux parcelles adjacentes peuvent être fusionnées sous conditions (voir §7).

---

## 4. Marché foncier

### Variables d'état

```
marche_foncier : {
  offres_actives      : OffreFonciere[]   // 3–8 parcelles simultanées
  prix_foncier_base   : int               // €/ha, hérité de la région
  disponibilite_foncier : float           // [0.0–1.0], taux de renouvellement
  dernier_rafraichissement : date_jeu
  zone_achat          : string[]          // [departement_joueur, ...limitrophes]
}

interface OffreFonciere {
  parcelle_id   : string
  type          : enum { achat, location }
  prix_ha       : int          // pour achat
  loyer_annuel  : int          // pour location (fermage)
  duree_bail    : int          // années (location uniquement), [3–9]
  expire_dans   : int          // jours de jeu restants avant retrait de l'offre
}
```

### Règles

1. **Offres actives** : entre 3 et 8 parcelles sont simultanément disponibles sur le marché local.
2. **Zone d'achat** : seules les parcelles situées dans le département du joueur ou dans un département limitrophe sont proposées.
3. **Rafraîchissement** : toutes les 30 jours de jeu, le marché retire les offres expirées et génère de nouvelles offres selon `disponibilite_foncier`.
4. **Prix de vente** : `prix_ha = prix_foncier_base × qualite_agronomique_factor × acces_factor × region_factor`
   - `qualite_agronomique_factor` : 0.6 (qa=0) à 1.5 (qa=100), linéaire
   - `acces_factor` : bon=1.0, moyen=0.9, difficile=0.75, isole=0.55
   - `region_factor` : ±20 % selon tension foncière locale
5. **Loyer fermage** : `loyer_annuel = prix_ha × taux_fermage` avec `taux_fermage` entre 1.5 % et 3.5 % selon la région.
6. **Expiration des offres** : une offre non acceptée expire après 15–45 jours de jeu (tiré aléatoirement à la génération).
7. **Indisponibilité temporaire** : une parcelle retirée du marché ne peut pas réapparaître avant 60 jours de jeu.

### Paramètres (ranges indicatifs)

| Paramètre                  | Min     | Max      |
|----------------------------|---------|----------|
| Offres actives simultanées | 3       | 8        |
| prix_foncier_base          | 1 500   | 12 000   |
| disponibilite_foncier      | 0.1     | 0.8      |
| Rafraîchissement           | 30 j    | 30 j     |
| Durée bail fermage         | 3 ans   | 9 ans    |
| taux_fermage               | 1.5 %   | 3.5 %    |
| Expiration offre           | 15 j    | 45 j     |

### Interactions avec autres systèmes

- **Territoire joueur** : `zone_achat` est dérivée du département d'ancrage.
- **Région** : `prix_foncier_base` et `disponibilite_foncier` sont initialisés depuis la région.
- **Parcelle** : `statut_propriete` est mis à jour lors des transactions.
- **Finances joueur** : les achats et loyers sont débités du compte de l'exploitation.

---

## 5. Achat & Location

### Variables d'état

```
acquisition : {
  type              : enum { achat, location }
  parcelle_id       : string
  date_transaction  : date_jeu
  prix_total        : int        // achat : prix_ha × surface_ha + frais_notaire
  loyer_annuel      : int        // location uniquement
  duree_bail        : int        // location : années restantes
  date_fin_bail     : date_jeu   // location uniquement
  renouvellement_auto : bool     // location uniquement
}
```

### Règles — Achat

1. **Eligibilité** : la parcelle doit avoir `statut_propriete = achetable` et être dans la `zone_achat`.
2. **Coût total** : `prix_total = prix_ha × surface_ha + frais_notaire`
   - `frais_notaire = prix_total_avant_frais × 0.08` (8 % forfaitaire V1)
3. **Paiement** : intégral au moment de la transaction (pas de crédit V1).
4. **Effet immédiat** : `statut_propriete` passe à `occupee` (propriété joueur) dès la validation.
5. **Contrainte capital** : le joueur doit disposer du `prix_total` en trésorerie.

### Règles — Location (Fermage)

1. **Eligibilité** : la parcelle doit avoir `statut_propriete = louable` et être dans la `zone_achat`.
2. **Loyer** : `loyer_annuel` est fixé à la signature et ne varie pas pendant la durée du bail (V1).
3. **Durée du bail** : 3, 6 ou 9 ans (choix du joueur parmi les options proposées par le propriétaire).
4. **Paiement** : le loyer est prélevé automatiquement chaque année de jeu.
5. **Résiliation anticipée** : impossible en V1 ; le joueur doit attendre la fin du bail.
6. **Non-renouvellement** : le joueur peut choisir de ne pas renouveler 90 jours de jeu avant l'échéance.
7. **Renouvellement** : si `renouvellement_auto = true` et que le joueur ne résilie pas, le bail est reconduit aux mêmes conditions.
8. **Reprise par le propriétaire** : à l'échéance, le propriétaire peut reprendre la parcelle (probabilité liée à `disponibilite_foncier`).

### Contraintes communes

- Une parcelle ne peut pas être à la fois achetée et louée.
- Le joueur ne peut pas louer une parcelle qu'il possède déjà.
- Nombre maximum de parcelles en location simultanée : 20 (V1).
- Nombre maximum de parcelles totales (achat + location) : 50 (V1).

### Paramètres (ranges indicatifs)

| Paramètre              | Valeur V1         |
|------------------------|-------------------|
| Frais de notaire       | 8 %               |
| Durées de bail         | 3, 6, 9 ans       |
| Max parcelles location | 20                |
| Max parcelles total    | 50                |
| Pénalité résiliation   | non applicable V1 |

### Interactions avec autres systèmes

- **Finances** : débits immédiats (achat) ou annuels (loyer).
- **Marché foncier** : mise à jour de `statut_propriete` et retrait de l'offre active.
- **Blocs de gestion** : la parcelle acquise peut être affectée à un bloc.
- **Dispersion** : `distance_siege_km` de la nouvelle parcelle recalcule les coûts logistiques.

---

## 6. Regroupement (Blocs de gestion)

### Variables d'état

```
bloc : {
  bloc_id       : string        // UUID
  nom           : string        // nom libre donné par le joueur
  parcelle_ids  : string[]      // liste des parcelles membres
  culture_id    : string | null // culture affectée au bloc (null = non planifié)
  surface_totale_ha : float     // somme des surface_ha des parcelles membres
}
```

### Règles — V1 (blocs statiques manuels)

1. **Création** : le joueur crée un bloc en lui donnant un nom et en y affectant une ou plusieurs parcelles qu'il possède ou loue.
2. **Affectation** : une parcelle ne peut appartenir qu'à un seul bloc à la fois.
3. **Retrait** : le joueur peut retirer une parcelle d'un bloc à tout moment (hors saison culturale active sur ce bloc).
4. **Culture de bloc** : le joueur peut affecter une culture unique à tout le bloc ; les opérations (semis, traitement, récolte) s'appliquent alors à toutes les parcelles du bloc en une seule action.
5. **Pas de contrainte géographique** en V1 : des parcelles distantes peuvent être dans le même bloc (les coûts de dispersion s'appliquent individuellement).
6. **Dissolution** : un bloc peut être dissous à tout moment ; les parcelles redeviennent indépendantes (`bloc_id = null`).

### Règles — V2+ (groupes dynamiques, hors scope V1)

- Regroupement automatique par proximité géographique.
- Suggestions de blocs optimaux par l'IA de conseil.
- Blocs multi-cultures avec assolement automatique.

### Paramètres (ranges indicatifs)

| Paramètre                    | Valeur V1 |
|------------------------------|-----------|
| Nombre max de blocs          | 20        |
| Parcelles max par bloc       | 30        |
| Cultures par bloc            | 1         |

### Interactions avec autres systèmes

- **Cultures** : les opérations culturales peuvent cibler un bloc entier.
- **Dispersion** : les coûts logistiques restent calculés par parcelle individuelle.
- **Fusion** : deux parcelles d'un même bloc peuvent être fusionnées (voir §7).

---

## 7. Fusion physique

### Variables d'état

```
fusion : {
  parcelle_source_ids : string[]   // exactement 2 parcelles en V1
  parcelle_resultante_id : string  // nouvelle parcelle créée
  cout_fusion         : int        // €
  delai_jours         : int        // jours de jeu
  date_debut          : date_jeu
  date_fin            : date_jeu
  statut              : enum { en_cours, terminee }
}
```

### Règles

1. **Conditions préalables** :
   - Les deux parcelles doivent appartenir au même joueur (propriété, pas location).
   - Les deux parcelles doivent être dans le même bassin hydrographique ou être physiquement adjacentes (distance entre centroïdes < 0.5 km en V1).
   - Aucune des deux parcelles ne doit avoir une culture en cours au moment de la demande.
   - Les deux parcelles ne doivent pas être en cours de fusion.

2. **Coût de fusion** :
   ```
   surface_totale = parcelle_A.surface_ha + parcelle_B.surface_ha
   cout_fusion = max(1000, surface_totale × 150)  // en €
   ```

3. **Délai** : entre 30 et 90 jours de jeu (tiré selon la complexité administrative simulée).

4. **Irréversibilité** : la fusion est définitive. Les deux parcelles sources sont supprimées et remplacées par une nouvelle parcelle unique.

5. **Parcelle résultante** :
   - `surface_ha = A.surface_ha + B.surface_ha`
   - `qualite_agronomique = moyenne_ponderee(A, B)` par surface
   - `fertilite = moyenne_ponderee(A, B)` par surface
   - `humidite = moyenne_ponderee(A, B)` par surface
   - `acces = min(A.acces, B.acces)` (le moins bon des deux)
   - `historique_cultural = fusion(A.historique, B.historique)` (union triée par année)
   - `distance_siege_km = moyenne_ponderee(A, B)` par surface
   - `bloc_id` : hérité du bloc commun si les deux parcelles étaient dans le même bloc, sinon `null`

6. **Pendant le délai** : les parcelles sources sont verrouillées (aucune opération culturale, aucune vente, aucune nouvelle fusion).

### Paramètres (ranges indicatifs)

| Paramètre          | Valeur                          |
|--------------------|---------------------------------|
| Parcelles par fusion | 2 (V1)                        |
| Coût minimum       | 1 000 €                         |
| Coût par ha        | 150 €/ha                        |
| Délai minimum      | 30 jours de jeu                 |
| Délai maximum      | 90 jours de jeu                 |
| Irréversible       | oui                             |

### Interactions avec autres systèmes

- **Finances** : `cout_fusion` débité immédiatement au lancement.
- **Blocs** : la parcelle résultante hérite du `bloc_id` si applicable.
- **Marché foncier** : les parcelles sources sont retirées de tout marché actif.
- **Cultures** : aucune culture ne peut être lancée sur les parcelles sources pendant le délai.

---

## 8. Contraintes de dispersion

### Variables d'état

```
dispersion : {
  seuil_km_standard   : float    // distance au-delà de laquelle le surcoût s'applique (défaut : 15 km)
  seuil_km_eleve      : float    // seuil de surcoût élevé (défaut : 40 km)
  cout_logistique_base : float   // €/ha/opération pour les parcelles dans le seuil
}

// Par parcelle, calculé dynamiquement :
surcoût_dispersion(parcelle) :
  si distance_siege_km <= seuil_km_standard  → 0 %
  si distance_siege_km <= seuil_km_eleve     → +15 % sur coût opération
  si distance_siege_km > seuil_km_eleve      → +35 % sur coût opération

// Modificateur accès :
  acces = isole → +20 % supplémentaire (cumulable)
```

### Règles

1. **Application** : le surcoût de dispersion s'applique à toutes les opérations mécanisées (travail du sol, semis, traitement phytosanitaire, récolte, épandage).
2. **Non-application** : les opérations administratives (planification, affectation de bloc) ne sont pas affectées.
3. **Calcul par parcelle** : le surcoût est calculé individuellement pour chaque parcelle, même si l'opération est lancée depuis un bloc.
4. **Cumul** : le modificateur `acces = isole` (+20 %) se cumule avec le surcoût de distance.
5. **Affichage** : le coût total estimé (incluant le surcoût de dispersion) est affiché au joueur avant confirmation de chaque opération.
6. **Seuils configurables** : les seuils `seuil_km_standard` et `seuil_km_eleve` sont des paramètres de configuration du scénario (non modifiables par le joueur en V1).

### Paramètres (ranges indicatifs)

| Paramètre              | Valeur par défaut | Plage possible |
|------------------------|-------------------|----------------|
| seuil_km_standard      | 15 km             | 10–25 km       |
| seuil_km_eleve         | 40 km             | 30–60 km       |
| Surcoût palier 1       | +15 %             | +10 %–+25 %    |
| Surcoût palier 2       | +35 %             | +25 %–+50 %    |
| Surcoût acces isole    | +20 %             | fixe V1        |

### Interactions avec autres systèmes

- **Cultures** : surcoût appliqué aux opérations de semis, traitement et récolte.
- **Elevage** : surcoût appliqué aux livraisons d'aliments et aux collectes sur parcelles éloignées.
- **Finances** : les surcoûts sont intégrés dans le calcul du résultat d'exploitation.
- **Blocs** : le surcoût est calculé parcelle par parcelle même au sein d'un bloc.
- **Territoire joueur** : `ville_ancrage` est le point de référence pour `distance_siege_km`.

---

## Annexe — Récapitulatif des enums

```typescript
enum AccesEnum        { bon, moyen, difficile, isole }
enum StatutProprieteEnum { achetable, louable, occupee, non_disponible }
enum DifficulteEnum   { facile, moyen, difficile, expert }
enum StatutFusionEnum { en_cours, terminee }
enum TypeAcquisitionEnum { achat, location }
```

---

## Annexe — Dépendances inter-systèmes (résumé)

```
Territoire joueur
  └─► Météo (ProfilMeteo affiné)
  └─► Marché foncier (zone_achat, prix_foncier_base)
  └─► Cultures (filtre disponibilité)
  └─► Dispersion (point d'origine distance_siege_km)

Parcelle
  └─► Cultures (fertilite, humidite, qualite_agronomique, historique_cultural)
  └─► Météo (humidite mis à jour)
  └─► Marché foncier (statut_propriete)
  └─► Blocs (bloc_id)
  └─► Dispersion (distance_siege_km, acces)

Marché foncier
  └─► Finances (transactions)
  └─► Parcelle (statut_propriete)

Fusion
  └─► Finances (cout_fusion)
  └─► Parcelle (suppression sources, création résultante)
  └─► Blocs (héritage bloc_id)
```
