# ADR-014 : Structure d'abonnement 2 tiers — AgriPass 3,99€ / AgriPass+ 7,99€

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #07 (GDD-DECISIONS-OUVERTES)
> Impacte : `GDD-SOURCE-VERITE` §8-9, monétisation, GDD-bovin-laitier (robot de traite)

## Contexte

Le GDD-SOURCE-VERITE (§8) établit : « Premium : 3,99 €/mois — confort et cosmétique uniquement. »

L'expert monétisation identifie qu'un tier unique à 3,99€ laisse de la valeur sur la table. Les « dolphins » (joueurs prêts à payer plus pour du cosmétique/confort supplémentaire) n'ont pas d'option. Le vétéran SimAgri valide que le SimPass à ~30€/an (2,50€/mois) était perçu comme raisonnable.

Le marché 2026 (OSRS Bond = ~11€/mois, EVE = 15€/mois, Albion = 11€/mois) positionne 3,99€ et 7,99€ dans le bas de la fourchette — cohérent avec une niche francophone.

## Décision

**Option B retenue — 2 tiers : AgriPass (3,99€) + AgriPass+ (7,99€).**

### Structure

| | 🆓 Gratuit | 🌾 AgriPass (3,99€/mois) | ⭐ AgriPass+ (7,99€/mois) |
|---|---|---|---|
| **Gameplay** | 100% des mécaniques | 100% des mécaniques | 100% des mécaniques |
| **Stats** | Stats de base | Stats avancées (historiques, graphiques, comparaisons) | Stats avancées + export CSV |
| **Notifications** | À la connexion uniquement | Push/email temps réel (événements, alertes) | Push/email temps réel |
| **Badge profil** | — | Badge AgriPass | Badge AgriPass+ (animé) |
| **Fiche ferme** | Standard | Personnalisable (couleurs, bannière) | Personnalisable + galerie photos |
| **Thèmes** | Thème par défaut | 5 thèmes visuels | Thèmes illimités + thèmes exclusifs saisonniers |
| **Robot de traite** | ❌ | ✅ Achetable (150-180k€ in-game) | ✅ Achetable |
| **2ème ferme** | ❌ | ❌ | ✅ Possible (même serveur, 2ème exploitation) |
| **Concours exclusifs** | — | — | ✅ Concours cosmétiques mensuels (décorations, trophées) |
| **Skip construction** | ❌ | ✅ Construction instantanée | ✅ Construction instantanée |
| **Cosmétiques boutique** | Accès limité (basiques) | Accès catalogue complet | Accès catalogue + exclusivités |

### Clarification robot de traite (P2W ?)

Le robot de traite est verrouillé derrière l'AgriPass. Ceci **ne viole PAS** la charte « pas P2W » car :

1. **Même production** — Un joueur gratuit avec salle de traite classique produit autant de lait qu'un AgriPass avec robot. Le rendement/VL est identique.
2. **Convenience, pas avantage** — Le robot économise des HT de traite (≈2-3h/jour pour 40 VL). Le joueur gratuit utilise ces HT en traite manuelle mais obtient le même résultat.
3. **Investissement in-game requis** — Le robot coûte 150-180k€ en jeu. L'AgriPass déverrouille le droit à l'achat, pas le robot lui-même.
4. **Pas de boost de production** — ❌ pas de +lait, ❌ pas de +reproduction, ❌ pas de meilleur prix.
5. **Analogie** — C'est l'équivalent d'un thème premium : même fonctionnalité, présentation différente du temps du joueur.

**Test décisif** : « Un F2P avec le même temps de jeu atteint-il ±10% des résultats d'un AgriPass ? » → **OUI**, car il peut traire manuellement et obtenir exactement le même lait.

### Lignes rouges maintenues (SdV §9)

Les lignes rouges s'appliquent à TOUS les tiers :
- ❌ Plus de HT / Heures de Travail
- ❌ Boost de production (rendement, lait, reproduction)
- ❌ Prix préférentiels à la coop
- ❌ Accès exclusif à des cultures/animaux/matériel
- ❌ Skip de gestation, croissance culture, engraissement
- ❌ Toute accélération biologique ou productive
- ❌ Avantage compétitif dans les classements

### Pricing et positionnement

| | Prix | Equivalent annuel | vs SimPass historique |
|---|:-:|:-:|---|
| AgriPass | 3,99€/mois | ~48€/an | +60% vs SimPass (~30€/an) mais +10 ans d'inflation |
| AgriPass+ | 7,99€/mois | ~96€/an | Segment « dolphin » inexistant avant |
| Engagement annuel | -20% (3,19€ / 6,39€) | 38€ / 77€ | Verrouille le revenu |

### Objectif financier

Hypothèse : 5 000 joueurs actifs, 15% conversion (niche passionnée)

| Tier | % des payants | Revenus mensuels |
|---|:-:|:-:|
| AgriPass (750 × 3,99€) | 75% | 2 993€ |
| AgriPass+ (250 × 7,99€) | 25% | 1 998€ |
| **Total** | | **~5 000€/mois** |

Nettement supérieur au tier unique (750 × 3,99€ = 2 993€ seul).

## Conséquences

- Le GDD-SOURCE-VERITE §8 doit être mis à jour : « 3,99€/mois » → « AgriPass 3,99€/mois + AgriPass+ 7,99€/mois ».
- Le GDD-bovin-laitier (robot de traite) référence cette ADR pour la justification non-P2W.
- L'architecture doit supporter un flag `subscription_tier` (free/agripass/agripass_plus).
- La 2ème ferme (AgriPass+) est un chantier UX/technique distinct (Phase 8+).
- La boutique cosmétique est un flux de revenu complémentaire (hors scope de cette ADR).

## Alternatives rejetées

| Option | Raison du rejet |
|--------|-----------------|
| A — 1 tier unique (5€/mois) | Plafonne les revenus, ne capture pas les dolphins, pricing non-testé |
| C — 3 tiers (4€/8€/15€) | Trop de choix pour une niche FR, tier « Mécène » à 15€ sans contenu suffisant pour justifier |

## Références

- `docs/design/GDD-SOURCE-VERITE.md` §8-9 — monétisation et lignes rouges
- `docs/design/GDD-DECISIONS-OUVERTES.md` — Décision #07
- `docs/design/GDD-bovin-laitier.md` — robot de traite
