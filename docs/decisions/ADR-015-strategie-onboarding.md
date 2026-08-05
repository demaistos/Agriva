# ADR-015 : Stratégie d'onboarding — Hybride guidé 30 min puis monde ouvert

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #12 (GDD-DECISIONS-OUVERTES)
> Impacte : UX flow Phase 3, design système tutoriel, GDD-onboarding (à créer)

## Contexte

Le jeu a 119 sous-systèmes. Même la Phase 3 minimale demande de comprendre : sols, météo, matériel, HT, bâtiments, stockage ET cultures = 7 systèmes interconnectés.

**Données clés :**
- 40%+ d'abandon avant la première action productive est le scénario sans onboarding structuré.
- La rétention moderne exige une « First Meaningful Action » en < 5 minutes.
- Le vétéran SimAgri veut pouvoir skipper (il connaît déjà les mécaniques).
- Le casual ne reviendra jamais s'il ne comprend pas quoi faire dans les 5 premières minutes.

Les deux audiences sont contradictoires : le vétéran demande la liberté totale immédiate, le nouveau demande un guidage serré.

## Décision

**Option D retenue — Tutoriel guidé 30 min (skippable) puis monde ouvert avec aide contextuelle.**

### Phase 1 : Tutoriel guidé (0-30 min)

```
┌─────────────────────────────────────────────────────────┐
│  INSCRIPTION → CHOIX DU KIT → TUTORIEL GUIDÉ            │
│                                                          │
│  Minute 0-2 :  "Bienvenue sur votre exploitation"        │
│                Vue panoramique de la ferme                │
│                                                          │
│  Minute 2-5 :  PREMIÈRE ACTION PRODUCTIVE               │
│                Kit Cultivateur → "Semez ce blé"           │
│                Kit Éleveur → "Nourrissez vos vaches"      │
│                Kit Aviculteur → "Ramassez vos œufs"       │
│                Kit Polyvalent → "Labourez cette parcelle" │
│                                                          │
│  Minute 5-15 : BOUCLE COMPLÈTE                           │
│                Action → résultat → vente → argent         │
│                Le joueur comprend le cycle complet        │
│                                                          │
│  Minute 15-30 : PREMIÈRE DÉCISION LIBRE                  │
│                 "Que voulez-vous faire maintenant ?"      │
│                 3 suggestions contextuelles               │
│                 (acheter du matériel / agrandir / vendre) │
│                                                          │
│  [SKIP] disponible à tout moment pour les vétérans       │
└─────────────────────────────────────────────────────────┘
```

#### Principes du tutoriel

| Règle | Justification |
|-------|---------------|
| **1 concept à la fois** | Pas de surcharge cognitive — sol, météo, rotation sont cachés |
| **Action immédiate** | Le joueur FAIT quelque chose en < 2 min, pas de lecture |
| **Récompense visible** | L'action produit un résultat monétaire visible (« +450€ ») |
| **Skip explicite** | Bouton « Je connais déjà » toujours visible, pas caché |
| **Adapté au kit** | Le tutoriel s'adapte au kit choisi (pas de blé pour l'éleveur) |
| **Pas de blocage** | Si le joueur sort du rail, il peut y revenir (pas de fail state) |

### Phase 2 : Monde ouvert + Aide contextuelle (post-tutoriel)

Après les 30 premières minutes (ou après skip), le joueur est en monde ouvert total. L'aide contextuelle intervient **uniquement quand le joueur semble bloqué** :

| Signal de blocage | Aide proposée |
|-------------------|---------------|
| Inactif >3 min sur un écran | Bulle « Besoin d'aide ? » (discret, coin bas-droit) |
| Première utilisation d'un système | Tooltip explicatif (1 phrase + lien « En savoir plus ») |
| Erreur de manipulation | Message explicatif (« Vous n'avez pas assez de semences — en acheter ? ») |
| Première saison | « C'est l'automne ! Voici ce que vous pouvez faire... » |

#### Ce que l'aide NE fait PAS

- ❌ Pop-up intrusif non-demandé
- ❌ Blocage de l'interface (« Vous devez cliquer ici »)
- ❌ Recommandation de stratégie (« Faites des poules c'est mieux ») — cf. ADR-012
- ❌ Remplacement du joueur (pas d'auto-action)

### Métriques de succès

| Métrique | Cible | Seuil d'alerte |
|----------|:-----:|:-:|
| % joueurs complétant le tutoriel | > 70% | < 50% |
| Temps médian First Meaningful Action | < 5 min | > 10 min |
| Rétention J1 (revient le lendemain) | > 50% | < 30% |
| Rétention J7 | > 25% | < 15% |
| % vétérans qui skip | > 40% | < 20% (= tutoriel trop facile à rater) |

### Livrable requis avant Phase 3

- Wireframes « First 5 Minutes » pour chaque kit (4 variantes)
- Validation par 5 tests utilisateurs (3 néophytes + 2 vétérans SimAgri)
- Flowchart complet du tutoriel avec tous les états possibles (skip, échec, retour)

## Conséquences

- Un système de tutoriel/onboarding doit être architecturé (state machine par joueur).
- L'UI doit supporter le mode « guidé » (highlight d'éléments, restriction de navigation) ET le mode libre.
- L'aide contextuelle nécessite un système de tracking d'activité (détection d'inactivité, first-use).
- Le serveur Expert (ADR-005) peut avoir un tutoriel allégé ou absent (cohérent avec son positionnement).

## Alternatives rejetées

| Option | Raison du rejet |
|--------|-----------------|
| A — Mode guidé obligatoire | Les vétérans fuient — condescendant pour ceux qui connaissent |
| B — Déblocage progressif (type RPG) | Anti-sandbox, frustrant pour les connaisseurs, tue la liberté |
| C — Exploration libre + aide contextuelle seule | Mur cognitif intact pour les casuals, 40%+ d'abandon garanti |

## Références

- `docs/design/GDD-DECISIONS-OUVERTES.md` — Décision #12
- `docs/design/GDD-SOURCE-VERITE.md` §7 — serveurs Normal vs Expert
- ADR-005 — deux serveurs séparés (le tutoriel peut varier)
