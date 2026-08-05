# 01 — Identité Visuelle & Design System — Cultivia

> **Réunion créative** : Directeur Artistique (DA), UI Designer (UI), Frontend Dev Vue 3 (FE)
> Date : 5 avril 2026 — Version 1.0

---

## Table des matières

1. [Identité de marque](#1--identité-de-marque)
2. [Palette couleurs](#2--palette-couleurs)
3. [Typographie](#3--typographie)
4. [Iconographie](#4--iconographie)
5. [Thème](#5--thème)
6. [Design System — Composants Vue](#6--design-system--composants-vue)
7. [Layouts](#7--layouts)
8. [Wireframes textuels](#8--wireframes-textuels)

---

## 1 — Identité de marque

**DA** : Cultivia doit évoquer la terre, le labeur, la satisfaction de voir pousser. On est entre le jeu de gestion sérieux et l'univers chaleureux du terroir français. Pas de cartoon, pas de réalisme photo — un flat design organique avec des textures subtiles.

**UI** : Attention à ne pas tomber dans le "trop rustique" qui ferait vieillot. On cible des joueurs web, il faut que ça reste moderne et lisible. Le flat organique c'est bien, mais avec des lignes nettes.

**FE** : Côté perf, le flat design c'est idéal — pas de textures lourdes, tout en CSS. On peut ajouter des micro-textures via `background-image` avec des SVG inline légers si besoin.

### Tagline

> **« Cultivez votre empire agricole »**

Alternatives : "De la graine au marché" (sous-titre), "Simulateur agricole multijoueur"

### Personnalité de marque

| Trait | Description | Ce qu'on évite |
|-------|-------------|----------------|
| **Authentique** | Ancré dans le réel agricole français | Fantaisie, cartoon |
| **Stratégique** | Chaque décision compte (HT, saisons, économie) | Casual, idle game |
| **Chaleureux** | Communauté, entraide, coopératives | Froid, corporate |
| **Progressif** | Satisfaction de la croissance lente | Instant gratification |

### Ton éditorial

- **Notifications** : direct, informatif — "Votre blé est mature. Récoltez avant la pluie."
- **Erreurs** : empathique, solution — "Fonds insuffisants — vendez votre récolte ou demandez un prêt."
- **Succès** : sobre mais satisfaisant — "50 T de blé récoltées ! Qualité ⭐⭐⭐"
- **Tutoriel** : pédagogue, pas condescendant — "Le labour prépare le sol. Utilisez votre tracteur + charrue."

---

## 2 — Palette couleurs

**DA** : La terre et le vert comme fondation. Des accents chauds pour les actions, du bleu pour l'eau et la banque. Chaque système de jeu a sa couleur signature.

**UI** : Il faut vérifier le contraste WCAG AA (4.5:1 texte normal, 3:1 gros texte) sur chaque combinaison fond/texte. Et prévoir les états : hover, active, disabled.

**FE** : Tout en CSS custom properties sur `:root`. On pourra ajouter un dark mode plus tard en surchargeant les variables.

### Primaires — Terre & Vert

| Nom | Hex | Usage | Contraste sur blanc |
|-----|-----|-------|---------------------|
| `--color-earth-900` | `#3E2723` | Texte principal, titres | 14.7:1 ✅ AAA |
| `--color-earth-700` | `#5D4037` | Texte secondaire | 9.5:1 ✅ AAA |
| `--color-earth-500` | `#8D6E63` | Bordures, icônes inactives | 4.6:1 ✅ AA |
| `--color-earth-200` | `#D7CCC8` | Fond cartes, séparateurs | — (fond) |
| `--color-earth-50` | `#EFEBE9` | Fond page secondaire | — (fond) |
| `--color-green-700` | `#2E7D32` | Primaire action, succès, nature | 5.9:1 ✅ AA |
| `--color-green-500` | `#4CAF50` | Hover primaire, badges positifs | 3.0:1 ⚠️ (gros texte) |
| `--color-green-100` | `#C8E6C9` | Fond succès léger | — (fond) |

### Secondaires — Accents

| Nom | Hex | Usage | Contraste sur blanc |
|-----|-----|-------|---------------------|
| `--color-amber-600` | `#F57F17` | Avertissement, saison été, HT | 3.4:1 ⚠️ gros texte |
| `--color-amber-100` | `#FFF8E1` | Fond warning | — (fond) |
| `--color-blue-600` | `#1565C0` | Eau, banque, liens | 7.0:1 ✅ AA |
| `--color-blue-100` | `#BBDEFB` | Fond info | — (fond) |
| `--color-red-600` | `#C62828` | Danger, erreur, dette | 7.8:1 ✅ AA |
| `--color-red-100` | `#FFCDD2` | Fond erreur | — (fond) |

### États fonctionnels

| Nom | Hex | Usage |
|-----|-----|-------|
| `--color-success` | `#2E7D32` | = green-700 |
| `--color-warning` | `#F57F17` | = amber-600 |
| `--color-error` | `#C62828` | = red-600 |
| `--color-info` | `#1565C0` | = blue-600 |

### Fonds & Surfaces

| Nom | Hex | Usage |
|-----|-----|-------|
| `--color-bg-primary` | `#FAFAF5` | Fond page principal (blanc cassé chaud) |
| `--color-bg-secondary` | `#EFEBE9` | = earth-50, fond sections |
| `--color-bg-card` | `#FFFFFF` | Fond cartes |
| `--color-bg-overlay` | `rgba(62, 39, 35, 0.5)` | Overlay modales |

### Textes

| Nom | Hex | Usage | Contraste sur bg-primary |
|-----|-----|-------|--------------------------|
| `--color-text-primary` | `#3E2723` | Titres, texte principal | 14.2:1 ✅ AAA |
| `--color-text-secondary` | `#5D4037` | Descriptions, labels | 9.2:1 ✅ AAA |
| `--color-text-muted` | `#8D6E63` | Placeholders, hints | 4.5:1 ✅ AA |
| `--color-text-inverse` | `#FAFAF5` | Texte sur fond sombre | — |
| `--color-text-link` | `#1565C0` | Liens | 6.8:1 ✅ AA |

### Saisons

| Saison | Hex | Variable |
|--------|-----|----------|
| 🌸 Printemps | `#66BB6A` | `--color-season-spring` |
| ☀️ Été | `#FFA726` | `--color-season-summer` |
| 🍂 Automne | `#D84315` | `--color-season-autumn` |
| ❄️ Hiver | `#42A5F5` | `--color-season-winter` |

### CSS Variables

```css
:root {
  /* Primaires */
  --color-earth-900: #3E2723;
  --color-earth-700: #5D4037;
  --color-earth-500: #8D6E63;
  --color-earth-200: #D7CCC8;
  --color-earth-50: #EFEBE9;
  --color-green-700: #2E7D32;
  --color-green-500: #4CAF50;
  --color-green-100: #C8E6C9;

  /* Accents */
  --color-amber-600: #F57F17;
  --color-amber-100: #FFF8E1;
  --color-blue-600: #1565C0;
  --color-blue-100: #BBDEFB;
  --color-red-600: #C62828;
  --color-red-100: #FFCDD2;

  /* Sémantiques */
  --color-success: var(--color-green-700);
  --color-warning: var(--color-amber-600);
  --color-error: var(--color-red-600);
  --color-info: var(--color-blue-600);

  /* Fonds */
  --color-bg-primary: #FAFAF5;
  --color-bg-secondary: var(--color-earth-50);
  --color-bg-card: #FFFFFF;
  --color-bg-overlay: rgba(62, 39, 35, 0.5);

  /* Textes */
  --color-text-primary: var(--color-earth-900);
  --color-text-secondary: var(--color-earth-700);
  --color-text-muted: var(--color-earth-500);
  --color-text-inverse: #FAFAF5;
  --color-text-link: var(--color-blue-600);

  /* Saisons */
  --color-season-spring: #66BB6A;
  --color-season-summer: #FFA726;
  --color-season-autumn: #D84315;
  --color-season-winter: #42A5F5;
}
```

---

## 3 — Typographie

**DA** : On veut une typo titre avec du caractère — pas trop serif, pas trop géométrique. Le corps doit être ultra-lisible pour les tableaux de données. Et un mono pour les chiffres financiers.

**UI** : Je propose Nunito pour les titres (rondeur chaleureuse), Inter pour le corps (lisibilité data), JetBrains Mono pour les montants. Tout en Google Fonts, chargement optimisé.

**FE** : On charge via `@fontsource` en npm pour éviter le FOUT. Fallback system fonts. Échelle en rem pour le responsive.

### Familles

| Rôle | Font | Poids | Google Fonts |
|------|------|-------|--------------|
| Titres | **Nunito** | 700, 800 | `family=Nunito:wght@700;800` |
| Corps | **Inter** | 400, 500, 600 | `family=Inter:wght@400;500;600` |
| Mono / Chiffres | **JetBrains Mono** | 400, 500 | `family=JetBrains+Mono:wght@400;500` |

### Échelle typographique

| Token | Élément | Size (rem) | Line-height | Weight | Font |
|-------|---------|-----------|-------------|--------|------|
| `--text-h1` | h1 | 2.0 | 1.2 | 800 | Nunito |
| `--text-h2` | h2 | 1.5 | 1.25 | 700 | Nunito |
| `--text-h3` | h3 | 1.25 | 1.3 | 700 | Nunito |
| `--text-h4` | h4 | 1.125 | 1.35 | 700 | Nunito |
| `--text-body` | p, td | 1.0 | 1.5 | 400 | Inter |
| `--text-body-medium` | labels | 1.0 | 1.5 | 500 | Inter |
| `--text-small` | small, hints | 0.875 | 1.4 | 400 | Inter |
| `--text-caption` | badges, tags | 0.75 | 1.3 | 500 | Inter |
| `--text-mono` | montants | 1.0 | 1.5 | 400 | JetBrains Mono |
| `--text-mono-lg` | solde header | 1.25 | 1.3 | 500 | JetBrains Mono |

### CSS Variables

```css
:root {
  --font-title: 'Nunito', system-ui, sans-serif;
  --font-body: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;

  --text-h1: 800 2rem/1.2 var(--font-title);
  --text-h2: 700 1.5rem/1.25 var(--font-title);
  --text-h3: 700 1.25rem/1.3 var(--font-title);
  --text-h4: 700 1.125rem/1.35 var(--font-title);
  --text-body: 400 1rem/1.5 var(--font-body);
  --text-body-medium: 500 1rem/1.5 var(--font-body);
  --text-small: 400 0.875rem/1.4 var(--font-body);
  --text-caption: 500 0.75rem/1.3 var(--font-body);
  --text-mono: 400 1rem/1.5 var(--font-mono);
  --text-mono-lg: 500 1.25rem/1.3 var(--font-mono);
}
```

---

## 4 — Iconographie

**DA** : Lucide Icons comme base — c'est cohérent, léger, open source. Pour les icônes métier spécifiques au jeu (HT, météo, saisons, cultures, animaux, qualité), on crée des icônes custom SVG dans le même style stroke 2px.

**UI** : On standardise : 24×24 par défaut, 16×16 pour inline, 32×32 pour les cartes. Couleur héritée via `currentColor`.

**FE** : `lucide-vue-next` en tree-shaking. Les icônes custom dans `src/client/assets/icons/` en composants Vue SFC pour le même API.

### Lucide Icons — Mapping fonctionnel

| Fonction | Icône Lucide | Nom |
|----------|-------------|-----|
| Dashboard | `LayoutDashboard` | layout-dashboard |
| Parcelles | `Map` | map |
| Bâtiments | `Building2` | building-2 |
| Matériels | `Tractor` | tractor |
| Banque | `Landmark` | landmark |
| Coopérative | `Store` | store |
| Profil | `User` | user |
| Notifications | `Bell` | bell |
| Paramètres | `Settings` | settings |
| Ajouter | `Plus` | plus |
| Modifier | `Pencil` | pencil |
| Supprimer | `Trash2` | trash-2 |
| Rechercher | `Search` | search |
| Filtrer | `Filter` | filter |
| Trier | `ArrowUpDown` | arrow-up-down |
| Chevron | `ChevronRight` | chevron-right |
| Fermer | `X` | x |
| Info | `Info` | info |
| Warning | `AlertTriangle` | alert-triangle |
| Erreur | `AlertCircle` | alert-circle |
| Succès | `CheckCircle2` | check-circle-2 |
| Argent | `Coins` | coins |
| Prêt | `HandCoins` | hand-coins |
| Énergie | `Zap` | zap |
| Eau | `Droplets` | droplets |
| Soleil | `Sun` | sun |
| Vent | `Wind` | wind |
| Entretien | `Wrench` | wrench |
| Récolte | `Wheat` | wheat |
| Semis | `Sprout` | sprout |
| Œil toggle | `Eye` / `EyeOff` | eye / eye-off |
| Calendrier | `Calendar` | calendar |
| Horloge | `Clock` | clock |
| Graphique | `BarChart3` | bar-chart-3 |

### Icônes custom jeu

Toutes en SVG stroke 2px, viewBox 24×24, `currentColor`.

#### Heures de Travail (HT)

```
⚡ Éclair stylisé dans un cercle
- Plein : HT disponibles
- Demi : HT partiels
- Vide : HT épuisés
```

Variable : `--icon-pa`

#### Météo — 5 niveaux

| Niveau | Icône | Description |
|--------|-------|-------------|
| 1 — Soleil | ☀️ | Cercle + rayons (Lucide `Sun`) |
| 2 — Éclaircies | 🌤️ | Soleil + petit nuage |
| 3 — Couvert | ☁️ | Nuage plein (Lucide `Cloud`) |
| 4 — Pluie | 🌧️ | Nuage + gouttes (Lucide `CloudRain`) |
| 5 — Orage | ⛈️ | Nuage + éclair (Lucide `CloudLightning`) |

Extras : `Wind` (💨 vent), `CloudHail` (⚠️ grêle)

#### Saisons — 4

| Saison | Icône | Couleur |
|--------|-------|---------|
| Printemps | 🌱 Pousse / fleur | `--color-season-spring` |
| Été | ☀️ Soleil plein | `--color-season-summer` |
| Automne | 🍂 Feuille tombante | `--color-season-autumn` |
| Hiver | ❄️ Flocon | `--color-season-winter` |

#### Cultures

| Culture | Icône |
|---------|-------|
| Blé | 🌾 Épi (Lucide `Wheat`) |
| Orge | Épi court |
| Colza | Fleur jaune |
| Tournesol | Fleur soleil |
| Maïs | Épi maïs |
| Betterave | Racine |
| Pomme de terre | Tubercule |
| Herbe / Pré | Brins d'herbe |
|  | Terre nue (tirets) |

#### Animaux

| Animal | Icône |
|--------|-------|
| Bovin | Tête vache |
| Ovin | Tête mouton |
| Caprin | Tête chèvre |
| Porcin | Tête cochon |
| Volaille | Poule |
| Cheval | Tête cheval |

#### Qualité — 3 niveaux

| Niveau | Icône | Couleur |
|--------|-------|---------|
| Q1 — Standard | ⭐ | `--color-amber-600` |
| Q2 — Bonne | ⭐⭐ | `--color-amber-600` |
| Q3 — Excellente | ⭐⭐⭐ | `--color-amber-600` |

Composant `<QualityStars :level="3" />` — affiche N étoiles pleines.

### Tailles standard

```css
:root {
  --icon-sm: 16px;
  --icon-md: 24px;
  --icon-lg: 32px;
}
```

---

## 5 — Thème

**DA** : Coins arrondis doux (8px), ombres très subtiles — on veut de la profondeur sans effet "carte qui flotte". Grille 8px pour tout aligner. Transitions rapides (200ms) pour que ça reste snappy.

**UI** : Le 8px grid c'est la base. Tous les spacings multiples de 8. Les ombres en 2 niveaux : cartes posées (sm) et modales élevées (lg). Pas d'ombre sur les boutons.

**FE** : Tout en custom properties. La grille 8px se traduit par un spacing scale. Les transitions avec `ease` pour le naturel.

### Rayons de bordure

```css
:root {
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;
}
```

| Élément | Rayon |
|---------|-------|
| Boutons | `--radius-md` (8px) |
| Cartes | `--radius-lg` (12px) |
| Inputs | `--radius-md` (8px) |
| Badges / Tags | `--radius-full` |
| Modales | `--radius-xl` (16px) |
| Tooltips | `--radius-md` (8px) |

### Ombres

```css
:root {
  --shadow-sm: 0 1px 3px rgba(62, 39, 35, 0.08);
  --shadow-md: 0 4px 12px rgba(62, 39, 35, 0.1);
  --shadow-lg: 0 8px 24px rgba(62, 39, 35, 0.15);
}
```

| Élément | Ombre |
|---------|-------|
| Cartes | `--shadow-sm` |
| Cartes hover | `--shadow-md` |
| Dropdowns, tooltips | `--shadow-md` |
| Modales | `--shadow-lg` |

### Espacement — Grille 8px

```css
:root {
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
}
```

### Transitions

```css
:root {
  --transition-fast: 150ms ease;
  --transition-base: 200ms ease;
  --transition-slow: 300ms ease;
}
```

| Élément | Transition |
|---------|-----------|
| Boutons (hover, active) | `--transition-fast` |
| Cartes (hover shadow) | `--transition-base` |
| Modales (entrée/sortie) | `--transition-slow` |
| Barres de progression | `--transition-slow` |
| Sidebar collapse | `--transition-slow` |
| Toasts (slide in) | `--transition-base` |

### Bordures

```css
:root {
  --border-width: 1px;
  --border-color: var(--color-earth-200);
  --border: var(--border-width) solid var(--border-color);
}
```

### Z-index

```css
:root {
  --z-base: 0;
  --z-dropdown: 100;
  --z-sticky: 200;
  --z-overlay: 300;
  --z-modal: 400;
  --z-toast: 500;
  --z-tooltip: 600;
}
```

---

## 6 — Design System — Composants Vue

**DA** : Chaque composant doit respirer le terroir sans sacrifier la modernité. Les couleurs terre en fond, le vert pour les actions positives.

**UI** : On documente chaque état, chaque taille. Un dev doit pouvoir implémenter sans poser de question.

**FE** : Tous les composants dans `src/client/components/ui/` (base) et `src/client/components/game/` (jeu). Props TypeScript, slots nommés, émissions typées.

---

### 6.1 — Composants Base

---

#### `<CButton>`

**Props** :

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `'primary' \| 'secondary' \| 'danger' \| 'ghost'` | `'primary'` | Style visuel |
| `size` | `'sm' \| 'md' \| 'lg'` | `'md'` | Taille |
| `disabled` | `boolean` | `false` | Désactivé |
| `loading` | `boolean` | `false` | Affiche spinner |
| `icon` | `Component` | — | Icône Lucide à gauche |
| `fullWidth` | `boolean` | `false` | Pleine largeur |

**Tailles** :

| Size | Height | Padding | Font |
|------|--------|---------|------|
| `sm` | 32px | 0 12px | `--text-small` |
| `md` | 40px | 0 16px | `--text-body-medium` |
| `lg` | 48px | 0 24px | `--text-body-medium` |

**Variantes CSS** :

```css
/* Primary */
.btn-primary {
  background: var(--color-green-700);
  color: var(--color-text-inverse);
  border: none;
}
.btn-primary:hover { background: #256427; }
.btn-primary:active { background: #1B5E20; }

/* Secondary */
.btn-secondary {
  background: var(--color-bg-card);
  color: var(--color-text-primary);
  border: var(--border);
}
.btn-secondary:hover { background: var(--color-earth-50); }

/* Danger */
.btn-danger {
  background: var(--color-red-600);
  color: var(--color-text-inverse);
  border: none;
}
.btn-danger:hover { background: #B71C1C; }

/* Ghost */
.btn-ghost {
  background: transparent;
  color: var(--color-text-secondary);
  border: none;
}
.btn-ghost:hover { background: var(--color-earth-50); }

/* Disabled (tous) */
.btn:disabled, .btn[aria-disabled="true"] {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

/* Loading */
.btn--loading {
  color: transparent;
  position: relative;
}
.btn--loading::after {
  content: '';
  position: absolute;
  width: 16px; height: 16px;
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: var(--radius-full);
  animation: spin 0.6s linear infinite;
}

/* Commun */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  border-radius: var(--radius-md);
  font: var(--text-body-medium);
  cursor: pointer;
  transition: background var(--transition-fast), box-shadow var(--transition-fast);
}
.btn--full { width: 100%; }

@keyframes spin { to { transform: rotate(360deg); } }
```

**Template Vue** :

```vue
<template>
  <button
    class="btn"
    :class="[
      `btn-${variant}`,
      `btn--${size}`,
      { 'btn--loading': loading, 'btn--full': fullWidth }
    ]"
    :disabled="disabled || loading"
    :aria-disabled="disabled || loading"
    :aria-busy="loading"
  >
    <component :is="icon" v-if="icon && !loading" :size="size === 'sm' ? 14 : 18" />
    <slot />
  </button>
</template>
```

---

#### `<CInput>`

**Props** :

| Prop | Type | Default |
|------|------|---------|
| `modelValue` | `string \| number` | — |
| `type` | `'text' \| 'email' \| 'password' \| 'number'` | `'text'` |
| `label` | `string` | — |
| `placeholder` | `string` | — |
| `error` | `string` | — |
| `hint` | `string` | — |
| `disabled` | `boolean` | `false` |
| `icon` | `Component` | — |

**CSS** :

```css
.input-wrapper { display: flex; flex-direction: column; gap: var(--space-1); }

.input-label {
  font: var(--text-small);
  font-weight: 500;
  color: var(--color-text-secondary);
}

.input-field {
  height: 40px;
  padding: 0 var(--space-4);
  border: var(--border);
  border-radius: var(--radius-md);
  font: var(--text-body);
  color: var(--color-text-primary);
  background: var(--color-bg-card);
  transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
}
.input-field:focus {
  outline: none;
  border-color: var(--color-green-700);
  box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.15);
}
.input-field--error {
  border-color: var(--color-error);
}
.input-field--error:focus {
  box-shadow: 0 0 0 3px rgba(198, 40, 40, 0.15);
}
.input-field:disabled {
  background: var(--color-earth-50);
  opacity: 0.6;
  cursor: not-allowed;
}
.input-field::placeholder { color: var(--color-text-muted); }

.input-error { font: var(--text-small); color: var(--color-error); }
.input-hint { font: var(--text-small); color: var(--color-text-muted); }

/* Avec icône */
.input-icon-wrapper { position: relative; }
.input-icon-wrapper .input-field { padding-left: var(--space-10); }
.input-icon-wrapper .input-icon {
  position: absolute;
  left: var(--space-3);
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-text-muted);
}
```

---

#### `<CSelect>`

**Props** : `modelValue`, `options: { value: string; label: string; disabled?: boolean }[]`, `label`, `placeholder`, `error`, `disabled`

**CSS** : Même style que `<CInput>` avec flèche chevron à droite via `background-image` SVG inline.

```css
.select-field {
  appearance: none;
  height: 40px;
  padding: 0 var(--space-10) 0 var(--space-4);
  border: var(--border);
  border-radius: var(--radius-md);
  font: var(--text-body);
  color: var(--color-text-primary);
  background: var(--color-bg-card) url("data:image/svg+xml,...chevron...") no-repeat right 12px center;
  background-size: 16px;
  cursor: pointer;
}
.select-field:focus {
  outline: none;
  border-color: var(--color-green-700);
  box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.15);
}
```

---

#### `<CCheckbox>`

**Props** : `modelValue: boolean`, `label`, `disabled`

```css
.checkbox {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
}
.checkbox-input {
  width: 20px; height: 20px;
  border: 2px solid var(--color-earth-500);
  border-radius: var(--radius-sm);
  transition: all var(--transition-fast);
  display: grid;
  place-content: center;
}
.checkbox-input--checked {
  background: var(--color-green-700);
  border-color: var(--color-green-700);
}
/* Checkmark via SVG pseudo-element ou icône Lucide Check */
.checkbox-label { font: var(--text-body); color: var(--color-text-primary); }
```

---

#### `<CToggle>`

**Props** : `modelValue: boolean`, `label`, `disabled`

```css
.toggle-track {
  width: 44px; height: 24px;
  border-radius: var(--radius-full);
  background: var(--color-earth-200);
  transition: background var(--transition-fast);
  position: relative;
  cursor: pointer;
}
.toggle-track--active { background: var(--color-green-700); }
.toggle-thumb {
  width: 20px; height: 20px;
  border-radius: var(--radius-full);
  background: white;
  box-shadow: var(--shadow-sm);
  position: absolute;
  top: 2px; left: 2px;
  transition: transform var(--transition-fast);
}
.toggle-track--active .toggle-thumb { transform: translateX(20px); }
```

---

#### `<CBadge>`

**Props** : `variant: 'success' | 'warning' | 'error' | 'info' | 'neutral'`, `size: 'sm' | 'md'`

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: 2px var(--space-2);
  border-radius: var(--radius-full);
  font: var(--text-caption);
  white-space: nowrap;
}
.badge--sm { padding: 1px var(--space-1); font-size: 0.625rem; }
.badge--success { background: var(--color-green-100); color: var(--color-green-700); }
.badge--warning { background: var(--color-amber-100); color: #E65100; }
.badge--error { background: var(--color-red-100); color: var(--color-red-600); }
.badge--info { background: var(--color-blue-100); color: var(--color-blue-600); }
.badge--neutral { background: var(--color-earth-200); color: var(--color-earth-700); }
```

---

#### `<CTag>`

**Props** : `label: string`, `removable: boolean`, `color: string` (hex optionnel)

```css
.tag {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-full);
  font: var(--text-caption);
  background: var(--color-earth-50);
  color: var(--color-text-secondary);
  border: var(--border);
}
.tag-remove {
  width: 14px; height: 14px;
  cursor: pointer;
  opacity: 0.6;
}
.tag-remove:hover { opacity: 1; }
```

---

#### `<CTooltip>`

**Props** : `content: string`, `position: 'top' | 'bottom' | 'left' | 'right'`

```css
.tooltip {
  position: absolute;
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-md);
  background: var(--color-earth-900);
  color: var(--color-text-inverse);
  font: var(--text-small);
  box-shadow: var(--shadow-md);
  z-index: var(--z-tooltip);
  max-width: 240px;
  pointer-events: none;
  animation: tooltip-in var(--transition-fast);
}
@keyframes tooltip-in {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}
```

**FE** : Implémenté via directive `v-tooltip="'Texte'"` ou composant wrapper. Utilise `floating-ui` pour le positionnement.

---

#### `<CToast>`

**Props** : `variant: 'success' | 'warning' | 'error' | 'info'`, `message: string`, `duration: number` (default 5000)

```css
.toast-container {
  position: fixed;
  top: var(--space-4);
  right: var(--space-4);
  z-index: var(--z-toast);
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}
.toast {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-md);
  font: var(--text-body);
  min-width: 300px;
  max-width: 480px;
  animation: toast-in var(--transition-base);
}
.toast--success { background: var(--color-green-100); color: var(--color-green-700); border-left: 4px solid var(--color-green-700); }
.toast--warning { background: var(--color-amber-100); color: #E65100; border-left: 4px solid var(--color-amber-600); }
.toast--error { background: var(--color-red-100); color: var(--color-red-600); border-left: 4px solid var(--color-red-600); }
.toast--info { background: var(--color-blue-100); color: var(--color-blue-600); border-left: 4px solid var(--color-blue-600); }

@keyframes toast-in {
  from { opacity: 0; transform: translateX(100%); }
  to { opacity: 1; transform: translateX(0); }
}
```

**FE** : Géré via composable `useToast()` → `toast.success('Message')`. Store Pinia `useToastStore` avec queue.

---

#### `<CModal>`

**Props** : `modelValue: boolean` (v-model open), `title: string`, `size: 'sm' | 'md' | 'lg'`, `danger: boolean`

**Tailles** : sm=400px, md=560px, lg=720px

```css
.modal-overlay {
  position: fixed;
  inset: 0;
  background: var(--color-bg-overlay);
  z-index: var(--z-modal);
  display: grid;
  place-items: center;
  animation: fade-in var(--transition-base);
}
.modal {
  background: var(--color-bg-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-lg);
  max-height: 90vh;
  overflow-y: auto;
  animation: modal-in var(--transition-slow);
}
.modal--sm { width: 400px; }
.modal--md { width: 560px; }
.modal--lg { width: 720px; }
.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-6);
  border-bottom: var(--border);
}
.modal-header--danger { border-bottom-color: var(--color-red-600); }
.modal-title { font: var(--text-h3); color: var(--color-text-primary); }
.modal-body { padding: var(--space-6); }
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: var(--space-3);
  padding: var(--space-4) var(--space-6);
  border-top: var(--border);
}

@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
@keyframes modal-in {
  from { opacity: 0; transform: scale(0.95) translateY(8px); }
  to { opacity: 1; transform: scale(1) translateY(0); }
}
```

**FE** : Teleport to `<body>`. Trap focus. Ferme sur Escape et clic overlay. `aria-modal="true"`, `role="dialog"`.

---

#### `<CSpinner>`

**Props** : `size: 'sm' | 'md' | 'lg'` (16/24/32px)

```css
.spinner {
  border: 2px solid var(--color-earth-200);
  border-top-color: var(--color-green-700);
  border-radius: var(--radius-full);
  animation: spin 0.6s linear infinite;
}
.spinner--sm { width: 16px; height: 16px; }
.spinner--md { width: 24px; height: 24px; }
.spinner--lg { width: 32px; height: 32px; }
```


---

### 6.2 — Composants Données

---

#### `<CDataTable>`

**Props** :

| Prop | Type | Description |
|------|------|-------------|
| `columns` | `Column[]` | `{ key, label, sortable?, align?, width? }` |
| `rows` | `any[]` | Données |
| `sortBy` | `string` | Colonne de tri active |
| `sortDir` | `'asc' \| 'desc'` | Direction |
| `page` | `number` | Page courante |
| `pageSize` | `number` | Lignes/page (default 20) |
| `total` | `number` | Total lignes (pagination serveur) |
| `loading` | `boolean` | Skeleton rows |
| `filters` | `Filter[]` | Filtres actifs |
| `emptyMessage` | `string` | Message si vide |

**Slots** : `#cell-{key}="{ row, value }"` pour personnaliser chaque cellule.

```css
.data-table { width: 100%; border-collapse: separate; border-spacing: 0; }

.data-table th {
  font: var(--text-caption);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
  padding: var(--space-3) var(--space-4);
  border-bottom: 2px solid var(--color-earth-200);
  text-align: left;
  white-space: nowrap;
  user-select: none;
}
.data-table th--sortable { cursor: pointer; }
.data-table th--sortable:hover { color: var(--color-text-primary); }
.data-table th--active { color: var(--color-green-700); }

.data-table td {
  font: var(--text-body);
  padding: var(--space-3) var(--space-4);
  border-bottom: var(--border);
  vertical-align: middle;
}
.data-table tr:hover td { background: var(--color-earth-50); }
.data-table tr:last-child td { border-bottom: none; }

/* Pagination */
.table-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-4) 0;
  font: var(--text-small);
  color: var(--color-text-muted);
}

/* Skeleton loading */
.table-skeleton td {
  height: 20px;
  background: linear-gradient(90deg, var(--color-earth-50) 25%, var(--color-earth-200) 50%, var(--color-earth-50) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: var(--radius-sm);
}
@keyframes shimmer { to { background-position: -200% 0; } }

/* Responsive : mode carte sous 768px */
@media (max-width: 768px) {
  .data-table thead { display: none; }
  .data-table tr {
    display: block;
    padding: var(--space-4);
    border: var(--border);
    border-radius: var(--radius-lg);
    margin-bottom: var(--space-3);
    background: var(--color-bg-card);
  }
  .data-table td {
    display: flex;
    justify-content: space-between;
    padding: var(--space-1) 0;
    border: none;
  }
  .data-table td::before {
    content: attr(data-label);
    font-weight: 500;
    color: var(--color-text-muted);
  }
}
```

---

#### `<CCard>`

**Props** : `title: string`, `subtitle: string`, `hoverable: boolean`, `padding: 'sm' | 'md' | 'lg'`

```css
.card {
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}
.card--hoverable { cursor: pointer; transition: box-shadow var(--transition-base); }
.card--hoverable:hover { box-shadow: var(--shadow-md); }
.card-header {
  padding: var(--space-4) var(--space-6);
  border-bottom: var(--border);
}
.card-title { font: var(--text-h4); color: var(--color-text-primary); }
.card-subtitle { font: var(--text-small); color: var(--color-text-muted); margin-top: var(--space-1); }
.card-body--sm { padding: var(--space-3); }
.card-body--md { padding: var(--space-6); }
.card-body--lg { padding: var(--space-8); }
.card-footer {
  padding: var(--space-3) var(--space-6);
  border-top: var(--border);
  background: var(--color-earth-50);
}
```

---

#### `<CStatCard>`

**Props** : `label: string`, `value: string | number`, `icon: Component`, `trend: 'up' | 'down' | 'neutral'`, `trendValue: string`, `color: string`

```css
.stat-card {
  display: flex;
  align-items: flex-start;
  gap: var(--space-4);
  padding: var(--space-5);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}
.stat-icon {
  width: 48px; height: 48px;
  border-radius: var(--radius-md);
  display: grid;
  place-content: center;
}
.stat-label { font: var(--text-small); color: var(--color-text-muted); }
.stat-value { font: var(--text-mono-lg); color: var(--color-text-primary); margin-top: var(--space-1); }
.stat-trend { font: var(--text-caption); margin-top: var(--space-1); }
.stat-trend--up { color: var(--color-success); }
.stat-trend--down { color: var(--color-error); }
```

---

#### `<CProgressBar>`

**Props** : `value: number` (0-100), `max: number`, `color: string`, `showLabel: boolean`, `size: 'sm' | 'md'`

```css
.progress { width: 100%; border-radius: var(--radius-full); background: var(--color-earth-200); overflow: hidden; }
.progress--sm { height: 6px; }
.progress--md { height: 10px; }
.progress-fill {
  height: 100%;
  border-radius: var(--radius-full);
  transition: width var(--transition-slow);
  background: var(--color-green-700);
}
.progress-fill--warning { background: var(--color-amber-600); }
.progress-fill--danger { background: var(--color-red-600); }
.progress-label { font: var(--text-caption); color: var(--color-text-muted); margin-top: var(--space-1); }
```

---

#### `<CGauge>`

**Props** : `value: number`, `max: number`, `label: string`, `unit: string`, `optimalMin: number`, `optimalMax: number`, `color: string`, `vertical: boolean`

Usage : jauges nutriments (N/P/K/Ca/Mg/S), eau, soleil.

```css
/* Jauge verticale (nutriments) */
.gauge-v {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-1);
  width: 32px;
}
.gauge-v-track {
  width: 12px;
  height: 80px;
  border-radius: var(--radius-full);
  background: var(--color-earth-200);
  position: relative;
  overflow: hidden;
}
.gauge-v-fill {
  position: absolute;
  bottom: 0;
  width: 100%;
  border-radius: var(--radius-full);
  transition: height var(--transition-slow);
}
.gauge-v-optimal {
  position: absolute;
  width: 100%;
  border-left: 2px dashed rgba(46, 125, 50, 0.4);
  border-right: 2px dashed rgba(46, 125, 50, 0.4);
}
.gauge-v-label { font: var(--text-caption); color: var(--color-text-muted); }
.gauge-v-value { font: var(--text-caption); font-family: var(--font-mono); }

/* Jauge horizontale (eau, soleil, remplissage) */
.gauge-h {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.gauge-h-track {
  flex: 1;
  height: 8px;
  border-radius: var(--radius-full);
  background: var(--color-earth-200);
  position: relative;
  overflow: hidden;
}
.gauge-h-fill {
  height: 100%;
  border-radius: var(--radius-full);
  transition: width var(--transition-slow);
}
```

**FE** : La couleur du fill est calculée dynamiquement :
```typescript
function gaugeColor(value: number, max: number): string {
  const pct = value / max * 100
  if (pct <= 20) return 'var(--color-red-600)'
  if (pct <= 50) return 'var(--color-amber-600)'
  return 'var(--color-green-700)'
}
```

---

#### `<CTimeline>`

**Props** : `items: { date: string; label: string; icon?: Component; variant?: string }[]`

```css
.timeline { position: relative; padding-left: var(--space-8); }
.timeline::before {
  content: '';
  position: absolute;
  left: 11px; top: 0; bottom: 0;
  width: 2px;
  background: var(--color-earth-200);
}
.timeline-item {
  position: relative;
  padding-bottom: var(--space-6);
}
.timeline-dot {
  position: absolute;
  left: calc(-1 * var(--space-8) + 4px);
  width: 16px; height: 16px;
  border-radius: var(--radius-full);
  background: var(--color-green-700);
  border: 2px solid var(--color-bg-card);
}
.timeline-date { font: var(--text-caption); color: var(--color-text-muted); }
.timeline-label { font: var(--text-body); color: var(--color-text-primary); margin-top: var(--space-1); }
```


---

### 6.3 — Composants Jeu

---

#### `<HTBar>`

Barre de Heures de Travail dans le header. Affichage circulaire + texte.

**Props** : `current: number`, `max: number`

```css
.ht-bar {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.pa-ring {
  width: 36px; height: 36px;
  position: relative;
}
.pa-ring svg {
  transform: rotate(-90deg);
}
.pa-ring-bg { stroke: var(--color-earth-200); fill: none; stroke-width: 3; }
.pa-ring-fill {
  fill: none;
  stroke-width: 3;
  stroke-linecap: round;
  transition: stroke-dashoffset var(--transition-slow), stroke var(--transition-fast);
}
.pa-text {
  font: var(--text-caption);
  font-family: var(--font-mono);
  color: var(--color-text-primary);
}
.pa-text--low { color: var(--color-error); }
```

**FE** : Couleur dynamique du ring :
```typescript
const paColor = computed(() => {
  const pct = props.current / props.max
  if (pct < 0.2) return 'var(--color-red-600)'
  if (pct < 0.5) return 'var(--color-amber-600)'
  return 'var(--color-green-700)'
})
```

**Template** :
```vue
<template>
  <div class="ht-bar" :title="`${current} / ${max} HT`">
    <svg class="pa-ring" viewBox="0 0 36 36">
      <circle class="pa-ring-bg" cx="18" cy="18" r="15" />
      <circle
        class="pa-ring-fill"
        cx="18" cy="18" r="15"
        :stroke="paColor"
        :stroke-dasharray="circumference"
        :stroke-dashoffset="circumference * (1 - current / max)"
      />
    </svg>
    <span class="pa-text" :class="{ 'pa-text--low': current / max < 0.2 }">
      {{ current.toFixed(1) }} / {{ max }}
    </span>
  </div>
</template>
```

---

#### `<BalanceDisplay>`

Solde bancaire animé dans le header.

**Props** : `amount: number`

```css
.balance {
  font: var(--text-mono-lg);
  font-variant-numeric: tabular-nums;
  transition: color var(--transition-fast);
}
.balance--positive { color: var(--color-green-700); }
.balance--warning { color: var(--color-amber-600); }
.balance--negative { color: var(--color-red-600); }
```

**FE** : Animation compteur via `requestAnimationFrame` pour le défilement des chiffres lors des transactions. Seuils : > 10 000 = vert, 0–10 000 = orange, < 0 = rouge.

```typescript
const balanceClass = computed(() => {
  if (props.amount > 10000) return 'balance--positive'
  if (props.amount >= 0) return 'balance--warning'
  return 'balance--negative'
})
```

---

#### `<WeatherWidget>`

Widget météo de le canton du joueur.

**Props** : `level: 1|2|3|4|5`, `wind: boolean`, `hail: boolean`, `history: { level: number }[]`

```css
.weather {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-4);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
}
.weather-icon { font-size: 32px; }
.weather-label { font: var(--text-body-medium); color: var(--color-text-primary); }
.weather-alerts {
  display: flex;
  gap: var(--space-1);
}
.weather-alert {
  padding: 2px var(--space-2);
  border-radius: var(--radius-full);
  font: var(--text-caption);
}
.weather-alert--wind { background: var(--color-blue-100); color: var(--color-blue-600); }
.weather-alert--hail { background: var(--color-red-100); color: var(--color-red-600); }

/* Mini historique 7 jours */
.weather-history {
  display: flex;
  gap: 2px;
  align-items: flex-end;
  height: 24px;
}
.weather-history-bar {
  width: 6px;
  border-radius: 2px;
  transition: height var(--transition-base);
}
```

**FE** : Mapping niveau → icône Lucide :
```typescript
const weatherIcons = { 1: Sun, 2: CloudSun, 3: Cloud, 4: CloudRain, 5: CloudLightning }
const weatherLabels = { 1: 'Ensoleillé', 2: 'Éclaircies', 3: 'Couvert', 4: 'Pluie', 5: 'Orage' }
```

---

#### `<SeasonIndicator>`

Indicateur de saison dans le header/dashboard.

**Props** : `season: 'spring' | 'summer' | 'autumn' | 'winter'`, `day: number`, `year: number`

```css
.season {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-full);
  font: var(--text-small);
  font-weight: 500;
}
.season--spring { background: rgba(102, 187, 106, 0.15); color: #2E7D32; }
.season--summer { background: rgba(255, 167, 38, 0.15); color: #E65100; }
.season--autumn { background: rgba(216, 67, 21, 0.15); color: #BF360C; }
.season--winter { background: rgba(66, 165, 245, 0.15); color: #1565C0; }
.season-icon { font-size: 16px; }
```

---

#### `<ParcelCard>`

Carte résumé d'une parcelle (dashboard + liste).

**Props** : `parcel: { id, type, area_ha, soil_quality, crop?, growth_pct?, status, water, sun, zone }`

```css
.parcel-card {
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: var(--space-3);
  align-items: center;
  padding: var(--space-4);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
  transition: box-shadow var(--transition-base);
  cursor: pointer;
}
.parcel-card:hover { box-shadow: var(--shadow-md); }

.parcel-type-icon { font-size: 24px; }
.parcel-info { min-width: 0; }
.parcel-name { font: var(--text-body-medium); color: var(--color-text-primary); }
.parcel-meta { font: var(--text-small); color: var(--color-text-muted); }
.parcel-crop { font: var(--text-small); color: var(--color-text-secondary); }
.parcel-crop--fallow { font-style: italic; color: var(--color-text-muted); }

.parcel-status {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: var(--space-1);
}
.parcel-diode {
  width: 10px; height: 10px;
  border-radius: var(--radius-full);
}
.parcel-diode--ok { background: var(--color-success); }
.parcel-diode--warn { background: var(--color-warning); }
.parcel-diode--danger { background: var(--color-error); }
```

---

#### `<AnimalCard>`

**Props** : `animal: { id, species, breed, age, health, production?, quality? }`

```css
.animal-card {
  display: grid;
  grid-template-columns: 48px 1fr auto;
  gap: var(--space-3);
  align-items: center;
  padding: var(--space-4);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: box-shadow var(--transition-base);
}
.animal-card:hover { box-shadow: var(--shadow-md); }
.animal-avatar {
  width: 48px; height: 48px;
  border-radius: var(--radius-md);
  background: var(--color-earth-50);
  display: grid;
  place-content: center;
  font-size: 24px;
}
.animal-name { font: var(--text-body-medium); }
.animal-breed { font: var(--text-small); color: var(--color-text-muted); }
.animal-stats { display: flex; gap: var(--space-2); }
```

---

#### `<VehicleCard>`

**Props** : `vehicle: { id, name, family, power_cv?, wear_pct, broken, sheltered }`

```css
.vehicle-card {
  display: grid;
  grid-template-columns: 48px 1fr auto;
  gap: var(--space-3);
  align-items: center;
  padding: var(--space-4);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
}
.vehicle-card--broken { border-color: var(--color-red-600); background: var(--color-red-100); }
.vehicle-icon {
  width: 48px; height: 48px;
  border-radius: var(--radius-md);
  background: var(--color-earth-50);
  display: grid;
  place-content: center;
}
.vehicle-name { font: var(--text-body-medium); }
.vehicle-family { font: var(--text-caption); color: var(--color-text-muted); }
.vehicle-wear { width: 80px; }
.vehicle-badge-broken {
  font: var(--text-caption);
  color: var(--color-red-600);
  background: var(--color-red-100);
  padding: 2px var(--space-2);
  border-radius: var(--radius-full);
}
```

---

#### `<BuildingCard>`

**Props** : `building: { id, type, size, unit, level, max_level, wear_pct, fill_current, fill_max, energy_cost }`

```css
.building-card {
  padding: var(--space-4);
  background: var(--color-bg-card);
  border: var(--border);
  border-radius: var(--radius-lg);
}
.building-header {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  margin-bottom: var(--space-3);
}
.building-icon { font-size: 28px; }
.building-name { font: var(--text-body-medium); }
.building-size { font: var(--text-small); color: var(--color-text-muted); }
.building-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-2);
}
.building-stat-label { font: var(--text-caption); color: var(--color-text-muted); }
.building-stat-value { font: var(--text-small); font-family: var(--font-mono); }
```

---

#### `<MarketPrice>`

Affichage d'un prix avec indicateur de tendance saisonnière.

**Props** : `price: number`, `unit: string`, `seasonFactor: number`, `trend: 'up' | 'down' | 'stable'`

```css
.market-price {
  display: flex;
  align-items: baseline;
  gap: var(--space-1);
}
.market-price-value {
  font: var(--text-mono);
  font-weight: 500;
  color: var(--color-text-primary);
}
.market-price-unit { font: var(--text-small); color: var(--color-text-muted); }
.market-price-trend { font: var(--text-caption); }
.market-price-trend--up { color: var(--color-success); }
.market-price-trend--down { color: var(--color-error); }
.market-price-trend--stable { color: var(--color-text-muted); }
.market-price-season {
  font: var(--text-caption);
  padding: 1px var(--space-1);
  border-radius: var(--radius-sm);
}
```

---

#### `<NotificationBell>`

Cloche avec badge compteur dans le header.

**Props** : `count: number`

```css
.notif-bell {
  position: relative;
  cursor: pointer;
  padding: var(--space-2);
  border-radius: var(--radius-md);
  transition: background var(--transition-fast);
}
.notif-bell:hover { background: var(--color-earth-50); }
.notif-bell-badge {
  position: absolute;
  top: 2px; right: 2px;
  min-width: 18px; height: 18px;
  border-radius: var(--radius-full);
  background: var(--color-red-600);
  color: white;
  font: var(--text-caption);
  display: grid;
  place-content: center;
  padding: 0 4px;
  animation: notif-pop var(--transition-fast);
}
@keyframes notif-pop {
  0% { transform: scale(0); }
  70% { transform: scale(1.2); }
  100% { transform: scale(1); }
}
```


---

## 7 — Layouts

**DA** : Header fixe avec les infos vitales (solde, HT, météo, saison). Sidebar pour la nav, collapsible pour gagner de l'espace. Le contenu respire.

**UI** : 4 breakpoints : mobile 375, tablette 768, desktop 1024, wide 1440. La sidebar disparaît en mobile → bottom nav. Le header se compacte.

**FE** : CSS Grid pour le layout principal. La sidebar est un composant avec état dans un store Pinia `useLayoutStore`. Transition smooth au collapse.

### Breakpoints

```css
:root {
  --bp-mobile: 375px;
  --bp-tablet: 768px;
  --bp-desktop: 1024px;
  --bp-wide: 1440px;
}
```

### Layout principal — `<AppLayout>`

```
┌──────────────────────────────────────────────────┐
│  HEADER (fixe, h=56px)                           │
│  Logo │ Nav │ Saison │ Météo │ Solde │ HT │ 🔔 │ │
├────────┬─────────────────────────────────────────┤
│SIDEBAR │  CONTENU                                │
│ 240px  │  padding: 24px                          │
│ (ou    │                                         │
│  64px  │  max-width: 1200px                      │
│ collap)│  margin: 0 auto                         │
│        │                                         │
│  🏠    │                                         │
│  🌾    │                                         │
│  🏗️    │                                         │
│  🚜    │                                         │
│  🏦    │                                         │
│  🏪    │                                         │
│  👤    │                                         │
└────────┴─────────────────────────────────────────┘
```

```css
.app-layout {
  display: grid;
  grid-template-rows: 56px 1fr;
  grid-template-columns: var(--sidebar-width) 1fr;
  grid-template-areas:
    "header header"
    "sidebar content";
  min-height: 100vh;
  --sidebar-width: 240px;
}
.app-layout--collapsed { --sidebar-width: 64px; }

.app-header {
  grid-area: header;
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
  display: flex;
  align-items: center;
  gap: var(--space-4);
  padding: 0 var(--space-6);
  background: var(--color-bg-card);
  border-bottom: var(--border);
  height: 56px;
}

.app-sidebar {
  grid-area: sidebar;
  position: sticky;
  top: 56px;
  height: calc(100vh - 56px);
  overflow-y: auto;
  background: var(--color-bg-card);
  border-right: var(--border);
  padding: var(--space-4) 0;
  transition: width var(--transition-slow);
  width: var(--sidebar-width);
}

.app-content {
  grid-area: content;
  padding: var(--space-6);
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
}

/* Tablette : sidebar collapsée par défaut */
@media (max-width: 1024px) {
  .app-layout { --sidebar-width: 64px; }
}

/* Mobile : pas de sidebar, bottom nav */
@media (max-width: 768px) {
  .app-layout {
    grid-template-columns: 1fr;
    grid-template-rows: 56px 1fr 56px;
    grid-template-areas:
      "header"
      "content"
      "bottomnav";
  }
  .app-sidebar { display: none; }
  .app-content { padding: var(--space-4); }
}
```

### Header — `<AppHeader>`

```css
.header-logo { font: var(--text-h3); color: var(--color-green-700); text-decoration: none; }
.header-spacer { flex: 1; }
.header-group {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}

/* Mobile : masquer certains éléments */
@media (max-width: 768px) {
  .header-hide-mobile { display: none; }
  .header-logo { font-size: 1rem; }
}
```

**Contenu header** (gauche → droite) :
1. Logo "Cultivia" (lien `/dashboard`)
2. `<SeasonIndicator />` — saison + jour + année
3. `<WeatherWidget />` (compact, icône seule en mobile)
4. Spacer
5. `<BalanceDisplay />` — solde animé
6. `<HTBar />` — HT circulaire
7. `<NotificationBell />` — cloche + badge
8. Avatar joueur (dropdown : profil, paramètres, déconnexion)

### Sidebar — `<AppSidebar>`

```css
.sidebar-nav { display: flex; flex-direction: column; gap: var(--space-1); }

.sidebar-link {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  margin: 0 var(--space-2);
  color: var(--color-text-secondary);
  text-decoration: none;
  font: var(--text-body);
  transition: background var(--transition-fast), color var(--transition-fast);
}
.sidebar-link:hover {
  background: var(--color-earth-50);
  color: var(--color-text-primary);
}
.sidebar-link--active {
  background: rgba(46, 125, 50, 0.1);
  color: var(--color-green-700);
  font-weight: 500;
}
.sidebar-link-label { white-space: nowrap; overflow: hidden; }

/* Collapsed : masquer les labels */
.app-layout--collapsed .sidebar-link-label { display: none; }
.app-layout--collapsed .sidebar-link { justify-content: center; padding: var(--space-3); }

.sidebar-toggle {
  position: absolute;
  bottom: var(--space-4);
  left: 50%;
  transform: translateX(-50%);
}
```

**Items sidebar** :
| Icône | Label | Route |
|-------|-------|-------|
| `LayoutDashboard` | Tableau de bord | `/dashboard` |
| `Map` | Parcelles | `/parcels` |
| `Building2` | Bâtiments | `/buildings` |
| `Tractor` | Matériels | `/vehicles` |
| `Landmark` | Banque | `/bank` |
| `Store` | Coopérative | `/coop` |
| `User` | Profil | `/profile` |

### Bottom Nav mobile — `<BottomNav>`

```css
.bottom-nav {
  display: none;
  position: fixed;
  bottom: 0;
  left: 0; right: 0;
  height: 56px;
  background: var(--color-bg-card);
  border-top: var(--border);
  z-index: var(--z-sticky);
}
@media (max-width: 768px) {
  .bottom-nav {
    display: flex;
    justify-content: space-around;
    align-items: center;
  }
}
.bottom-nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  padding: var(--space-1);
  color: var(--color-text-muted);
  text-decoration: none;
  font: var(--text-caption);
}
.bottom-nav-item--active { color: var(--color-green-700); }
```

Items bottom nav (5 max) : Dashboard, Parcelles, Coopérative, Banque, Plus (menu).

### Grille de contenu

```css
/* Grille dashboard : cartes en colonnes */
.grid-dashboard {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
}

/* Grille 2 colonnes (détail parcelle) */
.grid-detail {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: 1fr 1fr;
}
@media (max-width: 768px) {
  .grid-detail { grid-template-columns: 1fr; }
}

/* Grille catalogue (bâtiments, matériels) */
.grid-catalog {
  display: grid;
  gap: var(--space-4);
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
}
```


---

## 8 — Wireframes textuels

**DA** : Chaque page doit avoir une hiérarchie claire. L'info la plus importante en haut à gauche. Les actions principales toujours visibles.

**UI** : On utilise des wireframes ASCII pour que ce soit versionnable et lisible par tous. Chaque zone est annotée avec le composant Vue correspondant.

**FE** : Je valide la faisabilité technique de chaque layout. Tout est réalisable en CSS Grid + Flexbox.

---

### 8.1 — Dashboard (`/dashboard`)

```
┌─────────────────────────────────────────────────────────┐
│ [AppHeader]                                             │
├──────────┬──────────────────────────────────────────────┤
│[Sidebar] │                                              │
│          │ ┌──────────────────────────────────────────┐ │
│ 🏠 ←     │ │ BANDEAU JOUR                             │ │
│ 🌾       │ │ 🌸 Printemps, Jour 4 — Année 1          │ │
│ 🏗️       │ │ Prochain jour dans 3h 42min              │ │
│ 🚜       │ └──────────────────────────────────────────┘ │
│ 🏦       │                                              │
│ 🏪       │ ┌──── HT ÉPUISÉS (si pa=0) ──────────────┐ │
│ 👤       │ │ ⏳ HT épuisés. Reset dans 3h 42min       │ │
│          │ └──────────────────────────────────────────┘ │
│          │                                              │
│          │ ┌─────────────┐ ┌─────────────┐             │
│          │ │ <WeatherW.> │ │ <StatCard>  │             │
│          │ │ ☀️ Ensoleillé│ │ Finances    │             │
│          │ │ 💨 Vent     │ │ 100 000 €   │             │
│          │ │ Hist 7j ▁▃▅ │ │ ↑ +5 000    │             │
│          │ └─────────────┘ └─────────────┘             │
│          │                                              │
│          │ ┌─────────────┐ ┌─────────────┐             │
│          │ │ Parcelles   │ │ Bâtiments   │             │
│          │ │ 3 — 25 ha   │ │ 4 bâtiments │             │
│          │ │ <ParcelCard>│ │ <Building.> │             │
│          │ │ <ParcelCard>│ │ <Building.> │             │
│          │ │ [Voir tout] │ │ [Voir tout] │             │
│          │ └─────────────┘ └─────────────┘             │
│          │                                              │
│          │ ┌─────────────┐ ┌─────────────┐             │
│          │ │ Matériels   │ │ Notifs      │             │
│          │ │ 5 matériels │ │ 🔴 Blé mûr  │             │
│          │ │ 🔴 1 panne  │ │ Prêt mensuel│             │
│          │ │ 🟡 2 usure  │ │ Météo demain│             │
│          │ │ [Voir tout] │ │ [Voir tout] │             │
│          │ └─────────────┘ └─────────────┘             │
└──────────┴──────────────────────────────────────────────┘
```

**Composants** : `SeasonIndicator`, `WeatherWidget`, `StatCard` ×2, `Card` ×4 avec listes de `ParcelCard`, `BuildingCard`, `VehicleCard`, notifications.

---

### 8.2 — Parcelles (`/parcels`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> Parcelles </h1>                  │
│          │ 3 parcelles — 25 ha total             │
│          │                    [Acheter parcelle]  │
│          │                                       │
│          │ Filtres: [Toutes|En culture||⚠]│
│          │                                       │
│          │ ┌─────────────────────────────────────┐│
│          │ │ <CDataTable>                        ││
│          │ │ # │Type│Ha│Sol│Culture│Croiss│État│…││
│          │ │ ──┼────┼──┼───┼──────┼──────┼────┼─││
│          │ │ 1 │🌾  │10│⭐⭐│Blé   │██░ 72│🟢 │→││
│          │ │ 2 │🌾  │ 8│⭐⭐⭐│Colza │████ 95│🟡│→││
│          │ │ 3 │🌿  │ 7│⭐ ││      │🟢 │→││
│          │ │                                     ││
│          │ │ Page 1/1                             ││
│          │ └─────────────────────────────────────┘│
│          │                                       │
│          │ Mobile: cartes <ParcelCard> empilées   │
└──────────┴───────────────────────────────────────┘
```

---

### 8.3 — Détail parcelle (`/parcels/:id`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ ← Retour parcelles                    │
│          │ <h1> Parcelle #1 — Champ 10 ha </h1> │
│          │                                       │
│          │ ┌─── COL GAUCHE ──┐┌── COL DROITE ──┐│
│          │ │                  ││                 ││
│          │ │ INFOS            ││ CULTURE EN COURS││
│          │ │ Zone: Île-de-Fr. ││ 🌾 Blé (GP)    ││
│          │ │ Sol: ⭐⭐         ││ État: En croiss.││
│          │ │ Pierres: ██░ 15% ││                 ││
│          │ │                  ││ ████████░░ 72%  ││
│          │ │ NUTRIMENTS       ││ ~8 jours restant││
│          │ │ N  P  K  Ca Mg S ││                 ││
│          │ │ █  █  █  █  █  █ ││ Traitements:    ││
│          │ │ █  █  ▓  █  █  █ ││ 🍄 ✅ 🌿 ❌ 🐛 ✅││
│          │ │ █  ▓  ▓  █  ▓  █ ││ Engrais: ✅     ││
│          │ │ 45 38 22 60 30 55││ Rouleau: ❌     ││
│          │ │ [Analyser sol]   ││                 ││
│          │ │                  ││ ACTIONS:        ││
│          │ │ MÉTÉO PARCELLE   ││ [Traiter 🌿]   ││
│          │ │ 💧 ██████░ 62    ││ [Rouleau]      ││
│          │ │ ☀️ ████░░░ 45    ││ [🌾 Récolter]  ││
│          │ │ Hist: ▁▃▅▇▅▃▁   ││ (quand mature)  ││
│          │ └─────────────────┘└─────────────────┘│
│          │                                       │
│          │ HISTORIQUE CULTURES                    │
│          │ <CDataTable> An│Culture│Rdt│Qualité   │
└──────────┴───────────────────────────────────────┘
```

---

### 8.4 — Animaux (`/animals`) — Phase 2 preview

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> Mes Animaux </h1>                │
│          │ 12 bovins — 3 bâtiments               │
│          │                      [Acheter animal] │
│          │                                       │
│          │ Filtres: [Tous|Bovins|Ovins|Volailles] │
│          │                                       │
│          │ ┌─────────────────────────────────────┐│
│          │ │ <CDataTable>                        ││
│          │ │ # │Espèce│Race    │Âge│Santé│Prod  ││
│          │ │ ──┼──────┼────────┼───┼─────┼──────││
│          │ │ 1 │🐄    │Holstein│3a │🟢   │24L/j ││
│          │ │ 2 │🐄    │Holstein│5a │🟡   │21L/j ││
│          │ │ 3 │🐄    │Charol. │2a │🟢   │—     ││
│          │ └─────────────────────────────────────┘│
└──────────┴───────────────────────────────────────┘
```

---

### 8.5 — Détail animal (`/animals/:id`) — Phase 2 preview

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ ← Retour animaux                      │
│          │ <h1> 🐄 Holstein #1 — "Marguerite" </h1>│
│          │                                       │
│          │ ┌─── COL GAUCHE ──┐┌── COL DROITE ──┐│
│          │ │ INFOS            ││ PRODUCTION      ││
│          │ │ Race: Holstein   ││ Lait: 24 L/jour ││
│          │ │ Âge: 3 ans      ││ Qualité: ⭐⭐⭐   ││
│          │ │ Poids: 650 kg   ││ Dernière traite: ││
│          │ │ Santé: 🟢 Sain  ││ il y a 6h       ││
│          │ │ Bâtiment: Étable ││                 ││
│          │ │ Pâture: Oui ☀️   ││ GÉNÉTIQUE       ││
│          │ │                  ││ Lait: 8.2/10    ││
│          │ │ ALIMENTATION     ││ Viande: 5.1/10  ││
│          │ │ Ration: ████ OK  ││ Repro: 7.0/10   ││
│          │ │ Eau: ████ OK     ││                 ││
│          │ │                  ││ ACTIONS:        ││
│          │ │ VACCINS          ││ [Traire]        ││
│          │ │ ✅ Vacciné       ││ [Nourrir]       ││
│          │ │ Expire: 45j      ││ [Vacciner]      ││
│          │ │                  ││ [Vendre]        ││
│          │ └─────────────────┘└─────────────────┘│
└──────────┴───────────────────────────────────────┘
```

---

### 8.6 — Bâtiments (`/buildings`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> Bâtiments </h1>                  │
│          │ 4 bâtiments              [Construire] │
│          │                                       │
│          │ ┌─────────────────────────────────────┐│
│          │ │ <CDataTable>                        ││
│          │ │Type    │Taille│Niv│Usure│Énergie│Rem││
│          │ │────────┼──────┼───┼─────┼───────┼───││
│          │ │🏚️Hangar│500m² │2/5│██░15│0.80€  │320││
│          │ │🏗️Silo  │100T  │1/5│█░ 5 │0.16€  │45T││
│          │ │📦Entrep│200m² │1/5│███30│0.32€  │80 ││
│          │ │💩Fosse │50T   │1/5│░░ 0 │0.08€  │10T││
│          │ │                                     ││
│          │ │ Actions: 🔧 Entretenir ⬆️ Améliorer ││
│          │ │          🗑️ Détruire   👁️ Détail    ││
│          │ └─────────────────────────────────────┘│
└──────────┴───────────────────────────────────────┘
```

---

### 8.7 — Matériels (`/vehicles`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> Matériels </h1>                  │
│          │ 5 matériels  [Acheter neuf] [Occasion]│
│          │                                       │
│          │ Filtres: [Tous|Tracteurs|Sol|Récolte…] │
│          │                                       │
│          │ ┌─────────────────────────────────────┐│
│          │ │ <CDataTable>                        ││
│          │ │Nom         │Famille│CV │Usure│État  ││
│          │ │────────────┼───────┼───┼─────┼──────││
│          │ │Tracteur 120│Tract. │120│██░18│🟢    ││
│          │ │Charrue 4s  │Sol    │—  │█░ 8 │🟢    ││
│          │ │Moissonneuse│Récolt.│200│████45│🟡   ││
│          │ │Semoir 6m   │Semis  │—  │░░ 2 │🟢    ││
│          │ │Remorque 12T│Transp.│—  │🔴PANNE│🔴  ││
│          │ │                                     ││
│          │ │ Actions: 🔧 Entretenir 🔩 Réparer  ││
│          │ │          💰 Vendre     👁️ Détail    ││
│          │ └─────────────────────────────────────┘│
│          │                                       │
│          │ ⛽ HVC: ████████░░ 1200/5000 L        │
│          │        [Faire le plein]                │
└──────────┴───────────────────────────────────────┘
```

---

### 8.8 — Coopérative (`/coop`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> 🏪 Coopérative </h1>             │
│          │                                       │
│          │ [Vendre] [Prix du jour] [Calculateur]  │
│          │ ─────── onglets actifs ───────────     │
│          │                                       │
│          │ === ONGLET VENDRE ===                  │
│          │ ┌─────────────────────────────────────┐│
│          │ │Produit │Qualité│Stock│Prix/T │Saison││
│          │ │────────┼───────┼─────┼───────┼──────││
│          │ │Blé     │⭐⭐    │50 T │90,00€ │🌾×0.9││
│          │ │Blé     │⭐⭐⭐   │18 T │99,00€ │🌾×0.9││
│          │ │Colza   │⭐⭐    │30 T │198,00€│  ×1.1││
│          │ └─────────────────────────────────────┘│
│          │                                       │
│          │ Vendre: [Blé ⭐⭐ ▼]                    │
│          │ Quantité: ═══════●══ 30 T              │
│          │ [25%] [50%] [100%]                     │
│          │ Total: 30 × 90,00€ = 2 700,00 €       │
│          │ HT: 1.5                                │
│          │ ⚠️ Prix bas en saison récolte           │
│          │                                       │
│          │ [Vendre (2 700,00 €)]                  │
│          │                                       │
│          │ === ONGLET PRIX DU JOUR ===            │
│          │ <CDataTable> avec toutes les cultures, │
│          │ prix par qualité, facteur saison,      │
│          │ flèches tendance ↑↓                    │
└──────────┴───────────────────────────────────────┘
```

---

### 8.9 — Profil (`/profile`)

```
┌──────────────────────────────────────────────────┐
│ [AppHeader]                                      │
├──────────┬───────────────────────────────────────┤
│[Sidebar] │                                       │
│          │ <h1> Mon Profil </h1>                 │
│          │                                       │
│          │ ┌─── INFOS ──────┐┌── STATS ────────┐│
│          │ │ 👤 fermier42    ││ Inscrit depuis:  ││
│          │ │ Serveur: FR3   ││ 45 jours         ││
│          │ │ Région: IdF    ││                   ││
│          │ │ Zone: 5, Paris ││ Parcelles: 3     ││
│          │ │                ││ Surface: 25 ha   ││
│          │ │ [Modifier]     ││ Bâtiments: 4     ││
│          │ │                ││ Matériels: 5     ││
│          │ └────────────────┘│ Solde: 100 000 € ││
│          │                  │ Prêts: 47 916 €  ││
│          │                  └──────────────────┘│
│          │                                       │
│          │ HISTORIQUE FINANCIER                   │
│          │ <BarChart> revenus/dépenses par mois  │
│          │                                       │
│          │ PARAMÈTRES                             │
│          │ Notifications email: <CToggle>         │
│          │ Langue: <CSelect>                      │
│          │                                       │
│          │ [Changer mot de passe]                 │
│          │ [Se déconnecter]                       │
└──────────┴───────────────────────────────────────┘
```

---

## Annexe — Arborescence des composants

```
src/client/components/
├── ui/                    # Composants base (section 6.1)
│   ├── CButton.vue
│   ├── CInput.vue
│   ├── CSelect.vue
│   ├── CCheckbox.vue
│   ├── CToggle.vue
│   ├── CBadge.vue
│   ├── CTag.vue
│   ├── CTooltip.vue
│   ├── CToast.vue
│   ├── CModal.vue
│   └── CSpinner.vue
├── data/                  # Composants données (section 6.2)
│   ├── CDataTable.vue
│   ├── CCard.vue
│   ├── CStatCard.vue
│   ├── CProgressBar.vue
│   ├── CGauge.vue
│   └── CTimeline.vue
├── game/                  # Composants jeu (section 6.3)
│   ├── HTBar.vue
│   ├── BalanceDisplay.vue
│   ├── WeatherWidget.vue
│   ├── SeasonIndicator.vue
│   ├── ParcelCard.vue
│   ├── AnimalCard.vue
│   ├── VehicleCard.vue
│   ├── BuildingCard.vue
│   ├── MarketPrice.vue
│   └── NotificationBell.vue
├── layout/                # Layout (section 7)
│   ├── AppLayout.vue
│   ├── AppHeader.vue
│   ├── AppSidebar.vue
│   └── BottomNav.vue
└── icons/                 # Icônes custom SVG (section 4)
    ├── IconPA.vue
    ├── IconWeather1.vue → IconWeather5.vue
    ├── IconSeasonSpring.vue → IconSeasonWinter.vue
    ├── IconCropWheat.vue, IconCropBarley.vue, ...
    ├── IconAnimalCow.vue, IconAnimalSheep.vue, ...
    └── IconQualityStars.vue
```

---

## Annexe — Variables CSS complètes (copier-coller)

```css
:root {
  /* === COULEURS === */
  --color-earth-900: #3E2723;
  --color-earth-700: #5D4037;
  --color-earth-500: #8D6E63;
  --color-earth-200: #D7CCC8;
  --color-earth-50: #EFEBE9;
  --color-green-700: #2E7D32;
  --color-green-500: #4CAF50;
  --color-green-100: #C8E6C9;
  --color-amber-600: #F57F17;
  --color-amber-100: #FFF8E1;
  --color-blue-600: #1565C0;
  --color-blue-100: #BBDEFB;
  --color-red-600: #C62828;
  --color-red-100: #FFCDD2;

  --color-success: var(--color-green-700);
  --color-warning: var(--color-amber-600);
  --color-error: var(--color-red-600);
  --color-info: var(--color-blue-600);

  --color-bg-primary: #FAFAF5;
  --color-bg-secondary: var(--color-earth-50);
  --color-bg-card: #FFFFFF;
  --color-bg-overlay: rgba(62, 39, 35, 0.5);

  --color-text-primary: var(--color-earth-900);
  --color-text-secondary: var(--color-earth-700);
  --color-text-muted: var(--color-earth-500);
  --color-text-inverse: #FAFAF5;
  --color-text-link: var(--color-blue-600);

  --color-season-spring: #66BB6A;
  --color-season-summer: #FFA726;
  --color-season-autumn: #D84315;
  --color-season-winter: #42A5F5;

  /* === TYPOGRAPHIE === */
  --font-title: 'Nunito', system-ui, sans-serif;
  --font-body: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;

  --text-h1: 800 2rem/1.2 var(--font-title);
  --text-h2: 700 1.5rem/1.25 var(--font-title);
  --text-h3: 700 1.25rem/1.3 var(--font-title);
  --text-h4: 700 1.125rem/1.35 var(--font-title);
  --text-body: 400 1rem/1.5 var(--font-body);
  --text-body-medium: 500 1rem/1.5 var(--font-body);
  --text-small: 400 0.875rem/1.4 var(--font-body);
  --text-caption: 500 0.75rem/1.3 var(--font-body);
  --text-mono: 400 1rem/1.5 var(--font-mono);
  --text-mono-lg: 500 1.25rem/1.3 var(--font-mono);

  /* === THÈME === */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;

  --shadow-sm: 0 1px 3px rgba(62, 39, 35, 0.08);
  --shadow-md: 0 4px 12px rgba(62, 39, 35, 0.1);
  --shadow-lg: 0 8px 24px rgba(62, 39, 35, 0.15);

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

  --transition-fast: 150ms ease;
  --transition-base: 200ms ease;
  --transition-slow: 300ms ease;

  --border-width: 1px;
  --border-color: var(--color-earth-200);
  --border: var(--border-width) solid var(--border-color);

  --z-base: 0;
  --z-dropdown: 100;
  --z-sticky: 200;
  --z-overlay: 300;
  --z-modal: 400;
  --z-toast: 500;
  --z-tooltip: 600;

  /* === ICÔNES === */
  --icon-sm: 16px;
  --icon-md: 24px;
  --icon-lg: 32px;
}
```

---

> **Cultivia — Identité Visuelle & Design System — v1.0**
> Réunion créative : DA + UI Designer + Frontend Dev Vue 3
> Prochaine étape : implémentation des composants `src/client/components/ui/`


---

## 9 — Décisions design post-questionnaire (2026-04-06)

> Source : questionnaire ergonomie 10 000 joueurs + questionnaire experts 2 000

### 9.1 Micro-texture papier
Ajouter un grain subtil sur les cartes (bâtiments, animaux, parcelles) :
```css
.card { background-image: url("data:image/svg+xml,..."); /* grain SVG inline */ }
```
Objectif : casser le côté "trop propre" sans alourdir. Subtil, pas envahissant.

### 9.2 Sidebar avec icônes et groupes
```
🏠 Dashboard
─── Élevage ───
  🐄 Animaux
  🏗️ Bâtiments
  👷 Employés
─── Cultures ───
  🌾 Parcelles
  ☁️ Météo
─── Économie ───
  💰 Finances
  🛒 Marché
  🤝 Coopérative
─── Matériel ───
  🚜 Matériel
─── Social ───
  ✉️ Messages
  🏆 Classements
  🔔 Notifications
```
Groupes repliables, état mémorisé en localStorage.

### 9.3 Header compact mobile
- Desktop (>1024px) : solde + HT barre + date + saison + météo icône + notifs badge + profil
- Tablette (768-1024px) : solde + HT barre + date + météo icône + notifs
- Mobile (<768px) : solde + HT icône + notifs badge (1 ligne)

### 9.4 DataTable responsive
- Desktop : tableau classique avec tri/filtre/pagination
- Tablette (<1024px) : mode carte (chaque ligne = carte empilée)
- Pagination : sélecteur 20/50/100 éléments

### 9.4b Règle liste vs cartes (jeu de gestion)
**La liste (DataTable) est le mode par défaut pour TOUTES les pages de gestion** (animaux, bâtiments, lots, matériel, finances, classements). Les cartes sont un mode alternatif (toggle) pour les joueurs qui préfèrent le visuel.

### 9.4c Colonnes personnalisables
Chaque DataTable a un bouton **⚙️ Colonnes** qui ouvre un panneau de configuration :
- Le joueur coche/décoche les colonnes qu'il veut voir
- L'ordre des colonnes est modifiable (drag & drop)
- La configuration est sauvegardée par page en localStorage
- Colonnes par défaut raisonnables (les plus utiles visibles, les détaillées masquées)

Exemple colonnes animaux :
- **Toujours visibles :** ☐ (checkbox), Nom, Race
- **Visibles par défaut :** Sexe, Âge, Santé, Malade, Nourri, Production, Lot
- **Masquées par défaut :** Génétique (L/V/F/R/P/C), Poids, Vacciné, Vermifugé, Gestante, Lieu, Dernier soin

Le joueur éleveur génétique activera les colonnes génétique. Le joueur débutant gardera les colonnes par défaut.

Raison : dans un jeu de gestion, le joueur a 50+ éléments à gérer. Les listes permettent le tri, le filtre, la sélection multiple, l'export CSV. Les cartes ne scalent pas au-delà de 10 éléments.

Exception : le dashboard utilise des widgets (cartes) car c'est une vue résumé, pas une vue de gestion.

### 9.5 Modes utilisateur
- **Mode sobre** : désactive les emojis dans les toasts (préférences)
- **Mode expert** : désactive les modales de confirmation sauf destruction/abattoir (préférences)
- **Dark mode** : surcharge CSS variables (post-MVP Sprint 14)

### 9.6 Toast
- Durée : 5 secondes (au lieu de 3)
- Clic pour fermer immédiatement
- Historique consultable dans /notifications (F104)

### 9.7 Mobile
Cultivia est un jeu PC/tablette. Sur mobile (<768px) :
- Dashboard consultable (widgets empilés)
- Notifications consultables
- Cours du marché consultables
- Actions (nourrir, semer, vendre) = PC/tablette uniquement
- Message affiché : "Pour gérer votre ferme, utilisez un ordinateur ou une tablette."


---

## 10. Diagramme architecture (Réf: Review R1)

```
                    ┌──────────────────────────────────────────┐
                    │              INTERNET                     │
                    └──────────────┬───────────────────────────┘
                                   │
                    ┌──────────────▼───────────────────────────┐
                    │           Nginx (reverse proxy)           │
                    │  SSL termination, rate limit IP, CORS     │
                    └──────┬──────────────────┬────────────────┘
                           │                  │
              ┌────────────▼────────┐  ┌──────▼──────────────┐
              │   Client (Vue 3)    │  │   Server (Fastify)   │
              │   Vite :5173        │  │   :3001              │
              │   Pinia stores      │  │   JWT auth           │
              │   WebSocket client  │──│   Idempotency        │
              │   CSS design system │  │   Ownership check    │
              └─────────────────────┘  │   Rate limit user    │
                                       │   JSON Schema valid  │
                                       └──────┬──────┬────────┘
                                              │      │
                              ┌────────────────▼┐  ┌─▼──────────────┐
                              │  PgBouncer API   │  │  Redis          │
                              │  pool=50         │  │  Sessions       │
                              │  mode=transaction│  │  Idempotency    │
                              └────────┬─────────┘  │  Cache (60s)    │
                                       │            │  BullMQ queues  │
                              ┌────────▼─────────┐  └─▲──────────────┘
                              │  PostgreSQL 17    │    │
                              │  140 tables       │    │
                              │  RLS activé       │  ┌─┴──────────────┐
                              │  UUID v7          │  │  Worker         │
                              └──────────────────┘  │  BullMQ consumer│
                                                    │  Cron 00:00 CET │
                              ┌──────────────────┐  │  24 tick steps  │
                              │  PgBouncer Worker│──│  Batch 100      │
                              │  pool=10         │  └─────────────────┘
                              └────────┬─────────┘
                                       │
                              (même PostgreSQL)
```

### Flux de données

1. **Client → Server** : HTTP REST (JSON) + WebSocket (Socket.io)
2. **Server → PostgreSQL** : SQL paramétré via PgBouncer (pool API = 50 connexions)
3. **Server → Redis** : Sessions JWT, cache idempotency (24h), cache cours/météo (60s)
4. **Worker → PostgreSQL** : SQL via PgBouncer dédié (pool Worker = 10 connexions)
5. **Worker → Redis** : BullMQ queues, tick lock (10min + heartbeat 60s)
6. **Server → Client** : WebSocket events ciblés par player_id

### Séparation des pools

- **API pool** (PgBouncer) : 50 connexions, mode transaction, pour les requêtes joueurs
- **Worker pool** (PgBouncer) : 10 connexions, mode transaction, pour le tick journalier
- Le worker ne bloque JAMAIS le pool API (pools séparés)

---

## 11. Spec WebSocket (Réf: Review R13)

### Technologie
Socket.io (compatibilité navigateurs, reconnexion auto, rooms)

### Namespace
`/game` — un seul namespace pour tout le jeu

### Authentification
Le client envoie le JWT à la connexion. Le serveur vérifie et associe le socket au `player_id`.

### Format des events
```typescript
interface WSEvent {
  type: string;        // ex: 'balance_update'
  payload: unknown;    // données spécifiques
  timestamp: string;   // ISO 8601
}
```

### Events définis (extraits du registry)

| Event | Payload | Émis par |
|-------|---------|----------|
| `balance_update` | `{ balance: number }` | Toute mutation solde |
| `ht_update` | `{ ht_today: number, ht_max: number }` | Toute mutation HT |
| `animal_alert` | `{ type: 'birth'|'sick'|'dead'|'arrived', animal_id, message }` | Ticks + mutations |
| `parcel_alert` | `{ type: 'mature'|'over_mature', parcel_id, message }` | Tick croissance |
| `equipment_alert` | `{ type: 'delivered'|'broken'|'wear_high', vehicle_id, message }` | Ticks + mutations |
| `notification` | `{ id, type, message, action_url }` | Toute notification |
| `friend_request` | `{ from_player_id, from_username }` | F094 |
| `market_update` | `{ product, price, variation_pct }` | F077 tick cours |

### Ciblage
Tous les events sont envoyés au `player_id` concerné uniquement (pas de broadcast global sauf `market_update`).

### Reconnexion
Socket.io gère la reconnexion automatique. À la reconnexion, le client fait un `GET /api/player/me` pour resynchroniser l'état.

---

## 12. Checklist accessibilité WCAG AA (Réf: Review R18)

| Critère | Spec |
|---------|------|
| Contraste texte | 4.5:1 minimum (vérifié dans §2 palette) |
| Focus visible | `outline: 2px solid var(--color-green-700)` sur tous les éléments interactifs |
| Skip navigation | Lien caché "Aller au contenu" en haut de page |
| Aria-labels | Sur tous les boutons icône-seule, les jauges, les graphiques |
| Aria-live | Sur les toasts (`role="alert"`) et les mises à jour solde/HT |
| Prefers-reduced-motion | Désactiver les animations (défilement solde, transitions) |
| Keyboard navigation | Tab order logique, Enter/Space pour activer, Escape pour fermer modales |
| Screen reader | Texte alternatif sur les emojis (`aria-label="Vache"` sur 🐄) |

---

## 13. Décomposition pages complexes (Réf: Review F-01)

Les pages avec >10 flows sont décomposées en sous-composants par onglet :

### /parcels/:id (23 flows → 6 onglets)
- `ParcelSoilTab.vue` — F036, F037
- `ParcelCropTab.vue` — F038, F054, F101, F040, F039, F058, F102, F041
- `ParcelStrawTab.vue` — F059, F060
- `ParcelFertilizeTab.vue` — F055, F056, F103
- `ParcelManageTab.vue` — F086, F087, F088, F057, F046
- `ParcelHistoryTab.vue` — F115

### /animals/:id (9 flows → sections conditionnelles)
- `AnimalIdentity.vue` — F005
- `AnimalHealth.vue` — F012, F014
- `AnimalFeeding.vue` — lien F008
- `AnimalProduction.vue` — F023 (lait), F083 (œufs), F082 (laine)
- `AnimalReproduction.vue` — F018, F019, F022
- `AnimalActions.vue` — F025, F029, F080

### /buildings/:id (10 flows → sections)
- `BuildingInfo.vue` — F069, F070, F107, F113
- `BuildingFeed.vue` — F008, F010
- `BuildingWater.vue` — F009
- `BuildingBedding.vue` — F015, F016, F017


---

## 14. Améliorations UX complémentaires

### 14.1 Compteurs alertes dans la sidebar

```
🏠 Dashboard
─── Élevage ───
  🐄 Animaux (3⚠️)        ← 3 non nourris ou malades
  🏗️ Bâtiments (1⚠️)      ← 1 litière dégradée
  👷 Employés
─── Cultures ───
  🌾 Parcelles (1✅)       ← 1 culture mature
  ☁️ Météo
─── Matériel ───
  🚜 Matériel (1🔴)       ← 1 en panne
─── Économie ───
  💰 Finances
  🛒 Marché
```

Les compteurs sont calculés côté client depuis les stores Pinia. Mis à jour en temps réel via WebSocket.

### 14.2 Actions rapides au survol (mode avancé, opt-in)

Activable dans Préférences > Mode avancé. Au survol d'une ligne DataTable, des icônes d'action apparaissent à droite. Désactivé par défaut.

### 14.3 Principe de lisibilité des tableaux

**Chaque information = sa propre colonne.** Pas de badges inline qui surchargent une cellule. Les colonnes sont personnalisables (⚙️) donc le joueur masque ce qui ne l'intéresse pas plutôt que de tout compresser dans une cellule.

### 14.4 Récapitulatif coût total AVANT action (règle universelle)

**Avant TOUTE action qui coûte quelque chose, le joueur voit un récapitulatif complet :**

```
┌─ Récapitulatif ──────────────────────────────────┐
│ Acheter 100T de blé                              │
│                                                  │
│ Prix marchandise      100T × 200€    = 20 000€  │
│ Transport             17 voyages     =    408€   │
│   (benne 6T, 80km, 17 × 24€)                    │
│ HVC consommé          17 × 16L       =    272L   │
│ HT consommé           17 × 1.3       =   22.1    │
│ Usure benne           17 × 1.6%      =  +27.2%   │
│ Usure tracteur        17 × 1.6%      =  +27.2%   │
│ ─────────────────────────────────────────────────│
│ TOTAL                                  20 408€   │
│ HT après action       32.0 → 9.9 (⚠️ reste peu) │
│ Solde après            97 811€ → 77 403€         │
│ HVC après              450L → 178L (⚠️ bas)      │
│ Usure benne après      40% → 67.2% (⚠️ > 60%)   │
│                                                  │
│ [Confirmer 20 408€]  [Modifier quantité]         │
└──────────────────────────────────────────────────┘
```

**S'applique à :** tout achat, toute vente, tout travail de parcelle, tout déplacement animal, tout entretien matériel — bref, tout bouton qui consomme €, HT, HVC ou usure.

**Le joueur ne doit JAMAIS être surpris par un coût caché.**

Le récapitulatif est un **panneau inline** sous le bouton (pas une modale). Il apparaît dynamiquement quand le joueur sélectionne la quantité/le produit. Pas de clic supplémentaire pour le voir.
