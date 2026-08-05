# ADR-013 : Mécanisme de prix dynamiques — Plancher coop + Plafond anti-spéculation

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #03 (GDD-DECISIONS-OUVERTES)
> Impacte : `GDD-SOURCE-VERITE` §3, architecture marché, module coopérative

## Contexte

Le GDD-SOURCE-VERITE (§3) établit :
- La **coopérative (bot)** achète et vend à prix fixe — filet de sécurité.
- Le **marché joueurs** fonctionne en carnet d'ordres (order book) avec matching automatique.

Sans garde-fous sur le marché joueurs, les risques documentés sont :
1. **Manipulation de cours** — un joueur riche achète tout le stock d'un produit → prix ×5.
2. **Flash crash** — revente massive → prix → 0, les petits joueurs sont ruinés.
3. **Monopole** — 2-3 joueurs contrôlent des pans entiers de l'économie.
4. **Frustration nouveaux** — les prix affichés ne correspondent à aucune réalité pour eux.

Le vétéran SimAgri confirme que la manipulation des concessionnaires était un problème récurrent (dumping, monopole de zone).

## Décision

**Option B retenue — Plancher coopérative + Plafond anti-spéculation.**

### 1. Plancher : la Coop rachète toujours

```
PRIX PLANCHER = prix_coop_achat (fixe, connu de tous)

Règle : la coopérative achète TOUJOURS à son prix catalogue.
         Le joueur a TOUJOURS un débouché garanti.
         Aucun joueur ne peut être « piégé » avec un produit invendable.
```

| Caractéristique | Valeur |
|-----------------|--------|
| Visibilité | Affiché clairement sur chaque fiche produit |
| Variabilité | Fixe par produit, révisé uniquement par patch (jamais dynamique) |
| Budget | Illimité (la coop est un bot — pas de limite quotidienne sur les achats plancher) |
| Fonction | Filet de sécurité, pas prix optimal — le joueur rationnel vend au marché |

### 2. Plafond : anti-spéculation

```
PRIX PLAFOND = prix_moyen_30j × 2,5

Règle : aucune offre d'achat ou de vente ne peut être placée
         au-dessus du plafond sur le marché joueurs.
```

| Caractéristique | Valeur |
|-----------------|--------|
| Base de calcul | Moyenne pondérée des transactions des 30 derniers jours IG |
| Multiplicateur | ×2,5 (laisse de la marge pour la rareté réelle) |
| Initialisation | Au lancement du serveur, plafond = prix_coop × 3 (pas d'historique) |
| Affichage | Visible sur le carnet d'ordres (« prix max autorisé ») |
| Révision | Recalculé chaque tick (glissant 30 jours IG) |

### 3. Zone de prix libre

```
┌─────────────────────────────────────────┐
│  PLAFOND (prix_moyen × 2,5)             │  ← Aucune transaction au-dessus
│  ╔═══════════════════════════════════╗   │
│  ║  ZONE LIBRE                       ║   │  ← Marché joueurs, offre/demande
│  ║  (order book classique)           ║   │
│  ╚═══════════════════════════════════╝   │
│  PLANCHER (prix coop fixe)              │  ← Vente garantie, toujours
└─────────────────────────────────────────┘
```

Le joueur évolue librement entre plancher et plafond. L'économie fonctionne normalement (offre/demande, concurrence) dans cette bande.

### 4. Cas limites

| Situation | Comportement |
|-----------|-------------|
| Surproduction massive (ex : trop de poules) | Le prix marché descend vers le plancher — la coop absorbe le surplus. Le signal est clair : « change de production ». |
| Pénurie réelle (ex : sécheresse → pas de blé) | Le prix monte vers le plafond — la rareté est récompensée, mais pas exploitable à l'infini. |
| Nouveau produit (pas d'historique) | Plafond = prix_coop × 3 pendant les 30 premiers jours IG. |
| Produit jamais échangé (marché mort) | Le joueur vend à la coop. Le plafond reste théorique. |

### 5. Ce que cette ADR ne couvre PAS

- **Les puits monétaires** (money sinks) — traités séparément (Décision #01, futur ADR).
- **Les taxes sur transaction** — il n'y en a pas (SdV §3 : « Pas de taxes sur les transactions »).
- **La régulation des concessionnaires/ETA** — traité dans la Décision #24 (anti-monopole, pré-beta).
- **La saturation marché par profil** — mécanisme lié à ADR-012 (ROI par profil).

## Conséquences

- Le module marché doit implémenter le plafond comme un hard cap sur les ordres.
- La coop doit accepter toute quantité au prix plancher (pas de budget fini — cf. Option B rejetée en #01).
- Le prix_moyen_30j est une vue matérialisée recalculée à chaque tick.
- L'UI marché affiche clairement la bande [plancher — plafond] pour chaque produit.
- Un joueur ne peut jamais perdre son investissement de manière catastrophique (plancher = filet).

## Alternatives rejetées

| Option | Raison du rejet |
|--------|-----------------|
| A — Marché 100% libre | Monopoles, manipulation, frustration des nouveaux — inacceptable pour la rétention |
| C — Vitesse d'ajustement contrôlée (±X%/jour) | Empêche la réaction à la rareté réelle, mécanisme opaque |

## Références

- `docs/design/GDD-SOURCE-VERITE.md` §3 — économie de base
- `docs/design/GDD-DECISIONS-OUVERTES.md` — Décision #03
- ADR-012 — le plancher/plafond interagit avec la saturation marché (nerf poule)
