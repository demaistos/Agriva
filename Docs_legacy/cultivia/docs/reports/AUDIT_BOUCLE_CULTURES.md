# 🌾 Audit Boucle Cultures — Comparaison SimAgri vs Registry Cultivia

**Date** : 2026-04-06
**Auteur** : Expert Cultures IA
**Sources** : `docs/00-reference/regle sim.txt` + `docs/03-specs/ACTION_FLOW_REGISTRY.yaml` + `docs/03-specs/phases/PHASE1_CULTURES.md`

---

## Synthèse

| Métrique | Valeur |
|----------|--------|
| Étapes de la boucle analysées | 13 |
| Flows existants dans le registry (cultures) | 12 (F035-F042, F046) |
| Manques critiques identifiés | 7 |
| Corrections mineures | 9 |
| Flows à créer | 7 |

---

## Vue d'ensemble de la boucle

```
Acheter parcelle (F035)
  → Analyser sol (F036)
    → Déchaumer (F037 type=stubble)
      → Labourer (F037 type=plow)  ← uniquement technique Traditionnelle
        → Herser (F037 type=harrow)
          → Semer (F038)
            → Rouler (MANQUANT)
            → Épandre engrais (F039)
            → Épandre fumier/lisier (MANQUANT)
            → Traiter (F040)
            → Irriguer (MANQUANT)
              → Récolter (F041)
                → Presser paille (MANQUANT)
                → Broyer paille (MANQUANT)
                → Stocker en silo (inclus F041)
                  → Vendre récolte (F042)
  → Commander ETA (F046)
```

---

## 1. Acheter une parcelle (F035)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F035 | ✅/❌ |
|---------|---------|---------------|-------|
| Solde suffisant | ✅ | ✅ implicite | ✅ |
| HT suffisants | ✅ | ✅ `ht -= 2.0` | ✅ |
| Type parcelle (champ/pré) | ✅ champ, pré, verger | ✅ `type` dans body | ✅ |
| Surface en ha | ✅ 1-100 ha (200 ha CA/US) | ✅ `size_ha` dans body | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € (prix) | prix/ha × surface × qualité | ✅ `balance -= prix` | ✅ |
| HT | PA variable | ✅ `ht -= 2.0` | ✅ |
| Qualité sol aléatoire | ✅ 1-3 | ✅ `Generate soil quality` | ✅ |
| Pierres aléatoires | ✅ 0-100 | ❌ Non mentionné | ⚠️ |
| Altitude | Non SimAgri | ✅ `altitude` | ✅ |

### Manques
- **M1** : Le registry ne mentionne pas la génération de `stones_level` à l'achat. PHASE1_CULTURES.md le prévoit (0-60 selon qualité). → **Mineur**, déjà dans la spec technique.
- **M2** : Pas de `fatigue_index` initial mentionné dans le registry. → **Mineur**, déjà dans PHASE1_CULTURES.md.

---

## 2. Analyser le sol (F036)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F036 | ✅/❌ |
|---------|---------|---------------|-------|
| Parcelle possédée | ✅ | ✅ implicite | ✅ |
| Pas d'analyse récente | ✅ 1 fois / 5 saisons (420j) | ❌ Cooldown non spécifié | ⚠️ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € | 150€ | ✅ `balance -= 50` | ⚠️ Prix différent |
| HT | PA | ✅ `ht -= 0.5` | ✅ |

### Manques
- **M3** : SimAgri impose un cooldown de 420 jours (5 saisons) entre analyses. PHASE1_CULTURES.md prévoit 21 jours (1 saison). Le registry F036 ne mentionne aucun cooldown. → **Critique**, ajouter le cooldown.
- **M4** : Le prix est 50€ dans le registry vs 150€ dans SimAgri. Cultivia a choisi 50€ (PHASE1_CULTURES.md). → **OK, choix de design**.

---

## 3. Déchaumer (F037 type=stubble)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F037 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Cultivateur OU déchaumeur | ✅ les deux possibles | ⚠️ `vehicle:outil_sol` (générique) | ⚠️ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| HT | PA proportionnel surface | ✅ implicite | ✅ |
| HVC | CV × taux × PA | ✅ implicite | ✅ |
| Usure tracteur + outil | ✅ | ✅ `vehicle wear` | ✅ |
| Panne possible | ✅ si usure > seuil | ✅ `Roll panne chance` | ✅ |

### Conditions saisonnières
- SimAgri : déchaumage possible après récolte (été/automne principalement)
- Registry : pas de restriction saisonnière explicite → **OK**, le déchaumage n'a pas de contrainte saisonnière stricte.

### Manques
- **M5** : Le registry utilise `vehicle:outil_sol` générique. SimAgri distingue cultivateur et déchaumeur (deux outils différents). PHASE1_CULTURES.md les distingue aussi. → **Correction nécessaire** : préciser `vehicle:cultivateur|dechaumeur`.

---

## 4. Labourer (F037 type=plow)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F037 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Charrue | ✅ spécifiquement | ⚠️ `vehicle:outil_sol` (générique) | ⚠️ |
| Technique Traditionnelle uniquement | ✅ pas de labour en TCS/SD | ❌ Non modélisé | ❌ |

### Manques
- **M6** : SimAgri a 3 techniques culturales (Traditionnelle, TCS, Semis Direct) avec des outils différents. Le registry ne modélise pas ce choix. → **Critique pour le réalisme**. PHASE1_CULTURES.md mentionne la préparation mais ne distingue pas les techniques.
- **M7** : Le registry doit préciser `vehicle:charrue` pour le labour, pas `outil_sol` générique.

---

## 5. Herser (F037 type=harrow)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F037 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ | ✅ |
| Herse rotative | ✅ | ⚠️ `vehicle:outil_sol` | ⚠️ |

### Manques
- **M8** : Même problème que M5/M7 — le registry doit préciser `vehicle:herse_rotative`.

---

## 6. Semer (F038)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F038 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Semoir (classique ou M/B selon culture) | ✅ 2 types | ✅ `vehicle:semoir` | ⚠️ |
| Sol préparé (hersé) | ✅ | ✅ implicite (depends F037) | ✅ |
| Fenêtre saisonnière | ✅ mois précis par culture | ✅ `Check season` | ✅ |
| Rotation respectée | ✅ 1-6 ans selon culture | ✅ implicite | ✅ |
| Stock semences | ✅ | ✅ `stock:semences` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € (semences) | kg/ha × prix/kg | ✅ `balance` | ✅ |
| HT | PA | ✅ `ht` | ✅ |
| HVC | CV × taux × PA | ✅ | ✅ |
| Semences (stock) | kg/ha × surface | ✅ `seeds` | ✅ |
| Usure semoir + tracteur | ✅ | ✅ `vehicle wear` | ✅ |

### Conditions saisonnières (SimAgri)
| Culture | Semis | Récolte | Rotation |
|---------|-------|---------|----------|
| Blé | Oct-Nov | Juil-Août | 1 an |
| Orge | Oct-Nov | Juin-Juil | 1 an |
| Maïs grain | Avr-Mai | Oct-Nov | 2 ans |
| Colza | Août-Sep | Juin-Juil | 2 ans |
| Tournesol | Mar-Avr | Août-Sep | 3 ans |
| Pois | Fév-Mar | Juil-Août | 3 ans |
| Betterave | Mar-Avr | Oct-Nov | 4 ans |

### Manques
- **M9** : SimAgri distingue semoir classique (céréales) et semoir M/B (maïs/betterave). Le registry a un seul `vehicle:semoir`. PHASE1_CULTURES.md le distingue dans le catalogue. → **Correction mineure** dans le registry.
- **M10** : SimAgri permet le semis direct (sans labour ni hersage) avec un semoir direct spécifique. Non modélisé. → **Phase ultérieure**.

---

## 7. Rouler (MANQUANT — à créer)

### Analyse SimAgri
- Le passage du rouleau sur céréales et herbe donne +3% à +5% de rendement
- Possible entre 10% et 50% de croissance
- Matériel : tracteur + rouleau (tracté)
- PHASE1_CULTURES.md le prévoit (Feature 7, `rollCrop`)

### Statut registry
- **❌ ABSENT du registry**. L'action est dans PHASE1_CULTURES.md mais pas dans ACTION_FLOW_REGISTRY.yaml.
- → **Flow F054 à créer** : Rouler une parcelle

---

## 8. Épandre engrais (F039)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F039 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Épandeur à engrais | ✅ | ✅ `vehicle:epandeur_engrais` | ✅ |
| Stock engrais | ✅ | ✅ `stock:engrais` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € (engrais) | dose/ha × prix | ✅ implicite | ✅ |
| HT | PA | ✅ implicite | ✅ |
| HVC | ✅ | ✅ | ✅ |
| Engrais (stock) | dose/ha × surface | ✅ | ✅ |
| Usure | ✅ | ✅ | ✅ |

### Manques
- **M11** : SimAgri permet aussi l'épandage de fumier (25T/ha, épandeur à fumier) et de lisier (15m³/ha, tonne à lisier) comme engrais organique. Le registry F039 ne couvre que l'engrais chimique. → **Flows F055 et F056 à créer** pour fumier et lisier sur parcelle.
- **M12** : SimAgri permet 1 ou 2 passages d'engrais selon la culture. Le registry ne précise pas. → **Correction mineure**.

---

## 9. Traiter (F040)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F040 | ✅/❌ |
|---------|---------|---------------|-------|
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Pulvérisateur | ✅ (tracté ou automoteur) | ✅ `vehicle:pulverisateur` | ✅ |
| Stock traitement | ✅ | ✅ `stock:traitement` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € | 9€/L × 1.6 L/ha | ✅ implicite | ✅ |
| HT | PA | ✅ implicite | ✅ |
| HVC | ✅ | ✅ | ✅ |
| Traitement (stock) | 1.6 L/ha | ✅ | ✅ |
| Usure | ✅ | ✅ | ✅ |

### Types de traitements (SimAgri)
| Type | Prix | Dosage | Impact si absent |
|------|------|--------|------------------|
| Fongicide | 9€/L | 1.6 L/ha | Rendement ×0.95 |
| Herbicide | 9€/L | 1.6 L/ha | Rendement ×0.95 |
| Insecticide | 9€/L | 1.6 L/ha | Rendement ×0.95 |

### Manques
- **M13** : SimAgri a un système de prévention/lutte (traiter jour 1 = prévention, jour 2-3 = lutte avec dégâts). Le registry ne modélise pas cette temporalité. → **Phase ultérieure**, simplification acceptable pour le MVP.

---

## 10. Irriguer (MANQUANT — à créer)

### Analyse SimAgri
- Forage dans la parcelle (150€) pour trouver une source (niveau 1-10)
- Irrigation par enrouleur (tracteur + enrouleur, source requise)
- Irrigation par pivot central (construction + rampes)
- Retenue collinaire possible
- Impact : augmente la jauge pluviométrie

### Statut registry
- **❌ ABSENT du registry**. Ni forage ni irrigation ne sont modélisés.
- PHASE1_CULTURES.md mentionne les jauges eau/soleil mais pas l'irrigation active.
- → **Flows F057 (Forer) et F058 (Irriguer) à créer**

---

## 11. Récolter (F041)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F041 | ✅/❌ |
|---------|---------|---------------|-------|
| Moissonneuse-batteuse (céréales) | ✅ | ✅ `vehicle:moissonneuse` | ✅ |
| Ensileuse (maïs ensilé) | ✅ | ❌ Non distingué | ⚠️ |
| Arracheuse (betterave) | ✅ | ❌ Non distingué | ⚠️ |
| Benne (transport) | ✅ | ✅ `vehicle:benne` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |
| Silo avec capacité | ✅ | ✅ `Store in silo (capped)` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| HT | PA | ✅ implicite | ✅ |
| HVC | CV × taux × PA | ✅ | ✅ |
| Usure moissonneuse + benne | ✅ | ✅ | ✅ |

### Formule de rendement (9 facteurs — PHASE1_CULTURES.md)
1. Base régionale (T/ha)
2. Qualité sol (0.70-1.00)
3. Nutriments (0.50-1.00)
4. Engrais (1.00-1.10)
5. Traitements (0.857-1.00)
6. Météo (0.50-1.00)
7. Rouleau (+3-5% céréales)
8. Pierres (0.95-1.00)
9. Semence (1.00-1.10)

### Manques
- **M14** : Le registry ne distingue pas le matériel de récolte par culture. SimAgri exige : moissonneuse (céréales, colza, tournesol, pois, maïs grain), ensileuse (maïs ensilé, sorgho), arracheuse betterave, arracheuse PDT. → **Correction nécessaire** dans F041.
- **M15** : La paille au sol après récolte (céréales, pois) n'est pas mentionnée dans F041. PHASE1_CULTURES.md le prévoit. → **Correction mineure**.
- **M16** : L'auto-vente de l'excédent si silo plein est mentionnée dans F041 mais pas détaillée. → **OK**, acceptable.

---

## 12. Presser paille / Broyer paille (MANQUANT — à créer)

### Analyse SimAgri
- Après récolte céréales/pois : paille au sol
- Option 1 : Presser (tracteur + presse) → balles stockables/vendables
- Option 2 : Broyer (tracteur + broyeur) → restitution nutriments au sol
- Types de balles : carrée 500kg, carrée 250kg, ronde 300kg
- Pressage exporte des nutriments du sol

### Statut registry
- **❌ ABSENT du registry**. PHASE1_CULTURES.md Feature 13 le prévoit en détail.
- → **Flows F059 (Presser paille) et F060 (Broyer paille) à créer**

---

## 13. Vendre récolte (F042)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F042 | ✅/❌ |
|---------|---------|---------------|-------|
| Stock en silo | ✅ | ✅ `stock:recolte` | ✅ |
| Tracteur | ✅ | ✅ `vehicle:tractor` | ✅ |
| Benne | ✅ | ✅ `vehicle:benne` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| HT | PA | ✅ | ✅ |
| HVC | ✅ | ✅ | ✅ |
| Transport (distance) | ✅ | ✅ `backend_calculate_transport` | ✅ |
| Usure tracteur + benne | ✅ | ✅ | ✅ |

### Manques
- **M17** : SimAgri a un système de qualité (1-3) qui influence le prix de vente. Le registry F042 ne mentionne pas la qualité. → **Correction mineure**, ajouter `quality` dans le body.

---

## 14. Commander ETA (F046)

### Prérequis
| Critère | SimAgri | Registry F046 | ✅/❌ |
|---------|---------|---------------|-------|
| Parcelle possédée | ✅ | ✅ `parcel` | ✅ |
| Solde suffisant | ✅ prix fixé par ETA | ✅ `balance -= cost` | ✅ |
| HT | ✅ | ✅ `ht -= 1.0` | ✅ |

### Manques
- **M18** : SimAgri : les ETA sont gérées par des joueurs avec des prix variables. Le registry modélise une ETA PNJ (Cultivia). → **OK, choix de design Phase 1**. ETA joueur en Phase 3+.
- **M19** : Le registry ne liste pas les types de travaux ETA disponibles. SimAgri permet tous les travaux parcelle via ETA. → **Correction mineure**, ajouter la liste des `work_type` possibles.

---

## Flows manquants — Récapitulatif

| ID proposé | Nom | Sprint | Priorité | Justification SimAgri |
|------------|-----|--------|----------|----------------------|
| F054 | Rouler une parcelle | 10 | Haute | +3-5% rendement céréales/herbe, dans PHASE1_CULTURES.md |
| F055 | Épandre fumier sur parcelle | 11 | Haute | 25T/ha, apports NPKCaMgS, dans PHASE1_CULTURES.md F14 |
| F056 | Épandre lisier sur parcelle | 11 | Moyenne | 15m³/ha, apports NPKCaMgS, SimAgri |
| F057 | Forer une parcelle | 11 | Moyenne | 150€, source niveau 1-10, prérequis irrigation |
| F058 | Irriguer une parcelle | 11 | Haute | Enrouleur/pivot, impact jauge eau, SimAgri |
| F059 | Presser paille | 11 | Haute | Tracteur + presse, balles stockables, PHASE1_CULTURES.md F13 |
| F060 | Broyer paille | 11 | Moyenne | Tracteur + broyeur, restitution nutriments, PHASE1_CULTURES.md F13 |

---

## Corrections sur flows existants

### F037 — Préparer sol
1. Remplacer `vehicle:outil_sol` par des requires spécifiques selon le type :
   - `type=stubble` → `vehicle:cultivateur|dechaumeur`
   - `type=plow` → `vehicle:charrue`
   - `type=harrow` → `vehicle:herse_rotative`
2. Ajouter le concept de technique culturale (Traditionnelle/TCS/Semis Direct) — au minimum un champ `technique` dans le body

### F038 — Semer
1. Distinguer `vehicle:semoir` et `vehicle:semoir_mb` (maïs/betterave)
2. Ajouter `seed_quality: standard|certified` dans le body (déjà dans PHASE1_CULTURES.md)

### F039 — Épandre engrais
1. Préciser que c'est l'engrais chimique uniquement
2. Ajouter le nombre de passages possibles (1-2 selon culture)

### F040 — Traiter
1. Ajouter `treatment_type: fongicide|herbicide|insecticide` dans le body (déjà présent)
2. ✅ OK globalement

### F041 — Récolter
1. Distinguer le matériel par culture : `vehicle:moissonneuse` (céréales), `vehicle:ensileuse` (ensilage), `vehicle:arracheuse_betterave` (betterave)
2. Ajouter la production de paille au sol (céréales/pois) dans la chain
3. Ajouter `fatigue_index` update dans la chain

### F042 — Vendre récolte
1. Ajouter `quality: 1|2|3` dans le body
2. Ajouter le facteur qualité dans le calcul du prix

### F046 — Commander ETA
1. Lister les `work_type` possibles : `stubble|plow|harrow|sow|fertilize|treat|harvest|roll|press|mulch`

---

## Tableau comparatif des outils par étape

| Étape | Outil SimAgri | Registry actuel | Correction |
|-------|---------------|-----------------|------------|
| Déchaumer | Cultivateur OU Déchaumeur | `outil_sol` (générique) | → `cultivateur\|dechaumeur` |
| Labourer | Charrue | `outil_sol` | → `charrue` |
| Herser | Herse rotative | `outil_sol` | → `herse_rotative` |
| Semer céréales | Semoir classique | `semoir` | ✅ OK |
| Semer maïs/betterave | Semoir M/B | `semoir` | → `semoir_mb` |
| Rouler | Rouleau | ABSENT | → Créer F054 |
| Épandre engrais | Épandeur à engrais | `epandeur_engrais` | ✅ OK |
| Épandre fumier | Épandeur à fumier | ABSENT | → Créer F055 |
| Épandre lisier | Tonne à lisier | ABSENT | → Créer F056 |
| Traiter | Pulvérisateur | `pulverisateur` | ✅ OK |
| Irriguer | Enrouleur / Pivot | ABSENT | → Créer F058 |
| Récolter céréales | Moissonneuse-batteuse | `moissonneuse` | ✅ OK |
| Récolter maïs ensilé | Ensileuse | `moissonneuse` | → `ensileuse` |
| Récolter betterave | Arracheuse betterave | `moissonneuse` | → `arracheuse_betterave` |
| Presser paille | Presse (carrée/ronde) | ABSENT | → Créer F059 |
| Broyer paille | Broyeur | ABSENT | → Créer F060 |
| Transport récolte | Benne | `benne` | ✅ OK |

---

## Éléments SimAgri non retenus pour le MVP (choix de design)

| Élément | Raison |
|---------|--------|
| GPS (guidage satellite) | Complexité excessive, Phase 4+ |
| Combinés (multi-outils) | Phase 3+ |
| Maniabilité (bonus/malus taille parcelle) | Phase 2+ |
| Concessionnaires joueurs | Phase 3+ (économie) |
| Achat matériel en commun | Phase 4+ (social) |
| Cultures arboricoles | Phase 4+ |
| Engrais verts / CIPAN | Phase 2+ |
| Culture BIO | Phase 2+ |
| Compostage | Phase 2+ |
| Filière pomme de terre | Phase 3+ |
| Céréale immature (ensilage) | Phase 2+ |
| Quotas betterave | Phase 2+ |
| Herse de prairie | Phase 2+ (prés) |

---

## Conclusion

Le registry couvre bien le squelette de la boucle cultures (F035-F042, F046) mais présente 7 flows manquants et 9 corrections à apporter. Les manques les plus critiques sont :

1. **Roulage** (F054) — bonus rendement +3-5%, déjà dans PHASE1_CULTURES.md
2. **Épandage fumier/lisier** (F055/F056) — engrais organiques essentiels
3. **Irrigation** (F057/F058) — impact direct sur le rendement
4. **Pressage/broyage paille** (F059/F060) — déjà dans PHASE1_CULTURES.md Feature 13

Les corrections sur F037 (outils spécifiques) et F041 (matériel par culture) sont prioritaires pour la cohérence avec SimAgri.
