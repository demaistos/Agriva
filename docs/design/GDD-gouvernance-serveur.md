> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.

# GDD — Gouvernance et régulation du serveur

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `Docs_legacy/SimAgri/INVENTAIRE_SYSTEMES.md` (10.7 CESA, 1.8 CFSA), `docs/decisions/ADR-002-recette-simagri-en-normal.md`

---

## 1. Vision

### 1.1 Pourquoi ce document existe

Un serveur multijoueur économique **dérive** si personne ne le régule :
- **Inflation** : les joueurs créent de la valeur, la masse monétaire enfle, les prix explosent
- **Monopoles** : les anciens verrouillent les marchés, les nouveaux ne peuvent plus s'installer
- **Écart insurmontable** : un joueur de 5 ans possède 50× le capital d'un nouveau → frustration → départ

SimAgri tourne depuis 2005 sans wipe. Ses mécanismes (CESA, CFSA, prix régulés) sont rudimentaires mais suffisants. Agriva doit faire mieux : **des régulateurs automatiques, transparents, et ajustables**.

### 1.2 Principes directeurs

| Principe | Application |
|----------|-------------|
| Invisible au quotidien | Le joueur ne voit pas la régulation, il voit un jeu équilibré |
| Pas de punition | Les puits monétaires sont des coûts réalistes, pas des taxes arbitraires |
| Prévisible | Pas de nerfs surprises — les règles sont connues à l'avance |
| Progressif | Plus tu es riche, plus tu contribues (charges proportionnelles) |
| Mesurable | Chaque levier a un indicateur associé et un seuil d'alerte |

### 1.3 Différences entre serveur Normal et serveur Expert (gouvernance)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Charges sociales | 12% du bénéfice | 28% du bénéfice |
| Taxe foncière | Forfaitaire légère | Proportionnelle à la surface |
| Faillite possible | Non (plancher à 0€) | Oui (redressement judiciaire) |
| Rendements décroissants | Légers (−5%/tranche) | Marqués (−12%/tranche) |
| Plafond surface | 800 ha | 500 ha (+ contrainte main-d'œuvre) |

---

## 2. Régulation économique (repensée du CESA)

> **Principe fondamental (ADR-005)** : le stabilisateur économique s'applique à **CHAQUE SERVEUR INDÉPENDAMMENT**. Chaque serveur possède sa propre masse monétaire, ses propres indicateurs économiques (inflation, ratio P90/P10, coefficient puits), et son propre stabilisateur. Il n'y a aucune interaction économique entre les serveurs Normal et Expert.
>
> C'est une **simplification** par rapport à l'ancienne architecture (un mode hybride dans un même serveur) : deux économies fermées simples sont plus faciles à réguler qu'une économie mixte où deux populations aux charges différentes interagissent sur le même marché.

### 2.1 Le problème fondamental

Dans une économie fermée :
```
Joueurs produisent → vendent aux PNJ → argent APPARAÎT
Joueurs achètent intrants → argent DISPARAÎT
```

Si les sources > puits → **inflation**. Les prix joueurs montent, les nouveaux ne peuvent plus acheter.

SimAgri gère ça de façon rudimentaire : le CESA fixe quelques prix (miscanthus, luzerne) et verse 25 000€ aux nouveaux. Pas de mécanisme anti-inflation automatique.

### 2.2 Sources monétaires (argent qui APPARAÎT dans le jeu)

| Source | Déclencheur | Estimation/joueur/mois | Poids relatif |
|--------|-------------|------------------------|---------------|
| Ventes coopérative PNJ | Vente de récolte/lait/viande | 15 000–40 000€ | 55% |
| Aides PAC | Versement annuel (divisé/12) | 3 000–8 000€ | 20% |
| Dotation initiale | Inscription | 150 000€ (one-shot) | 5% |
| Aide CESA installation | Post-formation | 50 000€ (one-shot) | 3% |
| Primes concours | Événements | 500–2 000€ | 2% |
| Intérêts épargne | Livret (si implémenté) | 200–500€ | 1% |
| Contrats PNJ saisonniers | Missions optionnelles | 2 000–5 000€ | 14% |

**Total sources estimées** : ~25 000€/joueur/mois en régime de croisière.

### 2.3 Puits monétaires (argent qui DISPARAÎT du jeu)

| Puits | Déclencheur | Estimation/joueur/mois | Poids relatif |
|-------|-------------|------------------------|---------------|
| Charges sociales (MSA) | Trimestriel (12% bénéfice Normal) | 3 000–5 000€ | 20% |
| Achats intrants PNJ | Semences, engrais, phyto | 5 000–10 000€ | 30% |
| Carburant | Chaque opération mécanisée | 1 500–3 000€ | 10% |
| Entretien matériel | Usure → réparations | 1 000–2 500€ | 8% |
| Annuités emprunt (intérêts) | Mensuel | 1 500–3 000€ | 10% |
| Taxe foncière | Annuel (divisé/12) | 500–1 500€ | 5% |
| Frais vétérinaires | Par animal/mois | 500–2 000€ | 7% |
| Salaires employés PNJ | Par employé/mois | 2 000–4 000€ | 10% |

**Total puits estimés** : ~20 000€/joueur/mois.

### 2.4 L'équilibre cible

```
OBJECTIF : Sources − Puits = croissance masse monétaire ≤ 5%/an

Avec 200 joueurs actifs :
- Sources totales serveur : 200 × 25 000 = 5 000 000€/mois
- Puits totaux serveur   : 200 × 20 000 = 4 000 000€/mois
- Création nette          : 1 000 000€/mois = 12 000 000€/an

Masse monétaire initiale estimée (200 joueurs, solde moyen 300 000€) :
  200 × 300 000 = 60 000 000€

Croissance annuelle : 12M / 60M = 20% → TROP ÉLEVÉ

Cible : 5% max → création nette max = 3 000 000€/an = 250 000€/mois
Il faut absorber 750 000€/mois de plus → +3 750€/joueur/mois
```

### 2.5 Le mécanisme de régulation automatique : le Stabilisateur Économique

**Concept** : un coefficient multiplicateur appliqué à TOUS les puits PNJ, ajusté automatiquement chaque semaine.

```
coefficient_puits = 1.0 + (inflation_constatee - inflation_cible) × sensibilite

Où :
- inflation_constatee = (masse_mois_N − masse_mois_N-1) / masse_mois_N-1 × 12
- inflation_cible = 0.05 (5%/an)
- sensibilite = 2.0

Exemple : inflation constatée = 15%/an
  coefficient = 1.0 + (0.15 − 0.05) × 2.0 = 1.20
  → Tous les coûts PNJ augmentent de 20%
```

**Bornes de sécurité** :
- coefficient_puits MIN = 0.85 (jamais plus de 15% de réduction)
- coefficient_puits MAX = 1.40 (jamais plus de 40% d'augmentation)
- Variation max par semaine = ±0.03

**Ce qui est affecté** (puits PNJ uniquement) :
- Prix d'achat intrants en coopérative
- Coût carburant
- Coût entretien/réparations
- Frais vétérinaires

**Ce qui N'EST PAS affecté** :
- Prix de vente joueur↔joueur (marché libre)
- Charges sociales (taux fixe)
- Prix de vente à la coopérative PNJ (pour ne pas pénaliser les revenus)

### 2.6 Levier secondaire : ajustement des prix de vente PNJ

Si le coefficient_puits atteint 1.30 pendant 4 semaines consécutives, un second levier s'active :

```
coefficient_vente_PNJ = 1.0 − (coefficient_puits − 1.30) × 1.5

Exemple : coefficient_puits = 1.35
  coefficient_vente = 1.0 − (1.35 − 1.30) × 1.5 = 0.925
  → Les prix de vente à la coop baissent de 7.5%
```

Borne : coefficient_vente_PNJ MIN = 0.80 (jamais plus de 20% de baisse).

### 2.7 Indicateurs de surveillance

| Indicateur | Calcul | Seuil vert | Seuil orange | Seuil rouge |
|-----------|--------|------------|--------------|-------------|
| Inflation annualisée | Δ masse / masse × 12 | < 5% | 5–10% | > 10% |
| Solde médian | Médiane des soldes joueurs | 200k–500k€ | > 800k€ | > 1.5M€ |
| Ratio P90/P10 | Solde du 90e centile / 10e centile | < 20× | 20–50× | > 50× |
| Prix moyen blé marché | Moyenne pondérée 30 jours | ±15% du PNJ | ±30% | > ±50% |
| Coefficient puits actif | Valeur courante | 0.95–1.10 | 1.10–1.25 | > 1.25 |



---

## 3. Équité entre anciens et nouveaux

### 3.1 Le problème

Un joueur inscrit depuis 5 ans (ancienneté 1 800 jours) a typiquement :
- 400–600 ha, 200+ bovins, 15+ bâtiments
- Capital total : 5 000 000–15 000 000€
- Revenu mensuel net : 80 000–200 000€

Un nouveau joueur a :
- 0 ha (à acheter), 0 animal
- Capital : 150 000€ (dotation) + 150 000€ (prêt JA) = 300 000€
- Revenu mensuel net : 5 000–10 000€ (les premiers mois)

**Ratio capital : 40× à 60×.** Sans mécanisme, le nouveau ne rattrape JAMAIS.

### 3.2 Rendements décroissants

Doubler sa surface ne double PAS le revenu. Pourquoi :

```
revenu_net_par_ha = revenu_brut × (1 − taux_charges) − couts_fixes_par_ha

Mais au-delà d'un seuil, les coûts augmentent :
- Main d'œuvre supplémentaire nécessaire (1 employé / 80 ha en Normal)
- Matériel plus gros = plus cher à l'hectare (rendements d'échelle limités)
- Distance parcelles → plus de carburant
- Complexité de gestion → risque d'erreur

FORMULE RENDEMENT DÉCROISSANT (Normal) :
efficacite = 1.0 − 0.05 × max(0, tranche_surface − 1)

Tranches : 0-100ha = tranche 1, 100-200 = tranche 2, etc.

Exemple joueur 400 ha :
  Tranche 1 (0-100)   : efficacité 1.00 → revenu plein
  Tranche 2 (100-200) : efficacité 0.95 → −5%
  Tranche 3 (200-300) : efficacité 0.90 → −10%
  Tranche 4 (300-400) : efficacité 0.85 → −15%
  
  Revenu effectif = 100×1.0 + 100×0.95 + 100×0.90 + 100×0.85
                  = 370 ha-équivalent au lieu de 400 → rendement global −7.5%
```

En Expert, le coefficient est −12%/tranche → beaucoup plus marqué.

### 3.3 Plafonds

| Ressource | Normal | Expert | Justification |
|-----------|--------|--------|---------------|
| Surface totale | 800 ha | 500 ha | Empêche monopole foncier. 800 ha = très grosse ferme FR |
| Cheptel bovin | 500 têtes | 300 têtes | Au-delà = industriel, pas le gameplay visé |
| Cheptel ovin | 1 500 têtes | 1 000 têtes | Proportionnel au réel FR |
| Bâtiments | 30 | 20 | Limite l'accumulation passive |
| Employés | 10 | 8 | Main d'œuvre = coût fixe, limite naturelle |
| Parcelles marché simultanées | 20 annonces | 15 annonces | Anti-accaparement |

**Les plafonds sont FERMES** — pas de contournement possible. Un joueur au plafond doit vendre pour acheter.

### 3.4 Aides à l'installation pour les nouveaux (conformes SdV §19)

> **Règle absolue (SdV §19)** : Pas de rattrapage artificiel. Pas de bonus, pas de protection, pas de catch-up mécanique. Un joueur tard venu rattrape s'il joue bien, naturellement, avec le temps.

Les seuls mécanismes d'aide à l'installation sont les dotations financières initiales :

| Mécanisme | Valeur | Condition |
|-----------|--------|-----------|
| Dotation initiale | 150 000€ | Inscription |
| Kit de départ (matériel + bâtiment) | Selon kit choisi (SdV §5) | Inscription |
| Prêt JA bonifié | 150 000€ à 1.5%/an (Normal) / 120 000€ à 3% (Expert) | < 30 jours ancienneté |
| Aide CESA post-formation | 50 000€ (Normal) / 40 000€ (Expert) | Avoir terminé la formation CFSA |
| Parcelles réservées (5j exclusivité) | 10/mois IG par joueur | Mécanisme universel (SdV §6) |

**Ce qui est INTERDIT** (SdV §19) :
- ❌ Capacité de travail majorée pour les nouveaux
- ❌ Réduction intrants pour les nouveaux
- ❌ Accès exclusif à des terres réservées « zone JA »
- ❌ Tout bonus temporel, productif ou économique lié à l'ancienneté

**Pourquoi le nouveau rattrape quand même** :
- Les parcelles réservées (10/mois, 5j exclusivité) garantissent l'accès au foncier
- Le terrain est infini : le jeu génère toujours de nouvelles parcelles
- Le marché joueurs offre des opportunités (matériel d'occasion, etc.)
- La CFSA (formation, §4) aide à bien débuter sans donner d'avantage mécanique

### 3.5 Marché unique — carnet d'ordres (conforme SdV §3)

> **Règle (SdV §3)** : Le marché joueurs est un **carnet d'ordres unique** (order book) avec matching automatique. Pas de segmentation par ancienneté, pas de prix plafonnés par ligue.

Tous les joueurs, quelle que soit leur ancienneté, accèdent au même marché avec les mêmes règles :
- Offre et demande libres
- Matching automatique (meilleur prix)
- Historique de prix visible par tous
- Prix minimum anti-abus (~70-80% du prix coop, SdV §15)

La coopérative PNJ (prix fixe) sert de filet de sécurité pour tous les joueurs — anciens comme nouveaux.



---

## 4. Formation des nouveaux (CFSA → Centre de Formation Agriva)

### 4.1 Concept

Un nouveau joueur (< 14 jours) peut demander à être formé par un exploitant expérimenté (168+ jours). Pendant 42 jours, l'apprenti « travaille » sur l'exploitation du maître et apprend le jeu.

**Pourquoi ça marche** : le mentorat humain est le meilleur onboarding. Le maître a intérêt à former (main d'œuvre + récompenses), l'apprenti progresse vite et reste dans le jeu.

### 4.2 Conditions d'entrée

| Rôle | Condition | Limite |
|------|-----------|--------|
| Apprenti (stagiaire) | < 14 jours ancienneté | 1 formation max dans sa vie |
| Maître-exploitant | ≥ 168 jours ancienneté | Max stagiaires simultanés selon ancienneté |
| | Capital > 500 000€ | (preuve de compétence) |
| | Pas de sanction active | (pas de tricheur) |

**Slots maître selon ancienneté** :
| Ancienneté maître | Slots simultanés |
|-------------------|------------------|
| 168–365 jours | 1 |
| 366–730 jours | 2 |
| 731–1460 jours | 3 |
| 1461+ jours | 5 |

### 4.3 Déroulement de la formation (42 jours)

```
SEMAINE 1–2 (Jour 1–14) : DÉCOUVERTE
  - L'apprenti observe l'exploitation du maître (accès lecture)
  - Missions tutorielles guidées sur SA propre ferme
  - Récompense : 500€/jour travaillé = 7 000€

SEMAINE 3–4 (Jour 15–28) : PRATIQUE
  - L'apprenti effectue des tâches sur l'exploitation du maître
  - Chaque tâche validée = XP + rémunération
  - Le maître bénéficie de 3 h de main d'œuvre gratuite/jour (l'apprenti travaille chez lui)
  - Récompense : 750€/jour travaillé = 10 500€

SEMAINE 5–6 (Jour 29–42) : AUTONOMIE
  - L'apprenti gère sa propre ferme avec conseils du maître
  - Le maître valide les choix stratégiques (via interface dédiée)
  - Bonus XP ×1.5 sur toutes les actions de l'apprenti
  - Récompense : 1 000€/jour travaillé = 14 000€
```

**Total rémunération apprenti** : 31 500€ sur 42 jours.

### 4.4 Récompenses

| Bénéficiaire | Récompense | Condition |
|-------------|-----------|-----------|
| Apprenti | 31 500€ (salaire formation) | Compléter les 42 jours |
| Apprenti | 50 000€ (aide CESA installation) | Formation terminée |
| Apprenti | Badge « Formé » (cosmétique) | Formation terminée |
| Maître | 3 h de main d'œuvre gratuite/jour pendant 28 jours | Semaines 3–6 |
| Maître | 15 000€ prime de formation | Formation terminée |
| Maître | Badge « Formateur » (niveaux 1–5) | Cumulatif par formation réussie |
| Maître | +5% réputation sociale | Par formation réussie |

### 4.5 Anti-abus CFSA

| Risque | Détection | Sanction |
|--------|-----------|----------|
| Maître qui ne forme pas (0 interaction) | < 3 messages/semaine au stagiaire | Avertissement → annulation si récidive |
| Apprenti fantôme (inscrit mais inactif) | < 5 connexions/semaine | Formation annulée après 7j inactivité |
| Multi-compte pour aide CESA | Même IP/appareil, création < 48h | Bannissement des deux comptes |
| Maître qui exploite (tâches sans apprentissage) | > 80% du temps sur tâches maître, 0 progression apprenti | Perte du slot + amende 20 000€ |

### 4.6 Mockup ASCII — Écran CFSA (vue apprenti)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🎓 CENTRE DE FORMATION AGRIVA — Mon stage                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Maître-exploitant : Jean_Duval (⭐⭐⭐ Formateur niveau 3)          │
│  Jour de formation : 18 / 42          Phase : PRATIQUE              │
│                                                                     │
│  ┌─── Progression ──────────────────────────────────────────┐       │
│  │  ████████████████████░░░░░░░░░░░░░░░░░░░░  43%           │       │
│  └───────────────────────────────────────────────────────────┘       │
│                                                                     │
│  📋 Missions du jour :                                              │
│  ┌──────────────────────────────────────────────────────────┐       │
│  │  ✅ Nourrir les bovins du maître (1 h 30)   +250€ +15XP │       │
│  │  ✅ Labourer parcelle B4 (2 h 10)           +200€ +10XP │       │
│  │  ⬜ Vendre 5t de blé au marché (10 min)     +150€ +20XP │       │
│  │  ⬜ Acheter semences pour MA ferme (10 min) +0€   +25XP │       │
│  └──────────────────────────────────────────────────────────┘       │
│                                                                     │
│  💰 Rémunération cumulée : 13 250€ / 31 500€                       │
│  🏆 XP gagnée : 340 / 800 (objectif fin formation)                 │
│                                                                     │
│  💬 Dernier message du maître (il y a 2h) :                         │
│  « Pense à vendre ton blé avant jeudi, les prix vont baisser »     │
│                                                                     │
│  [📨 Écrire au maître]  [📊 Voir exploitation maître]  [❌ Quitter] │
└─────────────────────────────────────────────────────────────────────┘
```



---

## 5. Anti-abus et intégrité

### 5.1 Multi-comptes

**Règle** : 1 compte par personne par serveur. Pas d'exception.

| Signal de détection | Méthode | Seuil |
|--------------------|---------|-------|
| Même IP | Corrélation connexions | > 80% sessions sur même IP |
| Même appareil | Fingerprint navigateur | Correspondance > 90% |
| Transactions suspectes | Échanges systématiques entre 2 comptes | > 5 transactions/semaine même paire |
| Horaires synchronisés | Connexion/déconnexion simultanée | Corrélation > 0.85 sur 14 jours |
| Complémentarité économique | Un compte ne vend qu'à l'autre | > 60% des ventes vers même acheteur |

**Sanctions** :
1. Alerte automatique → vérification manuelle
2. Si confirmé : bannissement du compte secondaire, avertissement au principal
3. Récidive : bannissement définitif des deux comptes + IP

### 5.2 Collusion et prix truqués

**Définition** : deux joueurs qui s'échangent des biens à des prix anormaux pour transférer de l'argent.

```
DÉTECTION :
prix_marche_moyen = moyenne glissante 30 jours pour cet item
prix_transaction = prix réel de la transaction

anomalie = |prix_transaction − prix_marche_moyen| / prix_marche_moyen

Si anomalie > 0.50 (±50% du prix moyen) → FLAG
Si anomalie > 0.80 ET même paire de joueurs → ALERTE HAUTE
Si > 3 transactions flaggées entre même paire en 30 jours → ENQUÊTE AUTO
```

**Sanctions graduées** :
1. Transaction annulée + avertissement (1re fois)
2. Blocage marché 7 jours + amende 50 000€ (2e fois)
3. Bannissement 30 jours (3e fois)

### 5.3 Manipulation de marché

| Type | Détection | Seuil | Sanction |
|------|-----------|-------|----------|
| Accaparement | Un joueur détient > 40% du stock serveur d'un item | 40% | Interdiction d'achat de cet item 14j |
| Prix aberrant (haut) | Annonce > 300% prix PNJ | 300% | Annonce masquée + avertissement |
| Prix aberrant (bas) | Annonce < 20% prix PNJ | 20% | Annonce masquée + avertissement |
| Dumping coordonné | 3+ joueurs vendent même item à perte simultanément | Corrélation temporelle | Enquête manuelle |
| Cornering | Achat massif + revente immédiate majorée | Achat > 20 unités + revente < 48h à > +50% | Profit confisqué + amende |

### 5.4 Comptes dormants et fermes abandonnées

| Durée inactivité | Action | Réversible ? |
|-----------------|--------|--------------|
| 30 jours | Notification email « votre ferme vous attend » | — |
| 90 jours | Statut « dormant » — exploitation invisible au classement | Oui (retour = réactivation) |
| 180 jours | Animaux transférés au PNJ (vendus au prix coop) — argent crédité | Oui (argent disponible au retour) |
| 365 jours | Terres libérées → retour au pool « zone JA » pour nouveaux | Partiellement (le joueur récupère l'argent, pas les terres) |
| 730 jours | Compte archivé — matériel/bâtiments vendus, solde gelé | Restauration sur demande (support) |

**Principe** : le joueur ne PERD jamais d'argent. Ses actifs sont convertis en liquidités gelées. Seules les terres sont libérées (ressource commune limitée).

### 5.5 Outils de modération et sanctions graduées

| Niveau | Sanction | Durée | Appliqué par |
|--------|----------|-------|--------------|
| 0 | Avertissement (visible dans profil) | Permanent | Automatique |
| 1 | Mute chat/forum | 24h–7j | Automatique ou modérateur |
| 2 | Blocage marché (ne peut ni acheter ni vendre) | 7–30j | Modérateur |
| 3 | Gel de compte (lecture seule, pas d'action) | 7–30j | Admin |
| 4 | Bannissement temporaire | 30–90j | Admin |
| 5 | Bannissement définitif | Permanent | Admin (2 admins requis) |

**Droit d'appel** : toute sanction ≥ niveau 3 peut être contestée via formulaire. Réponse sous 72h.



---

## 6. Cycle de vie du serveur

### 6.1 Pas de wipe — justification

SimAgri ne wipe JAMAIS. Agriva non plus. Raisons :

| Argument pour le wipe | Pourquoi on le refuse |
|----------------------|----------------------|
| « Remet tout le monde à égalité » | Détruit des mois/années d'investissement émotionnel |
| « Corrige l'inflation » | Le stabilisateur automatique (§2.5) le fait en continu |
| « Relance l'intérêt » | Les serveurs frais remplissent ce rôle sans détruire |
| « Nettoie les comptes morts » | Le système §5.4 libère les terres progressivement |

**La promesse Agriva** : votre ferme ne disparaîtra jamais tant que vous jouez.

### 6.2 Stratégie d'ouverture séquentielle (ADR-005 §4)

Le risque principal de deux serveurs séparés est la **fragmentation de la population**. Pour un jeu économique multijoueur, un serveur peu peuplé est un serveur mort : pas de marché, pas de prestataires, pas de coopératives.

**Ouverture en 3 phases :**

```
PHASE 1 — Lancement : serveur Normal UNIQUEMENT
  Objectif : concentrer TOUTE la population sur un seul serveur.
  Valider l'équilibrage, faire vivre le marché et les métiers de service.
  Aucun serveur Expert n'existe à ce stade.

PHASE 2 — Ouverture du serveur Expert
  Condition : le serveur Normal atteint 800 joueurs actifs.
  Justification : environ 250-300 joueurs pourront migrer vers Expert
                  sans vider le Normal (qui reste > 500, donc viable).

PHASE 3 — Serveurs supplémentaires
  Condition : un serveur dépasse 3 000 joueurs actifs.
  Action : ouvrir un second serveur du même type.
```

### 6.3 Seuils de viabilité d'un serveur

| Population active | Viabilité | Ce qui fonctionne / ne fonctionne pas |
|:-----------------:|-----------|---------------------------------------|
| < 100 | ❌ Non viable | Marché atone, aucun métier de service rentable |
| 100-250 | ⚠️ Fragile | Marché fonctionnel, 1-2 concessionnaires possibles, pas de CUMA |
| 250-800 | ✅ Viable | Tous les métiers viables, CUMA et CAR possibles |
| 800-3 000 | ✅ Optimal | Concurrence saine entre prestataires, marché profond |
| > 3 000 | ⚠️ Saturation | Ouvrir un second serveur du même type |

**Filets de sécurité** (protègent un serveur peu peuplé) :
- ETA PNJ toujours disponible (`GDD-metiers-eta-concession` §2)
- Coopérative PNJ pour acheter et vendre (`GDD-marche` §3)
- Concessionnaire PNJ de secours (`GDD-metiers-eta-concession` §7)

### 6.4 Critère de fusion du serveur Expert

> **Indicateur à surveiller** : si le serveur Expert descend sous **150 joueurs actifs** pendant **3 mois consécutifs**, envisager sa fusion avec le serveur Normal.

**Procédure de fusion Expert → Normal** :
1. Annonce officielle 30 jours à l'avance
2. Les exploitations Expert basculent en configuration Normal
3. Compensation versée aux joueurs Expert (ajustement de leur capital pour refléter les contraintes plus légères du Normal)
4. Les classements Expert sont archivés (historiques conservés)
5. Cooldown de 6 mois avant ré-ouverture éventuelle d'un serveur Expert

### 6.5 Ouverture de serveurs supplémentaires

| Condition | Seuil | Action |
|-----------|-------|--------|
| Saturation joueurs | > 3 000 joueurs actifs sur un serveur | Ouverture d'un second serveur du même type |
| Saturation foncière | > 85% des terres attribuées | Ouverture ou extension de la carte |
| Demande communautaire | > 50 votes sur le forum officiel | Étude d'ouverture |
| Événement marketing | Lancement campagne pub | Serveur « fresh start » temporaire → permanent si > 100 joueurs à J+30 |

**Paramètres d'un nouveau serveur** :
- Type choisi (Normal ou Expert) selon la stratégie séquentielle
- 0 joueur existant (tout le monde repart de zéro)
- Bonus accéléré les 30 premiers jours (+50% XP, +20% revenus coop)
- Pas de migration depuis un autre serveur (pas de transfert d'exploitation)

### 6.6 Fusion de serveurs dépeuplés (cas général)

| Condition | Seuil | Action |
|-----------|-------|--------|
| Joueurs actifs | < 100 pendant 90 jours consécutifs | Alerte fusion |
| Confirmation | Vote communautaire (majorité simple) | Planification fusion |
| Exécution | Annonce 30 jours à l'avance | Migration |

**Règles de fusion** :
- Les joueurs gardent TOUT (solde, terres, animaux, matériel)
- Les terres sont re-localisées sur la carte du serveur cible (même surface, nouvel emplacement)
- Les classements sont fusionnés (au sein du même type de serveur)
- Les annonces marché sont transférées
- Historique de formation CFSA préservé
- Cooldown de 90 jours avant nouvelle fusion possible

> Note : une fusion ne peut avoir lieu qu'entre serveurs du **même type** (Normal + Normal, ou Expert + Expert). La fusion Expert → Normal (§6.4) est un cas spécial de disparition du serveur Expert.

### 6.7 Exploitation abandonnée — parcours détaillé

```
JOUR 0 : Dernière connexion du joueur
         └→ Rien ne change. Les animaux continuent de consommer
             (nourris automatiquement si stock disponible).

JOUR 30 : Notification email
         └→ « Vos animaux ont faim ! Reconnectez-vous. »

JOUR 90 : Passage en DORMANT
         └→ Exploitation invisible aux classements
         └→ Animaux nourris gratuitement (pas de pénalité)
         └→ Pas de production (lait, œufs = 0)

JOUR 180 : Liquidation bétail
         └→ Animaux vendus au prix coopérative (−10%)
         └→ Argent crédité sur le compte du joueur
         └→ Notification email avec récapitulatif

JOUR 365 : Libération des terres
         └→ Parcelles retournent au pool « Zone JA »
         └→ Bâtiments conservés (pas de démolition)
         └→ Le joueur récupère la valeur foncière sur son solde

JOUR 730 : Archivage
         └→ Compte en lecture seule
         └→ Matériel + bâtiments liquidés (valeur résiduelle)
         └→ Solde total gelé, restaurable sur demande
```



---

## 7. Tableau de bord administrateur

> **Contexte multi-serveurs (ADR-005)** : le tableau de bord doit permettre de surveiller les deux serveurs (Normal et Expert) de manière indépendante et comparée. Chaque serveur a ses propres indicateurs, mais l'administrateur dispose d'une vue consolidée.

### 7.1 Métriques quotidiennes (par serveur)

| Catégorie | Métrique | Granularité | Scope |
|-----------|---------|-------------|:-----:|
| Économie | Masse monétaire totale | Quotidien | Par serveur |
| Économie | Inflation annualisée (glissante 30j) | Quotidien | Par serveur |
| Économie | Coefficient stabilisateur actif | Temps réel | Par serveur |
| Économie | Volume transactions marché (€) | Quotidien | Par serveur |
| Population | Joueurs actifs (connectés dans les 7j) | Quotidien | Par serveur |
| Population | Inscriptions / départs (rolling 30j) | Quotidien | Par serveur |
| Population | Rétention J7/J30/J90 | Hebdomadaire | Par serveur |
| Population | **Seuil de viabilité** (cf. §6.3) | Quotidien | Par serveur |
| Équité | Ratio P90/P10 richesse | Quotidien | Par serveur |
| Équité | Solde médian | Quotidien | Par serveur |
| Équité | Nb joueurs < 50 000€ de solde | Quotidien | Par serveur |
| Intégrité | Alertes anti-abus en attente | Temps réel | Par serveur |
| Intégrité | Sanctions appliquées (7j) | Quotidien | Par serveur |
| Foncier | % terres attribuées | Quotidien | Par serveur |
| CFSA | Formations en cours / terminées (30j) | Quotidien | Par serveur |
| **Global** | Population totale (tous serveurs) | Quotidien | Cross-serveur |
| **Global** | Répartition Normal / Expert | Quotidien | Cross-serveur |

### 7.2 Alertes automatiques (par serveur)

| Alerte | Condition | Priorité | Action suggérée |
|--------|-----------|----------|-----------------|
| 🔴 Inflation critique | > 15%/an annualisé | CRITIQUE | Vérifier stabilisateur, activer levier §2.6 |
| 🔴 Ratio P90/P10 > 80× | Inégalité extrême | CRITIQUE | Vérifier plafonds, ajuster aides JA |
| 🔴 Serveur non viable | < 100 joueurs actifs pendant 30j | CRITIQUE | Activer procédure §6.4/§6.6 |
| 🟠 Coefficient puits > 1.25 | Stabilisateur très actif | HAUTE | Surveiller, préparer communication |
| 🟠 Rétention J30 < 40% | Les nouveaux quittent | HAUTE | Analyser CFSA, vérifier dotation |
| 🟠 Terres > 85% attribuées | Saturation foncière | HAUTE | Planifier extension ou nouveau serveur |
| 🟠 Serveur fragile | 100-250 joueurs actifs (serveur Expert) | HAUTE | Surveiller le seuil de fusion (150 actifs × 3 mois) |
| 🟠 Saturation serveur | > 3 000 joueurs actifs | HAUTE | Planifier ouverture d'un serveur supplémentaire |
| 🟡 Multi-compte détecté | Confidence > 90% | MOYENNE | Enquête manuelle sous 48h |
| 🟡 Transaction aberrante | Anomalie > 80% | MOYENNE | Vérification automatique + file modération |
| 🟡 Phase 2 déclenchable | Normal atteint 800 joueurs actifs (Expert pas encore ouvert) | MOYENNE | Préparer l'ouverture du serveur Expert |

### 7.3 Leviers d'action manuels

| Levier | Effet | Qui peut l'utiliser | Réversible ? | Scope |
|--------|-------|--------------------|--------------| :---: |
| Forcer coefficient_puits | Override temporaire du stabilisateur | Admin senior | Oui (expire après 7j) | Par serveur |
| Injection monétaire | Crédit de X€ à tous les joueurs | Admin senior (2 requis) | Non | Par serveur |
| Ponction monétaire | Taxe exceptionnelle X% sur tous les soldes > Y€ | Admin senior (2 requis) | Non | Par serveur |
| Gel du marché | Suspend toutes les transactions | Admin | Oui (durée max 24h) | Par serveur |
| Bonus événement | +X% revenus pendant Y jours | Admin | Oui (fin automatique) | Par serveur |
| Extension carte | Ajouter Z ha de terres disponibles | Admin senior | Non | Par serveur |
| Réinitialiser CFSA joueur | Permettre une 2e formation (exceptionnel) | Admin | Non | Par serveur |
| Ouvrir serveur Expert | Déclencher la Phase 2 | Admin senior (2 requis) | Non | Global |
| Fusionner un serveur | Lancer la procédure de fusion §6.4/§6.6 | Admin senior (2 requis) | Non | Global |

### 7.4 Mockup ASCII — Tableau de bord admin (vue multi-serveurs)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🛡️  AGRIVA — Administration              [2026-08-04 14:30]               │
│  [Serveur Normal ✓] [Serveur Expert]  [Vue consolidée]                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─── 🌐 VUE GLOBALE ──────────────────────────────────────────────────┐   │
│  │  Population totale : 1 435 joueurs actifs                            │   │
│  │  ├─ Serveur Normal : 1 049 actifs (✅ Optimal)                       │   │
│  │  └─ Serveur Expert :   386 actifs (✅ Viable)                        │   │
│  │  Phase courante : PHASE 2 (Expert ouvert)                            │   │
│  │  Prochaine action : aucune (population dans les seuils)              │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─── 💰 ÉCONOMIE — Serveur Normal ────────────────────────────────────┐   │
│  │  Masse monétaire : 62 450 000€        Δ 30j : +2.1% (🟢 4.8%/an)   │   │
│  │  Coefficient stabilisateur : 1.03     (actif, normal)                │   │
│  │  Volume marché 24h : 1 240 000€       Transactions : 347             │   │
│  │  Prix moyen blé : 198€/t (PNJ: 195€) Écart : +1.5% 🟢              │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─── 💰 ÉCONOMIE — Serveur Expert ────────────────────────────────────┐   │
│  │  Masse monétaire : 18 200 000€        Δ 30j : +1.8% (🟢 4.2%/an)   │   │
│  │  Coefficient stabilisateur : 1.01     (actif, normal)                │   │
│  │  Volume marché 24h : 420 000€         Transactions : 112             │   │
│  │  Prix moyen blé : 192€/t (PNJ: 195€) Écart : −1.5% 🟢              │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─── 👥 POPULATION ───────────────────────────────────────────────────┐   │
│  │         Normal                    Expert                             │   │
│  │  Actifs (7j) : 1 049 / 1 180     Actifs (7j) : 386 / 428            │   │
│  │  Inscrip. 30j :  +28             Inscrip. 30j :  +8                  │   │
│  │  Départs 30j :   −6              Départs 30j :   −3                  │   │
│  │  Rétention J30 : 52%             Rétention J30 : 61%                 │   │
│  │  Viabilité : ✅ Optimal           Viabilité : ✅ Viable               │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─── 🚨 ALERTES ──────────────────────────────────────────────────────┐   │
│  │  🟡 [Normal] 1 alerte multi-compte (confidence 92%)                  │   │
│  │  🟡 [Expert] 2 transactions aberrantes flaggées                      │   │
│  │  Dernière alerte critique : aucune depuis 45 jours 🟢               │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  [📊 Graphiques]  [⚙️ Leviers]  [👤 Joueurs]  [📋 Modération]  [🔄 Refresh]│
└─────────────────────────────────────────────────────────────────────────────┘
```



---

## 8. Équilibrage — Simulation économique sur 3 ans

### 8.1 Hypothèses du scénario

| Paramètre | Valeur |
|-----------|--------|
| Joueurs au lancement | 50 |
| Croissance joueurs | +10/mois pendant 12 mois, puis +3/mois |
| Départs | 5%/mois des joueurs < 90 jours, 1%/mois des > 90 jours |
| Solde initial moyen | 150 000€ (dotation) |
| Revenu moyen/joueur/mois | 25 000€ (croît à 35 000€ après 1 an d'ancienneté) |
| Puits moyen/joueur/mois | 20 000€ (croît à 28 000€ avec la taille) |
| Coefficient stabilisateur | Dynamique (formule §2.5) |

### 8.2 Simulation mois par mois (résumé trimestriel)

```
ANNÉE 1
─────────────────────────────────────────────────────────────────────────────
Trimestre  Joueurs  Masse monétaire   Sources/mois  Puits/mois  Inflation  Coeff
           actifs   fin trimestre     (serveur)     (serveur)   annualisée puits
─────────────────────────────────────────────────────────────────────────────
T1 (M1-3)    72     8 200 000€       1 500 000€    1 150 000€   16.2%     1.00→1.12
T2 (M4-6)    95    11 800 000€       2 100 000€    1 780 000€   12.1%     1.12→1.18
T3 (M7-9)   118    14 900 000€       2 700 000€    2 430 000€    8.4%     1.18→1.14
T4 (M10-12) 138    17 500 000€       3 200 000€    2 950 000€    6.6%     1.14→1.08

ANNÉE 2
─────────────────────────────────────────────────────────────────────────────
T5 (M13-15)  150    19 800 000€       3 500 000€    3 280 000€    5.2%     1.08→1.05
T6 (M16-18)  158    21 600 000€       3 700 000€    3 510 000€    4.6%     1.05→1.03
T7 (M19-21)  164    23 200 000€       3 850 000€    3 680 000€    4.4%     1.03→1.02
T8 (M22-24)  168    24 700 000€       3 950 000€    3 790 000€    4.1%     1.02→1.01

ANNÉE 3
─────────────────────────────────────────────────────────────────────────────
T9 (M25-27)  172    26 100 000€       4 050 000€    3 900 000€    3.8%     1.01→1.00
T10 (M28-30) 175    27 400 000€       4 100 000€    3 960 000€    3.7%     1.00
T11 (M31-33) 177    28 600 000€       4 130 000€    3 990 000€    3.5%     1.00
T12 (M34-36) 179    29 800 000€       4 160 000€    4 020 000€    3.3%     1.00
```

### 8.3 Analyse

**Année 1 — Phase de croissance** :
- Inflation élevée (16% au T1) car beaucoup de nouveaux joueurs reçoivent dotations + aides
- Le stabilisateur réagit : coefficient monte à 1.18 au T2
- L'inflation redescend progressivement grâce à l'augmentation des puits

**Année 2 — Stabilisation** :
- L'inflation passe sous la cible de 5% au T6
- Le stabilisateur se relâche (coefficient redescend vers 1.0)
- La croissance joueurs ralentit → moins de dotations → moins de création monétaire

**Année 3 — Régime de croisière** :
- Inflation stable entre 3-4% — en dessous de la cible
- Le stabilisateur est neutre (coefficient 1.0)
- La masse monétaire croît modérément avec les nouveaux joueurs

### 8.4 Indicateurs d'équité à 3 ans

| Indicateur | Année 1 fin | Année 2 fin | Année 3 fin | Seuil alerte |
|-----------|-------------|-------------|-------------|--------------|
| Solde médian | 180 000€ | 290 000€ | 380 000€ | > 800 000€ |
| Ratio P90/P10 | 12× | 22× | 28× | > 50× |
| Joueurs < 50k€ | 15% | 8% | 5% | > 20% |
| Prix blé marché/PNJ | +8% | +4% | +2% | > 30% |

**Constat** : le ratio P90/P10 monte naturellement (les anciens s'enrichissent). À 28× en fin d'année 3, on est dans le vert. La tendance suggère un passage en orange (>50×) vers l'année 5-6, ce qui déclenchera un renforcement des rendements décroissants.

### 8.5 Scénario de stress : que se passe-t-il sans stabilisateur ?

```
SANS stabilisateur (coefficient fixe à 1.0) :
  Année 1 : inflation 18% → masse 19.5M€ (vs 17.5M€ régulé)
  Année 2 : inflation 14% → masse 30.2M€ (vs 24.7M€ régulé)
  Année 3 : inflation 12% → masse 42.8M€ (vs 29.8M€ régulé)

  → Prix blé marché : +45% vs PNJ (les nouveaux ne peuvent plus acheter)
  → Ratio P90/P10 : 65× (zone rouge)
  → Le jeu devient injouable pour les nouveaux après 2 ans
```

**Conclusion** : le stabilisateur est INDISPENSABLE. Sans lui, le serveur dérive en 2 ans.

---

## 9. Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Charges sociales | 12% bénéfice | 28% bénéfice |
| Cotisation MSA minimum | 1 000€/trimestre | 2 500€/trimestre |
| Taxe foncière | 50€/ha/an forfaitaire | 80€/ha/an + 0.1% valeur foncière |
| Rendements décroissants | −5%/tranche de 100 ha | −12%/tranche de 100 ha |
| Plafond surface | 800 ha | 500 ha |
| Plafond cheptel bovin | 500 têtes | 300 têtes |
| Plafond employés | 10 | 8 |
| Dotation initiale | 150 000€ | 150 000€ |
| Prêt JA | 150 000€ à 1.5% | 120 000€ à 3% |
| Aide CESA post-formation | 50 000€ | 40 000€ |
| Capacité de travail majorée (nouveaux) | Non (SdV §19 : pas de rattrapage) | Non (SdV §19) |
| Réduction intrants nouveaux | Non (SdV §19 : pas de rattrapage) | Non (SdV §19) |
| Coefficient stabilisateur max | 1.40 | 1.50 |
| Coefficient vente PNJ min | 0.80 | 0.70 |
| Faillite | Impossible | Possible (redressement) |
| Marché joueurs | Carnet d'ordres unique (SdV §3) | Carnet d'ordres unique (SdV §3) |
| Durée formation CFSA | 42 jours | 42 jours |
| Prime maître CFSA | 15 000€ | 12 000€ |
| Heures sup. maître pendant formation | +30 min/jour (28j) | +30 min/jour (28j) |

---

## 10. Checklist playtest

| Test | Critère de succès | Bloquant ? |
|------|-------------------|-----------|
| Recette SimAgri (Normal) | Un joueur SimAgri retrouve ses sensations, dit « c'est SimAgri en mieux » | ✅ OUI |
| Nouveau joueur viable | Un nouveau peut acheter 30 ha + matériel de base en 30 jours | ✅ OUI |
| Stabilisateur fonctionne | Simulation 3 ans : inflation < 5%/an en régime de croisière | ✅ OUI |
| Pas de monopole | Aucun joueur ne détient > 15% des terres à 2 ans | ✅ OUI |
| CFSA incitatif | > 30% des nouveaux demandent une formation | OUI |
| CFSA non-exploitable | Aucun pattern d'abus non détecté en test | OUI |
| Anti multi-compte | Détection > 85% en test (faux négatifs < 15%) | OUI |
| Fusion serveur safe | 0 perte de données post-fusion en test | ✅ OUI |
| Admin dashboard complet | Toutes les alertes se déclenchent aux bons seuils | OUI |
| Ratio P90/P10 < 50× | Maintenu sur simulation 5 ans | OUI |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Audit de couverture : trous CESA (10.7) et CFSA (1.8) identifiés |
| 2026-08-04 | Passage à deux serveurs séparés : portée inter-serveurs, classements par serveur, stratégie d'ouverture séquentielle | ADR-005 |
