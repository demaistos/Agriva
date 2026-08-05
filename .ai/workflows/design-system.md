# Workflow : Concevoir un système de jeu

> Utiliser ce workflow pour chaque système majeur (cultures, élevage, matériel, économie, etc.)

## Étapes

### 1. Extraction SimAgri
- Lire les règles SimAgri dans `Docs_legacy/SimAgri/`
- Documenter comment SimAgri implémente le système
- Identifier les sous-systèmes et interactions

### 2. Analyse
- Qu'est-ce qui fonctionne bien dans SimAgri ?
- Qu'est-ce qui est daté ou frustrant ?
- Quels aspects méritent une modernisation UX ?

### 3. Design Agriva
- Reprendre la base SimAgri
- Appliquer les modernisations identifiées
- Documenter dans `docs/design/`

### 4. Review
- Vérifier la cohérence avec les autres systèmes
- Vérifier qu'aucune profondeur n'a été perdue
- Valider les choix de modernisation

### 5. Spécification technique
- Transformer le design en specs implémentables
- Schéma de données, API, logique de tick
- Documenter dans `docs/specs/`

### 6. Implémentation
- TDD : tests d'abord
- Code par module
- Review code

---

## Livrables par étape

| Étape | Output |
|-------|--------|
| Extraction | `docs/research/simagri-<système>.md` |
| Analyse | Annotations dans le même doc |
| Design | `docs/design/<système>.md` |
| Review | Commentaires / validation |
| Specs | `docs/specs/<système>.md` |
| Implem | Code dans `src/modules/<système>/` |
