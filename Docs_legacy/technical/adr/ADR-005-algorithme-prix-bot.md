# ADR-005 — Algorithme de prix bot (plancher/plafond/spread)

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Le bot de marché est le filet de sécurité de l'économie Agriva : il garantit la liquidité (toujours acheteur/vendeur en dernier recours) sans jamais être une source d'arbitrage profitable pour le joueur. Les contraintes fixées dans le decisions log sont : spread 15–25% minimum, rendements décroissants sur gros volumes (tag d'origine), et paramètres ajustables à chaud depuis le dashboard admin. Le bot ne doit pas dominer le marché (alerte si > 60% des transactions). L'algorithme doit être implémenté dès le Sprint 3.

## Options considérées

### Option A — Prix fixes en configuration

`bot_price[product]` et `bot_spread[product]` sont des constantes stockées en base de données, modifiables uniquement par un admin via le dashboard. Le prix d'achat bot = `ref_price × (1 - spread/2)`, le prix de vente bot = `ref_price × (1 + spread/2)`.

**Avantages** : simple, prévisible, entièrement contrôlé par l'équipe, aucun risque de dérive algorithmique, ajustable à chaud sans redéploiement, facile à tester (résultat déterministe).  
**Inconvénients** : nécessite une surveillance humaine régulière pour rester pertinent ; ne s'adapte pas automatiquement aux déséquilibres de marché.

### Option B — Formule dynamique basée sur l'offre/demande serveur

Le prix bot s'ajuste automatiquement selon le volume de transactions récentes : si le bot achète beaucoup (offre excédentaire), il baisse son prix d'achat ; si le bot vend beaucoup (demande excédentaire), il monte son prix de vente. Formule : `adjusted_price = ref_price × (1 + k × (demand - supply) / ref_volume)`.

**Avantages** : s'adapte automatiquement aux déséquilibres, réduit la charge de surveillance manuelle.  
**Inconvénients** : risque de dérive non contrôlée (boucles de rétroaction), complexité de calibration du paramètre `k`, comportement difficile à prédire pour les joueurs (imprévisibilité = frustration), risque d'arbitrage si la formule est exploitable, plus difficile à tester et à déboguer.

### Option C — Prix indexés sur un marché de référence simulé

Un "marché mondial simulé" génère des prix de référence qui fluctuent selon un modèle stochastique (bruit + tendances saisonnières). Le bot suit ces prix avec son spread.

**Avantages** : crée une dynamique de marché externe intéressante, les joueurs peuvent anticiper les tendances.  
**Inconvénients** : complexité de modélisation élevée, risque de déséquilibres imprévisibles, nécessite un calibrage fin pour rester jouable, hors de portée d'un petit studio en V1, reporté explicitement en V2+ dans les specs.

## Décision

**Option retenue : A — Prix fixes en configuration, avec ajustement hebdomadaire par l'équipe**

Justification : l'Option A est la seule compatible avec les contraintes V1 (petit studio, pragmatisme, contrôle total de l'économie). La règle fondamentale — "le bot est un filet de sécurité, jamais une source d'arbitrage profitable" — est plus facile à garantir avec des prix déterministes qu'avec une formule dynamique. L'Option B est écartée car le risque de dérive et d'exploitation est trop élevé sans équipe dédiée à l'économie. L'Option C est explicitement V2+.

L'ajustement "dynamique" est délégué au processus humain de LiveOps (dashboard hebdomadaire, ±10%/semaine max selon ADR-002 et tech-liveops §4) — ce qui est suffisant pour V1.

**Formule retenue** :

```
bot_buy_price[p]  = ref_price[p] × (1 - spread[p] / 2)
bot_sell_price[p] = ref_price[p] × (1 + spread[p] / 2)

// Rendements décroissants sur gros volumes (tag d'origine)
if (volume > volume_threshold[p]):
    effective_buy_price[p] = bot_buy_price[p] × (1 - decay_rate × (volume / volume_threshold[p] - 1))
    // plancher : jamais en dessous de bot_buy_price × 0.85
    effective_buy_price[p] = max(effective_buy_price[p], bot_buy_price[p] × 0.85)
```

Paramètres stockés en base (ajustables à chaud) :
- `bot_price_ref[product]` : prix de référence par produit
- `bot_spread[product]` : spread (15–25%, défaut 20%)
- `bot_volume_threshold[product]` : volume au-delà duquel les rendements décroissants s'appliquent
- `bot_decay_rate` : taux de décroissance (défaut 0.05 par tranche de threshold)

Invariant garanti par le code : `spread >= 0.15` (assertion à l'écriture en base). Toute transaction bot→joueur immédiatement suivie d'une transaction joueur→bot doit produire une perte nette pour le joueur (test automatisé dans la CI).

## Conséquences

- Le module `economy` implémente `getBotPrice(product, side, volume)` comme fonction pure testable.
- Les paramètres bot sont dans la table `AdminConfig` (clé/valeur), chargés en cache Redis au démarrage et invalidés à chaque modification admin.
- Le dashboard admin affiche le spread effectif par produit et alerte si un produit dépasse 60% de taux bot.
- Le test anti-arbitrage (`achat bot + revente bot immédiate = perte garantie`) est dans la CI dès le Sprint 3.
- L'ajustement dynamique automatique (Option B) peut être introduit en V2+ comme couche supplémentaire au-dessus de cette base, sans casser l'interface `getBotPrice`.

## Références

- `Docs/external-refinement/agriva_decisions_log_compact.md` — Market price (spread bot + tag d'origine + rendements décroissants), Spread bot (15-25% minimum)
- `Docs/specs/2026-05-07-tech-liveops-v1.md` §3 (paramètres ajustables à chaud : `bot_price`, `bot_spread`), §4 (stratégie d'équilibrage, amplitude ±10%/semaine)
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §2 Sprint 3 (bot de marché, test anti-arbitrage), §3 Risques — "Arbitrage bot non détecté en production"
- `Docs/specs/2026-05-07-economy-markets-v1.md`
