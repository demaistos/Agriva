# Agriva — Roadmap & Phases de Développement

> Date : 2026-08-03
> Statut : Draft
> Source : Inventaire des 119 sous-systèmes SimAgri

---

## 1. Cartographie des dépendances

### Couche 0 — Fondations (tout dépend de ça)

```
┌─────────────────────────────────────────────────────────────┐
│  Auth / Joueur / Serveurs / Temporalité / HT / Géographie   │
│  Économie (balance, transactions, banque)                    │
│  Worker (ticks)                                              │
│  Transport (base)                                            │
└─────────────────────────────────────────────────────────────┘
```

Sans ces systèmes, RIEN ne fonctionne. C'est le squelette.

### Couche 1 — Terrain de jeu

```
┌─────────────────────────────────────────────────────────────┐
│  Parcelles / Sols / Météo / Bâtiments (base) / Stockage     │
│  Matériel (catalogue + usure + HVC)                          │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 0
```

C'est l'infrastructure physique de la ferme.

### Couche 2A — Production végétale

```
┌─────────────────────────────────────────────────────────────┐
│  Cultures actives / Rendement / Techniques / Rotation         │
│  Récolte / Paille / Engrais verts                            │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 0 + 1
```

### Couche 2B — Production animale

```
┌─────────────────────────────────────────────────────────────┐
│  Animaux / Lots / Alimentation / Litière / Reproduction      │
│  Lait / Œufs / Pâturage / Abattoir                          │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 0 + 1
         ↑ dépend partiellement de Couche 2A (foin, ensilage, paille)
```

### Couche 3 — Commerce & Multijoueur

```
┌─────────────────────────────────────────────────────────────┐
│  Marché joueurs (annonces) / Coopérative (bot) / Prix dyn.   │
│  Social (amis, messagerie) / Classements                     │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 0 + productions
```

### Couche 4 — Spécialisations

```
┌─────────────────────────────────────────────────────────────┐
│  Génétique / Labels BIO / Arboriculture / Irrigation         │
│  Haies / Compostage / Filière PDT / Céréale immature         │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 2A et/ou 2B
```

### Couche 5 — Métiers & Transformations

```
┌─────────────────────────────────────────────────────────────┐
│  Concessionnaire / Transporteur / ETA / CIA                   │
│  Fromagerie / Maraîchage / Méthanisation / CAR               │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de Couche 3 + 4
```

### Couche 6 — Endgame & Profondeur

```
┌─────────────────────────────────────────────────────────────┐
│  Viticulture / Foresterie / Foie gras                         │
│  Concours / Salons / Challenges / CFSA avancé                │
│  Monétisation complète                                        │
└─────────────────────────────────────────────────────────────┘
         ↑ dépend de tout le reste
```

---

## 2. Graphe de dépendances critiques

```
Auth ─→ Joueur ─→ Exploitation
                      │
    ┌─────────────────┼──────────────────┐
    ↓                 ↓                  ↓
Temporalité        Géographie         Économie
    │                 │                  │
    ↓                 ↓                  ↓
 Worker ──────→ Météo ←────────── Prix dynamiques
    │              │
    ├──→ Parcelles + Sol
    │         │
    ├──→ Bâtiments + Stockage
    │         │
    ├──→ Matériel + HVC + Usure
    │         │
    │    ┌────┴────┐
    │    ↓         ↓
    │ CULTURES   ÉLEVAGE
    │    │         │
    │    ├─ Paille →┘ (litière)
    │    ├─ Foin ──→┘ (alimentation)
    │    │         │
    │    ↓         ↓
    │  Récolte   Lait/Œufs/Viande
    │    │         │
    │    └────┬────┘
    │         ↓
    │     MARCHÉ (vente)
    │         │
    │    ┌────┴────┐
    │    ↓         ↓
    │ Commerce   Transformations
    │ Joueurs    (fromagerie, viti...)
    │    │
    │    ↓
    │ Métiers annexes
    │ (concess., transport, CIA, CAR)
    │    │
    │    ↓
    │ Social avancé
    │ (concours, salons, CFSA)
    ↓
 TICKS quotidiens animent TOUT
```

---

## 3. Découpage en phases

### Phase 1 — Le Squelette (fondations techniques)
**Objectif** : infrastructure technique + un joueur peut se connecter et voir sa ferme vide.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Auth | Inscription, connexion JWT, sessions | Simple |
| Joueur | Création exploitation, profil, budget initial | Moyenne |
| Serveurs | Config serveur unique (France), difficulté | Moyenne |
| Géographie | Régions, départements, communes | Moyenne |
| Temporalité | Tick journalier, calendrier, saisons | Complexe |
| Worker | Système de ticks | Complexe |
| HT / Heures | Consommation, régénération quotidienne | Moyenne |
| Économie base | Balance, transactions, journal financier | Moyenne |
| Protection hors-ligne | Gel des jauges si absent | Simple |
| UX globale | Navigation, modales, DataTable | Moyenne |

**Livrable** : un joueur se connecte, voit un dashboard avec sa ferme (vide), le temps avance, il a un solde.

---

### Phase 2 — La Terre (parcelles + météo + bâtiments + matériel)
**Objectif** : un joueur peut acheter une parcelle, construire un hangar, acheter un tracteur. La météo tourne.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Parcelles | Achat, qualité sol, types | Moyenne |
| Sol | 6 éléments, analyse, apports | Complexe |
| Météo | Génération, prévisions, zones, impacts | Complexe |
| Bâtiments | Catalogue, construction, niveaux, usure, énergie, stockage | Complexe |
| Matériel | Catalogue (tracteurs + outils de base), achat, usure, HVC, pannes, pièces | Complexe |
| Transport base | Attelage, trajets, remorques | Complexe |
| Charges auto | Salaires, électricité | Moyenne |

**Livrable** : la ferme a un terrain, des bâtiments, du matériel. La météo change. Les charges tombent.

---

### Phase 3 — Les Cultures (le cœur du jeu)
**Objectif** : un joueur peut semer, faire pousser, et récolter. C'est jouable.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Cultures actives | Semis → croissance → récolte, jauges eau/soleil | Très complexe |
| Rendement | Tous les multiplicateurs | Très complexe |
| Techniques culturales | Traditionnelle, TCS, semis direct | Simple |
| Rotation | Historique, vérification | Moyenne |
| Coopérative (bot) | Achat intrants, vente récoltes | Complexe |
| Stockage | Silos, qualité, pertes | Complexe |
| Engrais/Fumure | Épandage, impact sol | Moyenne |
| Traitements | Phyto (fongicide, herbicide, insecticide) | Moyenne |
| Paille | Broyage ou stockage post-récolte | Simple |

**Livrable** : BOUCLE JOUABLE COMPLÈTE — semer, faire pousser, récolter, vendre, racheter des intrants, recommencer. Le jeu a un sens.

---

### Phase 4 — L'Élevage (base)
**Objectif** : un joueur peut acheter des animaux, les nourrir, les traire, vendre le lait.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Animaux / Lots | Catalogue races (bovins, porcins, volailles, ovins), stades | Très complexe |
| Alimentation | Rations, consommation auto, pénalités | Complexe |
| Litière & Fumier | Paille → fumier, caillebotis → lisier | Moyenne |
| Production lait | Traite, cuve, qualité | Complexe |
| Production œufs | Collecte, conditionnement, calibres | Complexe |
| Reproduction (base) | Monte naturelle, naissances | Complexe |
| Pâturage | Mise au pré, dates, surface | Complexe |
| Abattoir | Vente viande | Moyenne |
| Enclos d'attente | Stockage temporaire avec pénalités | Moyenne |

**Livrable** : deux activités principales fonctionnent (cultures + élevage). Un joueur peut se spécialiser.

---

### Phase 5 — Le Multijoueur & Commerce
**Objectif** : les joueurs peuvent commercer entre eux.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Prix dynamiques | Offre/demande, variation, historique | Complexe |
| Marché joueurs | Annonces, filtres, achat/vente | Moyenne |
| Annonces animaux | Vente entre joueurs | Moyenne |
| Social base | Amis, amis privilégiés | Simple |
| Messagerie | MP asynchrone + MP-Live (WebSocket) | Moyenne |
| Classements | Richesse, surface, production | Moyenne |
| Profil joueur | Fiche, stats publiques, disponibilité | Moyenne |
| Employés | Embauche, HT additionnels, salaires | Simple |
| Banque | Épargne, emprunts (simplifié, sans CAR) | Moyenne |

**Livrable** : le jeu est MULTIJOUEUR. Les joueurs interagissent, échangent, se comparent.

---

### Phase 6 — Spécialisations végétales
**Objectif** : profondeur supplémentaire sur les cultures.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Irrigation | Forage, enrouleur, pivot, retenue collinaire | Moyenne |
| Arboriculture | Vergers, 11 espèces, taille, récolte | Très complexe |
| Haies | Plantation, taille, bois déchiqueté | Moyenne |
| Filière PDT | Stockage, propositions vente | Complexe |
| Céréale immature | Ensilage précoce | Moyenne |
| Compostage | Fumier → compost | Moyenne |
| Engrais verts / CIPAN | Moutarde, phacélie... | Simple |
| Quotas | Betterave, tabac | Simple |
| Culture BIO | Conversion, contraintes, prix | Moyenne |
| Écume de sucrerie | Amendement calcique | Simple |

**Livrable** : la partie cultures est aussi riche que SimAgri.

---

### Phase 7 — Spécialisations animales
**Objectif** : profondeur supplémentaire sur l'élevage.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Génétique | 14 indices, croisements, valorisation, OG | Très complexe |
| Insémination (IA) | Doses, CIA simplifié, catalogues | Complexe |
| Labels élevage | Bio, Label Rouge, plein-air | Complexe |
| IVRAD | Sélection, accouplement raisonné | Complexe |
| Espèces supplémentaires | Caprins, lapins, chevaux, bisons, daims, oies, canards, pintades | Complexe |
| Vaccinations | Prévention maladies | Simple |
| Robot alimentation | Automatisation | Moyenne |
| Chien de troupeau | Réduction HT | Simple |
| Allaitement | Mères nourrissent petits | Simple |
| Négociant en bestiaux | Intermédiaire | Simple |

**Livrable** : la partie élevage est aussi riche que SimAgri.

---

### Phase 8 — Métiers & Transformations
**Objectif** : les joueurs peuvent exercer des métiers secondaires.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| ETA | Services aux autres joueurs | Moyenne |
| Concessionnaire | Hall, atelier, GPS, pièces, licences | Très complexe |
| Transporteur | Camions, chauffeurs, commandes | Complexe |
| CIA (complet) | Centre, reproducteurs, prélèvements, contrats | Complexe |
| Fromagerie | Fabrication, affinage, DLC, vente marchés | Très complexe |
| Maraîchage | Serres, chauffage, légumes, marchés | Complexe |
| Méthanisation (ferme) | Digesteur, substrats, biogaz, digestat | Complexe |

**Livrable** : diversification possible. Un joueur n'est plus seulement agriculteur.

---

### Phase 9 — Coopératives & Social avancé
**Objectif** : le jeu social complet.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| CAR | Structure multi-joueurs, parts sociales, sous-activités | Très complexe |
| CAR Huilerie | Colza → huile → HVC | Complexe |
| CAR Sucrerie | Betterave → sucre + écume | Complexe |
| CAR Laiterie | Collecte + transformation | Complexe |
| CAR Méthanisation | Version coopérative | Complexe |
| Forum | Catégories, topics, posts | Moyenne |
| CFSA | Mentorat complet | Moyenne |
| CESA | Régulation économique | Moyenne |
| Badges | Accomplissements | Moyenne |
| Challenges | Défis temporaires | Complexe |
| Sondages | Votes communautaires | Simple |
| Concours animaux | GénétiSim, scoring | Complexe |

**Livrable** : vie communautaire et coopérative complète.

---

### Phase 10 — Endgame & Contenus avancés
**Objectif** : les derniers systèmes à forte valeur ajoutée.

| Système | Sous-systèmes | Complexité |
|---------|---------------|:---:|
| Viticulture | Domaine, cépages, vinification, assemblage, concours | Très complexe |
| Foresterie | Forêt, ETF, vente bois | Complexe |
| Foie gras | Élevage → gavage → commercialisation | Complexe |
| GPS complet | Réseau balises, gains | Complexe |
| Combinés matériel | Attelages multiples | Moyenne |
| Matériel spécialisé | Arboricole, forestier, viticole, maraîcher | Moyenne |
| Salons/Événements | GénétiSim, VitiSim, GénétiVRAD | Moyenne |
| Serveurs supplémentaires | Belgique, Suisse, Canada, USA, Expert | Moyenne |
| Monétisation | SimPass, packs, parrainage | Simple |

**Livrable** : couverture complète de SimAgri.

---

## 4. Résumé des phases

| Phase | Nom | Systèmes | Ce que le joueur peut faire |
|:---:|------|:---:|------|
| 1 | Le Squelette | 10 | Se connecter, voir sa ferme vide |
| 2 | La Terre | 7 | Acheter terrain + bâtiment + matériel |
| 3 | Les Cultures | 9 | **Semer → Récolter → Vendre (BOUCLE JOUABLE)** |
| 4 | L'Élevage | 9 | Acheter/nourrir/produire lait/viande |
| 5 | Le Multijoueur | 9 | Commercer, se comparer, communiquer |
| 6 | Spé. Végétales | 10 | Vergers, irrigation, bio, haies... |
| 7 | Spé. Animales | 10 | Génétique, labels, espèces complètes |
| 8 | Métiers | 7 | Concessionnaire, fromagerie, ETA... |
| 9 | Social & Coops | 12 | CAR, concours, CFSA, forum... |
| 10 | Endgame | 9 | Viticulture, foresterie, serveurs... |
| | **TOTAL** | **92 groupes** | **Couverture complète SimAgri** |

---

## 5. Estimation de complexité par phase

| Phase | Complexité relative | Estimation (sprints de 2 semaines) |
|:---:|---|:---:|
| 1 | 🟢 Fondations classiques | 3-4 sprints |
| 2 | 🟡 Systèmes interconnectés | 4-5 sprints |
| 3 | 🔴 Cœur de la simulation | 5-7 sprints |
| 4 | 🔴 Deuxième système majeur | 5-7 sprints |
| 5 | 🟡 Intégration multijoueur | 3-4 sprints |
| 6 | 🟡 Extensions paramétriques | 4-5 sprints |
| 7 | 🟡 Extensions paramétriques | 4-5 sprints |
| 8 | 🔴 Systèmes autonomes complexes | 6-8 sprints |
| 9 | 🟡 Intégration sociale | 4-5 sprints |
| 10 | 🔴 Systèmes avancés | 5-7 sprints |
| | **TOTAL estimé** | **43-57 sprints (~1.5-2 ans)** |

---

## 6. Jalons clés (milestones)

| Milestone | Après phase | Signification |
|-----------|:---:|------|
| **Prototype fonctionnel** | 3 | Le jeu est jouable (boucle culture complète) |
| **Alpha** | 5 | Multijoueur + 2 activités principales |
| **Beta** | 7 | Contenu riche, spécialisations |
| **Release candidate** | 9 | Social complet, prêt pour communauté |
| **V1 complète** | 10 | Parité SimAgri atteinte |

---

## 7. Risques et mitigations

| Risque | Impact | Mitigation |
|--------|--------|-----------|
| Scope creep (119 systèmes c'est massif) | Élevé | Phases strictes, pas de saut entre phases |
| Dettes techniques accumulées | Élevé | TDD + refactoring intégré à chaque phase |
| Équilibrage économie | Moyen | Simulation/tests avant mise en production |
| Performances (ticks avec beaucoup de joueurs) | Moyen | Architecture optimisée dès Phase 1 (worker) |
| Motivation long-terme (projet >1 an) | Moyen | Chaque phase produit un jeu jouable |
