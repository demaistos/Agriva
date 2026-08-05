# ADR-008 : Définition opérationnelle « pas Pay-to-Win »

> Date : 2026-08-05
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Résout : Décision ouverte #08
> Impacte : Toute future feature de monétisation, charte communautaire

## Contexte

« Jamais P2W » est un engagement marketing fort mais sans définition testable, c'est un vœu pieux. Un seul thread Reddit « Agriva is P2W » peut tuer la croissance. La frontière entre QoL et avantage compétitif est floue — il faut une ligne infranchissable, publique et opposable.

## Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A — Règle du ±10% | F2P atteint ±10% des résultats d'un abonné | Difficile à mesurer sur 119 systèmes |
| **B — Liste rouge/verte explicite** | Charte publique de ce qui est JAMAIS monétisé vs ce qui l'est | ✅ **Retenue** |
| C — Comité communautaire | Les joueurs votent sur chaque ajout | Lent, votent toujours « tout gratuit » |

## Décision

**Option B** — Publier dès le lancement une **Charte « Lignes Rouges de Monétisation »**, testable et opposable.

### Lignes rouges (JAMAIS monétisé)

| Catégorie | Interdit |
|-----------|----------|
| **Temps de travail** | ❌ HT bonus, ❌ recharge accélérée, ❌ ouvrier gratuit |
| **Rendement** | ❌ Boost récolte, ❌ bonus reproduction, ❌ multiplicateur XP |
| **Vitesse** | ❌ Skip timer, ❌ accélération tick, ❌ croissance boost |
| **Accès** | ❌ Contenu gameplay exclusif abonnés |
| **Marché** | ❌ Avantage prix, ❌ info asymétrique, ❌ slots vente bonus |
| **Automatisation** | ❌ Ordres permanents dans l'abo (c'est un gameplay via employés) |

### Zone verte (monétisable)

| Catégorie | Exemples autorisés |
|-----------|--------------------|
| **Cosmétiques** | Skins bâtiments, avatars, badges |
| **Confort UX** | Thèmes, notifications push, graphiques avancés |
| **Social** | Emojis marché, profil décoré |
| **Commodité non-compétitive** | 2ème ferme (même HT total), sauvegarde layouts |
| **Méta** | Accès Discord privé, support prioritaire (bugs) |

### Test de conformité

Avant toute feature monétisée :

```
Q1 : Un F2P avec le même temps de jeu peut-il obtenir le même résultat économique ?
     OUI → autorisé    NON → interdit

Q2 : La feature donne-t-elle un avantage sur le MARCHÉ entre joueurs ?
     OUI → interdit    NON → vérifier Q1
```

### Publication

- Charte accessible en 1 clic dans le jeu
- Versionnée — modification annoncée avec 30 jours de préavis
- Opposable : violation démontrée → retrait ou passage gratuit sous 7 jours

## Conséquences

- Chaque feature monétisation doit passer le test Q1/Q2
- L'abonnement ne peut contenir QUE des items zone verte
- Le game design prévoit un chemin F2P viable pour chaque mécanique
- ❌ Ne pas ajouter un « petit boost » anodin (cumul = P2W systémique)
- ❌ Ne pas cacher un avantage derrière un cosmétique (skin tracteur +5% débit)
