# Agriva — Document Fondateur

> Date : 2026-08-03
> Statut : Actif — Source de vérité

---

## 1. Vision

**Ressusciter SimAgri.** Reprendre la formule complète du jeu — toute sa profondeur, ses systèmes, son économie — et la reconstruire sur une stack moderne avec une UX contemporaine.

SimAgri est mort depuis ~10 ans sans développement. Le jeu qu'il était mérite d'exister à nouveau.

## 2. Référence : SimAgri

SimAgri (simagri.com) est notre modèle. Pas une inspiration parmi d'autres — LE modèle. On vise la même couverture fonctionnelle :

- **Cultures** : 25+ types (céréales, oléagineux, arboriculture, maraîchage, viticulture, foresterie)
- **Élevage** : 13 espèces, génétique, alimentation, reproduction
- **Matériel** : tracteurs, outils, usure, pannes, GPS, combinés
- **Bâtiments** : hangars, stabulations, silos, fosses, salles de traite
- **Économie** : marché joueur dynamique, coopératives, prix offre/demande
- **Activités annexes** : concessionnaire, transporteur, ETA, fromagerie, CIA, méthanisation
- **Social** : coopératives, mentorat (CFSA), concours, classements, messagerie
- **Temporalité** : 1 semaine réelle = 1 mois de jeu

## 3. Ce qu'Agriva modernise

On ne change pas la formule. On modernise l'exécution :

| Aspect | SimAgri (2005) | Agriva (2026) |
|--------|----------------|---------------|
| Stack | PHP/MySQL/jQuery | TypeScript full-stack, PostgreSQL, React |
| UX | Interface datée, pages rechargeables | Interface réactive, responsive, synthétique |
| Ergonomie | Tout visible d'un coup, dense | Information par couches (synthèse → détail) |
| Mobile | Non | Responsive, jouable sur mobile |
| Onboarding | Brutal | Progressif, tutoriel intégré |
| Documentation | Wiki externe | Aide contextuelle intégrée |
| Monétisation | SimPass obligatoire pour certaines features | F2P + abo confort (QoL), jamais P2W |

## 4. Objectif

Atteindre la même profondeur et richesse que SimAgri à son apogée. Pas un SimAgri "lite" — le vrai jeu, complet, avec tous ses systèmes. La différence est dans la qualité technique et l'expérience utilisateur, pas dans le contenu.

## 5. Principes de développement

1. **Fidèle d'abord** — comprendre et reproduire chaque système de SimAgri avant de l'améliorer
2. **Robuste > Large** — chaque système complet et testé avant le suivant
3. **Incrémental** — livrer par couches fonctionnelles jouables
4. **TDD obligatoire** — tout système a ses tests
5. **AI-assisted** — les agents IA participent à chaque étape (design, code, review)

## 6. Roadmap de couverture

L'objectif final est la couverture complète de SimAgri. L'ordre de livraison sera défini dans les docs de design, mais tout y passe à terme :
- Cultures (toutes)
- Élevage (toutes espèces)
- Matériel complet
- Bâtiments complets
- Économie et marchés
- Activités annexes (toutes)
- Social et communautaire

## 7. Ce document est la racine

Tout dans le projet doit être cohérent avec ce document. En cas de doute : "est-ce que SimAgri le faisait ? Alors on le fait aussi."
