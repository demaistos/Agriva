# Template et conventions GDD Agriva

> À suivre impérativement pour tout GDD.

## Contexte projet (à connaître)

Agriva = jeu de simulation agricole multijoueur par navigateur, reconstruction moderne de SimAgri (simagri.com, actif depuis 2005). Objectif : même profondeur, meilleure UX, plus de réalisme.

## Les 3 décisions structurantes à RESPECTER

**ADR-001 — Deux modes de jeu**
Chaque système doit être spécifié en mode **Normal** ET en mode **Expert**. Même monde, mêmes prix, mêmes serveurs. Expert = profondeur additionnelle, pas du contenu bloqué.

**ADR-002 — Le mode Normal préserve la recette SimAgri**
Le mode Normal EST SimAgri amélioré. Règles absolues en Normal :
1. Pas de frein à la progression (charges légères 12%)
2. Pas de complexité obligatoire (aucun apprentissage préalable requis)
3. Pas de perte définitive (pas de faillite, pas de récolte nulle)
4. Les nouveautés sont des BONUS, pas des contraintes
5. L'information est suffisante (jamais besoin de doc externe)
6. Le social prime (toutes les interactions joueurs accessibles)
7. L'accumulation reste le moteur (acheter, agrandir, collectionner)

**Test de validation** : un joueur SimAgri doit dire « c'est SimAgri en mieux », jamais « c'est plus dur ».

**ADR-003 — Expert n'est pas plus rentable**
Expert apporte compréhension, contrôle, profondeur — PAS plus d'argent. Son avantage se manifeste sur : grandes structures, temps libéré, long terme, gestion de crise. Charges Expert = 28% (vs 12% Normal).

## Structure obligatoire d'un GDD

```markdown
# GDD — [Nom du système]

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : [docs de recherche pertinents], ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop
- Intention de design (pourquoi ce système existe, quel plaisir il procure)
- Ce que SimAgri fait bien (à garder) et mal (à corriger)
- Gameplay loop (schéma ASCII : quotidien / mensuel / annuel)
- Les décisions du joueur (tableau)
- Tableau différence Normal / Expert

## 2 à N. Mécaniques détaillées
Pour CHAQUE mécanique :
- Mode Normal : simple, fluide, avec mockup ASCII d'interface
- Mode Expert : profond, avec formules et mockup ASCII
- Tableau de paramètres chiffrés

## N+1. Équilibrage et scénarios
- Objectifs d'équilibrage (tableau de cibles)
- 2-3 scénarios CHIFFRÉS testés (calculs complets)
- Détection des problèmes et corrections appliquées
- Checklist playtest (dont test recette SimAgri, bloquant)

## Annexe — Récapitulatif des paramètres
Tableau complet Normal vs Expert

## Historique des révisions
Tableau : date, modification, raison
```

## Conventions de rédaction

- **Langue** : français. Code et noms de variables en anglais.
- **Chiffres** : toujours réalistes (France 2024-2026). Prix en €, surfaces en ha, poids en kg/t.
- **Mockups** : encadrés ASCII avec caractères `┌ ─ │ └ ┐ ┘`, emojis pour la lisibilité.
- **Formules** : blocs de code, variables explicites.
- **Tableaux** : alignement markdown propre.
- **Longueur cible** : 400 à 800 lignes. Dense et utile, pas de remplissage.
- **Ton** : direct, technique, sans emphase inutile.

## Ce qu'il faut ABSOLUMENT inclure

1. Au moins 2 mockups ASCII d'interface (un Normal, un Expert)
2. Au moins 1 scénario chiffré complet avec calculs
3. Le tableau récapitulatif Normal/Expert en annexe
4. La checklist playtest avec le test recette SimAgri
5. Des paramètres numériques précis (pas de « environ », pas de « à définir »)

## Ce qu'il faut ÉVITER

- Des sections vides ou « à compléter »
- Des paramètres flous (« un bonus », « une pénalité ») sans valeur chiffrée
- Du mode Normal plus complexe que SimAgri
- Des mécaniques punitives en Normal
- De la prose sans données

## Exemples de GDD déjà validés (à consulter pour le style)

- `docs/design/GDD-economie-base.md`
- `docs/design/GDD-cultures.md`
- `docs/design/GDD-materiel.md`
- `docs/design/GDD-bovin-laitier.md`
