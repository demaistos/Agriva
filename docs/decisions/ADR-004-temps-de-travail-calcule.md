# ADR-004 : Le temps de travail est calculé, pas attribué

> Date : 2026-08-04
> Statut : Accepté
> Auteur : humain + agent:game-designer
> Remplace : le système de PA (Points d'Action) hérité de SimAgri
> Impacte : `GDD-core-temporalite` §4, `GDD-materiel` §2, tous les GDD mentionnant un coût en temps

## Contexte

Le `GDD-core-temporalite` avait repris le système de **PA (Points d'Action)** de SimAgri en le renommant « heures de travail », avec des coûts forfaitaires par action :

```
Labourer 1 ha    : 0,5 h
Semer 1 ha       : 0,3 h
Récolter 1 ha    : 0,4 h
Traire 30 vaches : 1,0 h
```

**Deux problèmes.**

### Problème 1 — Contradiction avec le GDD matériel

Le `GDD-materiel` établit que le temps de travail dérive du matériel :

```
débit (ha/h) = largeur (m) × vitesse (km/h) × 0,1 × rendement_machine

Charrue 5 corps (1,75 m) : 0,98 ha/h → 1 ha = 1,02 h
Charrue 8 corps (2,80 m) : 1,84 ha/h → 1 ha = 0,54 h
```

Un forfait de 0,5 h/ha contredit directement ce calcul. Les deux systèmes ne peuvent pas coexister.

### Problème 2 — Le forfait reproduit le défaut de SimAgri

Dans SimAgri, une action coûte un nombre de PA **fixé arbitrairement**. Conséquence : acheter du matériel plus large ne fait pas gagner de temps (seule la « maniabilité » donne un bonus marginal de ±10%). L'investissement matériel n'a donc **pas de retour en productivité**.

C'est le point faible n°1 identifié dans la recherche (`reality-vs-simagri-materiel.md`, note 6,5/10). Reprendre le forfait, c'est reprendre le défaut — et rendre la filiation avec SimAgri visible sans en tirer de bénéfice.

## Options

| Option | Description | Verdict |
|--------|-------------|---------|
| A | Garder les PA forfaitaires (SimAgri) | ❌ Contredit le GDD matériel, reproduit le défaut |
| B | Aucune limite de temps | ❌ Le joueur le plus disponible gagne — inacceptable en multijoueur |
| C | Cooldowns temps réel par action (type Farmville) | ❌ Force les connexions fréquentes, punit le joueur occasionnel |
| D | Fenêtres météo/saison comme seule limite | ❌ Rien à faire hors pointe, impossible en pointe |
| E | **Temps de travail calculé + capacité de main d'œuvre** | ✅ **Retenue** |

## Décision

**Le temps d'une action n'est jamais attribué. Il est calculé à partir de la réalité physique de la tâche.**

### 1. Toute durée est dérivée

```
Travaux de parcelle (labour, semis, récolte, traitement...) :
  durée = surface / débit
  débit = largeur × vitesse × 0,1 × rendement_machine × f_conditions
  → cf. GDD-materiel §2

Travaux d'élevage (traite, alimentation, soins...) :
  durée = f(effectif, équipement, degré d'automatisation)
  Exemple traite : (nb_vaches / cadence_salle) + temps_préparation
  → cf. GDD-bovin-laitier §4.2

Transport :
  durée = (distance / vitesse) × nb_trajets
  nb_trajets = ⌈quantité / capacité_remorque⌉

Administratif (vendre, acheter, consulter) :
  durée = forfait court (5 à 15 min) — seul cas de forfait admis
```

**Aucune table de « coût en PA par action ».** La durée émerge du matériel, de l'effectif et des conditions.

### 2. La contrainte est la capacité de main d'œuvre

Ce qui limite le joueur n'est pas un budget de points, c'est **le nombre d'heures de travail disponibles sur l'exploitation** :

```
capacité_jour = heures_exploitant + Σ heures_salariés

heures_exploitant : 12 h/jour (fixe toute l'année)
heures_salarié    : 8 h/jour (fixe toute l'année)
coût_salarié      : 2 200 €/mois charges incluses
```

### 3. Capacité fixe — pas de variation saisonnière

La capacité est **constante**. C'est la **demande de travail** qui varie avec les saisons (semis au printemps, moisson en été), pas le budget horaire du joueur.

| | Heures/jour | Coût |
|--|:-----------:|------|
| **Exploitant** | 12 h | — |
| **Ouvrier** | 8 h | 2 200 €/mois |

**Pourquoi fixe** : la variation saisonnière ajoutait de la complexité sans gain de gameplay. Le joueur doit déjà gérer la saisonnalité des travaux (fenêtres de semis, de récolte). La tension en pointe émerge naturellement du volume de travail à accomplir, pas d'un budget qui change.

**Conséquence de gameplay** : en moisson, le joueur dispose de 12 h/jour mais a besoin de bien plus (150 ha × 1 h/ha = 150 h sur une fenêtre de 15 jours = 10 h/jour rien que pour moissonner). Il doit arbitrer, déléguer à une ETA, ou investir dans du matériel plus large.

### 4. L'investissement se convertit en temps

C'est le cœur de la boucle économique, et ce que SimAgri ne fait pas :

```
Exemple — semer 145 ha de céréales

Semoir 3 m : 2,4 ha/h → 60,4 h de travail
Semoir 4 m : 3,2 ha/h → 45,3 h  (-15 h)
Semoir 6 m : 4,8 ha/h → 30,2 h  (-30 h)

Le joueur peut donc CHOISIR entre :
  • investir 38 000 € dans un semoir 6 m
  • embaucher (1 salarié = 8 h/jour pour 2 200 €/mois)
  • faire appel à une ETA (75 €/ha, soit 10 875 € pour 145 ha)
  • découper l'action sur 2 ticks (semer 80 ha ce tick, 65 ha le suivant)

Quatre stratégies valides, chacune avec son coût et son risque.
```

### 5. Modèle d'exécution — instantané au clic

Le budget d'heures fonctionne comme les PA de SimAgri :

```
Le joueur clique une action → le budget est débité → l'action est résolue.
Tout est instantané. Pas de timer, pas de file d'attente, pas de chantier "en cours".

Budget par tick = 12 h × 7 jours = 84 h (exploitant seul)
               + 8 h × 7 jours = 56 h par ouvrier supplémentaire

Les heures sont rechargées à chaque tick (1 fois/jour réel, 06:00 UTC).
Pas de report des heures non utilisées.
```

**Règle fondamentale** : si le budget restant est insuffisant pour une action, le joueur ne peut pas la lancer. Il doit :
- Attendre le prochain tick (budget rechargé)
- Investir en matériel plus large (pour réduire le coût de l'action)
- Embaucher un ouvrier (pour augmenter le budget)
- Déléguer à une ETA (0 heure consommée)
- Découper manuellement (ex : labourer 40 ha maintenant, 40 ha au tick suivant)

**Il n'y a PAS de chantier pluri-journalier, PAS de file d'attente, PAS de planificateur.**

### 6. Ce que le joueur voit

Le vocabulaire est celui du métier, pas celui du jeu :

| ❌ Interdit | ✅ À utiliser |
|------------|--------------|
| « Points d'Action », « PA » | « Temps de travail », « heures » |
| « Il vous reste 18 PA » | « Il vous reste 47 h sur ce tick » |
| « Cette action coûte 3 PA » | « Cette action coûte 9 h 24 » |
| « Régénération des PA » | « Nouveau tick — budget rechargé » |
| « Chantier en cours — 45% » | (n'existe pas : l'action est faite ou pas faite) |

### 7. Ce qui différencie Agriva de SimAgri sur ce point

| Aspect | SimAgri | Agriva |
|--------|---------|--------|
| Unité | PA (points abstraits) | Heures de travail (même mécanique, meilleur habillage) |
| Coût d'une action | Forfait par table | Calculé (matériel × surface × conditions) |
| Effet d'un meilleur matériel | Bonus marginal (maniabilité ±10%) | Réduction directe du coût en heures (jusqu'à -50%) |
| Capacité quotidienne | 35 PA fixes toute l'année | 12 h fixes toute l'année (= 84 h/tick) |
| Salariés | +25 PA au pool | +8 h/jour (= +56 h/tick), coût réel 2 200 €/mois |
| Exécution | Instantanée au clic | Instantanée au clic (identique) |
| Chantier > budget | Impossible (il attend demain) | Impossible (il attend le tick suivant, ou découpe) |
| Arbitrage en pointe | Choisir quelles actions faire | Choisir entre investir / embaucher / déléguer / découper |

**La différence est structurelle, pas cosmétique** : dans Agriva, le temps est une conséquence des choix d'équipement et d'organisation. C'est la variable qui relie le matériel, les salariés, l'ETA, la CUMA, l'automatisation (robot de traite) et les fenêtres météo.

## Conséquences

### Documents à réviser
- [ ] `GDD-core-temporalite` §4 — réécrire entièrement (supprimer la table de coûts PA)
- [ ] `GDD-core-temporalite` §4.6 et §4.7 — remplacer les mockups « barre de PA »
- [ ] Vérifier tous les GDD pour les mentions de « PA » ou de coûts forfaitaires en temps
- [ ] `GDD-ui-ux` — le composant d'affichage du temps disponible
- [ ] `GDD-materiel` — devient la source de vérité du calcul de durée

### Impact sur l'architecture
Le calcul de durée devient un **service central** utilisé par toutes les actions :

```
WorkDurationService.compute(action, context) → durée en heures

Toute action passe par ce service. Aucune durée codée en dur.
```

### Impact sur l'équilibrage
Les scénarios chiffrés mentionnant un temps de travail doivent être revérifiés :
- `GDD-materiel` §9.2 (620 h, 480 h, 380 h selon la stratégie) — cohérent, dérivé
- `GDD-bovin-laitier` §9.2 (2 100 h/an dont 912 h de traite) — cohérent, dérivé
- `GDD-core-temporalite` §8 (scénarios PA) — **à recalculer**

### Ce qu'il ne faut pas faire
- ❌ Réintroduire un forfait « pour simplifier »
- ❌ Utiliser le mot « PA » dans l'interface ou le code
- ❌ Plafonner arbitrairement le temps sans justification métier
