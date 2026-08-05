> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Bâtiments et stockage

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `Docs_legacy/SimAgri/docs/sdd/02-batiments.md`, ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

Les bâtiments sont le **second poste d'investissement** après le foncier. Construire un bâtiment, c'est investir dans la capacité de production : plus de stockage, plus d'animaux, plus d'autonomie. Le plaisir fondamental est de **voir sa ferme grandir** — un hangar neuf, un silo supplémentaire, une stabulation qui s'agrandit.

**Ce que SimAgri fait bien** (ADR-002 — à garder) :
- La progression visible : chaque bâtiment est un jalon concret
- Le catalogue lisible : on sait ce qu'on achète, combien ça coûte
- L'accumulation : on peut toujours en construire plus
- La simplicité : construire = cliquer + payer + attendre

**Ce qu'on améliore** :
- Usure et entretien comme levier de décision (pas de punition en Normal)
- Consommation énergétique = charge récurrente réaliste
- Mode Expert : pertes au stockage, séchage, ventilation — la gestion fine
- Interface moderne avec vue d'ensemble des capacités

### 1.2 Gameplay loop

```
┌───────────────────────────────────────────────────────────┐
│  CYCLE BÂTIMENT (investissement → exploitation)           │
└───────────────────────────────────────────────────────────┘

  DÉCISION     Évaluer le besoin             [manque capacité ?]
               ↓
  INVESTIR     Construire ou agrandir        [coût unique]
               ↓
  EXPLOITER    Remplir (récolte, animaux)    [quotidien]
               ↓
  ENTRETENIR   Maintenance préventive        [mensuel/annuel]
               ↓
  OPTIMISER    Monter en niveau, ventiler    [ponctuel]
               ↓
               → Capacité libérée → nouveau cycle

BOUCLE ANNUELLE :
  Pré-moisson : vérifier capacité stockage → construire si besoin
  Moisson     : remplir silos → vendre ou stocker (spéculation)
  Hiver       : entretien annuel (usure accrue)
  Printemps   : agrandir si projet d'expansion
```

### 1.3 Les décisions du joueur

| Moment | Décision | Conséquence |
|--------|----------|-------------|
| Pré-moisson | Ai-je assez de capacité ? | Si non : construire ou vendre sur pied |
| Post-récolte | Stocker ou vendre ? | Stocker = spéculer, vendre = cash immédiat |
| Mensuel | Entretenir maintenant ? | Reporter = usure accrue, panne possible |
| Expansion | Quel niveau d'équipement ? | Niv. élevé = moins d'usure, plus de conso |
| Expert | Ventiler ou non ? | Pertes réduites mais coût énergie |

### 1.4 Différences Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Construction | Instantané (<10 bât.) ou 1-7j | Idem |
| Capacité | Suffisante, alertes claires | Gestion fine obligatoire |
| Débordement | Alerte + vente auto au prix du jour | Perte sèche de l'excédent |
| Pertes stockage | Aucune (0%) | 0,5%/mois ventilé, 1,5% non ventilé |
| Séchage | Non requis (grain sec par défaut) | Maïs récolté humide, séchage obligatoire |
| Usure | Visible mais entretien rappelé | Pannes si négligé, coûts réels |
| Énergie | Facture légère (charges 12%) | Facture réaliste (charges 28%) |
| Insectes | Inexistants | Risque si T° > seuil et durée > 3 mois |

---

## 2. Catalogue des bâtiments

### 2.1 Stockage récolte (céréales, oléagineux, ensilage)

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie (kWh/j/u) | Contenu autorisé |
|------|-----|-------|--------|-----------------|--------------|-------------------|-----------------|
| silo_plat | Silo plat | t | 120€ | 50–800 t | 40 ans | 0 | 1 type céréale/oléagineux |
| silo_ventile | Cellules ventilées | t | 180€ | 50–1000 t | 35 ans | 0.02 | 1 type céréale/oléagineux |
| silo_couloir | Silo couloir (ensilage) | t | 90€ | 100–2000 t | 30 ans | 0 | Maïs ensilé, ensilage herbe, sorgho ensilé |
| silo_taupe | Silo taupe | t | 80€ | 50–1500 t | 25 ans | 0 | Maïs ensilé, ensilage herbe, sorgho ensilé |

**Notes de design :**
- Silo plat : pas cher, pas de ventilation → pertes en Expert
- Cellules ventilées : plus cher, énergie, mais conservation optimale
- Silo couloir : en dur, plus durable que le taupe
- Silo taupe : le moins cher, le plus fragile, pertes les plus élevées

### 2.2 Stockage intrants

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie | Contenu autorisé |
|------|-----|-------|--------|-----------------|--------------|---------|-----------------|
| hangar | Hangar | m² | 100€ | 20–5000 m² | 50 ans | 0 | Matériel, paille, foin, marchandises |
| entrepot | Entrepôt | m² | 90€ | 20–5000 m² | 50 ans | 0 | Semences, engrais, paille, foin |
| local_phyto | Local phytosanitaire | m² | 120€ | 10–200 m² | 40 ans | 0 | Produits phyto (1000 L/m²) |

### 2.3 Stockage fourrage

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie | Pertes (Expert) |
|------|-----|-------|--------|-----------------|--------------|---------|----------------|
| hangar_fourrage | Hangar à foin/paille | m² | 100€ | 20–3000 m² | 50 ans | 0 | 0% |
| aire_stockage | Aire extérieure bâchée | t | 15€ | 10–500 t | ∞ (sol) | 0 | 0,5%/jour (≈8-12%/an) |

**Note :** l'aire extérieure est quasi gratuite mais les pertes en Expert sont massives. En Normal, pas de pertes — le joueur n'est pas puni pour l'option économique.

### 2.4 Élevage

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie (kWh/j/m²) |
|------|-----|-------|--------|-----------------|--------------|-------------------|
| stabulation | Stabulation | m² | 600€ | 20–2000 m² | 40 ans | 0.05 |
| porcherie | Porcherie | m² | 450€ | 20–2000 m² | 35 ans | 0.05 |
| bergerie | Bergerie | m² | 300€ | 20–2000 m² | 40 ans | 0.04 |
| chevrerie | Chèvrerie | m² | 300€ | 20–2000 m² | 40 ans | 0.04 |
| poulailler | Poulailler | m² | 200€ | 20–2000 m² | 30 ans | 0.03 |
| clapier | Clapier | m² | 150€ | 20–1000 m² | 25 ans | 0.03 |
| ecurie | Écurie | m² | 500€ | 20–1000 m² | 45 ans | 0.06 |

### 2.5 Effluents

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie |
|------|-----|-------|--------|-----------------|--------------|---------|
| fosse_lisier | Fosse à lisier | m³ | 50€ | 10–3000 m³ | 40 ans | 0 |
| fosse_fumier | Plate-forme fumier | t | 60€ | 10–3000 t | 40 ans | 0 |
| aire_compostage | Aire de compostage | t | 70€ | 10–1000 t | ∞ | 0 |

### 2.6 Bâtiments spécifiques

| Slug | Nom | Unité | Prix/u | Capacité min-max | Durée de vie | Énergie (kWh/j/u) |
|------|-----|-------|--------|-----------------|--------------|-------------------|
| salle_traite | Salle de traite | places | 3 000€ | 4–40 places | 25 ans | 0.50 |
| cuve_lait | Tank à lait | L | 25€ | 500–50 000 L | 20 ans | 0.01 |
| salle_conditionnement | Salle conditionnement œufs | œufs | 1,50€ | 500–10 000 œufs | 30 ans | 0.001 |
| sechoir | Séchoir à grain | t/j | 5 000€ | 10–100 t/j | 30 ans | 2.00 |



---

## 3. Construction

### 3.1 Coût

```
coût_construction = prix_par_unité × taille × facteur_niveau(level)

facteur_niveau :
  Niv. 1 → ×1.0   (base)
  Niv. 2 → ×1.5   (isolation + ventilation)
  Niv. 3 → ×2.2   (automatisation partielle)
  Niv. 4 → ×3.0   (automatisation complète)
  Niv. 5 → ×4.0   (haute technologie)
```

**Exemples concrets :**

| Bâtiment | Taille | Niv. | Coût | Usage typique |
|----------|--------|------|------|---------------|
| Silo plat | 200 t | 1 | 24 000€ | Stockage blé, 30 ha |
| Cellules ventilées | 500 t | 1 | 90 000€ | Stockage premium, 75 ha |
| Stabulation | 200 m² | 1 | 120 000€ | 25 vaches laitières |
| Poulailler | 200 m² | 1 | 40 000€ | 1800 poules conv. |
| Hangar | 500 m² | 1 | 50 000€ | Matériel + fourrage |
| Séchoir | 50 t/j | 1 | 250 000€ | Exploitation maïs 100+ ha |

### 3.2 Délai de construction

| Condition | Délai |
|-----------|-------|
| Joueur possède < 10 bâtiments | Instantané |
| Joueur possède ≥ 10 bâtiments | ceil(taille / 100) jours (min 1, max 7) |

**Justification :** les premiers bâtiments sont immédiats pour ne pas frustrer les débutants (ADR-002). Au-delà de 10, le délai simule le chantier et oblige à planifier.

### 3.3 Conditions

| Condition | Détail |
|-----------|--------|
| Surface disponible | La ferme doit avoir de la surface non bâtie (1 m² bâtiment = 1 m² terrain) |
| Fonds suffisants | Paiement intégral à la commande |
| Heures de travail | 2h par bâtiment construit |
| Permis | Non requis (simplification de jeu — on est en zone agricole) |
| Limite | Pas de limite de nombre, uniquement la surface |

### 3.4 Mockup — Écran de construction

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🏗️  CONSTRUIRE UN BÂTIMENT                            [Surface libre: 2.4 ha]  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Catégorie : [Stockage ▼]  [Élevage]  [Effluents]  [Spécialisé]       │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  📦 Silo plat              120€/t    Énergie: 0 kWh             │   │
│  │  📦 Cellules ventilées     180€/t    Énergie: 0.02 kWh/j/t     │   │
│  │  📦 Silo couloir            90€/t    Énergie: 0 kWh             │   │
│  │  📦 Silo taupe              80€/t    Énergie: 0 kWh             │   │
│  │  🏚️ Hangar                 100€/m²   Énergie: 0 kWh             │   │
│  │  🏚️ Entrepôt                90€/m²   Énergie: 0 kWh             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Sélection : Cellules ventilées                                        │
│  Taille :    [═══════●══════] 300 t    (min 50 / max 1000)            │
│  Niveau :    [●] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5                       │
│                                                                         │
│  ┌─────────────────────────────────────────────────────┐               │
│  │  Récapitulatif                                      │               │
│  │  Prix : 180€ × 300 t × 1.0 =         54 000€      │               │
│  │  Délai : 3 jours (≥10 bâtiments)                   │               │
│  │  Heures : 2h                                        │               │
│  │  Capacité : 300 t (1 type céréale)                  │               │
│  │  Énergie : ~6 kWh/jour à plein                      │               │
│  │  Facture estimée : ~14€/mois                        │               │
│  └─────────────────────────────────────────────────────┘               │
│                                                                         │
│           [ Annuler ]                    [ ✅ Construire ]              │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Agrandissement

### 4.1 Règles

| Paramètre | Valeur |
|-----------|--------|
| Condition | Bâtiment **vide** (aucun stock, aucun animal) |
| Coût | prix_par_unité × taille_ajoutée × facteur_niveau |
| Durée | 2h de travail |
| Limite | Pas de dépassement de la taille max du type |
| Fréquence | Illimitée tant que le bâtiment est vide |

### 4.2 Justification du "bâtiment vide"

Comme dans SimAgri, agrandir exige de vider le bâtiment. C'est un levier de gameplay :
- **Oblige à planifier** : on agrandit en morte-saison, pas en pleine moisson
- **Crée de la tension** : faut-il vendre le stock pour agrandir ?
- **Récompense l'anticipation** : le joueur qui prévoit est avantagé

### 4.3 Alternative : construire un second bâtiment

Le joueur peut toujours construire un nouveau bâtiment au lieu d'agrandir. Avantages :
- Pas besoin de vider
- Diversification (2 types de grain dans 2 silos)

Inconvénient :
- Surface terrain consommée
- Deux entretiens au lieu d'un

---

## 5. Usure et entretien

### 5.1 Dégradation quotidienne

```
usure_jour = 0.15% × facteur_niveau_usure[level] × facteur_saison

facteur_niveau_usure :
  Niv. 1 → ×1.00
  Niv. 2 → ×0.85
  Niv. 3 → ×0.70
  Niv. 4 → ×0.55
  Niv. 5 → ×0.40

facteur_saison :
  Printemps → 1.0
  Été       → 0.8
  Automne   → 1.1
  Hiver     → 1.3
```

**Exemple :** Un silo niv. 1 en hiver : 0.15% × 1.0 × 1.3 = 0.195%/jour → ~71%/an sans entretien.

### 5.2 Paliers d'usure

| Usure | État | Effet Normal | Effet Expert |
|-------|------|-------------|-------------|
| 0–30% | Bon | Aucun | Aucun |
| 30–60% | Usé | Rappel d'entretien | +20% énergie |
| 60–80% | Dégradé | Rappel insistant | +50% énergie, panne 2%/jour |
| 80–100% | Critique | Entretien forcé (auto-débit) | +100% énergie, panne 10%/jour |
| 100% | Hors service | Réparation automatique (2× coût) | Inutilisable, réparation manuelle |

**Normal (ADR-002)** : pas de perte définitive. À 80%, l'entretien se fait automatiquement (débit du compte). À 100%, réparation auto avec surcoût ×2. Le joueur est alerté mais jamais bloqué.

**Expert** : le joueur doit gérer activement. Une panne bloque le bâtiment (pas d'entrée/sortie stock) jusqu'à réparation.

### 5.3 Entretien préventif

| Type | Coût | Effet | Heures | Fréquence recommandée |
|------|------|-------|--------|----------------------|
| Mensuel | 2% valeur bâtiment | Usure −15 points | 0.5h | Tous les mois |
| Annuel | 8% valeur bâtiment | Usure reset à 5% | 2h | 1×/an (hiver) |

**Valeur bâtiment** = prix_par_unité × taille × facteur_niveau (= coût initial).

**Exemple :** Stabulation 200 m² niv. 1 (valeur 120 000€)
- Entretien mensuel : 2 400€ → usure −15 points
- Entretien annuel : 9 600€ → usure reset à 5%

### 5.4 Conséquences de la négligence

| Situation | Normal | Expert |
|-----------|--------|--------|
| Pas d'entretien 6 mois | Usure ~35%, rappels | Usure ~35%, +20% énergie |
| Pas d'entretien 1 an | Auto-entretien déclenché | Usure ~70%, pannes fréquentes |
| Panne (Expert) | N/A | Bâtiment bloqué 24h, coût réparation = entretien mensuel ×2 |



---

## 6. Consommation énergétique

### 6.1 Formule

```
kwh_jour = base_kwh × taille × f_remplissage × f_usure × f_saison × f_niveau

f_remplissage = 0.2 + (taux_remplissage × 0.8)   -- vide=0.2, plein=1.0
f_usure       = voir paliers (1.0 / 1.2 / 1.5 / 2.0)
f_saison      = printemps 1.0 / été 1.1 / automne 1.0 / hiver 1.3
f_niveau      = Niv.1: 1.0 / Niv.2: 0.9 / Niv.3: 0.8 / Niv.4: 0.7 / Niv.5: 0.6
```

### 6.2 Exemples de factures mensuelles

| Bâtiment | Taille | Niv. | Remplissage | kWh/jour | Facture/mois (0.08€/kWh) |
|----------|--------|------|-------------|----------|--------------------------|
| Cellules ventilées | 300 t | 1 | 80% | 4.4 | 10,6€ |
| Stabulation | 200 m² | 1 | 100% | 10.0 | 24,0€ |
| Porcherie | 100 m² | 2 | 75% | 3.4 | 8,2€ |
| Poulailler | 200 m² | 1 | 100% | 6.0 | 14,4€ |
| Séchoir | 50 t/j | 1 | En service | 100.0 | 240,0€ |
| Salle de traite | 20 pl. | 1 | Active | 10.0 | 24,0€ |

### 6.3 Impact du niveau d'équipement sur l'énergie

| Niveau | Facteur énergie | Économie vs Niv.1 | Justification RP |
|--------|----------------|-------------------|------------------|
| 1 | ×1.0 | — | Équipement de base |
| 2 | ×0.9 | −10% | Isolation renforcée |
| 3 | ×0.8 | −20% | Régulation automatique |
| 4 | ×0.7 | −30% | Pompes à chaleur |
| 5 | ×0.6 | −40% | Haute efficacité énergétique |

### 6.4 Facturation

- Tarif : **0.08 €/kWh** (prix France, simplifié)
- Débit : quotidien (chaque tick)
- Si solde insuffisant : le bâtiment continue mais usure ×1.5 (impayé = dégradation)
- En Normal : alerte « Énergie impayée » + suggestion de vendre du stock
- En Expert : coupure après 7 jours d'impayé → ventilation arrêtée → pertes accrues

---

## 7. Capacité et débordement

### 7.1 Calcul de capacité

```
capacité_effective = taille × facteur_niveau_capacité[level]

facteur_niveau_capacité :
  Niv. 1 → ×1.00
  Niv. 2 → ×1.00
  Niv. 3 → ×1.05
  Niv. 4 → ×1.10
  Niv. 5 → ×1.15
```

### 7.2 Que se passe-t-il quand un silo est plein à la récolte ?

**Mode Normal (ADR-002 : pas de perte définitive) :**

1. **Alerte pré-moisson** (7 jours avant) : « Attention, votre capacité de stockage pour le blé est insuffisante. Il manque ~45 t de capacité. »
2. **Alerte jour J** : « Silo plein ! L'excédent (45 t) sera vendu automatiquement au prix du jour. »
3. **Vente automatique** : l'excédent est vendu au prix marché du jour. Le joueur reçoit l'argent. Pas de perte.
4. **Notification post-vente** : « 45 t de blé vendues automatiquement à 210€/t = 9 450€ crédités. »

**Mode Expert (gestion fine, conséquences réelles) :**

1. **Alerte pré-moisson** (7 jours avant) : même alerte
2. **Pas de vente automatique** : le joueur doit agir (vendre, déplacer, louer du stockage)
3. **Si inaction** : l'excédent est **perdu** (laissé au champ, dégradé)
4. **Notification** : « 45 t de blé perdues — capacité de stockage insuffisante. »

### 7.3 Indicateurs visuels

| Remplissage | Couleur | Icône |
|-------------|---------|-------|
| 0–60% | 🟢 Vert | Normal |
| 60–85% | 🟡 Orange | Attention |
| 85–100% | 🔴 Rouge | Presque plein |
| 100% | ⚫ Noir + clignotant | PLEIN — action requise |



---

## 8. Pertes au stockage (Expert uniquement)

### 8.1 Taux de pertes par type de stockage

| Type de stockage | Perte/mois | Perte/an | Condition |
|-----------------|-----------|---------|-----------|
| Cellules ventilées | 0,5% | ~6% | Ventilation active (énergie payée) |
| Silo plat (non ventilé) | 1,5% | ~17% | Pas de ventilation |
| Silo couloir (ensilage) | 0,3% | ~3,5% | Ensilage bien tassé |
| Silo taupe | 0,5% | ~6% | Perte au front d'attaque |
| Aire extérieure bâchée | 1,0% | ~12% | Paille/foin, intempéries |
| Aire extérieure non bâchée | 2,0% | ~22% | Conditions dégradées |

### 8.2 Facteurs modulant les pertes

```
perte_effective = perte_base × f_temperature × f_humidite × f_duree × f_niveau

f_temperature :
  < 15°C  → 0.8 (froid = conservation)
  15-25°C → 1.0 (normal)
  > 25°C  → 1.5 (risque insectes)

f_humidite_grain :
  < 14%   → 0.8 (grain sec)
  14-15%  → 1.0 (normal)
  > 15%   → 2.0 (risque moisissure → séchage requis)

f_duree :
  < 3 mois → 0.8
  3-6 mois → 1.0
  > 6 mois → 1.3 (dégradation progressive)

f_niveau :
  Niv.1 → 1.0 / Niv.2 → 0.9 / Niv.3 → 0.8 / Niv.4 → 0.7 / Niv.5 → 0.6
```

### 8.3 Insectes de stockage (Expert)

| Condition | Risque/mois | Effet |
|-----------|------------|-------|
| T° > 25°C + durée > 3 mois + non ventilé | 15% | Perte ×3 ce mois |
| T° > 25°C + durée > 3 mois + ventilé | 3% | Perte ×1.5 ce mois |
| Traitement insecticide appliqué | 0% pendant 6 mois | Coût : 2€/t |

### 8.4 Récapitulatif Normal vs Expert (pertes)

| | Normal | Expert |
|-|--------|--------|
| Pertes céréales | 0% | 0,5% à 1,5%/mois selon infrastructure |
| Pertes fourrage extérieur | 0% | 8-12%/an |
| Insectes | Inexistants | Risque si conditions réunies |
| Ventilation | Cosmétique | Réduit pertes de 66% |
| Traitement insecticide | Non requis | 2€/t, protège 6 mois |

---

## 9. Séchage (Expert uniquement)

### 9.1 Principe

En mode Expert, le maïs grain est récolté **humide** (25 à 32% d'humidité selon la date de récolte et la météo). Il doit être séché à 14-15% pour être stocké sans risque de moisissure.

En mode Normal : le grain est considéré sec à la récolte (simplification ADR-002).

### 9.2 Humidité à la récolte (Expert)

| Culture | Humidité récolte | Humidité cible | Points à sécher |
|---------|-----------------|---------------|-----------------|
| Maïs grain | 25–32% | 15% | 10–17 points |
| Tournesol | 9–12% | 9% | 0–3 points |
| Colza | 9–11% | 9% | 0–2 points |
| Blé, orge, triticale | 14–16% | 14% | 0–2 points |

**Le maïs est la seule culture qui nécessite systématiquement un séchage significatif.**

### 9.3 Coût du séchage

```
coût_séchage = tonnage × points_à_sécher × 0.80€

Exemple : 500 t de maïs à 28% → cible 15% = 13 points
  500 × 13 × 0.80 = 5 200€ de séchage
```

### 9.4 Options de séchage

| Option | Investissement | Coût/t/point | Capacité | Avantage |
|--------|---------------|-------------|----------|----------|
| Séchoir propre | 80 000–250 000€ | 0.50€ | 10–100 t/j | Autonomie, coût réduit |
| Coopérative (service) | 0€ | 0.80€ | Illimité | Pas d'investissement |
| Séchage au champ (attendre) | 0€ | 0€ | — | Gratuit mais risque météo + pertes |

**Séchoir propre :**
- Investissement : 5 000€/t de capacité journalière
- Rentable à partir de ~300 t de maïs/an (≈40 ha de maïs grain)
- Consommation : 2 kWh/j par t de capacité (pendant le fonctionnement)

### 9.5 Gameplay du séchage (Expert)

```
┌─────────────────────────────────────────────────────────┐
│  DÉCISION À LA RÉCOLTE DU MAÏS (Expert)                 │
└─────────────────────────────────────────────────────────┘

  Maïs récolté à 28% d'humidité (500 t)
              ↓
  ┌─────────────┬──────────────────┬────────────────────┐
  │ Séchoir     │ Coopérative      │ Attendre au champ  │
  │ propre      │                  │                    │
  │ 0.50€/t/pt │ 0.80€/t/pt      │ 0€ mais -1%/jour  │
  │ 3 250€     │ 5 200€           │ risque verse/perte │
  │ 5 jours    │ Instantané       │ ?                  │
  └─────────────┴──────────────────┴────────────────────┘
```

### 9.6 Conséquence du non-séchage (Expert)

| Humidité stockage | Effet |
|-------------------|-------|
| ≤ 15% | Conservation normale (pertes de base) |
| 15–18% | Pertes ×2, risque moisissure 5%/mois |
| > 18% | Pertes ×4, moisissure 20%/mois → lot détruit si non traité |



---

### 9.7 Accessoires de bâtiments — Catalogue complet

Les accessoires sont des **équipements optionnels** installés dans ou autour d'un bâtiment. Ils améliorent la productivité, le confort animal, ou permettent de nouvelles opérations.

#### Accessoires d'élevage

| Accessoire | Bâtiment compatible | Prix | Installation | Effet | Entretien/an |
|-----------|:-------------------:|:----:|:------------:|-------|:------------:|
| Cornadis autobloquant | Stabulation, bergerie | 85 €/place | 0,5 h/place | Contention pour soins, tri | 50 €/20 places |
| Parc de contention | Tout élevage | 4 500 € | 4 h | Pesée, soins, tri — réduit temps soins ×0,6 | 120 €/an |
| Pédiluve | Stabulation | 2 800 € | 3 h | -40% boiteries, passage obligatoire traite | 180 €/an (produit) |
| DAC (Distributeur Automatique Concentré) | Stabulation | 8 500 € | 6 h | Distribution individuelle, -30 min/jour | 350 €/an |
| Ventilateurs brasseurs | Stabulation, poulailler | 1 200 €/unité (4 min.) | 2 h | Confort thermique été, -5% mortalité chaleur | 80 €/an/unité |
| Logettes caoutchouc | Stabulation | 120 €/place | 0,3 h/place | Confort couchage +8%, -15% boiteries | 0 € (durée 10 ans) |
| Racleur automatique | Stabulation (lisier) | 12 000 € | 1 jour | Propreté automatique, -45 min/jour nettoyage | 450 €/an |
| Abreuvoir antigel | Pâture, stabulation | 650 €/unité | 1 h | Eau disponible toute l'année, pas de gel | 35 €/an (énergie) |
| Caméra de surveillance | Tout bâtiment | 1 800 € (lot 4) | 2 h | Détection vêlage, alerte intrusion (Expert) | 60 €/an |

#### Accessoires de stockage

| Accessoire | Bâtiment compatible | Prix | Installation | Effet | Entretien/an |
|-----------|:-------------------:|:----:|:------------:|-------|:------------:|
| Ventilation (cellules) | Silo plat, cellules | 8 000 €/100 t | 1 jour | Pertes stockage ÷2 (Expert), séchage partiel | 280 €/an |
| Sonde température | Silo plat, cellules | 1 500 €/cellule | 2 h | Alerte si T° > 25°C (risque insectes, Expert) | 0 € |
| Nettoyeur à grain | Cellules | 6 500 € | 4 h | Élimine impuretés, +2% qualité à la vente | 200 €/an |
| Vis à grain supplémentaire | Silo plat | 3 200 € | 3 h | Débit chargement ×2 (gain temps manutention) | 80 €/an |
| Pont-bascule | Cour de ferme | 18 000 € | 2 jours | Pesée précise, requis pour vente grossiste > 50 t | 350 €/an |
| Station de conditionnement | Hangar, local dédié | 25 000 € | 3 jours | Mise en caisse/palette fruits et légumes — requis vente directe | 600 €/an |
| Chambre froide (50 t) | Local dédié | 35 000 € | 2 jours | Conservation fruits 6 mois, requis petits fruits | 1 200 €/an (énergie) |
| Tank à lait supplémentaire | Salle de traite | 12 000 € (+2 000 L) | 4 h | Capacité tampon si collecte retardée | 180 €/an |

#### Accessoires de travail

| Accessoire | Bâtiment compatible | Prix | Installation | Effet | Entretien/an |
|-----------|:-------------------:|:----:|:------------:|-------|:------------:|
| Atelier mécanique (établi) | Hangar | 5 500 € | 1 jour | Réparations mineures soi-même (-50% coût pièces mineures) | 150 €/an |
| Cuve carburant (5 000 L) | Cour de ferme | 4 200 € | 4 h | Achat carburant en gros (-8% sur le HVC) | 100 €/an (contrôle) |
| Station de lavage | Cour de ferme | 8 500 € | 1 jour | Nettoyage matériel, +5% valeur revente occasion | 220 €/an |
| Aire de stockage effluents | Extérieur | 15 000 € (200 m³) | 5 jours | Obligatoire en zone vulnérable (Expert), stockage 6 mois | 300 €/an |

#### Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Accessoires visibles | Tous | Tous |
| Effet gameplay | Bonus affiché, choix binaire (installer/non) | Maintenance, pannes d'accessoire, optimisation fine |
| Accessoires obligatoires | Aucun | Aire stockage en zone vulnérable, chambre froide pour petits fruits |
| Panne d'accessoire | Non | Oui (2%/an, réparation 200-2 000 €) |


---

## 10. Équilibrage et scénarios

### 10.1 Dimensionnement recommandé

| Surface cultures | Stockage céréales recommandé | Justification |
|-----------------|------------------------------|---------------|
| 50 ha | 300–400 t | Rendement moyen 7t/ha, 1 culture principale |
| 100 ha | 600–800 t | 2 cultures, stockage partiel |
| 150 ha | 900–1200 t | Diversification, spéculation possible |
| 300 ha | 1500–2500 t | Grosse structure, stockage long |

| Cheptel | Bâtiment élevage | Stockage fourrage | Effluents |
|---------|-----------------|-------------------|-----------|
| 30 vaches laitières | 240 m² stab. | 200 t foin + 500 t ensilage | 300 m³ lisier |
| 60 vaches laitières | 480 m² stab. | 400 t foin + 1000 t ensilage | 600 m³ lisier |
| 200 brebis | 300 m² berg. | 150 t foin | 200 t fumier |
| 3000 poules | 340 m² poul. | — | 100 t fumier |

### 10.2 Scénario chiffré : dimensionner le stockage pour 150 ha

**Profil :** Exploitation céréalière 150 ha, assolement : 60 ha blé, 40 ha maïs grain, 30 ha colza, 20 ha orge.

**Rendements moyens :**
- Blé : 7,5 t/ha → 450 t
- Maïs grain : 10 t/ha → 400 t
- Colza : 3,5 t/ha → 105 t
- Orge : 7 t/ha → 140 t

**Total à stocker : 1 095 t** (si tout est stocké — stratégie spéculative).

**Option A — Stockage minimal (vente rapide) :**

| Bâtiment | Taille | Coût | Usage |
|----------|--------|------|-------|
| Silo plat blé | 250 t | 30 000€ | Stock tampon blé |
| Silo plat orge | 100 t | 12 000€ | Stock tampon orge |
| Silo couloir maïs (ensilage voisin) | — | — | Pas de maïs ensilé ici |
| **Total** | 350 t | **42 000€** | Vente en moisson |

Stratégie : vendre 70% à la moisson, stocker 30% pour spéculer 2-3 mois.

**Option B — Stockage complet (spéculation maximale) :**

| Bâtiment | Taille | Coût | Usage |
|----------|--------|------|-------|
| Cellules ventilées blé | 500 t | 90 000€ | Blé + orge (2 cellules) |
| Cellules ventilées colza | 120 t | 21 600€ | Colza |
| Silo plat maïs | 450 t | 54 000€ | Maïs grain |
| Séchoir (Expert) | 50 t/j | 250 000€ | Séchage maïs |
| Hangar matériel | 300 m² | 30 000€ | Stockage matériel |
| **Total** | 1 070 t + hangar | **445 600€** | Stockage intégral |

**Coûts récurrents annuels (Option B) :**

| Poste | Calcul | Coût/an |
|-------|--------|---------|
| Énergie cellules ventilées (620 t) | 620 × 0.02 × 0.6 × 365 × 0.08€ | ~217€ |
| Énergie séchoir (30 jours actifs) | 50 × 2 × 30 × 0.08€ | 240€ |
| Entretien annuel silos | 8% × 165 600€ | 13 248€ |
| Entretien annuel séchoir | 8% × 250 000€ | 20 000€ |
| Entretien annuel hangar | 8% × 30 000€ | 2 400€ |
| Séchage maïs (Expert, coopé) | 400 t × 13 pts × 0.80€ | 4 160€ |
| **Total charges annuelles** | | **~40 265€** |

**Revenus spéculation (stocker 6 mois vs vendre moisson) :**
- Blé : +15€/t sur 450 t = +6 750€
- Colza : +30€/t sur 105 t = +3 150€
- Maïs : +10€/t sur 400 t = +4 000€
- **Gain spéculation : ~13 900€/an**

**Verdict :** Le stockage complet se rentabilise en ~32 ans au pur gain spéculation. L'intérêt réel est la **flexibilité** (vendre quand on veut) et la **sécurité** (pas de vente forcée). Le joueur choisit entre investir lourd (long terme) ou rester léger (cash rapide).

### 10.3 Objectifs d'équilibrage

| Cible | Valeur | Justification |
|-------|--------|---------------|
| Charges bâtiments / CA total | 8-15% | Second poste après foncier |
| Temps rentabilisation silo | 5-8 ans de jeu | Investissement significatif mais pas décourageant |
| Temps rentabilisation stabulation | 3-5 ans | L'élevage doit rester attractif |
| Perte max Expert (négligence totale) | 20%/an | Punition sans être rédhibitoire |
| Énergie max / CA | 3-5% (Normal), 6-10% (Expert) | Charge réaliste |

### 10.4 Mockup — Vue d'ensemble des bâtiments

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🏠 MES BÂTIMENTS                    Ferme de la Plaine — 14 bâtiments     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  📊 Résumé capacités                                                       │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ Céréales  : ████████████████░░░░ 780/1070 t (73%)                   │  │
│  │ Ensilage  : ████████░░░░░░░░░░░░ 400/1000 t (40%)                  │  │
│  │ Fourrage  : ██████████████░░░░░░ 140/200 t  (70%)                   │  │
│  │ Élevage   : ████████████████████ 48/50 VL   (96%) ⚠️               │  │
│  │ Lisier    : ██████████░░░░░░░░░░ 150/300 m³ (50%)                   │  │
│  │ Matériel  : ████░░░░░░░░░░░░░░░░  60/300 m² (20%)                  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ID       │ Nom              │ Type      │ Rempli.      │ Niv │ Usure      │
│  ─────────┼──────────────────┼───────────┼──────────────┼─────┼──────────  │
│  CEL-2041 │ Silo blé nord    │ Cell.vent │ 450/500 t 🟡 │  1  │ 22% 🟢    │
│  CEL-2042 │ Silo colza       │ Cell.vent │ 80/120 t  🟢 │  1  │ 18% 🟢    │
│  SIL-2050 │ Silo maïs        │ Silo plat │ 250/450 t 🟢 │  1  │ 45% 🟡    │
│  STA-1012 │ Stabulation      │ Stab.     │ 48/50 VL  🔴 │  2  │ 12% 🟢    │
│  HAN-1099 │ Hangar principal │ Hangar    │ 60/300 m² 🟢 │  1  │ 55% 🟡    │
│  SEC-3001 │ Séchoir          │ Séchoir   │ Inactif      │  1  │  8% 🟢    │
│  FOS-1500 │ Fosse lisier     │ Lisier    │ 150/300 m³🟢 │  1  │ 30% 🟢    │
│  ...      │                  │           │              │     │            │
│                                                                             │
│  ⚠️ Alerte : Stabulation presque pleine (96%) — Agrandir ou vendre ?      │
│  🔧 Rappel : Hangar principal — usure 55%, entretien recommandé            │
│                                                                             │
│  [ + Construire ]  [ 📋 Filtrer ]  [ 📊 Statistiques ]                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 10.5 Checklist playtest

| Test | Critère | Bloquant ? |
|------|---------|-----------|
| Test recette SimAgri | Un joueur SimAgri dit « c'est SimAgri en mieux » | ✅ OUI |
| Normal sans perte | Aucune récolte perdue en Normal même sans anticipation | ✅ OUI |
| Construction fluide | < 3 clics pour construire un bâtiment | ✅ OUI |
| Alerte pré-moisson | L'alerte arrive 7j avant et est actionnable | ✅ OUI |
| Expert punitif mais juste | Pertes Expert restent < 20%/an même sans entretien parfait | ✅ OUI |
| Spéculation rentable | Stocker 6 mois rapporte 5-15% de plus que vente moisson | ⬜ Non bloquant |
| Énergie pas écrasante | Facture énergie < 5% du CA en Normal | ✅ OUI |
| Séchoir rentable (Expert) | Séchoir propre rentabilisé en 4-6 ans si > 40 ha maïs | ⬜ Non bloquant |

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Pertes stockage céréales | 0% | 0,5–1,5%/mois |
| Pertes fourrage extérieur | 0% | 8–12%/an |
| Séchage requis | Non | Oui (maïs, tournesol) |
| Coût séchage/t/point | N/A | 0,80€ (coopé) / 0,50€ (propre) |
| Débordement silo | Vente auto prix du jour | Perte sèche |
| Usure visible | Oui (rappels) | Oui (pannes réelles) |
| Entretien auto | Oui (à 80% d'usure) | Non (gestion manuelle) |
| Insectes de stockage | Non | Oui (T° > 25°C, > 3 mois) |
| Facture énergie cible/CA | ~2-3% | ~6-10% |
| Charges globales bâtiments/CA | ~12% | ~28% |
| Panne si usure > 80% | Non (auto-réparé) | Oui (bloquant 24h) |
| Alerte pré-moisson | Oui (7j avant) | Oui (7j avant) |
| Vente auto si plein | Oui (prix marché) | Non |
| Traitement insecticide | Non requis | 2€/t, protège 6 mois |
| Ventilation arrêtée si impayé | Non | Oui (après 7j) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Premier draft GDD bâtiments-stockage |
| 2026-08-04 | Ajout §9.7 Accessoires de bâtiments — Catalogue complet | Audit couverture fonctionnelle — système 3.7 partiel |

