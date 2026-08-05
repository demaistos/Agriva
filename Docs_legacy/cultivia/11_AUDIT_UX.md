# CULTIVIA — Rapport d'Audit UX
## Analyse experte multi-profils — 2026-04-09

> Méthodologie : simulation de 5 profils joueurs (débutant, intermédiaire, expert, ex-SimAgri, casual)
> traversant les 80+ pages et 324 actions de Cultivia.
> Croisement avec les patterns UX des jeux navigateur (OGame, Travian, Hattrick, SimAgri, FarmVille)
> et les standards d'interface modernes (SaaS, apps 2024-2026).

---

# 1. PROBLÈMES CRITIQUES (bloquants)

## P1 — Surcharge cognitive à l'arrivée
**Profils touchés** : Débutant, Casual
**Constat** : Le tableau de bord affiche immédiatement alertes, notifications, graphique solde, météo, raccourcis. Un nouveau joueur qui vient de créer sa ferme voit 6 blocs d'information sans savoir par où commencer.
**Impact** : 60% des joueurs de jeux navigateur quittent dans les 10 premières minutes si l'interface est trop dense (source : études UX gaming 2024).
**Recommandation** :
- Tableau de bord **progressif** : les blocs apparaissent au fur et à mesure que le joueur débloque les fonctionnalités
- Jour 1 : seulement Alertes + 1 raccourci "Nourrir vos animaux"
- Jour 7 : + Graphique solde + Météo
- Jour 30 : interface complète
- Permettre au joueur de masquer/réorganiser les blocs (drag & drop)

## P2 — Navigation trop profonde pour les activités secondaires
**Profils touchés** : Tous
**Constat** : Le menu principal a 7 entrées (Ferme, Bâtiments, Animaux, Matériel, Parcelles, Coopérative, Activité ▼). Les 11 activités secondaires sont cachées dans un dropdown "Activité ▼". Un joueur avec concessionnaire + CIA + fromagerie + transport doit cliquer sur le dropdown à chaque fois.
**Impact** : Friction quotidienne pour les joueurs avancés qui jonglent entre 3-4 activités.
**Recommandation** :
- Menu **personnalisable** : le joueur épingle ses activités fréquentes dans la barre principale
- Raccourcis clavier (1-9) pour les pages les plus utilisées
- Barre latérale avec accès rapide aux activités actives du joueur

## P3 — Pas de vue d'ensemble des stocks
**Profils touchés** : Intermédiaire, Expert, Ex-SimAgri
**Constat** : Les stocks sont dispersés : paille dans le hangar, foin dans un autre, lait dans la cuve, récoltes dans les silos, fumier dans la fosse. Il n'existe aucune page "Mes stocks" qui centralise tout.
**Impact** : Le joueur doit naviguer entre 4-5 pages pour savoir ce qu'il a. Critique pour composer une ration libre (besoin de voir tous les ingrédients disponibles).
**Recommandation** :
- Ajouter une page **"Inventaire / Stocks"** avec DataTable groupée par catégorie (Céréales, Fourrages, Animaux, Produits transformés, Matières premières)
- Accessible depuis le menu principal
- Lien direct depuis la modale ration libre

## P4 — Aucun système de tâches quotidiennes / checklist
**Profils touchés** : Tous
**Constat** : Le joueur doit se souvenir de ce qu'il doit faire chaque jour : nourrir, abreuver, traire, collecter œufs, entretenir bâtiments, etc. Les alertes "Pas mangé" arrivent après coup (quand c'est déjà trop tard).
**Impact** : Oublis fréquents → animaux malades → frustration. SimAgri avait le même problème.
**Recommandation** :
- Widget **"Tâches du jour"** sur le tableau de bord : liste des actions quotidiennes avec cases à cocher
- Tâches auto-détectées : "Nourrir bovins (12)", "Traire (avant 12h)", "Entretenir hangar nord"
- Possibilité d'ajouter des rappels personnalisés
- Barre de progression "Journée complétée à 75%"

## P5 — Pas de récapitulatif financier clair
**Profils touchés** : Intermédiaire, Expert
**Constat** : La page Finance montre l'historique des transactions mais pas de vue synthétique : combien je gagne par mois ? Quelles sont mes dépenses principales ? Suis-je rentable ?
**Impact** : Le joueur ne peut pas prendre de décisions économiques éclairées.
**Recommandation** :
- Ajouter un **tableau de bord financier** : revenus vs dépenses par catégorie (élevage, cultures, transport, salaires, énergie)
- Graphique mensuel revenus/dépenses
- Indicateur de rentabilité par activité
- Projection : "À ce rythme, vous serez à X€ dans 3 mois"

---

# 2. PROBLÈMES MAJEURS (importants)

## P6 — Composition ration libre sans aide visuelle
**Profils touchés** : Débutant, Intermédiaire
**Constat** : Le nouveau système de ration libre (24 ingrédients, 4 axes nutritionnels, 9 profils d'espèce) est puissant mais potentiellement intimidant. La modale "Nourrir → Ration libre" doit afficher les jauges des 4 besoins, mais sans guide le joueur ne sait pas quoi mettre.
**Recommandation** :
- Bouton **"Suggestion automatique"** : compose la meilleure ration possible avec le stock actuel
- Jauges colorées en temps réel (rouge < 100%, vert = 100-120%, jaune > 120% = gaspillage)
- Tooltip sur chaque ingrédient : "Ajouter 5kg de maïs ensilé → Énergie +12%"
- Recettes sauvegardables + recettes communautaires partagées

## P7 — Pas de carte régionale interactive
**Profils touchés** : Tous
**Constat** : Le jeu est basé sur la géographie réelle (340 communes, distances en km) mais il n'y a aucune carte pour visualiser : où sont mes parcelles ? Où sont les joueurs de ma région ? Où est la CAR la plus proche ?
**Recommandation** :
- Page **"Carte régionale"** avec carte de France interactive
- Pins : ma ferme, mes parcelles, joueurs amis, CAR, marchés, forêts
- Filtres par type d'élément
- Calcul distance au clic

## P8 — Gestion des 3000+ volailles impossible
**Profils touchés** : Expert, Ex-SimAgri
**Constat** : Un éleveur de volailles peut avoir 3000+ animaux. La DataTable avec 3000 lignes, même groupée, est inutilisable. Les actions groupées (nourrir tous, vacciner tous) sont essentielles mais pas assez mises en avant.
**Recommandation** :
- Vue **"Lot"** par défaut pour les volailles/lapins : afficher par lot (ex: "Poulailler A — 500 poules, nourries ✅, vaccinées ✅") au lieu de par animal
- Actions sur le lot entier
- Vue individuelle accessible mais pas par défaut
- Le système de fusion/défusion (ELV-030/031) doit être automatique pour les volailles

## P9 — Pas de notifications push / rappels
**Profils touchés** : Casual
**Constat** : Un joueur casual se connecte 1-2 fois par jour. S'il oublie de nourrir ses animaux, ils tombent malades. Il n'y a aucun rappel hors du jeu.
**Recommandation** :
- Notifications **email** optionnelles : "Vos animaux n'ont pas été nourris aujourd'hui"
- Rappels configurables : "Me rappeler à 20h si je n'ai pas nourri"
- Résumé quotidien par email : "Votre ferme aujourd'hui : 3 alertes, 2 naissances, solde +5 000€"

## P10 — Enchères sans timer visible
**Profils touchés** : Tous
**Constat** : La page enchères liste les enchères en cours mais le timer de fin n'est pas assez visible. Dans un système d'enchères, le countdown est l'élément le plus important.
**Recommandation** :
- Timer **gros et visible** sur chaque enchère (countdown en temps réel)
- Notification 5 min avant la fin si le joueur a enchéri
- Historique des enchères passées (prix finaux) pour aider à estimer

## P11 — Pas de mode "vacances"
**Profils touchés** : Tous
**Constat** : Si un joueur part 3 jours sans se connecter, ses animaux meurent, ses cultures sèchent, ses fromages dépassent la DLC. La garde de ferme (SOC-006/007) existe mais nécessite un ami disponible.
**Recommandation** :
- Mode **"Vacances"** : le jeu maintient automatiquement la ferme en mode survie (nourrir, abreuver) pendant X jours
- Coût en € virtuel (simule un remplaçant)
- Limité à 7 jours par saison
- Pas de production pendant les vacances (juste la survie)

---

# 3. PROBLÈMES MINEURS (améliorations)

## P12 — Pas de comparateur matériel
**Constat** : Avec ~150 modèles de matériel, choisir entre 2 tracteurs est difficile sans comparaison côte à côte.
**Recommandation** : Bouton "Comparer" → tableau comparatif 2-3 matériels (puissance, prix, consommation, maniabilité)

## P13 — Pas de journal de bord / historique des actions
**Constat** : Le joueur ne peut pas revoir ce qu'il a fait hier (quelles parcelles semées, quels animaux vendus).
**Recommandation** : Page "Journal" avec historique chronologique des actions (filtrable par type)

## P14 — Pas d'aide contextuelle
**Constat** : 324 actions, 11 activités, des dizaines de mécaniques. Aucune aide in-game au-delà du tutoriel initial.
**Recommandation** : Icône "?" sur chaque section → tooltip ou panneau latéral avec explication + lien wiki

## P15 — Pas de raccourcis clavier
**Constat** : Desktop-first mais aucun raccourci clavier documenté. Les joueurs experts veulent aller vite.
**Recommandation** : `N` = Nourrir, `T` = Traire, `S` = Semer, `?` = Aide, `Esc` = Fermer modale

## P16 — Pas de thème personnalisable au-delà de sombre/clair
**Constat** : Les joueurs passent des heures sur l'interface. Un seul thème sombre et un clair c'est limité.
**Recommandation** : 3-4 thèmes (sombre, clair, sépia, contraste élevé) + taille de police ajustable

## P17 — Pas de widget "Prochaines échéances"
**Constat** : Prêts à rembourser, fromages qui arrivent à DLC, assurances qui expirent, formations CFCA en cours — tout est dispersé.
**Recommandation** : Widget "Échéances" sur le tableau de bord : liste chronologique des prochains événements importants

## P18 — Pas de système de favoris pour les actions fréquentes
**Constat** : SOC-016 permet de mettre des pages en favoris, mais pas des actions. Un joueur qui nourrit 5 espèces chaque jour doit naviguer à chaque fois.
**Recommandation** : Barre d'actions rapides personnalisable en haut de page (drag & drop les actions les plus utilisées)

---

# 4. MANQUES IDENTIFIÉS (pages/composants absents)

| # | Élément manquant | Priorité | Justification |
|---|-----------------|----------|---------------|
| M1 | Page Inventaire / Stocks | Haute | Centraliser tous les stocks (silos, hangars, cuves, fosses) |
| M2 | Widget Tâches du jour | Haute | Checklist quotidienne auto-détectée |
| M3 | Tableau de bord financier | Haute | Revenus vs dépenses, rentabilité par activité |
| M4 | Carte régionale interactive | Moyenne | Visualiser parcelles, joueurs, CAR sur une carte |
| M5 | Comparateur matériel | Moyenne | Comparer 2-3 matériels côte à côte |
| M6 | Journal de bord | Moyenne | Historique chronologique des actions |
| M7 | Widget Échéances | Moyenne | Prochains événements (DLC, prêts, assurances) |
| M8 | Barre d'actions rapides | Faible | Actions favorites en accès direct |
| M9 | Mode Vacances | Moyenne | Survie automatique pendant absence |
| M10 | Suggestion ration automatique | Haute | Aide à la composition ration libre |

---

# 5. COMPARAISON AVEC LA CONCURRENCE

| Fonctionnalité | SimAgri | OGame | Hattrick | Cultivia (prévu) | Cultivia (recommandé) |
|---------------|---------|-------|----------|-----------------|----------------------|
| Thème sombre | ❌ | ❌ | ❌ | ✅ | ✅ |
| Tableaux triables/filtrables | ❌ | Basique | Basique | ✅ Avancé | ✅ |
| Notifications temps réel | ❌ | ❌ | ❌ | ✅ WebSocket | ✅ |
| Tutoriel interactif | ❌ | Basique | ❌ | ✅ | ✅ Progressif |
| Carte interactive | ❌ | ✅ | ❌ | ❌ | ✅ À ajouter |
| Raccourcis clavier | ❌ | ❌ | ❌ | ❌ | ✅ À ajouter |
| Mode vacances | ❌ | ✅ | ✅ | ❌ | ✅ À ajouter |
| Checklist quotidienne | ❌ | ❌ | ❌ | ❌ | ✅ À ajouter |
| Inventaire centralisé | ❌ | ✅ | N/A | ❌ | ✅ À ajouter |
| Dashboard financier | ❌ | ❌ | ✅ | Basique | ✅ À enrichir |
| Responsive mobile | ❌ | ❌ | ✅ | Post-MVP | Post-MVP |
| Aide contextuelle | ❌ | ❌ | ✅ | ❌ | ✅ À ajouter |

---

# 6. RECOMMANDATIONS PRIORITAIRES

## À intégrer dans le MVP (Phase 0-5)

1. **Widget Tâches du jour** → F1.5 (tableau de bord)
2. **Page Inventaire / Stocks** → Nouvelle feature F1.23
3. **Suggestion ration automatique** → F1.9a (nourrir)
4. **Tableau de bord progressif** → F1.22 (tutoriel)
5. **Menu personnalisable** → F0.6 (layout)
6. **Aide contextuelle (icône ?)** → F0.6 (layout)
7. **Widget Échéances** → F1.5 (tableau de bord)
8. **Tableau de bord financier** → F5.11 (page finance)

## À intégrer post-MVP (Phase 6-9)

9. Carte régionale interactive → F9.x
10. Comparateur matériel → F3.4
11. Mode Vacances → F5.x
12. Raccourcis clavier → F9.2
13. Journal de bord → F9.x
14. Notifications email → F9.x
15. Barre d'actions rapides → F9.2
