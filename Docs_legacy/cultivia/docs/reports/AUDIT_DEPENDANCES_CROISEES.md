# 🔗 Audit Dépendances Croisées — Brainstorm Inter-Boucles

**Date** : 2026-04-06
**Participants** : @gamedesign, @uxdesign, @backend, @worker
**Sources** : 4 audits boucles + `regle sim.txt` + `ACTION_FLOW_REGISTRY.yaml`

---

## Synthèse

| Métrique | Valeur |
|----------|--------|
| Croisements analysés | 15 (6 boucles × 5 combinaisons) |
| Situations de blocage identifiées | 6 |
| Boucles de feedback manquantes | 5 |
| Ticks worker manquants | 4 |
| Notifications manquantes | 7 |
| Flows à créer | 5 (F075-F079) |
| Actions SimAgri non couvertes | 4 |

---

## 1. Matrice des croisements entre boucles

```
              Élevage   Cultures   Économie   Matériel   Infra   Info
Élevage         —        FUMIER     VENTE      USURE     BÂTI    DASH
Cultures      ALIMENT      —        VENTE      USURE     SILO    MÉTÉO
Économie      COÛT       COÛT        —         ACHAT     ÉNER    LEDGER
Matériel      BÉTAIL     OUTIL       ARGUS      —        HANGAR  PANNE
Infra         CAPAC      CAPAC       TAXE      STOCK      —      ÉTAT
Info          SANTÉ      POUSSE      SOLDE     WEAR       FILL    —
```

---

## 2. Croisement Élevage ↔ Cultures — FUMIER/LISIER

### 2.1 Boucle de feedback manquante : Fumier → Engrais organique

**@gamedesign** : SimAgri a une boucle fondamentale : les animaux produisent du fumier/lisier → stocké en fosse → épandu sur parcelles → améliore le rendement. C'est LE lien central entre élevage et cultures.

**État actuel** :
- F015 (litière) → fumier s'accumule ✅ (audit élevage FM2)
- F016 (retirer fumier) → fosse ✅
- F055 (épandre fumier sur parcelle) → créé par audit cultures ✅
- F056 (épandre lisier sur parcelle) → créé par audit cultures ✅

**Manque critique** : Aucun tick ne transforme la litière en fumier quotidiennement. L'audit élevage a identifié FM2 mais il n'est pas encore dans le registry.

**@worker** : Il faut un tick quotidien qui, pour chaque bâtiment avec litière :
1. Calcule `fumier_produit = Σ(paille_par_animal × ratio_fumier)`
2. Incrémente `building.manure_stock`
3. Décrémente `building.bedding_quality`
4. Si `manure_stock > seuil` → notification « Fosse bientôt pleine »

**Décision** : Tick déjà prévu (FM2 audit élevage). Confirmer dans le registry comme **F075**.

### 2.2 Boucle de feedback manquante : Aliments cultures → Élevage

**@gamedesign** : Les cultures produisent des aliments pour animaux (maïs ensilé, foin, paille, céréales). Le joueur cultivateur peut vendre au joueur éleveur.

**État actuel** :
- F041 (récolter) → stock en silo ✅
- F042 (vendre récolte) → Marché Central ✅
- F006 (acheter aliments) → depuis Marché Central ✅
- F008 (nourrir) → consomme stock ✅

**Verdict** : Chaîne complète ✅. Le Marché Central fait le pont. Pas de manque.

### 2.3 Blocage potentiel : Plus de fumier → fosse pleine → ne peut plus pailler

**@uxdesign** : Si la fosse à fumier est pleine et que le joueur ne peut pas épandre (pas de parcelle, mauvaise saison), il ne peut plus retirer le fumier du bâtiment → la litière s'accumule → hygiène baisse → maladie.

**@backend** : F052 (tick fosse) envoie déjà une notification quand la fosse est à 80%. Mais il n'y a pas de solution de secours.

**SimAgri** : Permet de vendre le fumier à d'autres joueurs ou de le composter.

**Décision** :
- Phase 1 : Ajouter dans F016 une option `sell_to_coop` qui vend le fumier au Marché Central à prix bas (filet de sécurité)
- Phase 3+ : Vente entre joueurs + compostage

---

## 3. Croisement Élevage ↔ Matériel — VÉHICULES OBLIGATOIRES

### 3.1 Blocage : Tracteur en panne → tout bloqué

**@gamedesign** : Le tracteur est requis pour : acheter animal (F002), acheter aliments (F006), nourrir par désilage (F008), retirer fumier (F016), vendre lait (F024), vendre animal (F025), toutes les opérations cultures. Si le tracteur tombe en panne, le joueur est paralysé.

**@backend** : F045 (réparer) existe mais nécessite une pièce détachée (F061, audit économie). Sans pièce → blocage total.

**SimAgri** : Location de tracteur chez un concessionnaire (même puissance ±5CV).

**Filets de sécurité actuels** :
1. F046 (ETA PNJ) → couvre les travaux parcelle uniquement
2. F008 method=manual → nourrir à la main (plus de HT, pas de tracteur)
3. F015 method=manual → pailler à la main

**Manques** :
- Pas de filet pour le transport (acheter aliments, vendre lait/animal)
- Pas de filet pour retirer fumier

**Décision** :
- Phase 1 : Ajouter dans F045 une option `repair_by_coop` (réparation SimAgri, coût élevé, pas besoin de pièce, immobilisation 2j) — déjà dans SimAgri
- Phase 4+ : Location matériel entre joueurs

### 3.2 Blocage : Plus de HVC → aucun transport

**@worker** : Si le joueur n'a plus de HVC et plus d'argent pour en acheter, il ne peut plus rien transporter.

**Filets de sécurité** :
1. F008/F015 method=manual → pas besoin de HVC
2. F046 (ETA) → l'ETA a son propre HVC

**Manque** : Pas de notification préventive quand le HVC est bas.

**Décision** : Ajouter un check dans le tick quotidien : si `hvc_stock < 50L` → notification ⚠️. Intégrer dans **F076** (tick alertes ressources).

---

## 4. Croisement Élevage ↔ Infrastructure — CAPACITÉ

### 4.1 Blocage : Naissance → pas de place → animal bloqué

**@gamedesign** : F020 (naissance) crée un animal dans le bâtiment de la mère. Si le bâtiment est plein, que se passe-t-il ?

**État actuel** : F020 ne vérifie pas la capacité. Le veau naît quoi qu'il arrive (réaliste).

**SimAgri** : L'animal naît même si le bâtiment est plein. Le joueur doit agrandir ou vendre.

**Décision** : OK, le veau naît toujours. Mais ajouter une notification urgente : « ⚠️ Bâtiment {name} en surpopulation ({count}/{max}) — agrandissez ou vendez ». Intégrer dans **F076**.

### 4.2 Boucle manquante : Amélioration bâtiment

**@gamedesign** : F069 (améliorer bâtiment) est identifié dans l'audit infra mais pas encore dans le registry. Sans amélioration, le joueur ne peut pas augmenter le niveau d'équipement (→ moins d'énergie consommée) ni agrandir.

**Décision** : Déjà prévu. Confirmer F069 dans le registry.

---

## 5. Croisement Cultures ↔ Matériel — OUTILS SPÉCIFIQUES

### 5.1 Blocage : Pas de moissonneuse → récolte impossible

**@gamedesign** : La récolte (F041) nécessite une moissonneuse. Si elle est en panne ou absente, la culture continue de mûrir puis perd en rendement.

**Filets de sécurité** :
1. F046 (ETA PNJ) → peut moissonner
2. F045 → réparer la moissonneuse

**@uxdesign** : Il faut une notification quand la culture atteint 90% de maturité ET que la moissonneuse est en panne.

**Décision** : Intégrer dans **F076** (tick alertes) : si `crop.growth >= 90% AND moissonneuse.is_broken` → alerte.

### 5.2 Feedback manquant : Usure matériel proportionnelle au travail

**@backend** : L'usure par action est modélisée dans chaque flow (F037, F038, F041...). Mais l'usure passive quotidienne (tick step 8) ne distingue pas abrité/non abrité pour les outils tractés.

**SimAgri** : « Un matériel abrité sous un hangar s'use moins vite que s'il reste dehors. »

**État actuel** : Le tick step 8 applique `wear += 0.02` (abrité) ou `wear += 0.05` (non abrité). ✅ Déjà modélisé.

**Verdict** : OK ✅.

---

## 6. Croisement Cultures ↔ Économie — SAISONNALITÉ DES REVENUS

### 6.1 Blocage : Pas de revenus pendant 6 mois (cultures d'hiver)

**@gamedesign** : Un joueur 100% cultures sème en octobre, récolte en juillet. Pendant 9 mois, zéro revenu. Les charges mensuelles (F067) continuent : énergie, taxes, prêts.

**@uxdesign** : Le joueur peut se retrouver en faillite avant la récolte.

**Filets de sécurité** :
1. F033 (prêt bancaire) → jusqu'à 150k€
2. F032 (épargne) → peut clôturer anticipé (F065)
3. Kit de départ → 100k€

**Manque** : Pas de notification préventive « Votre solde ne couvrira pas les charges des X prochains mois ».

**Décision** : Intégrer dans **F076** : si `balance < 3 × monthly_charges` → alerte « ⚠️ Trésorerie tendue ».

### 6.2 Feedback manquant : Prix du marché ↔ offre/demande

**@gamedesign** : SimAgri a des cours variables selon l'offre et la demande. Le registry F026 (cours du marché) est readonly. Mais aucun tick ne fait varier les prix.

**État actuel** : Les prix sont dans les seed data. Pas de tick de variation.

**Décision** : Créer **F077** (tick variation cours marché) — sprint 10. Logique : `prix = base × (1 + noise + demand_factor)`.

---

## 7. Croisement Économie ↔ Infrastructure — CHARGES FIXES

### 7.1 Blocage : Trop de bâtiments → charges insoutenables

**@gamedesign** : Chaque bâtiment consomme de l'énergie (F067 step 3). Un joueur qui construit trop de bâtiments vides peut se ruiner en charges.

**@uxdesign** : Pas de warning à la construction sur le coût mensuel d'entretien.

**Décision** : Ajouter dans F001 un tooltip informatif : « Coût mensuel estimé : {energy_cost}€/mois ». Correction mineure sur F001.

### 7.2 Feedback manquant : Destruction bâtiment → récupération

**@gamedesign** : F070 (détruire bâtiment) est identifié mais pas dans le registry. SimAgri donne 10% du prix d'achat.

**Décision** : Déjà prévu. Confirmer F070 dans le registry.

---

## 8. Croisement Matériel ↔ Infrastructure — STOCKAGE

### 8.1 Blocage : Pas de hangar → matériel s'use plus vite

**@worker** : Le tick usure passive (step 8) vérifie si le matériel est abrité. Mais le joueur n'est pas averti quand son hangar est plein et que du matériel reste dehors.

**Décision** : Intégrer dans **F076** : si `vehicle.is_sheltered = false` → alerte « ⚠️ {vehicle} non abrité — usure accélérée ».

---

## 9. Croisement Information ↔ Toutes boucles — NOTIFICATIONS

### 9.1 Notifications manquantes identifiées

| # | Situation | Boucle | Urgence | Intégrer dans |
|---|-----------|--------|---------|---------------|
| N1 | HVC < 50L | Matériel | ⚠️ | F076 |
| N2 | Bâtiment en surpopulation | Infra/Élevage | 🔴 | F076 |
| N3 | Moissonneuse en panne + culture ≥ 90% | Cultures/Matériel | 🔴 | F076 |
| N4 | Trésorerie < 3× charges mensuelles | Économie | ⚠️ | F076 |
| N5 | Matériel non abrité | Matériel/Infra | ℹ️ | F076 |
| N6 | Cuve lait bientôt pleine (>80%) | Élevage | ⚠️ | F076 |
| N7 | Animal non nourri depuis 2j | Élevage | 🔴 | F076 |

**Décision** : Regrouper dans un seul tick **F076 — Tick alertes ressources critiques** (sprint 4).

---

## 10. Actions SimAgri non couvertes (croisements)

| Action SimAgri | Boucles croisées | Priorité | Décision |
|----------------|-----------------|----------|----------|
| **Compostage** (fumier → compost 14j → épandage) | Élevage × Cultures | Moyenne | Phase 3+ — F078 |
| **Vente fumier/lisier entre joueurs** | Élevage × Économie | Basse | Phase 3+ |
| **Remboursement anticipé prêt** (pénalité 3%) | Économie | Moyenne | F079 sprint 9 |
| **Achat PA entre joueurs** (10€/PA) | Économie × Info | Basse | Phase 4+ |

---

## 11. Ticks worker — Couverture complète

### Ticks existants (registry)
| Step | Tick | Boucle | Sprint |
|------|------|--------|--------|
| 1 | Croissance animaux (F010) | Élevage | 4 |
| 2 | Auto-feed (F010) | Élevage | 4 |
| 3 | Santé animaux (F011) | Élevage | 4 |
| 4 | Maladie (F013) | Élevage | 5 |
| 5 | Gestation (F020) | Élevage | 6 |
| 6 | Arrivée transport (F048) | Matériel | 3 |
| 7 | Livraison matériel (F049) | Matériel | 12 |
| 8 | Usure passive matériel | Matériel | 4 |
| 9 | Pannes aléatoires | Matériel | 4 |
| 10 | Croissance cultures | Cultures | 10 |
| 11 | Météo quotidienne (F030) | Info | 8 |
| 12 | Fosse fumier/lisier (F052) | Infra | 5 |
| 13 | Consommation eau (F053) | Élevage | 4 |
| 14 | Lactation | Élevage | 7 |
| 15 | Intérêts épargne (F066) | Économie | 9 |
| 16 | Prélèvements mensuels (F067) | Économie | 9 |

### Ticks manquants identifiés
| ID | Tick | Boucle croisée | Sprint |
|----|------|----------------|--------|
| **F075** | Accumulation fumier/litière quotidien | Élevage × Cultures | 5 |
| **F076** | Alertes ressources critiques | Toutes × Info | 4 |
| **F077** | Variation cours marché | Économie × Cultures | 10 |
| **F078** | Compostage (fumier → compost 14j) | Élevage × Cultures | 16+ |
| — | Péremption lait (48h) | Élevage × Économie | Phase 2+ |

---

## 12. Flows à créer — Récapitulatif

| ID | Nom | Type | Sprint | Boucles croisées |
|----|-----|------|--------|-----------------|
| **F075** | Tick accumulation fumier/litière | worker_tick | 5 | Élevage × Cultures |
| **F076** | Tick alertes ressources critiques | worker_tick | 4 | Toutes × Info |
| **F077** | Tick variation cours marché | worker_tick | 10 | Économie × Cultures |
| **F078** | Composter du fumier | button_mutation | 16 | Élevage × Cultures |
| **F079** | Rembourser prêt par anticipation | button_mutation | 9 | Économie |

---

## 13. Corrections sur flows existants (croisements)

| Flow | Correction | Boucles |
|------|-----------|---------|
| F001 | Ajouter tooltip coût mensuel énergie estimé | Infra × Économie |
| F016 | Ajouter option `sell_to_coop` (vente fumier au MC) | Élevage × Économie |
| F020 | Notification surpopulation si bâtiment plein | Élevage × Infra |
| F045 | Ajouter option `repair_by_coop` (sans pièce, coût élevé, 2j) | Matériel × Économie |

---

## 14. Graphe de dépendances croisées

```
ÉLEVAGE                          CULTURES
  │                                │
  ├─ F015 litière ──→ F075 fumier ─┤
  │                    ↓           │
  │              F016 retirer      │
  │                    ↓           │
  │              F055 épandre ────→│ rendement +
  │                                │
  ├─ F023 traite ──→ F024 vendre ──┤
  │                                │
  └─ F025 abattoir ───────────────→│
                                   │
MATÉRIEL ←─── tracteur requis ────→│
  │                                │
  ├─ F043 acheter ──→ usure ──→ F045 réparer
  │                                │
  └─ F068 HVC ←── consommé par ───┘
                                   
ÉCONOMIE ←── revenus vente ────────┘
  │
  ├─ F067 charges mensuelles ──→ INFRA (énergie)
  │                            ──→ ÉLEVAGE (salaires)
  │
  └─ F033 prêt ──→ F079 remboursement anticipé
  
INFO ←── F076 alertes ←── TOUTES BOUCLES
```

---

## 15. Verdict final par question

### Q1 : Le joueur peut-il se retrouver bloqué ?
**6 situations identifiées**, toutes avec filet de sécurité proposé :
1. ❌ Tracteur en panne sans pièce → **F045 repair_by_coop**
2. ❌ Plus de HVC ni d'argent → **F008/F015 manual + F046 ETA**
3. ❌ Fosse pleine → **F016 sell_to_coop**
4. ❌ Naissance en surpopulation → **Naissance autorisée + alerte F076**
5. ❌ Faillite avant récolte → **F033 prêt + alerte F076**
6. ❌ Moissonneuse en panne à la récolte → **F046 ETA + alerte F076**

### Q2 : Boucles de feedback manquantes ?
**5 identifiées** :
1. Fumier → engrais parcelle (F075 + F055/F056) ✅ à créer
2. Prix marché dynamiques (F077) ✅ à créer
3. Compostage (F078) → Phase 3+
4. Péremption lait → Phase 2+
5. Coût énergie visible à la construction → correction F001

### Q3 : Les ticks couvrent-ils tous les effets différés ?
**4 ticks manquants** : F075, F076, F077, F078 (voir §11)

### Q4 : Les notifications alertent-elles à temps ?
**7 notifications manquantes** regroupées dans F076 (voir §9.1)

### Q5 : Actions SimAgri non couvertes ?
**4 identifiées** : compostage, vente fumier P2P, remboursement anticipé, achat PA (voir §10)

---

*Audit réalisé le 2026-04-06 — Brainstorm @gamedesign × @uxdesign × @backend × @worker*
