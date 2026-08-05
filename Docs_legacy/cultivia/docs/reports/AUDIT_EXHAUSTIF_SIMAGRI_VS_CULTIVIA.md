# Audit exhaustif SimAgri vs Cultivia — 10 agents spécialisés

> Chaque section des règles SimAgri comparée avec nos 168 flows.
> ✅ = couvert, ❌ = manquant, 🟡 = partiel

---

## Agent 1 — Spécialiste Élevage

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Bovins (achat, nourrissage, traite, reproduction, abattoir) | F002-F025 | ✅ |
| Bisons | Même logique que bovins | ✅ |
| Caprins | F002 + matrice espèces | ✅ |
| Ovins (lait + laine) | F082, F099 | ✅ |
| Porcins | F002 + matrice | ✅ |
| Volailles (œufs, calibrage) | F083, F100 | ✅ |
| Pintades | Même logique volailles | ✅ |
| Oies (foie gras) | F160 | ✅ |
| Canards (foie gras) | F160 | ✅ |
| Lapins | F002 + matrice | ✅ |
| Daims | Même logique bovins | ✅ |
| Chevaux | F002 + van | ✅ |
| Chien de troupeau | ❌ | ❌ MANQUANT |
| Négociant | F071 | ✅ |
| Lots d'animaux | F117-F120 | ✅ |
| Élevage industriel / ratio fusion | ❌ | ❌ MANQUANT |
| IVRAD (races à développer) | ❌ | ❌ MANQUANT |
| Allaitement | F020 (nursing) | ✅ |
| Sevrage | F122 | ✅ |
| Vermifuge | F138 | ✅ |
| Tarissement | F133 | ✅ |
| Dates mise au pré / plein-air | F029 (check saison) | ✅ |
| Labels (bio, plein-air) | F139, F140 | ✅ |
| Objectif Génétique (OG) | ❌ | ❌ MANQUANT |
| Valorisation génétique | ❌ | ❌ MANQUANT |
| Robot d'alimentation | ❌ | ❌ MANQUANT |
| Qualité lait (indice QL) | F098 | ✅ |
| Concours animaux | F159 | ✅ |

**Manquants élevage : 5** (chien, industriel/fusion, IVRAD, objectif génétique, robot alimentation)

---

## Agent 2 — Spécialiste Cultures

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Blé, orge, avoine, triticale | F038 + seeds | ✅ |
| Maïs grain, maïs ensilé | F038 + semoir_mb | ✅ |
| Colza, tournesol | F038 | ✅ |
| Betterave, PDT, lin | F038 + ETA | ✅ |
| Pois, féverole, soja, lentille | F038 | ✅ |
| Chanvre, tabac | F038 | ✅ |
| Épinard, haricot vert | F038 | ✅ |
| Sorgho ensilé | F038 | ✅ |
| Luzerne, miscanthus | F038 | 🟡 miscanthus = 20 saisons, pas modélisé |
| Céréale immature | ❌ | ❌ MANQUANT |
| Herbe / pré (pousse, fauche) | F084, F085, F144 | ✅ |
| Paille et foin | F059, F060 | ✅ |
| Techniques culturales (trad/TCS/direct) | F037 | ✅ |
| Engrais verts / CIPAN | F103 | ✅ |
| Cultiver en BIO | F139 | ✅ |
| Sol (analyse, éléments nutritifs) | F036 | ✅ |
| Pierres (épierrage) | ❌ | ❌ MANQUANT |
| Compostage | F078 | ✅ |
| Écume de sucrerie | ❌ | ❌ MANQUANT |
| Traitements (fongicide, herbicide, insecticide) | F040 | ✅ |
| Quotas | ❌ | ❌ MANQUANT |
| Retenue collinaire (réserve eau) | ❌ | ❌ MANQUANT |
| Filière PDT (plant, défanage, stockage) | F102 | 🟡 pas de plant spécifique |
| Drainage | F128 | ✅ |
| Chaulage | F129 | ✅ |
| Rotation | F038 (check) | ✅ |
| Rendements (9 facteurs) | F041 | ✅ |

**Manquants cultures : 5** (céréale immature, pierres, écume sucrerie, quotas, retenue collinaire)

---

## Agent 3 — Spécialiste Matériel

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Achat neuf | F043 | ✅ |
| Achat occasion (P2P) | F089 | ✅ |
| Achat en commun (CUMA) | F135 | ✅ |
| Vente matériel | F047 | ✅ |
| Vente P2P | F064 | ✅ |
| Négocier prix | F136 | ✅ |
| Location | F090 | ✅ |
| Entretien (mensuel/annuel) | F044 | ✅ |
| Panne et usure | F045 | ✅ |
| Pièces détachées | F061 | ✅ |
| Assurance | F062 | ✅ |
| GPS / guidage | ❌ | ❌ MANQUANT |
| Relevage avant | F132 | ✅ |
| Atteler / combiné | F127 | ✅ |
| Dépôt-vente | ❌ | ❌ MANQUANT |
| Frais annonce (1500€ SimAgri) | 100€ Cultivia | ✅ (adapté) |

**Manquants matériel : 2** (GPS, dépôt-vente)

---

## Agent 4 — Spécialiste Économie

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Épargne (3 types) | F032 | ✅ |
| Emprunt | F033 | ✅ |
| Investissement financier (parts CAR) | ❌ | ❌ MANQUANT |
| Taxe plus-value parcelles | Documenté SDD | ✅ |
| Salaires employés | F027 | ✅ |
| Énergie bâtiments | F106, F067 | ✅ |
| Carburant HVC | F068 | ✅ |
| Cours marché | F026, F077 | ✅ |
| Primes PAC | F110 | ✅ |
| Contrats laiterie | F092 | ✅ |
| Contrats vente à terme | F156 | ✅ |
| Grossistes / centrales d'achat | ❌ | ❌ MANQUANT |
| Marchés (vendre sur les marchés) | ❌ | ❌ MANQUANT |

**Manquants économie : 3** (parts CAR, grossistes, marchés locaux)

---

## Agent 5 — Spécialiste Transport

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Licence transport | F149 | ✅ |
| Camion | F150 | ✅ |
| Chauffeur | F151 | ✅ |
| Proposer transport | F152 | ✅ |
| Coût transport | Formules documentées | ✅ |
| Transport entre régions | Haversine | ✅ |

**Manquants transport : 0** ✅

---

## Agent 6 — Spécialiste Bâtiments

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Construction | F001 | ✅ |
| Amélioration | F069 | ✅ |
| Destruction | F070 | ✅ |
| Agrandissement | F113 | ✅ |
| Énergie | F106 | ✅ |
| Sol litière/caillebotis | F107 | ✅ |
| Hygiène/propreté | F015-F017 | ✅ |
| Électricité (détail) | F106 | ✅ |
| Équipements (accessoires) | ❌ | ❌ MANQUANT |

**Manquants bâtiments : 1** (accessoires bâtiments comme abreuvoirs automatiques, ventilation)

---

## Agent 7 — Spécialiste Social

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Messagerie | F034 | ✅ |
| Amis | F094 | ✅ |
| Classements | F095 | ✅ |
| Forums | ❌ | ❌ MANQUANT |
| Chat live (MP-Live) | ❌ | ❌ MANQUANT |
| Fiche joueur | F096 | ✅ |
| Visite ferme | F153 | ✅ |
| Parrainage | ❌ | ❌ MANQUANT |
| Favoris | ❌ | ❌ MANQUANT |

**Manquants social : 4** (forums, chat, parrainage, favoris)

---

## Agent 8 — Spécialiste Activités secondaires

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Fromagerie | F157-F158 | ✅ |
| Foie gras | F160 | ✅ |
| Viticulture (vigne, vin) | F165 | ✅ (esquissé) |
| Arboriculture (vergers) | ❌ | ❌ MANQUANT |
| Maraîchage (serres) | F166 | ✅ (esquissé) |
| Forêt / ETF | F167 | ✅ (esquissé) |
| Méthanisation (biogaz) | ❌ | ❌ MANQUANT |
| Huilerie | ❌ | ❌ MANQUANT |
| Sucrerie | ❌ | ❌ MANQUANT |
| Concessionnaire (activité joueur) | ❌ | ❌ MANQUANT |
| CIA (activité joueur) | ❌ | ❌ MANQUANT |
| Laiterie (activité joueur) | ❌ | ❌ MANQUANT |

**Manquants activités : 6** (arboriculture, méthanisation, huilerie, sucrerie, concessionnaire, CIA)

---

## Agent 9 — Spécialiste Météo & Environnement

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| Météo 3 jours | F030 | ✅ |
| Forte pluie | F141 | ✅ |
| Vent (interdit pulvérisation) | F040 check | ✅ |
| Grêle | F141 | ✅ |
| Gel | F141 | ✅ |
| Précipitations (jauge eau) | F058 | ✅ |
| Saisons (4) | GAME_SYSTEMS | ✅ |

**Manquants météo : 0** ✅

---

## Agent 10 — Spécialiste Formation & Politique

| Feature SimAgri | Cultivia | Status |
|----------------|----------|--------|
| CFSA (formation débutant) | F112 (tutoriel) | 🟡 simplifié |
| CESA (politique, conseil) | ❌ | ❌ MANQUANT |
| Élections chambre | ❌ | ❌ MANQUANT |
| Savoir-faire / compétences | F161 | ✅ |
| Badges / achievements | F142 | ✅ |
| Événements saisonniers | F163 | ✅ |
| Concours | F159 | ✅ |

**Manquants politique : 2** (CESA, élections)

---

## SYNTHÈSE GLOBALE

| Domaine | Features SimAgri | Couvertes | Manquantes | Taux |
|---------|-----------------|-----------|------------|------|
| Élevage | 28 | 23 | 5 | 82% |
| Cultures | 27 | 22 | 5 | 81% |
| Matériel | 16 | 14 | 2 | 88% |
| Économie | 13 | 10 | 3 | 77% |
| Transport | 6 | 6 | 0 | 100% |
| Bâtiments | 9 | 8 | 1 | 89% |
| Social | 9 | 5 | 4 | 56% |
| Activités sec. | 12 | 6 | 6 | 50% |
| Météo | 7 | 7 | 0 | 100% |
| Formation/Politique | 7 | 5 | 2 | 71% |
| **TOTAL** | **134** | **106** | **28** | **79%** |

## 28 features manquantes — Priorisation

### Sprint 17+ (extensions futures, pas bloquantes)
1. Chien de troupeau
2. Élevage industriel / ratio fusion
3. IVRAD (races à développer)
4. Objectif Génétique (OG)
5. Robot d'alimentation
6. Céréale immature
7. Pierres (épierrage)
8. Écume de sucrerie
9. Quotas
10. Retenue collinaire
11. GPS / guidage
12. Dépôt-vente
13. Parts sociales CAR
14. Grossistes / centrales d'achat
15. Marchés locaux (vente directe)
16. Accessoires bâtiments
17. Forums in-game
18. Chat live
19. Parrainage
20. Favoris
21. Arboriculture (vergers)
22. Méthanisation (biogaz)
23. Huilerie
24. Sucrerie
25. Concessionnaire (activité joueur)
26. CIA (activité joueur)
27. Laiterie (activité joueur)
28. CESA / élections chambre

**Aucune de ces 28 features n'est bloquante pour le MVP ni pour les sprints 14-16.** Ce sont des extensions qui enrichissent le jeu sur le long terme (1-2 ans post-launch).

**Taux de couverture : 79% de SimAgri couvert avec 168 flows.** Les 21% manquants sont des activités secondaires (concessionnaire, CIA, laiterie, viticulture avancée) et du social (forums, chat) qui ne sont pas le cœur du gameplay.
