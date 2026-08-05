# ADR-012 : Équilibrage ROI par profil — Cible ×2 à ×10 pour tous

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #02 (GDD-DECISIONS-OUVERTES)
> Impacte : `etude-economique-profils-joueurs.md`, GDD-aviculture, GDD-bovin-allaitant, équilibrage global

## Contexte

L'étude économique révèle un déséquilibre massif entre profils :

| Profil | ROI sur 4 ans IG (48 mois) | Investissement initial |
|--------|:-:|:-:|
| Aviculteur (poule) | ×50-100 | quasi-nul (kit fourni) |
| Laitier | ×3-5 | élevé (bâtiment + cheptel) |
| Céréalier | ×2-3 | moyen (kit cultivateur) |
| Allaitant | ×0,7-0,9 | moyen |

La poule est « Tier S » : investissement nul, revenu immédiat, croissance exponentielle par reproduction à la ferme. Tout joueur rationnel fait des poules. La diversité de gameplay est une illusion quand l'économie punit la diversification.

Le vétéran SimAgri confirme : la « méta poule » était un problème connu, source de frustration pour les éleveurs bovins et de monotonie sur les serveurs matures.

## Décision

**Option D retenue — Cible ×2 à ×10 pour tous les profils sur 4 ans IG.**

Combinaison de trois leviers :

### 1. Nerf Poule — Réduction du ROI de ×50-100 à ×8-10

| Levier | Mécanisme | Impact |
|--------|-----------|--------|
| **HT élevé (gestion manuelle intensive)** | Ramassage œufs, nourrissage, nettoyage, soins = coûteux en temps. Pas d'automatisation sans employé dédié. 1 poule ≈ 0,15 HT/jour de gestion (vs 0,02 pour une VA extensif). | Plafonne le cheptel gérable par un joueur seul à ~80-100 poules |
| **Bâtiment coûteux** | Poulailler aux normes = 150-200 €/m² (vs 50 €/m² SimAgri). Extension = investissement significatif. | Freine la croissance exponentielle gratuite |
| **Reproduction limitée** | 1 couvée/2 mois IG par poule (au lieu de chaque mois). Taux d'éclosion 60-70% (mortalité poussins). | Divise par 3-4 la vitesse de multiplication |
| **Saturation marché** | Prix des œufs chute si l'offre serveur dépasse la demande (élasticité -0,5). Coop réduit ses achats si surproduction. | Régulation naturelle en late-game |

**Résultat attendu** : un aviculteur atteint ×8-10 de ROI sur 4 ans, pas ×50-100.

### 2. Buff Allaitant — Augmentation du ROI de ×0,7-0,9 à ×2-3

| Levier | Mécanisme | Impact |
|--------|-----------|--------|
| **Aides PAC couplées** | 200 €/VA/an (vs 100-160 € actuels). Versement automatique chaque année IG. | +40% de revenu net/VA |
| **Prime extensivité** | +80 €/VA si chargement < 1,0 UGB/ha. Récompense le modèle extensif. | Avantage structurel au profil allaitant |
| **Prime Bio** | +120 €/VA si passage en bio (label accessible après 24 mois IG de conversion). | Objectif moyen terme motivant |
| **Faible coût HT** | L'allaitant consomme très peu de HT (extensif, pas de traite, pâturage) → le joueur peut diversifier. | Liberté de gameplay compensant le revenu brut faible |

**Résultat attendu** : un naisseur allaitant atteint ×2-3 de ROI sur 4 ans (contre ×0,7-0,9 sans intervention).

### 3. Bande cible universelle

```
TOUT profil doit se situer entre ×2 et ×10 de ROI sur 4 ans IG (48 mois).

┌──────────────────────────────────────────────────────────┐
│  ×1    ×2        ×5         ×8    ×10                    │
│   │─────[=========BANDE VIABLE=========]─────│          │
│         Allaitant    Céréalier  Laitier  Poule           │
└──────────────────────────────────────────────────────────┘
```

| Profil | ROI cible 4 ans | Mécanisme principal de revenu |
|--------|:-:|---|
| Allaitant | ×2-3 | Aides PAC + primes + vente broutards + diversification |
| Céréalier | ×3-5 | Marge/ha × surface + rotation optimisée |
| Laitier | ×4-6 | Cash-flow lait régulier + reproduction progressive |
| Aviculteur | ×8-10 | Triple revenu (œufs/poussins/viande) mais plafonné par HT/bâtiment |

### Invariants

1. **Aucun profil ne doit être « la bonne réponse »** — chaque profil offre un gameplay distinct avec ses propres satisfactions.
2. **Le ROI n'est pas le seul critère de fun** — l'allaitant est « pépère » (peu de HT, peu de stress), la poule est « intense » (beaucoup de micro-gestion).
3. **La saturation marché empêche le monoculture serveur** — si 80% des joueurs font des poules, le prix s'effondre et l'allaitant devient plus rentable.
4. **Les chiffres sont des cibles de calibrage**, pas des valeurs finales. Simulation headless requise (cf. Décision #21) pour valider avant alpha.

## Conséquences

- L'étude économique doit être révisée avec les nouveaux paramètres.
- Le GDD-aviculture doit intégrer les coûts HT élevés et la reproduction limitée.
- Le GDD-bovin-allaitant doit documenter les aides PAC et primes.
- Un tableur de simulation ROI est requis avant le premier commit économie.
- La saturation marché est liée à ADR-013 (mécanisme de prix dynamiques).

## Alternatives rejetées

| Option | Raison du rejet |
|--------|-----------------|
| A — Nerf poule seul | Ne résout pas le problème allaitant (toujours non-viable) |
| B — Buff profils faibles seul | L'écart reste trop large, la poule domine toujours |
| C — Saturation marché seule | Pénalise les late joiners, le premier arrivé gagne |

## Références

- `docs/design/etude-economique-profils-joueurs.md` — données de base
- `docs/design/GDD-DECISIONS-OUVERTES.md` — Décision #02
- `docs/design/reality-vs-simagri-elevage.md` — comparaison réalité/SimAgri
