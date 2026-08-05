# Workflow : Utilisation des Sub-Agents

> Règles pour déléguer efficacement le travail aux sub-agents sans crash.

---

## Problème identifié

Les sub-agents crashent quand :
- Le prompt est trop long (>4000 chars)
- On demande trop de fichiers à lire en une fois
- Le livrable attendu est trop massif (>800 lignes)

## Règles d'utilisation

### 1. Un sub-agent = UNE tâche précise

❌ Mauvais :
```
"Lis 12 fichiers et produis un document de 3000 lignes couvrant 13 sujets"
```

✅ Bon :
```
"Lis 03-cultures.md et produis la section Préparation du sol (réalité vs SimAgri)"
```

### 2. Taille de prompt : max 2000 caractères

Si le prompt dépasse 2000 chars, découper en plusieurs sub-agents avec dépendances.

### 3. Découpage par section

Pour un gros document de recherche, lancer N sub-agents en parallèle (un par section) :

```
Stage 1: section-sol        → produit section-sol.md
Stage 2: section-semis      → produit section-semis.md  
Stage 3: section-recolte    → produit section-recolte.md
...
Stage final: assemblage     → depends_on: [1,2,3...] → assemble le doc final
```

### 4. Fichiers à lire : max 2-3 par sub-agent

Si un sub-agent doit lire plus de 3 fichiers, l'agent principal lit d'abord et synthétise le contexte dans le prompt.

### 5. Livrable : max 300 lignes par sub-agent

Au-delà, découper. Mieux vaut 4 sub-agents de 200 lignes qu'un seul qui crash à 800.

### 6. Toujours écrire dans un fichier

Le sub-agent DOIT écrire son résultat dans un fichier (pas juste le retourner en texte). Ça garantit la persistance même si la session crash.

---

## Pattern type : Document de recherche

Pour produire un document exhaustif (ex: réalité agricole), utiliser ce pattern :

```
Étape 1 : Agent principal lit les sources legacy (2-3 fichiers)
Étape 2 : Agent principal découpe en N sections
Étape 3 : Lancer N sub-agents en parallèle, chacun écrit sa section
Étape 4 : Agent principal assemble et harmonise
```

### Exemple concret pour "Élevage réel vs SimAgri"

```json
{
  "stages": [
    {"name": "bovins-lait", "prompt": "Écris dans docs/research/tmp/elevage-bovins-lait.md..."},
    {"name": "bovins-viande", "prompt": "Écris dans docs/research/tmp/elevage-bovins-viande.md..."},
    {"name": "porcins", "prompt": "Écris dans docs/research/tmp/elevage-porcins.md..."},
    {"name": "ovins-caprins", "prompt": "Écris dans docs/research/tmp/elevage-ovins-caprins.md..."},
    {"name": "volailles", "prompt": "Écris dans docs/research/tmp/elevage-volailles.md..."},
    {"name": "alimentation", "prompt": "Écris dans docs/research/tmp/elevage-alimentation.md..."},
    {"name": "reproduction", "prompt": "Écris dans docs/research/tmp/elevage-reproduction.md..."},
    {"name": "sante", "prompt": "Écris dans docs/research/tmp/elevage-sante.md..."}
  ]
}
```

Puis l'agent principal assemble `docs/research/reality-vs-simagri-elevage.md`.

---

## Pattern type : Implémentation code

```json
{
  "stages": [
    {"name": "types", "prompt": "Crée src/modules/culture/culture.types.ts..."},
    {"name": "service", "prompt": "Crée src/modules/culture/culture.service.ts...", "depends_on": ["types"]},
    {"name": "tests", "prompt": "Crée les tests pour culture.service...", "depends_on": ["service"]},
    {"name": "review", "prompt": "Review le code produit...", "depends_on": ["tests"]}
  ]
}
```

---

## Quand NE PAS utiliser de sub-agent

- Tâche simple (<15 min de travail) → faire soi-même
- Besoin de beaucoup de contexte → faire soi-même
- Document qui nécessite une cohérence forte entre sections → faire soi-même puis review par sub-agent
