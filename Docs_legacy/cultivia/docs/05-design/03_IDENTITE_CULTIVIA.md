# 03 — IDENTITÉ CULTIVIA — Différenciation & Propriété Intellectuelle

> **Réunion d'équipe** — Game Director × Game Designer × Backend Dev × DBA × Frontend Dev
> Objectif : réviser les décisions d'identité Cultivia suite aux retours du Product Owner.
> Date : 2026-04-05 (révision v2)

---

## 1. RENOMMAGES OBLIGATOIRES (risque légal)

### 1.1 Heures de Travail (HT)

> **✅ Confirmé : Heures de Travail (HT) — 40 HT/jour**
> - 40 HT = 40h/semaine, ancrage réaliste dans le monde agricole.
> - Le joueur comprend immédiatement : un tracteur qui consomme 2 HT, c'est 2 heures de boulot.
> - Aucun risque légal, terme du langage courant.

### 1.2 Tableau des renommages

| SimAgri | Ancien Cultivia | **Nouveau Cultivia** | Justification |
|---------|----------------|---------------------|---------------|
| Points d'Action (PA) | PA | **Heures de Travail (HT)** | Réalisme agricole, 40 HT = 40h/semaine |
| SimPass | CultiPass | **Licence Pro** | Évoque un vrai agrément professionnel agricole |
| CESA | CECA | **Chambre Agricole** | Référence aux vraies Chambres d'Agriculture françaises |
| CFSA | CFCA | **Lycée Agricole** | Immédiatement compréhensible |
| GénétiSim | GénétiCult | **GénétiLab** | Neutre, professionnel |
| VitiSim | VitiCult | **Le Domaine** | Élégant, évoque le domaine viticole |
| Coopérative SimAgri | Coopérative Cultivia | **Le Marché Central** | Distingue PNJ vs coopératives joueurs (CAR) |
| Salon SimAgri | — | **Salon de Cultivia** | Nom du jeu intégré naturellement |

---

## 2. GÉOGRAPHIE — PRÉFECTURES ET SOUS-PRÉFECTURES

### 2.1 Décision

> **Retour PO :** Pas de cantons. Utiliser les préfectures et sous-préfectures réelles de chaque département. Plus réaliste et connu de tous.

Chaque joueur s'installe dans une préfecture ou sous-préfecture réelle. La distance entre deux fermes = distance réelle (haversine) entre les deux villes, pré-calculée.

### 2.2 Données France

- ~101 préfectures (1 par département)
- ~233 sous-préfectures
- **Total : ~340 villes jouables**

### 2.3 Schéma BDD (DBA)

```sql
CREATE TABLE department (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(3) NOT NULL UNIQUE,  -- '01', '2A', '75'...
    name        VARCHAR(100) NOT NULL,
    region_code VARCHAR(3) NOT NULL
);

CREATE TABLE prefecture (
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    department_id       INTEGER NOT NULL REFERENCES department(id),
    is_prefecture       BOOLEAN NOT NULL DEFAULT false,
    is_sous_prefecture  BOOLEAN NOT NULL DEFAULT false,
    lat                 DECIMAL(9,6) NOT NULL,
    lng                 DECIMAL(9,6) NOT NULL
);

CREATE TABLE distance_matrix (
    prefecture_a_id  INTEGER NOT NULL REFERENCES prefecture(id),
    prefecture_b_id  INTEGER NOT NULL REFERENCES prefecture(id),
    distance_km      SMALLINT NOT NULL,
    PRIMARY KEY (prefecture_a_id, prefecture_b_id)
);

CREATE INDEX idx_prefecture_dept ON prefecture(department_id);
CREATE INDEX idx_distance_lookup ON distance_matrix(prefecture_a_id, prefecture_b_id);
```

**Volumétrie :** `distance_matrix` = 340 × 339 / 2 = ~57 600 lignes. Pré-calculé au seed, négligeable.

### 2.4 Calcul de distance (Backend)

```typescript
function haversine(lat1: number, lng1: number, lat2: number, lng2: number): number {
    const R = 6371;
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLng = (lng2 - lng1) * Math.PI / 180;
    const a = Math.sin(dLat/2)**2
            + Math.cos(lat1 * Math.PI/180) * Math.cos(lat2 * Math.PI/180)
            * Math.sin(dLng/2)**2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
}
```

Pré-calculé au seed → stocké dans `distance_matrix`. À l'exécution : simple `SELECT distance_km`.

### 2.5 Coût de déplacement (Game Designer)

```
Coût = ceil(distance_km / 30) HT, minimum 1 HT
Même préfecture = 0 HT
```

| Trajet exemple | Distance | Coût HT |
|---------------|----------|---------|
| Même préfecture | 0 km | 0 HT |
| Préfecture voisine | ~60 km | 2 HT |
| Même département | ~100 km | 4 HT |
| Paris → Lyon | 465 km | 16 HT |
| Paris → Marseille | 775 km | 26 HT |

> La distance rend la géographie significative : le commerce local est favorisé, le transport longue distance nécessite un chauffeur.

### 2.6 Frontend — Inscription

Autocomplete sur le nom de préfecture avec département affiché :
```
"Chartres (28 - Eure-et-Loir)"
"Dreux (28 - Eure-et-Loir)"
"Nogent-le-Rotrou (28 - Eure-et-Loir)"
```

---

## 3. SERVEUR UNIQUE — FRANCE DIFFICULTÉ NORMALE

### 3.1 Décision

> **Retour PO :** 1 seul serveur au lancement. France, difficulté normale. Pas de Beauce/Aubrac/Maîtrise.

Un seul serveur "France". Pas de variantes de difficulté. Les serveurs additionnels (autres pays, mode expert) seront ouverts post-lancement si la communauté le justifie.

### 3.2 Paramètres économiques — Serveur France (normal)

| Paramètre | Valeur | Justification |
|-----------|--------|---------------|
| HT/jour | **40** | 40h/semaine, réalisme |
| Solde initial | **100 000 €** | Départ modeste, progression satisfaisante |
| Plancher solde | **-30 000 €** | Découvert réduit, force la prudence |
| Prix parcelle/ha (base) | **4 500 €** | Modulé par coefficient départemental (0.7 à 1.5) |
| Coût annonce | **800 €** | Encourage le commerce dès le début |
| Salaire employé/mois | **1 600 €** | Cohérent avec l'économie du jeu |
| Prêt max | **150 000 €** | Augmenté (audit E3) — marge pour intrants + 2e parcelle |
| Taux épargne | **3 / 4.5 / 6 %** | Réaliste, réduit le faucet monétaire |
| Coût déplacement | **1 HT / 30 km** | Favorise le commerce local |
| Coût transport marchandise | **0.02 €/kg/km** | Proportionnel à la distance réelle |
| Rayon CAR | **150 km** | Les associés doivent être proches |
| Achat/vente HT | **10 €/HT** | Régional uniquement |

### 3.3 Kit de démarrage (résolution audit E1)

> **Décision :** Chaque nouveau joueur reçoit un kit de matériel usé mais fonctionnel à l'inscription.
> Voir `02-architecture/08_EQUILIBRAGE_ECONOMIQUE.md` pour les simulations complètes.

| Matériel | Usure initiale | Argus estimé |
|----------|---------------|-------------|
| Tracteur 80 CV | 50% | 14 875€ |
| Charrue 4 corps | 40% | 4 080€ |
| Herse rotative 3m | 40% | 6 120€ |
| Semoir 3m | 40% | 7 650€ |
| Moissonneuse 300 CV | 60% | 61 200€ |
| Benne 12T | 40% | 6 120€ |
| **Total argus** | | **~100 045€** |

**Règles du kit :**
- Attribué automatiquement à la création de la ferme (Feature 8)
- Matériel non revendable pendant 1 mois Cultivia (7 jours réels) — anti-exploit
- Usure élevée → pannes fréquentes → incite à upgrader
- Le matériel est abrité dans le hangar offert (200m²)

### 3.4 ETA Cultivia — PNJ (filet de sécurité)

> **Décision :** Un service PNJ de travaux agricoles est disponible dès Phase 1 pour les joueurs sans matériel adapté.

| Travail | Tarif/ha | HT joueur |
|---------|----------|-----------|
| Labour | 80€/ha | 0.5 HT |
| Hersage | 50€/ha | 0.5 HT |
| Semis | 60€/ha | 0.5 HT |
| Récolte | 120€/ha | 0.5 HT |
| Épandage engrais | 40€/ha | 0.5 HT |
| Traitement phyto | 45€/ha | 0.5 HT |

**Règles :** Tarifs fixes (+30% vs coût propre), toujours disponible, disparaît progressivement quand des ETA joueurs (Phase 3) s'installent dans la zone.

### 3.3 Coefficient départemental (prix parcelles)

Le prix de base (4 500 €/ha) est multiplié par un coefficient basé sur les vrais prix SAFER :

| Zone | Coefficient | Prix effectif/ha | Exemples |
|------|------------|-----------------|----------|
| Terres riches | 1.3 – 1.5 | 5 850 – 6 750 € | Beauce (28), Picardie (60, 80), Île-de-France |
| Terres moyennes | 0.9 – 1.1 | 4 050 – 4 950 € | Bretagne, Normandie, Alsace |
| Terres pauvres | 0.7 – 0.8 | 3 150 – 3 600 € | Causses (12), Massif Central, Montagne |

---

## 4. SYSTÈME DE TEMPS — 84 JOURS PAR AN

### 4.1 Décision

> **Retour PO :** Garder 84 jours/an comme SimAgri. La proposition 12 mois / 8 jours par semaine n'est pas réaliste. C'est un standard qui marche.

### 4.2 Mapping temps

```
CULTIVIA_DAY     = 1 jour réel
CULTIVIA_MONTH   = 7 jours réels (1 semaine réelle = 1 mois in-game)
CULTIVIA_SEASON  = 3 CULTIVIA_MONTH = 21 jours réels
CULTIVIA_YEAR    = 12 CULTIVIA_MONTH = 84 jours réels
```

### 4.3 Saisons

| Saison | Mois in-game | Jours réels | Mois réels correspondants |
|--------|-------------|-------------|--------------------------|
| Hiver | 1-3 | 1-21 | Décembre, Janvier, Février |
| Printemps | 4-6 | 22-42 | Mars, Avril, Mai |
| Été | 7-9 | 43-63 | Juin, Juillet, Août |
| Automne | 10-12 | 64-84 | Septembre, Octobre, Novembre |

### 4.4 Fonctions de calcul

```typescript
function getSeason(dayOfYear: number): Season {
    if (dayOfYear <= 21) return 'WINTER';
    if (dayOfYear <= 42) return 'SPRING';
    if (dayOfYear <= 63) return 'SUMMER';
    return 'AUTUMN';
}

function getMonth(dayOfYear: number): number {  // 1-12
    return Math.ceil(dayOfYear / 7);
}

function getDayOfMonth(dayOfYear: number): number {  // 1-7
    return ((dayOfYear - 1) % 7) + 1;
}
```

### 4.5 Éléments supprimés

Les éléments suivants sont **définitivement supprimés** :
- ~~84 jours/an~~
- ~~12 mois~~
- ~~8 jours/semaine~~
- ~~Mois de  (13e mois)~~
- ~~CULTIVIA_WEEK = 7 jours = 1 quinzaine~~

> Note : la "jachère" reste un **état de parcelle** (pas de culture en cours), mais ce n'est plus une saison ni un mois.

---

## 5. HEURES DE TRAVAIL (HT) — RÉFÉRENCE EXHAUSTIVE

### 5.1 Attribution quotidienne

```
HT_BASE              = 40       // par joueur par jour (reset à minuit serveur)
// Les HT non utilisés sont PERDUS (pas de cumul)
```

### 5.2 Employés et animaux de travail

| Type | HT/jour | Coût/mois | Usage |
|------|---------|-----------|-------|
| Chauffeur | 32 HT | 1 600 € | Transport, travaux parcelle |
| Chien de troupeau | 35 HT | — | Déplacement animaux uniquement |
| Mécanicien | 25 HT | 1 600 € | Entretien matériel |
| Inséminateur | 25 HT | 1 600 € | Insémination animaux |
| Ouvrier maraîchage | 22 HT | 1 600 € | Travaux maraîchage |

### 5.3 Coût de déplacement

```
Même préfecture :           0 HT
Autre préfecture :          ceil(distance_km / 30) HT, minimum 1 HT
Trajet Marché Central :     1 HT (fixe)
```

### 5.4 Coût travaux parcelle

```
ht = (surface_ha / (largeur_travail_m / 100))
   × facteur_maniabilité    // ±5% par point (1-5), parcelles < 10 ha uniquement
   × facteur_GPS            // 0.85 si GPS, 1.0 sinon
   × facteur_combiné        // 0.60 si combiné, 1.0 sinon
```

| Facteur | Valeur | Condition |
|---------|--------|-----------|
| GPS | ×0.85 (-15%) | Matériel équipé GPS |
| Maniabilité 1 | ×1.10 (+10%) | Parcelle < 10 ha |
| Maniabilité 3 | ×1.00 | Parcelle < 10 ha |
| Maniabilité 5 | ×0.90 (-10%) | Parcelle < 10 ha |
| Combiné | ×0.60 (-40%) | 2 opérations en 1 passage |

### 5.5 Coût élevage

| Action | Coût HT |
|--------|---------|
| Nourrissage | Variable par espèce (voir specs phase 2) |
| Traite | Variable, jusqu'à 4×/jour |
| Litière | Variable par bâtiment |
| Gavage oie | 0.27 HT/animal |
| Gavage canard | 0.0625 HT/animal |
| Abattage | 0.25 HT/animal |
| Tonte laine | Variable |
| Duvet oies | 0.025 HT/animal |
| Duvet canards | 0.020 HT/animal |

### 5.6 Coût entretien

| Élément | Coût HT |
|---------|---------|
| Bâtiment | 0.3 HT/mois |
| Matériel | 1.0 HT/mois |
| Méthaniseur (par module) | 1.0 HT/mois |

### 5.7 Marché

| Action | Coût HT |
|--------|---------|
| Visite marché | 1 à 4 HT |
| Maximum marchés/jour | 16 HT (hors déplacements) |

### 5.8 Achat/vente de HT entre joueurs

```
Prix fixe :     10 €/HT
Portée :        régionale uniquement (même région)
```

### 5.9 Reset quotidien

À minuit serveur, chaque joueur reçoit exactement **40 HT**. Les HT restants de la veille sont perdus. Les employés et chiens reçoivent leurs HT propres (non cumulables non plus).

---

## 6. MÉCANIQUES ORIGINALES — CE QUI DIFFÉRENCIE CULTIVIA

### 6.1 Les 8 mécaniques originales

**1. Réputation d'Exploitant** ★★★
Score 0-100 visible publiquement. Augmente : livraisons à temps, qualité, participation communautaire. Diminue : défauts de paiement, animaux maltraités, annonces trompeuses. Impact : accès aux meilleures CAR, prix préférentiels au Marché Central, éligibilité Chambre Agricole.

**2. Événements Saisonniers** ★★★
1-2 événements aléatoires par préfecture par saison : gel tardif (printemps), sécheresse (été), tempête (automne), neige (hiver). Affecte les rendements localement. Assurance optionnelle.

**3. Contrats de Filière** ★★☆
Contrats joueur-joueur garantis par le système : "10t de blé/mois pendant 6 mois à 180€/t". Pénalité si non-livraison. Stabilise les revenus.

**4. Arbre de Spécialisation** ★★★
3 branches : Cultures, Élevage, Commerce. XP par la pratique. Bonus passifs (rendement +2%, coût véto -5%, transport -10%). Pas de P2W.

**5. Météo Dynamique par Préfecture** ★★☆
Chaque préfecture a sa propre météo (température, pluie, ensoleillement) basée sur les moyennes réelles. Bretagne = plus de pluie, Provence = plus de soleil. Impact direct sur rendements et pousse d'herbe.

**6. Journal de l'Exploitation** ★☆☆
Historique automatique de toutes les actions, consultable comme un cahier de plaine. Utile pour optimiser rotations et comparer rendements. Export possible.

**7. Objectifs Hebdomadaires** ★★☆
3 objectifs optionnels par semaine réelle (ex: "Vendre 5t de blé"). Récompense : +5 HT le lendemain ou petit bonus financier.

**8. Marché à Terme** ★★★
Contrats à terme sur matières premières. Spéculation, stratégie, profondeur économique.

### 6.2 Priorisation

| Mécanique | Phase | Effort |
|-----------|-------|--------|
| Météo Dynamique par Préfecture | Phase 0 | M |
| Réputation d'Exploitant | Phase 0 | S |
| Événements Saisonniers | Phase 1 | M |
| Journal de l'Exploitation | Phase 1 | S |
| Objectifs Hebdomadaires | Phase 1 | S |
| Contrats de Filière | Phase 3 | M |
| Arbre de Spécialisation | Phase 2 | L |
| Marché à Terme | Phase 3 | L |

---

## 7. TABLE DE CORRESPONDANCE COMPLÈTE

Référence pour search-and-replace global dans toute la documentation et le code.

| Ancien terme | Nouveau terme |
|---|---|
| SimAgri | Cultivia |
| Points d'Action (PA) | Heures de Travail (HT) |
| PA | HT |
| pa_today | ht_today |
| pa_max | ht_max |
| pa_base | ht_base |
| PA_BASE | HT_BASE |
| PA_EMPLOYEE | HT_EMPLOYEE |
| PA_MECHANICIEN | HT_MECHANICIEN |
| PA_INSEMINATEUR | HT_INSEMINATEUR |
| PA_CHAUFFEUR | HT_CHAUFFEUR |
| PA_CHIEN_TROUPEAU | HT_CHIEN_TROUPEAU |
| PA_OUVRIER_MARAICH | HT_OUVRIER_MARAICH |
| PLAYER_INSUFFICIENT_PA | PLAYER_INSUFFICIENT_HT |
| SimPass | Licence Pro |
| simpass_expires | license_expires |
| CultiPass | Licence Pro |
| CESA / CECA | Chambre Agricole |
| cesa_representative | chamber_representative |
| cesa_election | chamber_election |
| CFSA / CFCA | Lycée Agricole |
| cfsa | lycee_agricole |
| GénétiSim / GénétiCult | GénétiLab |
| VitiSim / VitiCult | Le Domaine |
| Coopérative SimAgri / Cultivia | Le Marché Central |
| canton | préfecture |
| canton_id | prefecture_id |
| zone_id | prefecture_id |
| canton_distance | distance_matrix |
| 0.25 PA/zone | 1 HT / 30 km |
| 3 PA changement département | *(supprimé, remplacé par distance réelle)* |
| 35 PA/jour | 40 HT/jour |
| 70 PA (Expert) | *(supprimé, serveur unique)* |
| 80 HT (Maîtrise) | *(supprimé, serveur unique)* |
| 120 000 € (solde initial SimAgri) | 100 000 € |
| -50 000 € (plancher SimAgri) | -30 000 € |
| 150 000 € (prêt max SimAgri) | 150 000 € |
| 1 750 €/mois (salaire SimAgri) | 1 600 €/mois |
| 1 500 € (coût annonce SimAgri) | 800 € |
| 5/6/7% (épargne SimAgri) | 3/4.5/6% |
| 84 jours = 1 an | *(supprimé)* → 84 jours = 1 an |
| 8 jours = 1 mois | *(supprimé)* → 7 jours = 1 mois |
| 12 mois/an | *(supprimé)* → 12 mois/an |
| Mois de  | *(supprimé)* |
| Serveur Beauce | *(supprimé)* → Serveur France |
| Serveur Aubrac | *(supprimé)* |
| Serveur Maîtrise | *(supprimé)* |
| SIM_DAY | CULTIVIA_DAY |
| SIM_MONTH | CULTIVIA_MONTH |
| SIM_YEAR | CULTIVIA_YEAR |
| SIM_SEASON | CULTIVIA_SEASON |
| John Deere | Verdant |
| Claas | Aureus |
| New Holland | Novaterra |
| Massey Ferguson | Fergusson |
| Fendt | Feldmark |
| Case IH | Castor |
| Kubota | Kubara |
| Deutz-Fahr | Deutmark |

---

## 8. RÉSUMÉ DES DÉCISIONS (v2)

| Sujet | Décision v1 | **Décision v2 (PO)** | Changement |
|-------|------------|---------------------|------------|
| Énergie | HT, 40/jour | **HT, 40/jour** | ✅ Confirmé |
| Géographie | Cantons réels (~2 000) | **Préfectures/sous-préfectures (~340)** | 🔄 Changé |
| Temps | 84j/an, 12 mois, 8j/mois,  | **84j/an, 12 mois, 7j/mois** | 🔄 Changé |
| Serveurs | 3 (Beauce, Aubrac, Maîtrise) | **1 seul (France, normal)** | 🔄 Changé |
| Abonnement | Licence Pro | **Licence Pro** | ✅ Confirmé |
| Conseil éco | Chambre Agricole | **Chambre Agricole** | ✅ Confirmé |
| Formation | Lycée Agricole | **Lycée Agricole** | ✅ Confirmé |
| Génétique | GénétiLab | **GénétiLab** | ✅ Confirmé |
| Viticulture | Le Domaine | **Le Domaine** | ✅ Confirmé |
| Coop PNJ | Le Marché Central | **Le Marché Central** | ✅ Confirmé |
| Mécaniques | 8 originales | **8 originales** | ✅ Confirmé |
| Déplacement | 1 HT / 30 km (cantons) | **1 HT / 30 km (préfectures)** | 🔄 Ajusté |

---

## 9. IMPACTS SUR LES AUTRES DOCUMENTS

Les documents suivants doivent être mis à jour pour refléter ces décisions :

| Document | Changements nécessaires |
|----------|------------------------|
| `02_GAME_SYSTEMS.md` | HT_BASE → 40, supprimer formule déplacement par zones, ajouter formule par préfectures, confirmer 84j/an |
| `05_SCALABILITY.md` | Remplacer "8 serveurs" par "1 serveur", ajuster volumétrie météo (~340 préfectures au lieu de 400 zones), remplacer `pa:` par `ht:` dans Redis |
| `01_DATA_MODEL.md` | Ajouter tables `department`, `prefecture`, `distance_matrix` ; supprimer table `canton` |
| Specs phases (`03-specs/`) | Remplacer PA→HT, canton→préfecture, 104→84 jours partout |
| README.md | Supprimer mentions cantons, 12 mois, , serveurs terroir |

---

*Document révisé suite aux retours du Product Owner. Validé en réunion d'équipe le 2026-04-05.*
