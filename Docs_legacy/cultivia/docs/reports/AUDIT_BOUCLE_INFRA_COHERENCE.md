# 🏗️ Audit Boucle Infrastructure & Cohérence Globale

**Date** : 2026-04-06
**Auteur** : Expert Infrastructure & Cohérence Globale IA
**Sources** : `docs/00-reference/regle sim.txt`, `docs/03-specs/ACTION_FLOW_REGISTRY.yaml`, `docs/03-specs/phases/PHASE0_INFRASTRUCTURE.md`, `docs/03-specs/phases/PHASE1_CULTURES.md`, `docs/02-architecture/08_EQUILIBRAGE_ECONOMIQUE.md`

---

## Synthèse

| Métrique | Valeur |
|----------|--------|
| Flows analysés | 68 |
| Boucles de gameplay vérifiées | 5 (infra, élevage, cultures, économie, information) |
| Manques critiques (bloquants) | 7 |
| Manques importants (gameplay incomplet) | 6 |
| Corrections mineures | 5 |
| Flows à créer | 8 |

---

## 1. Boucle Infrastructure — F001 est-il suffisant ?

### 1.1 Ce que couvre F001

F001 = « Construire un bâtiment ». Il gère :
- ✅ Vérification solde + HT
- ✅ Déduction balance + HT
- ✅ Insertion building + capacity (si housing)
- ✅ Ledger, WS, toast, redirect

### 1.2 Ce qui manque dans le registry

La logique métier dans `PHASE1_CULTURES.md` §3.3 définit 4 opérations sur les bâtiments :

| Action | Logique métier | Flow registry | Statut |
|--------|---------------|---------------|--------|
| Construire | `buildBuilding()` | F001 ✅ | OK |
| Améliorer (niveau 1→5) | `upgradeBuilding()` | ❌ AUCUN | **MANQUE CRITIQUE** |
| Détruire | `destroyBuilding()` | ❌ AUCUN | **MANQUE CRITIQUE** |
| Entretenir (mensuel) | `processMonthlyBuildingMaintenance()` | ❌ AUCUN (tick F067 partiel) | **MANQUE** |

**SimAgri confirme** : « Vous pouvez agrandir et faire évoluer le niveau d'équipement d'un bâtiment déjà existant » + « Vous pouvez détruire un bâtiment. L'entreprise de démolition vous versera 10% du prix d'achat. »

### 1.3 Boucle complète attendue

```
Construire (F001) → Capacité → Usure mensuelle (tick) → Énergie mensuelle (F067)
     ↓                                    ↓
Améliorer (MANQUE)              Entretien auto (tick F067 partiel)
     ↓
Détruire (MANQUE) → Récupération 10%
```

### 1.4 Verdict

**F001 seul est insuffisant.** Il faut 2 flows supplémentaires :
- **F069** — Améliorer un bâtiment (niveau 2→5)
- **F070** — Détruire un bâtiment

L'entretien mensuel et l'usure sont déjà dans le tick F067 (`worker_process_energy`), mais l'usure bâtiment (+0.5%/mois) n'est pas explicitement listée dans F067. → Correction F067.

---

## 2. Cohérence des dépendances croisées

### 2.1 Chaîne « Nourrir des animaux »

```
Nourrir (F008) → nécessite stock aliments
  ↑
Acheter aliments (F006) → nécessite silo avec place + tractor + benne + HVC
  ↑
Construire silo (F001) → nécessite balance
  ↑
Acheter HVC (F068) → nécessite cuve HVC
  ↑
Construire cuve HVC (F001) → nécessite balance
```

| Étape | Flow | Sprint | Dépendance vérifiée |
|-------|------|--------|---------------------|
| Construire cuve HVC | F001 | 3 | ✅ balance + HT |
| Acheter HVC | F068 | 4 | ✅ depends_on F001, requires infra:cuve_hvc |
| Construire silo | F001 | 3 | ✅ |
| Acheter aliments | F006 | 4 | ✅ depends_on F001, requires building:silo + vehicle:tractor + vehicle:benne + fuel:hvc |
| Nourrir | F008 | 4 | ✅ depends_on F002 + F006 |

**Verdict : chaîne cohérente ✅** — Mais le kit Éleveur inclut déjà un silo 10T et une citerne eau 10 000L, donc le joueur n'est pas bloqué au sprint 3.

### 2.2 Chaîne « Traire → Vendre lait »

```
Traire (F023) → nécessite salle de traite + cuve lait + vaches lactantes
  ↑
Naissance (F020) → nécessite gestation
  ↑
Inséminer (F018/F019) → nécessite mâle ou CIA
  ↑
Acheter animal (F002) → nécessite bâtiment + bétaillère + HVC
```

| Étape | Flow | Sprint | OK |
|-------|------|--------|-----|
| Acheter animal | F002 | 3 | ✅ |
| Inséminer | F018 | 6 | ✅ |
| Naissance | F020 | 6 | ✅ |
| Traire | F023 | 7 | ✅ |
| Vendre lait | F024 | 7 | ⚠️ requires vehicle:citerne_lait — **pas dans le kit Éleveur** |

**Manque M1** : Le kit Éleveur n'inclut pas de citerne à lait (véhicule). Le joueur devra acheter une citerne à lait pour vendre son lait. Ce n'est pas bloquant (il peut stocker) mais c'est un piège pour le débutant. → Documenter dans le guide joueur ou ajouter au kit.

### 2.3 Chaîne « Cultures complète »

```
Acheter parcelle (F035) → Préparer sol (F037) → Semer (F038) → Traiter (F040)
→ Épandre (F039) → Récolter (F041) → Presser/Broyer paille (F059/F060)
→ Vendre récolte (F042)
```

**Verdict : chaîne cohérente ✅** — Toutes les dépendances sont correctement modélisées.

### 2.4 Chaîne « Fumier → Compost → Épandage »

```
Litière (F015) → Fumier s'accumule (F052) → Retirer fumier (F016) → Fosse
→ Épandre fumier (F055) sur parcelle
```

**Manque M2** : SimAgri a un système de **compostage** (fumier → compost en 14 jours → épandage). Le registry n'a aucun flow de compostage. C'est une feature Phase 2+ mais elle devrait être documentée comme manque planifié.

---

## 3. Flows d'information — Suffisants ?

### 3.1 Analyse des flows readonly

| Flow | Contenu | Sprint | Suffisant ? |
|------|---------|--------|-------------|
| F003 | Liste animaux + dashboard élevage | 3 | ✅ |
| F004 | Fiche animal détaillée | 3 | ✅ |
| F022 | Arbre généalogique | 6 | ✅ |
| F026 | Cours du marché | 7 | ✅ |
| F030 | Météo | 8 | ✅ |
| F031 | Dashboard complet | 9 | ⚠️ Sprint 9 = trop tard |

### 3.2 Manques

**Manque M3 — Dashboard trop tardif** : F031 (dashboard complet) est au sprint 9. Le joueur n'a aucune vue d'ensemble avant ça. Le sprint 3 a F003 (dashboard élevage) mais pas de dashboard global.

**Recommandation** : Avancer F031 au sprint 3-4 avec un contenu progressif (widgets ajoutés au fur et à mesure des sprints).

**Manque M4 — Pas de flow « Voir mes bâtiments »** : Il n'y a pas de flow de navigation pour `/buildings` (liste des bâtiments avec capacité, usure, remplissage). Le joueur construit (F001) mais ne peut pas consulter l'état de ses bâtiments via un flow documenté.

**Manque M5 — Pas de flow « Voir mon matériel »** : Idem pour `/equipment` — pas de flow de navigation pour voir la liste du matériel, l'usure, les pannes. F043 (acheter) et F044 (entretenir) existent mais pas la consultation.

**Manque M6 — Pas de flow « Voir mes finances »** : Pas de flow pour `/finances` (historique ledger, solde, prêts, épargne). F032/F033 existent pour souscrire mais pas pour consulter.

---

## 4. Manques systémiques — Actions sans flow

### 4.1 Actions présentes dans SimAgri mais absentes du registry

| Action | SimAgri | Registry | Priorité | Sprint suggéré |
|--------|---------|----------|----------|----------------|
| **Négociant en bestiaux** | 1×/mois, animaux adultes, 4 races, non revendables entre joueurs | ❌ AUCUN | **Haute** (source alternative d'animaux) | 7 |
| **Vendre animal entre joueurs** | Vente privée entre joueurs | ❌ AUCUN (F064 = matériel seulement) | **Haute** (économie P2P) | 15 |
| **Acheter matériel occasion** | Dépôt-vente, annonces, négociation | ❌ AUCUN (F043 = neuf seulement) | **Moyenne** | 15 |
| **Louer matériel** | Location tracteur si panne, location moissonneuse/ensileuse | ❌ AUCUN | **Moyenne** (filet de sécurité panne) | 15+ |
| **Compostage** | Fumier → compost (14j) → épandage | ❌ AUCUN | **Basse** (Phase 3+) | 16+ |
| **Améliorer bâtiment** | Agrandir + monter niveau | ❌ AUCUN | **Critique** | 4 |
| **Détruire bâtiment** | Démolition → 10% récupéré | ❌ AUCUN | **Critique** | 4 |
| **Acheter HVC à la CAR** | Prix 0.36-0.55€/L (vs 0.60€ Coop) | ❌ (F068 = Coop seulement) | **Basse** (Phase 3) | 13+ |

### 4.2 Flows à créer

| ID proposé | Nom | Sprint | Priorité |
|------------|-----|--------|----------|
| **F069** | Améliorer un bâtiment | 4 | CRITIQUE |
| **F070** | Détruire un bâtiment | 4 | CRITIQUE |
| **F071** | Appeler le négociant en bestiaux | 7 | HAUTE |
| **F072** | Voir liste bâtiments | 3 | HAUTE |
| **F073** | Voir liste matériel | 3 | HAUTE |
| **F074** | Voir finances (ledger) | 3 | HAUTE |
| **F075** | Vendre animal entre joueurs | 15 | MOYENNE |
| **F076** | Acheter matériel occasion (entre joueurs) | 15 | MOYENNE |

---

## 5. Onboarding — Le joueur peut-il jouer dès le sprint 3 ?

### 5.1 Kit Éleveur au sprint 3

Le kit Éleveur fournit :
- Tracteur 80CV, bétaillère, épandeur fumier, pailleuse, désileuse, faucheuse
- Stabulation 100m², salle traite 4 postes, cuve lait 500L, citerne eau 10 000L, silo 10T, fosse fumier 20T, hangar 50m²
- 4 vaches Montbéliarde + 1 taureau
- 100 000€ de solde

**Actions possibles au sprint 3 :**

| Action | Flow | Possible ? | Bloquant ? |
|--------|------|-----------|------------|
| Voir ses animaux | F003 | ✅ | — |
| Voir fiche animal | F004 | ✅ | — |
| Renommer animal | F005 | ✅ | — |
| Construire bâtiment | F001 | ✅ | — |
| Acheter animal | F002 | ✅ (a bétaillère + tracteur) | — |

**Actions NON possibles au sprint 3 (sprint 4+) :**

| Action | Flow | Sprint | Impact |
|--------|------|--------|--------|
| Nourrir | F008 | 4 | ⚠️ **BLOQUANT** — les animaux ne mangent pas pendant tout le sprint 3 |
| Abreuver | F009 | 4 | ⚠️ **BLOQUANT** — les animaux ne boivent pas pendant tout le sprint 3 |
| Acheter aliments | F006 | 4 | Dépendance de F008 |
| Remplir cuve eau | F007 | 4 | Dépendance de F009 |
| Acheter HVC | F068 | 4 | ⚠️ Pas de carburant = pas de transport |

### 5.2 Problème critique : le tick santé (F011) est au sprint 4

F011 (tick santé — animaux non nourris tombent malades) est au sprint 4. Donc au sprint 3, les animaux ne peuvent ni être nourris ni tomber malades. C'est cohérent en termes de code, mais **le joueur a des animaux qu'il ne peut pas nourrir pendant un sprint entier**.

**Deux solutions :**
1. **Accepter** : au sprint 3, les animaux sont « en mode démo » — pas de nourrissage, pas de maladie. Le joueur peut les voir, les renommer, en acheter d'autres. Le gameplay réel commence au sprint 4.
2. **Avancer F006/F007/F008/F009/F068 au sprint 3** : le joueur peut nourrir/abreuver dès le début. Plus réaliste mais plus de travail.

**Recommandation** : La solution 1 est acceptable si le joueur est clairement informé (tutoriel/notification : « Vos animaux sont en bonne santé. Le nourrissage sera disponible prochainement. »). La solution 2 est préférable pour l'immersion.

### 5.3 Kit Cultivateur au sprint 3

Le kit Cultivateur n'a pas d'animaux. Au sprint 3, il peut :
- Construire des bâtiments (F001)
- C'est tout — les cultures commencent au sprint 10

**Problème** : Le joueur Cultivateur n'a rien à faire au sprint 3 sauf construire des bâtiments. Les parcelles (F035) sont au sprint 10. C'est un **désert de gameplay de 7 sprints**.

**Recommandation** : Ce n'est pas un problème du registry mais du planning. Le kit Cultivateur devrait être activé quand les cultures sont disponibles, ou le joueur devrait avoir des activités intermédiaires (marché, finances, exploration).

### 5.4 Kit Polyvalent au sprint 3

Même situation que l'Éleveur (2 vaches, pas de nourrissage) + même problème que le Cultivateur (pas de cultures).

### 5.5 Résumé onboarding

| Kit | Sprint 3 jouable ? | Bloquants |
|-----|-------------------|-----------|
| Éleveur | ⚠️ Partiel — animaux non nourrissables | F006-F009 au sprint 4 |
| Cultivateur | ❌ Quasi-vide — rien à faire sauf construire | Cultures au sprint 10 |
| Polyvalent | ⚠️ Partiel — même problème que Éleveur | F006-F009 au sprint 4 |

---

## 6. Corrections à appliquer

### 6.1 Corrections au registry (YAML)

| # | Type | Cible | Correction |
|---|------|-------|------------|
| C1 | AJOUT | F069 | Améliorer un bâtiment (sprint 4) |
| C2 | AJOUT | F070 | Détruire un bâtiment (sprint 4) |
| C3 | AJOUT | F071 | Appeler le négociant en bestiaux (sprint 7) |
| C4 | AJOUT | F072 | Voir liste bâtiments (sprint 3) |
| C5 | AJOUT | F073 | Voir liste matériel (sprint 3) |
| C6 | AJOUT | F074 | Voir finances / ledger (sprint 3) |
| C7 | MODIF | F067 | Ajouter step `worker_process_building_wear` (+0.5%/mois) |
| C8 | MODIF | F031 | Avancer de sprint 9 → sprint 4 (version progressive) |
| C9 | MODIF | stats | Mettre à jour total_flows et by_sprint |

### 6.2 Corrections aux docs

| # | Fichier | Correction |
|---|---------|------------|
| D1 | PHASE1_CULTURES.md | Déjà documenté (upgradeBuilding, destroyBuilding) — OK |
| D2 | 08_EQUILIBRAGE_ECONOMIQUE.md | Ajouter note : kit Éleveur manque citerne_lait pour vendre |

---

## 7. Matrice de dépendances croisées complète

```
F001 (Construire) ──→ F069 (Améliorer) ──→ F070 (Détruire)
  │
  ├──→ F002 (Acheter animal) ──→ F008 (Nourrir) ──→ F011 (Tick santé)
  │         │                        │
  │         │                        └──→ F010 (Auto-feed)
  │         │
  │         ├──→ F018 (Inséminer) ──→ F020 (Naissance) ──→ F023 (Traire)
  │         │                                                    │
  │         └──→ F025 (Abattoir)                           F024 (Vendre lait)
  │
  ├──→ F006 (Acheter aliments) ──→ F008 (Nourrir)
  │
  ├──→ F007 (Remplir cuve eau) ──→ F009 (Abreuver)
  │
  ├──→ F068 (Acheter HVC) ──→ [tous les transports]
  │
  └──→ F072 (Voir bâtiments) [NOUVEAU]

F035 (Acheter parcelle) ──→ F037 (Préparer) ──→ F038 (Semer) ──→ F041 (Récolter)
                                                      │
                                                      └──→ F042 (Vendre récolte)

F043 (Acheter matériel) ──→ F044 (Entretenir) ──→ F045 (Réparer)
                       └──→ F073 (Voir matériel) [NOUVEAU]

F032 (Épargne) + F033 (Prêt) ──→ F074 (Voir finances) [NOUVEAU]
```
