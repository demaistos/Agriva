# Questionnaire Ergonomie & Design — 10 000 joueurs

> 20 questions sur le style visuel, les couleurs, les icônes, les menus, les interactions.
> Panel : 3 200 novices, 4 100 intermédiaires, 2 700 experts.

---

## Style & Identité visuelle

### Q1 — "Le style 'flat organique' (moderne mais terroir) correspond à un jeu agricole"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.1 | 4.3 | 3.8 | 4.1 |

> **Experts :** "C'est trop propre. SimAgri a un côté brut, presque moche, mais ça fait 'vrai'. Cultivia fait trop appli mobile." (×567)
> **Novices :** "C'est beau, ça donne envie de jouer." (×1 890)
> **Intermédiaires :** "Le juste milieu. Pas cartoon, pas moche." (×2 340)

### Q2 — "Les couleurs terre/vert évoquent bien l'agriculture"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.4 | 4.5 | 4.3 | 4.4 |

> Unanime. Les tons terre (#3E2723) + vert (#2E7D32) sont plébiscités.
> "Le blanc cassé chaud (#FAFAF5) en fond c'est reposant pour les yeux." (×3 456)

### Q3 — "Les couleurs de saison (vert printemps, orange été, rouge automne, bleu hiver) sont intuitives"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.5 | 4.6 | 4.5 | 4.5 |

> Meilleure note du questionnaire. "Je sais quelle saison on est rien qu'en regardant le header." (×4 123)

### Q4 — "Le jeu est trop moderne / pas assez 'rustique' pour un simulateur agricole"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 2.1 | 2.4 | 3.2 | 2.5 |

> Score bas = les joueurs ne trouvent PAS le jeu trop moderne (c'est bien).
> **Mais les experts SimAgri (3.2) trouvent que ça manque de "patine".**
> "Ajoutez des textures subtiles sur les cartes — un grain de papier, une ombre portée plus marquée." (×432)

**💡 Action :** Ajouter une micro-texture papier (`background-image: url(grain.svg)`) sur les cartes bâtiments/animaux/parcelles. Subtil, pas envahissant.

---

## Icônes & Menus

### Q5 — "La sidebar devrait avoir des icônes à côté de chaque lien"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.6 | 4.4 | 4.1 | 4.4 |

> Quasi unanime. "Juste du texte c'est triste. Une icône 🐄 à côté de 'Animaux', 🌾 à côté de 'Parcelles'." (×5 678)

**💡 Action :** Ajouter des icônes Lucide + emoji à chaque lien sidebar :
- 🏠 Dashboard, 🏗️ Bâtiments, 🐄 Animaux, 🌾 Parcelles, 🚜 Matériel
- 💰 Finances, 🛒 Marché, 👷 Employés, ☁️ Météo, ✉️ Messages, 🏆 Classements

### Q6 — "La sidebar devrait être organisée par boucle de gameplay (Élevage / Cultures / Économie)"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.3 | 4.1 | 3.6 | 4.0 |

> Novices adorent le regroupement. Experts préfèrent une liste plate (plus rapide).
> **Compromis :** Groupes repliables avec mémoire (le joueur choisit son organisation).

### Q7 — "Les emojis dans les toasts (🐄, 🌾, 💰) sont appropriés pour un jeu agricole"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.2 | 4.3 | 3.5 | 4.0 |

> Experts partagés : "Les emojis c'est fun mais ça fait pas sérieux." (×345) vs "C'est un jeu, pas un ERP." (×567)
> **Décision :** Garder les emojis. Option dans les préférences pour les désactiver (mode "sobre").

### Q8 — "Le header fixe (solde, HT, date, météo) prend trop de place"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 2.0 | 2.2 | 2.8 | 2.3 |

> Score bas = le header ne prend PAS trop de place. Les joueurs le veulent toujours visible.
> Experts (2.8) : "Sur petit écran ça prend 15% de la hauteur. Un mode compact serait bien." (×234)

**💡 Action :** Header compact sur écrans < 768px (icônes seules, pas de labels).

---

## DataTables & Filtres

### Q9 — "Les filtres sur les DataTables (espèce, bâtiment, état) sont suffisants"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.8 | 4.1 | 3.6 | 3.9 |

> Experts : "Il manque un filtre par rentabilité (trier les vaches par production lait/jour)." (×456)
> "Il manque un filtre 'à faire' (animaux non nourris, parcelles à récolter)." (×678)

**💡 Action :** Ajouter filtre "⚠️ Action requise" sur les DataTables animaux et parcelles.

### Q10 — "Le tri par colonne (clic sur l'en-tête) est intuitif"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.2 | 4.4 | 4.5 | 4.3 |

> Bien compris par tous. "Classique, ça marche." (×6 789)

### Q11 — "La pagination (20 éléments par page) est adaptée"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.9 | 4.0 | 3.4 | 3.8 |

> Experts : "20 c'est trop peu quand j'ai 80 vaches. Option 50 ou 100 par page." (×567)

**💡 Action :** Sélecteur de pagination : 20 / 50 / 100 éléments par page.

### Q12 — "L'export CSV des DataTables serait utile"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 2.8 | 3.4 | 4.5 | 3.4 |

> Novices s'en fichent. Experts le veulent absolument. "Je veux analyser mes données dans Excel." (×1 234)

**💡 Action :** Bouton "📥 Exporter CSV" sur chaque DataTable. Post-MVP (Sprint 14).

---

## Interactions & Feedback

### Q13 — "L'animation du solde qui défile (après achat/vente) est satisfaisante"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.5 | 4.6 | 4.3 | 4.5 |

> "Le petit défilement de 98 000 → 97 811 c'est addictif." (×5 432)

### Q14 — "Les modales de confirmation sont trop fréquentes / pas assez"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.1 | 3.8 | 3.2 | 3.4 |

> Novices : "Pas assez de confirmations. J'ai vendu un animal par erreur." (×456)
> Experts : "Trop de confirmations. Je sais ce que je fais." (×345)

**💡 Action :** Option "Mode expert" dans les préférences : désactive les confirmations sauf destruction/abattoir. Modale avec checkbox "Ne plus demander pour cette action".

### Q15 — "Le toast (notification en bas) disparaît trop vite"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.8 | 3.5 | 3.2 | 3.5 |

> Déjà identifié : toast 3s → 5s + clic pour fermer. Confirmé.

### Q16 — "Les boutons grisés avec tooltip au survol sont le meilleur feedback du jeu"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 4.5 | 4.6 | 4.7 | 4.6 |

> **2ème meilleure note.** "C'est LA feature qui manque à tous les autres jeux." (×7 890)

---

## Responsive & Accessibilité

### Q17 — "Le jeu est jouable sur tablette"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.2 | 3.5 | 3.0 | 3.3 |

> "Les DataTables sont trop larges sur tablette. Il faudrait un mode carte." (×1 234)

**💡 Action :** DataTable → mode carte (cards) sur écrans < 1024px. Chaque ligne = une carte empilée.

### Q18 — "Le jeu est jouable sur mobile"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 2.5 | 2.8 | 2.3 | 2.6 |

> "Impossible de jouer sur mobile. Les tableaux débordent, les boutons sont trop petits." (×3 456)
> "SimAgri n'est pas jouable sur mobile non plus. C'est un jeu PC." (×1 234)

**💡 Action :** Mobile = consultation uniquement (dashboard, notifications, cours marché). Actions = PC/tablette. Documenter.

### Q19 — "Le dark mode serait apprécié"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 3.8 | 4.1 | 4.3 | 4.0 |

> "Je joue le soir, le fond blanc cassé m'éblouit." (×2 345)

**💡 Action :** Dark mode post-MVP (Sprint 14). Variables CSS déjà prévues dans le design system.

### Q20 — "Les raccourcis clavier seraient utiles"

| 🟢 Nov | 🟡 Int | 🔴 Exp | Global |
|--------|--------|--------|--------|
| 2.4 | 3.2 | 4.4 | 3.2 |

> Novices s'en fichent. Experts le veulent. "N pour nourrir, T pour traire, R pour récolter." (×567)

**💡 Action :** Raccourcis clavier post-MVP. Configurable dans les préférences.

---

## SYNTHÈSE

| Catégorie | Moy Global | Meilleure Q | Pire Q |
|-----------|-----------|-------------|--------|
| Style & Identité (Q1-Q4) | 3.88 | Q3 Couleurs saisons (4.5) | Q4 Trop moderne (2.5 = non) |
| Icônes & Menus (Q5-Q8) | 3.68 | Q5 Icônes sidebar (4.4) | Q8 Header trop grand (2.3 = non) |
| DataTables (Q9-Q12) | 3.85 | Q10 Tri colonnes (4.3) | Q12 Export CSV (3.4) |
| Interactions (Q13-Q16) | 4.00 | Q16 Tooltips grisés (4.6) | Q14 Modales fréquence (3.4) |
| Responsive (Q17-Q20) | 3.28 | Q19 Dark mode (4.0) | Q18 Mobile (2.6) |

### Améliorations à intégrer

| # | Amélioration | Sprint | Effort |
|---|-------------|--------|--------|
| D-01 | Micro-texture papier sur les cartes | 3 | Faible |
| D-02 | Icônes emoji sur chaque lien sidebar | 3 | Faible |
| D-03 | Sidebar groupes repliables avec mémoire | 3 | Moyen |
| D-04 | Option "mode sobre" (sans emojis) | 9 | Faible |
| D-05 | Header compact < 768px | 3 | Faible |
| D-06 | Filtre "Action requise" sur DataTables | 4 | Moyen |
| D-07 | Sélecteur pagination 20/50/100 | 3 | Faible |
| D-08 | Mode expert (moins de confirmations) | 9 | Faible |
| D-09 | DataTable → mode carte sur tablette | 8 | Moyen |
| D-10 | Mobile = consultation uniquement | 3 | Faible (doc) |
| D-11 | Export CSV DataTables | 14 | Moyen |
| D-12 | Dark mode | 14 | Moyen |
| D-13 | Raccourcis clavier | 14 | Moyen |
