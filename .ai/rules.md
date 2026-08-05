# Agriva — Règles & Conventions

> Ce fichier s'applique à tout agent IA travaillant sur le projet. Le lire au début de chaque session.

---

## 1. Hiérarchie documentaire

1. `docs/foundation/FOUNDATION.md` — source de vérité absolue (vision)
2. `docs/design/GDD-SOURCE-VERITE.md` — source de vérité game design (paramètres du jeu)
3. `.ai/rules.md` (ce fichier) — conventions de travail
4. `docs/decisions/` — décisions actives
5. `docs/design/` + `docs/specs/` — documents de conception
6. `Docs_legacy/` — archives en lecture seule

En cas de conflit entre documents, le niveau supérieur gagne.

## 2. Workflow de travail

### Séquence pour une nouvelle feature
```
1. Question / Besoin identifié
2. Recherche (legacy, concurrence, contraintes)
3. Proposition (document structuré)
4. Review (validation humaine ou agent reviewer)
5. Décision documentée (docs/decisions/)
6. Spécification (docs/specs/)
7. Implémentation (TDD)
8. Review code
```

### Ce que chaque session doit produire
- Au moins un livrable concret (document, code, décision)
- Pas de session "discussion sans output"

## 3. Conventions de documentation

### Nommage des fichiers
- Documents : `YYYY-MM-DD-sujet.md` ou `SUJET.md` pour les documents vivants
- Décisions : `ADR-NNN-titre.md` (NNN = numéro séquentiel)

### Structure d'un document
```markdown
# Titre

> Date : YYYY-MM-DD
> Statut : Draft / En review / Validé / Obsolète
> Auteur : humain / agent:<rôle>

---

[contenu]
```

### Langage
- Documentation : français
- Code + commentaires : anglais
- Noms de variables/fonctions : anglais

## 4. Conventions de code

Voir `.ai/prompts/developer.md` pour le détail.

Résumé :
- TypeScript strict partout
- TDD obligatoire
- Fichiers en kebab-case
- Modules par domaine métier
- Pas de `any`, pas de logique dans les controllers
- Commits conventionnels (`feat(scope): description`)

## 5. Règles de décision

### Quand documenter une décision (ADR)
- Choix technique qui impacte l'architecture
- Choix de game design qui ferme des portes
- Tout ce qui ne peut pas être facilement inversé

### Format d'une décision
```markdown
# ADR-NNN : Titre

> Date : YYYY-MM-DD
> Statut : Proposé / Accepté / Rejeté / Remplacé par ADR-XXX

## Contexte
Pourquoi cette décision est nécessaire.

## Options
| Option | Avantages | Inconvénients |
|--------|-----------|---------------|

## Décision
L'option choisie et pourquoi.

## Conséquences
Ce qui en découle.
```

## 6. Gestion du scope

### Objectif final = couverture complète SimAgri
Tout y passe à terme : cultures, élevage, matériel, bâtiments, économie, activités annexes, social.

### Livraison incrémentale
On livre par couches fonctionnelles jouables. L'ordre est défini dans les docs de design. Chaque couche doit être :
- Complète (le système fonctionne de bout en bout)
- Testée
- Jouable (apporte quelque chose au joueur)

### Règle : concevoir large, implémenter par couche
- La conception couvre l'ensemble (pour éviter les impasses architecturales)
- L'implémentation est incrémentale (on ne code pas tout d'un coup)
- Pas d'abstractions spéculatives — mais pas non plus de choix qui bloquent la suite

## 7. Utilisation du legacy

Le dossier `Docs_legacy/` contient les itérations précédentes du projet. Règles :
- **OK** : s'en inspirer, en extraire des données, comparer les approches
- **NOK** : copier-coller sans réévaluation, considérer comme source de vérité
- Chaque information issue du legacy doit être re-validée dans le contexte actuel

## 8. Communication

- Être direct et concis
- Proposer, ne pas demander la permission quand le scope est clair
- Documenter les incertitudes plutôt que les ignorer
- Quand on ne sait pas : dire "je ne sais pas" + proposer comment trancher

## 9. Source de vérité Game Design

- TOUT agent travaillant sur le game design, l'équilibrage, ou les mécaniques DOIT lire `docs/design/GDD-SOURCE-VERITE.md` en début de session
- En cas de conflit entre un GDD et la source de vérité, la source de vérité gagne TOUJOURS
- Les anciens GDD (dans docs/design/) sont des documents de travail qui peuvent être obsolètes
- Après toute session de décision GD, mettre à jour la source de vérité ET propager les changements
- Le système utilise des HEURES DE TRAVAIL (HT), PAS des Points d'Action (PA). Ne jamais utiliser le terme PA pour désigner le système Agriva.
