# Agriva — Meilleures Pratiques IA

> Comment utiliser l'IA de manière optimale sur ce projet, de la conception au déploiement.

---

## 1. Organisation des sessions

### Principe : chaque session a un objectif clair et un livrable

| Type de session | Durée idéale | Livrable attendu |
|----------------|--------------|-----------------|
| Recherche | 30-60 min | Document de référence |
| Design | 30-45 min | GDD d'un système |
| Architecture | 20-30 min | ADR ou schéma |
| Implémentation | 45-90 min | Module + tests |
| Review | 15-30 min | Rapport avec verdict |
| Debugging | Variable | Fix + test de non-régression |

### Début de session (toujours)

```
1. Lire .ai/context.md
2. Lire docs/sprints/CURRENT.md
3. Identifier la tâche suivante
4. Annoncer ce qu'on va faire
5. Faire
```

### Fin de session (toujours)

```
1. Mettre à jour CURRENT.md
2. Update KB si changement significatif
3. Résumer ce qui a été fait + prochaine étape
```

---

## 2. Stratégie de prompts

### Contexte structuré > contexte massif

Fournir au modèle :
- Le minimum de contexte nécessaire (pas tout le projet)
- Des instructions précises (format de sortie, longueur, contraintes)
- Des exemples si le format est non-trivial

### Hiérarchie de contexte

```
Niveau 1 : .ai/context.md (toujours)
Niveau 2 : Le prompt du rôle actif (.ai/prompts/<role>.md)
Niveau 3 : Le document spécifique au sujet (design doc, spec, code)
Niveau 4 : La source de référence (legacy, doc externe)
```

Ne pas tout charger — charger par couches selon le besoin.

### Prompts efficaces pour ce projet

**Recherche :**
```
Contexte : [1 paragraphe max]
Source à lire : [1-2 fichiers]
Produis : [format exact attendu]
Contraintes : [longueur, niveau de détail, angle]
Écris dans : [chemin du fichier de sortie]
```

**Implémentation :**
```
Spec : [lien vers la spec]
Module : [chemin du module]
Pattern à suivre : [exemple existant ou convention]
Tests attendus : [types de tests]
```

**Review :**
```
Fichier(s) à reviewer : [chemins]
Checklist : [lien vers .ai/prompts/reviewer.md]
Focus : [ce qu'on cherche spécifiquement]
```

---

## 3. Utilisation des sub-agents

### Quand paralléliser

- Document de recherche multi-sections → 1 agent/section en parallèle
- Implémentation multi-modules indépendants → 1 agent/module
- Review de plusieurs fichiers non liés → 1 agent/fichier

### Quand NE PAS paralléliser

- Sections qui dépendent les unes des autres
- Code avec beaucoup d'interdépendances
- Quand la cohérence stylistique est critique

### Règles (cf. .ai/workflows/subagent-usage.md)

- Prompt < 2000 chars
- Max 2-3 fichiers à lire par agent
- Livrable < 300 lignes par agent
- Toujours écrire dans un fichier (pas en mémoire)
- Pattern : parallèle → assemblage par agent principal

---

## 4. Knowledge Management

### Ce qu'on indexe

| Contenu | KB | Quand mettre à jour |
|---------|----|--------------------|
| `.ai/` (prompts, règles, workflows) | Agriva - Environnement IA | À chaque modif des fichiers .ai |
| `docs/` (fondation, design, specs, sprints) | Agriva - Documentation fondatrice | À chaque nouveau doc ou décision |

### Quand chercher dans la KB

- Avant de rédiger un design doc (vérifier qu'il n'existe pas déjà)
- Avant de prendre une décision (vérifier qu'elle n'a pas déjà été tranchée)
- Pour retrouver un chiffre ou une spec précise

### Mise à jour

Faire un `knowledge update` après :
- Création/modification d'un document important
- Fin de sprint
- Nouvelle décision documentée

---

## 5. Workflow de production de contenu

### Documents de référence (recherche réalité agricole)

```
┌──────────────────────────────────────────────┐
│ 1. Agent principal : lire sources legacy      │
│    → identifier les sections à couvrir        │
├──────────────────────────────────────────────┤
│ 2. Lancer N sub-agents en parallèle          │
│    → 1 section par agent                      │
│    → chacun écrit dans docs/research/tmp/     │
├──────────────────────────────────────────────┤
│ 3. Agent principal : assembler                │
│    → harmoniser style et format               │
│    → vérifier complétude                      │
│    → écrire le doc final                      │
├──────────────────────────────────────────────┤
│ 4. Sub-agent reviewer : valider               │
│    → cohérence, trous, erreurs                │
└──────────────────────────────────────────────┘
```

### Game Design Documents

```
┌──────────────────────────────────────────────┐
│ 1. Lire le doc réalité correspondant          │
│    (docs/research/reality-vs-simagri-X.md)    │
├──────────────────────────────────────────────┤
│ 2. Lire les règles SimAgri du système         │
│    (Docs_legacy/SimAgri/...)                  │
├──────────────────────────────────────────────┤
│ 3. Rédiger le GDD Agriva                      │
│    (docs/design/<systeme>.md)                 │
├──────────────────────────────────────────────┤
│ 4. Review (sub-agent reviewer)                │
│    → Crée une vraie décision ?                │
│    → Réaliste ?                               │
│    → Pas de trous ?                           │
└──────────────────────────────────────────────┘
```

### Code (implémentation)

```
┌──────────────────────────────────────────────┐
│ 1. Lire la spec (docs/specs/<module>.md)      │
├──────────────────────────────────────────────┤
│ 2. Écrire les types (.types.ts)               │
├──────────────────────────────────────────────┤
│ 3. Écrire les tests (.service.test.ts)        │
│    (TDD : tests d'abord)                      │
├──────────────────────────────────────────────┤
│ 4. Écrire le service (.service.ts)            │
│    → faire passer les tests                   │
├──────────────────────────────────────────────┤
│ 5. Écrire le repository (.repository.ts)      │
├──────────────────────────────────────────────┤
│ 6. Écrire le controller (.controller.ts)      │
├──────────────────────────────────────────────┤
│ 7. Tests d'intégration                        │
├──────────────────────────────────────────────┤
│ 8. Review (sub-agent)                         │
└──────────────────────────────────────────────┘
```

---

## 6. Gestion des erreurs et blocages

### Si un sub-agent crash

1. Réduire la taille du prompt
2. Découper en sous-tâches plus petites
3. Si ça crash encore → faire soi-même

### Si on est bloqué sur un problème technique

1. Documenter le blocage dans le sprint
2. Chercher dans la KB et le legacy
3. Web search si nécessaire
4. Si toujours bloqué → marquer comme `blocked`, passer à la suite, signaler en fin de session

### Si une décision est incertaine

1. Lister les options (max 3)
2. Évaluer les trade-offs
3. Si aucune option ne domine clairement → demander au humain
4. Documenter la décision dans `docs/decisions/`

---

## 7. Qualité et cohérence

### Chaque document produit est vérifié contre

- [ ] Cohérent avec `FOUNDATION.md`
- [ ] Pas de contradiction avec les décisions existantes
- [ ] Format respecté (date, statut, structure)
- [ ] Complet (pas de sections vides ou TODO)

### Chaque code produit est vérifié contre

- [ ] Tests passent
- [ ] Types stricts (pas de `any`)
- [ ] Conventions respectées (nommage, structure)
- [ ] Pas de régression sur les tests existants

---

## 8. Optimisation du contexte IA

### Le problème : le contexte est limité

Techniques pour maximiser l'efficacité :

1. **Résumer avant de passer** — entre phases, résumer ce qui est pertinent
2. **Fichiers > mémoire** — tout écrire dans des fichiers, pas garder en tête
3. **KB > relecture** — chercher dans la KB plutôt que relire 500 lignes
4. **Conventions fortes** — si le format est toujours le même, pas besoin de le rappeler
5. **Un sujet par session** — pas de multitâche, focus

### Hiérarchie de confiance des sources

```
1. Code qui compile + tests qui passent (vérité terrain)
2. Fichiers du repo (écrits et persistés)
3. Knowledge base (indexée, cherchable)
4. Mémoire de session (volatile, peut être compactée)
5. Assumptions (à vérifier avant d'agir)
```

---

## 9. Checklist pré-développement

Avant de commencer à coder (Phase 1), s'assurer que :

- [x] Document fondateur validé
- [x] Roadmap et phases définies
- [x] Environnement IA en place
- [x] Framework de gestion de projet
- [ ] Documents de référence réalité (cultures, élevage, matériel, économie, métiers)
- [ ] Game Design Documents des systèmes Phase 1
- [ ] Architecture technique (ADR stack, schéma BDD, API design)
- [ ] Specs techniques Phase 1

On en est à l'étape "Documents de référence réalité". C'est la prochaine session.
