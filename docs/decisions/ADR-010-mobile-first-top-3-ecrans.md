# ADR-010 : Mobile-first pour les 3 écrans principaux

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #13
> Impacte : UI/UX, architecture front-end, design system

## Contexte

Le jeu repose sur des tableaux (catalogues matériel, annonces marché, lots d'animaux). Un tableau 8+ colonnes est illisible sur 375px. Le responsive classique (desktop-first) produit une expérience mobile dégradée. Promettre « jouable sur mobile » sans design mobile-first = promesse non tenue.

Mais un mobile-first intégral double le coût de design pour un bénéfice marginal sur les écrans secondaires.

## Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Mobile-first intégral | Toutes les interfaces pour le pouce | Coût ×2, desktop vide |
| **B — Mobile-first top 3 écrans** | Les 3 écrans les plus fréquents en mobile-first | ✅ **Retenue** |
| C — Desktop-first + responsive | Adaptation technique mobile | Mobile = citoyen 2nde classe |
| D — App compagnon simplifiée | Desktop complet, mobile simplifié | Deux interfaces à maintenir |

## Décision

**Option B** — Design mobile-first pour les 3 écrans les plus utilisés, responsive classique pour le reste.

### Les 3 écrans mobile-first

| # | Écran | Usage mobile typique |
|---|-------|---------------------|
| 1 | **Dashboard** | « Que se passe-t-il ? » — 30 sec |
| 2 | **Actions parcelle** | « Je lance un labour depuis le bus » — 2 min |
| 3 | **Marché** | « Bonne affaire, je saute dessus » — 1 min |

### Principes mobile-first (ces 3 écrans uniquement)

| Principe | Règle |
|----------|-------|
| Touch-first | Zones cliquables ≥ 44px |
| Viewport 375px | iPhone SE comme référence minimale |
| Pas de tableau > 3 colonnes | Cartes empilées ou listes expansibles |
| Actions en bas | Pouce = zone basse |
| Info progressive | Résumé visible, détails en tap |

### Le reste : responsive classique

Écrans secondaires (admin, paramètres, statistiques, gestion personnel, catalogues) = desktop-first avec responsive technique (scroll horizontal ou mode carte sous 768px).

### Breakpoints

| Breakpoint | Nom |
|------------|-----|
| < 480px | `mobile` |
| 480-768px | `tablet-portrait` |
| 768-1024px | `tablet-landscape` |
| > 1024px | `desktop` |

## Conséquences

- [ ] Prototypes Figma mobile (375px) des 3 écrans — avant tout code front
- [ ] Design system avec composants mobile-first (Card, ActionBar, ExpandableList)
- [ ] Tests utilisateurs mobile (5 testeurs min) avant implémentation
- Les 3 écrans : CSS min-width (mobile-first), le reste : max-width (desktop-first)
- ❌ Ne pas designer tous les écrans en mobile-first
- ❌ Ne pas utiliser de tableaux HTML classiques pour le marché
- ❌ Ne pas mettre les boutons d'action en haut sur mobile
