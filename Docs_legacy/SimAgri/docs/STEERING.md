# Steering — Mindset de développement SimAgri

> Ce fichier définit l'état d'esprit à appliquer pour TOUTE feature, TOUT code, TOUTE décision sur le projet.

## 1. Penser comme un agriculteur français joueur de SimAgri

- Quand je vois "ration bovin", je sais que c'est du foin + complément, pas un truc abstrait
- Les prix doivent sembler crédibles à quelqu'un qui connaît l'agriculture française (2024)
- Un poussin Cou Nu à 0.80€, une génisse Holstein à 180€, une tonne de blé à 220€ — ça doit sonner juste

## 2. SimAgri comme référence de game design

SimAgri a tourné 15+ ans avec des milliers de joueurs. Leurs choix sont éprouvés :
- La coopérative est le hub central d'achat (prix fixe +15%, stock illimité, distance à parcourir)
- Tout transport nécessite un attelage adapté (tracteur + remorque compatible)
- Les accessoires sont distincts des bâtiments (robot = accessoire de poulailler, salle de conditionnement = bâtiment de ferme)
- Chaque production a une chaîne complète : infrastructure → matière première → transformation → stockage → vente
- Le joueur doit investir avant de gagner (ROI de quelques semaines à quelques mois)

## 3. Chaque feature = une chaîne économique complète

Avant de coder, tracer la chaîne :
```
INVESTIR → PRODUIRE → STOCKER → VENDRE
```
Si un maillon manque, le joueur est bloqué. Chaque maillon manquant = un message clair + un lien vers la page pour le résoudre.

## 4. Le transport est un coût réel, pas un détail

- Distance coopérative : 20 km fixe
- Attelage requis : tracteur + remorque adaptée au produit (benne/plateau/bétaillère/citerne)
- Compatibilité CV : `tracteur.horsepower >= remorque.required_hp`
- Trajets multiples : `trips = ⌈quantité / capacité⌉`
- Coût par trajet : 1h de travail + 0.5% usure (tracteur ET remorque)
- Le joueur choisit son véhicule dans la modale d'achat

## 5. L'équipement conditionne tout

Pas de tracteur = pas de transport = pas d'achat = pas de production.
Le matériel est le goulot d'étranglement. Le joueur investit intelligemment.

## 6. La difficulté module l'économie, pas les mécaniques

| Multiplicateur | Facile | Normal | Difficile |
|---|---|---|---|
| hours_multiplier | 0.7 | 1.0 | 1.3 |
| revenue_multiplier | 1.5 | 1.0 | 0.8 |
| penalty_multiplier | 0.7 | 1.0 | 1.3 |

Les règles sont les mêmes pour tous. Seuls les chiffres changent.

## 7. Le temps est la ressource la plus précieuse

8h de travail par jour (ratio 7:1). Chaque action coûte du temps. Le joueur priorise.

## 8. Le dashboard = le cockpit du joueur

Chaque page "principale" (Élevage, Bâtiments, Parcelles, Matériel) doit être un DASHBOARD, pas une liste brute.

Un dashboard répond à 4 questions dans cet ordre :
1. **Qu'est-ce qui va mal ?** (alertes critiques — rouge)
2. **Qu'est-ce qui va bien ?** (opportunités — vert)
3. **Qu'est-ce que je dois gérer ?** (logistique — orange)
4. **Quel est l'état de mes ressources ?** (monitoring — bleu)

Référence : SimAgri "Mes animaux" a 13 panneaux d'alerte + estimation eau + raccourcis nourrir + infos saison.
→ Voir `docs/sdd/04-elevage-dashboard.md` pour l'inventaire complet.

Règle : la liste détaillée (DataTable) va sur une sous-route `/xxx/list`, jamais sur la page principale.

## 9. Checklist avant de coder une feature

- [ ] Un joueur de SimAgri reconnaîtrait-il cette feature ?
- [ ] Un vrai agriculteur français trouverait-il les prix/mécaniques crédibles ?
- [ ] Le parcours est-il complet de bout en bout (INVESTIR → PRODUIRE → STOCKER → VENDRE) ?
- [ ] Où le joueur va-t-il chercher cette feature dans l'interface ?
- [ ] Que se passe-t-il si un prérequis manque ? Le message est-il clair ?
- [ ] Est-ce rentable ? En combien de temps (ROI) ?
- [ ] Le transport est-il pris en compte ?
- [ ] La difficulté serveur est-elle appliquée ?
- [ ] Le dashboard montre-t-il les alertes AVANT les données ?
- [ ] Les actions sont-elles accessibles directement depuis le dashboard (pas 3 clics) ?
- [ ] La météo impacte-t-elle cette feature ? (gel, canicule, pluie forte, vent)

## 10. La météo est un facteur de gameplay, pas un décor

La météo n'est pas cosmétique. Elle conditionne les actions et les résultats :
- **Gel** → dégâts cultures, surconsommation nourriture animaux, sol gelé (pas de labour)
- **Canicule** (>35°C) → stress hydrique cultures, stress thermique animaux, baisse production lait
- **Pluie forte** (>20mm) → empêche semis/récolte, risque verse céréales
- **Orage + grêle** → dégâts directs sur cultures matures
- **Vent fort** → impossible de traiter (pulvérisation), animaux au pré rentrent

Le joueur consulte la météo AVANT de planifier ses actions de la semaine.
La page `/meteo` et le widget dashboard 3 jours sont ses outils de décision.

### Zones climatiques réalistes
5 zones françaises (océanique, océanique-dégradé, semi-continental, continental, méditerranéen) avec des profils de température et de précipitations réalistes par saison. Chaque région est rattachée à une zone.

### Prévisions 7 jours
- J+0 à J+2 : fiables (le joueur peut planifier)
- J+3 à J+6 : incertaines (peuvent changer, affichées en opacité réduite)

Référence : `docs/sdd/01b-meteo.md`

## 9. Règles de code

- Écrire le minimum de code nécessaire, pas de verbose
- Toujours vérifier côté serveur (ne jamais faire confiance au front)
- Après chaque mutation : `store.loadAll()` + `store.loadPlayer()`
- Messages d'erreur explicites avec guidance (lien vers la page qui résout le problème)
- 1 décimale pour m², poids (kg), jauges (%)
- Prix : `price × revenue_multiplier` pour toute vente
- Heures : `consumeHours()` applique automatiquement `hours_multiplier`

## 11. Décisions de design validées (alimentation)

Ces décisions ont été prises le 2026-04-03 et sont définitives pour le MVP :

| # | Décision | Choix | Raison |
|---|----------|-------|--------|
| 1 | Silo | **Mono-type** (1 silo = 1 aliment) | Réaliste, force l'investissement en infrastructure |
| 2 | Config ration | **Par bâtiment** | Bon compromis entre simplicité et flexibilité |
| 3 | Transport | **Obligatoire** (tracteur + benne/plateau) | Déjà implémenté, cœur du gameplay SimAgri |
| 4 | Nourrissage | **Manuel + robot** | Manuel = 1h + tracteur + désileuse. Robot = automatique |
| 5 | Base partielle | **Proportionnelle** | Si un ingrédient manque, productivité réduite (pas 0%) |
| 6 | Productivité | **Stockée sur bâtiment** | Accessible partout (dashboard, API, worker) |

### Formule de productivité
```
productivité = (75% × Σ poids_ingrédients_fournis) + bonus_complément_1 + bonus_complément_2 + bonus_complément_3
max = 120%
```

Philosophie : **reward, pas punition**. Sans compléments = 75% (normal). Avec tous = 120% (surperformance).
