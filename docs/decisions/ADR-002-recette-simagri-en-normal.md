# ADR-002 : Le mode Normal préserve la recette SimAgri

> Date : 2026-08-04
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Complète : ADR-001 (modes de jeu)

## Contexte

SimAgri fonctionne depuis 2005 avec une communauté fidèle. Ce n'est pas un hasard : le jeu a trouvé une formule qui marche. En introduisant un mode Expert réaliste, il y a un risque de contaminer le mode Normal avec de la complexité et des frictions qui casseraient cette formule.

L'ADR-001 définit Normal comme « accessible » et Expert comme « réaliste ». Ce n'est pas assez précis : **Normal n'est pas une version dégradée d'Expert. Normal EST le jeu SimAgri, amélioré.**

## Ce qui fait le succès de SimAgri (à préserver absolument)

### 1. La progression est constante et visible
Le joueur gagne de l'argent, achète, agrandit, collectionne. Il progresse à chaque session. **Aucun mur, aucune régression.**

### 2. Les PA créent le rythme
35 PA/jour = le joueur doit choisir. C'est la vraie contrainte, pas l'argent. Se connecter 10 minutes par jour suffit à progresser.

### 3. L'accumulation est gratifiante
Collectionner du matériel, des races, des bâtiments. Voir sa ferme grandir. **Le plaisir de posséder.**

### 4. Le social est le cœur
Coopératives entre joueurs, concessionnaires, marché, forum. Les autres joueurs sont une ressource, pas des concurrents hostiles.

### 5. La profondeur est accessible
119 sous-systèmes, mais chacun est simple à comprendre. La complexité vient du nombre, pas de la difficulté individuelle.

### 6. Pas de punition brutale
On ne perd pas sa ferme. Les erreurs coûtent du temps, pas la partie. Un joueur absent 2 semaines retrouve sa ferme.

### 7. Le temps long
Le jeu se joue sur des mois/années. Pas de pression, pas de FOMO. On avance à son rythme.

## Décision

**Le mode Normal reproduit la recette SimAgri. Les mécaniques réalistes qui créent de la friction sont réservées à Expert.**

### Règles de design pour le mode Normal

| Règle | Application |
|-------|-------------|
| **1. Pas de frein à la progression** | Les charges restent légères (10-12% max). Le joueur doit sentir qu'il s'enrichit. |
| **2. Pas de complexité obligatoire** | Aucun système ne demande d'apprentissage préalable pour être utilisé correctement. |
| **3. Pas de perte définitive** | Pas de faillite, pas de mort de troupeau évitable, pas d'échec de campagne total. |
| **4. Les nouveautés sont des bonus** | Les aides PAC, le fermage, l'ETA = des options qui aident, pas des contraintes à gérer. |
| **5. L'information est suffisante** | Le joueur n'a jamais besoin d'une doc externe pour comprendre quoi faire. |
| **6. Le social prime** | Toutes les interactions entre joueurs restent accessibles en Normal. |
| **7. L'accumulation reste le moteur** | Acheter, agrandir, collectionner = toujours possible et gratifiant. |

### Correction des paramètres du GDD économie

| Paramètre | Version initiale (rejetée) | Version corrigée |
|-----------|---------------------------|------------------|
| Charges sociales Normal | 20% du bénéfice | **12% du bénéfice** |
| Cotisation minimum Normal | 2 000 € | **1 000 €** |
| Aides PAC Normal | Versement annuel | **Inchangé** (bonus bienvenu) |
| Trésorerie Normal | Pas de blocage | **Inchangé** |
| Faillite Normal | — | **Impossible** (le pire = ne plus pouvoir investir) |

**Justification du 12%** : suffisant pour que le joueur perçoive une notion de charges (contrairement à SimAgri = 0%), assez léger pour ne pas freiner la progression. Un joueur qui dégage 40 000 € de bénéfice paie 4 800 € — visible mais pas punitif.

### Ce que Normal gagne par rapport à SimAgri

Le mode Normal n'est pas juste « SimAgri copié ». Il corrige les défauts sans ajouter de friction :

| Amélioration | Pourquoi ça ne casse pas la recette |
|-------------|-------------------------------------|
| Aides PAC | Argent en plus, aucune contrainte à gérer |
| Fermage | Option pour démarrer plus vite (moins de capital) |
| ETA / prestation | Option pour éviter d'acheter du matériel cher |
| Largeur = débit | Rend le choix de matériel plus intéressant (pas plus dur) |
| Poulet de chair | Nouvelle filière = plus de choix |
| Portée réaliste | Le porc devient plus rentable (14 porcelets !) |
| Saisonnalité prix légère | Incite à stocker sans obliger |
| Tableau de bord | Plus d'information = meilleures décisions |

**Chacune de ces améliorations ajoute du choix, pas de la contrainte.**

## Conséquences

- Le GDD-economie-base doit être révisé (charges 20% → 12%)
- Chaque futur GDD doit passer le test : « est-ce que ça freine la progression en Normal ? »
- Si une mécanique réaliste crée de la friction, elle va en Expert
- Le mode Normal doit être testé par un joueur SimAgri : il doit retrouver ses sensations
- Le mode Expert peut être exigeant, c'est son rôle

## Test de validation

Un joueur SimAgri qui essaie Agriva en mode Normal doit pouvoir dire :
> « C'est SimAgri, mais en mieux. »

Et pas :
> « C'est plus compliqué / plus dur / moins fun. »
