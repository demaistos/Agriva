# 02 — Quality of Life & UX — Réunion de conception

> **Participants :**
> - 🎨 **Léa** — UX Designer spécialisée jeux de gestion
> - 🎮 **Marc** — Joueur vétéran Cultivia (8 ans d'expérience)
> - 💻 **Tom** — Frontend Dev Vue 3 / TypeScript
>
> **Objectif :** Identifier les frustrations joueur, proposer des solutions UX, et spécifier l'implémentation Vue 3 pour chaque amélioration QoL de Cultivia.
>
> **Référence :** `UX_PHASE0_1.md`, `UX_PHASE2.md`, `UX_PHASE3_6.md`

---

## Table des matières

1. [Tableaux de données](#1-tableaux-de-données)
2. [Raccourcis & actions rapides](#2-raccourcis--actions-rapides)
3. [Notifications intelligentes](#3-notifications-intelligentes)
4. [Dashboard intelligent](#4-dashboard-intelligent)
5. [Aide contextuelle](#5-aide-contextuelle)
6. [Confort visuel](#6-confort-visuel)
7. [Gestion du temps](#7-gestion-du-temps)
8. [Social](#8-social)
9. [Mobile](#9-mobile)

---

## 1. Tableaux de données

### Contexte de la réunion

> 🎮 **Marc :** « Sur Cultivia, les tableaux c'est l'enfer. J'ai 47 bovins, 15 parcelles, des centaines de transactions bancaires. Pas de tri multi-colonnes, pas de filtres, pas de recherche. Je passe mon temps à scroller. Et sur mobile, les tableaux débordent, c'est inutilisable. Quand je veux nourrir 12 vaches d'un coup, je dois cliquer une par une. L'export ? Inexistant. Je fais des screenshots pour suivre mes comptes. »
>
> 🎨 **Léa :** « On va créer un composant DataTable universel. Tri multi-colonnes, filtres par colonne, filtres rapides preset, recherche fuzzy, pagination cursor, sélection multiple avec actions groupées, export CSV, colonnes réordonnables et masquables, mode carte responsive sur mobile, et persistance localStorage. Un seul composable `useDataTable()` pour tout piloter. »
>
> 💻 **Tom :** « Je pars sur un composable `useDataTable()` qui encapsule toute la logique. Le composant `DataTable` sera générique, configurable par props. On utilise Fuse.js pour le fuzzy search, et on persiste les préférences colonnes dans localStorage. »

---

### 1.1 Tri multi-colonnes

**Problème joueur :** Impossible de trier les animaux par race PUIS par âge. Le tri simple ne suffit pas quand on a beaucoup de données.

**Solution UX :**
- Clic sur un header = tri primaire (asc → desc → neutre)
- Shift+clic = ajouter un tri secondaire (badge numéroté ①②③ sur chaque colonne triée)
- Max 3 niveaux de tri simultanés
- Indicateur visuel : flèche ↑↓ + badge numéro d'ordre

**Composant Vue 3 :**

```
DataTableHeader
  Props:
    column: ColumnDef
    sortState: SortState[]        // [{key, direction}]
    sortIndex: number | null      // position dans le tri multi (1,2,3)
  Events:
    @sort(key: string, multi: boolean)  // multi=true si Shift enfoncé
```

**Implémentation technique :**

```ts
// composables/useDataTable.ts (extrait tri)
interface SortState { key: string; direction: 'asc' | 'desc' }

function toggleSort(key: string, multi: boolean) {
  if (!multi) {
    sorts.value = sorts.value[0]?.key === key
      ? [{ key, direction: sorts.value[0].direction === 'asc' ? 'desc' : 'asc' }]
      : [{ key, direction: 'asc' }]
  } else {
    const idx = sorts.value.findIndex(s => s.key === key)
    if (idx >= 0) sorts.value[idx].direction = sorts.value[idx].direction === 'asc' ? 'desc' : 'asc'
    else if (sorts.value.length < 3) sorts.value.push({ key, direction: 'asc' })
  }
}
```

**Priorité :** MVP

---

### 1.2 Filtres par colonne

**Problème joueur :** « Je veux voir uniquement mes vaches Prim'Holstein gestantes. Actuellement je dois tout parcourir à l'œil. »

**Solution UX :**
- Icône entonnoir sur chaque header de colonne
- Clic → popover avec les options de filtre adaptées au type de données :
  - Texte : input recherche
  - Enum (race, sexe, état) : checkboxes multi-sélection
  - Nombre (poids, âge, santé) : slider range min/max
  - Booléen (nourri, vacciné) : toggle oui/non/tous
- Badges actifs sous le tableau : « Race: Prim'Holstein × | Gestante: Oui × » (clic × pour retirer)
- Bouton « Réinitialiser tous les filtres »

**Composant Vue 3 :**

```
DataTableColumnFilter
  Props:
    column: ColumnDef
    type: 'text' | 'enum' | 'range' | 'boolean'
    options?: string[]            // pour enum
    min?: number, max?: number    // pour range
    value: FilterValue
  Events:
    @change(value: FilterValue)
```

**Implémentation technique :**

```ts
// Dans useDataTable()
type FilterValue = string | string[] | [number, number] | boolean | null
interface ColumnFilter { key: string; type: string; value: FilterValue }

const filters = ref<ColumnFilter[]>([])
const filteredData = computed(() =>
  data.value.filter(row => filters.value.every(f => matchFilter(row, f)))
)
```

**Priorité :** MVP

---

### 1.3 Filtres rapides preset

**Problème joueur :** « Chaque jour je veux voir les mêmes choses : parcelles avec problèmes, animaux pas nourris, matériels en panne. Je refais les mêmes filtres à chaque connexion. »

**Solution UX :**
- Barre de boutons toggle au-dessus du tableau
- Presets contextuels par page :
  - Parcelles : `Toutes` | `En culture` | `En jachère` | `⚠️ Problèmes`
  - Animaux : `Tous` | `🍽️ Pas nourris` | `🏥 Malades` | `🤰 Gestantes` | `🍼 Allaitantes`
  - Matériels : `Tous` | `🔴 En panne` | `🟡 Usure > 70%` | `🟢 OK`
  - Transactions : `Toutes` | `Achats` | `Ventes` | `Prêts` | `Énergie`
- Presets combinables avec les filtres par colonne
- Preset actif = bouton coloré, les autres gris

**Composant Vue 3 :**

```
DataTablePresets
  Props:
    presets: PresetDef[]          // { id, label, icon, filter: FilterValue[] }
    active: string | null
  Events:
    @select(presetId: string)
```

**Implémentation technique :**

```ts
// Défini par page, injecté dans useDataTable()
const parcelPresets: PresetDef[] = [
  { id: 'all', label: 'Toutes', icon: null, filters: [] },
  { id: 'problems', label: '⚠️ Problèmes', filters: [{ key: 'status', type: 'enum', value: ['problem'] }] },
]
```

**Priorité :** MVP

---

### 1.4 Recherche fuzzy

**Problème joueur :** « J'ai nommé ma vache "Marguerite" mais je tape "margu" et rien ne sort. Il faut taper le nom exact. »

**Solution UX :**
- Barre de recherche globale au-dessus du tableau
- Recherche fuzzy tolérante aux fautes (Fuse.js)
- Recherche sur toutes les colonnes texte visibles
- Résultats surlignés (highlight du match)
- Debounce 200ms

**Composant Vue 3 :**

```
DataTableSearch
  Props:
    placeholder: string
    modelValue: string
  Events:
    @update:modelValue(query: string)
```

**Implémentation technique :**

```ts
// Dans useDataTable()
import Fuse from 'fuse.js'

const fuse = computed(() => new Fuse(filteredData.value, {
  keys: columns.value.filter(c => c.searchable).map(c => c.key),
  threshold: 0.3,
  includeMatches: true,
}))
const searchResults = computed(() =>
  searchQuery.value ? fuse.value.search(searchQuery.value) : filteredData.value
)
```

**Priorité :** MVP

---

### 1.5 Pagination cursor

**Problème joueur :** « Mon relevé bancaire a des centaines de lignes. La page met 10 secondes à charger. Et quand je suis page 5 et qu'une transaction arrive, tout décale. »

**Solution UX :**
- Pagination par curseur (pas par offset) pour stabilité
- 20 lignes par page par défaut (configurable : 10/20/50)
- Boutons Précédent / Suivant + indicateur « Page 1 sur ~5 »
- Scroll infini optionnel (toggle)
- Skeleton loaders pendant le chargement

**Composant Vue 3 :**

```
DataTablePagination
  Props:
    pageSize: number
    hasNext: boolean
    hasPrev: boolean
    total?: number
  Events:
    @next()
    @prev()
    @pageSizeChange(size: number)
```

**Implémentation technique :**

```ts
// Dans useDataTable() — mode API (server-side)
const cursor = ref<string | null>(null)
const pageSize = ref(20)

async function fetchPage(direction: 'next' | 'prev') {
  const { data, nextCursor, prevCursor } = await api.get(endpoint, {
    cursor: cursor.value, limit: pageSize.value, direction,
  })
  items.value = data
  cursors.next = nextCursor
  cursors.prev = prevCursor
}
```

**Priorité :** MVP

---

### 1.6 Sélection multiple + actions groupées

**Problème joueur :** « Nourrir 12 vaches une par une, c'est 12 clics + 12 confirmations + 12 toasts. Pareil pour vacciner, mettre au pré, etc. Je perds un temps fou. »

**Solution UX :**
- Checkbox en première colonne de chaque ligne
- Checkbox « tout sélectionner » dans le header (sélectionne la page courante)
- Barre d'actions groupées flottante en bas quand ≥ 1 sélectionné :
  - « 12 sélectionnés — [Nourrir] [Vacciner] [Mettre au pré] [Exporter] »
- Actions groupées contextuelles par page :
  - Animaux : Nourrir, Vacciner, Mettre au pré, Vendre abattoir
  - Parcelles : Labourer, Semer, Traiter, Récolter
  - Matériels : Entretenir, Vendre
- Confirmation unique pour l'action groupée (pas une par item)
- Résultat groupé : « 12/12 animaux nourris ✅ » ou « 10/12 nourris, 2 échoués (stock insuffisant) »

**Composant Vue 3 :**

```
DataTableBulkActions
  Props:
    selectedCount: number
    actions: BulkActionDef[]      // { id, label, icon, variant, confirm? }
  Events:
    @action(actionId: string, selectedIds: string[])

DataTable (intégration)
  Props:
    selectable: boolean
    bulkActions?: BulkActionDef[]
  Events:
    @bulkAction(actionId: string, selectedIds: string[])
```

**Implémentation technique :**

```ts
// Dans useDataTable()
const selected = ref<Set<string>>(new Set())
const allSelected = computed(() =>
  currentPage.value.every(row => selected.value.has(row.id))
)
function toggleAll() {
  if (allSelected.value) currentPage.value.forEach(r => selected.value.delete(r.id))
  else currentPage.value.forEach(r => selected.value.add(r.id))
}

// Appel API groupé
async function executeBulk(actionId: string) {
  const ids = [...selected.value]
  const results = await api.post(`/api/${resource}/bulk/${actionId}`, { ids })
  // results: { succeeded: string[], failed: { id, reason }[] }
}
```

**Priorité :** MVP

---

### 1.7 Export CSV

**Problème joueur :** « Je veux suivre mes finances dans un tableur. Impossible d'exporter quoi que ce soit. Je fais des copier-coller manuels. »

**Solution UX :**
- Bouton « Exporter CSV » dans la toolbar du tableau
- Exporte les données filtrées/triées actuelles (pas tout)
- Colonnes visibles uniquement (respecte le masquage)
- Nom de fichier auto : `cultivia_animaux_2026-04-05.csv`
- Encodage UTF-8 avec BOM (compatibilité Excel)

**Composant Vue 3 :**

```
DataTableExport
  Props:
    data: any[]
    columns: ColumnDef[]
    filename: string
  Events:
    @export()
```

**Implémentation technique :**

```ts
function exportCSV(data: any[], columns: ColumnDef[], filename: string) {
  const BOM = '\uFEFF'
  const headers = columns.filter(c => c.visible).map(c => c.label)
  const rows = data.map(row => columns.filter(c => c.visible).map(c => formatCell(row[c.key])))
  const csv = BOM + [headers, ...rows].map(r => r.map(c => `"${c}"`).join(';')).join('\n')
  downloadBlob(csv, `${filename}.csv`, 'text/csv;charset=utf-8')
}
```

**Priorité :** Post-MVP

---

### 1.8 Colonnes réordonnables / masquables

**Problème joueur :** « Dans la liste animaux, je m'en fiche de la colonne "Zone". Mais la colonne "Santé" est trop à droite, je dois scroller. Chaque joueur a ses priorités. »

**Solution UX :**
- Bouton ⚙️ « Colonnes » dans la toolbar
- Panneau latéral ou popover :
  - Liste des colonnes avec checkbox (visible/masqué)
  - Drag & drop pour réordonner
  - Bouton « Réinitialiser par défaut »
- Préférences sauvegardées par page dans localStorage

**Composant Vue 3 :**

```
DataTableColumnManager
  Props:
    columns: ColumnDef[]
  Events:
    @reorder(columns: ColumnDef[])
    @toggle(key: string, visible: boolean)
    @reset()
```

**Implémentation technique :**

```ts
// Persistance dans useDataTable()
const STORAGE_KEY = (tableId: string) => `cultivia_table_${tableId}`

function saveColumnPrefs(tableId: string, columns: ColumnDef[]) {
  const prefs = columns.map(c => ({ key: c.key, visible: c.visible, order: c.order }))
  localStorage.setItem(STORAGE_KEY(tableId), JSON.stringify(prefs))
}
function loadColumnPrefs(tableId: string, defaults: ColumnDef[]): ColumnDef[] {
  const saved = JSON.parse(localStorage.getItem(STORAGE_KEY(tableId)) || 'null')
  if (!saved) return defaults
  return defaults.map(d => ({ ...d, ...saved.find((s: any) => s.key === d.key) }))
    .sort((a, b) => a.order - b.order)
}
```

**Priorité :** Post-MVP

---

### 1.9 Mode carte responsive mobile

**Problème joueur :** « Sur téléphone, le tableau des animaux est illisible. Les colonnes se chevauchent, il faut scroller horizontalement sans arrêt. »

**Solution UX :**
- Breakpoint < 768px : le tableau bascule automatiquement en mode « cartes »
- Chaque ligne devient une carte empilée verticalement
- Carte : titre (nom animal), badges (état, santé), infos clés, bouton action
- Swipe gauche sur une carte = actions rapides (voir §9)
- Toggle manuel desktop ↔ cartes disponible

**Composant Vue 3 :**

```
DataTableCardView
  Props:
    items: any[]
    cardTemplate: Component       // slot ou composant de rendu carte
    selected: Set<string>
  Events:
    @select(id: string)
    @action(id: string, action: string)
```

**Implémentation technique :**

```ts
// Dans DataTable.vue
const isMobile = useMediaQuery('(max-width: 768px)')
const viewMode = ref<'table' | 'cards'>(isMobile.value ? 'cards' : 'table')
watch(isMobile, (val) => { viewMode.value = val ? 'cards' : 'table' })
```

```css
/* Transition fluide */
.data-view-enter-active, .data-view-leave-active { transition: opacity 0.2s; }
.data-view-enter-from, .data-view-leave-to { opacity: 0; }
```

**Priorité :** MVP

---

### 1.10 Persistance localStorage

**Problème joueur :** « À chaque reconnexion, je dois refaire mes filtres, mes tris, ma taille de page. Rien n'est mémorisé. »

**Solution UX :**
- Toutes les préférences du tableau sont persistées automatiquement :
  - Tris actifs, filtres actifs, preset sélectionné
  - Taille de page, colonnes visibles et ordre
- Par page (clé unique par tableau)
- Bouton « Réinitialiser mes préférences » dans ⚙️

**Implémentation technique :**

```ts
// useDataTable() — persistance automatique
function useDataTable(tableId: string, options: DataTableOptions) {
  const state = reactive({ sorts: [], filters: [], pageSize: 20, columns: [] })

  // Charger au mount
  onMounted(() => {
    const saved = localStorage.getItem(`dt_${tableId}`)
    if (saved) Object.assign(state, JSON.parse(saved))
  })

  // Sauvegarder au changement (debounce 500ms)
  watchDebounced(state, () => {
    localStorage.setItem(`dt_${tableId}`, JSON.stringify(state))
  }, { debounce: 500, deep: true })

  return { ...toRefs(state), reset: () => localStorage.removeItem(`dt_${tableId}`) }
}
```

**Priorité :** MVP

---

### Récapitulatif Section 1 — Composable `useDataTable()`

```ts
// API publique complète
const {
  // Données
  items, filteredItems, paginatedItems, total,
  // Tri
  sorts, toggleSort,
  // Filtres
  filters, setFilter, clearFilter, clearAllFilters,
  activePreset, setPreset,
  // Recherche
  searchQuery,
  // Pagination
  page, pageSize, hasNext, hasPrev, nextPage, prevPage,
  // Sélection
  selected, toggleSelect, toggleAll, allSelected, clearSelection,
  // Colonnes
  columns, reorderColumns, toggleColumn, resetColumns,
  // Export
  exportCSV,
  // Persistance
  reset,
} = useDataTable('animals', {
  columns: animalColumns,
  presets: animalPresets,
  fetchFn: (params) => api.get('/api/animals', params), // mode server-side
  // ou data: ref([...])  // mode client-side
})
```


---

## 2. Raccourcis & actions rapides

### Contexte de la réunion

> 🎮 **Marc :** « Chaque matin sur Cultivia c'est la même routine : nourrir les animaux, abreuver, pailler, traire, vérifier les parcelles, faire le plein de HVC. C'est 30 minutes de clics répétitifs. Et quand je me trompe, pas de "annuler". Je dois tout refaire. Si je pouvais enchaîner les actions sur une parcelle sans revenir à la liste à chaque fois, ça changerait ma vie. »
>
> 🎨 **Léa :** « On va attaquer ça sur 3 axes : actions groupées en 1 clic, flux de travail enchaînés, et raccourcis clavier. Plus un historique des dernières actions avec "refaire", des favoris, et une barre de commande Ctrl+K à la Spotlight. »
>
> 💻 **Tom :** « Côté Vue, un store Pinia `useActionHistoryStore` pour l'historique, un composable `useKeyboardShortcuts()` pour les raccourcis, et un composant `CommandPalette` pour le Ctrl+K. »

---

### 2.1 Actions groupées 1 clic

**Problème joueur :** « Nourrir 3 bâtiments = 3 × (ouvrir bâtiment → sélectionner ration → confirmer). Pareil pour abreuver, pailler. C'est la corvée quotidienne. »

**Solution UX :**
- Bouton « Routine du matin 🌅 » sur le dashboard
- Exécute en séquence : Nourrir tous les bâtiments → Abreuver → Pailler → Traire
- Modale récapitulative avant exécution :
  - Liste des actions avec coût HT/HVC/€ estimé par action
  - Total HT / HVC / € en bas
  - Checkbox par action pour inclure/exclure
  - Bouton « Lancer la routine (X HT) »
- Résultat groupé : tableau succès/échecs par action
- Routines personnalisables (créer ses propres séquences)

**Composant Vue 3 :**

```
RoutineRunner
  Props:
    routine: RoutineDef            // { id, name, steps: RoutineStep[] }
  Events:
    @execute(steps: RoutineStep[])
    @complete(results: RoutineResult[])

RoutineStep: { action: string, target: string, params: any, enabled: boolean }
RoutineResult: { step: RoutineStep, success: boolean, message: string }
```

**Implémentation technique :**

```ts
// stores/routineStore.ts
const defaultMorning: RoutineDef = {
  id: 'morning',
  name: 'Routine du matin 🌅',
  steps: [
    { action: 'feed', target: 'all_buildings', params: { use_auto_ration: true } },
    { action: 'water', target: 'all_buildings', params: {} },
    { action: 'litter', target: 'all_litiere_buildings', params: { method: 'machine' } },
    { action: 'milk', target: 'all_milking_buildings', params: {} },
  ]
}

async function executeRoutine(routine: RoutineDef) {
  const results: RoutineResult[] = []
  for (const step of routine.steps.filter(s => s.enabled)) {
    try {
      await api.post(`/api/bulk/${step.action}`, step.params)
      results.push({ step, success: true, message: 'OK' })
    } catch (e) {
      results.push({ step, success: false, message: e.response?.data?.message })
    }
  }
  return results
}
```

**Priorité :** Post-MVP

---

### 2.2 Nourrissage automatique 15 jours

**Problème joueur :** « Le nourrissage quotidien c'est la corvée n°1. Même avec la routine, c'est tous les jours. Si je pars en vacances 3 jours IRL, mes animaux crèvent de faim. »

**Solution UX :**
- Toggle « Nourrissage auto 🔄 » sur chaque bâtiment (cf. UX Phase 2, action 5)
- Vérification stock 15 jours avant activation
- Si stock insuffisant : proposition du nombre de jours possibles
- Badge « AUTO 🔄 12j » visible sur la carte bâtiment du dashboard
- Notification push quand stock épuisé ou auto-feed désactivé
- Désactivation manuelle possible à tout moment

**Composant Vue 3 :**

```
AutoFeedToggle
  Props:
    buildingId: string
    currentRation: Ration | null
    stockDays: number              // jours couverts par le stock actuel
    isActive: boolean
    daysRemaining: number
  Events:
    @activate(rationId: string, days: number)
    @deactivate()
```

**Implémentation technique :**

```ts
// composables/useAutoFeed.ts
async function activateAutoFeed(buildingId: string, rationId: string) {
  const stock = await api.get(`/api/buildings/${buildingId}/feed-estimate`, { ration_id: rationId, days: 15 })
  if (stock.possibleDays < 15) {
    // Proposer stock.possibleDays au lieu de 15
    return { partial: true, maxDays: stock.possibleDays }
  }
  return api.post(`/api/buildings/${buildingId}/auto-feed`, { ration_id: rationId, duration_days: 15 })
}
```

**Priorité :** MVP

---

### 2.3 Flux travail parcelle enchaîné

**Problème joueur :** « Pour semer du blé : je vais sur la parcelle, je déchaume, je retourne à la liste, je reclique la parcelle, je laboure, retour liste, re-clic, je prépare, retour, re-clic, je sème. 8 navigations pour 4 actions. »

**Solution UX :**
- Sur la page détail parcelle, les actions s'enchaînent sans quitter la page
- Après chaque action réussie, le bouton suivant dans le flux s'active automatiquement
- Flux visuel en stepper horizontal : `Déchaumer → Labourer → Préparer → Semer → [Engrais] → [Traiter] → Récolter`
- Étape courante mise en avant, étapes futures grisées, étapes passées cochées ✅
- Bouton « Action suivante → » proéminent après chaque succès
- Possibilité de sauter des étapes optionnelles (engrais, traitements)

**Composant Vue 3 :**

```
ParcelWorkflow
  Props:
    parcelId: string
    currentState: ParcelState      // 'fallow' | 'stubbled' | 'plowed' | 'prepared' | 'sown' | 'growing' | 'mature'
    availableActions: Action[]     // depuis GET /api/parcels/:id → available_actions
  Events:
    @actionComplete(action: string, result: any)

WorkflowStepper
  Props:
    steps: StepDef[]
    currentStep: number
  Events:
    @stepClick(index: number)
```

**Implémentation technique :**

```ts
// composables/useParcelWorkflow.ts
const WORKFLOW_STEPS = ['stubble', 'plow', 'harrow', 'sow', 'fertilize', 'treat', 'roll', 'harvest']

const currentStepIndex = computed(() => {
  const stateMap: Record<string, number> = {
    fallow: 0, stubbled: 1, plowed: 2, prepared: 3, sown: 4, growing: 5, mature: 7
  }
  return stateMap[parcelState.value] ?? 0
})

async function executeAndAdvance(action: string, params: any) {
  await api.post(`/api/parcels/${parcelId}/prepare`, { type: action, ...params })
  await refreshParcel() // recharge l'état → le stepper avance automatiquement
}
```

**Priorité :** MVP

---

### 2.4 Favoris

**Problème joueur :** « J'ai 15 parcelles mais je surveille surtout les 3 qui ont du blé en croissance. J'ai 47 animaux mais mes 2 meilleures laitières m'intéressent le plus. Pas moyen de les mettre en avant. »

**Solution UX :**
- Icône ⭐ sur chaque ligne de tableau (parcelle, animal, bâtiment, matériel)
- Clic = toggle favori (sauvegardé localStorage)
- Filtre rapide « ⭐ Favoris » dans les presets du DataTable
- Section « Favoris » en haut du dashboard avec accès direct
- Max 20 favoris par catégorie

**Composant Vue 3 :**

```
FavoriteToggle
  Props:
    entityType: 'parcel' | 'animal' | 'building' | 'vehicle'
    entityId: string
    isFavorite: boolean
  Events:
    @toggle(entityType: string, entityId: string)
```

**Implémentation technique :**

```ts
// stores/favoritesStore.ts
const favorites = useLocalStorage<Record<string, string[]>>('cultivia_favorites', {})

function toggle(type: string, id: string) {
  const list = favorites.value[type] ?? []
  const idx = list.indexOf(id)
  if (idx >= 0) list.splice(idx, 1)
  else if (list.length < 20) list.push(id)
  favorites.value[type] = list
}
```

**Priorité :** Post-MVP

---

### 2.5 Historique 10 dernières actions + refaire

**Problème joueur :** « J'ai nourri le mauvais bâtiment. Pas de retour arrière. Et hier j'ai fait un super enchaînement sur une parcelle, j'aimerais le refaire sur une autre. »

**Solution UX :**
- Panneau « Historique récent » accessible via icône 🕐 dans le header
- 10 dernières actions avec : horodatage, description, cible, résultat
- Bouton « Refaire ↻ » sur chaque action (pré-remplit le formulaire avec les mêmes paramètres mais permet de changer la cible)
- Pas de « annuler » (les actions ont des effets serveur irréversibles) — mais le refaire est très utile
- Historique en session (pas persisté entre connexions)

**Composant Vue 3 :**

```
ActionHistory
  Props:
    actions: ActionRecord[]
  Events:
    @redo(action: ActionRecord)

ActionRecord: {
  id: string, timestamp: Date, type: string,
  label: string, target: string, params: any,
  success: boolean, result?: any
}
```

**Implémentation technique :**

```ts
// stores/actionHistoryStore.ts
const history = ref<ActionRecord[]>([])
const MAX = 10

function record(action: ActionRecord) {
  history.value.unshift(action)
  if (history.value.length > MAX) history.value.pop()
}

function redo(action: ActionRecord) {
  router.push({ name: action.type, params: { id: action.target }, query: { redo: JSON.stringify(action.params) } })
}
```

**Priorité :** Nice-to-have

---

### 2.6 Raccourcis clavier

**Problème joueur :** « Les joueurs expérimentés veulent aller vite. Cliquer sur "Nourrir" puis "Confirmer" c'est lent. Un raccourci clavier serait 2× plus rapide. »

**Solution UX :**
- Raccourcis globaux :
  - `N` → Nourrir (contexte bâtiment/animal)
  - `S` → Semer (contexte parcelle)
  - `R` → Récolter (contexte parcelle mature)
  - `T` → Traire (contexte bâtiment laitier)
  - `Esc` → Fermer modale / annuler
  - `Ctrl+K` → Barre de commande (§2.7)
  - `?` → Aide raccourcis (overlay)
- Raccourcis actifs uniquement quand aucun input n'a le focus
- Overlay « ? » listant tous les raccourcis disponibles sur la page courante
- Désactivables dans les paramètres

**Composant Vue 3 :**

```
KeyboardShortcutOverlay
  Props:
    shortcuts: ShortcutDef[]
  Events:
    @close()
```

**Implémentation technique :**

```ts
// composables/useKeyboardShortcuts.ts
function useKeyboardShortcuts(shortcuts: ShortcutDef[]) {
  function handler(e: KeyboardEvent) {
    if (['INPUT', 'TEXTAREA', 'SELECT'].includes((e.target as HTMLElement).tagName)) return
    const match = shortcuts.find(s => s.key === e.key && !!s.ctrl === e.ctrlKey)
    if (match) { e.preventDefault(); match.action() }
  }
  onMounted(() => window.addEventListener('keydown', handler))
  onUnmounted(() => window.removeEventListener('keydown', handler))
}

// Usage dans une page
useKeyboardShortcuts([
  { key: 'n', label: 'Nourrir', action: () => openFeedModal() },
  { key: 's', label: 'Semer', action: () => openSowModal() },
  { key: 'Escape', label: 'Fermer', action: () => closeModal() },
])
```

**Priorité :** Post-MVP

---

### 2.7 Barre de commande Ctrl+K

**Problème joueur :** « Je veux aller à la parcelle 7, je dois : menu Parcelles → scroller → trouver la 7 → cliquer. Si je pouvais juste taper "parcelle 7"... »

**Solution UX :**
- `Ctrl+K` (ou `Cmd+K` sur Mac) ouvre une barre de commande modale
- Recherche fuzzy sur : pages, parcelles, animaux, bâtiments, matériels, actions
- Résultats groupés par catégorie avec icônes
- Navigation clavier : ↑↓ pour sélectionner, Enter pour exécuter, Esc pour fermer
- Actions directes : « Nourrir Stabulation 1 », « Aller parcelle 7 », « Relevé bancaire »
- Historique des commandes récentes affiché par défaut (avant de taper)

**Composant Vue 3 :**

```
CommandPalette
  Props:
    open: boolean
  Events:
    @close()
    @execute(command: CommandResult)

CommandResult: {
  type: 'navigate' | 'action',
  route?: RouteLocationRaw,
  action?: () => Promise<void>,
  label: string
}
```

**Implémentation technique :**

```ts
// composables/useCommandPalette.ts
import Fuse from 'fuse.js'

interface CommandEntry { id: string; label: string; category: string; icon: string; route?: string; action?: () => void }

function useCommandPalette() {
  const entries = computed<CommandEntry[]>(() => [
    // Pages statiques
    ...staticPages,
    // Entités dynamiques
    ...parcels.value.map(p => ({ id: `parcel-${p.id}`, label: `Parcelle #${p.id}`, category: 'Parcelles', icon: '🌾', route: `/parcels/${p.id}` })),
    ...animals.value.map(a => ({ id: `animal-${a.id}`, label: `${a.name} (${a.breed})`, category: 'Animaux', icon: '🐄', route: `/animals/${a.id}` })),
    // Actions
    ...availableActions.value,
  ])

  const fuse = computed(() => new Fuse(entries.value, { keys: ['label', 'category'], threshold: 0.4 }))
  const search = (q: string) => q ? fuse.value.search(q).map(r => r.item) : recentCommands.value
  return { search, execute }
}
```

**Priorité :** Post-MVP


---

## 3. Notifications intelligentes

### Contexte de la réunion

> 🎮 **Marc :** « Sur Cultivia, les notifs c'est un mur de texte. Tout est au même niveau : "Votre blé est mûr" mélangé avec "Bienvenue sur le serveur". Aucun moyen de filtrer. Et si je me connecte pas pendant 2 jours, je rate des trucs critiques — culture mature qui pourrit, animal malade, prêt impayé. J'aimerais recevoir un push sur mon téléphone pour les urgences. »
>
> 🎨 **Léa :** « On va structurer ça en 3 niveaux d'urgence avec un centre de notifications filtrable, du push navigateur opt-in, un résumé quotidien au login, et des alertes configurables par le joueur. »
>
> 💻 **Tom :** « Un store Pinia `useNotificationStore` alimenté par WebSocket. Les push via l'API Notification du navigateur avec Service Worker. Le résumé quotidien est un endpoint dédié. »

---

### 3.1 Trois niveaux d'urgence

**Problème joueur :** « Toutes les notifs se ressemblent. Je rate les urgences noyées dans le bruit. »

**Solution UX :**
- 🔴 **Critique** (rouge) : action requise immédiatement ou perte irréversible
  - Culture mature > 7 jours (pourrissement), animal santé < 20, solde < -40 000€ (faillite proche), prêt impayé, auto-feed arrêté (stock épuisé), matériel cassé en plein travail
- 🟠 **Attention** (orange) : action recommandée sous 24-48h
  - Culture mature (pas encore en danger), animal pas nourri, usure matériel > 70%, stock HVC < 20%, nutriments sol < 20, vaccin expire dans 7j, fosse fumier > 90%
- 🔵 **Info** (bleu) : information non urgente
  - Tick journalier passé, météo du jour, transaction bancaire, vente réalisée, ami connecté, résultat concours

**Composant Vue 3 :**

```
NotificationBadge (header)
  Props:
    criticalCount: number
    warningCount: number
    infoCount: number
  Events:
    @click()

NotificationItem
  Props:
    notification: Notification
  Events:
    @read(id: string)
    @action(id: string)           // navigation vers la cible

Notification: {
  id: string, level: 'critical' | 'warning' | 'info',
  title: string, message: string, icon: string,
  createdAt: Date, readAt: Date | null,
  actionRoute?: string            // ex: '/parcels/7'
}
```

**Implémentation technique :**

```ts
// stores/notificationStore.ts
const notifications = ref<Notification[]>([])
const unreadByLevel = computed(() => ({
  critical: notifications.value.filter(n => !n.readAt && n.level === 'critical').length,
  warning: notifications.value.filter(n => !n.readAt && n.level === 'warning').length,
  info: notifications.value.filter(n => !n.readAt && n.level === 'info').length,
}))

// Badge header : affiche le point rouge si critical > 0, orange si warning > 0, sinon bleu
const badgeColor = computed(() =>
  unreadByLevel.value.critical > 0 ? 'red' : unreadByLevel.value.warning > 0 ? 'orange' : 'blue'
)
```

**Priorité :** MVP

---

### 3.2 Centre de notifications filtrable

**Problème joueur :** « Je veux revoir les notifs d'hier. Impossible, elles disparaissent. Et je veux voir uniquement les alertes animaux, pas le reste. »

**Solution UX :**
- Panneau latéral (slide-in depuis la droite) ouvert par clic sur la cloche
- Filtres en haut :
  - Par niveau : `Toutes` | `🔴 Critiques` | `🟠 Attention` | `🔵 Info`
  - Par catégorie : `Cultures` | `Animaux` | `Finances` | `Matériels` | `Social`
- Chaque notif : icône niveau, titre, message, horodatage relatif (« il y a 2h »), bouton « Voir → »
- Actions : « Tout marquer comme lu », « Supprimer les lues »
- Scroll infini avec chargement progressif
- Notifs non lues en fond légèrement coloré, lues en fond neutre

**Composant Vue 3 :**

```
NotificationCenter
  Props:
    open: boolean
  Events:
    @close()

NotificationFilters
  Props:
    activeLevel: string | null
    activeCategory: string | null
  Events:
    @filterLevel(level: string | null)
    @filterCategory(category: string | null)
```

**Implémentation technique :**

```ts
// WebSocket listener dans le store
function initWebSocket() {
  const ws = useWebSocket('/ws')
  ws.on('notification', (notif: Notification) => {
    notifications.value.unshift(notif)
    if (notif.level === 'critical') showSystemToast(notif) // toast immédiat pour les critiques
  })
}

async function markAllRead() {
  await api.post('/api/notifications/mark-all-read')
  notifications.value.forEach(n => n.readAt = new Date())
}
```

**Priorité :** MVP

---

### 3.3 Push navigateur opt-in

**Problème joueur :** « Quand je suis sur un autre onglet ou que j'ai fermé le jeu, je rate les urgences. Mon blé a pourri parce que je ne me suis pas connecté à temps. »

**Solution UX :**
- Proposition opt-in au premier login (pas de popup agressive) :
  - Bandeau discret : « 🔔 Recevez les alertes critiques même hors-jeu — [Activer] [Plus tard] »
- Seules les notifs 🔴 critiques déclenchent un push (pas de spam)
- Paramétrable : le joueur choisit quels types de critiques envoient un push
- Icône de notification native du navigateur avec badge

**Composant Vue 3 :**

```
PushOptIn
  Props:
    dismissed: boolean
  Events:
    @enable()
    @dismiss()
```

**Implémentation technique :**

```ts
// composables/usePushNotifications.ts
async function requestPush() {
  if (!('Notification' in window)) return
  const permission = await Notification.requestPermission()
  if (permission !== 'granted') return

  const reg = await navigator.serviceWorker.ready
  const sub = await reg.pushManager.subscribe({ userVisibleOnly: true, applicationServerKey: VAPID_KEY })
  await api.post('/api/push/subscribe', sub.toJSON())
}

// Service Worker (sw.js)
self.addEventListener('push', (e) => {
  const data = e.data.json()
  e.waitUntil(self.registration.showNotification(data.title, {
    body: data.message, icon: '/icon-192.png', badge: '/badge-72.png',
    tag: data.id, data: { url: data.actionRoute },
  }))
})
```

**Priorité :** Post-MVP

---

### 3.4 Résumé quotidien au login

**Problème joueur :** « Quand je me connecte le matin, je ne sais pas ce qui s'est passé pendant la nuit. Quels ticks sont passés ? Qu'est-ce qui a changé ? »

**Solution UX :**
- Modale « Résumé depuis votre dernière visite » affichée au login si > 1 tick passé
- Sections :
  - ⏰ Ticks passés : « 3 jours Cultivia écoulés (Jour 4 → Jour 7) »
  - 🌾 Cultures : « Blé parcelle #3 : 45% → 78%. Colza parcelle #7 : MATURE ✅ »
  - 🐄 Animaux : « 2 animaux pas nourris hier. Marguerite : santé 95 → 88. »
  - 💰 Finances : « Revenus : +2 340€. Dépenses : -1 200€ (énergie, salaires). Solde : 118 140€ »
  - 🔴 Alertes : « 1 alerte critique : Colza mature depuis 5 jours — récoltez vite ! »
  - 🌤️ Météo : « Aujourd'hui : ☀️ Soleil, pas de vent »
- Bouton « Voir les détails » par section → navigation
- Bouton « C'est noté ! » pour fermer
- Option « Ne plus afficher » dans les paramètres

**Composant Vue 3 :**

```
DailySummaryModal
  Props:
    summary: DailySummary
    open: boolean
  Events:
    @close()
    @navigate(route: string)

DailySummary: {
  ticksPassed: number, fromDay: number, toDay: number,
  crops: CropSummary[], animals: AnimalSummary[],
  finances: FinanceSummary, alerts: Notification[],
  weather: WeatherData
}
```

**Implémentation technique :**

```ts
// Au login, dans le router guard ou App.vue
const lastVisit = useLocalStorage('cultivia_last_visit', null)

onMounted(async () => {
  if (lastVisit.value) {
    const summary = await api.get('/api/player/summary-since', { since: lastVisit.value })
    if (summary.ticksPassed > 0) showDailySummary.value = true
  }
  lastVisit.value = new Date().toISOString()
})
```

**Priorité :** MVP

---

### 3.5 Alertes configurables

**Problème joueur :** « Je m'en fiche des notifs "ami connecté" mais je veux absolument savoir quand un animal est malade. Chaque joueur a ses priorités. »

**Solution UX :**
- Page Paramètres → onglet « Notifications »
- Tableau de configuration :

| Catégorie | Événement | In-app | Push | Seuil configurable |
|-----------|-----------|--------|------|---------------------|
| Cultures | Culture mature | ✅ | ☐ | — |
| Cultures | Culture en danger (>7j mature) | ✅ | ✅ | Jours : `[7]` |
| Animaux | Animal pas nourri | ✅ | ☐ | — |
| Animaux | Santé < seuil | ✅ | ✅ | Seuil : `[30]` |
| Animaux | Naissance | ✅ | ☐ | — |
| Finances | Solde < seuil | ✅ | ✅ | Seuil : `[-10000]` |
| Finances | Prêt impayé | ✅ | ✅ | — |
| Matériels | Usure > seuil | ✅ | ☐ | Seuil : `[70]%` |
| Matériels | Panne | ✅ | ✅ | — |
| Social | Ami connecté | ☐ | ☐ | — |
| Social | Message reçu | ✅ | ☐ | — |

- Toggles par ligne (in-app / push)
- Seuils ajustables par slider ou input
- Sauvegardé côté serveur (pas localStorage — cross-device)

**Composant Vue 3 :**

```
NotificationSettings
  Props:
    config: NotifConfig[]
  Events:
    @save(config: NotifConfig[])

NotifConfig: {
  event: string, category: string,
  inApp: boolean, push: boolean,
  threshold?: number
}
```

**Implémentation technique :**

```ts
// API
// GET /api/player/notification-settings → NotifConfig[]
// PUT /api/player/notification-settings → NotifConfig[]

// Le worker (BullMQ) vérifie les seuils à chaque tick et crée les notifications
// selon la config du joueur. Le push est envoyé uniquement si push=true pour cet event.
```

**Priorité :** Post-MVP


---

## 4. Dashboard intelligent

### Contexte de la réunion

> 🎮 **Marc :** « Le dashboard actuel c'est une page statique. Moi je veux voir mes laitières en premier, un autre joueur veut voir ses parcelles. Et les infos sont trop résumées — je veux un vrai graphe de mes finances, pas juste un chiffre. »
>
> 🎨 **Léa :** « Dashboard à widgets réorganisables en drag & drop. Chaque joueur compose son propre tableau de bord. 5 widgets de base : À faire, Alertes, Économie sparkline, Météo 7j, Production. Tous personnalisables. »
>
> 💻 **Tom :** « Vue-grid-layout pour le drag & drop. Chaque widget est un composant autonome avec son propre fetch. Layout persisté dans localStorage. »

---

### 4.1 Widget « À faire aujourd'hui »

**Problème joueur :** « Je me connecte et je ne sais pas par quoi commencer. Quelles actions sont prioritaires ? »

**Solution UX :**
- Checklist dynamique générée à partir de l'état du jeu :
  - ☐ Nourrir Stabulation 1 (12 animaux) — 0.5 HT
  - ☐ Abreuver Stabulation 1 — 0.25 HT
  - ☐ Traire (traite 1/4) — 0.5 HT
  - ☐ Récolter Colza parcelle #7 (MATURE ⚠️) — 3.2 HT
  - ☐ Entretenir Tracteur 120CV (usure 72%) — 1.0 HT
- Trié par urgence (critique en haut)
- Clic sur une ligne → navigation directe vers l'action
- Bouton « Tout faire » → lance la routine (§2.1)
- Se coche automatiquement quand l'action est effectuée (WebSocket)
- HT total estimé affiché en bas : « Total : 5.45 HT / 40 HT disponibles »

**Composant Vue 3 :**

```
WidgetTodo
  Props:
    tasks: TodoTask[]
  Events:
    @navigate(route: string)
    @runAll()

TodoTask: {
  id: string, label: string, icon: string,
  urgency: 'critical' | 'warning' | 'normal',
  paCost: number, route: string, done: boolean
}
```

**Implémentation technique :**

```ts
// composables/useTodoWidget.ts
async function fetchTodos(): Promise<TodoTask[]> {
  const [animals, parcels, vehicles] = await Promise.all([
    api.get('/api/dashboard/todo/animals'),
    api.get('/api/dashboard/todo/parcels'),
    api.get('/api/dashboard/todo/vehicles'),
  ])
  return [...animals, ...parcels, ...vehicles].sort((a, b) => urgencyOrder[a.urgency] - urgencyOrder[b.urgency])
}
```

**Priorité :** MVP

---

### 4.2 Widget « Alertes »

**Problème joueur :** « Les alertes critiques sont noyées dans le dashboard. Je veux un bloc rouge bien visible. »

**Solution UX :**
- Bloc avec bordure rouge/orange selon le niveau le plus élevé
- Liste des 5 alertes les plus récentes non lues (critiques d'abord)
- Chaque alerte : icône, message court, lien « Voir → »
- Si 0 alerte : bloc vert « ✅ Tout va bien ! »
- Badge compteur en coin du widget

**Composant Vue 3 :**

```
WidgetAlerts
  Props:
    alerts: Notification[]        // filtrées level != 'info'
  Events:
    @navigate(route: string)
    @openCenter()
```

**Priorité :** MVP

---

### 4.3 Widget « Économie sparkline »

**Problème joueur :** « Je vois mon solde mais pas la tendance. Est-ce que je gagne ou je perds de l'argent cette saison ? »

**Solution UX :**
- Solde actuel en gros (couleur selon seuil)
- Sparkline (mini graphe en ligne) des 30 derniers jours : revenus vs dépenses
- Indicateur tendance : ↑ +12% ce mois (vert) ou ↓ -5% (rouge)
- Clic → page `/bank`

**Composant Vue 3 :**

```
WidgetEconomy
  Props:
    balance: number
    history: { day: number, revenue: number, expense: number }[]
    trend: number                 // % variation
  Events:
    @click()
```

**Implémentation technique :**

```ts
// Sparkline en SVG inline (pas de lib externe)
// <svg viewBox="0 0 200 50"><polyline :points="sparklinePoints" /></svg>
const sparklinePoints = computed(() =>
  props.history.map((d, i) => `${i * (200 / props.history.length)},${50 - (d.revenue - d.expense) * scale}`).join(' ')
)
```

**Priorité :** MVP

---

### 4.4 Widget « Météo 7 jours »

**Problème joueur :** « Je vois la météo du jour mais pas la prévision. Si je sais qu'il va pleuvoir demain, je ne sème pas aujourd'hui. »

**Solution UX :**
- Météo du jour en grand : icône + température + vent + grêle
- Prévision 7 jours en mini-cartes horizontales : jour, icône, niveau eau/soleil
- Zone de la ferme du joueur
- Alerte grêle : bandeau rouge « ⚠️ Grêle prévue Jour 5 — protégez vos cultures ! »

**Composant Vue 3 :**

```
WidgetWeather
  Props:
    today: WeatherData
    forecast: WeatherData[]       // 7 jours
    zone: string
  Events:
    @dayClick(day: number)
```

**Priorité :** MVP

---

### 4.5 Widget « Production »

**Problème joueur :** « Combien de lait j'ai produit cette semaine ? Combien de tonnes de blé en stock ? Pas de vue synthétique. »

**Solution UX :**
- Résumé par catégorie :
  - 🥛 Lait : 245 L aujourd'hui | Cuve : 1 200/2 000 L
  - 🌾 Stocks silo : Blé 50T, Colza 18T
  - 🧀 Fromages : 3 en affinage, 12 prêts
  - 🐄 Troupeau : 47 bovins (6 lactantes, 2 gestantes, 1 malade)
- Mini barres de remplissage pour les cuves/silos
- Clic par section → page détail

**Composant Vue 3 :**

```
WidgetProduction
  Props:
    milk: { today: number, tank: number, tankMax: number }
    stocks: { product: string, quantity: number, unit: string }[]
    herd: { total: number, lactating: number, pregnant: number, sick: number }
  Events:
    @navigate(section: string)
```

**Priorité :** MVP

---

### 4.6 Drag & drop et personnalisation

**Problème joueur :** « Je veux la météo en haut à droite et les alertes en plein centre. Un autre joueur veut l'inverse. »

**Solution UX :**
- Grille responsive 12 colonnes
- Chaque widget : déplaçable par drag & drop (poignée en haut)
- Redimensionnable (coin bas-droit)
- Bouton « + Ajouter un widget » → catalogue des widgets disponibles
- Bouton « 🔒 Verrouiller la disposition » (empêche les déplacements accidentels)
- Bouton « Réinitialiser » → layout par défaut
- Layout persisté dans localStorage par joueur

**Composant Vue 3 :**

```
DashboardGrid
  Props:
    layout: LayoutItem[]          // { i, x, y, w, h, component }
    locked: boolean
  Events:
    @layoutChange(layout: LayoutItem[])
    @addWidget(widgetType: string)
    @removeWidget(widgetId: string)
```

**Implémentation technique :**

```ts
// Utilisation de vue-grid-layout (ou grid-layout-plus pour Vue 3)
import { GridLayout, GridItem } from 'grid-layout-plus'

const defaultLayout: LayoutItem[] = [
  { i: 'todo', x: 0, y: 0, w: 4, h: 4, component: 'WidgetTodo' },
  { i: 'alerts', x: 4, y: 0, w: 4, h: 2, component: 'WidgetAlerts' },
  { i: 'economy', x: 8, y: 0, w: 4, h: 2, component: 'WidgetEconomy' },
  { i: 'weather', x: 4, y: 2, w: 4, h: 2, component: 'WidgetWeather' },
  { i: 'production', x: 8, y: 2, w: 4, h: 4, component: 'WidgetProduction' },
]

const layout = useLocalStorage('cultivia_dashboard_layout', defaultLayout)
```

**Priorité :** Post-MVP (les widgets sont MVP, le drag & drop est Post-MVP)

---

## 5. Aide contextuelle

### Contexte de la réunion

> 🎮 **Marc :** « Cultivia a une courbe d'apprentissage brutale. Quand j'ai commencé, j'ai perdu 50 000€ en 2 jours parce que je ne comprenais pas le système de HT. Et encore aujourd'hui, quand un bouton est grisé, je ne sais pas toujours pourquoi. Le tooltip dit "Conditions non remplies" — merci, très utile. Et pour calculer combien de foin il faut pour 20 vaches pendant 3 mois, je sors la calculatrice. »
>
> 🎨 **Léa :** « Aide à 3 niveaux : tooltips enrichis partout, bouton ? par page avec explication contextuelle, et tutoriel guidé au premier lancement. Plus des calculateurs intégrés et un indicateur clair de pourquoi chaque bouton est grisé. »
>
> 💻 **Tom :** « Un composant `HelpTooltip` réutilisable, un composable `useContextualHelp()`, et un système de tutoriel step-by-step avec highlight d'éléments DOM. »

---

### 5.1 Tooltips enrichis

**Problème joueur :** « Les tooltips sont soit absents, soit inutiles. "Solde insuffisant" — oui mais il me manque combien ? »

**Solution UX :**
- Chaque élément interactif a un tooltip informatif
- Tooltips sur les boutons grisés : raison précise + données chiffrées
  - ❌ « Conditions non remplies »
  - ✅ « HT insuffisants (besoin : 3.2 HT, disponible : 1.5 HT) »
  - ✅ « Moissonneuse requise — vous n'en possédez pas. [Acheter →] »
- Tooltips sur les jauges : valeur exacte + seuils
  - « Santé : 72/100 (🟢 > 50 = OK, 🟡 20-50 = attention, 🔴 < 20 = critique) »
- Tooltips sur les icônes : explication du symbole
  - « 🤰 Gestante — naissance prévue dans 42 jours »
- Délai d'apparition : 300ms (pas instantané, pas trop lent)
- Position intelligente (ne déborde pas de l'écran)

**Composant Vue 3 :**

```
HelpTooltip
  Props:
    content: string | VNode       // texte simple ou contenu riche (lien, chiffres)
    position: 'top' | 'bottom' | 'left' | 'right'
    delay: number                 // défaut 300ms
    maxWidth: number              // défaut 300px
  Slots:
    default                       // élément déclencheur
```

**Implémentation technique :**

```ts
// Directive v-tooltip pour usage rapide
// <button v-tooltip="'HT insuffisants (3.2 requis, 1.5 dispo)'" :disabled="!canAct">

app.directive('tooltip', {
  mounted(el, binding) {
    el._tooltip = new TooltipManager(el, binding.value, binding.arg)
  },
  updated(el, binding) { el._tooltip.update(binding.value) },
  unmounted(el) { el._tooltip.destroy() },
})
```

**Priorité :** MVP

---

### 5.2 Bouton « ? » par page

**Problème joueur :** « C'est quoi la "qualité du sol" ? Comment ça marche les nutriments ? Je dois aller chercher sur le wiki externe. »

**Solution UX :**
- Bouton « ? » fixe en bas à droite de chaque page (ou dans le header de page)
- Clic → panneau latéral avec aide contextuelle de la page courante :
  - Explication des concepts de la page
  - Signification des icônes et couleurs
  - Formules simplifiées (ex : « Rendement = base × sol × nutriments × météo × traitements »)
  - Liens vers les pages liées
  - FAQ courte (2-3 questions fréquentes)
- Contenu différent par page (géré par un fichier de contenu)
- Bouton « Tutoriel de cette page » → relance le tuto guidé de la page

**Composant Vue 3 :**

```
ContextualHelp
  Props:
    pageId: string                // ex: 'parcels-detail', 'animals-list'
    open: boolean
  Events:
    @close()
    @startTutorial()
```

**Implémentation technique :**

```ts
// help/content.ts — contenu d'aide par page
const helpContent: Record<string, HelpPage> = {
  'parcels-detail': {
    title: 'Détail parcelle',
    sections: [
      { title: 'Qualité du sol', body: 'La qualité (1-3 ⭐) affecte le rendement...' },
      { title: 'Nutriments', body: '6 nutriments (N, P, K, Ca, Mg, S)...' },
      { title: 'Formule rendement', body: 'rendement = base_regional × sol × ...' },
    ],
    faq: [
      { q: 'Pourquoi mon rendement est faible ?', a: 'Vérifiez les nutriments et les traitements.' },
    ],
  },
}
```

**Priorité :** Post-MVP

---

### 5.3 Tutoriel guidé premier lancement

**Problème joueur :** « Mon pote a essayé Cultivia, il a abandonné en 10 minutes. Trop complexe, aucune guidance. »

**Solution UX :**
- Au premier login (après création de ferme), tutoriel interactif en 8 étapes :
  1. « Voici votre tableau de bord » (highlight dashboard)
  2. « Votre solde et vos HT » (highlight header)
  3. « Achetez votre première parcelle » (guide vers /parcels/buy)
  4. « Préparez le sol et semez » (guide le flux parcelle)
  5. « Construisez un hangar » (guide vers /buildings/new)
  6. « Achetez un tracteur » (guide vers /vehicles/shop)
  7. « Consultez la météo » (highlight widget météo)
  8. « Explorez la coopérative » (guide vers /coop)
- Chaque étape : overlay sombre + spotlight sur l'élément cible + bulle explicative
- Boutons : « Suivant → », « Passer le tutoriel », « ← Précédent »
- Progression sauvegardée (si le joueur quitte, il reprend où il en était)
- Relançable depuis Paramètres → « Relancer le tutoriel »

**Composant Vue 3 :**

```
TutorialOverlay
  Props:
    step: TutorialStep
    currentIndex: number
    totalSteps: number
  Events:
    @next()
    @prev()
    @skip()

TutorialStep: {
  target: string                  // sélecteur CSS de l'élément à highlight
  title: string, content: string,
  position: 'top' | 'bottom' | 'left' | 'right',
  route?: string                  // navigation avant l'étape
}
```

**Implémentation technique :**

```ts
// composables/useTutorial.ts
const TUTORIAL_KEY = 'cultivia_tutorial_progress'
const steps: TutorialStep[] = [
  { target: '#dashboard', title: 'Tableau de bord', content: 'Voici votre centre de commande...', position: 'bottom' },
  { target: '#header-balance', title: 'Solde & HT', content: 'Surveillez votre solde et vos HT...', position: 'bottom' },
  // ...
]

function highlightElement(selector: string) {
  const el = document.querySelector(selector)
  if (!el) return
  const rect = el.getBoundingClientRect()
  // Positionner l'overlay avec un trou à la position de l'élément
  overlay.value = { top: rect.top, left: rect.left, width: rect.width, height: rect.height }
}
```

**Priorité :** Post-MVP

---

### 5.4 Calculateurs intégrés

**Problème joueur :** « Combien de foin il me faut pour 20 vaches pendant 3 mois ? Combien de semences pour 10 ha de blé ? Je sors la calculatrice à chaque fois. »

**Solution UX :**
- Bouton « 🧮 Calculateur » accessible depuis les pages pertinentes
- Calculateurs disponibles :
  - **Alimentation** : nb animaux × type × jours → kg foin, maïs, compléments nécessaires
  - **Semences** : surface × culture × type semence → kg semences + coût
  - **Engrais** : surface × type engrais → kg + coût + apports NPK
  - **Rentabilité culture** : surface × culture → coût total (semences + engrais + traitements + HT) vs revenu estimé (rendement × prix coop)
  - **Rentabilité lait** : nb vaches × production moyenne → revenu mensuel - coûts (alimentation + énergie)
- Inputs interactifs avec résultat en temps réel
- Bouton « Appliquer » → pré-remplit le formulaire d'action correspondant

**Composant Vue 3 :**

```
Calculator
  Props:
    type: 'feed' | 'seeds' | 'fertilizer' | 'crop-profit' | 'milk-profit'
  Events:
    @apply(params: any)           // pré-remplir un formulaire

CalculatorFeed
  Props:
    animalCounts: Record<string, number>  // { 'adult_cow': 8, 'heifer': 3, 'calf': 1 }
    days: number
  Computed:
    result: { hay_kg, corn_kg, complement_kg, total_cost }
```

**Implémentation technique :**

```ts
// composables/useCalculator.ts
function calcFeedNeeds(animals: Record<string, number>, days: number) {
  const DAILY_NEEDS: Record<string, { hay: number; corn: number }> = {
    adult_cow: { hay: 12, corn: 15 },
    heifer: { hay: 8, corn: 10 },
    calf: { hay: 2, corn: 3 },
  }
  let hay = 0, corn = 0
  for (const [type, count] of Object.entries(animals)) {
    hay += (DAILY_NEEDS[type]?.hay ?? 0) * count * days
    corn += (DAILY_NEEDS[type]?.corn ?? 0) * count * days
  }
  return { hay_kg: hay, corn_kg: corn }
}
```

**Priorité :** Post-MVP

---

### 5.5 Indicateur « pourquoi bouton grisé »

**Problème joueur :** « Le bouton "Récolter" est grisé. Pourquoi ? Il me manque quoi ? C'est le matériel ? Les HT ? Le HVC ? Aucune idée. »

**Solution UX :**
- Chaque bouton d'action affiche TOUTES les conditions, pas juste la première qui échoue
- Sous le bouton grisé : liste des conditions avec ✅ / ❌
  - ✅ Culture mature (100%)
  - ❌ Moissonneuse requise — [Acheter →]
  - ✅ Benne disponible
  - ❌ HT insuffisants (3.2 requis, 1.5 dispo)
  - ✅ HVC suffisant (19.2L)
  - ❌ Silo plein — [Agrandir →] ou [Vendre stock →]
- Liens d'action directe sur les conditions échouées (navigation vers la solution)
- Mode compact (tooltip) sur les petits boutons, mode étendu sur les boutons principaux

**Composant Vue 3 :**

```
ActionButton
  Props:
    label: string
    icon: string
    conditions: ActionCondition[]  // { label, met: boolean, detail?: string, fixRoute?: string }
    loading: boolean
    variant: 'primary' | 'danger'
  Events:
    @click()
  Computed:
    disabled: boolean              // = !conditions.every(c => c.met)
```

**Implémentation technique :**

```ts
// Les conditions viennent de available_actions dans GET /api/parcels/:id
// Le backend retourne pour chaque action :
// { action: 'harvest', possible: true/false, conditions: [
//   { key: 'mature', met: true, label: 'Culture mature' },
//   { key: 'harvester', met: false, label: 'Moissonneuse requise', fixRoute: '/vehicles/shop?family=harvest' },
// ]}

// Le composant ActionButton les affiche directement
```

**Priorité :** MVP


---

## 6. Confort visuel

### Contexte de la réunion

> 🎮 **Marc :** « Je joue souvent le soir, l'écran blanc me brûle les yeux. Et mon pote daltonien ne distingue pas les diodes vert/rouge sur les parcelles. Les animations sont jolies mais sur mon vieux PC ça rame. »
>
> 🎨 **Léa :** « Accessibilité et personnalisation visuelle. Dark mode, taille de police ajustable, respect de prefers-reduced-motion, 3 niveaux de densité, et un mode daltonisme avec des formes en plus des couleurs. »
>
> 💻 **Tom :** « CSS custom properties pour le theming, un composable `useVisualPrefs()` qui persiste dans localStorage, et des media queries pour reduced-motion. »

---

### 6.1 Dark mode

**Problème joueur :** « Écran blanc à 23h = migraine. »

**Solution UX :**
- Toggle dans le header : ☀️ / 🌙
- 3 modes : Clair / Sombre / Auto (suit le système OS)
- Transition douce (200ms) entre les modes
- Toutes les couleurs adaptées : fonds, textes, bordures, graphiques, jauges
- Les icônes emoji restent lisibles dans les deux modes

**Composant Vue 3 :**

```
ThemeToggle
  Props:
    mode: 'light' | 'dark' | 'auto'
  Events:
    @change(mode: string)
```

**Implémentation technique :**

```ts
// composables/useTheme.ts
const mode = useLocalStorage('cultivia_theme', 'auto')
const resolved = computed(() => {
  if (mode.value !== 'auto') return mode.value
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
})
watchEffect(() => document.documentElement.setAttribute('data-theme', resolved.value))
```

```css
:root[data-theme="light"] { --bg: #ffffff; --text: #1a1a1a; --surface: #f5f5f5; }
:root[data-theme="dark"] { --bg: #1a1a1a; --text: #e5e5e5; --surface: #2a2a2a; }
body { background: var(--bg); color: var(--text); transition: background 0.2s, color 0.2s; }
```

**Priorité :** MVP

---

### 6.2 Taille de police ajustable

**Problème joueur :** « Sur mon écran 27 pouces le texte est minuscule. Sur mon laptop 13 pouces c'est trop gros. »

**Solution UX :**
- Paramètres → slider taille de police : 12px / 14px (défaut) / 16px / 18px
- Affecte tout le texte via `font-size` sur `<html>`
- Prévisualisation en temps réel

**Implémentation technique :**

```ts
const fontSize = useLocalStorage('cultivia_font_size', 14)
watchEffect(() => document.documentElement.style.fontSize = `${fontSize.value}px`)
```

**Priorité :** Post-MVP

---

### 6.3 Animations réduites (prefers-reduced-motion)

**Problème joueur :** « Les animations de compteur, les transitions, les confettis — sur mon vieux PC ça lag. Et certains joueurs ont des troubles vestibulaires. »

**Solution UX :**
- Respect automatique de `prefers-reduced-motion: reduce` du système
- Toggle manuel dans les paramètres : « Réduire les animations »
- Quand activé :
  - Compteurs animés → changement instantané
  - Transitions de page → coupe franche
  - Confettis → désactivés
  - Barres de progression → pas d'animation de remplissage
  - Skeleton loaders → placeholder statique

**Implémentation technique :**

```ts
const reduceMotion = useLocalStorage('cultivia_reduce_motion', false)
const prefersReduced = useMediaQuery('(prefers-reduced-motion: reduce)')
const shouldReduce = computed(() => reduceMotion.value || prefersReduced.value)
provide('reduceMotion', shouldReduce)
```

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

**Priorité :** MVP

---

### 6.4 Densité d'affichage

**Problème joueur :** « Je veux voir le maximum d'infos à l'écran sans scroller. Un autre joueur préfère des gros boutons bien espacés. »

**Solution UX :**
- 3 modes : Compact / Normal (défaut) / Confortable
- Affecte : padding des cellules tableau, hauteur des lignes, espacement des cartes, taille des boutons
- Toggle dans les paramètres ou raccourci dans la toolbar des tableaux

**Implémentation technique :**

```ts
const density = useLocalStorage<'compact' | 'normal' | 'comfortable'>('cultivia_density', 'normal')
watchEffect(() => document.documentElement.setAttribute('data-density', density.value))
```

```css
[data-density="compact"] { --row-height: 32px; --cell-padding: 4px 8px; --gap: 8px; }
[data-density="normal"] { --row-height: 44px; --cell-padding: 8px 12px; --gap: 16px; }
[data-density="comfortable"] { --row-height: 56px; --cell-padding: 12px 16px; --gap: 24px; }
```

**Priorité :** Post-MVP

---

### 6.5 Mode daltonisme

**Problème joueur :** « Les diodes vert/rouge sur les parcelles, je ne les distingue pas. Pareil pour les jauges. »

**Solution UX :**
- Paramètres → « Mode daltonisme » avec 3 profils : Protanopie, Deutéranopie, Tritanopie
- Quand activé :
  - Les couleurs seules ne portent JAMAIS l'information (déjà le cas par design WCAG)
  - Ajout de formes distinctives : ✅ ⚠️ ❌ en plus des couleurs
  - Palette alternative : bleu/orange au lieu de vert/rouge
  - Motifs (hachures, pointillés) sur les barres de progression en plus de la couleur
- Contraste WCAG AA minimum garanti dans tous les modes

**Implémentation technique :**

```ts
const colorblindMode = useLocalStorage<'none' | 'protanopia' | 'deuteranopia' | 'tritanopia'>('cultivia_colorblind', 'none')
watchEffect(() => document.documentElement.setAttribute('data-colorblind', colorblindMode.value))
```

```css
[data-colorblind="deuteranopia"] {
  --color-success: #0077bb; --color-danger: #ee7733; --color-warning: #ccbb44;
}
/* Les icônes ✅❌⚠️ sont toujours présentes en plus de la couleur */
```

**Priorité :** Post-MVP

---

## 7. Gestion du temps

### Contexte de la réunion

> 🎮 **Marc :** « Le temps Cultivia c'est déroutant au début. 1 jour IRL = 7 jours Cultivia. Les saisons passent vite. Je rate souvent la fenêtre de semis parce que je ne sais pas quel mois on est en jeu. Et le countdown du prochain tick, il est où ? Nulle part. Je dois calculer de tête. »
>
> 🎨 **Léa :** « Un calendrier Cultivia toujours visible, un countdown prochain tick, un historique des saisons, et un planificateur de rappels. »
>
> 💻 **Tom :** « Un composable `useGameTime()` qui se synchronise avec le serveur et calcule les countdowns en temps réel. »

---

### 7.1 Calendrier Cultivia visible

**Problème joueur :** « Quel mois on est en jeu ? Quelle saison ? Je dois aller sur le dashboard pour voir ça. »

**Solution UX :**
- Dans le header permanent (toutes les pages) :
  - Jour + Mois + Année Cultivia : « Mars, Jour 4 — An 1 »
  - Icône saison colorée : 🌸 🟢 / ☀️ 🟡 / 🍂 🟠 / ❄️ 🔵
- Clic → popover calendrier mensuel :
  - Grille 7 colonnes (jours de la semaine Cultivia)
  - Jour actuel surligné
  - Événements marqués : jours de marché (🟢🔵), fenêtres de semis (🌱), dates de récolte estimées (🌾)
  - Navigation mois précédent/suivant

**Composant Vue 3 :**

```
GameCalendar
  Props:
    currentDay: number
    currentMonth: string
    currentYear: number
    season: 'spring' | 'summer' | 'autumn' | 'winter'
    events: CalendarEvent[]
  Events:
    @dayClick(day: number)
```

**Implémentation technique :**

```ts
// composables/useGameTime.ts
const gameTime = ref<GameTime>({ day: 0, month: '', year: 0, season: 'spring' })

async function sync() {
  const data = await api.get('/api/time')
  gameTime.value = data
  nextTickAt.value = new Date(data.next_tick_utc)
}

// Sync au mount + à chaque WebSocket 'daily_tick'
onMounted(sync)
ws.on('daily_tick', sync)
```

**Priorité :** MVP

---

### 7.2 Countdown prochain tick

**Problème joueur :** « Le prochain jour Cultivia c'est dans combien de temps ? Si c'est dans 5 minutes, j'attends. Si c'est dans 3 heures, je fais autre chose. »

**Solution UX :**
- Dans le header, à côté du calendrier : « ⏱️ Prochain jour dans 2h 34min »
- Countdown en temps réel (mis à jour chaque seconde)
- Quand < 5 min : texte orange pulsant « Prochain jour imminent ! »
- Quand tick passe : flash vert « Nouveau jour ! » + refresh automatique des données
- Tooltip : « Prochain tick horaire dans Xmin, prochain tick journalier dans Xh, prochain tick hebdomadaire dans Xj »

**Composant Vue 3 :**

```
TickCountdown
  Props:
    nextTickAt: Date
  Computed:
    remaining: string             // "2h 34min" ou "4min 12s"
    imminent: boolean             // < 5 min
```

**Implémentation technique :**

```ts
// Dans useGameTime()
const remaining = ref('')
const imminent = ref(false)

useIntervalFn(() => {
  const diff = nextTickAt.value.getTime() - Date.now()
  if (diff <= 0) { remaining.value = 'Maintenant !'; return }
  imminent.value = diff < 5 * 60 * 1000
  const h = Math.floor(diff / 3600000)
  const m = Math.floor((diff % 3600000) / 60000)
  const s = Math.floor((diff % 60000) / 1000)
  remaining.value = h > 0 ? `${h}h ${m}min` : `${m}min ${s}s`
}, 1000)
```

**Priorité :** MVP

---

### 7.3 Historique des saisons

**Problème joueur :** « La saison dernière il a beaucoup plu, mes rendements étaient bons. Mais je ne m'en souviens plus. Pas d'historique. »

**Solution UX :**
- Page « Historique » accessible depuis le calendrier ou le menu
- Tableau par saison :
  - Saison, Année, Météo dominante, Rendements moyens, Revenus, Dépenses, Événements marquants
- Graphique évolution sur plusieurs saisons (rendements, finances)
- Utile pour planifier : « L'hiver dernier j'ai dépensé X en alimentation animale »

**Composant Vue 3 :**

```
SeasonHistory
  Props:
    seasons: SeasonRecord[]
  Events:
    @seasonClick(seasonId: string)

SeasonRecord: {
  season: string, year: number, weatherSummary: string,
  avgYield: number, revenue: number, expense: number, events: string[]
}
```

**Priorité :** Nice-to-have

---

### 7.4 Planificateur de rappels

**Problème joueur :** « Je sais que mon blé sera mûr dans 12 jours Cultivia. Mais dans combien de jours IRL ? Et je vais oublier. »

**Solution UX :**
- Bouton « 🔔 Rappel » sur les éléments avec échéance :
  - Culture en croissance → rappel à maturité
  - Gestation → rappel à la naissance
  - Prêt → rappel avant échéance
  - Vaccin → rappel avant expiration
  - Affinage fromage → rappel quand prêt
- Le rappel calcule automatiquement la date IRL correspondante
- Notification in-app + push (si activé) au moment du rappel
- Page « Mes rappels » avec liste et possibilité de supprimer

**Composant Vue 3 :**

```
ReminderButton
  Props:
    entityType: string
    entityId: string
    estimatedDate: Date           // date Cultivia estimée
    label: string
  Events:
    @set()
    @cancel()
```

**Implémentation technique :**

```ts
// stores/reminderStore.ts
interface Reminder { id: string; entityType: string; entityId: string; label: string; triggerAt: Date; notified: boolean }

const reminders = useLocalStorage<Reminder[]>('cultivia_reminders', [])

// Vérification à chaque tick
ws.on('daily_tick', () => {
  const now = new Date()
  reminders.value.filter(r => !r.notified && r.triggerAt <= now).forEach(r => {
    notificationStore.push({ level: 'info', title: '🔔 Rappel', message: r.label })
    r.notified = true
  })
})
```

**Priorité :** Post-MVP


---

## 8. Social

### Contexte de la réunion

> 🎮 **Marc :** « Cultivia c'est multijoueur mais on se sent seul. Pas de chat en jeu, pas de statut en ligne, pas moyen de savoir si un transporteur est fiable. L'annuaire joueurs est une liste brute sans filtre. Et quand un ami se connecte, je ne le sais pas. »
>
> 🎨 **Léa :** « Annuaire filtrable, statut en ligne, chat MP live, système de réputation, et notifications ami connecté. Le social doit être intégré naturellement, pas un module séparé. »
>
> 💻 **Tom :** « WebSocket pour le chat et les statuts en temps réel. Un store `useSocialStore` pour centraliser. La réputation est côté serveur, calculée à chaque transaction. »

---

### 8.1 Annuaire joueurs filtrable

**Problème joueur :** « Je cherche un transporteur dans ma région. L'annuaire liste 500 joueurs sans filtre. »

**Solution UX :**
- Page `/players` avec DataTable (réutilise le composant §1)
- Colonnes : Pseudo, Région, Département, Activités (badges : 🚛 Transport, 🏭 Concession, 🧀 Fromagerie, 🍷 Vigne), En ligne (🟢/⚫), Réputation (⭐), Ami (oui/non)
- Filtres : région, activité, en ligne uniquement, amis uniquement
- Recherche fuzzy par pseudo
- Clic sur un joueur → profil public : ferme, activités, réputation, bouton « Ajouter en ami »

**Composant Vue 3 :**

```
PlayerDirectory
  Props:
    players: PlayerSummary[]
  Events:
    @viewProfile(playerId: string)
    @addFriend(playerId: string)
```

**Priorité :** Post-MVP

---

### 8.2 Statut en ligne

**Problème joueur :** « Je veux envoyer un message à un joueur mais je ne sais pas s'il est connecté. »

**Solution UX :**
- Pastille verte 🟢 (en ligne) / grise ⚫ (hors ligne) / orange 🟠 (inactif > 5min)
- Visible dans : annuaire, liste amis, chat, profil joueur, annonces marché
- « Dernière connexion : il y a 2h » si hors ligne
- Paramètre : « Apparaître hors ligne » (mode invisible)

**Implémentation technique :**

```ts
// WebSocket presence channel
ws.on('presence', (data: { playerId: string; status: 'online' | 'idle' | 'offline' }) => {
  socialStore.updatePresence(data.playerId, data.status)
})

// Heartbeat toutes les 30s pour maintenir le statut online
useIntervalFn(() => ws.send('heartbeat'), 30000)
// Idle detection : si pas d'interaction > 5min → status 'idle'
```

**Priorité :** Post-MVP

---

### 8.3 Chat MP live

**Problème joueur :** « Pour négocier un prix avec un joueur, je dois passer par un forum externe. Pas de messagerie en jeu. »

**Solution UX :**
- Icône 💬 dans le header avec badge messages non lus
- Clic → panneau chat (slide-in droite, sous les notifications)
- Liste des conversations récentes (triées par dernier message)
- Conversation : bulles de chat classiques, horodatage, statut lu/non lu
- Input message + envoi (Enter ou bouton)
- Nouveau message : recherche joueur par pseudo
- Notifications : badge + son discret (désactivable)
- Historique persisté côté serveur

**Composant Vue 3 :**

```
ChatPanel
  Props:
    conversations: Conversation[]
    activeConversation: string | null
  Events:
    @selectConversation(id: string)
    @sendMessage(conversationId: string, text: string)
    @newConversation(playerId: string)

ChatMessage: { id: string, senderId: string, text: string, sentAt: Date, readAt: Date | null }
```

**Implémentation technique :**

```ts
// WebSocket chat channel
ws.on('chat_message', (msg: ChatMessage) => {
  socialStore.addMessage(msg.conversationId, msg)
  if (msg.senderId !== me.value.id) unreadCount.value++
})

async function sendMessage(convId: string, text: string) {
  const msg = await api.post(`/api/chat/${convId}/messages`, { text })
  socialStore.addMessage(convId, msg)
}
```

**Priorité :** Post-MVP

---

### 8.4 Réputation transporteurs / ETA

**Problème joueur :** « J'ai payé un transporteur, il n'a jamais livré. Pas de système de notation, pas de recours. »

**Solution UX :**
- Après chaque transaction (transport, ETA, vente joueur) : modale de notation
  - 1-5 étoiles + commentaire optionnel (max 200 chars)
  - Notation obligatoire pour les transports (bloquante pour le prochain transport)
- Profil joueur : note moyenne + nombre d'avis + derniers commentaires
- Annuaire : colonne « Réputation » triable
- Seuils : < 2.5 ⭐ → badge « ⚠️ Attention » sur les annonces du joueur
- Anti-abus : 1 seule note par transaction, pas de note entre amis privilégiés

**Composant Vue 3 :**

```
RatingModal
  Props:
    transaction: TransactionRef
    open: boolean
  Events:
    @submit(rating: number, comment: string)
    @skip()                       // uniquement si non obligatoire

ReputationBadge
  Props:
    rating: number
    count: number
  Computed:
    stars: string                 // "⭐⭐⭐⭐" (arrondi)
    level: 'excellent' | 'good' | 'average' | 'poor'
```

**Implémentation technique :**

```ts
// API
// POST /api/ratings → { target_player_id, transaction_id, rating: 1-5, comment? }
// GET /api/players/:id/ratings → { average, count, recent: Rating[] }

// Le serveur calcule la moyenne pondérée (notes récentes pèsent plus)
```

**Priorité :** Post-MVP

---

### 8.5 Notification ami connecté

**Problème joueur :** « Mon ami joue en même temps que moi et je ne le sais pas. On pourrait faire du commerce ensemble. »

**Solution UX :**
- Quand un ami se connecte : notification 🔵 info « 👋 Marc est en ligne »
- Configurable dans les alertes (§3.5) : activable/désactivable par joueur
- Clic sur la notif → ouvre le chat avec cet ami
- Limité aux amis (pas tous les joueurs du serveur)
- Cooldown : 1 notif par ami par session (pas à chaque reconnexion)

**Implémentation technique :**

```ts
// WebSocket
ws.on('friend_online', (data: { playerId: string; username: string }) => {
  if (notifSettings.value.friendOnline) {
    notificationStore.push({
      level: 'info', title: `👋 ${data.username} est en ligne`,
      message: 'Cliquez pour discuter', actionRoute: `/chat/${data.playerId}`,
    })
  }
})
```

**Priorité :** Nice-to-have

---

## 9. Mobile

### Contexte de la réunion

> 🎮 **Marc :** « Je joue souvent sur mon téléphone dans les transports. Le site desktop sur mobile c'est une catastrophe : boutons minuscules, tableaux qui débordent, navigation impossible. Et quand je perds la connexion dans le métro, tout plante. »
>
> 🎨 **Léa :** « Mobile-first pour les actions quotidiennes. Bottom nav 5 onglets, swipe actions sur les cartes, pull-to-refresh, actions rapides depuis l'accueil, et un mode hors-ligne partiel pour consulter ses données. »
>
> 💻 **Tom :** « Vue responsive avec breakpoints, composants adaptatifs, Service Worker pour le cache offline, et touch events natifs. »

---

### 9.1 Bottom navigation 5 onglets

**Problème joueur :** « Le menu hamburger en haut c'est 2 clics pour accéder à n'importe quoi. Et le pouce ne va pas en haut de l'écran. »

**Solution UX :**
- Barre de navigation fixe en bas (mobile uniquement, < 768px)
- 5 onglets : 🏠 Accueil | 🌾 Parcelles | 🐄 Animaux | 💰 Banque | ☰ Plus
- Onglet actif : icône colorée + label
- Onglets inactifs : icône grise
- « Plus » ouvre un menu avec les pages secondaires (Bâtiments, Matériels, Coop, Social, Paramètres)
- Badge notification sur l'icône Accueil si alertes non lues
- Disparaît en scroll down, réapparaît en scroll up (gain d'espace)

**Composant Vue 3 :**

```
BottomNav
  Props:
    items: NavItem[]              // { icon, label, route, badge? }
    active: string
  Events:
    @navigate(route: string)
```

**Implémentation technique :**

```ts
// Layout mobile conditionnel
const isMobile = useMediaQuery('(max-width: 768px)')
// Dans App.vue : <BottomNav v-if="isMobile" /> au lieu du sidebar desktop

// Hide on scroll down
const { y, directions } = useScroll(window)
const showNav = ref(true)
watch(() => directions.bottom, (scrollingDown) => { showNav.value = !scrollingDown })
```

```css
.bottom-nav {
  position: fixed; bottom: 0; left: 0; right: 0; height: 56px; z-index: 50;
  display: flex; justify-content: space-around; align-items: center;
  background: var(--surface); border-top: 1px solid var(--border);
  transform: translateY(v-bind(showNav ? '0' : '100%')); transition: transform 0.2s;
}
/* Safe area pour iPhone avec encoche */
@supports (padding-bottom: env(safe-area-inset-bottom)) {
  .bottom-nav { padding-bottom: env(safe-area-inset-bottom); }
}
```

**Priorité :** MVP

---

### 9.2 Swipe actions sur cartes

**Problème joueur :** « Sur mobile, les boutons d'action sont trop petits. Et ouvrir chaque fiche pour faire une action simple c'est trop de clics. »

**Solution UX :**
- En mode carte mobile (DataTable §1.9), swipe gauche sur une carte révèle les actions rapides
- Actions contextuelles :
  - Carte animal : 🍽️ Nourrir | 💧 Abreuver | 👁️ Voir
  - Carte parcelle : 🌾 Récolter | 👁️ Voir
  - Carte matériel : 🔧 Entretenir | 👁️ Voir
- Boutons larges, colorés, faciles à toucher (min 44×44px)
- Swipe droit = favori ⭐
- Feedback haptique (vibration légère) sur mobile

**Composant Vue 3 :**

```
SwipeableCard
  Props:
    leftActions: SwipeAction[]    // { icon, label, color, action }
    rightActions: SwipeAction[]
  Events:
    @action(actionId: string)
  Slots:
    default                       // contenu de la carte
```

**Implémentation technique :**

```ts
// composables/useSwipe.ts
function useSwipe(el: Ref<HTMLElement>) {
  let startX = 0, currentX = 0
  const offset = ref(0)
  const onTouchStart = (e: TouchEvent) => { startX = e.touches[0].clientX }
  const onTouchMove = (e: TouchEvent) => {
    currentX = e.touches[0].clientX
    offset.value = Math.max(-150, Math.min(80, currentX - startX))
  }
  const onTouchEnd = () => {
    if (offset.value < -80) emit('swipe-left')
    else if (offset.value > 40) emit('swipe-right')
    offset.value = 0
  }
  return { offset, onTouchStart, onTouchMove, onTouchEnd }
}
```

**Priorité :** Post-MVP

---

### 9.3 Pull-to-refresh

**Problème joueur :** « Sur mobile, comment je rafraîchis les données ? F5 n'existe pas. »

**Solution UX :**
- Tirer vers le bas depuis le haut de la page = refresh des données
- Indicateur visuel : spinner qui apparaît en haut pendant le pull
- Seuil : 60px de pull minimum pour déclencher
- Feedback : vibration légère au déclenchement
- Fonctionne sur toutes les pages avec données dynamiques

**Composant Vue 3 :**

```
PullToRefresh
  Props:
    loading: boolean
  Events:
    @refresh()
  Slots:
    default
```

**Implémentation technique :**

```ts
// composables/usePullToRefresh.ts
function usePullToRefresh(onRefresh: () => Promise<void>) {
  const pulling = ref(false), pullDistance = ref(0), refreshing = ref(false)
  const THRESHOLD = 60

  function onTouchMove(e: TouchEvent) {
    if (window.scrollY > 0) return // seulement si en haut de page
    pullDistance.value = Math.min(120, e.touches[0].clientY - startY)
    if (pullDistance.value > 0) e.preventDefault()
  }
  async function onTouchEnd() {
    if (pullDistance.value >= THRESHOLD) {
      refreshing.value = true
      await onRefresh()
      refreshing.value = false
    }
    pullDistance.value = 0
  }
  return { pullDistance, refreshing, onTouchStart, onTouchMove, onTouchEnd }
}
```

**Priorité :** MVP

---

### 9.4 Actions rapides depuis l'accueil

**Problème joueur :** « Sur mobile, les actions quotidiennes (nourrir, traire, vérifier) demandent trop de navigation. »

**Solution UX :**
- Section « Actions rapides » en haut du dashboard mobile (avant les widgets)
- Grille 2×2 de gros boutons :
  - 🍽️ Nourrir tout | 🥛 Traire | 🌾 Récoltes prêtes (badge compteur) | 📊 Résumé
- Chaque bouton : icône + label + badge si action nécessaire
- Clic → exécution directe (avec confirmation modale rapide) ou navigation
- Personnalisable : long press pour changer les 4 actions rapides

**Composant Vue 3 :**

```
QuickActions
  Props:
    actions: QuickAction[]
  Events:
    @execute(actionId: string)
    @customize()

QuickAction: { id: string, icon: string, label: string, badge?: number, route?: string, action?: () => void }
```

**Implémentation technique :**

```ts
const defaultQuickActions: QuickAction[] = [
  { id: 'feed-all', icon: '🍽️', label: 'Nourrir tout', action: () => routineStore.feedAll() },
  { id: 'milk', icon: '🥛', label: 'Traire', route: '/buildings?action=milk' },
  { id: 'harvest', icon: '🌾', label: 'Récoltes', badge: matureCount.value, route: '/parcels?preset=mature' },
  { id: 'summary', icon: '📊', label: 'Résumé', action: () => showDailySummary.value = true },
]
const quickActions = useLocalStorage('cultivia_quick_actions', defaultQuickActions.map(a => a.id))
```

**Priorité :** MVP

---

### 9.5 Mode hors-ligne partiel

**Problème joueur :** « Dans le métro je perds la connexion. Le jeu plante et je perds ce que je faisais. Au minimum, je voudrais consulter mes données. »

**Solution UX :**
- Service Worker cache les dernières données consultées
- En mode hors-ligne :
  - Consultation possible : dashboard, liste parcelles/animaux/bâtiments, relevé bancaire, fiche animal
  - Bandeau jaune en haut : « 📡 Mode hors-ligne — données du {date dernière sync} »
  - Actions désactivées (tous les boutons grisés avec tooltip « Connexion requise »)
  - Calculateurs fonctionnent (pas besoin de réseau)
- À la reconnexion : sync automatique + toast « 🟢 Connexion rétablie — données mises à jour »

**Implémentation technique :**

```ts
// Service Worker (sw.js) — stratégie cache-first pour les données
const CACHE_NAME = 'cultivia-data-v1'
const DATA_URLS = ['/api/player/me', '/api/parcels', '/api/animals', '/api/buildings', '/api/bank/summary']

self.addEventListener('fetch', (e) => {
  if (DATA_URLS.some(url => e.request.url.includes(url))) {
    e.respondWith(
      fetch(e.request).then(res => {
        const clone = res.clone()
        caches.open(CACHE_NAME).then(c => c.put(e.request, clone))
        return res
      }).catch(() => caches.match(e.request))
    )
  }
})
```

```ts
// composables/useOffline.ts
const isOnline = useOnline()
const lastSync = useLocalStorage('cultivia_last_sync', null)

watch(isOnline, async (online) => {
  if (online) {
    await refreshAllStores()
    lastSync.value = new Date().toISOString()
    toast.success('🟢 Connexion rétablie')
  }
})
```

**Priorité :** Nice-to-have

---

## Récapitulatif des priorités

### MVP (Phase 0-1)

| # | Feature | Section |
|---|---------|---------|
| 1.1 | Tri multi-colonnes | Tableaux |
| 1.2 | Filtres par colonne | Tableaux |
| 1.3 | Filtres rapides preset | Tableaux |
| 1.4 | Recherche fuzzy | Tableaux |
| 1.5 | Pagination cursor | Tableaux |
| 1.6 | Sélection multiple + actions groupées | Tableaux |
| 1.9 | Mode carte responsive mobile | Tableaux |
| 1.10 | Persistance localStorage | Tableaux |
| 2.2 | Nourrissage auto 15j | Raccourcis |
| 2.3 | Flux travail parcelle enchaîné | Raccourcis |
| 3.1 | 3 niveaux d'urgence | Notifications |
| 3.2 | Centre notifs filtrable | Notifications |
| 3.4 | Résumé quotidien au login | Notifications |
| 4.1 | Widget À faire | Dashboard |
| 4.2 | Widget Alertes | Dashboard |
| 4.3 | Widget Économie sparkline | Dashboard |
| 4.4 | Widget Météo 7j | Dashboard |
| 4.5 | Widget Production | Dashboard |
| 5.1 | Tooltips enrichis | Aide |
| 5.5 | Indicateur pourquoi bouton grisé | Aide |
| 6.1 | Dark mode | Confort visuel |
| 6.3 | Animations réduites | Confort visuel |
| 7.1 | Calendrier Cultivia visible | Temps |
| 7.2 | Countdown prochain tick | Temps |
| 9.1 | Bottom nav mobile | Mobile |
| 9.3 | Pull-to-refresh | Mobile |
| 9.4 | Actions rapides accueil | Mobile |

### Post-MVP (Phase 2-3)

| # | Feature | Section |
|---|---------|---------|
| 1.7 | Export CSV | Tableaux |
| 1.8 | Colonnes réordonnables/masquables | Tableaux |
| 2.1 | Routines 1 clic | Raccourcis |
| 2.4 | Favoris | Raccourcis |
| 2.6 | Raccourcis clavier | Raccourcis |
| 2.7 | Barre commande Ctrl+K | Raccourcis |
| 3.3 | Push navigateur opt-in | Notifications |
| 3.5 | Alertes configurables | Notifications |
| 4.6 | Dashboard drag & drop | Dashboard |
| 5.2 | Bouton ? par page | Aide |
| 5.3 | Tutoriel guidé | Aide |
| 5.4 | Calculateurs intégrés | Aide |
| 6.2 | Taille police ajustable | Confort visuel |
| 6.4 | Densité d'affichage | Confort visuel |
| 6.5 | Mode daltonisme | Confort visuel |
| 7.4 | Planificateur rappels | Temps |
| 8.1 | Annuaire joueurs filtrable | Social |
| 8.2 | Statut en ligne | Social |
| 8.3 | Chat MP live | Social |
| 8.4 | Réputation transporteurs/ETA | Social |
| 9.2 | Swipe actions cartes | Mobile |

### Nice-to-have (Phase 4+)

| # | Feature | Section |
|---|---------|---------|
| 2.5 | Historique 10 actions + refaire | Raccourcis |
| 7.3 | Historique des saisons | Temps |
| 8.5 | Notification ami connecté | Social |
| 9.5 | Mode hors-ligne partiel | Mobile |

---

## Composables & stores récapitulatifs

| Composable / Store | Responsabilité | Section |
|--------------------|----------------|---------|
| `useDataTable()` | Tri, filtres, recherche, pagination, sélection, export, colonnes, persistance | §1 |
| `useKeyboardShortcuts()` | Raccourcis clavier contextuels | §2.6 |
| `useCommandPalette()` | Barre commande Ctrl+K | §2.7 |
| `useNotificationStore` (Pinia) | Notifications WebSocket, niveaux, centre, push | §3 |
| `useGameTime()` | Calendrier Cultivia, countdown tick, sync serveur | §7 |
| `useSocialStore` (Pinia) | Présence, chat, amis, réputation | §8 |
| `useTheme()` | Dark mode, densité, daltonisme, police | §6 |
| `useTutorial()` | Tutoriel guidé step-by-step | §5.3 |
| `useOffline()` | Détection hors-ligne, cache, sync | §9.5 |
| `useActionHistoryStore` (Pinia) | Historique 10 dernières actions | §2.5 |
| `useRoutineStore` (Pinia) | Routines personnalisables | §2.1 |
| `useFavoritesStore` (Pinia) | Favoris par catégorie | §2.4 |
| `useAutoFeed()` | Nourrissage automatique 15j | §2.2 |
| `useParcelWorkflow()` | Flux travail parcelle enchaîné | §2.3 |
| `usePullToRefresh()` | Pull-to-refresh mobile | §9.3 |
| `useSwipe()` | Swipe actions cartes mobile | §9.2 |
