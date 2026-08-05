# PLAN DIRECTEUR — Agriva

> Date : 2026-08-04
> Statut : Actif
> Usage : vue d'ensemble de tout ce qui reste à faire, du design au déploiement

---

## 1. Où nous en sommes

```
┌──────────────────────────────────────────────────────────────────┐
│  ÉTAPE 0 — CADRAGE                                    ✅ TERMINÉ  │
│  Inventaire SimAgri, recherche réalité terrain, roadmap           │
│  → 10 100 lignes de référence                                     │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 1 — GAME DESIGN                                ✅ TERMINÉ  │
│  20 GDD, modes Normal/Expert, 3 ADR structurants                  │
│  → ~18 700 lignes de game design, audité 3× (0 erreur)            │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 2 — ARCHITECTURE TECHNIQUE                   🔄 SUIVANTE   │
│  Stack, schéma de données, structure du code, ADR techniques      │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 3 — SPÉCIFICATIONS                             ⬜ À FAIRE  │
│  Specs implémentables par module (API, règles, tests)             │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 4 — DÉVELOPPEMENT                              ⬜ À FAIRE  │
│  10 phases (Squelette → Endgame), ~43-57 sprints                  │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 5 — TESTS & ÉQUILIBRAGE                        ⬜ À FAIRE  │
│  Playtests, ajustement des paramètres, correction de bugs         │
├──────────────────────────────────────────────────────────────────┤
│  ÉTAPE 6 — DÉPLOIEMENT & EXPLOITATION                 ⬜ À FAIRE  │
│  Infra, CI/CD, monitoring, communauté, monétisation               │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. ÉTAPE 1 — Game Design (en cours)

### 2.1 GDD prioritaires (nécessaires pour développer les phases 1-5)

| # | GDD | Statut | Priorité | Phase dev concernée |
|:-:|-----|:------:|:--------:|:-------------------:|
| 1 | `GDD-economie-base.md` | ✅ | P0 | Phase 1 |
| 2 | `GDD-cultures.md` | ✅ | P0 | Phase 3 |
| 3 | `GDD-materiel.md` | ✅ | P0 | Phase 2 |
| 4 | `GDD-bovin-laitier.md` | ✅ | P0 | Phase 4 |
| 5 | `GDD-poulet-chair.md` | ⬜ | P0 | Phase 4 |
| 6 | `GDD-marche.md` | ⬜ | P0 | Phase 5 |

### 2.2 GDD complémentaires (nécessaires avant les phases correspondantes)

| # | GDD | Priorité | Phase dev | Contenu |
|:-:|-----|:--------:|:---------:|---------|
| 7 | `GDD-core-temporalite.md` | **P0** | Phase 1 | Ticks, calendrier, saisons, HT, protection hors-ligne |
| 8 | `GDD-parcelles-sol.md` | **P0** | Phase 2 | Achat/fermage, 6 éléments, analyse, qualité |
| 9 | `GDD-meteo.md` | **P0** | Phase 2 | Génération, zones, prévisions, événements climatiques |
| 10 | `GDD-batiments-stockage.md` | **P0** | Phase 2 | Catalogue, construction, usure, énergie, capacités |
| 11 | `GDD-social-multijoueur.md` | P1 | Phase 5 | Amis, messagerie, classements, profils |
| 12 | `GDD-elevage-autres-especes.md` | P1 | Phase 4 | Porcin, ovin, caprin, bovin allaitant |
| 13 | `GDD-genetique.md` | P1 | Phase 7 | Index, sélection, IVRAD, concours |
| 14 | `GDD-metiers-eta-concession.md` | P1 | Phase 8 | ETA, concessionnaire, transporteur |
| 15 | `GDD-transformation.md` | P2 | Phase 8 | Fromagerie, huilerie, méthanisation |
| 16 | `GDD-specialisations-vegetales.md` | P2 | Phase 6 | Arboriculture, irrigation, haies, PDT |
| 17 | `GDD-cooperatives-car.md` | P2 | Phase 9 | CAR, parts sociales, sous-activités |
| 18 | `GDD-endgame.md` | P3 | Phase 10 | Viticulture, foresterie, concours, monétisation |
| 19 | `GDD-onboarding.md` | **P0** | Phase 1 | Tutoriel, choix du mode, premiers pas |
| 20 | `GDD-ui-ux.md` | **P0** | Phase 1 | Design system, navigation, responsive, accessibilité |

**Total : 20 GDD, dont 10 en priorité P0**

### 2.3 Ordre de rédaction recommandé

```
IMMÉDIAT (bloquant pour démarrer le développement)
  5. GDD-poulet-chair          (termine le bloc élevage)
  6. GDD-marche                 (termine le bloc économie)
  7. GDD-core-temporalite       ← FONDATION, à faire tôt
  8. GDD-parcelles-sol
  9. GDD-meteo
 10. GDD-batiments-stockage
 19. GDD-onboarding
 20. GDD-ui-ux

ENSUITE (avant les phases 4-5)
 11. GDD-social-multijoueur
 12. GDD-elevage-autres-especes

PLUS TARD (avant les phases 6-10)
 13-18. Spécialisations, métiers, endgame
```

---

## 3. ÉTAPE 2 — Architecture technique

### 3.1 Décisions d'architecture à documenter (ADR)

| ADR | Sujet | Priorité |
|-----|-------|:--------:|
| ADR-004 | Stack technique définitive (versions, libs) | **P0** |
| ADR-005 | Architecture applicative (modules, couches, patterns) | **P0** |
| ADR-006 | Modèle de données (PostgreSQL, schéma, migrations) | **P0** |
| ADR-007 | Système de ticks (worker, cron, idempotence, reprise) | **P0** |
| ADR-008 | Gestion du temps de jeu (ratio réel/jeu, fuseau) | **P0** |
| ADR-009 | Stratégie d'API (REST, validation, versioning) | **P0** |
| ADR-010 | Authentification et sécurité (JWT, refresh, RBAC) | **P0** |
| ADR-011 | Temps réel (WebSocket : quoi, quand, pourquoi) | P1 |
| ADR-012 | Stratégie de cache (Redis ? quoi cacher ?) | P1 |
| ADR-013 | Gestion des modes Normal/Expert dans le code | **P0** |
| ADR-014 | Stratégie de tests (unitaires, intégration, e2e) | **P0** |
| ADR-015 | Observabilité (logs, métriques, traces) | P1 |
| ADR-016 | Anti-triche et intégrité (validation serveur) | P1 |
| ADR-017 | Internationalisation (français d'abord, extensible ?) | P2 |
| ADR-018 | Stratégie de déploiement (conteneurs, environnements) | P1 |

### 3.2 Documents d'architecture

| Document | Contenu | Priorité |
|----------|---------|:--------:|
| `docs/architecture/ARCHITECTURE.md` | Vue d'ensemble, diagrammes, flux | **P0** |
| `docs/architecture/DATA-MODEL.md` | Schéma complet, relations, index | **P0** |
| `docs/architecture/API-DESIGN.md` | Conventions REST, erreurs, pagination | **P0** |
| `docs/architecture/TICK-ENGINE.md` | Moteur de simulation, ordre des ticks | **P0** |
| `docs/architecture/RULES-ENGINE.md` | Où vivent les règles métier, comment les tester | **P0** |
| `docs/architecture/MODE-SYSTEM.md` | Implémentation Normal/Expert (flags, stratégies) | **P0** |
| `docs/architecture/SECURITY.md` | Menaces, protections, validation | P1 |
| `docs/architecture/PERFORMANCE.md` | Budgets, optimisations, scaling | P1 |

### 3.3 Points d'architecture critiques à trancher

```
1. LE MOTEUR DE TICKS
   • Ordre d'exécution (croissance → alimentation → santé → production → prix)
   • Idempotence (que se passe-t-il si un tick échoue à mi-parcours ?)
   • Performance (1 000 joueurs × 100 parcelles × 200 animaux = combien de temps ?)
   • Rattrapage (le worker était éteint 6 h, on rattrape ou on saute ?)

2. LES MODES NORMAL/EXPERT
   • Un seul moteur avec paramètres verrouillés (recommandé, cf. REFERENCE §3.6)
   • Ou deux implémentations séparées (rejeté : dette technique)
   • Comment tester les deux modes sans dupliquer les tests ?

3. LE CALCUL DU RENDEMENT
   • Où vit la formule ? (service pur, testable, sans effet de bord)
   • Comment expliquer le résultat au joueur (décomposition = besoin de traçabilité)

4. LA COHÉRENCE TRANSACTIONNELLE
   • Une action = une transaction (achat = débit + livraison atomiques)
   • Que faire si le joueur clique 2× rapidement ? (idempotence des actions)

5. LE MULTIJOUEUR
   • Les prix dépendent de l'activité globale → calcul centralisé
   • Les échanges entre joueurs → verrouillage, anti-race-condition
```

---

## 4. ÉTAPE 3 — Spécifications

Pour chaque module à développer, une spec implémentable :

### 4.1 Contenu type d'une spec

```markdown
# SPEC — [Module]

## 1. Périmètre
Ce qui est inclus / exclu

## 2. Modèle de données
Tables, colonnes, contraintes, index, migrations

## 3. Règles métier
Formules exactes, cas limites, valeurs par défaut
Comportement en mode Normal / Expert

## 4. API
Endpoints, payloads, codes d'erreur, validation

## 5. Ticks
Ce que le worker fait pour ce module, dans quel ordre

## 6. UI
Écrans, composants, états (chargement, vide, erreur)

## 7. Tests
Cas de test obligatoires, données de test, critères d'acceptation

## 8. Dépendances
Modules requis, ordre d'implémentation
```

### 4.2 Specs à produire (alignées sur les phases de dev)

| Phase | Specs | Nombre |
|:-----:|-------|:------:|
| 1 | auth, joueur, serveur, géographie, temporalité, worker, HT, économie-base, UX-core | 9 |
| 2 | parcelles, sol, météo, bâtiments, stockage, matériel, transport, charges-auto | 8 |
| 3 | cultures, rendement, techniques, rotation, coopérative, engrais, traitements, récolte, paille | 9 |
| 4 | animaux, lots, alimentation, litière, lait, œufs, reproduction, pâturage, abattoir, enclos | 10 |
| 5 | prix-dynamiques, marché-joueurs, social, messagerie, classements, profil, employés, banque | 8 |
| 6 | irrigation, arboriculture, haies, filière-PDT, compostage, engrais-verts, bio | 7 |
| 7 | génétique, IA, labels-élevage, IVRAD, espèces-suppl, vaccins, robots | 7 |
| 8 | ETA, concessionnaire, transporteur, CIA, fromagerie, maraîchage, méthanisation | 7 |
| 9 | CAR, huilerie, sucrerie, laiterie, forum, CFSA | 6 |
| 10 | viticulture, foresterie, foie-gras, concours, salons, monétisation | 6 |

**Total : ~77 specs**

---

## 5. ÉTAPE 4 — Développement

### 5.1 Les 10 phases (source : ROADMAP.md)

| Phase | Nom | Livrable | Sprints estimés |
|:-----:|-----|----------|:---------------:|
| **1** | Le Squelette | Un joueur se connecte, voit sa ferme vide, le temps avance | 4-5 |
| **2** | La Terre | Parcelles, météo, bâtiments, matériel | 5-6 |
| **3** | Les Cultures | **BOUCLE JOUABLE** : semer → récolter → vendre | 6-8 |
| **4** | L'Élevage | Animaux, alimentation, lait, œufs | 6-8 |
| **5** | Multijoueur | Prix dynamiques, marché, social | 5-6 |
| **6** | Spécialisations végétales | Irrigation, arbo, haies, PDT | 4-5 |
| **7** | Spécialisations animales | Génétique, labels, espèces suppl. | 4-6 |
| **8** | Métiers & Transformations | ETA, concession, fromagerie, métha | 5-7 |
| **9** | Coopératives & Social avancé | CAR, forum, CFSA | 3-4 |
| **10** | Endgame | Viticulture, foresterie, concours | 3-4 |

**Total : 45-59 sprints** (~1,5 à 2,5 ans à raison de 2 semaines par sprint)

### 5.2 Jalons majeurs

```
🎯 JALON 1 — "Ça tourne" (fin Phase 1, ~2 mois)
   Un joueur se connecte, le temps avance, il a un solde.
   → Validation technique du socle

🎯 JALON 2 — "C'est jouable" (fin Phase 3, ~7 mois)
   BOUCLE COMPLÈTE : semer, faire pousser, récolter, vendre, recommencer.
   → PREMIER PROTOTYPE TESTABLE PAR DES JOUEURS
   → Playtest fermé (10-20 testeurs)

🎯 JALON 3 — "C'est complet" (fin Phase 4, ~11 mois)
   Cultures + élevage. Un joueur peut se spécialiser.
   → Playtest élargi (50-100 testeurs)

🎯 JALON 4 — "C'est un MMO" (fin Phase 5, ~14 mois)
   Multijoueur, commerce, social.
   → ALPHA PUBLIQUE

🎯 JALON 5 — "C'est riche" (fin Phase 8, ~22 mois)
   Spécialisations + métiers annexes.
   → BÊTA PUBLIQUE

🎯 JALON 6 — "C'est SimAgri complet" (fin Phase 10, ~28 mois)
   Couverture fonctionnelle totale.
   → LANCEMENT OFFICIEL
```

### 5.3 Règles de développement (rappel des conventions)

```
Par sprint :
  • Code fonctionnel + tests + documentation
  • Rétrospective en fin de sprint
  • Rien ne part en production sans tests

Par feature :
  Design → Review → Spec → Implémentation (TDD) → Test → Review code → Merge

Qualité :
  • TypeScript strict, pas de `any`
  • Modules par domaine métier
  • Tests unitaires sur toute règle métier
  • Tests e2e sur tout parcours joueur critique
  • CI verte obligatoire pour merger
```

---

## 6. ÉTAPE 5 — Tests & équilibrage

### 6.1 Types de tests à mettre en place

| Type | Outil | Couverture cible | Quand |
|------|-------|:----------------:|-------|
| Unitaires (règles métier) | Vitest | 90%+ sur les services | À chaque commit |
| Intégration (API + DB) | Vitest + testcontainers | Tous les endpoints | À chaque commit |
| E2E (parcours joueur) | Playwright | 15-20 parcours critiques | Avant chaque merge |
| Simulation (équilibrage) | Script custom | 10 profils de joueurs × 10 ans | À chaque phase |
| Charge | k6 ou Artillery | 1 000 joueurs simultanés | Avant chaque jalon |
| Sécurité | OWASP ZAP + audit manuel | Top 10 OWASP | Avant l'alpha publique |

### 6.2 Tests d'équilibrage spécifiques

```
SIMULATEUR DE PARTIE (à développer en Phase 3)
  Objectif : faire tourner 10 ans de jeu en quelques minutes
  
  Profils à simuler :
    • Débutant Normal qui joue "correctement"
    • Débutant Normal négligent
    • Joueur Normal optimisateur
    • Joueur Expert débutant
    • Joueur Expert optimisateur
    • Joueur spécialisé cultures
    • Joueur spécialisé élevage laitier
    • Joueur mixte
    • Joueur bio
    • Joueur qui fait de l'ETA

  Métriques à vérifier :
    ✓ Aucun profil ne fait faillite en Normal
    ✓ Écart de revenu entre filières < 30%
    ✓ Progression de trésorerie positive chaque année
    ✓ Aucune stratégie dominante (> +40% vs les autres)
    ✓ Les paramètres des GDD sont respectés
```

### 6.3 Playtests

| Playtest | Quand | Participants | Objectif |
|----------|-------|:------------:|----------|
| Test interne | Fin Phase 2 | 3-5 | Le socle est-il utilisable ? |
| Playtest fermé | Fin Phase 3 | 10-20 | La boucle de jeu est-elle plaisante ? |
| **Test recette SimAgri** | Fin Phase 3 | 5-10 joueurs SimAgri | « C'est SimAgri en mieux » ? (ADR-002) |
| Playtest élargi | Fin Phase 4 | 50-100 | L'équilibrage tient-il ? |
| Alpha publique | Fin Phase 5 | 500+ | Le multijoueur fonctionne-t-il ? |
| Bêta publique | Fin Phase 8 | 2 000+ | Le jeu est-il complet et stable ? |

---

## 7. ÉTAPE 6 — Déploiement & exploitation

### 7.1 Infrastructure

| Élément | Choix à faire | Priorité |
|---------|--------------|:--------:|
| Hébergement | Cloud (AWS/OVH/Scaleway) ou dédié | **P0** |
| Base de données | PostgreSQL managé ou auto-hébergé | **P0** |
| Worker de ticks | Process séparé, résilient, monitoré | **P0** |
| CDN / assets | Images, sons, ressources statiques | P1 |
| Cache | Redis (sessions, prix, classements) | P1 |
| Stockage fichiers | Avatars, exports | P2 |
| Backups | Fréquence, rétention, test de restauration | **P0** |
| Monitoring | Uptime, erreurs, performance, alertes | **P0** |
| Logs | Centralisation, recherche, rétention | P1 |

### 7.2 CI/CD

```
À mettre en place dès la Phase 1 :
  • GitHub Actions (ou équivalent)
  • Pipeline : lint → typecheck → tests unitaires → tests intégration → build
  • Déploiement automatique en staging sur merge dans main
  • Déploiement en production manuel (validation humaine)
  • Migrations de base automatiques avec rollback possible
  • Rollback applicatif en 1 commande
```

### 7.3 Exploitation

| Sujet | À prévoir | Priorité |
|-------|-----------|:--------:|
| Support joueurs | Canal (Discord ? ticket ?), FAQ, modération | P1 |
| Communauté | Discord, forum in-game, réseaux sociaux | P1 |
| Documentation joueur | Règles, tutoriels, wiki | P1 |
| Modération | Outils admin, sanctions, anti-triche | P1 |
| Monétisation | Modèle (abonnement type SimPass ? cosmétique ?) | P2 |
| RGPD | Politique de confidentialité, droit à l'oubli, CGU | **P0** |
| Mentions légales | CGU, CGV si monétisation | **P0** |

---

## 8. Chemin critique — que faire dans quel ordre

```
MAINTENANT (les 4 prochaines sessions)
  1. GDD-poulet-chair                    ← termine le bloc élevage prioritaire
  2. GDD-marche                          ← termine le bloc économie
  3. GDD-core-temporalite                ← FONDATION du moteur de jeu
  4. GDD-ui-ux + GDD-onboarding          ← l'expérience du premier joueur

ENSUITE (architecture, ~4-6 sessions)
  5. ADR-004 à ADR-014 (stack, données, ticks, modes, tests)
  6. ARCHITECTURE.md + DATA-MODEL.md + TICK-ENGINE.md
  7. Choix d'hébergement et setup CI/CD

PUIS (specs Phase 1, ~3-4 sessions)
  8. Les 9 specs de la Phase 1
  9. Setup du projet (repo, stack, CI, tests, environnements)

ENFIN (développement)
 10. Phase 1 — Le Squelette
 11. Puis GDD-parcelles-sol, GDD-meteo, GDD-batiments avant la Phase 2
 12. Alterner : GDD → specs → dev, phase par phase
```

### 8.1 Principe d'alternance recommandé

```
Ne pas tout designer avant de coder, ni tout coder sans designer.

Rythme :
  Pour la phase N :
    • Les GDD de la phase N doivent être finis
    • Les specs de la phase N doivent être finies
    • On développe la phase N
    • Pendant le dev de la phase N, on rédige les GDD de la phase N+1

Avantage : on apprend en codant, et cet apprentissage nourrit
           le design des phases suivantes.
```

---

## 9. Risques identifiés et mitigations

| Risque | Probabilité | Impact | Mitigation |
|--------|:-----------:|:------:|------------|
| Le moteur de ticks ne scale pas | Moyenne | Critique | Tests de charge dès la Phase 1, conception par lots |
| Les modes Normal/Expert doublent le travail | Élevée | Fort | ADR-013 : un seul moteur, paramètres verrouillés |
| L'équilibrage économique est faux | Élevée | Fort | Simulateur de partie dès la Phase 3 |
| Le scope explose (119 systèmes) | Élevée | Fort | Phases strictes, pas de scope creep, backlog |
| Le jeu n'est pas fun | Moyenne | Critique | Playtest dès le Jalon 2 (Phase 3) |
| Perte de la "recette SimAgri" | Moyenne | Critique | ADR-002 + test avec de vrais joueurs SimAgri |
| Dette technique accumulée | Moyenne | Moyen | TDD obligatoire, revue de code, refactoring continu |
| Abandon par lassitude (projet long) | Moyenne | Critique | Jalons courts, livrable jouable dès 7 mois |
| Problème juridique (nom, ressemblance) | Faible | Fort | Vérifier la marque, ne pas copier les assets |

---

## 10. Tableau de bord de suivi

### 10.1 État global

| Étape | Avancement | Livrables faits | Livrables restants |
|-------|:----------:|:---------------:|:------------------:|
| Cadrage | 100% | 7 | 0 |
| **Game Design** | **100%** | **20 GDD + 3 ADR + 1 audit** | **0** |
| Architecture | 0% | 0 | 23 |
| Specs | 0% | 0 | ~77 |
| Développement | 0% | 0 | 10 phases |
| Tests | 0% | 0 | 6 types + 6 playtests |
| Déploiement | 0% | 0 | ~20 éléments |

### 10.2 Prochains livrables (les 10 prochains)

- [ ] `ADR-004-stack-technique.md`
- [ ] `ADR-005-architecture-applicative.md`
- [ ] `ADR-006-modele-donnees.md`
- [ ] `ADR-007-systeme-ticks.md`
- [ ] `ADR-013-implementation-modes.md`
- [ ] `ADR-014-strategie-tests.md`
- [ ] `architecture/ARCHITECTURE.md`
- [ ] `architecture/DATA-MODEL.md`
- [ ] `architecture/TICK-ENGINE.md`
- [ ] `architecture/MODE-SYSTEM.md`

---

## 11. Estimation globale

| Étape | Durée estimée | Cumul |
|-------|:-------------:|:-----:|
| Game Design (16 GDD restants) | 6-10 semaines | 2,5 mois |
| Architecture (23 documents) | 3-5 semaines | 4 mois |
| Specs Phase 1-3 (26 specs) | 4-6 semaines | 5,5 mois |
| Dev Phase 1 (Squelette) | 8-10 semaines | 8 mois |
| Dev Phase 2 (La Terre) | 10-12 semaines | 11 mois |
| Dev Phase 3 (Cultures) | 12-16 semaines | **14 mois → JOUABLE** |
| Dev Phase 4 (Élevage) | 12-16 semaines | 18 mois |
| Dev Phase 5 (Multijoueur) | 10-12 semaines | **21 mois → ALPHA** |
| Dev Phases 6-8 | 26-36 semaines | **29 mois → BÊTA** |
| Dev Phases 9-10 | 12-16 semaines | **32 mois → LANCEMENT** |

> Ces estimations supposent un rythme de travail soutenu et régulier. Elles seront révisées après la Phase 1, quand la vélocité réelle sera mesurable.

---

*Plan directeur créé le 4 août 2026. À réviser à chaque fin d'étape.*
