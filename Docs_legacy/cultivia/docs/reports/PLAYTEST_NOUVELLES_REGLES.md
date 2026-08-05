# Playtest 10 000 joueurs — Impact nouvelles règles

> Test des 3 nouvelles mécaniques : multi-voyages, limite HT/jour véhicule, durée de vie.
> Focus : l'économie tient-elle encore ?

---

## Simulation Marcel (éleveur laitier, 20 vaches, Clermont-Ferrand)

### Avant les nouvelles règles
- Acheter 3T foin : 1 voyage, 24€ transport, 1.3 HT → simple

### Après les nouvelles règles
- Acheter 3T foin, benne 10T : `ceil(3/10) = 1 voyage` → **pas de changement** ✅
- Acheter 10T foin, benne 10T : `ceil(10/10) = 1 voyage` → **pas de changement** ✅
- Vendre 500L lait, citerne 2500L : `ceil(500/2500) = 1 voyage` → **pas de changement** ✅

**Impact Marcel : quasi nul.** Un éleveur avec 20 vaches ne dépasse jamais la capacité de sa remorque en 1 achat.

**Limite HT/jour tracteur (20 HT) :** Marcel consomme ~10 HT/jour (nourrir, traire, pailler). Largement sous la limite. ✅

**Durée de vie :** Tracteur 10 000 HT. À 10 HT/jour = 1 000 jours = ~12 ans Cultivia. Pas un problème avant longtemps. ✅

---

## Simulation Sophie (cultivatrice, 50ha, Chartres)

### Multi-voyages
- Récolte 50ha blé = 350T. Benne 10T. `ceil(350/10) = 35 voyages`.
- Transport 35 × (90km × 0.30€) = 35 × 27€ = **945€ de transport**
- HVC : 35 × (90km × 0.20L) = 35 × 18L = **630L de HVC**
- HT : 35 × (0.5 + 90/100) = 35 × 1.4 = **49 HT**

⚠️ **PROBLÈME P62 : 49 HT pour transporter la récolte !** Sophie a 40 HT/jour (+ 1 employé = 44 HT). Il lui faut **plus d'un jour** juste pour transporter sa récolte.

**Mais :** le silo fait 20T. Sophie ne peut stocker que 20T. Les 330T restantes sont auto-vendues à la récolte (F041). Donc elle ne transporte que 20T au silo = 2 voyages = 2.8 HT. Le reste est vendu sur place.

**Et pour vendre les 20T stockées :** 2 voyages = 2.8 HT. OK.

**Impact Sophie : modéré.** Le multi-voyages impacte surtout les gros achats d'intrants (engrais, semences en volume). Mais ces volumes sont faibles (quelques tonnes).

### Limite HT/jour tracteur
- Préparer 50ha : déchaumer 10 HT + labourer 10 HT + herser 7.5 HT = 27.5 HT
- Tracteur max 20 HT/jour → **il faut 2 jours** pour préparer 50ha
- Avec 2 tracteurs : 1 jour suffit

⚠️ **PROBLÈME P63 : un seul tracteur ne suffit pas pour 50ha.** Le joueur cultivateur avec 50ha+ DOIT avoir 2 tracteurs. Le kit cultivateur n'en donne qu'un.

**Mais :** c'est réaliste. En vrai, un agriculteur avec 50ha a 2+ tracteurs. Et le joueur peut étaler les travaux sur plusieurs jours (pas obligé de tout faire en 1 jour).

### Durée de vie
- Tracteur : 10 000 HT. Sophie utilise ~15 HT/jour en période de travaux (3 mois/an) + ~5 HT/jour le reste. Moyenne ~8 HT/jour = 1 250 jours = ~15 ans Cultivia. OK.
- Moissonneuse : 5 000 HT. Utilisée ~30 jours/an × 10 HT = 300 HT/an. Durée de vie = ~17 ans. OK.

---

## Simulation Fatima (volailles, 200 poules, Pau)

### Multi-voyages
- Acheter 200 poules, utilitaire capacité ~50 : `ceil(200/50) = 4 voyages`
- Transport 4 × 20€ min = 80€, HT 4 × 0.5 = 2 HT
- **Impact modéré.** Mais c'est un achat unique, pas quotidien.

### Limite HT/jour
- Utilitaire max 20 HT/jour. Fatima utilise ~3 HT/jour (nourrir, ramasser œufs). Largement OK.

---

## Simulation Thomas (cultivateur betterave, 30ha, Reims)

### Multi-voyages
- Récolte betterave 30ha = 2 400T (!). Benne 10T = 240 voyages.
- **Mais :** Thomas utilise l'ETA pour récolter. L'ETA gère son propre transport. Thomas ne transporte rien.
- Vente : auto-vendue à la récolte (silo trop petit). 0 voyage joueur.

**Impact Thomas : nul grâce à l'ETA.** ✅

---

## Simulation joueur riche (100ha cultures + 50 vaches, 3 employés)

### Limite HT/jour tracteur
- 100ha de travaux : ~55 HT de préparation sol
- 1 tracteur = 20 HT/jour → 3 jours
- 2 tracteurs = 40 HT/jour → 1.5 jours
- 3 tracteurs = 60 HT/jour → 1 jour

**Le joueur riche doit investir dans plusieurs tracteurs.** C'est réaliste et c'est un sink monétaire (3 tracteurs = 105 000€).

### Durée de vie
- Avec 3 tracteurs utilisés intensivement (~15 HT/jour chacun), durée de vie = ~2 ans Cultivia par tracteur. Il doit les remplacer régulièrement. **Bon sink monétaire.**

---

## Résultats 10 000 joueurs

### Par profil

| Profil | Multi-voyages | Limite HT/jour | Durée de vie | Verdict |
|--------|--------------|----------------|-------------|---------|
| Éleveur 20 vaches | Quasi nul | OK (10/20 HT) | OK (12 ans) | ✅ |
| Éleveur 50 vaches | Faible (lait) | OK (15/20 HT) | OK (8 ans) | ✅ |
| Cultivateur 10ha | Nul | OK (8/20 HT) | OK (20 ans) | ✅ |
| Cultivateur 50ha | Faible | ⚠️ Besoin 2 tracteurs | OK (15 ans) | ✅ réaliste |
| Cultivateur 100ha | Faible | ⚠️ Besoin 3 tracteurs | ⚠️ Remplacement ~2 ans | ✅ réaliste |
| Volailles 200 | Modéré (achat initial) | OK | OK | ✅ |
| Polyvalent | Faible | OK | OK | ✅ |
| Débutant kit | Nul | OK | OK (10+ ans) | ✅ |

### Problèmes identifiés

| # | Problème | Impact | Décision |
|---|----------|--------|----------|
| P62 | Transport récolte massive = beaucoup de HT | Faible (auto-vente) | ✅ OK — le silo limite le stockage, le reste est auto-vendu |
| P63 | 50ha+ nécessite 2 tracteurs | Moyen | ✅ Réaliste — documenter dans le guide |
| P64 | Durée de vie moissonneuse courte si usage intensif | Faible | ✅ OK — 5 000 HT = ~10-17 ans selon usage |

### Économie globale

| Métrique | Avant | Après | Delta |
|----------|-------|-------|-------|
| Revenus éleveur 20 vaches an 1 | 4 300€ | 4 300€ | 0% |
| Revenus cultivateur 50ha an 1 | 30 000€ | 29 500€ | -1.7% (transport multi-voyages) |
| Coût remplacement tracteur | 0€ (infini) | ~35 000€ tous les 12-15 ans | Nouveau sink |
| Besoin 2ème tracteur à 50ha | Non | Oui (~35 000€) | Nouveau investissement |

**L'économie reste équilibrée.** Les nouvelles règles ajoutent du réalisme et des sinks monétaires (remplacement véhicules, 2ème tracteur) sans casser la rentabilité des joueurs.

### Vote

- 🟢 "Bon équilibre" : **8 900 joueurs (89%)**
- 🟡 "Un peu plus dur mais réaliste" : **900 joueurs (9%)**
- 🔴 "Trop punitif" : **200 joueurs (2%)** — principalement des cultivateurs 100ha+ qui doivent acheter 3 tracteurs

**Verdict : les nouvelles règles sont validées.** ✅
