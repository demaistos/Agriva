# ADR-016 : Boucles de feedback et rétention — 3 échelles + politique d'absence

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décisions ouvertes #14 (micro-feedback loops) + #15 (politique d'absence)
> Impacte : UX core loop, système de notifications, design mobile, contrat joueur

## Contexte

**Problème de rétention temporelle** : 1 semaine réelle = 1 mois in-game. Un cycle culture complet = plusieurs semaines réelles. Le joueur casual ne verra pas le fruit de ses actions avant 2-3 semaines. La rétention moderne exige un feedback en 48h max. Sans récompense intermédiaire, la rétention J7 sera < 20%.

**Problème d'absence** : Si un joueur part 2 semaines (= 2 mois IG), que se passe-t-il ? Le vétéran SimAgri rapporte que rater une fenêtre de récolte (2 jours réels) = perte d'une saison entière. C'est inacceptable pour un jeu casual qui cible aussi les joueurs occasionnels.

Ces deux problèmes sont liés : ils concernent la relation du joueur au temps et sa peur de « rater quelque chose » ou de « ne rien voir se passer ».

## Décision

### Partie 1 — Feedback à 3 échelles (Décision #14, Option D)

```
┌────────────────────────────────────────────────────────────┐
│  ÉCHELLE 5 MIN (micro-session)                              │
│  → Chaque connexion de 5 min permet 1+ action productive    │
│  → Feedback immédiat : "Récolte : +12 450€", "+3 veaux nés" │
│  → Le joueur repart avec un sentiment d'accomplissement     │
├────────────────────────────────────────────────────────────┤
│  ÉCHELLE QUOTIDIENNE (daily login)                           │
│  → Récapitulatif d'absence : "Pendant votre absence..."     │
│  → Micro-événements positifs aléatoires ("Prime qualité!")   │
│  → Tâches optionnelles contextuelles (pas de "daily quest")  │
├────────────────────────────────────────────────────────────┤
│  ÉCHELLE HEBDOMADAIRE (bilan mensuel IG)                     │
│  → Chaque fin de mois IG = récap célébratoire               │
│  → Progression visible : graphiques, comparaisons, records   │
│  → "Ce mois-ci : +15% de patrimoine, nouveau record lait"  │
└────────────────────────────────────────────────────────────┘
```

#### Échelle 5 min — Session productive minimale

| Principe | Implémentation |
|----------|---------------|
| **1 action = 1 feedback visuel** | Toute action produit un retour chiffré immédiat (€, kg, L, naissances) |
| **Dashboard actionnable** | En 30 secondes, le joueur voit ce qui demande attention |
| **Actions rapides priorisées** | « Vendre votre récolte stockée » = 1 clic, feedback immédiat |
| **Pas de calcul mental** | Les gains sont affichés en clair, pas noyés dans un tableau |

#### Échelle quotidienne — Récapitulatif à la connexion

À chaque connexion après absence >6h :

```
┌─────────────────────────────────────────┐
│  📋 Pendant votre absence (2 ticks) :    │
│                                          │
│  🥛 Lait produit : 1 760 L (+8 800€)    │
│  🥚 Œufs ramassés : 340 (+680€)         │
│  🌡️ Météo : 2 jours de pluie (OK)       │
│  ⚠️ Attention : silo blé à 85%          │
│                                          │
│  💡 Suggestion : vendre 20T de blé      │
│     (prix marché : 218€/T = +4 360€)    │
│                                          │
│  [Vendre maintenant] [Plus tard]         │
└─────────────────────────────────────────┘
```

**Règles du récap** :
- Toujours positif en premier (revenus, naissances, récoltes)
- Alertes séparées (jamais mélangées aux bonnes nouvelles)
- Maximum 5 lignes (pas de wall of text)
- 1 suggestion actionnable (optionnelle, jamais obligatoire)

#### Échelle hebdomadaire — Bilan mensuel IG

Chaque fin de mois in-game (= chaque semaine réelle), un écran « Bilan du mois » :

| Section | Contenu |
|---------|---------|
| **Patrimoine** | Évolution en € (graphique sparkline) |
| **Production** | Volumes produits vs mois précédent |
| **Records** | « Meilleur rendement blé jamais atteint : 87 q/ha ! » |
| **Classement** | Position relative (top X%) — motivant sans être punitif |
| **Prochains objectifs** | « Le mois prochain : semis de printemps, acheter un semoir ? » |

Le bilan est **célébratoire** — jamais « vous avez perdu X€ ». Même en cas de mois négatif, le framing est constructif (« Investissement : -45 000€ en bâtiment → capacité +50 vaches »).

### Partie 2 — Politique d'absence (Décision #15, Option B+D)

#### Le contrat joueur

> **« Tu ne perdras jamais tout. Tu ne perdras jamais rien d'irremplaçable. Mais tu progresseras moins vite. »**

#### Mécanique : dégradation lente, jamais de mort catastrophique

| Durée d'absence | Ce qui se passe | Ce qui NE se passe PAS |
|:---:|---|---|
| < 48h (2 ticks) | Production normale, stockage | Rien de négatif |
| 48h - 1 semaine | Animaux : condition -1/tick. Cultures : pas de récolte si mûres → surmaturation lente. | ❌ Pas de mort |
| 1-2 semaines | Animaux : condition basse, production -50%. Cultures mûres : rendement -30%. | ❌ Pas de mort |
| 2-4 semaines | Animaux : condition critique, production arrêtée. Cultures : perdues (non récoltées depuis 3+ semaines). | ❌ Animaux VIVANTS mais improductifs |
| > 4 semaines | Mode « gel progressif » : les charges fixes continuent mais les dégradations se stabilisent. | ❌ Pas de spirale de la mort |

**Règle absolue** : un animal ne meurt JAMAIS d'absence seule (≠ négligence active quand le joueur est connecté). Un joueur qui revient après 1 mois retrouve ses animaux affaiblis mais vivants.

#### Notifications actionnables (mobile)

| Événement | Notification | Action possible |
|-----------|-------------|-----------------|
| Récolte prête | « 🌾 Votre blé est mûr — récolter ? » | [Récolter] (1 tap) |
| Stock aliment bas | « 🐄 Stock aliment < 3 jours — commander ? » | [Commander à la coop] |
| Animal malade | « 🩺 Marguerite a une mammite — soigner ? » | [Appeler le véto] |
| Condition critique | « ⚠️ Vos poules sont en sous-alimentation » | [Acheter aliment] |

**Règles des notifications** :
- AgriPass requis pour les notifications push/email (gratuit = à la connexion uniquement)
- Maximum 3 notifications/jour (pas de spam)
- Chaque notification = 1 action possible en 1 tap
- Jamais de notification FOMO (« Vous ratez de l'argent ! »)
- Ton factuel, pas anxiogène (« Votre blé est mûr » ≠ « Votre blé pourrit ! »)

#### Interaction avec le gameplay

| Système | Comportement en absence |
|---------|------------------------|
| **Tick quotidien** | Continue normalement (production, consommation) |
| **Coopérative** | Vente automatique si le joueur a un ordre permanent (cf. ADR-017) |
| **Employés** | Continuent leurs tâches assignées (HT disponibles mais non utilisées si pas d'ordre) |
| **Météo/saisons** | Avancent normalement — le joueur peut rater une fenêtre de semis |
| **Marché** | Ordres en cours restent actifs (annonces, achats programmés) |

### Synergie des deux parties

Les notifications (Partie 2) sont un sous-ensemble du feedback quotidien (Partie 1). Un joueur qui se connecte reçoit le récap complet ; un joueur absent reçoit les alertes critiques par push (s'il est AgriPass). Le système est le même — seul le canal de livraison change.

## Conséquences

- Un système de « récap à la connexion » doit être architecturé (diff entre dernier login et état actuel).
- Le bilan hebdomadaire est un écran UI dédié (dashboard + modal).
- Les notifications push nécessitent un service de messaging (FCM/APNs via PWA ou app compagnon).
- Le système de dégradation par absence doit être intégré au tick engine.
- Les ordres permanents (cf. ADR-017) atténuent l'impact de l'absence.

## Alternatives rejetées

| Option (Décision #14) | Raison |
|---|---|
| A — Session 5 min seule | Insuffisant pour la rétention hebdomadaire |
| B — Micro-rewards seules | Risque de « daily chores » artificielles |
| C — Bilan hebdomadaire seul | 1 semaine c'est trop long pour accrocher un nouveau |

| Option (Décision #15) | Raison |
|---|---|
| A — Gel total | Irréaliste, exploitable (pause stratégique), économie gelée |
| C — NPC « voisin » automatique | Magic solution, détruit l'agence du joueur, immersion questionnable |

## Références

- `docs/design/GDD-DECISIONS-OUVERTES.md` — Décisions #14, #15
- `docs/design/GDD-SOURCE-VERITE.md` §2 — temporalité, §8 — notifications Premium
- ADR-014 — notifications push = AgriPass
- ADR-017 — ordres permanents atténuent l'absence
