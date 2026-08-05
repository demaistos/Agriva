# Agriva — Architecture de Game Design

> Architecture des systèmes de jeu, composants et flux de données.

## 1. Vue d'ensemble

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Systèmes    │────▶│  Économie    │────▶│  Joueur      │
│  (farming,   │     │  (bot,       │     │  (UI, prog,  │
│   sols, météo)│     │   marché)    │     │   social)    │
└──────────────┘     └──────────────┘     └──────────────┘
```

## 2. Systèmes de jeu

| Système | Domaine | Mode Normal | Mode Expert |
|---------|---------|-------------|-------------|
| **Cultures** | Grandes cultures, maraîchage | Fertilité + humidité | NPK + MO + pH + rotations |
| **Élevage** | Ateliers animaux | Santé + production | Rations, génétique, cycles |
| **Météo** | Régionale + modificateurs | Prévision simple | Incertitude détaillée |
| **Foncier** | Parcelles, territoire | Achat/location | Fusion, optimisation |
| **Stockage** | Capacités, logistique | Coût + délai | Optimisation flux |
| **Transformation** | Chaînes simples | Valeur ajoutée | Filières (V2+) |

## 3. Flux économiques

```
Production → Stockage → [Bot (filet) | Marché joueur (optimal)] → Revenus → Investissement
                                                                              ↓
                                                              Agrandissement / Spécialisation / Diversification
```

## 4. Couches de progression

| Phase | Contenu |
|-------|---------|
| Année 1 | Prise en main + activité principale |
| Années 2–3 | Agrandissement + début spécialisation |
| Suite | Diversification maîtrisée + montée en gamme |

## 5. Territoire

- Département + bassins locaux
- Impact sur : météo, marchés, logistique, spécialisations
- Coop bot : une par département (préfecture)

## 6. Architecture Decision Records (ADR)

Voir `Docs/external-refinement/agriva_decisions_log.md` pour le log complet des décisions.
