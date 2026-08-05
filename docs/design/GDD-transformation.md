> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Transformation et valorisation

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-metiers.md` §4, §6, §7, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `decisions/ADR-003-expert-nest-pas-plus-rentable.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

La transformation est la **voie de la valeur ajoutée** : le joueur convertit sa matière première brute en produit fini pour multiplier sa valeur par 2 à 5. Mais cette multiplication a un coût : du **temps de travail**, du **capital** et de la **gestion**.

**L'arbitrage fondamental** : volume brut vs valeur transformée. Un éleveur caprin peut vendre 500 L de lait à 0,70 €/L (350 €) ou transformer en 70 kg de fromage à 18 €/kg (1 260 €). Mais la transformation consomme 2 à 3 h/jour là où la vente brute en consomme 5 min.

**Ce qui rend la transformation plaisante** :
1. **Le multiplicateur de valeur** — voir 1 L de lait à 0,70 € devenir 0,14 kg de fromage à 18 €/kg
2. **La maîtrise d'un savoir-faire** — progresser en compétences, créer un produit unique
3. **L'investissement long terme** — affiner 12 mois pour un fromage premium
4. **La diversification** — ne pas dépendre d'un seul revenu

**Ce que SimAgri fait bien** : la fromagerie (8/10) — compétences, affinage, DLC, marchés. Un vrai mini-jeu de gestion dans le jeu.

**Ce que SimAgri rate** : pas de photovoltaïque (revenu passif n°1 des fermes 2024), pas de vente directe viande (circuit court n°1 en élevage), pas de transformation céréales.

**Ce qu'Agriva ajoute** : photovoltaïque, vente directe viande, huilerie/farine/bière, et le système AOP pour la fromagerie.

### 1.2 Gameplay loop

```
┌──────────────────────────────────────────────────────────────┐
│  BOUCLE QUOTIDIENNE                                          │
├──────────────────────────────────────────────────────────────┤
│  Collecter la matière première (lait, grain, viande)         │
│  Lancer une transformation (emprésurage, pressage, découpe)  │
│  Surveiller l'affinage / la fermentation en cours            │
│  Vendre les produits arrivés à maturité                      │
│         ↓                                                    │
│  Revenus quotidiens (fromage frais, caissettes, électricité) │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE MENSUELLE                                            │
├──────────────────────────────────────────────────────────────┤
│  Vérifier les DLC (fromages qui périment)                    │
│  Ajuster le volume de production au débouché                 │
│  Entretenir le matériel (digesteur, panneaux, atelier)       │
│  Payer les charges (employés, énergie, emprunt)              │
│         ↓                                                    │
│  Bilan mensuel : marge nette de transformation               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE ANNUELLE                                             │
├──────────────────────────────────────────────────────────────┤
│  Investir : agrandir l'atelier ? nouveau digesteur ?         │
│  Embaucher : fromager, boucher, technicien                   │
│  Diversifier : nouvelle filière de transformation            │
│  Candidater à une AOP (si conditions remplies)               │
│         ↓                                                    │
│  Progression : compétences, capacité, gamme de produits      │
└──────────────────────────────────────────────────────────────┘
```

### 1.3 Décisions du joueur

| Décision | Fréquence | Enjeu |
|----------|:---------:|-------|
| Vendre brut ou transformer ? | Quotidienne | Temps vs argent |
| Quel volume transformer ? | Quotidienne | DLC = risque de perte |
| Quel type de fromage ? | Hebdomadaire | Rendement vs prix vs durée |
| Investir dans un atelier ? | Ponctuelle | Capital vs ROI |
| Embaucher un fromager ? | Ponctuelle | Libérer du temps vs charges |
| Viser l'AOP ? | Annuelle | Contraintes vs survaleur |
| Dimensionner le digesteur ? | Ponctuelle | Trop petit = sous-revenu, trop grand = charges fixes |

### 1.4 Différences Normal / Expert (synthèse)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Fromagerie | Lait → fromage en 1 action, vente auto | 6 compétences, affinage, DLC, AOP |
| Méthanisation | Substrats → revenu fixe/mois | Dimensionnement, CIVE, panne, usure |
| Photovoltaïque | Investir → revenu passif/mois | Autoconsommation vs revente, dégradation |
| Vente directe | Viande → caissette en 1 action | Découpe, clientèle, commercialisation |
| Charges | 12% du CA | 28% du CA (entretien, énergie, personnel) |



---

## 2. Fromagerie

Le système le plus riche de la transformation. SimAgri le modélise bien (8/10) — Agriva le conserve et l'enrichit avec l'AOP et la progression des compétences.

### 2.1 Trois niveaux de fromagerie

| Niveau | Qui transforme | Capacité | Investissement | Temps/jour |
|--------|---------------|:--------:|:--------------:|:----------:|
| Fermière | Le joueur lui-même | 50-200 L/jour | 30 000 € | 1 h 30 – 2 h 30 |
| Artisanale | 1 fromager employé | 200-1 000 L/jour | 80 000 € | 30 min (supervision) |
| Industrielle | 2-10 fromagers | 1 000-10 000 L/jour | 200 000-500 000 € | 15 min (gestion) |

**Fermière** : le joueur réalise chaque étape. Rentable à petite échelle, mais très consommatrice en temps de travail. Idéal pour un caprin avec 30-50 chèvres.

**Artisanale** : un fromager employé (salaire 2 200 €/mois) effectue la transformation. Le joueur supervise et décide. Rentable à partir de 500 L/jour.

**Industrielle** : plusieurs fromagers, production de volume. Le joueur est gestionnaire. Rentable à partir de 2 000 L/jour, compétitif sur les marchés de gros.

### 2.2 Rendements et prix

| Type de fromage | Lait nécessaire | Prix de vente | Affinage | DLC après affinage |
|----------------|:--------------:|:------------:|:--------:|:-----------------:|
| Chèvre frais | 5-6 L/kg | 12-18 €/kg | 0 (frais) | 14 jours |
| Pâte molle (Camembert) | 7-8 L/kg | 10-20 €/kg | 2-8 semaines | 30 jours |
| Tomme | 8-10 L/kg | 12-20 €/kg | 2-4 mois | 45 jours |
| Pâte pressée (Comté) | 10-12 L/kg | 15-30 €/kg | 6-24 mois | 60 jours |
| Pâte persillée (Roquefort) | 10-12 L brebis/kg | 20-40 €/kg | 3-6 mois | 45 jours |

**Formule de production :**
```
kg_fromage = litres_lait / rendement_type
prix_total = kg_fromage × prix_base × coef_qualité × coef_AOP
coef_qualité = 0.7 + (indice_qualité × 0.006)  // indice 0-100 → coef 0.7-1.3
coef_AOP = 1.0 (générique) | 1.3-3.0 (AOP selon type)
```

### 2.3 Compétences du fromager (mode Expert)

6 axes de compétence, chacun noté de 1 à 10. Les compétences progressent avec la pratique (+0,1/semaine d'activité, cap à 10).

| Compétence | Effet sur le fromage | Progression |
|------------|---------------------|:-----------:|
| Emprésurage | Texture du caillé, régularité | +0,1/sem |
| Découpe | Taille des grains, homogénéité | +0,1/sem |
| Moulage | Forme, densité, aspect | +0,1/sem |
| Égouttage | Humidité résiduelle, conservation | +0,1/sem |
| Salage | Goût, croûte, conservation | +0,1/sem |
| Affinage | Maturation, développement arômes | +0,1/sem |

**Indice qualité global :**
```
indice_qualité = (emprésurage + découpe + moulage + égouttage + salage + affinage) / 6 × 10
// Un fromager débutant (toutes compétences à 3) → indice 30
// Un fromager expérimenté (compétences 7-8) → indice 75
// Un maître fromager (compétences 9-10) → indice 95
```

**En Normal** : pas de compétences visibles. Le fromage a une qualité fixe de 70 (« bon »). Pas de progression.

### 2.4 Affinage

L'affinage est le **temps de maturation** du fromage en cave. Pendant l'affinage, l'indice qualité évolue :

```
qualité_affinage(jour) = qualité_base + bonus_affinage × (jour / durée_optimale)
// Si jour > durée_optimale × 1.2 : qualité commence à baisser (suraffinage)
// Si jour < durée_optimale × 0.5 : fromage immature (malus -20%)
bonus_affinage = compétence_affinage × 2  // fromager compétent = meilleur affinage
```

| Type | Durée optimale | Bonus max affinage | Fenêtre de vente |
|------|:-------------:|:-----------------:|:----------------:|
| Chèvre frais | 0 jours | 0 | Immédiat → DLC 14j |
| Pâte molle | 21-42 jours | +15 qualité | Semaine 3-6 |
| Tomme | 60-120 jours | +20 qualité | Mois 2-4 |
| Pâte pressée | 180-720 jours | +30 qualité | Mois 6-24 |
| Pâte persillée | 90-180 jours | +25 qualité | Mois 3-6 |

**En Normal** : l'affinage est automatique. Le joueur lance la production, le fromage est prêt à la date optimale et se vend automatiquement.

### 2.5 DLC et gestion des stocks

**Le fromage périme.** C'est la tension de gestion fondamentale : ne pas surproduire.

```
Si date_actuelle > date_fabrication + durée_affinage + DLC :
    fromage = perdu (valeur = 0)
    pénalité_hygiène si non retiré sous 7 jours
```

| Alerte | Condition | Action suggérée |
|--------|-----------|-----------------|
| 🟢 Frais | > 50% DLC restante | Vente au prix plein |
| 🟡 Proche péremption | 25-50% DLC restante | Réduction -20% |
| 🔴 Urgent | < 25% DLC restante | Réduction -50% ou perte |

**En Normal** : pas de DLC. Le fromage se vend toujours (pas de perte possible, ADR-002 respecté).

### 2.6 Sous-produits

La transformation du lait génère des sous-produits valorisables :

```
1 L de lait → 0,0375 L de crème (écrémage)
1 L de crème → 0,48 kg de beurre (barattage)
```

| Sous-produit | Rendement | Prix de vente | Temps nécessaire |
|--------------|:---------:|:------------:|:----------------:|
| Crème fraîche | 0,0375 L/L de lait | 4,50 €/L | 15 min/50 L |
| Beurre | 0,48 kg/L de crème | 8,00 €/kg | 30 min/10 kg |
| Petit-lait (lactosérum) | 0,85 L/L de lait transformé | 0,10 €/L (alimentation animale) | 0 min |

### 2.7 AOP — Appellation d'Origine Protégée (mode Expert)

L'AOP impose des contraintes strictes en échange d'une **survaleur de +30% à +200%** sur le prix.

**Cahier des charges AOP (conditions cumulatives) :**

| Contrainte | Exemple Comté | Exemple Chèvre AOP |
|------------|--------------|---------------------|
| Race | Montbéliarde ou Simmental | Alpine ou Saanen |
| Zone géographique | Parcelle en zone AOP | Parcelle en zone AOP |
| Alimentation | > 70% herbe, 0% OGM, 0% ensilage | > 80% pâturage |
| Transformation | Sur place, lait cru | Sur place, lait cru |
| Affinage minimum | 120 jours (4 mois) | Variable selon type |

**Survaleur AOP :**

| AOP | Type | Survaleur | Prix résultant |
|-----|------|:---------:|:--------------:|
| Comté | Pâte pressée cuite | +100% | 30-45 €/kg |
| Reblochon | Pâte pressée non cuite | +80% | 22-30 €/kg |
| Camembert de Normandie | Pâte molle | +60% | 18-28 €/kg |
| Crottin de Chavignol | Chèvre | +50% | 20-30 €/kg |
| Roquefort | Pâte persillée brebis | +200% | 40-60 €/kg |

**En Normal** : pas d'AOP. Tous les fromages sont « génériques » et se vendent au prix de base.



---

## 3. Méthanisation

Investissement lourd, revenu stable garanti sur 15-20 ans. La méthanisation valorise les effluents d'élevage et les résidus de cultures en énergie + engrais.

### 3.1 Dimensionnement

| Taille | Puissance | Investissement | Substrat/an | Joueur type |
|--------|:---------:|:--------------:|:-----------:|-------------|
| Micro | 50 kW | 500 000 € | 3 000 t | Éleveur solo (50-80 UGB) |
| Petite | 150 kW | 1 200 000 € | 8 000 t | Éleveur moyen (150-250 UGB) |
| Moyenne | 300 kW | 2 000 000 € | 15 000 t | Gros éleveur ou collectif |
| Grande | 500 kW | 2 500 000 € | 25 000 t | CAR ou collectif de 3-5 joueurs |

### 3.2 Substrats

| Substrat | Part recommandée | Pouvoir méthanogène | Source |
|----------|:----------------:|:-------------------:|--------|
| Effluents (fumier, lisier) | 40-60% | Faible | Élevage propre (gratuit) |
| CIVE (seigle, avoine) | 15-25% | Moyen | Culture intermédiaire |
| Résidus cultures (paille) | 5-10% | Faible | Récolte propre |
| Déchets IAA | 10-20% | Élevé | Achat (5-15 €/t) |
| Maïs ensilé (plafonné 15%) | 0-15% | Élevé | Culture propre |

**Formule de production biogaz :**
```
biogaz_m3_jour = somme(substrat_tonnes_jour × pouvoir_méthanogène)
electricite_kWh = biogaz_m3_jour × 2.2 × rendement_moteur  // rendement = 0.38
chaleur_kWh = biogaz_m3_jour × 2.2 × 0.42
digestat_tonnes = substrat_total × 0.85  // 85% de la masse initiale
```

### 3.3 Produits et revenus

| Produit | Recette annuelle (150 kW) | Tarif |
|---------|:-------------------------:|-------|
| Électricité (cogénération) | 180 000-250 000 € | Tarif garanti 20 c€/kWh × 15-20 ans |
| Chaleur valorisée | 20 000-40 000 € | Séchage, serres, chauffage |
| Digestat (économie engrais) | 10 000-30 000 € | Remplace 80-120 €/ha d'engrais chimique |
| **Total recettes** | **210 000-320 000 €** | |

| Charge | Montant annuel (150 kW) |
|--------|:-----------------------:|
| Maintenance moteur | 30 000-50 000 € |
| Substrats achetés | 10 000-25 000 € |
| Personnel / suivi | 15 000-25 000 € |
| Assurance + divers | 10 000-20 000 € |
| **Total charges** | **80 000-120 000 €** |
| Annuités emprunt (15 ans) | 80 000-130 000 € |
| **Revenu net** | **50 000-150 000 €** |

### 3.4 Panne et usure (mode Expert)

Le digesteur s'use et peut tomber en panne :

```
usure_mensuelle = 1.5%  // durée de vie théorique = 66 mois sans entretien
entretien_mensuel → réduit usure à 0.5%/mois (coût 3 000-5 000 €)
Si usure > 80% : risque_panne = (usure - 80) × 5%  // à 100% = panne certaine
Panne : production = 0 pendant 7-21 jours, réparation = 15 000-50 000 €
```

| État | Usure | Production | Action |
|------|:-----:|:----------:|--------|
| 🟢 Bon | 0-40% | 100% | Entretien standard |
| 🟡 Usé | 40-70% | 90-100% | Entretien renforcé conseillé |
| 🔴 Critique | 70-100% | 70-90% + risque panne | Révision majeure (30 000 €) |

**En Normal** : pas de panne, pas d'usure. Le digesteur produit un revenu fixe chaque mois. Entretien = charge forfaitaire intégrée aux 12%.

### 3.5 Gestion des substrats (mode Expert)

Le joueur doit **alimenter le digesteur quotidiennement** avec le bon mix :

- Si effluents < 40% : rendement biogaz -20% (acidification)
- Si maïs > 15% : pénalité réglementaire (amende 5 000 €/mois)
- Si digesteur sous-alimenté (< 70% capacité) : rendement -30%
- Si digesteur sur-alimenté (> 110% capacité) : usure ×2

**En Normal** : le digesteur consomme automatiquement les substrats disponibles au ratio optimal.



---

## 4. Photovoltaïque

Absent de SimAgri. C'est le **revenu passif n°1 des fermes françaises en 2024**. Simple à comprendre, long à rentabiliser, zéro temps de travail une fois installé.

### 4.1 Types d'installation

| Type | Puissance | Investissement | Revenu annuel | ROI | Temps/mois |
|------|:---------:|:--------------:|:------------:|:---:|:----------:|
| Toiture petit bâtiment | 36 kWc | 40 000 € | 4 500-5 500 € | 7-9 ans | 0 min |
| Toiture grand bâtiment | 100 kWc | 100 000 € | 10 000-15 000 € | 7-10 ans | 0 min |
| Au sol | 1 000 kWc (1 MWc) | 700 000-1 000 000 € | 80 000-120 000 € | 8-12 ans | 0 min |
| Agrivoltaïsme | 500 kWc + culture | 200 000 € | 25 000-35 000 € | 7-10 ans | 0 min |

**Prérequis** : posséder un bâtiment (toiture) ou un terrain (au sol).

### 4.2 Mécanique

```
revenu_annuel = puissance_kWc × heures_ensoleillement × tarif_rachat × (1 - dégradation)
// heures_ensoleillement = 1000-1400 h/an selon région
// tarif_rachat = 0.10-0.13 €/kWh (contrat 20 ans)
// dégradation = 0.5%/an (panneau perd 0.5% de rendement/an)
```

### 4.3 Autoconsommation vs revente (mode Expert)

| Mode | Avantage | Inconvénient |
|------|----------|--------------|
| Revente totale | Revenu garanti, stable | Tarif fixe (pas d'optimisation) |
| Autoconsommation + surplus | Économie sur la facture + vente surplus | Variable selon consommation |
| Autoconsommation totale | Indépendance énergétique | Pas de revenu direct, besoin batterie |

**En Normal** : revente totale uniquement. L'installation produit un revenu fixe mensuel = `investissement / (ROI_années × 12)` pendant 20 ans.

**En Expert** : le joueur choisit le mode. L'autoconsommation réduit les charges d'exploitation (chauffage, séchage, robot traite). Le surplus est vendu.

### 4.4 Entretien et durée de vie

- Durée de vie : 25-30 ans (dégradation 0,5%/an)
- Entretien : 500-1 500 €/an (nettoyage, onduleur)
- Remplacement onduleur : 10 000-20 000 € à 12-15 ans
- En Normal : aucun entretien nécessaire (intégré aux charges 12%)



---

## 5. Vente directe viande

Absent de SimAgri. C'est le **circuit court n°1 en élevage allaitant**. Le joueur découpe et vend directement, sans passer par l'abattoir/grossiste.

### 5.1 Investissement et capacité

| Niveau | Investissement | Capacité | Temps/animal | Marge vs abattoir |
|--------|:--------------:|:--------:|:------------:|:-----------------:|
| Atelier de découpe basique | 20 000 € | 2-4 bovins/mois | 1 h 00 | ×2 |
| Atelier équipé | 50 000 € | 5-10 bovins/mois | 45 min | ×2,5 |
| Atelier professionnel | 80 000 € | 10-20 bovins/mois | 30 min | ×3 |

### 5.2 Produit : la caissette

| Format | Poids | Prix de vente | Contenu |
|--------|:-----:|:------------:|---------|
| Caissette découverte | 5 kg | 75 € (15 €/kg) | Mix steaks, rôtis, bourguignon |
| Caissette premium | 5 kg | 90 € (18 €/kg) | Pièces nobles uniquement |
| Caissette familiale | 10 kg | 130 € (13 €/kg) | Mix complet (os inclus) |
| Colis agneau | 5 kg | 80 € (16 €/kg) | Demi-agneau |
| Colis porc | 10 kg | 100 € (10 €/kg) | Demi-porc |

**Comparaison avec vente abattoir :**
```
Bovin (400 kg carcasse) :
  - Vente abattoir : 400 kg × 4,50 €/kg = 1 800 €
  - Vente caissettes : 280 kg vendable × 14 €/kg = 3 920 €
  - Multiplicateur = ×2,2
  - Mais : 1 h + trouver les clients
```

### 5.3 Clientèle (mode Expert)

En Expert, le joueur doit **constituer et fidéliser une clientèle** :

| Source de clients | Coût | Clients gagnés | Fidélité |
|-------------------|:----:|:--------------:|:--------:|
| Bouche à oreille | 0 € | 1-2/mois | 80% |
| Marché local | 30 min/semaine | 3-5/mois | 50% |
| Site internet | 3 000 € + 15 min/sem | 5-10/mois | 60% |
| Drive fermier | 500 €/an adhésion | 3-8/mois | 70% |

```
ventes_max_mois = nombre_clients_actifs × taux_commande  // taux_commande = 0.3/mois
Si production > ventes_max : invendus → congélateur (DLC 6 mois) ou perte
```

**En Normal** : pas de gestion de clientèle. Les caissettes se vendent automatiquement au prix fixe. Pas d'invendu.



---

## 6. Autres transformations

Systèmes plus simples, traités avec moins de profondeur. Chacun suit le même principe : investissement + temps de travail → multiplicateur de valeur.

### 6.1 Huilerie

| Paramètre | Valeur |
|-----------|--------|
| Investissement | 30 000-50 000 € (pressoir + filtration) |
| Matière première | Colza, tournesol |
| Rendement | 1 t colza → 400 L huile + 600 kg tourteau |
| Prix huile | 3,50-5,00 €/L (vs colza brut 450 €/t) |
| Tourteau | Alimentation animale, 250-350 €/t |
| HVC carburant | 1,20 €/L (autoconsommation tracteur) |
| Temps | 30 min/tonne pressée |
| Multiplicateur | ×2,5-3,5 |

### 6.2 Farine (moulin)

| Paramètre | Valeur |
|-----------|--------|
| Investissement | 40 000-80 000 € (moulin à meule de pierre) |
| Matière première | Blé tendre, seigle, épeautre |
| Rendement | 1 t blé → 750 kg farine + 250 kg son |
| Prix farine | 1,20-2,50 €/kg (vs blé 220 €/t) |
| Son | Alimentation animale, 180 €/t |
| Temps | 30 min/tonne |
| Multiplicateur | ×3-5 |

### 6.3 Jus de pomme

| Paramètre | Valeur |
|-----------|--------|
| Investissement | 15 000-40 000 € (pressoir + pasteurisateur) |
| Matière première | Pommes (verger) |
| Rendement | 1 t pommes → 650-700 L jus |
| Prix jus | 2,50-4,00 €/L (vs pommes 300-500 €/t) |
| Temps | 45 min/tonne |
| Multiplicateur | ×4-5 |

### 6.4 Confiture

| Paramètre | Valeur |
|-----------|--------|
| Investissement | 8 000-20 000 € (cuiseur + mise en pot) |
| Matière première | Fruits (fraise, abricot, cerise) |
| Rendement | 1 kg fruit + 0,6 kg sucre → 1,2 kg confiture |
| Prix confiture | 8-15 €/kg |
| Temps | 30 min/50 pots |
| Multiplicateur | ×3-6 |

### 6.5 Bière artisanale

| Paramètre | Valeur |
|-----------|--------|
| Investissement | 80 000-200 000 € (malterie + brasserie) |
| Matière première | Orge (maltage) + houblon |
| Rendement | 200 kg orge → 1 000 L bière |
| Prix bière | 4-8 €/L (vs orge 200 €/t) |
| Temps | 1 h/brassin (1 000 L) |
| Multiplicateur | ×5-10 |
| Particularité | Fermentation 2-4 semaines, gamme de recettes |

### 6.6 Tableau récapitulatif des transformations

| Filière | Investissement | Temps/unité | Multiplicateur | Complexité |
|---------|:--------------:|:-----------:|:--------------:|:----------:|
| Fromagerie | 30-500k € | 1 h 30 – 2 h 30/jour | ×3-5 | ★★★★★ |
| Méthanisation | 500k-2,5M € | 15-30 min/jour | Revenu fixe | ★★★★☆ |
| Photovoltaïque | 40k-1M € | 0 min | Revenu passif | ★☆☆☆☆ |
| Vente directe viande | 20-80k € | 30 min – 1 h/animal | ×2-3 | ★★★☆☆ |
| Huilerie | 30-50k € | 30 min/t | ×2,5-3,5 | ★★☆☆☆ |
| Farine | 40-80k € | 30 min/t | ×3-5 | ★★☆☆☆ |
| Jus de pomme | 15-40k € | 45 min/t | ×4-5 | ★★☆☆☆ |
| Confiture | 8-20k € | 30 min/50 pots | ×3-6 | ★★☆☆☆ |
| Bière | 80-200k € | 1 h/brassin | ×5-10 | ★★★☆☆ |



---

## 7. Équilibrage et scénarios

### 7.1 Objectifs d'équilibrage

| Objectif | Cible | Garde-fou |
|----------|-------|-----------|
| Multiplicateur fromage | ×3-5 vs lait brut | Limité par le temps (1 h 30 – 2 h 30/jour) |
| Multiplicateur viande directe | ×2-3 vs abattoir | Limité par clientèle |
| ROI photovoltaïque | 7-10 ans | Pas d'enrichissement rapide |
| ROI méthanisation | 8-12 ans | Charges + emprunt |
| Temps max transformation/jour | 2 h 30 – 3 h 45 | Un joueur ne peut pas TOUT transformer |
| Part max transformation dans le revenu | 40-60% | Ne doit pas écraser l'activité agricole principale |
| Serveur Expert internement équilibré | Chaque serveur est viable en lui-même (ADR-005) | Comparaison informative — les deux serveurs étant séparés, aucune équivalence de rentabilité n'est requise |

### 7.2 Mockup — Interface fromagerie (mode Normal)

```
┌─────────────────────────────────────────────────────────────────┐
│  🧀 FROMAGERIE FERMIÈRE — La Chèvrerie du Vallon              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📦 Lait disponible : 180 L (chèvre)                           │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  PRODUIRE DU FROMAGE              [▼ Type : Crottin]    │   │
│  │                                                         │   │
│  │  Quantité : [■■■■■■■■░░] 150 L → 25 crottins           │   │
│  │  Coût temps : ⏱️ 2 h                                     │   │
│  │  Prêt dans : 21 jours (affinage auto)                   │   │
│  │  Valeur estimée : 25 × 14 € = 350 €                    │   │
│  │                                                         │   │
│  │  💡 Vendre le lait brut : 150 × 0,70 = 105 €           │   │
│  │  💡 Gain transformation : +245 € (+233%)                │   │
│  │                                                         │   │
│  │              [ 🧀 Lancer la production ]                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  📊 EN CAVE (affinage en cours) :                              │
│  ┌───────────────┬──────────┬───────────┬──────────┐           │
│  │ Lot           │ Type     │ Prêt dans │ Valeur   │           │
│  ├───────────────┼──────────┼───────────┼──────────┤           │
│  │ Lot #47       │ Crottin  │ 3 jours   │ 280 €    │           │
│  │ Lot #46       │ Tomme    │ 45 jours  │ 520 €    │           │
│  │ Lot #44       │ Crottin  │ ✅ Prêt   │ 350 €    │           │
│  └───────────────┴──────────┴───────────┴──────────┘           │
│                                                                 │
│  [ Vendre tout ce qui est prêt : 350 € ]                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 7.3 Mockup — Interface fromagerie (mode Expert)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🧀 FROMAGERIE ARTISANALE — Gaec des Alpages        [AOP Reblochon] │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  👨‍🍳 Fromager : Jean-Pierre (exp. 4 ans)                            │
│  ┌──────────────────────────────────────────────────────┐           │
│  │ Emprésurage ■■■■■■■░░░ 7.2  │ Égouttage ■■■■■■░░░░ 6.4 │       │
│  │ Découpe    ■■■■■■■■░░ 7.8  │ Salage    ■■■■■■■░░░ 6.9 │       │
│  │ Moulage    ■■■■■■░░░░ 6.1  │ Affinage  ■■■■■■■■░░ 8.0 │       │
│  └──────────────────────────────────────────────────────┘           │
│  Indice qualité moyen : 71/100                                      │
│                                                                     │
│  📦 Lait du jour : 800 L (vache Abondance — AOP compatible ✅)     │
│                                                                     │
│  PRODUCTION :                                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ Type : Reblochon AOP    Lait : 600 L → 75 kg                │   │
│  │ Affinage : 6 semaines   DLC après : 30 jours                │   │
│  │ Qualité estimée : 71 + 16 (affinage) = 87/100               │   │
│  │ Prix estimé : 75 × 22 € × 1.10 (qualité) = 1 815 €         │   │
│  │ Coef AOP : ×1.8 → prix final estimé : 3 267 €              │   │
│  │ Temps : 30 min (supervision)    Coût main d'œuvre : 110 €/jour      │   │
│  │                                                              │   │
│  │ ⚠️ AOP : vérifier alimentation troupeau (pâturage > 70%)    │   │
│  │              [ Lancer ]  [ Modifier le type ]                │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  📊 CAVE D'AFFINAGE (capacité 500 kg / 420 kg occupés) :           │
│  ┌──────────┬──────────┬─────────┬──────────┬───────┬───────────┐  │
│  │ Lot      │ Type     │ Qualité │ Affinage │ DLC   │ Statut    │  │
│  ├──────────┼──────────┼─────────┼──────────┼───────┼───────────┤  │
│  │ #201     │ Reblochon│ 84/100  │ 38/42 j  │ 30j   │ 🟢 Bientôt│  │
│  │ #198     │ Reblochon│ 79/100  │ 42/42 j  │ 22j   │ 🟡 Vendre │  │
│  │ #195     │ Tomme    │ 72/100  │ 55/90 j  │ —     │ 🟢 Mature │  │
│  │ #190     │ Reblochon│ 88/100  │ 42/42 j  │ 8j    │ 🔴 Urgent │  │
│  └──────────┴──────────┴─────────┴──────────┴───────┴───────────┘  │
│                                                                     │
│  [ Vendre #198 + #190 : 145 kg × 22 € × qual × AOP = 4 980 € ]   │
│                                                                     │
│  📈 Sous-produits du jour : 30 L crème → [ Beurre ] [ Vendre ]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.4 Scénario chiffré n°1 — Fromagerie caprine fermière

**Profil** : joueur caprin, 50 chèvres Alpine, 150 L/jour, fromagerie fermière.

| Poste | Calcul | Résultat |
|-------|--------|:--------:|
| Lait produit/jour | 50 chèvres × 3 L/jour | 150 L |
| Vente lait brut (référence) | 150 L × 0,70 €/L | 105 €/jour |
| **Option A : tout vendre brut** | 105 € × 30 jours | **3 150 €/mois** |
| Temps consommé (vente brute) | 5 min/jour | 2 h 30/mois |

| Poste | Calcul | Résultat |
|-------|--------|:--------:|
| Fromage produit/jour | 150 L / 5,5 L/kg (crottin) | 27 kg |
| Prix vente (qualité 70) | 27 kg × 14 €/kg × 1,0 | 378 €/jour |
| **Option B : tout transformer** | 378 € × 30 jours | **11 340 €/mois brut** |
| Charges exploitation (Normal 12% du CA) | 11 340 × 0,12 | -1 361 € |
| Bénéfice avant charges sociales | | 9 979 €/mois |
| Charges sociales (12% du bénéfice, ADR-002) | 9 979 × 0,12 | -1 197 € |
| **Résultat net Normal** | | **8 782 €/mois** |
| Temps consommé | 2 h/jour | 60 h/mois |

| Poste (Expert) | Calcul | Résultat |
|-------|--------|:--------:|
| Fromage avec qualité 75 | 27 kg × 14 € × 1,15 (qual) | 435 €/jour |
| Crème sous-produit | 150 L × 0,0375 = 5,6 L → beurre 2,7 kg | +22 €/jour |
| **Revenu brut Expert** | (435 + 22) × 30 | **13 710 €/mois** |
| Charges exploitation Expert (28% du CA) | 13 710 × 0,28 | -3 839 € |
| Bénéfice avant charges sociales | | 9 871 €/mois |
| Charges sociales (28% du bénéfice, ADR-003) | 9 871 × 0,28 | -2 764 € |
| **Résultat net Expert** | | **7 107 €/mois** |
| Temps consommé | 2 h 30/jour (+ beurre) | 75 h/mois |

**Bilan** :
- Multiplicateur vs lait brut : ×2,8 (Normal) / ×2,3 (Expert)
- Coût en temps : ×8 (Normal) / ×10 (Expert)
- Expert < Normal en revenu net (comparaison informative — les deux serveurs étant séparés, aucune équivalence de rentabilité n'est requise, cf. ADR-005)
- Le joueur qui transforme TOUT n'a plus de temps pour autre chose → arbitrage

**Variante AOP** (Expert uniquement) :
- Crottin de Chavignol AOP : 14 € × 1,5 (AOP) = 21 €/kg
- Revenu brut AOP : 27 kg × 21 € × 1,15 = 651 €/jour → 19 530 €/mois
- Charges exploitation 28% : -5 468 €
- Bénéfice avant charges sociales : 14 062 €/mois
- Charges sociales (28% du bénéfice, ADR-003) : -3 937 €
- Contraintes AOP : race Alpine obligatoire ✅, zone AOP, pâturage > 80%
- **Résultat net AOP : 10 125 €/mois** (×3,2 vs lait brut — mais contraintes fortes)

### 7.5 Scénario chiffré n°2 — Méthanisation 150 kW

**Profil** : éleveur bovin laitier, 120 vaches, investit dans un méthaniseur 150 kW.

| Poste | Valeur |
|-------|:------:|
| Investissement total | 1 200 000 € |
| Emprunt (15 ans, 3,5%) | 1 200 000 € |
| Annuité | 103 000 €/an |

**Substrats disponibles (propres + achetés) :**

| Substrat | Quantité/an | Coût | Part |
|----------|:-----------:|:----:|:----:|
| Fumier/lisier (120 vaches) | 4 800 t | 0 € (propre) | 55% |
| CIVE (20 ha × 8 t/ha) | 1 600 t | 0 € (propre) | 18% |
| Résidus cultures | 400 t | 0 € (propre) | 5% |
| Déchets IAA achetés | 1 900 t | 19 000 € | 22% |
| **Total** | **8 700 t** | **19 000 €** | 100% |

**Revenus annuels :**

| Produit | Calcul | Montant |
|---------|--------|:-------:|
| Électricité | 150 kW × 8 000 h × 0,20 €/kWh × 0,38 (rend.) | 91 200 € |
| Prime cogé (tarif garanti) | Complément tarif | +120 000 € |
| Chaleur valorisée | Séchage foin + chauffage | 30 000 € |
| Économie engrais (digestat) | 120 ha × 120 €/ha | 14 400 € |
| **Total recettes** | | **255 600 €** |

**Charges annuelles :**

| Charge | Montant |
|--------|:-------:|
| Maintenance moteur + digesteur | 42 000 € |
| Substrats achetés | 19 000 € |
| Personnel (0,3 ETP) | 15 000 € |
| Assurance | 8 000 € |
| Annuité emprunt | 103 000 € |
| **Total charges** | **187 000 €** |

**Bilan :**

| Indicateur | Normal | Expert |
|------------|:------:|:------:|
| Revenu net/an | 68 600 € | 68 600 € |
| Revenu net/mois | 5 717 € | 5 717 € |
| ROI (hors emprunt) | 7,8 ans | 7,8 ans |
| Temps/jour | 15 min (supervision) | 30 min (gestion substrats) |
| Risque panne | Non | Oui (coût 15-50k€) |
| Charges (mode) | 12% forfait | 28% détaillé |

**En Normal** : le joueur perçoit un revenu simplifié. Recettes 255 600 € - charges exploitation forfaitaires 12% (30 672 €) = 224 928 €. Annuité remboursement : -103 000 €. Bénéfice avant charges sociales = 121 928 €. Charges sociales (12% du bénéfice, ADR-002) = -14 631 €. **Résultat net = 107 297 €/an soit 8 941 €/mois**.

**En Expert** : revenu identique en brut mais le joueur gère activement les substrats, l'usure et les pannes. Recettes 255 600 € - charges détaillées 28% (71 568 €) = 184 032 €. Annuité : -103 000 €. Bénéfice avant charges sociales = 81 032 €. Charges sociales (28% du bénéfice, ADR-003) = -22 689 €. **Résultat net = 58 343 €/an soit 4 862 €/mois**. Mauvaise gestion → rendement -20 à -30%.



### 7.6 Détection des problèmes et corrections

| Problème détecté | Cause | Correction appliquée |
|------------------|-------|---------------------|
| Fromage trop rentable vs lait brut (×5+) | Temps insuffisant comme frein | Temps fromage fermière = 2 h/jour minimum (limite le volume) |
| PV = argent gratuit sans gameplay | 0 h, 0 risque | ROI long (7-10 ans), dégradation 0,5%/an, remplacement onduleur |
| Expert plus rentable que Normal | Qualité + AOP = surprofit | Charges 28% vs 12% neutralisent l'avantage (ADR-003) |
| Méthanisation sans risque = OP | Revenu fixe garanti | Panne possible en Expert, investissement très lourd |
| Transformation écrase l'élevage | Tout le revenu vient du fromage | Plafond de temps : impossible de transformer ET gérer 200 vaches |

### 7.7 Checklist playtest

| Test | Critère | Bloquant |
|------|---------|:--------:|
| Test recette SimAgri | Un joueur SimAgri dit « c'est SimAgri en mieux » pour la fromagerie Normal | ✅ Bloquant |
| Pas de perte en Normal | Aucun fromage ne périme, aucune panne, aucune faillite | ✅ Bloquant |
| Arbitrage temps crédible | Un joueur ne peut PAS tout transformer (max 3 h 45/jour en transfo) | ✅ Bloquant |
| Expert ≈ Normal en revenu | Écart < 5% sur un scénario comparable | ✅ Bloquant |
| Multiplicateur 2-5× | Aucune filière ne dépasse ×5 (sauf bière = niche, volume limité) | ⚠️ Important |
| ROI investissements | 7-12 ans pour PV et métha (pas d'enrichissement flash) | ⚠️ Important |
| DLC = tension (Expert) | Le joueur doit surveiller ses stocks, invendus possibles | ⚠️ Important |
| AOP = contraignant | Les conditions AOP éliminent les joueurs non spécialisés | ℹ️ Souhaité |

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| **Charges globales** | 12% du CA | 28% du CA |
| **Fromagerie — qualité** | Fixe (70/100) | Variable (30-100), dépend des compétences |
| **Fromagerie — affinage** | Automatique (prêt = vendu) | Manuel (surveiller, fenêtre optimale) |
| **Fromagerie — DLC** | Pas de DLC (pas de perte) | DLC active (perte possible) |
| **Fromagerie — AOP** | Non disponible | Disponible (contraintes + survaleur ×1,3-3,0) |
| **Fromagerie — compétences** | Masquées | 6 axes progressifs (1-10) |
| **Fromagerie — sous-produits** | Automatiques (inclus dans le prix) | Gérés manuellement (crème → beurre) |
| **Méthanisation — gestion** | Revenu fixe mensuel | Gestion substrats + usure + pannes |
| **Méthanisation — panne** | Impossible | Possible (usure > 80% = risque) |
| **Méthanisation — CIVE** | Pas nécessaire | Optimise le rendement (+15-25%) |
| **Photovoltaïque — mode** | Revente totale fixe | Choix autoconso/revente, dégradation |
| **Photovoltaïque — entretien** | Aucun (intégré) | Onduleur à remplacer (12-15 ans) |
| **Vente directe — clients** | Vente automatique | Clientèle à constituer et fidéliser |
| **Vente directe — invendus** | Pas d'invendu | Invendus → congel (DLC 6 mois) ou perte |
| **Autres transfo — production** | 1 action = produit fini | Étapes, fermentation, temps de process |
| **Temps transformation max/jour** | 3 h 45 | 3 h 45 |
| **Multiplicateur prix** | ×2-5 | ×2-5 (identique, ADR-003) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Couvrir fromagerie, méthanisation, PV, vente directe, autres transfo |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
