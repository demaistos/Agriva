# 08 — ÉQUILIBRAGE ÉCONOMIQUE

> **Game Designer + Économiste** — Résolution des problèmes E1-E5 de l'AUDIT_FINAL
> Date : 2026-04-05

---

## 1. DÉCISION — Kits de démarrage par style de jeu

**Problème :** Un joueur débutant (100 000€ + prêt 150 000€ = 250 000€) ne peut pas acheter le matériel minimum viable. La moissonneuse seule coûte 180 000€.

**Solution retenue :** À l'inscription, après le choix de la préfecture, le joueur choisit **1 kit de démarrage parmi 3** selon son style de jeu préféré. Le kit est gratuit, unique, et ne peut pas être changé. Le matériel du kit est usé (40-60%) mais fonctionnel, avec 50% de durée de vie déjà consommée.

---

### 1.1 Kit Cultivateur 🌾

> *« Tu veux labourer, semer et récolter. La terre est ton outil. »*

Idéal pour les joueurs qui veulent se concentrer sur les cultures.

| Matériel | Caractéristiques | Usure | Argus |
|----------|-----------------|-------|-------|
| Tracteur 90 CV | Verdant V90 | 50% | 17 000€ |
| Charrue 4 corps | Novaterra C4 | 40% | 4 080€ |
| Herse rotative 3m | Aureus HR3 | 40% | 6 120€ |
| Semoir 3m | Feldmark S3 | 40% | 7 650€ |
| Épandeur engrais 12m | Castor E12 | 40% | 3 060€ |
| Pulvérisateur 12m | Verdant P12 | 40% | 4 080€ |
| Moissonneuse 280 CV | Aureus M280 | 60% | 51 000€ |
| Benne 10T | Novaterra B10 | 40% | 5 100€ |
| Plateau 6T | Feldmark PL6 | 40% | 2 040€ |
| **Total argus** | | | **100 130€** |

Bâtiments offerts : Hangar 100m² (niv.1) + Silo 20T + Entrepôt 50m²

**Le joueur peut cultiver immédiatement** : déchaumer, labourer, herser, semer, traiter, épandre, récolter, transporter. Il n'a besoin d'acheter que les semences, engrais et traitements.

---

### 1.2 Kit Éleveur 🐄

> *« Tu veux élever des animaux, les nourrir, les soigner. Le troupeau est ta fierté. »*

Idéal pour les joueurs qui veulent se concentrer sur l'élevage bovin.

| Matériel | Caractéristiques | Usure | Argus |
|----------|-----------------|-------|-------|
| Tracteur 80 CV | Verdant V80 | 50% | 14 875€ |
| Benne 10T | Novaterra B10 | 40% | 5 100€ |
| Plateau 6T | Feldmark PL6 | 40% | 2 040€ |
| Bétaillère 5T | Castor BT5 | 40% | 4 080€ |
| Épandeur fumier 8T | Novaterra EF8 | 40% | 3 570€ |
| Pailleuse | Aureus PA1 | 40% | 2 550€ |
| Désileuse | Feldmark D1 | 40% | 3 060€ |
| Faucheuse 2.5m | Verdant F25 | 40% | 2 550€ |
| Citerne lait 2500L | Joskin 2500 | 40% | 4 800€ |
| **Total argus** | | | **42 625€** |

Bâtiments offerts : Hangar 50m² (niv.1) + Stabulation 100m² (niv.1) + Silo 10T + Fosse fumier 20T + Citerne eau 10 000L + Salle traite 4 postes + Cuve lait 500L

Animaux offerts : **4 vaches Montbéliarde** (2 ans, prêtes à inséminer) + **1 taureau Montbéliard** (3 ans)

> Le joueur choisit son espèce principale après avoir sélectionné le kit Éleveur :
> - 🐄 **Bovin laitier** (défaut) → Montbéliarde + stabulation + salle traite + cuve lait + citerne lait
> - 🐄 **Bovin allaitant** → Charolaise + stabulation (pas de salle traite/cuve/citerne, +parcelle pré 5ha) + **prime installation 10 000€**. ⚠️ Pas de revenus réguliers. Premiers revenus après ~18 mois. Recommandé joueurs expérimentés.
> - 🐐 **Caprin** → Alpine + chèvrerie (remplace stabulation) + salle traite + cuve lait + citerne lait
> - 🐑 **Ovin** → Lacaune + bergerie (remplace stabulation) + salle traite + cuve lait + citerne lait
> - 🐔 **Volailles** → Leghorn ×50 + utilitaire (remplace bétaillère) + poulailler (remplace stabulation) + salle conditionnement + stockage œufs (pas de salle traite/cuve/citerne)
> - 🐷 **Porcin** → Large White ×10 + porcherie (remplace stabulation, pas de salle traite/cuve/citerne)

**Le joueur peut élever immédiatement** : nourrir, abreuver, pailler, traire, mettre au pré, inséminer. Il devra acheter du foin/maïs et une parcelle de pré.

> ⚠️ **Note audit infra** : Le kit Éleveur n'inclut pas de citerne à lait (véhicule de transport). Le joueur pourra traire et stocker dans la cuve lait 500L, mais pour vendre au Marché Central (F024), il devra acheter une citerne à lait. Documenter dans le tutoriel d'onboarding.

---

### 1.3 Kit Polyvalent ⚖️

> *« Tu veux un peu de tout. Cultures et élevage, à toi de choisir ta voie. »*

Idéal pour les joueurs indécis ou qui veulent explorer.

| Matériel | Caractéristiques | Usure | Argus |
|----------|-----------------|-------|-------|
| Tracteur 80 CV | Verdant V80 | 50% | 14 875€ |
| Charrue 3 corps | Novaterra C3 | 45% | 2 805€ |
| Herse rotative 2.5m | Aureus HR25 | 45% | 3 960€ |
| Semoir 2.5m | Feldmark S25 | 45% | 4 950€ |
| Moissonneuse 250 CV | Aureus M250 | 65% | 37 800€ |
| Benne 8T | Novaterra B8 | 45% | 3 740€ |
| Plateau 6T | Feldmark PL6 | 45% | 1 870€ |
| Bétaillère 4T | Castor BT4 | 45% | 2 970€ |
| **Total argus** | | | **72 970€** |

Bâtiments offerts : Hangar 80m² (niv.1) + Stabulation 50m² (niv.1) + Silo 15T + Entrepôt 30m² + Citerne eau 5 000L

Animaux offerts : **2 vaches Prim'Holstein** (2 ans)

**Le joueur peut cultiver ET élever** mais avec du matériel plus modeste. Il devra investir pour se spécialiser.

---

### 1.4 Règles communes aux 3 kits

| Règle | Détail |
|-------|--------|
| Choix | 1 seul kit par joueur, choisi à l'inscription, irréversible |
| Matériel | Usé mais fonctionnel, revendable (à l'argus) |
| Bâtiments | Niveau 1, construction instantanée |
| Animaux (si inclus) | Génétique moyenne, nés hors ferme |
| Parcelle | NON incluse — le joueur achète sa première parcelle avec son solde |
| ETA Cultivia (PNJ) | Disponible pour tous — filet de sécurité si matériel en panne ou manquant |

### 1.5 Écran de choix du kit

```
┌─────────────────────────────────────────────────────────┐
│  Bienvenue sur Cultivia ! Choisis ton kit de démarrage  │
│                                                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │
│  │  🌾          │ │  🐄          │ │  ⚖️          │      │
│  │ CULTIVATEUR  │ │   ÉLEVEUR   │ │ POLYVALENT  │      │
│  │             │ │             │ │             │      │
│  │ Tracteur 90 │ │ Tracteur 80 │ │ Tracteur 80 │      │
│  │ Moissonneuse│ │ 4 vaches    │ │ Moissonneuse│      │
│  │ Charrue     │ │ 1 taureau   │ │ 2 vaches    │      │
│  │ Semoir      │ │ Stabulation │ │ Charrue     │      │
│  │ Pulvériseur │ │ Salle traite│ │ Semoir      │      │
│  │ ...         │ │ ...         │ │ ...         │      │
│  │             │ │             │ │             │      │
│  │ [Choisir]   │ │ [Choisir]   │ │ [Choisir]   │      │
│  └─────────────┘ └─────────────┘ └─────────────┘      │
│                                                         │
│  ⚠️ Ce choix est définitif. Tu pourras te diversifier   │
│  plus tard en achetant du matériel supplémentaire.      │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Budget débutant après kit

| Poste | Montant |
|-------|---------|
| Solde initial | 100 000€ |
| Kit de démarrage (gratuit) | 0€ |
| **Budget disponible pour parcelle + intrants** | **100 000€** |
| Prêt disponible (si besoin) | 150 000€ |
| **Budget max théorique** | **250 000€** |

### 1.3 Dépenses obligatoires au démarrage

| Achat | Coût |
|-------|------|
| Parcelle 10 ha (Q2, coeff 1.0) | 45 000€ |
| Silo 100T | 5 000€ |
| Hangar 200m² (abriter le matériel) | 3 000€ |
| Cuve HVC 2000L | 1 000€ |
| HVC 1000L (stock initial) | 600€ |
| Semences blé 10 ha (150 kg/ha × 0.35€) | 525€ |
| Engrais NPK 10 ha | 1 350€ |
| **Total dépenses démarrage** | **56 475€** |
| **Reste après démarrage (sans prêt)** | **43 525€** |

Le joueur démarre avec 43 525€ de trésorerie — confortable pour survivre la première saison.

---

## 2. ETA CULTIVIA — PNJ (filet de sécurité)

L'ETA Cultivia est un service PNJ disponible dès Phase 1. Le joueur qui n'a pas de matériel (ou dont le matériel est en panne) peut faire appel à l'ETA pour effectuer les travaux.

### 2.1 Tarifs ETA Cultivia (PNJ)

| Travail | Tarif/ha | HT joueur | Matériel joueur requis |
|---------|----------|-----------|----------------------|
| Labour | 80€/ha | 0.5 HT (supervision) | Aucun |
| Hersage | 50€/ha | 0.5 HT | Aucun |
| Semis | 60€/ha | 0.5 HT | Aucun |
| Récolte (moissonneuse) | 120€/ha | 0.5 HT | Aucun |
| Épandage engrais | 40€/ha | 0.5 HT | Aucun |
| Traitement phyto | 45€/ha | 0.5 HT | Aucun |

**Règles :**
- Disponible dans toutes les préfectures (PNJ omniscient)
- Tarifs fixes, non négociables, ~30% plus cher que le coût réel avec son propre matériel
- Le joueur paie en € mais économise ses HT (0.5 HT supervision vs 2-4 HT en propre)
- Pas de file d'attente (PNJ toujours disponible)
- L'ETA Cultivia disparaît progressivement quand des ETA joueurs (Phase 3) s'installent dans la zone

### 2.2 Coût ETA vs coût propre (10 ha de blé)

| Opération | Coût propre (HVC + usure) | Coût ETA | Surcoût ETA |
|-----------|--------------------------|----------|-------------|
| Labour | ~15€ HVC + usure | 800€ | +785€ |
| Hersage | ~10€ HVC + usure | 500€ | +490€ |
| Semis | ~10€ HVC + usure | 600€ | +590€ |
| Récolte | ~25€ HVC + usure | 1 200€ | +1 175€ |
| **Total** | **~60€** | **3 100€** | **+3 040€** |

L'ETA est un filet de sécurité coûteux — le joueur est fortement incité à utiliser son propre matériel.

---

## 3. SIMULATION — PREMIER MOIS D'UN DÉBUTANT (jour par jour)

**Hypothèses :** Serveur France, inscription en début de printemps (mois 4 = Mars), 10 ha blé, sol Q2, pas d'engrais la première fois.

### 3.1 Semaine 1 (Mois 4 — Mars, jours 22-28)

| Jour | Action | HT | € dépensés | € gagnés | Solde € | HT restants |
|------|--------|----|-----------|----------|---------|-------------|
| J22 | Inscription + création ferme | 0 | 0 | 0 | 100 000 | 40 |
| J22 | Achat parcelle 10 ha | 1 (marché) | 45 000 | 0 | 55 000 | 39 |
| J22 | Achat silo 100T + hangar + cuve HVC | 2 | 9 000 | 0 | 46 000 | 37 |
| J22 | Achat HVC 1000L | 0.5 | 600 | 0 | 45 400 | 36.5 |
| J22 | Achat semences blé 10 ha | 0.5 | 525 | 0 | 44 875 | 36 |
| J23 | Labour 10 ha (tracteur 80CV + charrue 4c, 1.4m) | 7.1 | ~8€ HVC | 0 | 44 867 | 32.9 |
| J24 | Hersage 10 ha (herse 3m) | 3.3 | ~6€ HVC | 0 | 44 861 | 36.7 |
| J24 | Semis 10 ha (semoir 3m) | 3.3 | ~6€ HVC | 0 | 44 855 | 33.4 |
| J25-28 | Attente pousse (exploration, marché) | 0 | 0 | 0 | 44 855 | 40/j |

**Fin mois 4 :** Solde ~44 855€, blé en pousse, matériel fonctionnel.

### 3.2 Semaines 2-6 (Mois 5-6 — Avril-Mai, jours 29-42)

| Période | Action | Coût € | Solde € |
|---------|--------|--------|---------|
| Mois 5 J1 | Charges mensuelles (taxe foncière 10ha × 5€) | 50€ | 44 805 |
| Mois 5 | Entretien matériel (6 matériels × 1 HT, 0€) | 0€ | 44 805 |
| Mois 5 | Entretien bâtiments (3 × 0.3 HT, 0€) | 0€ | 44 805 |
| Mois 6 J1 | Charges mensuelles | 50€ | 44 755 |
| Mois 5-6 | Blé pousse automatiquement (tick) | 0€ | 44 755 |

**Fin printemps :** Solde ~44 755€, blé à ~75% de pousse.

### 3.3 Semaine 7-9 (Mois 7-8 — Juin-Juillet, jours 43-56)

| Période | Action | Coût € | Revenu € | Solde € |
|---------|--------|--------|----------|---------|
| Mois 7 J1 | Charges mensuelles | 50€ | | 44 705 |
| ~J50 | Blé mature (100%) | 0 | | 44 705 |
| ~J51 | Récolte 10 ha (moissonneuse + benne) | ~25€ HVC | | 44 680 |
| ~J52 | Vente blé à la Coop | 0.5 HT | | voir ci-dessous |

**Calcul rendement :**
- Base IDF : 7.7 T/ha
- Sol Q2 : ×0.85 = 6.55
- Pas d'engrais : ×1.0
- Pas de traitement (×0.95³) : ×0.857 = 5.61
- Météo moyenne : ×0.85 = 4.77
- Pierres ~20 : ×0.99 = 4.72 T/ha
- **Total 10 ha : 47.2 T**

**Calcul revenu :**
- Prix Coop blé Q2 en été (saison récolte) : 100 × 1.00 × 0.90 = 90€/T
- **Revenu brut : 47.2 × 90 = 4 248€**

| | Montant |
|---|---|
| Revenu récolte | +4 248€ |
| Solde après vente | **48 928€** |

### 3.4 Bilan premier cycle (3 mois Cultivia = 21 jours réels)

| Poste | Montant |
|-------|---------|
| Solde initial | 100 000€ |
| Parcelle + bâtiments + intrants | -56 475€ |
| HVC consommé | -45€ |
| Charges mensuelles (3 mois × 50€) | -150€ |
| Revenu récolte blé | +4 248€ |
| **Solde fin saison 1** | **~47 578€** |
| **Patrimoine total** (solde + argus kit + parcelle + bâtiments) | **~200 623€** |

**✅ ROI première saison : POSITIF.** Le joueur a 47 578€ de trésorerie, n'a pas eu besoin de prêt, et peut réinvestir (engrais, 2e parcelle, meilleur matériel).

---

## 4. SIMULATION — JOUEUR À 6 MOIS (42 jours réels = 6 mois Cultivia)

**Profil :** 30 ha de cultures (blé + colza rotation), matériel partiellement upgradé, 1 employé chauffeur.

### 4.1 Patrimoine à 6 mois

| Actif | Valeur |
|-------|--------|
| Solde bancaire | ~35 000€ |
| 3 parcelles (10+10+10 ha) | 135 000€ |
| Matériel (kit usé + quelques achats neufs) | ~120 000€ argus |
| Bâtiments (silo 200T, hangar 400m², cuve) | ~15 000€ |
| Stock récoltes en silo | ~8 000€ |
| **Patrimoine total** | **~313 000€** |

### 4.2 Revenus vs charges mensuels (moyenne)

| Revenus | €/mois |
|---------|--------|
| Vente blé 20 ha (2 récoltes/an, ~94T, étalé) | ~1 410€ |
| Vente colza 10 ha (1 récolte/an, ~25T, étalé) | ~915€ |
| **Total revenus** | **~2 325€/mois** |

| Charges | €/mois |
|---------|--------|
| Taxe foncière (30 ha × 5€) | 150€ |
| MSA (5% CA) | ~116€ |
| Salaire employé | 1 600€ |
| HVC | ~50€ |
| Semences + engrais (amorti) | ~200€ |
| Remboursement prêt (si 80k€ emprunté) | ~1 900€ |
| **Total charges** | **~4 016€/mois** |

**⚠️ Déficit mensuel : ~1 691€/mois** — Normal à 6 mois, le joueur est en phase d'investissement. La trésorerie de 35 000€ couvre ~20 mois de déficit. Le prêt sera remboursé en 48 mois, après quoi les charges tombent à ~2 116€/mois → excédent.

---

## 5. SIMULATION — JOUEUR À 1 AN (84 jours réels)

**Profil :** 50 ha, rotation blé/colza/pois, matériel neuf, 2 employés, début élevage (10 vaches).

### 5.1 Patrimoine à 1 an

| Actif | Valeur |
|-------|--------|
| Solde bancaire | ~20 000€ |
| 5 parcelles (50 ha) | 225 000€ |
| Matériel (neuf + occasion) | ~200 000€ argus |
| Bâtiments | ~40 000€ |
| 10 vaches laitières | ~15 000€ |
| Stock récoltes | ~12 000€ |
| Épargne (si placée) | ~10 000€ |
| **Patrimoine total** | **~522 000€** |

### 5.2 Revenus vs charges mensuels

| Revenus | €/mois |
|---------|--------|
| Cultures 50 ha (blé/colza/pois) | ~4 500€ |
| Lait 10 vaches (~280L/j × 0.32€) | ~627€ |
| **Total revenus** | **~5 127€/mois** |

| Charges | €/mois |
|---------|--------|
| Taxe foncière 50 ha | 250€ |
| MSA 5% | ~256€ |
| 2 salaires employés | 3 200€ |
| Alimentation vaches | ~200€ |
| HVC + énergie | ~80€ |
| Intrants cultures | ~350€ |
| Remboursement prêt | ~1 900€ |
| **Total charges** | **~6 236€/mois** |

**Déficit : ~1 109€/mois** — Encore en phase d'investissement. Le prêt sera soldé vers le mois 48 (fin année 4 Cultivia). Après remboursement : excédent de ~791€/mois, croissant avec l'optimisation des rendements et l'ajout de vaches.

---

## 6. SINKS ET FAUCETS

### 6.1 Faucets (sources d'argent)

| Faucet | Montant estimé | Fréquence | Phase |
|--------|---------------|-----------|-------|
| Solde initial | 100 000€ | 1 fois | 0 |
| Vente récoltes (Coop) | 90-250€/T | Par récolte | 1 |
| Vente lait | 320€/1000L | Quotidien | 2 |
| Vente animaux | 500-3 000€/tête | Ponctuel | 2 |
| Vente entre joueurs (marché) | Prix libre | Ponctuel | 3 |
| Intérêts épargne | 3-6%/an, plafond 100k€ | Mensuel | 0 |
| Prêt bancaire | Max 150 000€ | Ponctuel | 0 |
| Objectifs hebdomadaires | +5 HT ou ~200€ | Hebdo | 1 |
| Contrats de filière | Prix garanti | Mensuel | 3 |

### 6.2 Sinks (sorties d'argent)

| Sink | Montant estimé | Fréquence | Phase |
|------|---------------|-----------|-------|
| Achat parcelles | 3 150-6 750€/ha | Ponctuel | 1 |
| Achat matériel neuf | 6 000-280 000€ | Ponctuel | 1 |
| Semences + engrais + traitements | 50-350€/ha/cycle | Par culture | 1 |
| HVC (carburant) | 0.60€/L | Par action | 1 |
| Taxe foncière | 5€/ha/mois | Mensuel | 1 |
| MSA (cotisations) | 5% du CA | Mensuel | 1 |
| Salaires employés | 1 600€/mois/employé | Mensuel | 3 |
| Remboursement prêt + intérêts | Variable | Mensuel | 0 |
| Réparations matériel | 100-500€/pièce | Ponctuel | 1 |
| Alimentation animaux | Variable | Quotidien | 2 |
| Vétérinaire | 50-200€/intervention | Ponctuel | 2 |
| Licence ETA | 5 000€/an | Annuel | 3 |
| Coût annonces marché | 800€/annonce | Ponctuel | 3 |
| Transport marchandises | 0.02€/kg/km | Par livraison | 3 |
| **Transport joueur (bétaillère)** | **0.50€/km + 0.15L HVC/km** | **Par trajet** | **1** |
| **Transport joueur (benne/plateau)** | **0.30€/km + 0.20L HVC/km** | **Par trajet** | **1** |
| **Transport joueur (citerne lait)** | **0.30€/km + 0.20L HVC/km** | **Par trajet** | **1** |
| **Livraison concessionnaire** | **0.80€/km** | **Par livraison** | **3** |
| Taxe plus-value parcelles | 5-15% | À la vente | 3 |
| Énergie bâtiments | 0.08€/kWh | Mensuel | 1 |

### 6.3 Équilibre macro-économique

| Phase joueur | Revenus/mois | Charges/mois | Balance | Commentaire |
|-------------|-------------|-------------|---------|-------------|
| Débutant (10 ha, mois 1-3) | ~1 400€ | ~100€ | +1 300€ | Investissement initial absorbé |
| Croissance (30 ha, mois 4-6) | ~2 325€ | ~4 016€ | -1 691€ | Phase d'investissement, prêt actif |
| Établi (50 ha + vaches, mois 7-12) | ~5 127€ | ~6 236€ | -1 109€ | Prêt en cours, rentable après remboursement |
| Mature (50 ha + 20 vaches, an 2+) | ~6 500€ | ~4 500€ | +2 000€ | Prêt soldé, croissance organique |

---

## 7. GARDE-FOUS DU MARCHÉ À TERME

Résolution du problème E5 de l'audit.

### 7.1 Limites de position

| Règle | Valeur |
|-------|--------|
| Max tonnes par joueur par produit | 500 T |
| Max contrats ouverts par joueur | 10 |
| Max valeur totale engagée | 50% du patrimoine |

### 7.2 Marge de garantie

- À la signature d'un contrat à terme, **20% de la valeur** est bloqué sur le compte du vendeur ET de l'acheteur
- Si le solde descend sous la marge → appel de marge (24h pour renflouer ou liquidation automatique)

### 7.3 Circuit breaker

| Règle | Valeur |
|-------|--------|
| Variation max journalière par produit | ±15% |
| Si atteint → marché suspendu pour ce produit | 24h (1 jour Cultivia) |
| Alerte admin si 3 suspensions en 1 mois | Oui |

### 7.4 Pénalité de non-livraison

| Situation | Pénalité |
|-----------|----------|
| Non-livraison à échéance | 20% de la valeur du contrat (existant) |
| + Marge de garantie perdue | 20% supplémentaire |
| + Impact réputation | -5 points réputation |
| **Total pénalité effective** | **40% + réputation** |

### 7.5 Transparence

- Historique des prix sur 30 jours visible par tous
- Volume échangé par produit visible
- Carnet d'ordres anonymisé (quantités visibles, pas les noms)

---

## 8. CONSTANTES ÉCONOMIQUES MISES À JOUR

| Constante | Ancienne valeur | **Nouvelle valeur** | Justification |
|-----------|----------------|--------------------|----|
| Solde initial | 100 000€ | **100 000€** | Inchangé — le kit compense |
| Prêt max | 120 000€ | **150 000€** | Marge pour intrants + 2e parcelle |
| Seuil faillite | -30 000€ | **-30 000€** | Inchangé |
| HT/jour | 40 | **40** | Inchangé |
| Kit démarrage | ∅ | **~100k€ argus matériel usé** | Résout E1 |
| ETA Cultivia (PNJ) | ∅ | **Tarifs fixes, +30% vs coût propre** | Filet de sécurité |

---

*Document créé suite à l'AUDIT_FINAL — Résolution des problèmes E1-E5.*
*Validé par : Game Designer + Économiste — 2026-04-05*

---

## 9. SIMULATION KIT ÉLEVEUR — Budget jour par jour

> Ajouté suite à la réunion plénière finale (M23/B7)

### 9.1 Hypothèses

- Kit Éleveur : 4 vaches Montbéliarde (femelles, 24 mois, en lactation) + 1 taureau
- Production lait : ~28 L/jour/vache (Montbéliarde moyenne)
- Prix lait Marché Central : ~320 €/1000 L

### 9.2 Revenus quotidiens

| Poste | Calcul | Montant/jour |
|-------|--------|-------------|
| Lait | 4 vaches × 28 L × 0,32 €/L | ~35,84 € |

### 9.3 Charges quotidiennes

| Poste | Calcul | Montant/jour |
|-------|--------|-------------|
| Foin/alimentation | 4 vaches × ~12 kg/j × 0,30 €/kg | ~14,40 € |
| Eau | 4 vaches × 80 L/j × 0,005 €/L | ~1,60 € |
| Litière (paille) | ~0,50 €/j | ~0,50 € |
| **Total charges** | | **~16,50 €** |

### 9.4 Bilan

| Période | Revenu | Charges | Profit net |
|---------|--------|---------|-----------|
| Jour | ~35,84 € | ~16,50 € | **~19,34 €** |
| Semaine (1 mois Cultivia) | ~250,88 € | ~115,50 € | **~135,38 €** |
| Mois (4 semaines) | ~1 003 € | ~462 € | **~541 €** |

**Conclusion** : Le kit Éleveur est viable dès le jour 1. Profit net ~19 €/jour, ~135 €/semaine, ~540 €/mois. Comparable au kit Cultivateur (~47 578 € en saison 1 mais avec des revenus concentrés à la récolte). L'Éleveur a un cash flow plus régulier (lait quotidien) mais un plafond de revenus plus bas sans expansion du troupeau.

---

## 10. COÛTS DES NOUVEAUX SYSTÈMES (audit flows 2026-04-06)

### 10.1 Transport (F002, F006, F024, F025, F042)

| Type transport | Coût €/km | HVC L/km | HT/100km | Exemple 80km |
|----------------|-----------|----------|----------|---------------|
| Bétaillère (animaux) | 0.50 | 0.15 | 1.0 | 40€ + 12L + 1.3HT |
| Benne (marchandises) | 0.30 | 0.20 | 1.0 | 24€ + 16L + 1.3HT |
| Citerne lait | 0.30 | 0.20 | 1.0 | 24€ + 16L + 1.3HT |
| Livraison concessionnaire | 0.80 | — | — | 64€ (pas de véhicule joueur) |

### 10.2 Assurance matériel (F062-F063)

| Paramètre | Valeur |
|-----------|--------|
| Prime annuelle | argus × 3% |
| Argus | prix_neuf × (1 - usure%) × 0.85 × 0.60 |
| Durée | 12 mois Cultivia (84 jours réels) |
| Exemple tracteur 50k€ neuf, usure 20% | argus = 20 400€, prime = 612€/an |

### 10.3 Pièces détachées (F061)

| Paramètre | Valeur |
|-----------|--------|
| Coût base | Variable par type véhicule |
| Surcoût âge | +2% par année Cultivia d'âge |
| Formule | base × (1 + age_years × 0.02) |
| HT | 0.5 par remplacement |

### 10.4 Irrigation (F057-F058)

| Action | Coût € | HT | Prérequis |
|--------|--------|-----|----------|
| Forage | 150€ | 0.5 | Parcelle sans source |
| Irrigation (par session) | 0€ (HVC seul) | 0.5 | Source > 0, enrouleur, tracteur, HVC |
| Débit source | niveau × 100 000 L/jour | — | — |

### 10.5 Compostage (F078)

| Paramètre | Valeur |
|-----------|--------|
| Ratio | 3T fumier → 1T compost |
| Durée | 14 jours Cultivia |
| HT | 1.0 par lancement |
| Coût € | 0€ (main d'œuvre seule) |

### 10.6 Négociant en bestiaux (F071)

| Paramètre | Valeur |
|-----------|--------|
| Fréquence | 1 appel/mois Cultivia max |
| Offres | 4 animaux aléatoires |
| Prix | cours marché × 1.20 (+20%) |
| Restriction | Animaux non revendables entre joueurs |

### 10.7 Impact sur le budget débutant

Les coûts de transport ajoutent ~5-15% aux achats/ventes selon la distance à la préfecture du marché. Un joueur à 100km du Marché Central paie ~50€ de transport par achat d'animal et ~30€ par vente de récolte. Cela renforce l'avantage des joueurs proches des centres économiques, compensé par des prix de parcelles plus élevés en zone urbaine.

### 10.8 Remboursement anticipé prêt (F079)

| Paramètre | Valeur |
|-----------|--------|
| Pénalité | 3% du capital restant dû |
| Formule | total = remaining × 1.03 |
| Exemple | Prêt 50k€, restant 30k€ → 30 900€ à payer |
| Avantage | Économie des intérêts futurs |

### 10.9 Clôture anticipée épargne (F065)

| Paramètre | Valeur |
|-----------|--------|
| Pénalité | Perte totale des intérêts non versés |
| Capital restitué | 100% du montant initial |
| Intérêts restitués | 0€ |
| Exemple | Épargne 80k€ à 5%, clôturée après 50j → 80k€ restitués, 0€ intérêts |