> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Coopérative Agricole Régionale (CAR)

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : reality-vs-simagri-metiers.md §8, reality-vs-simagri-economie.md §2, ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### Intention de design

La CAR est le **sommet de la coopération** dans Agriva. Plusieurs joueurs mutualisent du capital pour créer une structure économique qui les sert tous : collecte, approvisionnement, transformation, financement. C'est l'équivalent d'une guilde dans un MMO, mais avec une vraie économie sous-jacente — chaque décision collective a un impact mesurable sur le portefeuille de chaque membre.

**Pourquoi ce système existe** : créer de la vie sociale, de la coopération et de l'interdépendance économique entre joueurs. Dans SimAgri, c'est le système le mieux noté socialement (8/10). Il transforme un jeu solo en expérience collective.

### Ce que SimAgri fait bien (à garder)

- Structure multi-joueurs avec parts sociales
- Sous-activités de transformation (huilerie, sucrerie, laiterie, méthanisation)
- Emprunts aux membres (rôle bancaire)
- Magasin libre-service pour les adhérents
- Achats/ventes entre CAR

### Ce que SimAgri fait mal (à corriger)

- Pas de collecte/stockage céréales (activité n°1 d'une coopérative réelle)
- Pas de ristourne en fin d'exercice (mécanisme central du modèle coopératif)
- Pas de gouvernance réelle (vote AG, budget, admission)
- Pas d'engagement d'apport (le membre n'a aucune obligation)
- Pas d'achats groupés à prix négocié (inversé : la coop est plus chère dans SimAgri)

### Gameplay loop

```
┌─────────────────────────────────────────────────────────────────┐
│                    CYCLE ANNUEL DE LA CAR                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  QUOTIDIEN (membres)                                            │
│  ┌─────────────────────────────────────────────┐                │
│  │ Livrer récolte → Acheter intrants → Produire │               │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  MENSUEL (administrateurs)                                      │
│  ┌──────────────────────────────────────────────────┐           │
│  │ Gérer stocks → Fixer prix → Valider emprunts     │           │
│  │ → Piloter sous-activités → Traiter candidatures  │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                 │
│  ANNUEL (assemblée générale)                                    │
│  ┌──────────────────────────────────────────────────────┐       │
│  │ Voter budget → Élire président → Décider ristourne  │       │
│  │ → Investir/désinvestir → Fixer engagement d'apport  │       │
│  └──────────────────────────────────────────────────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Décisions du joueur

| Décision | Fréquence | Impact | Mode |
|----------|:---------:|:------:|:----:|
| Rejoindre / quitter une CAR | Rare | Fort | Normal |
| Livrer sa récolte à la CAR | Chaque récolte | Moyen | Normal |
| Acheter intrants au magasin CAR | Saisonnier | Moyen | Normal |
| Voter en AG | Annuel | Fort | Expert |
| Se présenter au conseil | Rare | Fort | Expert |
| Fixer les tarifs (admin) | Mensuel | Fort | Expert |
| Décider un investissement lourd | Rare | Très fort | Expert |

### Tableau Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Adhésion | Rejoindre en 1 clic, accès magasin + collecte | Idem + engagement d'apport obligatoire |
| Gouvernance | Automatique (PNJ président) | Élections, votes, conseil d'administration |
| Ristourne | Versée automatiquement | Vote AG sur le montant, arbitrage réserves/ristourne |
| Sous-activités | Bénéficier des prix transformés | Gérer la production, capacité, investissement |
| Sortie | Libre, remboursement immédiat | Préavis 1 saison, remboursement progressif |
| Bilan | Non affiché | Bilan complet, ratios, projections |

---

## 2. Création et gouvernance

### 2.1 Conditions de création

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Nombre minimum de fondateurs | 5 joueurs | 5 joueurs |
| Ancienneté minimum par fondateur | 30 jours | 30 jours |
| Capital social minimum | 500 000 € | 500 000 € |
| Part sociale unitaire | 10 000 € | 10 000 € |
| Parts minimum par fondateur | 5 (50 000 €) | 5 (50 000 €) |
| Parts maximum par joueur | 20 (200 000 €) | 20 (200 000 €) |
| CAR maximum par région (serveur) | 3 | 3 |

**Processus de création** :
1. Un joueur initie la création (formulaire : nom, région, objet)
2. 4 autres joueurs rejoignent dans les 14 jours (souscription de parts)
3. Capital minimum atteint → la CAR est constituée
4. Le fondateur initiateur devient président provisoire (6 mois)
5. Première AG obligatoire à 6 mois (élection du bureau)

### 2.2 Parts sociales

| Paramètre | Valeur |
|-----------|:------:|
| Valeur nominale | 10 000 € |
| Minimum par membre | 3 parts (30 000 €) |
| Maximum par membre | 20 parts (200 000 €) |
| Rémunération des parts | 0% (pas d'intérêt sur le capital — principe coopératif) |
| Remboursement à la sortie | Valeur nominale (pas de plus-value) |
| Droits attachés | 1 voix en AG (indépendamment du nombre de parts) |

**Principe fondamental** : 1 membre = 1 voix, quel que soit le capital détenu. Un membre avec 3 parts a le même pouvoir de vote qu'un membre avec 20 parts. C'est le principe coopératif réel, pas une ploutocratie.

### 2.3 Gouvernance

#### Rôles

| Rôle | Nombre | Pouvoirs | Élection |
|------|:------:|----------|:--------:|
| Président | 1 | Décisions courantes, représentation, veto suspensif | AG annuelle |
| Administrateurs | 2-4 | Vote conseil, gestion sous-activités, validation emprunts | AG annuelle |
| Membres | Illimité (min 5) | Vote en AG, accès services, candidature au conseil | Adhésion |

#### Élections (mode Expert uniquement)

- **Fréquence** : AG annuelle (1 fois par saison de jeu)
- **Candidatures** : tout membre peut se présenter (7 jours avant l'AG)
- **Vote** : scrutin majoritaire à 1 tour, 1 membre = 1 voix
- **Quorum** : 50% des membres doivent voter (sinon report 7 jours)
- **Mandat** : 1 an (renouvelable sans limite)
- **Motion de défiance** : vote extraordinaire si 33% des membres le demandent

#### En mode Normal

Pas d'élection. La CAR est gérée par un PNJ-président (IA) qui prend des décisions raisonnables automatiquement. Le joueur Normal bénéficie des services sans gérer la complexité politique.

### 2.4 Votes et décisions collectives

| Type de décision | Majorité requise | Qui vote | Mode |
|-----------------|:----------------:|:--------:|:----:|
| Admission nouveau membre | Simple (>50%) | Conseil | Expert |
| Exclusion d'un membre | Qualifiée (>66%) | AG | Expert |
| Investissement < 500 000 € | Simple (>50%) | Conseil | Expert |
| Investissement ≥ 500 000 € | Qualifiée (>66%) | AG | Expert |
| Modification tarifs magasin | Simple (>50%) | Conseil | Expert |
| Répartition du résultat | Simple (>50%) | AG | Expert |
| Dissolution de la CAR | Unanimité - 1 | AG | Expert |
| Modification engagement d'apport | Qualifiée (>66%) | AG | Expert |

**Durée de vote** : 72h (conseil), 7 jours (AG).

### 2.5 Sortie d'un membre

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Préavis | Immédiat | 1 saison (3 mois IRL) |
| Remboursement parts | Instantané | Progressif (3 mensualités) |
| Engagement d'apport restant | Annulé | Dû jusqu'à fin de saison |
| Pénalité de sortie anticipée | 0% | 5% du capital si < 1 an d'ancienneté |
| Réintégration après sortie | Immédiate | Délai 6 mois |



---

## 3. Services de base de la CAR

### 3.1 Collecte et stockage des récoltes

La collecte est l'activité n°1 d'une coopérative réelle (75% des céréales françaises). La CAR possède des silos collectifs où les membres livrent leurs récoltes.

| Paramètre | Valeur |
|-----------|:------:|
| Capacité silo de base | 5 000 t |
| Extension silo | +2 500 t (investissement 200 000 €) |
| Maximum extensions | 4 (total max : 15 000 t) |
| Coût de stockage | 2 €/t/mois |
| Séchage (si humidité > 15%) | 5 €/t |
| Durée max stockage | 12 mois (au-delà : perte qualité -1 niveau/mois) |

**Mécanisme** :
1. Le membre livre sa récolte au silo CAR (coût transport selon distance)
2. La CAR stocke et attend le meilleur prix (décision du conseil ou automatique)
3. Vente groupée : la CAR négocie un prix supérieur (+5 à +12% vs prix spot individuel)
4. Le membre reçoit un acompte à la livraison (80% du prix estimé)
5. Le solde est versé à la vente effective (+ ristourne éventuelle en fin d'exercice)

**Avantage collecte CAR** :

| Volume collecté | Bonus prix vente |
|:-:|:-:|
| < 1 000 t | +5% |
| 1 000 - 5 000 t | +8% |
| 5 000 - 10 000 t | +10% |
| > 10 000 t | +12% |

Le bonus est lié au pouvoir de négociation : plus la CAR agrège de volume, meilleur est le prix obtenu.

### 3.2 Magasin d'approvisionnement

La CAR propose à ses membres des intrants à prix négocié (achats groupés = remise volume).

| Produit | Remise vs prix catalogue | Stock |
|---------|:------------------------:|:-----:|
| Semences certifiées | -8% | Limité (commande anticipée) |
| Engrais minéraux (N, P, K) | -12% | Limité (commande anticipée) |
| Phytosanitaires | -10% | Limité |
| Aliments animaux | -15% | Permanent |
| Petit matériel (clôtures, bâches) | -5% | Permanent |
| HVC (carburant bio si huilerie) | -20% | Selon production huilerie |

**Mécanisme de commande groupée (Expert)** :
1. Le conseil fixe les besoins prévisionnels (avant saison)
2. Les membres passent des pré-commandes (engagement)
3. La CAR négocie les prix fournisseurs selon le volume total
4. Plus le volume commandé est élevé, meilleure est la remise
5. Livraison au magasin CAR → les membres récupèrent leur commande

**En Normal** : le joueur achète directement au magasin CAR au prix remisé, sans pré-commande.

### 3.3 Vente groupée

Au-delà du stockage, la CAR peut négocier des contrats de vente pour ses membres.

| Type de contrat | Bonus prix | Engagement membre | Risque |
|----------------|:----------:|:-----------------:|:------:|
| Spot (pas de contrat) | +0% (prix du jour) | Aucun | Prix volatil |
| Contrat saisonnier | +3-5% | Livrer le volume promis | Manque à gagner si prix monte |
| Contrat annuel | +5-8% | Engagement d'apport total | Verrouillé |
| Export (gros volume) | +10-15% | Volume ≥ 5 000 t | Délai paiement long |

### 3.4 Avance de trésorerie et prêts aux membres

La CAR joue un rôle bancaire pour ses membres (comme en réalité : la coopérative avance la trésorerie de campagne).

| Paramètre | Valeur |
|-----------|:------:|
| Prêt maximum par membre | 3× la valeur de ses parts sociales |
| Taux d'intérêt | 2,5% / saison |
| Durée maximum | 4 saisons |
| Garantie | Parts sociales (saisies en cas de défaut) |
| Validation | Conseil d'administration (Expert) / Automatique (Normal) |
| Plafond global CAR | 40% du capital social |

**Exemple** : un membre avec 5 parts (50 000 €) peut emprunter jusqu'à 150 000 € à 2,5%/saison.

### 3.5 Engagement d'apport

Mécanisme central du modèle coopératif : le membre s'engage à livrer un pourcentage de sa production à la CAR.

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Engagement minimum | 0% (facultatif) | 50% de la production |
| Engagement maximum | 100% | 100% |
| Pénalité non-livraison | Aucune | 10% de la valeur non livrée |
| Modification | Libre | Vote AG (annuel) |
| Cultures concernées | Toutes | Toutes (fixé par culture) |

**En Expert** : l'engagement d'apport crée une tension stratégique. Le membre bénéficie des prix CAR (+5 à +12%) mais perd la liberté de vendre au plus offrant sur le marché libre.

### 3.6 Ristourne de fin d'exercice

Le résultat positif de la CAR est redistribué aux membres proportionnellement à leur activité (volume livré), pas à leur capital.

```
ristourne_membre = (volume_livré_membre / volume_livré_total) × montant_ristourne_global
```

| Paramètre | Valeur |
|-----------|:------:|
| Base de calcul | Volume livré (en tonnes ou €) |
| Part redistribuable | 40-80% du résultat net (vote AG) |
| Le reste | Mis en réserve (renforce le capital CAR) |
| Versement | 1 fois / saison (après clôture) |
| Ristourne typique | 5-15 €/t livrée (selon résultat) |

**Exemple** : CAR avec 30 000 € de résultat, 60% en ristourne = 18 000 € répartis. Un membre qui a livré 500 t sur 3 000 t totales reçoit : 18 000 × (500/3000) = 3 000 €.



---

## 4. Sous-activités de transformation (investissements collectifs)

Les sous-activités sont des investissements lourds que seul un collectif peut financer. Elles transforment la matière première des membres en produits à plus forte valeur ajoutée.

### 4.1 Huilerie

**Chaîne** : colza des membres → trituration → huile alimentaire + tourteau + HVC (carburant)

| Paramètre | Valeur |
|-----------|:------:|
| Investissement | 800 000 € |
| Capacité | 3 000 t colza / saison |
| Rendement huile | 420 kg huile / t colza |
| Rendement tourteau | 560 kg tourteau / t colza |
| Rendement HVC | 350 L HVC / t colza |
| Personnel | 2 employés dédiés (2 500 €/mois chacun) |
| Charges exploitation | 15 €/t colza trituré |
| Durée de vie | 20 saisons (amortissement 40 000 €/saison) |

**Produits et prix** :

| Produit | Prix vente marché | Prix membre CAR | Avantage |
|---------|:-:|:-:|:-:|
| Huile alimentaire | 1 200 €/t | 1 000 €/t | -17% pour le membre acheteur |
| Tourteau (aliment bétail) | 350 €/t | 300 €/t | -14% |
| HVC (carburant) | 1,20 €/L | 0,95 €/L | -21% |

**Rentabilité huilerie** (capacité pleine, 3 000 t) :
```
Recettes : 3000 × 420kg × 1,20€/kg + 3000 × 560kg × 0,35€/kg + 3000 × 350L × 1,20€/L
         = 1 512 000 + 588 000 + 1 260 000 = 3 360 000 €
Achat colza membres : 3000 × 450 €/t = 1 350 000 € (prix supérieur au marché)
Charges : 3000 × 15 + 2 × 2500 × 12 + 40 000 = 45 000 + 60 000 + 40 000 = 145 000 €
Résultat huilerie : 3 360 000 - 1 350 000 - 145 000 = 1 865 000 €
```

> Note : les recettes sont très élevées car on vend les 3 produits. Le colza acheté aux membres à 450 €/t (vs 430 marché) = bonus +20 €/t pour le producteur.

### 4.2 Sucrerie

**Chaîne** : betterave des membres → extraction → sucre cristallisé + écume de sucrerie (amendement calcaire)

| Paramètre | Valeur |
|-----------|:------:|
| Investissement | 1 200 000 € |
| Capacité | 20 000 t betterave / saison |
| Rendement sucre | 160 kg sucre / t betterave |
| Rendement écume | 30 kg écume / t betterave |
| Personnel | 3 employés (campagne sept-mars) |
| Charges exploitation | 8 €/t betterave |
| Campagne | 6 mois (septembre → mars) |
| Durée de vie | 25 saisons |

**Produits et prix** :

| Produit | Prix marché | Prix membre CAR | Usage |
|---------|:-:|:-:|---------|
| Sucre cristallisé | 800 €/t | Vendu au marché (recette CAR) | Agroalimentaire |
| Écume de sucrerie | 25 €/t | Gratuit pour les membres | Amendement calcaire (remplace chaux) |

**Bénéfice pour les membres** :
- Prix betterave garanti : 35 €/t (vs 30-32 sur le marché = +10%)
- Écume gratuite (économie 25 €/t × besoins) = ~500-1 500 €/an/membre
- Ristourne sur le résultat de la sucrerie

### 4.3 Laiterie

**Chaîne** : collecte lait des membres → pasteurisation → produits laitiers

| Paramètre | Valeur |
|-----------|:------:|
| Investissement | 1 500 000 € |
| Capacité collecte | 5 000 000 L / saison |
| Produits | Lait conditionné, beurre, yaourts, fromages industriels |
| Personnel | 4 employés |
| Charges exploitation | 0,03 €/L collecté |
| Camion citerne | 150 000 € (collecte quotidienne) |
| Durée de vie | 20 saisons |

**Prix lait payé au membre** :

| Qualité lait | Prix marché | Prix CAR | Bonus |
|:---:|:-:|:-:|:-:|
| Standard | 410 €/1000L | 440 €/1000L | +7% |
| Bon (TB/TP élevé) | 430 €/1000L | 465 €/1000L | +8% |
| Excellent | 450 €/1000L | 490 €/1000L | +9% |

**Avantage** : la laiterie CAR paye le lait 7-9% au-dessus du prix marché car elle capte la marge de transformation.

### 4.4 Méthanisation collective

**Chaîne** : substrats des membres (fumier, lisier, CIVE, résidus) → digesteur → biogaz → électricité + digestat

| Paramètre | Valeur |
|-----------|:------:|
| Investissement | 2 000 000 € |
| Capacité | 15 000 t substrats / saison |
| Production électricité | 2 000 MWh / saison |
| Production digestat | 12 000 t / saison |
| Personnel | 2 employés |
| Charges exploitation | 80 000 € / saison |
| Contrat tarif garanti | 15 saisons (prix fixe électricité) |
| Durée de vie | 20 saisons |

**Économie** :
```
Recettes électricité : 2 000 MWh × 150 €/MWh = 300 000 €/saison
Recettes digestat (vendu aux non-membres) : 2 000 t × 15 €/t = 30 000 €
Total recettes : 330 000 €/saison
Charges : 80 000 + 2 × 2500 × 12 = 140 000 €
Amortissement : 2 000 000 / 20 = 100 000 €
Résultat : 330 000 - 140 000 - 100 000 = 90 000 €/saison
```

**Bénéfice pour les membres** :
- Substrats rachetés à 5 €/t (vs 0 sans méthaniseur — les effluents sont un coût à gérer)
- Digestat gratuit pour les membres (remplace engrais chimique : économie 30-50 €/ha)
- Électricité à -30% pour les membres (0,056 €/kWh vs 0,08 marché)

### 4.5 Synthèse sous-activités

| Sous-activité | Investissement | ROI (saisons) | Bénéfice membre principal |
|:---:|:-:|:-:|:---|
| Huilerie | 800 000 € | 3-4 | HVC -21%, tourteau -14% |
| Sucrerie | 1 200 000 € | 5-6 | Betterave +10%, écume gratuite |
| Laiterie | 1 500 000 € | 6-8 | Lait +7-9% |
| Méthanisation | 2 000 000 € | 8-10 | Digestat gratuit, élec -30% |

**Prérequis** : une sous-activité ne peut être construite que par vote AG (majorité qualifiée 66%). Le financement peut combiner capital propre CAR + emprunt bancaire.



---

## 5. Économie de la CAR

### 5.1 Bilan simplifié

Le bilan de la CAR est visible par tous les membres (transparence coopérative).

```
┌─────────────────────────────────────────────────────────────────┐
│                    BILAN CAR — Exemple                           │
├─────────────────────────────┬───────────────────────────────────┤
│         ACTIF               │         PASSIF                    │
├─────────────────────────────┼───────────────────────────────────┤
│ Silos (valeur nette)  800k  │ Capital social         600k      │
│ Huilerie (valeur nette) 650k│ Réserves accumulées    400k      │
│ Stocks marchandises   200k  │ Emprunts bancaires     500k      │
│ Trésorerie            150k  │ Dettes fournisseurs    100k      │
│ Créances membres       50k  │ Ristourne à verser      50k     │
│ Matériel roulant      100k  │ Résultat exercice      100k      │
├─────────────────────────────┼───────────────────────────────────┤
│ TOTAL ACTIF         1 950k  │ TOTAL PASSIF         1 750k      │
│                             │ Situation nette      + 200k       │
└─────────────────────────────┴───────────────────────────────────┘
```

### 5.2 Compte de résultat (annuel)

| Poste | Montant typique |
|-------|:---:|
| **Produits** | |
| Marge sur collecte/vente | +180 000 € |
| Marge magasin approvisionnement | +60 000 € |
| Résultat sous-activités | +90 000 € |
| Intérêts sur prêts aux membres | +15 000 € |
| **Total produits** | **+345 000 €** |
| **Charges** | |
| Personnel CAR | -120 000 € |
| Amortissements | -80 000 € |
| Charges financières (emprunt) | -25 000 € |
| Frais généraux | -20 000 € |
| **Total charges** | **-245 000 €** |
| **Résultat net** | **+100 000 €** |

### 5.3 Répartition du résultat (vote AG)

| Affectation | Fourchette | Décision |
|:---:|:-:|:-:|
| Ristourne aux membres | 40-80% | Vote AG (Expert) / 60% auto (Normal) |
| Réserves légales | 10-20% | Obligatoire (minimum 10%) |
| Investissement / remboursement dettes | 10-40% | Vote AG |
| Report à nouveau | 0-10% | Solde |

### 5.4 Faillite de la CAR

**Conditions de déclenchement** :
- Trésorerie < 0 pendant 3 mois consécutifs
- ET incapacité de rembourser les échéances bancaires
- ET pas de plan de redressement voté en AG extraordinaire

**Conséquences** :
1. Liquidation des actifs (vente aux enchères automatique)
2. Remboursement des créanciers (banque d'abord)
3. Remboursement des parts sociales au prorata du solde restant (peut être < valeur nominale)
4. Les membres récupèrent leurs stocks non vendus
5. Cooldown : les ex-membres ne peuvent pas fonder une nouvelle CAR pendant 2 saisons

**En mode Normal** : la faillite est quasi-impossible (le PNJ-président gère prudemment, pas d'investissement risqué). Si elle survient malgré tout : les parts sont remboursées à 80% minimum (protection ADR-002).

---

## 6. Le CIA (Centre d'Insémination Artificielle)

### 6.1 Positionnement

Le CIA peut être :
- **Une sous-activité de la CAR** (financé collectivement, géré par le conseil)
- **Un métier indépendant** (1 joueur entrepreneur, sans lien coopératif)

Les deux modèles coexistent. Le CIA-CAR a l'avantage du capital collectif ; le CIA indépendant a la liberté tarifaire totale.

### 6.2 Fonctionnement

| Paramètre | CIA-CAR | CIA indépendant |
|-----------|:-------:|:---------------:|
| Investissement initial | 300 000 € (voté AG) | 300 000 € (capital propre) |
| Taureaux reproducteurs | 3-10 | 1-5 |
| Prix d'un taureau élite | 20 000 - 80 000 € | Idem |
| Prélèvements / taureau / mois | 20 doses | 20 doses |
| Durée de vie reproductive | 8 saisons | 8 saisons |
| Personnel (inséminateur) | 1 employé | Le joueur ou 1 employé |
| Stockage doses (azote liquide) | 2 000 doses max | 1 000 doses max |

### 6.3 Catalogue et génétique

Chaque taureau a des **indices génétiques** qui déterminent la qualité de la descendance :

| Indice | Effet sur la descendance | Fourchette |
|--------|:---:|:-:|
| Lait (ISU lait) | Production laitière | 80-160 |
| Morphologie | Conformation, longévité | 80-140 |
| Croissance (ISEVR) | GMQ, poids adulte | 80-150 |
| Fertilité | Taux de réussite insémination | 85-110% |

**Catalogue visible par tous les joueurs** :
```
┌─────────────────────────────────────────────────────────────────────┐
│  🐂 CATALOGUE CIA — Coopérative Beauce Céréales                     │
├──────┬────────────┬──────┬───────┬──────────┬────────┬─────────────┤
│  #   │ Nom        │ Race │ Lait  │ Morpho   │ Fertil │ Prix/dose   │
├──────┼────────────┼──────┼───────┼──────────┼────────┼─────────────┤
│  01  │ OLYMPUS    │ Hol. │  152  │   125    │  98%   │    85 €     │
│  02  │ TONNERRE   │ Hol. │  138  │   132    │  102%  │    65 €     │
│  03  │ GRANIT     │ Norm.│  120  │   140    │  105%  │    55 €     │
│  04  │ HERCULE    │ Char.│   —   │   148    │  95%   │    70 €     │
│  05  │ MISTRAL    │ Lim. │   —   │   142    │  100%  │    60 €     │
├──────┴────────────┴──────┴───────┴──────────┴────────┴─────────────┤
│  📦 Stock disponible : 347 doses  │  🚚 Livraison : 15 min          │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.4 Prix et contrats

| Mode de vente | Prix | Avantage |
|:---:|:-:|:---|
| Dose unitaire | Prix catalogue (libre) | Flexibilité |
| Contrat annuel (≥ 20 doses) | -10% | Volume garanti pour le CIA |
| Contrat membre CAR | -15% | Fidélisation, avantage coopératif |
| Dose taureau jeune (non prouvé) | -40% | Risque génétique, mais potentiel |

**Économie du CIA** :
```
Investissement : 300 000 € (bâtiment + 5 taureaux à 40 000 € en moyenne)
Production : 5 taureaux × 20 doses/mois × 12 mois = 1 200 doses/saison
Prix moyen dose : 65 €
Recettes : 1 200 × 65 = 78 000 €/saison
Charges : 1 employé (30 000 €) + alimentation taureaux (15 000 €) + azote (5 000 €) = 50 000 €
Résultat CIA : 78 000 - 50 000 = 28 000 €/saison
ROI : 300 000 / 28 000 ≈ 11 saisons
```

### 6.5 Amélioration génétique

Les taureaux vieillissent. Le CIA doit renouveler son cheptel reproducteur :
- **Achat de taureaux élite** : marché aux enchères entre joueurs ou PNJ (prix selon indices)
- **Élevage de jeunes taureaux** : un éleveur sélectionne ses meilleurs mâles → vente au CIA
- **Évaluation sur descendance** : après 2 saisons, les indices sont confirmés (±10% vs estimation initiale)



---

## 7. Interactions entre CAR

### 7.1 Échanges inter-coopératives

Les CAR d'un même serveur peuvent commercer entre elles.

| Type d'échange | Exemple | Mécanisme |
|:---:|:---|:---|
| Vente de surplus | CAR A (excédent blé) vend à CAR B (déficit) | Offre sur le marché inter-CAR |
| Achat groupé inter-CAR | 3 CAR commandent ensemble l'engrais | Remise supplémentaire -5% |
| Partage de sous-activité | CAR A n'a pas de sucrerie → envoie ses betteraves à CAR B | Contrat inter-CAR (prix négocié) |
| Échange substrats/digestat | CAR céréalière fournit paille à CAR d'élevage pour méthanisation | Contrat bilatéral |

### 7.2 Appels d'offres

Une CAR peut lancer un appel d'offres visible par toutes les autres CAR et les joueurs indépendants :

| Paramètre | Valeur |
|-----------|:------:|
| Durée de l'appel | 7 jours |
| Minimum enchérisseurs | 2 |
| Critères | Prix, volume, délai |
| Commission | 1% (prélevé sur le vendeur) |
| Fréquence max | 2 appels d'offres actifs simultanément |

**Exemples d'appels d'offres** :
- « Recherche 2 000 t de maïs grain, livraison avant le 15 novembre »
- « Besoin de 500 t tourteau soja pour notre élevage CAR »
- « Transport de 3 000 t betterave vers notre sucrerie (20 km) »

### 7.3 Fédération de coopératives (V3)

Mécanisme futur : plusieurs CAR peuvent créer une union de coopératives (type InVivo) pour des investissements très lourds (port d'export, malterie industrielle). Hors scope V2.

---

## 8. Équilibrage

### 8.1 Objectifs d'équilibrage

| Objectif | Cible | Garde-fou |
|----------|:-----:|:---------:|
| Avantage net membre CAR vs solo | +10 à +20% | Pas plus de +20% (sinon solo non-viable) |
| Joueur solo reste viable | Marge nette > 0 sans CAR | ADR-002 : pas de contenu bloqué |
| ROI investissement sous-activité | 5-10 saisons | Pas < 4 (trop facile) ni > 12 (décourageant) |
| Nombre membres optimal | 8-20 | Min 5 (constitution), pas de max dur |
| Monopole régional | Impossible | Max 3 CAR/région + plafond parts de marché |
| Mode Normal = sans friction | Aucun vote, aucune pénalité | PNJ-président gère tout |

### 8.2 Garde-fous anti-monopole

| Mécanisme | Effet |
|:---|:---|
| Maximum 3 CAR par région | Empêche le contrôle total d'un marché local |
| Plafond collecte : 60% du volume régional | Une CAR ne peut pas capter tout le grain de la région |
| Magasin ouvert aux non-membres | Les non-membres peuvent acheter (sans remise) = pas d'exclusion |
| Interdiction d'exclusivité fournisseur | Un membre peut quitter et vendre ailleurs (avec pénalité Expert) |
| Coopérative PNJ toujours disponible | Achat/vente au prix catalogue pour tout joueur, CAR ou pas |

### 8.3 Scénario chiffré : membre CAR vs joueur indépendant

**Profil** : céréalier 150 ha blé, rendement 8 t/ha = 1 200 t/saison.

#### Joueur indépendant (solo)

| Poste | Calcul | Montant |
|-------|--------|--------:|
| **Vente blé** (prix spot moyen) | 1 200 t × 220 €/t | +264 000 € |
| Semences | 150 ha × 80 €/ha | -12 000 € |
| Engrais | 150 ha × 180 €/ha | -27 000 € |
| Phytos | 150 ha × 90 €/ha | -13 500 € |
| HVC (carburant) | 150 ha × 60 €/ha | -9 000 € |
| Charges fixes (salaire, matériel, etc.) | Forfait | -45 000 € |
| **Bénéfice avant charges sociales** | | **+157 500 €** |
| Charges sociales (12% Normal, ADR-002) | 157 500 × 0,12 | -18 900 € |
| **Résultat net** | | **+138 600 €** |

#### Membre CAR (même exploitation)

| Poste | Calcul | Montant |
|-------|--------|--------:|
| **Vente blé via CAR** (prix +8%) | 1 200 t × 237 €/t | +284 400 € |
| Semences CAR (-8%) | 150 ha × 73,6 €/ha | -11 040 € |
| Engrais CAR (-12%) | 150 ha × 158,4 €/ha | -23 760 € |
| Phytos CAR (-10%) | 150 ha × 81 €/ha | -12 150 € |
| HVC CAR (-21%, huilerie) | 150 ha × 47,4 €/ha | -7 110 € |
| Charges fixes (idem) | Forfait | -45 000 € |
| Parts sociales (coût d'entrée, amorti) | 50 000 € / 20 saisons | -2 500 € |
| Ristourne fin d'exercice | ~8 €/t × 1 200 t | +9 600 € |
| **Bénéfice avant charges sociales** | | **+192 440 €** |
| Charges sociales (12% Normal, ADR-002) | 192 440 × 0,12 | -23 093 € |
| **Résultat net** | | **+169 347 €** |

#### Comparaison

| Indicateur | Solo | Membre CAR | Écart |
|:---:|:-:|:-:|:-:|
| Bénéfice avant charges sociales | 157 500 € | 192 440 € | +22% |
| Résultat net (après charges sociales 12%) | 138 600 € | 169 347 € | **+22%** |
| Coût intrants / ha | 350 €/ha | 290 €/ha | -17% |
| Prix de vente effectif | 220 €/t | 245 €/t (spot+ristourne) | +11% |

**Constat** : l'avantage reste à +22% après charges sociales (proportionnel). C'est légèrement au-dessus de la cible (+20% max). 

**Correction d'équilibrage** : réduire le bonus de vente groupée de +8% à +6% pour les volumes < 3 000 t. Nouveau calcul : 1 200 t × 233 €/t = 279 600 €. Bénéfice ajusté = 187 640 €. Charges sociales (12%) = 22 517 €. **Résultat net ajusté = 165 123 €**.

Écart après correction : (165 123 - 138 600) / 138 600 = **+19,1%**. ✅ Dans la cible 15-20%.

### 8.4 Mockup — Tableau de bord CAR (président/admin)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🏛️  CAR BEAUCE CÉRÉALES — Tableau de bord          Saison 12 │ Mois 8 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  👥 MEMBRES : 14 actifs │ 2 candidatures en attente                     │
│  💰 TRÉSORERIE : 312 450 € │ Capital social : 680 000 €                │
│  📊 RÉSULTAT COURANT : +87 200 € (projection fin saison : +105 000 €)  │
│                                                                         │
├──────────────────────────────┬──────────────────────────────────────────┤
│  📦 SILOS                    │  🏭 SOUS-ACTIVITÉS                       │
│  ├─ Blé : 4 200 / 5 000 t   │  ├─ Huilerie : 78% capacité ✅           │
│  ├─ Colza : 1 800 / 2 500 t │  ├─ Sucrerie : campagne en cours 🔄      │
│  ├─ Orge : 900 / 2 500 t    │  ├─ Méthanisation : 92% capacité ✅      │
│  └─ Maïs : 0 / 2 500 t      │  └─ CIA : 347 doses en stock             │
│      Occupation : 55%        │                                          │
├──────────────────────────────┼──────────────────────────────────────────┤
│  🛒 MAGASIN (ce mois)        │  📋 DÉCISIONS EN COURS                   │
│  ├─ Engrais vendus : 340 t   │  ├─ 🗳️ Investir laiterie (AG, 4j rest.) │
│  ├─ Semences : 120 t         │  ├─ 👤 Admission "FermeduBois" (conseil)│
│  ├─ HVC : 45 000 L           │  └─ 💲 Révision tarif phytos (conseil)  │
│  └─ Marge mois : +18 400 €  │                                          │
├──────────────────────────────┴──────────────────────────────────────────┤
│  📈 HISTORIQUE RÉSULTAT                                                  │
│  S9: +62k │ S10: +78k │ S11: +95k │ S12 (en cours): +87k               │
│  Ristourne S11 : 57 000 € versés (60% du résultat)                     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 8.5 Mockup — Écran de vote AG

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🗳️  ASSEMBLÉE GÉNÉRALE — CAR Beauce Céréales                           │
│  Session annuelle │ Saison 12 │ Fin du vote : 3 jours 14h              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  QUESTION 1/4 — Répartition du résultat (95 000 €)                     │
│  ─────────────────────────────────────────────────────                  │
│  Proposition du conseil :                                               │
│    • Ristourne aux membres : 60% (57 000 €)                            │
│    • Réserves : 15% (14 250 €)                                         │
│    • Investissement (extension silo) : 25% (23 750 €)                  │
│                                                                         │
│  ┌─────────────────────────────────────────────┐                        │
│  │  ✅ POUR : 9 voix (69%)                      │                       │
│  │  ❌ CONTRE : 3 voix (23%)                    │                       │
│  │  ⬜ ABSTENTION : 1 voix (8%)                 │                       │
│  │  ⏳ N'a pas voté : 1 membre                  │                       │
│  └─────────────────────────────────────────────┘                        │
│  Quorum atteint ✅ (13/14 = 93%)  │  Majorité requise : >50%           │
│  ➡️ RÉSULTAT PROVISOIRE : ADOPTÉ                                        │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  QUESTION 2/4 — Investissement laiterie (1 500 000 €)                  │
│  ─────────────────────────────────────────────────────                  │
│  Financement proposé : 500 000 € fonds propres + 1 000 000 € emprunt  │
│  Majorité requise : 66% (investissement ≥ 500 000 €)                   │
│                                                                         │
│  [ 🟢 POUR ]    [ 🔴 CONTRE ]    [ ⚪ ABSTENTION ]                      │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  QUESTION 3/4 — Élection président (mandat 1 an)                       │
│  Candidats : 🧑‍🌾 AgriMax (sortant) │ 🧑‍🌾 ChampsLibres                   │
│                                                                         │
│  QUESTION 4/4 — Engagement d'apport S13 : maintien à 60% ?            │
├─────────────────────────────────────────────────────────────────────────┤
│  💬 Forum AG : 23 messages │ [Écrire un message]                        │
└─────────────────────────────────────────────────────────────────────────┘
```

### 8.6 Checklist playtest

| Test | Critère | Bloquant ? |
|:---|:---|:-:|
| Test recette SimAgri | Un joueur SimAgri dit "c'est SimAgri en mieux, pas plus dur" | ✅ Oui |
| Joueur solo viable | Un joueur sans CAR peut progresser normalement | ✅ Oui (ADR-002) |
| Avantage CAR ∈ [10%, 20%] | Vérifier que le bonus n'est ni trop faible ni trop fort | ✅ Oui |
| Mode Normal sans friction | Aucun vote, aucune pénalité, PNJ gère tout | ✅ Oui (ADR-001) |
| Chaque serveur internement équilibré | Le serveur Expert est viable en lui-même (ADR-005) | ✅ Oui |
| Pas de monopole | 1 CAR ne peut pas bloquer le marché d'une région | ✅ Oui |
| Faillite CAR = pas de perte totale | Les parts sont remboursées (au moins partiellement) | ✅ Oui |
| CIA indépendant viable | Un joueur CIA solo gagne sa vie sans être en CAR | ✅ Oui (ADR-002) |
| Gouvernance fluide | Les votes se résolvent en 72h-7j, pas de blocage | ⚠️ Important |
| 5 joueurs suffisent à créer une CAR fun | Pas besoin de 20 joueurs pour que ça fonctionne | ⚠️ Important |

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|:---|:---:|:---:|
| Adhésion | 1 clic, immédiat | Candidature → vote conseil |
| Engagement d'apport | 0% (facultatif) | 50-100% (obligatoire) |
| Pénalité non-livraison | Aucune | 10% valeur non livrée |
| Gouvernance | PNJ-président automatique | Élections, votes, AG |
| Ristourne | Versée automatiquement (60%) | Vote AG sur la répartition |
| Sous-activités | Bénéficier des prix | Gérer production + investir |
| Bilan/comptabilité | Non affiché | Complet (actif/passif/résultat) |
| Sortie | Libre, remboursement immédiat | Préavis 1 saison, progressif |
| Prêts | Automatique (sous plafond) | Vote conseil + garanties |
| Tarifs magasin | Fixés par le PNJ | Fixés par vote conseil |
| Admission nouveaux membres | Automatique | Vote conseil (majorité simple) |
| Exclusion | Impossible en Normal | Vote AG (majorité qualifiée) |
| Faillite | Protégée (remboursement 80% min) | Possible (remboursement au prorata) |
| Appels d'offres | Non disponible | Disponible |
| Investissements lourds | PNJ décide si pertinent | Vote AG (majorité 66%) |

---

## Historique des révisions

| Date | Modification | Raison |
|:----:|:-------------|:-------|
| 2026-08-04 | Création initiale | Rédaction GDD CAR + CIA |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |

