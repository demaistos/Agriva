# Agriva — Action Economy V1 — Spec détaillée
> Date : 2026-05-07
> Statut : **Figé V1**
> Références : gdd_action_economy.md · gdd_farming_workflow_semer.md · gdd_economy_planification_ressources.md · agriva_decisions_log_compact.md · 2026-05-07-farming-systems-v1.md

---

## Sommaire

1. [Ressources d'action](#1-ressources-daction)
2. [Capacité d'exécution](#2-capacité-dexécution)
3. [File d'ordres de travail](#3-file-dordres-de-travail)
4. [Décisions vs opérations](#4-décisions-vs-opérations)
5. [Scalabilité](#5-scalabilité)
6. [Réservation prévisionnelle](#6-réservation-prévisionnelle)
7. [Feedback joueur](#7-feedback-joueur)

---

## Principes fondateurs

- **Pas de jauge d'énergie abstraite.** Le joueur n'est jamais bloqué pour réfléchir, seulement pour exécuter.
- **Les décisions sont immédiates, les opérations prennent du temps.**
- **Une ressource n'existe que si elle crée un arbitrage clair** : faire maintenant / faire plus tard / déléguer / investir / renoncer.
- **Un clic peut lancer une séquence de travail**, pas seulement une micro-action.
- **Boucle principale** : Observer → Évaluer → Planifier → Réserver → Exécuter → Vendre/Acheter → Investir → Progresser.

---

## 1. Ressources d'action

### Variables d'état

| Ressource | Variable | Type | Reset |
|---|---|---|---|
| Argent | `tresorerie` | float (€) | Persistant |
| Temps opérationnel | `heures_travail_disponibles_j` | float (h) | Quotidien |
| Main-d'œuvre | `operateurs_disponibles_j` | int | Quotidien |
| Matériel | `materiel[id].statut` | enum `libre/occupé/en_panne` | Par chantier |
| Intrants | `stock_intrant[type]` | float (unité métier) | Persistant (consommé) |
| Capacité logistique | `capacite_logistique_j` | float (t) | Quotidien |
| Météo / fenêtre | `fenetre_travail_j` | float [0–1] | Quotidien (généré) |

### Règles

**Argent (`tresorerie`)**
- Monnaie universelle : achats, salaires, investissements, charges, réparations.
- Toute opération qui consomme des intrants ou mobilise un prestataire débite la trésorerie.
- La trésorerie ne se renouvelle pas ; elle est alimentée par les ventes et les emprunts.
- Une trésorerie négative bloque les achats et les commandes de services ; elle ne bloque pas les travaux déjà en cours avec ressources réservées.

**Temps opérationnel (`heures_travail_disponibles_j`)**
- Ressource pivot : fait le lien entre météo, main-d'œuvre, matériel, parcelles et saison.
- Se renouvelle chaque tick quotidien selon la formule de capacité (§2).
- Consommée à la réservation d'un ordre de travail (réservation prévisionnelle, §6).
- Les heures non utilisées en fin de journée sont perdues (pas de report).

**Main-d'œuvre (`operateurs_disponibles_j`)**
- Nombre d'opérateurs humains disponibles dans la journée.
- Chaque chantier requiert un nombre minimum d'opérateurs (1 par machine active en règle générale).
- Se renouvelle chaque jour ; les opérateurs affectés à un chantier en cours ne sont pas disponibles pour un autre.
- Embaucher un salarié permanent augmente le pool quotidien de façon permanente (coût fixe journalier).

**Matériel (`materiel[id].statut`)**
- Chaque équipement a un statut : `libre`, `occupé` (affecté à un chantier actif), `en_panne`.
- Un équipement `occupé` ne peut pas être affecté à un second chantier simultané.
- La panne est un événement aléatoire (probabilité fonction de l'âge et de l'entretien) ; elle bloque l'équipement jusqu'à réparation.
- Acheter du matériel augmente la capacité machine de façon permanente.
- Types de matériel V1 : tracteur, semoir, moissonneuse-batteuse, épandeur, pulvérisateur, remorque, micro-tracteur (maraîchage).

**Intrants (`stock_intrant[type]`)**
- Ressources physiques consommées à l'exécution du chantier (pas à la réservation).
- Types V1 : semences (par culture), engrais minéral, fumier/compost, herbicide, fongicide, insecticide, carburant, aliment bétail, litière, produits vétérinaires.
- Stock persistant ; se reconstitue par achat (marché joueur ou coop bot).
- Un stock insuffisant au moment de l'exécution bloque le chantier (état `bloqué`, §3).

**Capacité logistique (`capacite_logistique_j`)**
- Volume transportable par jour avec les moyens propres du joueur (remorques, camions).
- Consommée par les transferts vers silo, les livraisons vers acheteurs.
- Se renouvelle chaque jour.
- Peut être complétée par le transport coop bot (service externe, coût €).

**Météo / fenêtre de travail (`fenetre_travail_j`)**
- Coefficient [0–1] calculé chaque jour par le moteur météo (§5 farming-systems-v1).
- `fenetre_travail_j = 1.0` : conditions optimales (toutes tâches autorisées).
- `fenetre_travail_j = 0.5` : conditions dégradées (tâches sensibles bloquées ou pénalisées).
- `fenetre_travail_j = 0.0` : conditions bloquantes (aucun chantier de plein champ possible).
- Règles de blocage par condition météo :
  - Pluie > 5 mm/j → récolte bloquée.
  - Sol saturé → labour bloqué.
  - Gel prévu dans 48h → semis bloqué.
  - Vent > 40 km/h → pulvérisation bloquée.
- La fenêtre météo est une ressource contextuelle : elle ne se consomme pas, elle conditionne.

### Paramètres (ranges indicatifs)

| Ressource | Petite exploitation | Exploitation moyenne | Grande exploitation |
|---|---|---|---|
| Heures travail/j | 8–12 h | 16–32 h | 40–80 h |
| Opérateurs/j | 1–2 | 2–5 | 5–15 |
| Tracteurs | 1 | 2–3 | 4–8 |
| Capacité logistique/j | 20–40 t | 60–120 t | 150–400 t |

### Interactions avec autres systèmes

- **Sols** : les intrants (engrais, fumier) modifient fertilité/NPK/MO.
- **Météo** : `fenetre_travail_j` est produit par le moteur météo ; les événements extrêmes peuvent annuler des réservations.
- **Marché** : la trésorerie est alimentée par les ventes ; les achats d'intrants la débitent.
- **Services ETA bot** : libère heures travail + matériel joueur en échange de trésorerie.
- **Foncier** : la surface totale des parcelles détermine le volume de travail à réaliser.

---

## 2. Capacité d'exécution

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `capacite_travail_j` | float (h) | Heures de travail disponibles pour la journée |
| `capacite_machine_j[id]` | float (h) | Heures disponibles par équipement pour la journée |
| `capacite_logistique_j` | float (t) | Tonnes transportables dans la journée |
| `heures_reservees_j` | float (h) | Heures déjà allouées à des ordres planifiés/confirmés |
| `heures_restantes_j` | float (h) | `capacite_travail_j - heures_reservees_j` |

### Règles

**Calcul de la capacité de travail quotidienne**

```
capacite_travail_j = (nb_operateurs_permanents + nb_operateurs_saisonniers_actifs)
                   × heures_par_operateur_j
                   × fenetre_travail_j
                   × facteur_saison
```

- `heures_par_operateur_j` : 8 h en standard ; réduit à 6 h en conditions difficiles.
- `fenetre_travail_j` : coefficient météo [0–1] (§1).
- `facteur_saison` : 1.0 en saison normale ; 1.1 en pic (heures supplémentaires possibles) ; 0.8 en hiver.

**Calcul de la capacité machine quotidienne**

```
capacite_machine_j[id] = heures_par_operateur_j × fenetre_travail_j   (si statut = libre)
                       = 0                                              (si statut = occupé ou en_panne)
```

- Un tracteur ne peut pas être sur deux chantiers simultanément.
- La capacité machine est la contrainte technique ; la capacité travail est la contrainte humaine.
- Un chantier consomme les deux : il faut un opérateur ET la machine.

**Capacité logistique quotidienne**

```
capacite_logistique_j = somme(capacite_remorque[i] pour chaque remorque libre)
                      × nb_rotations_possibles_j
```

- `nb_rotations_possibles_j` dépend de la distance parcelle↔silo et des heures disponibles.
- En V1 : simplification — 1 remorque = capacité fixe par jour selon distance (local/départemental/national).

**Règle fondamentale : pas de limite de décisions**
- Le joueur peut consulter, planifier, arbitrer et créer des ordres sans limite.
- Seule l'exécution réelle est contrainte par les ressources ci-dessus.
- Un ordre planifié au-delà de la capacité du jour passe automatiquement au jour suivant (file persistante).

**Dépassement de capacité**
- Si `heures_reservees_j > capacite_travail_j` : les ordres en excès passent en état `conditionnel` (orange).
- Le joueur est averti immédiatement lors de la planification (§7).
- Il n'est pas possible de forcer l'exécution d'un ordre si la capacité machine est à zéro (équipement occupé ou en panne).

### Paramètres (ranges indicatifs)

| Paramètre | Valeur V1 |
|---|---|
| Heures/opérateur/j standard | 8 h |
| Heures/opérateur/j pic | 10 h (max) |
| Heures/opérateur/j hiver | 6 h |
| Facteur météo bloquant | 0.0 |
| Facteur météo dégradé | 0.4–0.7 |
| Facteur météo optimal | 1.0 |

### Interactions avec autres systèmes

- **File d'ordres** (§3) : chaque ordre réservé décrémente `heures_restantes_j`.
- **Réservation prévisionnelle** (§6) : les ordres futurs réservent la capacité des jours concernés.
- **Scalabilité** (§5) : la capacité évolue avec la taille de l'exploitation.
- **Services ETA bot** : un ordre délégué au bot ne consomme pas la capacité joueur (seulement la trésorerie).


---

## 3. File d'ordres de travail

### Variables d'état

**Ordre de travail (Work Order)**

| Variable | Type | Description |
|---|---|---|
| `ordre_id` | uuid | Identifiant unique |
| `parcelle_id` | uuid | Parcelle cible |
| `type_action` | enum | Type d'opération (voir §4) |
| `statut` | enum | `planifié` · `confirmé` · `conditionnel` · `en_cours` · `terminé` · `bloqué` |
| `date_planifiee` | date | Jour prévu d'exécution |
| `date_debut_reel` | date\|null | Jour effectif de démarrage |
| `date_fin_reelle` | date\|null | Jour effectif de fin |
| `duree_estimee_h` | float | Durée estimée en heures |
| `duree_reelle_h` | float\|null | Durée réelle (renseignée à la fin) |
| `operateurs_requis` | int | Nombre d'opérateurs nécessaires |
| `materiel_requis[]` | list[ref] | Équipements nécessaires |
| `intrants_requis{}` | map[type→float] | Intrants et quantités nécessaires |
| `cout_estime` | float (€) | Coût total estimé (intrants + carburant + main-d'œuvre) |
| `cause_blocage` | string\|null | Raison du blocage si statut = `bloqué` |
| `ordre_suivant_id` | uuid\|null | Prochain ordre dans la chaîne (max 2 suivants) |
| `conditions_declenchement` | list[Condition]\|null | Conditions pour les ordres `conditionnel` |
| `delegue_eta` | bool | Si true : exécuté par le bot ETA (pas de consommation capacité joueur) |

**File de la parcelle**

| Variable | Type | Description |
|---|---|---|
| `parcelle_id` | uuid | Parcelle concernée |
| `file_ordres[]` | list[ordre_id] | Ordres dans l'ordre d'exécution prévu |
| `longueur_file` | int | Nombre d'ordres en attente (max 3 en V1) |

**File globale de l'exploitation**

| Variable | Type | Description |
|---|---|---|
| `ordres_du_jour[]` | list[ordre_id] | Ordres planifiés pour aujourd'hui |
| `ordres_futurs[]` | list[ordre_id] | Ordres planifiés pour les jours suivants |
| `ordres_bloques[]` | list[ordre_id] | Ordres en attente de déblocage |

### Règles

#### Structure d'un ordre

Un ordre de travail est l'unité atomique d'exécution. Il représente **une opération agricole sur une parcelle** à une date donnée, avec toutes ses dépendances de ressources.

Chaque ordre contient :
1. **Quoi** : type d'action (ex. `semis_ble`).
2. **Où** : parcelle cible.
3. **Quand** : date planifiée.
4. **Avec quoi** : matériel requis + opérateurs requis.
5. **Combien** : intrants requis + coût estimé.
6. **Combien de temps** : durée estimée.
7. **Sous quelle condition** : conditions de déclenchement (pour les ordres `conditionnel`).

#### Chaînage d'ordres (max 3 actions compatibles)

- Un joueur peut enchaîner jusqu'à **3 ordres** sur une même parcelle dans une même séquence.
- Le chaînage est possible uniquement entre actions **compatibles agronomiquement** (voir tableau ci-dessous).
- Les ordres chaînés s'exécutent séquentiellement : l'ordre N+1 ne démarre que si l'ordre N est `terminé`.
- Si l'ordre N passe en `bloqué`, tous les ordres suivants de la chaîne passent en `conditionnel` (en attente).

**Compatibilités de chaînage V1**

| Ordre 1 | Ordre 2 autorisé | Ordre 3 autorisé |
|---|---|---|
| Préparer le sol | Semer | Rouler / Fertiliser de base |
| Semer | Rouler | — |
| Récolter | Préparer le sol | Semer (si fenêtre ouverte) |
| Fertiliser | Traiter | — |
| Traiter | Fertiliser | — |
| Changer litière (élevage) | Soigner | — |
| Alimenter (élevage) | Collecter production | — |

**Incompatibilités strictes (chaînage interdit)**
- Semer → Récolter (cycle trop long, pas de chaînage direct).
- Deux actions nécessitant le même équipement simultanément.
- Toute action sur une parcelle dont le stade phénologique ne correspond pas au prérequis de l'action.

#### États des ordres

**`planifié`**
- L'ordre a été créé par le joueur.
- Les ressources sont réservées en prévisionnel (§6).
- Peut être modifié, déplacé ou annulé librement.
- Transition vers `confirmé` : automatique si toutes les ressources sont disponibles et la date est J ou J+1.
- Transition vers `conditionnel` : si une ressource est incertaine (météo, intrant non encore acheté).

**`confirmé`**
- Toutes les ressources sont vérifiées et disponibles.
- La date d'exécution est dans les 24h.
- Les ressources sont verrouillées (ne peuvent plus être réaffectées à un autre ordre).
- Transition vers `en_cours` : au tick du jour d'exécution si `fenetre_travail_j > 0` et ressources toujours disponibles.
- Transition vers `bloqué` : si une ressource disparaît entre la confirmation et l'exécution (panne, météo).

**`conditionnel`**
- L'ordre est planifié mais dépend d'une condition non encore remplie.
- Exemples de conditions : "si météo favorable J+2", "si semences livrées avant J+3", "si ordre précédent terminé".
- Les ressources sont réservées en prévisionnel mais pas verrouillées.
- Transition vers `confirmé` : automatique quand toutes les conditions sont remplies.
- Transition vers `bloqué` : si une condition devient impossible à remplir.

**`en_cours`**
- Le chantier est en train de s'exécuter.
- Les ressources (opérateurs, matériel) sont immobilisées.
- Les intrants sont consommés progressivement (ou en une fois selon le type d'action).
- Durée réelle peut différer de la durée estimée (aléas météo, panne en cours de chantier).
- Transition vers `terminé` : à la fin du chantier (durée écoulée, pas d'interruption).
- Transition vers `bloqué` : si un aléa interrompt le chantier (panne machine, météo soudaine).

**`terminé`**
- Le chantier est achevé.
- Les effets sur la parcelle/culture/élevage sont appliqués.
- Les ressources sont libérées.
- Les ordres suivants dans la chaîne passent de `conditionnel` à `planifié` (réévaluation).
- L'ordre est archivé (historique).

**`bloqué`**
- Le chantier ne peut pas démarrer ou a été interrompu.
- `cause_blocage` est renseignée (voir règles de blocage ci-dessous).
- Les ressources réservées sont libérées (sauf intrants déjà consommés partiellement).
- Les ordres suivants dans la chaîne restent `conditionnel` jusqu'à déblocage.
- Le joueur reçoit une alerte avec la cause et les actions correctives possibles (§7).
- Transition vers `planifié` : si le joueur corrige la cause et replanifie.

#### Règles de blocage

Un ordre passe en `bloqué` si l'une des conditions suivantes est vraie au moment de l'exécution :

| Cause | Condition | Action corrective suggérée |
|---|---|---|
| Météo bloquante | `fenetre_travail_j = 0` ou condition spécifique (pluie/gel/vent) | Décaler au prochain jour favorable |
| Matériel indisponible | Équipement requis `en_panne` ou `occupé` par un autre ordre | Réparer / Réaffecter / Déléguer ETA bot |
| Intrant insuffisant | `stock_intrant[type] < quantite_requise` | Acheter l'intrant manquant |
| Opérateurs insuffisants | `operateurs_disponibles_j < operateurs_requis` | Embaucher saisonnier / Déléguer ETA bot |
| Prérequis agronomique non rempli | Stade phénologique de la parcelle incompatible | Attendre le bon stade / Exécuter l'action prérequise |
| Trésorerie insuffisante | `tresorerie < cout_estime` (pour les ordres avec achat intégré) | Vendre des stocks / Réduire le périmètre |
| Capacité stockage saturée | Récolte impossible car silo plein | Vendre ou transférer le stock existant |
| Ordre précédent non terminé | Chaînage : ordre N-1 encore `en_cours` ou `bloqué` | Attendre / Débloquer l'ordre précédent |

#### Règles de priorité dans la file globale

- Les ordres sont exécutés dans l'ordre de leur `date_planifiee`.
- En cas d'égalité de date, priorité aux ordres `confirmé` > `planifié` > `conditionnel`.
- Le joueur peut manuellement réordonner les ordres d'un même jour (glisser-déposer).
- Un ordre `en_cours` ne peut pas être interrompu volontairement (sauf événement météo).

#### Limite de file par parcelle

- **V1 : maximum 3 ordres en file par parcelle individuelle** (incluant l'ordre `en_cours`). Au sein d'un bloc, chaque parcelle membre a sa propre file de 3 ordres indépendante.
- Cette limite évite la planification aveugle sur plusieurs semaines et force des décisions régulières.
- Un 4e ordre peut être créé uniquement si le premier de la file est `en_cours` ou `terminé`.
- **[V2+]** : file étendue à 5 ordres, templates de campagne réutilisables.

### Paramètres (ranges indicatifs)

| Paramètre | Valeur V1 |
|---|---|
| Longueur max file par parcelle | 3 ordres |
| Délai max de confirmation automatique | 24 h avant exécution |
| Durée de conservation des ordres `terminé` en historique | 90 jours de jeu |
| Délai de réévaluation des ordres `conditionnel` | 1 tick/jour |

### Interactions avec autres systèmes

- **Capacité d'exécution** (§2) : chaque ordre consomme `heures_travail` et `capacite_machine`.
- **Réservation prévisionnelle** (§6) : la création d'un ordre déclenche la réservation.
- **Feedback joueur** (§7) : chaque changement d'état génère une notification ou une mise à jour visuelle.
- **Météo** (farming-systems §5) : `fenetre_travail_j` conditionne le passage `confirmé` → `en_cours`.
- **Services ETA bot** (farming-systems §9) : un ordre délégué suit le même cycle d'états mais sans consommer la capacité joueur.


---

## 4. Décisions vs opérations

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `action_type` | enum | Classification de l'action (immédiate / temporisée courte / temporisée métier) |
| `duree_h` | float | Durée en heures de jeu (0 = immédiat) |
| `consomme_capacite` | bool | Si true : consomme heures travail + matériel |
| `consomme_intrants` | bool | Si true : consomme des intrants à l'exécution |

### Règles

#### Principe de classification

Toute action dans Agriva appartient à l'une des trois catégories suivantes :

**Catégorie A — Décisions immédiates (0 h)**
- Relèvent du pilotage et de l'arbitrage.
- Ne consomment pas de capacité opérationnelle.
- Ne créent pas d'ordre de travail.
- Exécutées instantanément au clic.

**Catégorie B — Opérations courtes (< 2 h de jeu)**
- Relèvent de la préparation logistique.
- Consomment une fraction de capacité.
- Créent un ordre de travail de courte durée.

**Catégorie C — Opérations métier (2 h à plusieurs jours de jeu)**
- Relèvent des vrais travaux agricoles.
- Consomment pleinement la capacité (travail + machine).
- Créent un ordre de travail temporisé.
- Peuvent être chaînées (§3).

#### Catalogue des actions V1

**Catégorie A — Décisions immédiates**

| Action | Domaine | Effet |
|---|---|---|
| Choisir une culture pour une parcelle | Grandes cultures / Maraîchage | Définit `culture_id` sur la parcelle |
| Planifier un chantier (créer un ordre) | Tous | Crée un ordre `planifié` dans la file |
| Modifier / annuler un ordre planifié | Tous | Met à jour ou supprime l'ordre ; libère les réservations |
| Réordonner la file d'ordres | Tous | Change la priorité des ordres du jour |
| Acheter des intrants (coop bot) | Tous | Débite trésorerie ; incrémente stock (délai livraison = 1 j) |
| Acheter des intrants (marché joueur) | Tous | Débite trésorerie ; délai selon distance vendeur |
| Vendre depuis silo (créer une annonce) | Marché | Crée une annonce de vente |
| Consulter la météo | Météo | Affiche prévision J+1 à J+7 |
| Consulter les alertes | Tous | Marque les alertes comme lues |
| Affecter un opérateur à un atelier | Élevage | Modifie l'affectation RH |
| Commander un service ETA bot | Tous | Crée un ordre délégué |
| Souscrire une assurance récolte | Grandes cultures | Active la couverture pour la saison |
| Décider de transformer vs vendre brut | Transformation | Oriente le stock vers la chaîne de transformation |
| Fusionner des parcelles (décision) | Foncier | Lance le processus (délai 30–90 jours in-game selon surface, irréversible — voir territoire-foncier-v1.md §8) |
| Acheter / louer une parcelle | Foncier | Débite trésorerie / active loyer annuel |

**Catégorie B — Opérations courtes (< 2 h)**

| Action | Durée estimée | Ressources consommées |
|---|---|---|
| Remplir le semoir | 0.5 h | Opérateur × 1 ; semences |
| Charger une remorque | 0.5–1 h | Opérateur × 1 ; tracteur + remorque |
| Affecter une équipe à un chantier | 0.5 h | Opérateur × 1 |
| Changer la litière (petit atelier) | 1 h | Opérateur × 1 ; litière |
| Collecter la production (élevage) | 0.5–1 h | Opérateur × 1 |
| Soins vétérinaires préventifs | 1 h | Opérateur × 1 ; produits vétérinaires |
| Transfert stock parcelle → silo (local) | 1 h | Opérateur × 1 ; tracteur + remorque |

**Catégorie C — Opérations métier (durées de chantier)**

Les durées ci-dessous sont calculées pour une parcelle de référence de **10 ha** avec un équipement standard. La durée réelle est proportionnelle à la surface et inversement proportionnelle à la capacité de l'équipement.

```
duree_chantier_h = (surface_ha / debit_chantier_ha_h) × facteur_meteo × facteur_sol
```

| Action | Débit standard (ha/h) | Durée ref. 10 ha | Matériel requis | Intrants |
|---|---|---|---|---|
| Préparer le sol (labour) | 1.5 ha/h | ~7 h | Tracteur + charrue | Carburant |
| Préparer le sol (travail superficiel) | 3 ha/h | ~3 h | Tracteur + outil | Carburant |
| Semer (grandes cultures) | 2 ha/h | ~5 h | Tracteur + semoir | Semences + carburant |
| Semer / repiquer (maraîchage) | 0.2 ha/h | ~2 h (petite surface) | Micro-tracteur ou manuel | Semences/plants |
| Fertiliser (épandage) | 4 ha/h | ~2.5 h | Tracteur + épandeur | Engrais + carburant |
| Traiter (pulvérisation) | 5 ha/h | ~2 h | Tracteur + pulvérisateur | Produit phyto + carburant |
| Rouler après semis | 4 ha/h | ~2.5 h | Tracteur + rouleau | Carburant |
| Irriguer | 2 ha/h | ~5 h | Équipement irrigation + eau | Eau + énergie |
| Récolter (céréales) | 2 ha/h | ~5 h | Moissonneuse-batteuse | Carburant |
| Récolter (maraîchage) | 0.1 ha/h | ~2 h (petite surface) | Manuel principalement | — |
| Transporter (local, 10 t) | — | ~1 h | Tracteur + remorque | Carburant |
| Lancer la transformation | — | `volume / capacite_t_j` jours | Unité de transformation | Énergie + main-d'œuvre |

**Facteurs de correction de durée**

| Facteur | Valeur | Condition |
|---|---|---|
| `facteur_meteo` | 1.0 | Conditions optimales |
| `facteur_meteo` | 1.3 | Conditions dégradées (sol lourd, vent modéré) |
| `facteur_sol` | 1.0 | Sol normal |
| `facteur_sol` | 1.2 | Sol compact ou très humide |
| `facteur_materiel` | 1.0 | Matériel récent et entretenu |
| `facteur_materiel` | 1.15 | Matériel vieillissant (> 10 ans) |

**Règle de durée multi-jours**
- Si `duree_chantier_h > heures_disponibles_j` : le chantier s'étale sur plusieurs jours.
- Chaque jour, le chantier consomme `min(heures_disponibles_j, heures_restantes_chantier)`.
- Le chantier reste `en_cours` jusqu'à épuisement des heures requises.
- Si la météo bloque un jour intermédiaire, le chantier est suspendu (pas annulé) et reprend le jour suivant.

### Paramètres (ranges indicatifs)

| Paramètre | Valeur V1 |
|---|---|
| Débit semoir standard (grandes cultures) | 2 ha/h |
| Débit moissonneuse standard | 2 ha/h |
| Débit pulvérisateur standard | 5 ha/h |
| Durée max d'un chantier avant alerte | 5 jours |
| Facteur météo bloquant (durée infinie) | `fenetre_travail_j = 0` |

### Interactions avec autres systèmes

- **File d'ordres** (§3) : les opérations C créent des ordres temporisés ; les décisions A ne créent pas d'ordre.
- **Capacité d'exécution** (§2) : les opérations B et C consomment la capacité ; les décisions A ne la consomment pas.
- **Farming systems** (farming-systems-v1 §1–3) : les durées de chantier sont cohérentes avec les stades phénologiques et les fenêtres calendaires.
- **Météo** (farming-systems-v1 §5) : `facteur_meteo` est dérivé de `fenetre_travail_j`.


---

## 5. Scalabilité

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `taille_exploitation` | enum | `petite` · `moyenne` · `grande` |
| `surface_totale_ha` | float | Surface totale exploitée (propriété + location) |
| `nb_ateliers_elevage` | int | Nombre d'ateliers d'élevage actifs |
| `nb_salaries_permanents` | int | Salariés permanents (hors saisonniers) |
| `nb_salaries_saisonniers` | int | Saisonniers actifs sur la période |
| `parc_materiel[]` | list[Materiel] | Équipements possédés |
| `niveau_delegation` | enum | `manuel` · `semi-auto` · `auto` |
| `cout_coordination_j` | float (€) | Coût journalier de coordination (salaires encadrement + overhead) |

### Règles

#### Paliers de taille

**Petite exploitation**
- Surface : 10–50 ha grandes cultures, ou 1–5 ha maraîchage, ou 1–2 ateliers élevage.
- Main-d'œuvre : 1–2 opérateurs (exploitant + 1 saisonnier max).
- Matériel : 1 tracteur, 1 semoir, 1 moissonneuse (ou ETA bot pour la récolte).
- Chantiers simultanés : 1–2 maximum.
- Mode de pilotage : **manuel** — le joueur gère chaque ordre individuellement.
- Décisions stratégiques/jour : 3–5.
- Coût de coordination : quasi nul (exploitant seul).
- Caractéristique : chaque décision a un impact fort ; les erreurs sont coûteuses mais lisibles.

**Exploitation moyenne**
- Surface : 50–200 ha grandes cultures, ou 5–20 ha maraîchage, ou 3–6 ateliers élevage.
- Main-d'œuvre : 2–5 opérateurs permanents + saisonniers en pic.
- Matériel : 2–3 tracteurs, semoir, moissonneuse, épandeur, pulvérisateur.
- Chantiers simultanés : 2–4.
- Mode de pilotage : **semi-auto** — le joueur peut créer des groupes de parcelles et lancer des campagnes.
- Décisions stratégiques/jour : 5–8.
- Coût de coordination : salaires permanents + overhead RH (10–20 % du coût main-d'œuvre).
- Caractéristique : le joueur commence à piloter des systèmes plutôt que des parcelles individuelles.

**Grande exploitation**
- Surface : > 200 ha grandes cultures, ou > 20 ha maraîchage, ou > 6 ateliers élevage.
- Main-d'œuvre : 5–15+ opérateurs permanents, équipes spécialisées.
- Matériel : flotte organisée par atelier (grandes cultures / élevage / logistique).
- Chantiers simultanés : 4–10+.
- Mode de pilotage : **auto** — le joueur valide des campagnes, surveille les exceptions, arbitre les goulets.
- Décisions stratégiques/jour : 8–15 (mais de niveau supérieur : investissement, arbitrage filière, gestion RH).
- Coût de coordination : encadrement intermédiaire, overhead logistique, risque d'inefficience.
- Caractéristique : le joueur est directeur, pas opérateur. La complexité est stratégique, pas cliquée.

#### Règle fondamentale de scalabilité

> **La taille de l'exploitation augmente la complexité stratégique, pas la quantité de micro-actions.**

Ce qui **augmente** avec la taille :
- Nombre de chantiers simultanés possibles.
- Volume financier et logistique.
- Capacité de stockage et de transformation.
- Options de délégation et d'automatisation.
- Profondeur des décisions d'investissement.

Ce qui **ne doit pas augmenter** proportionnellement :
- Nombre d'alertes critiques par session.
- Nombre de clics nécessaires pour une opération standard.
- Nombre d'écrans à visiter obligatoirement.
- Nombre de décisions triviales (remplir le semoir, changer la litière).

#### Systèmes de délégation

**Niveau 1 — Délégation ponctuelle (disponible dès le début)**
- Commander un service ETA bot pour une tâche spécifique.
- Commander un transport coop bot.
- Disponible pour toutes les tailles d'exploitation.
- Coût : tarif ETA/transport (€) ; pas de consommation de capacité joueur.

**Niveau 2 — Groupes de parcelles statiques (exploitation moyenne) [V1]**
- Le joueur peut créer un groupe de parcelles (ex. "Bloc Nord") et lancer une campagne sur le groupe.
- Un seul ordre de campagne génère automatiquement les ordres individuels pour chaque parcelle du groupe.
- Les ordres individuels restent visibles et modifiables.
- Prérequis : ≥ 3 parcelles avec la même culture planifiée.
- **[V2+]** : groupes dynamiques avec règles de regroupement automatique. En V1 : groupes statiques manuels uniquement.

**Niveau 3 — Équipes spécialisées (grande exploitation)**
- Le joueur peut créer des équipes (ex. "Équipe semis", "Équipe élevage").
- Chaque équipe a un pool d'opérateurs et de matériel dédié.
- Les ordres sont affectés à une équipe ; l'équipe gère l'exécution.
- Le joueur ne voit que les exceptions (blocages, alertes).
- Prérequis : ≥ 5 opérateurs permanents.
- **[V2+]** : responsable d'équipe avec compétences, formation, turnover.

**Niveau 4 — Automatisation de routines (grande exploitation)**
- Certaines tâches récurrentes peuvent être configurées en mode automatique :
  - Alimentation élevage : si `stock_aliment_j < seuil`, commander automatiquement.
  - Collecte production élevage : chaque jour automatiquement.
  - Transfert récolte → silo : automatique si silo non saturé.
- L'automatisation consomme quand même la capacité (opérateurs + matériel).
- Le joueur peut désactiver l'automatisation à tout moment.
- Prérequis : ≥ 3 opérateurs permanents affectés à l'atelier concerné.
- **[V2+]** : automatisation des traitements phytosanitaires, irrigation automatique.

#### Coûts de coordination

La croissance n'est pas gratuite. Chaque palier introduit des coûts de coordination :

| Palier | Coût de coordination | Nature |
|---|---|---|
| Petite | Quasi nul | Exploitant seul |
| Moyenne | 10–20 % du coût main-d'œuvre | Overhead RH, temps de briefing |
| Grande | 20–35 % du coût main-d'œuvre | Encadrement intermédiaire, réunions, inefficiences |

**Règle de rendement décroissant de la main-d'œuvre**
```
efficacite_operateur = 1.0 - (nb_operateurs / seuil_coordination) × 0.05
```
- Au-delà de 5 opérateurs sans encadrement : efficacité réduite de 5 % par opérateur supplémentaire.
- Un responsable d'atelier (salarié senior) annule ce malus pour son équipe (max 5 personnes).
- **[V2+]** : compétences individuelles, courbe d'apprentissage, turnover.

**Règle de rendement décroissant du matériel**
- Au-delà de 3 tracteurs sans planification optimisée : taux d'utilisation moyen baisse.
- Indicateur visible en mode expert : `taux_utilisation_materiel` [0–100 %].
- Un taux < 60 % signale un surinvestissement matériel.

### Paramètres (ranges indicatifs)

| Paramètre | Petite | Moyenne | Grande |
|---|---|---|---|
| Surface (grandes cultures) | 10–50 ha | 50–200 ha | > 200 ha |
| Chantiers simultanés max | 1–2 | 2–4 | 4–10+ |
| Décisions stratégiques/j | 3–5 | 5–8 | 8–15 |
| Seuil coordination (opérateurs) | — | 3 | 5 |
| Coût coordination (% MO) | 0 % | 10–20 % | 20–35 % |
| Niveau délégation disponible | 1 | 1–2 | 1–4 |

### Interactions avec autres systèmes

- **Capacité d'exécution** (§2) : la capacité quotidienne est directement fonction du palier de taille.
- **File d'ordres** (§3) : les groupes de parcelles et équipes spécialisées génèrent des ordres en masse.
- **Réservation prévisionnelle** (§6) : les campagnes de groupe réservent les ressources sur plusieurs jours.
- **Feedback joueur** (§7) : en grande exploitation, le joueur ne voit que les exceptions ; les opérations normales sont silencieuses.
- **Marché** (economy-markets) : les grandes exploitations ont accès à des volumes qui influencent les prix (rendements décroissants du spread bot).
- **Foncier** (farming-systems §6) : la surface totale détermine le palier de taille.


---

## 6. Réservation prévisionnelle

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `reservation_id` | uuid | Identifiant de la réservation |
| `ordre_id` | uuid | Ordre de travail associé |
| `date_reservation` | date | Jour pour lequel les ressources sont réservées |
| `heures_reservees` | float (h) | Heures de travail bloquées |
| `materiel_reserve[]` | list[ref] | Équipements bloqués |
| `intrants_reserves{}` | map[type→float] | Intrants mis de côté (quantités) |
| `statut_reservation` | enum | `active` · `verrouillée` · `libérée` · `consommée` |
| `budget_previsionnel_j[date]` | float (€) | Dépenses prévues par jour (agrégat de toutes les réservations) |

### Règles

#### Principe de réservation en deux temps

La réservation suit un cycle en deux phases distinctes :

**Phase 1 — Réservation prévisionnelle (à la planification)**
- Déclenchée dès que le joueur crée un ordre `planifié` ou `conditionnel`.
- Les ressources sont **réservées** : elles apparaissent comme indisponibles pour d'autres ordres.
- Les intrants sont **mis de côté** dans le stock (stock disponible = stock total - intrants réservés).
- La trésorerie affiche le **budget prévisionnel** (dépenses futures engagées).
- `statut_reservation = active`.

**Phase 2 — Verrouillage (à la confirmation, 24h avant exécution)**
- Quand l'ordre passe de `planifié` à `confirmé`, les ressources sont **verrouillées**.
- Un équipement verrouillé ne peut plus être réaffecté même manuellement.
- Les intrants verrouillés ne peuvent plus être utilisés pour un autre ordre.
- `statut_reservation = verrouillée`.

**Phase 3 — Consommation (à l'exécution)**
- Quand l'ordre passe en `en_cours`, les ressources sont **consommées** :
  - Heures de travail : débitées de `capacite_travail_j`.
  - Matériel : passe en statut `occupé`.
  - Intrants : retirés du stock physiquement.
  - Trésorerie : débitée du coût réel (peut différer légèrement de l'estimation).
- `statut_reservation = consommée`.

#### Libération des réservations

Les ressources réservées sont libérées dans les cas suivants :

| Déclencheur | Ressources libérées | Comportement |
|---|---|---|
| Annulation d'un ordre `planifié` | Toutes (heures, matériel, intrants) | Libération immédiate et totale |
| Annulation d'un ordre `confirmé` | Toutes sauf frais d'annulation éventuels | Libération immédiate ; alerte si < 2h avant exécution |
| Ordre passé en `bloqué` | Heures + matériel (intrants non consommés) | Libération automatique ; intrants partiellement consommés = perdus |
| Ordre `terminé` | Matériel (libéré) | Heures et intrants déjà consommés ; matériel repasse en `libre` |
| Météo annule un ordre `confirmé` | Toutes | Libération automatique ; ordre repasse en `planifié` avec nouvelle date suggérée |

#### Calcul du budget prévisionnel

```
budget_previsionnel_j[date] = somme(cout_estime[ordre] pour tous les ordres planifiés à cette date)

tresorerie_disponible_reelle = tresorerie - somme(budget_previsionnel_j[date] pour tous les jours futurs)
```

- La trésorerie affichée au joueur est toujours la **trésorerie disponible réelle** (après déduction des engagements futurs).
- Cela évite qu'un joueur planifie 10 chantiers sans réaliser qu'il n'a pas les fonds.
- En mode Normal : affichage simplifié "Trésorerie disponible : X €" (engagements déduits).
- En mode Expert : décomposition par jour et par type de dépense.

#### Règle de cohérence des réservations

- Si deux ordres réservent le même équipement pour le même jour : le second passe automatiquement en `conditionnel` avec cause "matériel déjà réservé".
- Si les intrants réservés dépassent le stock disponible : le dernier ordre créé passe en `conditionnel` avec cause "intrant insuffisant".
- Si le budget prévisionnel dépasse la trésorerie disponible : alerte orange (pas de blocage automatique, mais avertissement fort).

#### Réservation sur plusieurs jours (chantiers longs)

- Un chantier qui s'étale sur N jours crée N réservations journalières.
- Chaque réservation journalière est indépendante : si le jour J est bloqué (météo), la réservation J est libérée et reportée à J+1.
- Le matériel est réservé pour toute la durée du chantier (pas libéré entre deux jours d'un même chantier).

### Paramètres (ranges indicatifs)

| Paramètre | Valeur V1 |
|---|---|
| Horizon de réservation prévisionnelle | 14 jours |
| Délai de verrouillage avant exécution | 24 h |
| Délai de libération après annulation | Immédiat (< 1 tick) |
| Frais d'annulation ordre `confirmé` | 0 € en V1 (pas de pénalité) |

### Interactions avec autres systèmes

- **File d'ordres** (§3) : chaque création/annulation d'ordre déclenche une mise à jour des réservations.
- **Capacité d'exécution** (§2) : `heures_restantes_j = capacite_travail_j - heures_reservees_j`.
- **Feedback joueur** (§7) : le budget prévisionnel et les conflits de réservation sont affichés en temps réel.
- **Marché** : la trésorerie disponible réelle (après engagements) est la référence pour les décisions d'achat/vente.
- **Stockage** : les intrants réservés sont soustraits du stock disponible pour les calculs de capacité.

---

## 7. Feedback joueur

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `faisabilite_ordre` | enum | `vert` · `orange` · `rouge` |
| `alerte_active[]` | list[Alerte] | Alertes en cours non acquittées |
| `alerte.type` | enum | `blocage` · `tension` · `info` · `opportunite` |
| `alerte.priorite` | enum | `critique` · `haute` · `normale` · `basse` |
| `alerte.cause` | string | Description lisible de la cause |
| `alerte.action_suggeree` | string\|null | Action corrective recommandée |
| `indicateur_capacite_j` | float [0–1] | Taux d'utilisation de la capacité du jour |

### Règles

#### Système de faisabilité (vert / orange / rouge)

Chaque ordre de travail affiche un indicateur de faisabilité calculé en temps réel lors de la planification :

**Vert — Faisable**
- Toutes les ressources sont disponibles.
- La météo prévue est favorable.
- La trésorerie disponible couvre le coût estimé.
- Le stade phénologique est compatible.
- Affichage : icône verte + "Prêt à lancer".

**Orange — Faisable mais tendu**
- Au moins une ressource est disponible mais à la limite (< 20 % de marge).
- La météo est incertaine (prévision J+2 ou J+3 avec incertitude > 40 %).
- La trésorerie couvre le coût mais laisse peu de marge (< 15 % de la trésorerie totale).
- Un ordre concurrent réserve la même ressource sur une plage proche.
- Affichage : icône orange + message court expliquant la tension (ex. "Tracteur disponible mais peu de marge").

**Rouge — Non faisable**
- Au moins une ressource est indisponible (matériel en panne, intrant manquant, opérateurs insuffisants).
- La météo est bloquante pour ce type de tâche.
- La trésorerie est insuffisante.
- Le stade phénologique est incompatible.
- Affichage : icône rouge + cause principale + action corrective suggérée.

**Règle d'affichage de la cause principale**
- Si plusieurs causes de blocage coexistent, afficher la cause la plus bloquante en premier.
- Ordre de priorité : météo > matériel > opérateurs > intrants > trésorerie > stade.
- En mode Expert : toutes les causes sont listées.

#### Mise à jour en temps réel lors de la planification

- À chaque ordre ajouté à la file, le système recalcule immédiatement :
  - `heures_restantes_j` pour le jour concerné.
  - `tresorerie_disponible_reelle` (après déduction du nouvel engagement).
  - La faisabilité de tous les ordres existants (un nouvel ordre peut rendre un ordre précédent orange).
- L'indicateur de capacité du jour (`indicateur_capacite_j`) se met à jour visuellement :
  - 0–70 % : vert.
  - 70–90 % : orange.
  - > 90 % : rouge (surcharge).

#### Système d'alertes

**Alertes critiques (push immédiat)**
- Ordre passé en `bloqué` (cause + action corrective).
- Chantier interrompu par météo soudaine.
- Stock aliment élevage < 2 jours d'autonomie.
- Trésorerie < seuil critique (paramétrable par le joueur).
- Panne machine pendant un chantier `en_cours`.
- Récolte prête mais météo défavorable prévue dans 48h.

**Alertes hautes (visible dans le tableau de bord)**
- Ordre `conditionnel` dont la condition ne sera probablement pas remplie (météo défavorable persistante).
- Intrant réservé mais stock insuffisant (achat nécessaire).
- Capacité du jour > 90 % (surcharge).
- Fenêtre de semis qui se ferme dans 3 jours.
- Stock silo > 80 % de capacité (risque de saturation à la prochaine récolte).

**Alertes normales (résumé quotidien)**
- Chantier terminé (confirmation de fin).
- Ordre passé de `conditionnel` à `confirmé`.
- Livraison reçue (intrants commandés).
- Production élevage collectée.

**Alertes basses / informations (consultables)**
- Prévision météo favorable pour les 3 prochains jours (opportunité de chantier).
- Prix marché favorable pour une culture en stock.
- Fenêtre de semis optimale ouverte.

#### Estimations affichées

Pour chaque ordre de travail, le joueur voit :

| Information | Mode Normal | Mode Expert |
|---|---|---|
| Durée estimée | "~5 h" ou "~2 jours" | Décomposition : surface × débit × facteurs |
| Coût estimé | Total en € | Décomposition : intrants + carburant + main-d'œuvre |
| Ressources mobilisées | Icônes (tracteur, opérateur, semences) | Détail quantitatif par ressource |
| Faisabilité | Vert / Orange / Rouge + 1 phrase | Toutes les causes listées |
| Impact attendu | "Parcelle semée" | Effet sur rendement potentiel, stade résultant |
| Risques | Icône météo si incertitude | Probabilité de blocage estimée |

#### Résumé de fin de journée

Chaque tick quotidien génère un résumé consultable :
- Chantiers terminés aujourd'hui.
- Chantiers bloqués (avec causes).
- Ressources consommées (heures, intrants, €).
- Alertes actives à traiter.
- Aperçu du lendemain (ordres planifiés + météo prévue).

En grande exploitation (§5) : le résumé est filtré — seules les exceptions (blocages, alertes critiques) sont mises en avant. Les opérations normales sont silencieuses.

#### Règle d'économie d'attention

> **En grande exploitation, le joueur ne doit pas recevoir plus de 5 alertes critiques par session.**

- Les alertes normales et basses sont regroupées en résumé.
- Les alertes critiques sont individuelles et actionnables.
- Le joueur peut configurer ses seuils d'alerte (mode Expert).
- **[V2+]** : tableau de bord personnalisable, filtres par atelier/activité.

### Paramètres (ranges indicatifs)

| Paramètre | Valeur V1 |
|---|---|
| Seuil orange capacité | 70 % |
| Seuil rouge capacité | 90 % |
| Seuil alerte trésorerie (défaut) | 10 % de la trésorerie totale |
| Seuil alerte stock aliment élevage | 2 jours d'autonomie |
| Seuil alerte silo | 80 % de capacité |
| Max alertes critiques/session (grande exploitation) | 5 |

### Interactions avec autres systèmes

- **File d'ordres** (§3) : chaque changement d'état d'un ordre génère une mise à jour de faisabilité ou une alerte.
- **Réservation prévisionnelle** (§6) : les conflits de réservation sont affichés en orange dès la planification.
- **Météo** (farming-systems §5) : l'incertitude météo est traduite en couleur sur les ordres futurs.
- **Scalabilité** (§5) : le niveau de détail des alertes s'adapte à la taille de l'exploitation.
- **Tous les systèmes** : le feedback est la couche de présentation de l'action economy ; il ne contient pas de logique métier propre.

---

## Annexe — Récapitulatif des décisions figées appliquées

| Domaine | Décision appliquée |
|---|---|
| Énergie abstraite | Absente — limites = ressources métier uniquement |
| Ressources V1 | Argent + temps opérationnel + main-d'œuvre + matériel + intrants + logistique + météo |
| Limite de clics | Aucune — seule l'exécution est contrainte |
| File d'ordres | Max 3 ordres par parcelle en V1 |
| Chaînage | Max 3 actions compatibles par séquence |
| États des ordres | planifié / confirmé / conditionnel / en_cours / terminé / bloqué |
| Décisions | Immédiates (catégorie A) |
| Opérations | Temporisées (catégories B et C) |
| Réservation | Prévisionnelle à la planification, verrouillée 24h avant exécution |
| Feedback | Vert / Orange / Rouge + cause + action corrective |
| Scalabilité | 3 paliers : petite / moyenne / grande |
| Délégation | 4 niveaux progressifs |

## Annexe — Éléments explicitement hors scope V1 (V2+)

- File d'ordres étendue à 5+ ordres par parcelle
- Templates de campagne réutilisables
- Groupes dynamiques de parcelles avec règles automatiques
- Responsables d'équipe avec compétences et turnover
- Automatisation des traitements phytosanitaires et de l'irrigation
- Tableau de bord personnalisable et filtres par atelier
- Compétences individuelles des opérateurs, courbe d'apprentissage
- Frais d'annulation sur les ordres confirmés
- Stations météo locales achetables pour améliorer les prévisions
- Prestataires joueurs spécialisés (ETA bot joueur)
- Contrats de service à long terme avec prestataires
