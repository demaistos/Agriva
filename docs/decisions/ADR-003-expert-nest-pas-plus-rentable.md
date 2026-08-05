# ADR-003 : Expert n'est pas plus rentable que Normal — c'est un style de jeu

> Date : 2026-08-04
> Statut : **Contrainte levée par ADR-005** (document conservé comme référence historique)
> Auteur : agent:game-designer
> Complète : ADR-001 (modes de jeu), ADR-002 (recette SimAgri en Normal)

> ⚠️ **AVERTISSEMENT — la contrainte principale de cet ADR est levée**
>
> Cet ADR établissait qu'**« Expert n'est pas plus rentable que Normal »**. Cette contrainte
> existait parce que les deux populations partageaient un monde, un marché et des classements :
> si Expert avait rapporté davantage, Normal aurait été « le mauvais choix ».
>
> **L'ADR-005 a séparé les deux univers en deux serveurs distincts.** Les joueurs ne partagent
> plus ni marché ni classement. Aucun arbitrage n'est donc possible entre les deux, et la
> contrainte d'équivalence de rentabilité n'a plus d'objet.
>
> **Nouvelle règle** : chaque serveur doit être **internement** équilibré et plaisant. Aucune
> comparaison de rentabilité entre serveurs n'est nécessaire.
>
> **Ce qui reste utile dans ce document** : l'analyse de la proposition de valeur du mode Expert
> (compréhension, contrôle, profondeur), les 8 leviers de gain identifiés, et la justification
> du taux de charges à 28% (taux effectif réel après optimisation fiscale).
>
> Voir `ADR-005-deux-serveurs-separes.md`.

## Contexte

En rédigeant les 4 premiers GDD (économie, cultures, matériel, bovin laitier), le même problème est apparu **systématiquement** dans les scénarios d'équilibrage :

**Le joueur Expert dégage un produit brut supérieur mais un revenu net inférieur au joueur Normal.**

| GDD | Produit brut Expert | Revenu net Normal | Revenu net Expert |
|-----|:-------------------:|:-----------------:|:-----------------:|
| Économie (GC 60 ha) | +10 362 € | 33 634 € | 26 482 € |
| Cultures (blé 18 ha) | +2 000 € | 1 555 €/ha | 1 587 €/ha (+2%) |
| Matériel (145 ha) | — | 376 €/ha de coût | 350 €/ha (-7%) |
| Bovin laitier (60 VL) | +45 916 € | 47 111 € | 22 387 € |

**Cause structurelle** : les charges sociales du mode Expert (35% + IR progressif) sont trois fois supérieures à celles du mode Normal (12%). Aucun gain d'optimisation ne compense cet écart sur des structures moyennes.

## Options

| Option | Description | Problème |
|--------|-------------|----------|
| **A** | Réduire les charges Expert à 28% | Atténue sans résoudre ; réduit le réalisme |
| **B** | Augmenter les charges Normal à 18-20% | Viole l'ADR-002 (freine la progression) |
| **C** | Ajouter un bonus artificiel au mode Expert | Incohérent, factice |
| **D** | Renforcer massivement les leviers Expert | Déséquilibre le réalisme des rendements |
| **E** | Assumer que Expert ≠ plus rentable | Demande de clarifier la proposition de valeur |

## Décision

**Option E, complétée par A.**

### 1. Le mode Expert n'est pas conçu pour être plus rentable

Le mode Expert apporte de la **profondeur**, pas de la **performance financière**. Sa proposition de valeur :

| Ce qu'Expert apporte | Ce qu'Expert ne promet pas |
|---------------------|---------------------------|
| Comprendre pourquoi ça marche ou pas | Gagner plus d'argent |
| Piloter finement son exploitation | Progresser plus vite |
| Réagir aux crises avec des outils | Éviter les problèmes |
| Progression génétique/agronomique long terme | Rendements supérieurs immédiats |
| Réalisme de simulation | Facilité |

**Analogie** : dans un jeu de course, le mode simulation n'est pas plus rapide que le mode arcade. Il est plus exigeant et plus gratifiant pour ceux qui aiment ça.

### 2. Là où Expert devient réellement avantageux

Le mode Expert prend l'avantage dans quatre situations :

```
✅ GRANDES STRUCTURES (> 250 ha, > 100 VL)
   L'optimisation se démultiplie avec le volume.
   Un gain de 2 €/1000 L sur 1 million de litres = 2 000 €.

✅ VALORISATION DU TEMPS LIBÉRÉ
   Le robot de traite libère 732 h/an → diversification possible
   (prestation ETA, cultures supplémentaires, transformation).

✅ LONG TERME (10+ ans)
   Progression génétique cumulative (+20 pts ISU),
   amélioration de la structure du sol, réputation ETA.

✅ SITUATIONS DE CRISE
   Le joueur Expert dispose des outils (DEP, contrats, assurance,
   diagnostic) pour absorber une sécheresse ou un crash de prix.
   Le joueur Normal subit.
```

### 3. Ajustement des charges Expert : 35% → 28%

Même si l'écart de rentabilité est assumé, un taux de 35% était excessif.

**Justification du 28%** : la MSA réelle est de 35-45% du revenu professionnel, mais s'applique **après** de nombreuses déductions que le jeu ne modélise pas (DEP, amortissements dégressifs, déficits reportables, optimisation du statut juridique en société, exonérations JA). Le taux effectif réel d'un exploitant qui optimise se situe autour de 28-32%.

Puisque le mode Expert représente précisément un joueur qui optimise, **28% est le taux effectif cohérent**.

## Conséquences

### Sur les GDD existants
- [x] GDD-bovin-laitier : charges Expert notées à 28%
- [ ] GDD-economie-base : réviser 35% → 28% (§2.2, annexe)
- [ ] GDD-cultures : pas de charges sociales (pas d'impact)
- [ ] GDD-materiel : pas de charges sociales (pas d'impact)

### Sur la communication en jeu
L'écran de choix du mode doit être explicite :

```
┌─ Choisir votre mode de jeu ────────────────────────────────────┐
│                                                                 │
│  🌾 NORMAL — « Je veux gérer ma ferme »                          │
│     • Progression fluide et gratifiante                         │
│     • Décisions claires, résultats lisibles                     │
│     • Charges allégées (12%)                                    │
│     • Jamais de faillite                                        │
│     → Recommandé pour découvrir le jeu                          │
│                                                                 │
│  🔬 EXPERT — « Je veux comprendre et optimiser »                 │
│     • Simulation agronomique et économique réaliste             │
│     • Chaque décision technique compte                          │
│     • Charges réelles (28%), risques réels                      │
│     • Progression long terme (génétique, sol, réputation)       │
│     ⚠️ Pas plus rentable — plus exigeant et plus profond         │
│     → Recommandé si vous aimez la technique agricole            │
│                                                                 │
│  💡 Vous pourrez passer de Normal à Expert à tout moment.        │
│     L'inverse nécessite de repartir sur une nouvelle ferme.     │
└─────────────────────────────────────────────────────────────────┘
```

### Sur les futurs GDD
Chaque GDD doit valider que :
1. Le mode Normal est viable et gratifiant (ADR-002)
2. Le mode Expert apporte de la **compréhension** et du **contrôle**, sans promettre plus de revenu
3. L'avantage Expert se manifeste sur les grandes structures, le temps libéré, le long terme, ou la gestion de crise

### Ce qu'il ne faut PAS faire
- ❌ Gonfler artificiellement les gains Expert pour "compenser"
- ❌ Dégrader le mode Normal pour créer un écart
- ❌ Laisser croire au joueur qu'Expert = plus d'argent
