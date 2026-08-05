# Workflow : Spec-Driven Development

> Inspiré du workflow officiel Kiro IDE. Chaque feature passe par 3 phases obligatoires avec validation humaine entre chaque.

---

## Structure des specs

```
docs/specs/{feature-name}/
├── requirements.md    # Phase 1 : Quoi (user stories + critères EARS)
├── design.md          # Phase 2 : Comment (architecture, composants, data)
└── tasks.md           # Phase 3 : Plan d'implémentation (checklist codable)
```

---

## Phase 1 : Requirements

### Format

```markdown
# Requirements — {Feature Name}

## Introduction
[Résumé de la feature en 2-3 phrases]

## Requirements

### Requirement 1
**User Story:** As a [role], I want [feature], so that [benefit]

#### Acceptance Criteria
1. WHEN [event] THEN [system] SHALL [response]
2. IF [precondition] THEN [system] SHALL [response]
3. WHILE [state] THE [system] SHALL [behavior]

### Requirement 2
...
```

### Règles
- Générer un premier draft basé sur l'idée / le système SimAgri
- Format EARS (Easy Approach to Requirements Syntax)
- Couvrir les cas limites, l'UX, les contraintes techniques
- **Validation humaine obligatoire avant Phase 2**

---

## Phase 2 : Design

### Format

```markdown
# Design — {Feature Name}

## Overview
[Ce que fait le système, en quoi il consiste]

## Architecture
[Comment les composants s'articulent — diagramme Mermaid si utile]

## Components & Interfaces
[API publique, interfaces TypeScript, contrats]

## Data Models
[Schéma Prisma, types, relations]

## Error Handling
[Erreurs métier, codes, messages, recovery]

## Testing Strategy
[Quoi tester, comment, couverture attendue]
```

### Règles
- Basé sur les requirements approuvés
- Inclure les recherches réalité agricole comme contexte
- Documenter les décisions et leur justification
- **Validation humaine obligatoire avant Phase 3**

---

## Phase 3 : Tasks (Implementation Plan)

### Format

```markdown
# Implementation Plan — {Feature Name}

- [ ] 1. Set up types and interfaces
  - Create TypeScript interfaces for the domain
  - _Requirements: 1.1, 1.2_

- [ ] 2. Implement core service
  - [ ] 2.1 Write unit tests for core logic
    - Test [specific behavior]
    - _Requirements: 2.1_
  - [ ] 2.2 Implement service functions
    - Code the business logic
    - _Requirements: 2.1, 2.2_

- [ ] 3. Create repository layer
  ...
```

### Règles
- Chaque tâche = action de code concrète (écrire, modifier, tester)
- TDD : tests d'abord quand possible
- Incrémental : chaque tâche build sur la précédente
- Référence les requirements spécifiques
- PAS de tâches non-code (déploiement, tests utilisateur, marketing)
- **Validation humaine obligatoire avant implémentation**
- **Exécuter UNE tâche à la fois, jamais plusieurs**

---

## Règles d'exécution

1. **Séquentiel** : Requirements → Design → Tasks. Pas de saut.
2. **Validation** : chaque document doit être approuvé explicitement avant de passer au suivant.
3. **Itératif** : si le feedback demande des changements, on modifie et on redemande validation.
4. **Retour possible** : si la phase Design révèle un trou dans les requirements, on retourne en Phase 1.
5. **Une tâche à la fois** : pendant l'implémentation, on fait une tâche, on s'arrête, on valide.

---

## Différences avec notre workflow précédent

| Avant | Maintenant |
|-------|-----------|
| design doc libre | Structure requirements + design + tasks obligatoire |
| Validation implicite | Validation explicite à chaque phase |
| Plan d'implem dans le sprint | Plan dans la spec de la feature |
| Format libre | Format EARS pour requirements, checklist pour tasks |

---

## Quand utiliser ce workflow

- **Toujours** pour une nouvelle feature/système
- **Pas nécessaire** pour un bugfix simple ou un refactoring mineur
- **Adapté** pour les documents de design game (requirements = mécaniques de jeu, design = règles détaillées, tasks = implémentation)
