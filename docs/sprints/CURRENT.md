# Sprint Actuel

> **Phase Game Design : ✅ TERMINÉE ET VALIDÉE**
> Prochaine phase : Architecture technique

## Décisions de cette session (2026-08-04)

### ADR-005 — Deux serveurs séparés (Normal + Expert)
- Deux économies indépendantes, deux marchés, deux classements
- Un joueur peut avoir une exploitation sur chaque serveur
- Partagé : compte, amis, messagerie, forum, abonnement premium
- Non partagé : argent, matériel, animaux, terres, classements
- Stratégie d'ouverture : Normal d'abord, Expert à 800 joueurs actifs

### ADR-006 — Cascade complète des effets
- Toute action déclenche TOUS ses effets (temps, carburant, usure, stocks, sol, etc.)
- Transaction atomique : tout ou rien
- 129 actions documentées dans ACTIONS-CATALOGUE.md

### Modèle d'exécution — instantané au clic (ADR-004 révisé)
- **Les heures sont des POINTS** habillés en heures (même mécanique que les PA SimAgri)
- Clic → budget débité → action résolue → enchaîner
- **Pas de planificateur, pas de file, pas de chantier en cours**
- Budget : 84 h/tick (exploitant seul), rechargé à chaque tick quotidien
- Si budget insuffisant → action refusée (investir, embaucher, ou attendre)
- Le joueur découpe manuellement s'il veut faire 40 ha maintenant et 40 ha au tick suivant

### Capacité de travail (fixe toute l'année)
- Exploitant : **12 h/jour** × 7 = **84 h/tick**
- Ouvrier : **8 h/jour** × 7 = **56 h/tick**, coût 2 200 €/mois
- Pas de variation saisonnière (la demande varie, pas le budget)
- Max 5 ouvriers → budget max = 364 h/tick

### Marché des animaux
- **3 canaux** : Grossiste PNJ (prix fixe, génétique moyenne, quota mensuel) / Marché public joueurs (prix libre, premier arrivé) / Marché privé B2B (entre 2 joueurs nommés)
- **Chaque animal est unique** (génétique propre, historique, production)
- Grossiste PNJ = starter pour débutants (quota 5 bovins/mois, indices 40-60)
- Marché joueurs = progression long terme (génétique supérieure, prix libre)
- Limites : quota PNJ, prix bornés 50-200%, commission 5%, transport bétaillère obligatoire

## Fichiers créés/modifiés cette session

### Nouveaux
| Fichier | Lignes | Contenu |
|---------|:------:|---------|
| `decisions/ADR-005-deux-serveurs-separes.md` | 217 | Deux serveurs, stratégie d'ouverture, ce qui est partagé |
| `decisions/ADR-006-cascade-complete-effets.md` | 399 | Principe de cascade, matrices d'effets, contrat d'action |
| `design/ACTIONS-CATALOGUE.md` | ~3 800 | 129 actions avec cascade complète par catégorie |

### Révisés significativement
| Fichier | Nature de la révision |
|---------|----------------------|
| `decisions/ADR-001-modes-de-jeu.md` | Marqué partiellement remplacé par ADR-005 |
| `decisions/ADR-003-expert-nest-pas-plus-rentable.md` | Contrainte levée (serveurs séparés) |
| `decisions/ADR-004-temps-de-travail-calcule.md` | 12h/8h fixes + modèle instantané + suppression chantiers pluri-journaliers |
| `design/GDD-core-temporalite.md` | Section 4 entière réécrite (modèle instantané, budget/tick) |
| `design/GDD-onboarding.md` | Choix serveur au lieu de choix mode, seconde exploitation |
| `design/GDD-social-multijoueur.md` | Portée inter-serveurs, classements par serveur |
| `design/GDD-gouvernance-serveur.md` | Stratégie d'ouverture, seuils de viabilité, fusion |
| `design/GDD-maraichage.md` | 8h ouvrier, capacité fixe |
| 12 GDD | Contrainte ADR-003 reformulée, références ADR corrigées |

## Les 6 ADR structurants

| ADR | Sujet | Statut |
|-----|-------|--------|
| **ADR-001** | Deux modes Normal/Expert (paramètres) | Partiellement remplacé par ADR-005 |
| **ADR-002** | Recette SimAgri en Normal (7 règles) | ✅ Actif |
| **ADR-003** | Expert ≠ plus rentable | Contrainte levée (ADR-005) |
| **ADR-004** | Temps calculé, instantané, 12h+8h fixes | ✅ Actif — révisé |
| **ADR-005** | Deux serveurs séparés | ✅ Actif — nouveau |
| **ADR-006** | Cascade complète des effets | ✅ Actif — nouveau |

## Modèle de jeu — synthèse en une page

```
TEMPORALITÉ :
  1 tick/jour réel = 7 jours de jeu
  1 an de jeu = 84 jours réels (~3 mois)

BUDGET :
  Exploitant : 84 h/tick (12h × 7j)
  + Ouvrier : +56 h/tick (8h × 7j), coût 2 200 €/mois
  Rechargé à chaque tick. Pas de report.

EXÉCUTION :
  Clic → résolution instantanée → budget débité → enchaîner
  Pas de file, pas de timer, pas de chantier en cours.
  Si budget < coût → action refusée.

COÛT D'UNE ACTION :
  Calculé (pas forfaitaire). Dépend du matériel.
  Meilleur matériel = coût en heures plus bas = faire plus par tick.

CASCADE :
  Chaque action consomme : temps + carburant + usure + intrants
  Chaque action produit : modification sol/animal/stock + alertes

CE QUI RAMÈNE LE JOUEUR :
  1. Les stades de culture évoluent au tick (décisions à prendre)
  2. La météo tombe au tick (adapter ses plans)
  3. Le marché fluctue (opportunités d'achat/vente)
  4. Les animaux ont des événements (chaleurs, vêlages, maladies)
  5. Les autres joueurs agissent (ETA, marché, coopérative)

CE QUI LIMITE LE JOUEUR :
  1. Le budget d'heures (84h seul = ~80 ha de labour max)
  2. Les saisons (pas de moisson en hiver)
  3. Les stades (pas de fertilisation sans le bon stade)
  4. L'argent (investissement progressif)
  5. Les quotas (grossiste PNJ limité)

PROGRESSION :
  Court terme : agrandir (parcelles, troupeau)
  Moyen terme : investir (matériel, bâtiments, ouvriers)
  Long terme : génétique animale, labels, transformation, métiers
```

## Prochaine étape : Architecture technique

Le game design est complet. Les prochains documents à produire :
1. ADR-007 — Système de ticks
2. ADR-008 — Architecture applicative
3. ADR-009 — Modèle de données
4. ARCHITECTURE.md, DATA-MODEL.md, TICK-ENGINE.md
