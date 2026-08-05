# ADR-007 : Politique monétaire serveur — puits monétaires et garde-fous de prix

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décisions ouvertes #01, #03
> Impacte : `GDD-SOURCE-VERITE` §économie, `GDD-core-economie` (à créer)

## Contexte

La coopérative (bot) crée de la monnaie ex nihilo à chaque vente joueur. Avec la croissance exponentielle des cheptels (poule = ×50 ROI), la masse monétaire explose mécaniquement. Aucun puits proportionnel à la richesse n'est documenté. L'hyperinflation est mathématiquement inévitable sans intervention.

En parallèle, un marché dynamique sans garde-fous permet la manipulation de cours, les flash crashes, et la spéculation abusive par les joueurs riches.

Ces deux problèmes sont indissociables : les puits contrôlent la masse monétaire globale, les garde-fous protègent les transactions individuelles.

## Options — Puits monétaires (#01)

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Taxes progressives | Taxe transactions + impôt patrimoine | Trop agressif seul |
| B — Coop à budget limité | Budget quotidien fini, prix baisse si surproduction | Pénalise les derniers connectés |
| C — Usure/decay agressif | Dégradation proportionnelle à la valeur | Punitif si mal calibré |
| **D — Hybride léger** | Combinaison de plusieurs puits dosés | ✅ **Retenue** |

## Options — Garde-fous de prix (#03)

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Marché 100% libre | Aucune régulation | Monopoles et manipulation |
| **B — Plancher coop + plafond anti-spéc** | Coop rachète à prix plancher, plafond à +200% | ✅ **Retenue** |
| C — Vitesse d'ajustement contrôlée | Prix ±X%/jour max | Empêche la réaction à la rareté réelle |

## Décision

### 1. Puits monétaires : hybride de plusieurs mécanismes légers (Option D)

Aucun puits unique ne doit être assez fort pour frustrer un joueur. La combinaison retire la monnaie de façon répartie :

| Puits | Mécanisme | Cible |
|-------|-----------|-------|
| **Frais de transaction marché** | 3-5% de commission sur chaque vente entre joueurs | Proportionnel au volume |
| **Entretien matériel** | Coût croissant avec l'âge et la valeur (cf. ADR-006) | Proportionnel au patrimoine |
| **Charges salariales** | 2 200 €/mois par ouvrier (monnaie détruite) | Proportionnel à la taille |
| **Frais vétérinaires** | Coûts récurrents obligatoires en élevage | Proportionnel au cheptel |
| **Assurances** | Prime annuelle proportionnelle aux actifs | Proportionnel à la richesse |
| **Certification/labels** | Coûts annuels pour maintenir les labels | Drain endgame |

**Règle fondamentale** : la monnaie retirée par les puits est **détruite**, jamais redistribuée.

### 2. Garde-fous de prix marché (Option B)

| Paramètre | Valeur | Justification |
|-----------|--------|---------------|
| **Prix plancher** | 60% du prix de référence coop | Filet de sécurité |
| **Prix plafond** | 200% du prix de référence coop | Anti-manipulation |
| **Prix de référence** | Moyenne mobile 7 ticks des transactions réelles | Stabilité |
| **Capacité coop** | Illimitée en achat (au plancher) | Pas de rareté artificielle |

### 3. Addendum — HT variables comme levier de money sink (lien Décision #22)

La Décision #22 (calibrage HT) est couverte par ADR-004 (base 84 h/tick). Le coût HT variable par activité est un levier d'équilibrage indirect :

- Activités haut ROI (poule) → beaucoup de HT → embauche précoce → salaires = money sink
- Activités extensives (allaitant) → peu de HT → charges basses

L'embauche est un money sink proportionnel à l'ambition de croissance.

## Conséquences

- [ ] Calibrer le taux de commission marché (3% ou 5%)
- [ ] Définir les prix de référence initiaux Phase 3
- [ ] Implémenter le monitoring : masse monétaire, volume détruit/puits, Gini, prix vs référence
- ❌ Ne pas faire un seul puits massif (rage-quit)
- ❌ Ne pas redistribuer la monnaie détruite
- ❌ Ne pas mettre un plancher si haut que le marché joueur est inutile
