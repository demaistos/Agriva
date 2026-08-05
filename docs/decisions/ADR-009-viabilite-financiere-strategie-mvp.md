# ADR-009 : Viabilité financière et stratégie MVP

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #09
> Impacte : Roadmap, scope Phase 1-3, modèle économique projet

## Contexte

Avec 5 000 joueurs actifs (optimiste pour une niche FR) et 5% de conversion : 250 abonnés × 5€ = 1 250€/mois. Ça ne couvre pas les serveurs. Le projet risque la mort financière s'il développe les 119 systèmes avant de valider le marché.

## Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Internationalisation dès le design | EN/DE/ES/PT en V1 | Prématuré sans validation |
| **B+C — Diversification + MVP minimal** | Plusieurs sources de revenu + validation rapide | ✅ **Retenue** |
| D — Modèle passion/hobby | Financer par passion + dons | Non pérenne |

## Décision

**Options B+C combinées** — Valider le modèle économique avec un MVP monétisable AVANT de développer l'intégralité des systèmes.

### 1. Stratégie MVP : valider avant de construire

| Phase | Scope | Validation |
|-------|-------|-----------|
| **MVP (Phases 1-3)** | Cultures + marché + coop + 1 élevage simple | « Reviennent-ils et paient-ils ? » |
| **Alpha (Phase 4-5)** | + élevage complet + employés + tick robuste | « Rétention J30 > 20% ? » |
| **Beta (Phase 6+)** | Systèmes restants | Seulement si métriques MVP atteintes |

**Gate MVP → Alpha** : 500 joueurs actifs/semaine OU 100 abonnés OU revenu ≥ coût serveur × 2.

Si aucune gate atteinte après 3 mois → pivot.

### 2. Diversification des revenus

| Source | Quand | Fourchette |
|--------|-------|-----------|
| **Abonnement** | MVP | 4-8€/mois |
| **Boutique cosmétique** | Alpha | 1-5€ ponctuels |
| **Pack Fondateur** | Pré-lancement | 30-50€ one-shot |
| **Don/Tip jar** | MVP | Optionnel |
| **Internationalisation** | Post-validation FR | ×5-10 TAM |

### 3. Seuils de rentabilité

| Seuil | Calcul |
|-------|--------|
| Coûts fixes MVP | ~120€/mois (VPS + BDD + CDN + domaine) |
| Rentabilité | 25 abonnés à 5€ |
| Pérennité | 500 abonnés = 2 500€/mois |

## Conséquences

- Le scope Phase 1-3 = minimum jouable monétisable, pas le jeu complet
- Chaque feature : « ça augmente la rétention ou la conversion ? »
- Suivi métriques (DAU, J7/J30, conversion, ARPU) prioritaire dès le MVP
- ❌ Ne pas développer 2 ans sans feedback marché
- ❌ Ne pas reporter la monétisation à « plus tard »
- ❌ Ne pas construire les 119 systèmes avant validation
