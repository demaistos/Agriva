> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.

# Étude Économique — Profils de joueurs Agriva (1-3-6-12 mois de jeu)

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Base : données `reality-vs-simagri-cultures.md` + `reality-vs-simagri-elevage.md`

---

## Hypothèses de base

| Paramètre | Valeur |
|-----------|--------|
| Temporalité | 1 semaine réelle = 1 mois in-game |
| Capital départ joueur | **150 000 €** (SdV §3 — identique pour tous les kits) |
| Kit de départ | 4 kits au choix : Cultivateur, Éleveur, Aviculteur, Polyvalent (SdV §5) |
| Heures de Travail par jour | ~40-50 HT/jour de base (SdV §4 — calibrage exact en équilibrage) |
| Prix marché | Fluctuants (offre/demande), on utilise les **moyennes 2024** |
| Charges fixes annuelles | Fermage + cotisations + assurance ≈ 380 €/ha (cultures), variable (élevage) |
| DPB (aides PAC) | **150 €/ha** en Normal (SdV §3) |
| Monétisation | Gratuit (100% mécaniques) + Premium 3,99€/mois (confort/cosmétique, SdV §8) |

**Conversion temporelle :**
- 1 mois réel = 4 mois in-game
- 3 mois réel = 12 mois in-game (1 année agricole complète)
- 6 mois réel = 24 mois in-game (2 années)
- 12 mois réel = 48 mois in-game (4 années)

---

## 1. Profil CÉRÉALIER (Grandes cultures)

### Configuration type
- **Surface** : départ 30 ha, extension progressive
- **Rotation** : Colza → Blé → Orge (3 ans)
- **Kit de départ (SdV §5)** : Kit Cultivateur — tracteur 120CV, charrue, herse, semoir, moissonneuse 280CV, benne 12T, hangar 200m², silo 100T (matériel usé 50-60%, non-revendable 7j)
- **Capital** : 150 000 € + kit complet (pas d'achat initial de matériel nécessaire)

### Revenus par culture (€/ha)

| Culture | Produit brut | Charges opé | Marge brute | Méca + Structure | **Marge nette** |
|---------|:---:|:---:|:---:|:---:|:---:|
| Blé tendre | 1 650 | 510 | 1 140 | 720 | **570** |
| Orge hiver | 1 400 | 430 | 970 | 690 | **400** |
| Colza | 1 632 | 490 | 1 142 | 690 | **452** |
| **Moyenne rotation** | **1 560** | **477** | **1 084** | **700** | **~470** |

### Projection financière (30 ha de départ — Kit Cultivateur)

| Durée réelle | Mois in-game | Cycles récolte | Revenu net cumulé | Capital total estimé |
|:---:|:---:|:---:|:---:|:---:|
| **1 mois** | 4 mois | 0-1 (blé d'hiver semé, récolte en cours) | 0 à 14 100 € | 150 000 - 164 100 € |
| **3 mois** | 12 mois | 1 cycle complet (1 culture/parcelle) | ~14 100 € | ~164 000 € |
| **6 mois** | 24 mois | 2 cycles, extension à 50 ha possible | ~33 000 € (30ha) à 47 000 € (50ha) | ~195 000 € |
| **12 mois** | 48 mois | 4 cycles, 80-100 ha possibles | ~130 000 - 188 000 € cumulé | ~300 000+ € |

### Caractéristiques économiques
- ⏱️ **Temps avant 1er revenu** : ~6-9 mois in-game (semis → récolte)
- 💰 **Marge nette/ha** : ~470 €/ha/an
- 📈 **Scalabilité** : excellente — plus de surface = revenu proportionnel
- ⚠️ **Risques** : météo (verse, sécheresse), prix marché, maladie
- 🎮 **Gameplay** : saisonnier, pics d'activité (semis/récolte), calme entre
- 💡 **Avantage** : faible coût d'entrée, bon rapport surface/revenu

---

## 2. Profil ÉLEVEUR BOVIN LAITIER

### Configuration type
- **Cheptel** : départ 20 vaches laitières (Prim'Holstein)
- **Surface fourragère** : 25-40 ha (pâturages + maïs ensilage)
- **Bâtiment** : stabulation 20 places (~120 000 €) + salle de traite (~60 000 €)
- **Investissement initial** : 200 000-300 000 € (très lourd, emprunt nécessaire)

### Revenus (par vache laitière / an)

| Poste | Montant |
|-------|:---:|
| Production lait | 8 800 L × 0,41 €/L = **3 608 €** |
| Veau (vente à 8j ou élevage) | +200-400 € |
| Réforme (1 vache/5 par an) | +700-1 000 € (au prorata) |
| **Produit brut/VL** | **~4 000 €** |
| Charges opérationnelles/VL | -1 800 à -2 500 € |
| **Marge brute/VL** | **1 500 - 2 200 €** |
| Charges structure (au prorata) | -800 à -1 200 € |
| **Marge nette/VL** | **500 - 1 000 €** |

### Projection financière (20 VL départ — AVEC reproduction/renouvellement)

> Le laitier se reproduit lentement : 1 veau/vache/an, gestation 9 mois, génisse productive à 24-36 mois IG.
> Le levier = garder les génisses femelles pour agrandir le troupeau.

| Durée réelle | Mois in-game | VL en production | Génisses en élevage | Revenu net cumulé | Capital total |
|:---:|:---:|:---:|:---:|:---:|:---:|
| **1 mois** | 4 mois | 20 | 0 | ~5 000 - 6 600 € | Très endetté (emprunt bâtiment) |
| **3 mois** | 12 mois | 20 | 10 (1ères naissances, femelles gardées) | ~15 000 - 20 000 € | Début remboursement |
| **6 mois** | 24 mois | 20 | 20 (pas encore en prod — maturité 24-36 mois) | ~35 000 - 45 000 € | ~150 000 € (net dettes) |
| **12 mois** | 48 mois | **38-42** (génisses entrent en production) | 15 | **~300 000 - 380 000 €** | ~400 000+ € |

> Le laitier est **lent à se multiplier** (33-36 mois entre naissance et 1ère lactation) mais le cash-flow du lait est constant. La valeur du patrimoine (troupeau) augmente aussi car chaque VL vaut 1500-2500€.

### Caractéristiques économiques
- ⏱️ **Temps avant 1er revenu** : immédiat (lait dès J1 si achat de vaches en lactation)
- 💰 **Revenu/VL** : ~750 €/VL/an net (troupeau 20 VL = ~15 000 €/an)
- 📈 **Scalabilité** : bonne mais par paliers (bâtiment à agrandir)
- ⚠️ **Risques** : mammites, prix du lait, coût alimentation
- 🎮 **Gameplay** : quotidien (traite), régulier, peu de morte-saison
- 💡 **Avantage** : revenu très régulier (lait = cash-flow constant)
- ❌ **Inconvénient** : investissement initial massif, forte dépendance au prix du lait

---

## 3. Profil ÉLEVEUR BOVIN ALLAITANT (Viande)

### Configuration type
- **Cheptel** : départ 15 vaches allaitantes (Charolaises) + 1 taureau
- **Surface** : 20-30 ha de prairies (faible chargement 0,8-1,2 UGB/ha)
- **Bâtiment** : stabulation simple (~50 000 €)
- **Investissement initial** : 80 000-120 000 €

### Revenus (par vache allaitante / an)

| Poste | Montant |
|-------|:---:|
| Vente broutard (mâle) 8-10 mois | 900 - 1 200 € |
| Vente broutarde (femelle, si non conservée) | 700 - 900 € |
| Taux moyen (50% mâles, réforme, mortalité) | **~800 €/VA** |
| Vache réforme (1/7 par an) | +500-700 € (au prorata) |
| **Produit brut/VA** | **~900 - 1 100 €** |
| Charges opérationnelles | -420 à -840 € |
| **Marge brute/VA** | **300 - 600 €** |
| Charges structure (au prorata) | -200 à -350 € |
| **Marge nette/VA** | **100 - 250 €** |
| + Aides PAC couplées | +100 - 160 €/VA |
| **Marge nette avec PAC** | **200 - 410 €/VA** |

### Projection financière (15 VA départ)

| Durée réelle | Mois in-game | Événements clés | Revenu net cumulé | Capital total |
|:---:|:---:|:---|:---:|:---:|
| **1 mois** | 4 mois | Vêlages en cours, pas de vente encore | ~0 € (charges en cours) | 150 000 € - charges |
| **3 mois** | 12 mois | 1ère vente de broutards (automne) | ~4 500 - 6 000 € | ~55 000 € |
| **6 mois** | 24 mois | 2ème lot de broutards, premières génisses gardées, 20 VA | ~12 000 - 18 000 € | ~70 000 € |
| **12 mois** | 48 mois | 30 VA, naisseur-engraisseur possible (JB) | ~35 000 - 60 000 € | ~120 000 € |

### Caractéristiques économiques
- ⏱️ **Temps avant 1er revenu** : 8-10 mois in-game (naissance → sevrage → vente)
- 💰 **Revenu/VA** : ~300 €/VA/an net (avec PAC), 15 VA = ~4 500 €/an
- 📈 **Scalabilité** : lente (reproduction naturelle, besoin de surface)
- ⚠️ **Risques** : mortalité vêlage, prix broutards cyclique
- 🎮 **Gameplay** : saisonnier (vêlages automne/hiver, ventes automne)
- 💡 **Avantage** : faible technicité, extensif, peu de HT quotidiens
- ❌ **Inconvénient** : revenu faible, très dépendant des aides PAC

---

## 4. Profil AVICULTEUR (Poules — Modèle SimAgri avec multiplication)

> ⚠️ **Ce profil est le PLUS RENTABLE dans SimAgri** grâce à la reproduction exponentielle à la ferme.
> Le modèle SimAgri diffère fortement de la réalité (où les fermiers achètent des poussins au couvoir, pas de reproduction locale).
> Agriva doit décider : garder ce modèle très rentable (fun, gratifiant) ou le rapprocher du réel (moins explosif).

### Configuration type (modèle SimAgri)
- **Cheptel départ** : 20 poules + 2 coqs (Kit Aviculteur, SdV §5)
- **Bâtiment** : poulailler 50m² + hangar 100m² + tracteur 50CV (Kit Aviculteur)
- **Investissement initial** : aucun achat nécessaire (kit fourni) — capital de 150 000 € disponible pour extension

### Mécaniques de revenu (triple source)

| Source | Détail | Revenu/poule/mois IG |
|--------|--------|:---:|
| 🥚 Œufs | 0,5-1 œuf/jour selon race, vente coop | ~5-10 € |
| 🐣 Poussins (vente) | Surplus vendu aux joueurs ou abattoir | ~10-30 € (par portée) |
| 🍗 Viande (abattoir) | Vente adultes excédentaires | ~5-15 €/animal |

### La boucle de multiplication (le vrai game-changer)

**Reproduction SimAgri** : 1 coq féconde 10 poules/mois → chaque poule peut couver

```
Départ : 20 poules + 2 coqs (Kit Aviculteur SdV §5)
Mois 1 IG :  20 poules pondent + 20 œufs fécondés → incubation
Mois 2 IG :  20 poussins éclosent, 20 nouvelles couvées lancées
Mois 3-6 IG : les poussins deviennent jeunes → adultes
Mois 7 IG :  40+ poules en production, cycle accélère
Mois 12 IG : 80-150 poules (selon capacité bâtiment)
Mois 24 IG : 300-600 poules (extension progressive)
Mois 48 IG : 1000-3000+ poules (SATURÉ seulement par le bâtiment)
```

### Revenus cumulés (AVEC multiplication)

| Poste/mois IG | Cheptel | Œufs/mois | Vente surplus | Revenu mensuel IG |
|:---:|:---:|:---:|:---:|:---:|
| Mois 1-3 | 20 poules | ~400 œufs | ~0 (on garde tout) | ~200-400 € |
| Mois 4-6 | 20-30 poules | ~600 œufs | 5-10 poussins vendus | ~500-800 € |
| Mois 7-12 | 50-100 poules | ~2 000 œufs | 20-40 animaux vendus | ~1 500-3 000 € |
| Mois 13-24 | 200-500 poules | ~8 000 œufs | 50-100 vendus/mois | ~5 000-10 000 € |
| Mois 25-48 | 1 000-3 000 poules | ~40 000 œufs | 200+ vendus/mois | ~15 000-40 000 € |

### Projection financière (modèle multiplication)

| Durée réelle | Mois in-game | Cheptel | Revenu net cumulé | Capital total |
|:---:|:---:|:---:|:---:|:---:|
| **1 mois** | 4 mois | 20-30 poules | ~1 500 - 2 500 € | ~7 000 - 12 000 € |
| **3 mois** | 12 mois | 80-150 poules | ~10 000 - 20 000 € | ~20 000 - 30 000 € |
| **6 mois** | 24 mois | 300-800 poules | ~50 000 - 100 000 € | ~60 000 - 110 000 € |
| **12 mois** | 48 mois | 2 000-5 000 poules | ~250 000 - 500 000+ € | ~300 000 - 550 000 € |

> 🔥 **C'est explosif.** La croissance exponentielle + triple revenu fait de la volaille le profil le plus rentable de SimAgri, et de loin à long terme.

### Pourquoi c'est le n°1 dans SimAgri

| Avantage | Détail |
|----------|--------|
| Investissement quasi-nul | Kit Aviculteur fourni (20 poules + 2 coqs + poulailler 50m²) |
| Revenu immédiat | Œufs dès le jour 1 |
| Croissance exponentielle | Le cheptel se multiplie tout seul |
| Triple monétisation | Œufs + animaux vivants + viande |
| Faible coût aliment | 0,12 kg/j/poule = charges négligeables |
| Peu de surface | 0,1 m²/poule = 1000 poules dans 100 m² |
| Cycle ultra-court | Adulte en 6 mois IG, reproduction dès l'âge adulte |
| Marché joueurs | Les autres joueurs ACHÈTENT des poules pour démarrer |

### Caractéristiques économiques
- ⏱️ **Temps avant 1er revenu** : immédiat (œufs dès J1)
- 💰 **ROI** : le meilleur du jeu (~5 000% sur 12 mois réels)
- 📈 **Scalabilité** : exponentielle (limitée seulement par la capacité bâtiment)
- ⚠️ **Risques** : saturation du marché (si trop de joueurs font pareil), grippe aviaire (si modélisée)
- 🎮 **Gameplay** : quotidien, simple mais addictif (voir le cheptel grandir)
- 💡 **Avantage** : meilleur profil de départ, gratifiant, peu technique
- ❌ **Inconvénient** : peut déséquilibrer le jeu si pas de frein (voir section équilibrage)

### ⚖️ Question d'équilibrage pour Agriva

Le modèle SimAgri est **fun mais potentiellement broken** :
- Si tout le monde fait des poules → le marché s'effondre (offre > demande)
- Le ratio investissement/revenu est 10× supérieur aux autres filières

**Options d'équilibrage :**
1. **Garder tel quel** (fidèle à SimAgri) — la régulation se fait par le marché joueur
2. **Limiter la reproduction** — ponte OU reproduction, pas les deux en même temps
3. **Augmenter les charges** — bâtiment plus cher, aliment plus cher, vétérinaire
4. **Saturation marché** — prix des œufs/poules baisse si trop d'offre sur le serveur
5. **Maladies** — grippe aviaire = perte massive, risque réel
6. **HT limitants** — ramassage œufs + soins + reproduction = beaucoup de HT

> **Recommandation** : option 4 (régulation par le marché) + option 6 (HT). C'est ce que SimAgri faisait implicitement — la poule est rentable mais le joueur est limité par ses HT et par la demande des autres joueurs.

---

## 5. Profil PORCIN (Naisseur-Engraisseur)

### Configuration type
- **Cheptel** : 20 truies reproductrices
- **Bâtiment** : porcherie complète (maternité + post-sevrage + engraissement) ~150 000 €
- **Investissement initial** : 150 000-200 000 €

### Revenus (par truie productive / an)

| Poste | Montant |
|-------|:---:|
| Porcelets sevrés/truie/an | 25-30 |
| Poids sortie engraissement | 115-120 kg vif → 90 kg carcasse |
| Prix carcasse | 1,60 - 1,90 €/kg |
| **Produit brut/porc engraissé** | **~155 €** |
| × 25 porcs/truie/an | **~3 875 €/truie** |
| Charges aliment (IC 2,7) | -2 600 €/truie |
| Autres charges | -500 €/truie |
| **Marge brute/truie** | **~775 €** |
| Amortissement/structure | -300 à -500 €/truie |
| **Marge nette/truie** | **200 - 475 €** |

### Projection financière (20 truies — AVEC multiplication du cheptel)

| Durée réelle | Mois in-game | Truies | Porcs vendus (cumulé) | Revenu net cumulé | Capital total |
|:---:|:---:|:---:|:---:|:---:|:---:|
| **1 mois** | 4 mois | 20 | 0 (1ère gestation en cours) | ~0 € | -100 000 € (dette) |
| **3 mois** | 12 mois | 25 (gardé cochettes) | ~200 porcs | ~30 000 - 40 000 € | Début remboursement |
| **6 mois** | 24 mois | 50 truies | ~1 300 porcs | ~150 000 - 200 000 € | ~100 000 € |
| **12 mois** | 48 mois | 120-150 truies | ~6 000+ porcs | **~600 000 - 900 000 €** 🔥 | ~500 000+ € |

> ⚠️ Avec la reproduction, le porc devient **le 2ème profil le plus rentable** en revenu absolu (après la poule en ROI), car le volume de vente est énorme. Mais l'investissement en bâtiment suit (porcherie = très cher à chaque extension).

### Caractéristiques économiques
- ⏱️ **Temps avant 1er revenu** : ~7-8 mois in-game (gestation + engraissement)
- 💰 **Revenu net** : ~350 €/truie/an au départ → explose avec la multiplication
- 📈 **Scalabilité** : **exponentielle** (10-14 porcelets/portée, 2,3 portées/an)
- ⚠️ **Risques** : prix du porc très cyclique (±30%), PPA (épizootie), investissement bâtiment massif
- 🎮 **Gameplay** : régulier, gestion de bandes, décisions alimentation
- 💡 **Avantage** : volume énorme (25-30 porcs vendus/truie/an), 2ème meilleur en absolu
- ❌ **Inconvénient** : investissement bâtiment suit la croissance (porcherie = cher), marge/porc très fine

---

## 6. Tableau comparatif synthétique

### À 1 mois de jeu réel (4 mois in-game)

> **Note** : Avec le système de kits (SdV §5), les 4 kits de départ sont : Cultivateur, Éleveur, Aviculteur, Polyvalent. Tous commencent avec 150 000 € + kit matériel inclus. Les profils Porcin et Allaitant ci-dessous sont des orientations stratégiques possibles (via le Kit Éleveur ou Polyvalent), pas des kits séparés.

| Profil (Kit) | Kit de départ | 1er revenu après | Cash généré | Endettement |
|--------|:---:|:---:|:---:|:---:|
| 🐔 Volaille (Kit Aviculteur) | 20 poules + 2 coqs + tracteur 50CV + poulailler 50m² | Immédiat | 2 000 - 3 500 € | **Nul** |
| 🌾 Céréalier (Kit Cultivateur) | Tracteur 120CV + moissonneuse 280CV + outils | 6-9 mois IG | 0 - 14 000 € | Nul |
| 🐄 Laitier (Kit Éleveur) | 10 VL Holstein + tracteur 80CV + stabulation 300m² | Immédiat | 5 000 - 6 600 € | Nul |
| ⚖️ Polyvalent (Kit Polyvalent) | Tracteur 100CV + outils de base | Variable | Variable | Nul |

### À 3 mois de jeu réel (12 mois in-game = 1 an agricole)

| Profil | Revenu net annuel | Revenu/€ investi | Cash-flow | Risque |
|--------|:---:|:---:|:---:|:---:|
| 🐔 Volaille | 10 000 - 20 000 € | **2,0 - 4,0** 🔥 | Quotidien + ventes | Faible |
| 🌾 Céréalier | ~14 100 € | 0,18 - 0,28 | Saisonnier (récolte) | Moyen |
| 🐄 Laitier | 12 000 - 20 000 € | 0,06 - 0,10 | Régulier (mensuel) | Moyen |
| 🐂 Allaitant | 4 500 - 6 000 € | 0,05 - 0,07 | Saisonnier (automne) | Faible |
| 🐷 Porcin | 7 000 - 10 000 € | 0,04 - 0,06 | Par bandes (tous 2-3 mois) | Fort |

### À 12 mois de jeu réel (48 mois in-game = 4 ans)

| Profil | Patrimoine estimé | Revenu cumulé 4 ans | Croissance cheptel | Diversification |
|--------|:---:|:---:|:---:|:---:|
| 🐔 Volaille | **~500 000 €** 🔥 | 250 000 - 500 000 € | **×140-230** (exponentiel) | Vers tout (réinvestissement) |
| 🐷 Porcin | **~500 000 €** 🔥 | 600 000 - 900 000 € | ×6-7 truies/an | Vers salaison/direct |
| 🐄 Laitier | ~400 000+ € | 300 000 - 380 000 € | ×2 VL (lent) | Vers fromagerie/AOP |
| 🌾 Céréalier | ~200 000+ € | 130 000 - 188 000 € | ×3 (surface achetée) | Vers betterave/PDT |
| 🐑 Ovin | ~100 000 € | 95 000 € | ×3-4 brebis/an | Vers fromage/labels |
| 🐂 Allaitant | ~120 000 € | 72 000 € | ×1,8 (très lent) | Vers engraissement |

> **Conclusion** : avec la reproduction, le classement change radicalement. Le porc rivalise avec la poule en revenu absolu, mais la poule garde le meilleur ROI (rapport investissement/revenu).

---

## 7. Courbes de progression comparées — AVEC REPRODUCTION

> La vraie force de l'élevage dans SimAgri n'est pas seulement la vente de produits (lait, œufs) mais la **multiplication du cheptel**. Chaque espèce se reproduit avec ses propres paramètres.

### 7.1 Paramètres de reproduction par espèce (modèle SimAgri)

| Espèce | Gestation/Incubation | Maturité sexuelle | Portée | Fréquence max | Femelles/mâle/mois |
|--------|:---:|:---:|:---:|:---:|:---:|
| 🐔 **Poule** | 1 mois IG | 6 mois IG (180j) | ~10 œufs fécondés/mois | Continu | 10 poules/coq/mois |
| 🐷 **Porc** | 4 mois IG | ~8 mois IG | 10-14 porcelets | ~2,3 portées/an | 5 femelles/mâle/mois |
| 🐄 **Bovin lait** | 9 mois IG | ~15 mois IG | 1 veau | 1/an (IVV 12-14 mois) | 3 femelles/mâle/mois |
| 🐂 **Bovin viande** | 9 mois IG | ~15-24 mois IG | 1 veau | 1/an | 3 femelles/mâle/mois |
| 🐑 **Ovin** | 5 mois IG | ~8-12 mois IG | 1-2 agneaux | 1-1,5/an | 5-10 femelles/mâle/mois |

### 7.2 Taux de multiplication annuel (in-game) par espèce

La vraie question : **combien d'animaux a-t-on au bout de X mois si on garde tout ?**

#### 🐔 Poule — Croissance EXPONENTIELLE RAPIDE

```
Paramètres SimAgri :
- 10 poules fécondées/coq/mois
- Incubation : 1 mois
- Adulte productif : 6 mois (180j)
- Cycle complet naiss→prod : 7 mois IG

Départ (Kit Aviculteur SdV §5) : 20 poules + 2 coqs = 22 animaux
```

| Mois IG | Adultes | Jeunes/Bébés | Total | Œufs/mois | Animaux vendables |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 22 | 0 | 22 | 300-600 | 0 |
| 3 | 22 | 60 | 82 | 300-600 | 0 |
| 6 | 22 | 120 | 142 | 300-600 | 40 (1ers adultes) |
| 9 | 62 | 150 | 212 | 800-1 800 | 50 |
| 12 | 120 | 200 | 320 | 1 800-3 600 | 80+ |
| 18 | 250+ | 300+ | 550+ | 3 500-7 500 | 150+ |
| 24 | 600+ | 500+ | 1 100+ | 9 000-18 000 | 300+ |
| 36 | 2 000+ | 1 500+ | 3 500+ | 30 000+ | 600+ |
| 48 | **3 000-5 000+** | — | **saturé bâtiment** | **45 000+** | **1 000+** |

**Taux de multiplication** : ×15-50 par an IG (exponentiel, limité par bâtiment)
**Revenu multiplicateur** : œufs + vente animaux + abattoir = **triple source**

---

#### 🐷 Porc — Croissance EXPONENTIELLE MOYENNE

```
Paramètres SimAgri :
- 5 truies fécondées/verrat/mois
- Gestation : 4 mois IG
- Portée : 10-14 porcelets
- Adulte : ~8 mois IG
- Cycle naiss→adulte : 8 mois IG
- Cycle naiss→vente (engraissement) : 4-5 mois post-sevrage
```

| Mois IG | Truies prod. | Porcelets/jeunes | Porcs engraissés vendus (cumulé) | Revenu vente |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 20 | 0 | 0 | 0 |
| 4 | 20 | 200-280 (1ère portée) | 0 | 0 |
| 8 | 20 | 400+ | ~200 (1er lot abattoir) | ~30 000 € |
| 12 | 25 (gardé génisses) | 500+ | ~450 | ~70 000 € |
| 18 | 35 | 600+ | ~800 | ~125 000 € |
| 24 | 50 | 800+ | ~1 300 | ~200 000 € |
| 36 | 80 | 1 200+ | ~3 000 | ~460 000 € |
| 48 | **120-150** | — | **~6 000+** | **~900 000 €** |

**Taux de multiplication** : ×5-7 par an IG en truies (si on garde des cochettes)
**Mais** : investissement bâtiment MASSIF nécessaire à chaque extension
**Revenu principal** : vente porcs engraissés à l'abattoir (155€/porc × volume)

> ⚠️ Le porc avec reproduction est potentiellement AUSSI rentable que la poule, voire plus ! Mais il nécessite beaucoup plus d'investissement bâtiment et la marge/porc est fine (très sensible au prix).

---

#### 🐄 Bovin laitier — Croissance LINÉAIRE-LENTE

```
Paramètres SimAgri :
- 3 vaches inséminées/taureau/mois (ou IA)
- Gestation : 9 mois IG
- Veau → génisse productive : ~24-27 mois IG (2+ ans)
- Cycle naiss→lactation : ~33-36 mois IG
- 1 veau/vache/an maximum (IVV ~12-14 mois)
```

| Mois IG | Vaches lait. | Génisses élevage | Veaux vendus (cum.) | Lait cumulé (L) | Revenu cumulé |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 20 | 0 | 0 | 0 | 0 |
| 9 | 20 | 10 (1ères naissances) | 10 mâles vendus | 140 000 L | ~60 000 € |
| 12 | 20 | 10 | 10 | 175 000 L | ~75 000 € |
| 18 | 20 | 15 | 15 | 265 000 L | ~115 000 € |
| 24 | 20 | 20 | 20 | 350 000 L | ~155 000 € |
| 33-36 | **30** (1ères génisses en prod) | 15 | 30 | 530 000 L | ~235 000 € |
| 48 | **38-42** | 20 | 50+ | 850 000 L | **~380 000 €** |

**Taux de multiplication** : ×1,5-2 par an IG en vaches (50% des veaux = femelles, gardées si place)
**Lenteur** : 33-36 mois IG (8-9 mois réels !) avant qu'une génisse produise du lait
**Mais** : le lait coule CHAQUE JOUR → cash-flow immédiat et constant
**Levier** : acheter des vaches au marché pour accélérer (si on a le capital)

---

#### 🐂 Bovin allaitant — Croissance TRÈS LENTE

```
Paramètres SimAgri :
- 3 vaches/taureau/mois
- Gestation : 9 mois IG
- Broutard vendable : 8-10 mois après naissance
- Génisse → 1er vêlage : ~30-36 mois IG
- 1 veau/vache/an
```

| Mois IG | Vaches mères | Génisses | Broutards vendus (cum.) | Revenu cumulé |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 15 | 0 | 0 | 0 |
| 9 | 15 | 7 (femelles gardées) | 0 (pas encore sevrés) | 0 |
| 12 | 15 | 7 | 7 mâles (900-1200€) | ~7 500 € |
| 18 | 15 | 12 | 14 | ~15 000 € |
| 24 | 15 | 15 | 22 | ~24 000 € |
| 36 | **22** (génisses en prod) | 10 | 40 | ~45 000 € |
| 48 | **28-30** | 15 | 65+ | **~72 000 €** |

**Taux de multiplication** : ×1,3-1,5 par an IG (le plus lent de tous)
**Avantage** : très peu de charges, extensif, peu de HT
**Inconvénient** : revenu/animal faible, croissance du troupeau très lente

---

#### 🐑 Ovin (bonus) — Croissance INTERMÉDIAIRE

```
Paramètres (estimation SimAgri-like) :
- 5-10 brebis/bélier/mois
- Gestation : 5 mois IG
- Portée : 1-2 agneaux
- Maturité : 8-12 mois IG
- ~1,3 portée/an (désaisonnement possible)
```

| Mois IG | Brebis | Agneaux vendus (cum.) | Revenu cumulé |
|:---:|:---:|:---:|:---:|
| 0 | 30 | 0 | 0 |
| 5 | 30 | 0 (1ères naissances) | 0 |
| 8 | 30 | 20 (agneaux 3 mois) | ~5 000 € |
| 12 | 35 | 45 | ~12 000 € |
| 24 | 55 | 120 | ~32 000 € |
| 48 | **100-120** | 350+ | **~95 000 €** |

**Taux de multiplication** : ×2-3 par an IG (intermédiaire entre porc et bovin)

---

### 7.3 TABLEAU COMPARATIF — Multiplication & Revenu cumulé à 12 mois réels (48 mois IG)

| Espèce | Départ | Cheptel à 48 mois IG | Multiplicateur | Revenu cumulé | Investissement initial | **ROI** |
|--------|:---:|:---:|:---:|:---:|:---:|:---:|
| 🐔 Poule | 22 (Kit Aviculteur) | 3 000-5 000 | **×140-230** | 250 000-500 000 € | Kit (inclus) | **×50-100** 🔥🔥🔥 |
| 🐷 Porc | 21 (20 truies) | 120-150 truies | ×6-7 | 600 000-900 000 € | 150-200 k€ | **×4-5** 🔥 |
| 🐄 Lait | 20 | 38-42 VL | ×2 | 380 000 € | 200-300 k€ | **×1,5-2** |
| 🐑 Ovin | 31 | 100-120 | ×3-4 | 95 000 € | 30-50 k€ | **×2-3** |
| 🐂 Allaitant | 16 | 28-30 VA | ×1,8 | 72 000 € | 80-120 k€ | **×0,7-0,9** |
| 🌾 Céréalier | 30 ha | 80-100 ha (achat) | ×3 (surface) | 130 000-188 000 € | 50-80 k€ | **×2-3** |

### 7.4 Courbe de valeur totale (capital + revenus cumulés)

```
Valeur totale (€) — échelle logarithmique mentale
│
│  🐔 POULE                            ★ 500 000+ €
│       multiplication exponentielle ╱╱╱
│                               ╱╱╱╱
│  🐷 PORC                ╱╱╱╱         ★ 900 000+ € (mais 200k€ investi)
│     expo + volume  ╱╱╱╱╱╱
│               ╱╱╱╱╱╱
│  🐄 LAITIER ╱╱╱╱                     ★ 380 000 €
│     linéaire + cash-flow ╱╱╱╱╱
│         ╱╱╱╱╱╱╱
│  🌾 CÉRÉALIER                         ★ 188 000 €
│     linéaire (surface) ╱╱╱╱
│        ╱╱╱╱╱
│  🐑 OVIN                              ★ 95 000 €
│     ╱╱╱╱
│  🐂 ALLAITANT                          ★ 72 000 €
│   ╱╱╱
├────────┼────────┼────────┼────────┼──→ Temps (mois réels)
0       3        6        9       12
```

### 7.5 Pourquoi la poule domine TOUT

| Facteur | Poule | Porc | Bovin | Céréalier |
|---------|:---:|:---:|:---:|:---:|
| Cycle reproduction | **1 mois** | 4 mois | 9 mois | — |
| Nombre de petits | **10/mois** | 12/portée | 1/an | — |
| Maturité | **6 mois** | 8 mois | 24-36 mois | — |
| Investissement/place | **très faible** | moyen | élevé | — |
| Alimentation/animal | **0,12 kg/j** | 3 kg/j | 20-25 kg MS/j | — |
| Sources de revenu | **3** (œufs+vente+viande) | 1 (viande) | 2 (lait+veau) | 1 (récolte) |

**La poule cumule TOUS les avantages** : cycle court, portée élevée, coût faible, multiple revenu. C'est le "broken build" de SimAgri.

### 7.6 Le porc : le challenger sous-estimé

Le porc est potentiellement **le 2ème meilleur** en revenu absolu grâce à :
- 10-14 porcelets/portée (vs 1 veau)
- 2,3 portées/an
- Cycle court (adulte en 8 mois IG vs 24-36 mois bovin)
- Volume d'affaires élevé (155€ × centaines de porcs/an)

**Mais** son talon d'Achille = l'investissement bâtiment massif et le prix du porc très volatile.

### 7.7 Impact sur le game design

La hiérarchie "naturelle" si on laisse tout le monde se reproduire librement :

```
🐔 Poule >>> 🐷 Porc >> 🐄 Laitier > 🌾 Céréalier > 🐑 Ovin > 🐂 Allaitant
```

**C'est un choix de design intentionnel de SimAgri** — la poule est le starter parfait car :
- Accessible à tous (investissement nul)
- Gratifiant (voir le cheptel grandir)
- Limité naturellement par les HT et la demande marché

**Régulateurs naturels dans SimAgri :**
1. **HT** : ramasser les œufs, nourrir, gérer la repro = mange des HT
2. **Bâtiment** : il faut construire des poulaillers (coût croissant)
3. **Marché** : si tout le monde vend des poules, le prix s'effondre
4. **Robot ramassage** : requis à 500-1000 poules (investissement)
5. **Salle de conditionnement** : requise pour stocker les œufs

---

## 8. Analyse stratégique pour le game design

### Démarrage recommandé selon profil joueur

| Type de joueur | Profil recommandé | Pourquoi |
|---------------|-------------------|----------|
| Optimiseur / min-maxer | 🐔 Volaille | Le plus rentable, croissance exponentielle |
| Impatient, veut du revenu vite | 🐔 Volaille ou 🐄 Laitier | Cash immédiat |
| Aime la gestion quotidienne | 🐄 Laitier | Action constante, optimisation traite |
| Casual / peu de temps | 🐂 Allaitant ou 🌾 Céréalier | Peu d'interventions |
| Stratège long terme | 🌾 Céréalier | Scalabilité linéaire, rotation |
| Parieur / risque | 🐷 Porcin | Forte volatilité = gros gains possibles |
| Polyvalent (méta SimAgri) | 🐔 Volaille → 🌾 Céréalier + 🐄 Laitier | Capital poules → diversification |

### Équilibrage du jeu — Points d'attention

1. **Le céréalier est le plus rentable à long terme** (meilleur ratio revenu/investissement) → normal, c'est le profil "base" du jeu
2. **L'allaitant est sous-rentable** → compenser avec aides PAC généreuses + gameplay extensif valorisant (peu de HT consommés)
3. **Le laitier a un cash-flow unique** → récompense les joueurs réguliers (traite quotidienne)
4. **La volaille est le meilleur "starter"** → investissement faible, revenu rapide, bon tremplin
5. **Le porc est "high risk / high reward"** → cycle court mais prix volatile

### Équilibre multi-spécialisation

En pratique, les joueurs expérimentés de SimAgri combinaient les profils :
- **Polyculture-élevage** : 50 ha cultures + 30 VL = double source de revenus + synergies (foin, paille, fumier)
- **Diversification progressive** : démarrer céréalier → ajouter volaille → puis bovins
- **Le mixte est optimal** mais plus complexe à gérer (HT limités)

---

## 9. Implications pour l'équilibrage Agriva

### Leviers d'équilibrage à calibrer

| Levier | Impact | Profils affectés |
|--------|--------|-----------------|
| Capital de départ | Qui peut faire quoi au J1 | Laitier/Porc = impossibles sans emprunt |
| Taux d'emprunt banque | Frein ou accélérateur des gros investissements | Laitier, Porc |
| Prix de vente (coop) | Revenu de base garanti | Tous |
| Variabilité prix marché | Risque = reward ou frustration | Céréalier, Porc |
| Aides PAC (si modélisées) | Subvention des profils peu rentables | Allaitant, Ovin |
| Coût alimentation | Charge n°1 de l'élevage | Laitier, Porc, Volaille |
| Vitesse d'extension | Acheter du terrain/bâtiment | Céréalier surtout |

### Ratio investissement / 1er revenu (critère fun)

**Objectif game design :** chaque profil doit avoir son 1er revenu dans un délai "fun" :
- Max acceptable : 2 mois réels (8 mois IG) avant le 1er €
- Idéal : <1 mois réel (4 mois IG)

| Profil | Délai 1er € (réaliste) | Ajustement possible pour le fun |
|--------|:---:|:---|
| 🌾 Céréalier | 6-9 mois IG | Offrir une parcelle déjà semée au départ |
| 🐄 Laitier | Immédiat | ✅ Déjà bon |
| 🐂 Allaitant | 8-10 mois IG | Offrir des vaches déjà gestantes/avec veaux |
| 🐔 Volaille | Immédiat | ✅ Déjà bon |
| 🐷 Porcin | 7-8 mois IG | Offrir des truies déjà gestantes |

---

## 10. Résumé exécutif

| Critère | 🥇 Meilleur | 🥈 Second | 🥉 Troisième |
|---------|:---:|:---:|:---:|
| ROI (retour sur investissement) | **Volaille** (×50-100) | Ovin (×2-3) | Céréalier (×2-3) |
| Revenu absolu cumulé (4 ans) | **Porcin** (900k€) | Volaille (500k€) | Laitier (380k€) |
| Revenu immédiat | Volaille | Laitier | — |
| Investissement le plus faible | **Volaille** (kit fourni) | Ovin (kit + peu d'extension) | Céréalier (kit fourni) |
| Scalabilité (multiplication) | **Volaille** (×140-230/4ans) | Porcin (×7/an) | Ovin (×3-4/an) |
| Régularité cash-flow | Laitier | Volaille | — |
| Gameplay casual | Allaitant | Céréalier | — |
| Skill ceiling (optimisation) | Porcin | Laitier | Céréalier |
| Risque/Volatilité | Porcin | Céréalier | Laitier |

### Hiérarchie de rentabilité avec reproduction

```
🏆 TIER S : 🐔 Poule (ROI imbattable, exponentiel, 3 sources revenu)
🥈 TIER A : 🐷 Porc (revenu absolu massif, mais investissement lourd)
🥉 TIER B : 🐄 Laitier (cash-flow constant + multiplication lente)
            🌾 Céréalier (linéaire mais solide, pas de reproduction)
📉 TIER C : 🐑 Ovin (intermédiaire, sous-estimé)
            🐂 Allaitant (extensif, très lent, dépendant des aides)
```

### Pourquoi la poule est TIER S dans SimAgri

La poule cumule **tous les facteurs multiplicateurs** :
1. **Cycle ultra-court** (1 mois incubation vs 9 mois bovin)
2. **Portée élevée** (10/mois vs 1/an bovin)
3. **Maturité rapide** (6 mois vs 24-36 mois bovin)
4. **Triple revenu** (œufs + animaux + viande)
5. **Investissement quasi-nul** (pas de dette)
6. **Coût d'entretien dérisoire** (0,12 kg/j vs 25 kg MS/j pour une vache)

Le **porc** est le seul qui peut rivaliser en volume grâce à sa prolificité (12 porcelets/portée × 2,3/an = 27 naissances/truie/an), mais il nécessite 20-40× plus d'investissement initial.

### Stratégie optimale du joueur SimAgri (méta)

```
Phase 1 (mois 1-3 réels) : 🐔 Poules → multiplication folle, cash rapide
Phase 2 (mois 3-6 réels) : Réinvestir dans 🌾 Terres + 🐄 Lait (diversification)
Phase 3 (mois 6-12 réels) : 🐷 Porcs (si capital suffisant) + 🌾 Extension surface
Endgame : Polyculture-élevage avec toutes les filières
```

---

> **Ce document est une base de conception pour l'équilibrage économique du jeu. Les chiffres sont basés sur les réalités agricoles françaises 2024, adaptés à la temporalité SimAgri (1 semaine = 1 mois). Le calibrage final sera ajusté lors de l'implémentation pour que chaque profil soit viable et intéressant.**
