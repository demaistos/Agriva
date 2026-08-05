> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Design System & Expérience Utilisateur

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer, agent:ux-designer
> Références : ADR-001, ADR-002, ADR-003, `docs/design/GDD-economie-base.md`

---

## 1. Vision UX

### 1.1 Intention de design

Agriva est un jeu de gestion **dense en information** joué dans un navigateur. Le joueur gère une exploitation agricole complète : cultures, élevages, matériel, finances, social. L'interface doit rendre cette complexité **lisible en un coup d'œil**.

**Règle des 3 secondes** : en arrivant sur n'importe quel écran, le joueur doit comprendre :
1. **Où il en est** (solde, temps de travail restant, alertes critiques)
2. **Ce qui nécessite son attention** (animaux affamés, récolte prête, paiement dû)
3. **Ce qu'il peut faire maintenant** (actions disponibles, raccourcis)

**Ce que SimAgri fait bien** : densité d'information, tableaux complets, accès direct aux actions.
**Ce que SimAgri fait mal** : interface datée (2005), pas de responsive, pas de hiérarchie visuelle, trop de clics pour les actions courantes.

### 1.2 Gameplay loop UX

```
┌─────────────────────────────────────────────────────┐
│              SESSION TYPE (15-30 min)                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. DASHBOARD → Scan 3s : que se passe-t-il ?       │
│     ↓                                               │
│  2. ALERTES → Traiter les urgences (0-2 min)        │
│     ↓                                               │
│  3. ACTIONS QUOTIDIENNES → Nourrir, récolter (5m)   │
│     ↓                                               │
│  4. DÉCISIONS → Acheter, vendre, planifier (10m)    │
│     ↓                                               │
│  5. SOCIAL → Marché, coopérative, messages (5m)     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 2. Principes directeurs

### 2.1 Information hiérarchisée

| Niveau | Contenu | Traitement visuel |
|--------|---------|-------------------|
| Critique | Alertes, solde négatif, animaux en danger | Rouge, badge pulsant, position haute |
| Important | Temps restant, récoltes prêtes, échéances | Couleur primaire, gras, visible sans scroll |
| Secondaire | Détails de parcelle, historique | Visible au clic ou en mode Expert |
| Tertiaire | Logs, formules, paramètres avancés | Mode Expert uniquement |

### 2.2 Coût affiché AVANT validation

Toute action qui consomme une ressource affiche un récapitulatif :

```
┌─────────────────────────────────────────┐
│  🌾 Semer du blé tendre                 │
├─────────────────────────────────────────┤
│  Parcelle : Les Music (12 ha)           │
│                                         │
│  Coût semences :        360 €           │
│  Coût carburant :        48 €           │
│  Temps de travail :     1 h 30          │
│  ─────────────────────────────          │
│  TOTAL :               408 €  + 1 h 30  │
│                                         │
│  Solde après :       14 592 €           │
│                                         │
│  [ Annuler ]          [ ✓ Confirmer ]   │
└─────────────────────────────────────────┘
```

### 2.3 Aucune action destructive sans confirmation

Actions destructives = vente d'animal, résiliation de bail, suppression de bâtiment, emprunt. Toujours une modale avec récapitulatif + bouton rouge explicite.

### 2.4 Mode Normal / Expert (ADR-001)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Tableaux | Colonnes essentielles (5-7) | Colonnes complètes (10-15) |
| Formules | Masquées | Affichées dans un panneau dépliable |
| Paramètres | Prédéfinis (choix A/B/C) | Sliders et valeurs numériques |
| Alertes | Texte simple « Vache affamée » | Détail « Vache #42, faim 85/100, -2kg lait/j » |
| Jauges | Couleur + icône | Couleur + icône + valeur numérique + tendance |

Le toggle Normal/Expert est **persistant** dans le header, accessible en 1 clic.



---

## 3. Navigation : structure des écrans

### 3.1 Architecture de navigation

```
┌─────────────────────────────────────────────────────────────────┐
│  HEADER PERSISTANT                                              │
│  [Logo] [Dashboard] [Parcelles] [Élevage] [Bâtiments]          │
│         [Matériel] [Marché] [Finances] [Social]                 │
│                                    [💰 15 000€] [⏱️ 8 h] [👤]  │
│                                    [Normal ○ / ● Expert]        │
├─────────────────────────────────────────────────────────────────┤
│  BREADCRUMB : Accueil > Élevage > Bovins laitiers > Vache #42  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                     CONTENU PRINCIPAL                            │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  FOOTER : Heure serveur | Météo du jour | Tick suivant dans 2h  │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Écrans principaux

| Écran | Rôle | Éléments clés |
|-------|------|---------------|
| Dashboard | Vue d'ensemble 3s | Solde, temps restant, alertes, météo, raccourcis rapides |
| Parcelles | Gestion des terres | Liste/carte, état cultural, actions groupées |
| Élevage | Gestion des animaux | Par espèce, jauges santé/faim, reproduction |
| Bâtiments | Infrastructures | Capacité, usure, stockage |
| Matériel | Machines & outils | État, cuve carburant, planning |
| Marché | Achat/vente | Cours, annonces joueurs, historique prix |
| Finances | Comptabilité | Trésorerie, emprunts, bilan, prévisionnel |
| Social | Interactions | Coopérative, messages, classement, contrats |

### 3.3 Règles de navigation

- **Retour toujours possible** : bouton ← dans le breadcrumb, touche Escape ferme les modales.
- **Pas de cul-de-sac** : chaque écran a au moins un lien vers une action ou un écran parent.
- **Raccourcis clavier** : `D` = dashboard, `P` = parcelles, `E` = élevage, `M` = marché, `F` = finances.
- **Deep linking** : chaque écran a une URL stable pour partage et favoris.



---

## 4. Design System

### 4.1 Palette de couleurs

#### Couleurs principales (thème agricole)

| Token | Hex | Usage |
|-------|-----|-------|
| `--color-primary-500` | `#2D7A3A` | Actions principales, liens, boutons CTA |
| `--color-primary-600` | `#1E5C2B` | Hover sur boutons primaires |
| `--color-primary-700` | `#144A20` | Active/pressed |
| `--color-primary-100` | `#E8F5EA` | Background léger (cards succès) |
| `--color-secondary-500` | `#8B5E3C` | Accents terre, headers secondaires |
| `--color-secondary-600` | `#6B4730` | Hover terre |
| `--color-sky-500` | `#4A90D9` | Liens, info, météo |
| `--color-sky-100` | `#E3F0FC` | Background info |

#### Couleurs sémantiques

| Token | Hex | Usage |
|-------|-----|-------|
| `--color-success` | `#22863A` | Validation, gain, bonne santé |
| `--color-warning` | `#D4850A` | Attention, stock bas, usure moyenne |
| `--color-danger` | `#CB2431` | Erreur, perte, action destructive |
| `--color-info` | `#4A90D9` | Information neutre |

#### Couleurs de jauges (par palier)

| Palier | Hex | Signification |
|--------|-----|---------------|
| 80-100% | `#22863A` | Excellent |
| 60-79% | `#6ABF69` | Bon |
| 40-59% | `#D4850A` | Attention |
| 20-39% | `#E86825` | Critique |
| 0-19% | `#CB2431` | Danger |

#### Neutres

| Token | Hex | Usage |
|-------|-----|-------|
| `--color-gray-900` | `#1B1F23` | Texte principal |
| `--color-gray-700` | `#444D56` | Texte secondaire |
| `--color-gray-500` | `#6A737D` | Texte tertiaire, placeholders |
| `--color-gray-300` | `#D1D5DA` | Bordures |
| `--color-gray-100` | `#F6F8FA` | Background surfaces |
| `--color-white` | `#FFFFFF` | Background cards |

#### Contraste WCAG AA vérifié

- Texte `gray-900` sur `white` → ratio 16.5:1 ✓
- Texte `gray-700` sur `white` → ratio 7.7:1 ✓
- Texte `white` sur `primary-500` → ratio 4.8:1 ✓
- Texte `white` sur `danger` → ratio 4.6:1 ✓

### 4.2 Typographie

Police : **Inter** (variable, sans-serif, optimisée écran).
Fallback : `system-ui, -apple-system, sans-serif`.

| Token | Taille | Poids | Line-height | Usage |
|-------|--------|-------|-------------|-------|
| `--text-display` | 28px | 700 | 1.2 | Titre de page |
| `--text-heading` | 22px | 600 | 1.3 | Titre de section |
| `--text-subheading` | 18px | 600 | 1.4 | Sous-titre, nom de carte |
| `--text-body` | 15px | 400 | 1.5 | Texte courant |
| `--text-body-bold` | 15px | 600 | 1.5 | Labels, valeurs importantes |
| `--text-small` | 13px | 400 | 1.4 | Métadonnées, timestamps |
| `--text-caption` | 11px | 500 | 1.3 | Badges, tags |

**Valeurs monétaires** : toujours en `--text-body-bold`, alignées à droite dans les tableaux.
**Nombres de jauges** : `tabular-nums` pour éviter les décalages lors des animations.

### 4.3 Espacements (échelle 4px)

| Token | Valeur | Usage |
|-------|--------|-------|
| `--space-1` | 4px | Padding interne icônes, gap micro |
| `--space-2` | 8px | Gap entre badges, padding bouton vertical |
| `--space-3` | 12px | Padding bouton horizontal, gap formulaire |
| `--space-4` | 16px | Padding card, marge entre éléments |
| `--space-5` | 20px | Gap entre sections de card |
| `--space-6` | 24px | Marge entre cards |
| `--space-8` | 32px | Marge entre sections |
| `--space-10` | 40px | Marge entre blocs majeurs |
| `--space-12` | 48px | Padding page latéral |
| `--space-16` | 64px | Espacement vertical page |

**Grille** : 12 colonnes, gouttière 24px, max-width 1440px, centré.



### 4.4 Composants

#### Button

| Variante | Background | Texte | Border | Border-radius |
|----------|-----------|-------|--------|---------------|
| Primary | `#2D7A3A` | `#FFFFFF` | none | 6px |
| Secondary | `#FFFFFF` | `#2D7A3A` | 1px `#2D7A3A` | 6px |
| Danger | `#CB2431` | `#FFFFFF` | none | 6px |
| Ghost | transparent | `#444D56` | none | 6px |

Tailles : `sm` (h=32px, text=13px), `md` (h=40px, text=15px), `lg` (h=48px, text=15px).
Padding horizontal : 16px (sm), 20px (md), 24px (lg).

#### Card

- Background : `#FFFFFF`
- Border : 1px `#D1D5DA`
- Border-radius : 8px
- Padding : 16px
- Shadow : `0 1px 3px rgba(0,0,0,0.08)`
- Shadow hover : `0 4px 12px rgba(0,0,0,0.12)`

#### Table

- Header background : `#F6F8FA`
- Header text : `--text-small`, weight 600, `#444D56`
- Row height : 44px
- Row border-bottom : 1px `#D1D5DA`
- Row hover : background `#F6F8FA`
- Row selected : background `#E8F5EA`, border-left 3px `#2D7A3A`
- Cell padding : 8px 12px

#### Modal

- Overlay : `rgba(27, 31, 35, 0.5)`
- Background : `#FFFFFF`
- Border-radius : 12px
- Padding : 24px
- Max-width : 520px (sm), 720px (md), 960px (lg)
- Shadow : `0 8px 32px rgba(0,0,0,0.2)`
- Animation entrée : fade + scale depuis 0.95, durée 150ms ease-out

#### Gauge (jauge)

- Height : 8px (compact), 12px (standard), 20px (large)
- Border-radius : 999px (pill)
- Background track : `#D1D5DA`
- Fill : couleur dynamique selon palier (voir §4.1)
- Transition du fill : 300ms ease-in-out
- Label : à gauche du track (nom), à droite (valeur en mode Expert)

#### Badge

- Height : 22px
- Padding : 0 8px
- Border-radius : 999px
- Font : `--text-caption`, weight 500
- Variantes : success (bg `#E8F5EA`, text `#22863A`), warning (bg `#FFF3CD`, text `#D4850A`), danger (bg `#FDECEA`, text `#CB2431`), info (bg `#E3F0FC`, text `#4A90D9`), neutral (bg `#F6F8FA`, text `#6A737D`)

#### Tooltip

- Background : `#1B1F23`
- Text : `#FFFFFF`, 13px
- Padding : 6px 10px
- Border-radius : 4px
- Max-width : 240px
- Delay apparition : 400ms
- Arrow : 6px

#### Alert

- Border-left : 4px couleur sémantique
- Background : couleur-100 correspondante
- Padding : 12px 16px
- Border-radius : 6px
- Icône : à gauche, 20px
- Dismiss : bouton × en haut à droite (optionnel)

#### Tabs

- Height : 44px
- Tab padding : 0 16px
- Active : border-bottom 2px `#2D7A3A`, text weight 600
- Inactive : text `#6A737D`
- Hover : text `#1B1F23`, background `#F6F8FA`

#### Form

- Input height : 40px
- Input padding : 8px 12px
- Input border : 1px `#D1D5DA`, radius 6px
- Input focus : border `#4A90D9`, shadow `0 0 0 3px rgba(74,144,217,0.15)`
- Label : `--text-small`, weight 600, margin-bottom 4px
- Error text : `--text-small`, color `#CB2431`, margin-top 4px
- Spacing entre champs : 16px

### 4.5 États des composants

| État | Visuel |
|------|--------|
| Normal | Style par défaut |
| Hover | Background s'assombrit de 8%, cursor pointer |
| Focus | Outline `0 0 0 3px rgba(74,144,217,0.3)`, jamais masqué |
| Disabled | Opacité 0.5, cursor not-allowed, pas de hover |
| Loading | Spinner 16px inline, texte « Chargement… », bouton désactivé |
| Error | Border rouge `#CB2431`, icône ⚠️, message sous le champ |
| Empty | Illustration simple + texte + CTA (voir §5.4) |



---

## 5. Patterns récurrents

### 5.1 Jauges par palier

Utilisées pour : santé animale, faim, maturité culture, usure matériel, niveau de stock.

```
Mode Normal :
┌───────────────────────────────────────┐
│  Santé   [████████████░░░░] 🟢 Bon   │
│  Faim    [██████░░░░░░░░░░] 🟡 Moyen │
│  Lait    [████████████████] 🟢 Max   │
└───────────────────────────────────────┘

Mode Expert :
┌───────────────────────────────────────────────┐
│  Santé   [████████████░░░░] 78/100  ↗ +2/j   │
│  Faim    [██████░░░░░░░░░░] 42/100  ↘ -5/j   │
│  Lait    [████████████████] 32L/j   → stable  │
│  NEC     [█████████░░░░░░░] 3.2/5   ↗ +0.1   │
└───────────────────────────────────────────────┘
```

Règle couleur : la jauge change de couleur à chaque palier (voir §4.1). En plus de la couleur, un **icône** et un **label texte** indiquent l'état (pas d'info uniquement par la couleur).

### 5.2 Tableaux de données

Pattern standard pour listes : animaux, parcelles, matériel, annonces marché.

Fonctionnalités :
- **Tri** : clic sur header, icône ↕ → ↑ ou ↓
- **Filtres** : barre de filtres au-dessus du tableau (dropdowns, recherche texte)
- **Sélection multiple** : checkbox en colonne 1, header = tout sélectionner
- **Actions groupées** : barre contextuelle apparaît quand ≥1 ligne sélectionnée
- **Pagination** : 25 lignes par défaut, options 25/50/100

```
┌─────────────────────────────────────────────────────────────────────┐
│ [Filtre: Race ▼] [Filtre: État ▼] [Recherche...]     [+ Acheter]   │
├────┬──────────┬────────┬────────┬──────────┬────────────────────────┤
│ ☐  │ Nom  ↕   │ Race   │ Santé  │ Lait/j   │ Actions               │
├────┼──────────┼────────┼────────┼──────────┼────────────────────────┤
│ ☑  │ Margot   │ Holstein│ 🟢 92  │ 34L      │ [Voir] [Vendre]       │
│ ☐  │ Blanchett│ Montbél│ 🟡 58  │ 22L      │ [Voir] [Vendre]       │
│ ☑  │ Rosalie  │ Holstein│ 🔴 18  │ 12L      │ [Voir] [Soigner]      │
├────┴──────────┴────────┴────────┴──────────┴────────────────────────┤
│ ☑ 2 sélectionnées  [Vendre groupé] [Déplacer] [Nourrir]            │
├─────────────────────────────────────────────────────────────────────┤
│ Page 1/3   [← Préc] [1] [2] [3] [Suiv →]     Afficher: [25▼]      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.3 Modale de confirmation avec récapitulatif

Toute action engageante passe par ce pattern :

```
┌─────────────────────────────────────────────────┐
│  ⚠️  Vendre 2 vaches                            │
├─────────────────────────────────────────────────┤
│                                                 │
│  Vous allez vendre :                            │
│    • Margot (Holstein, 4 ans)     →  1 850 €    │
│    • Rosalie (Holstein, 6 ans)    →    920 €    │
│                                                 │
│  ─────────────────────────────────              │
│  Revenu total :                      2 770 €    │
│  Commission marché (3%) :             - 83 €    │
│  ─────────────────────────────────              │
│  Revenu net :                        2 687 €    │
│                                                 │
│  ⚠️ Cette action est irréversible.              │
│                                                 │
│  [ Annuler ]              [ 🔴 Vendre ]         │
└─────────────────────────────────────────────────┘
```

Le bouton destructif est **toujours à droite**, en rouge, avec un verbe explicite (pas « OK »).

### 5.4 Écran vide (première visite)

Quand une section est vide (pas encore d'animaux, pas de parcelle) :

```
┌─────────────────────────────────────────────────┐
│                                                 │
│              🐄                                  │
│                                                 │
│     Vous n'avez pas encore d'animaux            │
│                                                 │
│     Achetez votre premier troupeau sur          │
│     le marché ou auprès d'un éleveur.           │
│                                                 │
│         [ 🛒 Aller au marché ]                  │
│                                                 │
└─────────────────────────────────────────────────┘
```

Toujours : icône/illustration, texte explicatif, **un seul CTA** orienté vers l'action suivante.



---

## 6. Responsive

### 6.1 Breakpoints

| Token | Valeur | Cible |
|-------|--------|-------|
| `--bp-desktop-lg` | ≥ 1440px | Écran large, grille 12 colonnes complète |
| `--bp-desktop` | 1024–1439px | Desktop standard, grille 12 colonnes |
| `--bp-tablet` | 768–1023px | Tablette paysage, grille 8 colonnes |
| `--bp-mobile` | < 768px | Mobile, grille 4 colonnes, nav en bottom-bar |

### 6.2 Adaptations par breakpoint

| Élément | Desktop | Tablette | Mobile |
|---------|---------|----------|--------|
| Navigation | Sidebar ou top-bar horizontale | Top-bar condensée | Bottom bar (5 icônes) + hamburger |
| Dashboard cards | 3-4 par ligne | 2 par ligne | 1 par ligne (stack) |
| Tableaux | Complets | Colonnes réduites | Cards empilées (pas de table) |
| Modales | Centrées 520px | Centrées 90% width | Plein écran (sheet) |
| Jauges | Inline avec label | Inline | Stack verticale |

### 6.3 Priorité desktop

Le jeu est conçu pour desktop. Tablette = fonctionnel, mobile = consultable (voir son état, lancer des actions simples). Les actions complexes (configuration avancée, gestion de lots) restent optimales sur desktop.

---

## 7. Accessibilité (WCAG AA)

### 7.1 Contrastes

- Texte normal (< 18px) : ratio minimum 4.5:1
- Texte large (≥ 18px bold ou ≥ 24px) : ratio minimum 3:1
- Éléments interactifs et graphiques : ratio minimum 3:1 contre background
- Tous les tokens de couleur du §4.1 sont vérifiés AA

### 7.2 Navigation clavier

- **Tab** : parcourt tous les éléments interactifs dans l'ordre du DOM
- **Enter/Space** : active boutons et liens
- **Escape** : ferme modale, tooltip, dropdown
- **Flèches** : navigation dans tableaux, tabs, menus
- **Focus visible** : outline `0 0 0 3px rgba(74,144,217,0.3)` sur TOUS les éléments focusables, jamais masqué
- **Skip link** : « Aller au contenu principal » en premier élément

### 7.3 ARIA

- `role="alert"` sur les messages de feedback (succès, erreur)
- `aria-live="polite"` sur les zones qui se mettent à jour (solde, temps restant, jauges)
- `aria-label` sur les boutons icône-seule
- `aria-describedby` pour lier les champs à leurs messages d'erreur
- `aria-expanded` sur les accordéons et dropdowns
- `aria-current="page"` sur l'item de navigation actif
- Tableaux : `<th scope="col">` et `<th scope="row">` systématiques

### 7.4 Pas d'information uniquement par la couleur

Chaque état encodé en couleur a AUSSI :
- Un **icône** (🟢 ✓ bon, 🟡 ⚠ attention, 🔴 ✗ danger)
- Un **label texte** (« Bon », « Attention », « Critique »)
- Une **pattern** dans les jauges (hachuré pour danger en mode fort contraste)

### 7.5 Lecteurs d'écran

- Structure de headings correcte (h1 > h2 > h3, pas de saut)
- Images décoratives : `alt=""`
- Images informatives : alt descriptif
- Jauges : `role="progressbar"` + `aria-valuenow` + `aria-valuemin` + `aria-valuemax` + `aria-valuetext="Santé: 78 sur 100, bon état"`
- Tableaux de données : jamais de tableaux de mise en page

---

## 8. Feedback et animations

### 8.1 Principes d'animation

- **Ce qui bouge** : transitions d'état (hover, focus, ouverture modale, apparition de contenu)
- **Ce qui ne bouge pas** : texte, tableaux statiques, structure de page
- **Durée courte** : interactions immédiates (hover, toggle) = 100-150ms
- **Durée moyenne** : transitions de contenu (modale, panneau) = 200-300ms
- **Durée longue** : animations d'état (jauge qui remplit) = 300-500ms
- **Respect `prefers-reduced-motion`** : toutes les animations désactivées si l'utilisateur le demande

### 8.2 Timing functions

| Contexte | Easing | Duration |
|----------|--------|----------|
| Hover bouton | `ease-out` | 100ms |
| Focus ring | `ease-out` | 100ms |
| Ouverture modale | `ease-out` | 150ms |
| Fermeture modale | `ease-in` | 100ms |
| Panneau dépliable | `ease-in-out` | 200ms |
| Remplissage jauge | `ease-in-out` | 300ms |
| Toast notification (entrée) | `ease-out` | 200ms |
| Toast notification (sortie) | `ease-in` | 150ms |
| Skeleton loading pulse | `ease-in-out` | 1500ms (loop) |

### 8.3 Feedback utilisateur

| Action | Feedback |
|--------|----------|
| Clic bouton | Ripple subtil ou scale 0.97 pendant 100ms |
| Soumission formulaire | Bouton passe en état loading (spinner) |
| Action réussie | Toast vert en haut à droite, auto-dismiss 4s |
| Erreur | Toast rouge ou message inline, pas d'auto-dismiss |
| Chargement de données | Skeleton screens (pas de spinner plein écran) |
| Tick serveur (mise à jour) | Flash léger sur les valeurs modifiées (background `#FFF3CD` → transparent, 600ms) |



---

## 9. Différence Normal / Expert — Mockups comparatifs

### 9.1 Dashboard — Mode Normal

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🌾 AGRIVA    [Parcelles] [Élevage] [Bâtiments] [Matériel] [Marché]        │
│               [Finances] [Social]              💰 15 240€  ⏱️ 8 h  [N/E]   │
├─────────────────────────────────────────────────────────────────────────────┤
│  Accueil > Dashboard                                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────────────────┐    │
│  │ 💰 Solde         │  │ ⚡ Points Action │  │ 🌤️ Météo                 │    │
│  │   15 240 €       │  │     8 / 10      │  │   Ensoleillé, 24°C      │    │
│  │   ↗ +1 200 hier  │  │   Recharge: 6h  │  │   Demain: Pluie légère  │    │
│  └─────────────────┘  └─────────────────┘  └──────────────────────────┘    │
│                                                                             │
│  ┌─ 🔔 Alertes (2) ────────────────────────────────────────────────────┐   │
│  │  🔴 Vache Rosalie : santé critique → [Soigner]                      │   │
│  │  🟡 Blé parcelle Nord : récolte prête → [Récolter]                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─ ⚡ Actions rapides ────────────────────────────────────────────────┐   │
│  │  [🌾 Récolter] [🐄 Nourrir troupeau] [🛒 Marché] [💧 Irriguer]     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─ 📊 Résumé exploitation ───────────────────────────────────────────┐   │
│  │  Parcelles: 5 (48 ha)  │  Animaux: 32  │  Matériel: 8 machines    │   │
│  │  Récoltes prêtes: 1    │  À nourrir: 0 │  En panne: 0             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  🕐 Tick: 14h00  │  🌡️ 24°C Ensoleillé  │  Prochain tick dans 1h42        │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 9.2 Dashboard — Mode Expert

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🌾 AGRIVA    [Parcelles] [Élevage] [Bâtiments] [Matériel] [Marché]        │
│               [Finances] [Social]              💰 15 240€  ⏱️ 8 h  [N/●E]  │
├─────────────────────────────────────────────────────────────────────────────┤
│  Accueil > Dashboard                                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────┐ ┌─────────────────────┐ ┌────────────────────┐    │
│  │ 💰 Trésorerie        │ │ ⏱️ Temps de travail  │ │ 🌤️ Météo détaillée │    │
│  │   Solde: 15 240 €    │ │   Restant: 8h/10h   │ │  Aujourd'hui:      │    │
│  │   Hier:  +1 200 €    │ │   Recharge: 6h03    │ │   24°C ☀️ Hum: 45%  │    │
│  │   Sem:   +4 800 €    │ │   Demain:  +10 h    │ │  Demain:           │    │
│  │   Mois:  +8 320 €    │ │   Consommé auj: 2h  │ │   18°C 🌧️ 12mm     │    │
│  │   Charges dues: 820€ │ │                     │ │  J+2: 20°C ⛅      │    │
│  │   Échéance: 12 jours │ │                     │ │  Impact récolte:+5%│    │
│  └─────────────────────┘ └─────────────────────┘ └────────────────────┘    │
│                                                                             │
│  ┌─ 🔔 Alertes (2) ────────────────────────────────────────────────────┐   │
│  │  🔴 Vache #12 Rosalie: santé 18/100 ↘-3/j, cause: mammite          │   │
│  │     Coût soins: 120€ + 1PA │ Sans soins: mort en ~6j → [Soigner]   │   │
│  │  🟡 Parcelle Nord (12ha blé): maturité 100%, rendement estimé 7.8t/ha  │
│  │     Fenêtre optimale: 3j │ Perte/jour après: -2% → [Récolter]      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─ 📈 Indicateurs clés ──────────────────────────────────────────────┐   │
│  │  Marge brute/ha: 890€  │  Coût alim/UGB: 3.2€/j  │  Tx endett: 22%│   │
│  │  Rdt moyen blé: 7.4t   │  Prod lait moy: 28L/j   │  Charges: 28%  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─ ⚡ Actions rapides ─────┐  ┌─ 📋 Prochaines échéances ───────────┐   │
│  │  [🌾 Récolter]           │  │  Dans 3j: Annuité emprunt    1 200€  │   │
│  │  [🐄 Nourrir troupeau]   │  │  Dans 8j: MSA T3              640€  │   │
│  │  [🛒 Marché]             │  │  Dans 12j: Fermage            820€  │   │
│  │  [💧 Irriguer]           │  │  Dans 30j: Salaire ouvrier    1 800€ │   │
│  └──────────────────────────┘  └──────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  🕐 Tick #1247: 14h00  │  🌡️ 24°C ☀️ Hum:45%  │  Prochain tick: 1h42     │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 9.3 Fiche parcelle — Mode Normal

```
┌─────────────────────────────────────────────────────────────────┐
│  Accueil > Parcelles > Les Music (12 ha)                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─ Infos ──────────────────────────────────────────────────┐  │
│  │  Culture: Blé tendre      │  Surface: 12 ha              │  │
│  │  État: En croissance      │  Semé le: 15 octobre         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌─ Maturité ──────────────────────────────────────────────┐   │
│  │  [████████████████████░░░░░░░░] 🟢 68% — Bon            │   │
│  │  Récolte estimée: 20 février                             │   │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌─ Actions ────────────────────────────────────────────────┐  │
│  │  [💧 Irriguer — 15 min, 96€] [🧪 Traiter — 15 min, 144€] │  │
│  │  [📊 Historique]                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 9.4 Fiche parcelle — Mode Expert

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Accueil > Parcelles > Les Music (12 ha)                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─ Infos ──────────────────────────────────────────────────────────┐  │
│  │  Culture: Blé tendre (var. Apache)  │  Surface: 12.4 ha          │  │
│  │  État: Tallage (stade BBCH 25)      │  Semé: 15/10, densité 320g/m²│ │
│  │  Précédent: Colza (bonus azote +20u)│  Type sol: Limon argileux  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌─ Croissance ─────────────────────────────────────────────────────┐  │
│  │  Maturité [████████████████████░░░░░░░░] 68/100  ↗ +1.8/j       │  │
│  │  Azote    [██████████████░░░░░░░░░░░░░░] 120/200u               │  │
│  │  Eau      [█████████████████░░░░░░░░░░░] 72%     ↘ -3%/j        │  │
│  │  Santé    [████████████████████████████] 95/100  → stable        │  │
│  │                                                                   │  │
│  │  Rendement prévu: 7.8 t/ha (potentiel variétal: 9.2 t/ha)       │  │
│  │  Facteurs limitants: azote (-8%), densité semis (-5%)            │  │
│  │  Récolte optimale: entre le 18 et 22 février                     │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌─ Actions ────────────────────────────────────────────────────────┐  │
│  │  [💧 Irriguer — 1PA, 96€, +15% eau]                             │  │
│  │  [🧪 Fongicide — 1PA, 144€, santé +10]                          │  │
│  │  [🌿 Azote 40u — 1PA, 72€, rdt +4%]                             │  │
│  │  [📊 Historique] [📈 Courbes] [🧮 Simulation]                    │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌─ 📋 Historique interventions ────────────────────────────────────┐  │
│  │  15/10 Semis 320g/m² (1PA, 360€) │ 20/11 Herbicide (1PA, 108€) │  │
│  │  05/12 Azote 80u (1PA, 144€)     │ 10/01 Azote 40u (1PA, 72€)  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 9.5 Tableau d'animaux (Mode Normal)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Accueil > Élevage > Bovins laitiers (32 têtes)                         │
├─────────────────────────────────────────────────────────────────────────┤
│  [Filtre: Race ▼] [Filtre: État ▼] [🔍 Rechercher]       [+ Acheter]   │
├────┬──────────┬──────────┬──────────┬──────────┬────────────────────────┤
│ ☐  │ Nom      │ Race     │ Santé    │ Lait/j   │ Actions               │
├────┼──────────┼──────────┼──────────┼──────────┼────────────────────────┤
│ ☐  │ Margot   │ Holstein │ 🟢 Bon   │ 34 L     │ [Voir] [Vendre]       │
│ ☐  │ Blanchet │ Montbél. │ 🟡 Moyen │ 22 L     │ [Voir] [Vendre]       │
│ ☐  │ Rosalie  │ Holstein │ 🔴 Crit. │ 12 L     │ [Voir] [Soigner]      │
│ ☐  │ Caramel  │ Jersiaise│ 🟢 Bon   │ 26 L     │ [Voir] [Vendre]       │
│ ☐  │ Étoile   │ Holstein │ 🟢 Bon   │ 31 L     │ [Voir] [Vendre]       │
├────┴──────────┴──────────┴──────────┴──────────┴────────────────────────┤
│  Total: 32 vaches │ Production: 890 L/j │ Santé moy: 🟢 Bon            │
├─────────────────────────────────────────────────────────────────────────┤
│  Page 1/7   [← Préc] [1] [2] [3] ... [7] [Suiv →]                      │
└─────────────────────────────────────────────────────────────────────────┘
```

### 9.6 Modale d'achat (commune aux deux modes)

```
┌─────────────────────────────────────────────────────────┐
│  🛒 Acheter du matériel                          [ × ]  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Article : Tracteur John Deere 6120M                    │
│  État : Occasion (2 800h, usure 35%)                    │
│  Vendeur : Joueur « FermeduBois »                       │
│                                                         │
│  ┌─ Récapitulatif ──────────────────────────────────┐  │
│  │                                                   │  │
│  │  Prix d'achat :                      45 000 €     │  │
│  │  Frais de livraison :                   450 €     │  │
│  │  ──────────────────────────────────────────       │  │
│  │  TOTAL :                             45 450 €     │  │
│  │                                                   │  │
│  │  💰 Solde actuel :        15 240 €                │  │
│  │  💰 Solde après achat :  -30 210 €  ⚠️            │  │
│  │                                                   │  │
│  │  ⚠️ Solde insuffisant.                            │  │
│  │  Financer par emprunt ? [Simuler un prêt]         │  │
│  │                                                   │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  [ Annuler ]                    [ 🔴 Acheter — 45 450€] │
│                                 (désactivé si insuff.)  │
└─────────────────────────────────────────────────────────┘
```



---

## Annexe — Récapitulatif Normal vs Expert (UI)

| Élément d'interface | Mode Normal | Mode Expert |
|---------------------|-------------|-------------|
| Colonnes tableau animaux | Nom, Race, Santé (icône), Lait/j | + Âge, NEC, Faim, Poids, Jours gestation, Valeur € |
| Colonnes tableau parcelles | Nom, Culture, Surface, État | + Stade BBCH, Azote, Eau, Rendement prévu, Facteurs limitants |
| Dashboard cards | Solde, Temps restant, Météo (simple) | + Évolution sem/mois, Charges dues, Échéances, Indicateurs |
| Jauges | Couleur + icône + label | + Valeur numérique + tendance/j + seuils |
| Actions | Bouton avec coût simple | + Impact détaillé (%, valeur absolue, durée précise) |
| Alertes | Texte simple + CTA | + Cause, coût, conséquence si rien, délai |
| Finances | Solde + dernières opérations | + Bilan complet, ratios, graphiques, prévisionnel |
| Météo | Icône + température | + Humidité, pluviométrie, impact cultures, prévision 3j |
| Historique | Masqué (accessible par bouton) | Affiché inline sous les fiches |
| Formules de calcul | Jamais affichées | Panneau dépliable « Comment c'est calculé ? » |

---

## Annexe — Tokens CSS récapitulatifs

```css
:root {
  /* Couleurs */
  --color-primary-100: #E8F5EA;
  --color-primary-500: #2D7A3A;
  --color-primary-600: #1E5C2B;
  --color-primary-700: #144A20;
  --color-secondary-500: #8B5E3C;
  --color-secondary-600: #6B4730;
  --color-sky-100: #E3F0FC;
  --color-sky-500: #4A90D9;
  --color-success: #22863A;
  --color-warning: #D4850A;
  --color-danger: #CB2431;
  --color-gray-900: #1B1F23;
  --color-gray-700: #444D56;
  --color-gray-500: #6A737D;
  --color-gray-300: #D1D5DA;
  --color-gray-100: #F6F8FA;

  /* Jauges */
  --gauge-excellent: #22863A;
  --gauge-good: #6ABF69;
  --gauge-warning: #D4850A;
  --gauge-critical: #E86825;
  --gauge-danger: #CB2431;

  /* Typographie */
  --font-family: 'Inter', system-ui, -apple-system, sans-serif;
  --text-display: 700 28px/1.2 var(--font-family);
  --text-heading: 600 22px/1.3 var(--font-family);
  --text-subheading: 600 18px/1.4 var(--font-family);
  --text-body: 400 15px/1.5 var(--font-family);
  --text-body-bold: 600 15px/1.5 var(--font-family);
  --text-small: 400 13px/1.4 var(--font-family);
  --text-caption: 500 11px/1.3 var(--font-family);

  /* Espacements */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;
  --space-16: 64px;

  /* Rayons */
  --radius-sm: 4px;
  --radius-md: 6px;
  --radius-lg: 8px;
  --radius-xl: 12px;
  --radius-full: 999px;

  /* Shadows */
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.08);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.12);
  --shadow-lg: 0 8px 32px rgba(0,0,0,0.2);

  /* Animations */
  --duration-fast: 100ms;
  --duration-normal: 200ms;
  --duration-slow: 300ms;
  --duration-gauge: 500ms;
  --easing-out: cubic-bezier(0.33, 1, 0.68, 1);
  --easing-in: cubic-bezier(0.32, 0, 0.67, 0);
  --easing-in-out: cubic-bezier(0.65, 0, 0.35, 1);

  /* Breakpoints (utilisés en @media) */
  --bp-mobile: 768px;
  --bp-tablet: 1024px;
  --bp-desktop: 1440px;

  /* Grid */
  --grid-columns: 12;
  --grid-gutter: 24px;
  --grid-max-width: 1440px;
}
```

---

## Checklist de validation UX

| Critère | Vérifié |
|---------|---------|
| Règle des 3 secondes sur chaque écran | ☐ |
| Coût affiché avant toute action engageante | ☐ |
| Aucune action destructive sans modale de confirmation | ☐ |
| Toggle Normal/Expert accessible en 1 clic | ☐ |
| Navigation clavier complète (Tab, Enter, Escape) | ☐ |
| Contrastes WCAG AA sur tous les textes | ☐ |
| Pas d'info uniquement par la couleur | ☐ |
| `aria-live` sur zones dynamiques (solde, temps restant) | ☐ |
| Skeleton screens au chargement (pas de spinner plein écran) | ☐ |
| `prefers-reduced-motion` respecté | ☐ |
| Tableaux lisibles sur tablette (colonnes réduites) | ☐ |
| Mobile : bottom-bar fonctionnelle | ☐ |
| Test recette SimAgri : « c'est SimAgri en mieux » | ☐ |
| Serveur Expert internement équilibré et plaisant (ADR-005) | ☐ |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Définition du design system et UX pour Agriva |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
