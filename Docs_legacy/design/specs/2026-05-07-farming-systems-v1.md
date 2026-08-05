# Agriva — Farming Systems V1 — Spec détaillée
> Date : 2026-05-07
> Statut : **Figé V1** — toutes les décisions pending résolues (decisions_log 2026-05-07)
> Référence : agriva_split_systems_farming.md §4-12, §19, §26, §34-35 · agriva_decisions_log_compact.md

---

## Sommaire

1. [Grandes cultures](#1-grandes-cultures)
2. [Élevage](#2-élevage)
3. [Maraîchage](#3-maraîchage)
4. [Sols](#4-sols)
5. [Météo](#5-météo)
6. [Foncier](#6-foncier)
7. [Stockage & logistique](#7-stockage--logistique)
8. [Transformation V1](#8-transformation-v1)
9. [Services V1](#9-services-v1)

---

## Principes transversaux

- **Unité de temps** : tick quotidien. Chaque jour, les ressources (travail, machine) se réinitialisent et les tâches en file progressent.
- **Boucle principale** : Observer → Évaluer → Planifier → Réserver → Exécuter → Vendre/Acheter → Investir → Progresser.
- **Mode Normal / Expert** : bascule par système. Le mode normal montre les *conséquences* ; le mode expert montre les *causes*. Un profil global sert de preset.
- **Règle de scope** : tout ce qui dépasse le périmètre V1 est explicitement marqué **[V2+]**.

---

## 1. Grandes cultures

> Rythme : cycle long (annuel). Filières types : blé tendre, orge, colza, maïs, tournesol, betterave.

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `culture_id` | enum | Espèce cultivée sur la parcelle |
| `stade_phenologique` | enum | `vide` · `préparation` · `semis` · `levée` · `croissance` · `floraison` · `maturation` · `récolte_prête` · `récolté` |
| `jours_dans_stade` | int | Compteur de jours depuis l'entrée dans le stade courant |
| `rendement_potentiel` | int [0–100] | Score de potentiel de rendement (0 = nul, 100 = optimal) — utilisé comme multiplicateur normalisé dans la formule finale |
| `stress_hydrique` | float [0–100] | Niveau de stress eau courant (0 = aucun, 1 = critique) |
| `stress_nutritif` | float [0–100] | Niveau de carence nutritive courant |
| `pression_adventices` | float [0–100] | Pression mauvaises herbes (dégradée si non traitée) |
| `pression_ravageurs` | float [0–100] | Pression insectes/maladies (dégradée si non traitée) |
| `date_semis` | date | Date effective du semis (détermine la fenêtre de récolte) |
| `surface_ha` | float | Surface de la parcelle en hectares |
| `stock_recolte` | float (t) | Tonnes récoltées en attente de transfert vers stockage |

### Actions joueur

| Action | Prérequis | Coût ressources | Effet principal |
|---|---|---|---|
| **Préparer le sol** | stade `vide` ou `récolté` | Travail + machine (tracteur+outil) | Passe en `préparation` ; améliore humidité sol si conditions ok |
| **Semer** | stade `préparation` ; fenêtre calendaire ouverte | Travail + machine + semences | Passe en `levée` ; fixe `date_semis` |
| **Fertiliser** | stade `levée` à `maturation` | Travail + machine + intrants | Réduit `stress_nutritif` ; en expert : ajuste N/P/K |
| **Traiter (herbicide/fongicide/insecticide)** | stade `levée` à `maturation` | Travail + machine + intrants | Réduit `pression_adventices` ou `pression_ravageurs` |
| **Irriguer** | stade `levée` à `maturation` ; équipement irrigation | Travail + eau | Réduit `stress_hydrique` |
| **Récolter** | stade `récolte_prête` ; météo favorable | Travail + machine (moissonneuse) | Calcule rendement final ; remplit `stock_recolte` ; passe en `récolté` |
| **Déléguer au prestataire ETA** | toute action de champ éligible | Argent (tarif ETA bot) | Exécute l'action avec délai ; libère capacité travail/machine joueur |
| **Vendre (marché / coop bot)** | `stock_recolte > 0` ou stock en silo | Logistique (coût+délai) | Transfère vers acheteur ; encaisse prix |

> **[V2+]** Irrigation par pivot automatisé, modulation intra-parcellaire, agriculture de précision.

### Règles de simulation

**Progression des stades**
- Chaque stade a une durée en jours (paramétrable par culture et région).
- La transition vers le stade suivant est automatique si les conditions sont remplies (température cumulée, humidité minimale).
- Un stade manqué (ex. semis hors fenêtre) dégrade `rendement_potentiel` de façon irréversible.

**Calcul du rendement final**
```
rendement_final = rendement_base(culture, région)
                × fertilité_sol_factor       -- [0.6 – 1.2]
                × humidité_sol_factor         -- [0.5 – 1.1]
                × (1 - stress_hydrique_moy)
                × (1 - stress_nutritif_moy)
                × (1 - pression_adventices_moy × 0.4)
                × (1 - pression_ravageurs_moy × 0.3)
                × météo_saison_factor         -- [0.7 – 1.15]
```
- `rendement_base` varie par culture et par région (ex. blé Beauce > blé Bretagne).
- Les facteurs sont multiplicatifs ; un stress sévère non traité peut réduire le rendement de 40–60 %.

**Fenêtres calendaires**
- Chaque culture a une fenêtre de semis optimale (ex. blé d'hiver : oct–nov) et une fenêtre de récolte (ex. juillet–août).
- Semer hors fenêtre est possible mais pénalise `rendement_potentiel` (-10 % à -30 % selon l'écart).

**Dégradation passive**
- `pression_adventices` et `pression_ravageurs` augmentent de +0.02/jour si non traitées.
- `stress_hydrique` augmente si `humidité_sol` descend sous le seuil de la culture.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Indicateurs sol | Fertilité (barre) + Humidité (barre) | NPK détaillé + MO + pH + historique |
| Stress affiché | Icône d'alerte colorée (vert/orange/rouge) | Valeur numérique + cause identifiée |
| Rendement prévisionnel | Fourchette simple (ex. "6–8 t/ha") | Décomposition facteur par facteur |
| Traitements | "Traiter la parcelle" (action unique) | Choix produit, dose, timing optimal |
| Fenêtres | Alerte "fenêtre optimale ouverte" | Calendrier détaillé avec probabilités |

### Interactions avec autres systèmes

- **Sols** : chaque cycle cultural modifie fertilité, humidité, NPK, MO, pH et alimente l'historique cultural.
- **Météo** : pluie réduit `stress_hydrique` ; gel hors saison peut tuer une culture en `levée` ; canicule augmente `stress_hydrique` ; excès de pluie à la récolte bloque l'action Récolter.
- **Foncier** : la surface de la parcelle détermine le volume de récolte et le temps machine nécessaire.
- **Stockage** : `stock_recolte` doit être transféré vers un silo avant saturation ; si aucun silo disponible, la récolte est vendue au prix spot (souvent défavorable).
- **Marché** : le tag d'origine régionale de la récolte influence le prix sur le marché joueur.
- **Élevage** : les céréales récoltées peuvent alimenter les ateliers d'élevage (aliment produit en interne).

---

## 2. Élevage

> Rythme : cycle moyen (mensuel à annuel selon atelier). Ateliers V1 : bovins lait, bovins viande, ovins, porcins, volailles. **Note** : les volailles sont confirmées V1 (décision ajoutée dans decisions_log).

### Variables d'état

**Atelier (niveau exploitation)**

| Variable | Type | Description |
|---|---|---|
| `atelier_id` | enum | Type d'atelier (bovin_lait, bovin_viande, ovin, porcin, volaille) |
| `effectif` | int | Nombre d'animaux présents |
| `capacite_max` | int | Capacité du bâtiment (détermine le plafond d'effectif) |
| `stock_aliment_j` | float | Jours d'autonomie alimentaire restants |
| `stock_litiere_j` | float | Jours d'autonomie en litière restants |
| `etat_sanitaire` | float [0–100] | Santé globale du troupeau (0 = épidémie, 1 = excellent) |
| `productivite` | float [0–100] | Niveau de production courant (lait, viande, œufs…) |

**Animal / lot (niveau individuel ou groupe)**

| Variable | Type | Description |
|---|---|---|
| `stade_vie` | enum | `naissance` · `croissance` · `adulte_productif` · `réforme` |
| `age_jours` | int | Âge en jours |
| `poids_kg` | float | Poids vif (pour bovins/ovins/porcins) |
| `production_jour` | float | Production journalière (litres lait, kg gain, œufs) |
| `gestation` | bool | En gestation (femelles reproductrices) |
| `jours_gestation` | int | Jours de gestation écoulés |

### Actions joueur

| Action | Prérequis | Coût ressources | Effet principal |
|---|---|---|---|
| **Acheter animaux** | Capacité bâtiment disponible | Argent (marché joueur ou bot) | Augmente `effectif` ; animaux en stade `croissance` ou `adulte_productif` |
| **Vendre animaux** | `effectif > 0` ; stade éligible | Logistique | Réduit `effectif` ; encaisse prix |
| **Alimenter** | `stock_aliment_j < seuil_alerte` | Argent + logistique (livraison) | Recharge `stock_aliment_j` |
| **Changer litière** | Travail | Travail | Maintient `etat_sanitaire` ; tâche quotidienne |
| **Soigner / traitement vétérinaire** | `etat_sanitaire < 0.6` | Argent + travail | Remonte `etat_sanitaire` ; stoppe dégradation |
| **Inséminer / faire saillir** | Femelle adulte ; non gestante | Argent (insémination bot) + travail | Déclenche gestation |
| **Vêler / agneler / mettre bas** | Gestation terminée | Travail | Ajoute naissances à l'effectif ; femelle repasse en `adulte_productif` |
| **Réformer** | Stade `réforme` | Travail | Retire l'animal de l'atelier ; vente ou abattage |
| **Collecter production** | Atelier productif | Travail | Collecte lait/œufs du jour ; alimente stock produits |
| **Agrandir bâtiment** | Argent + délai construction | Argent | Augmente `capacite_max` |

> **[V2+]** Sélection génétique, croisements, gestion fine de la ration, bien-être animal comme indicateur de classement.

### Règles de simulation

**Cycle de production (exemple bovin lait)**
- Vache adulte : production laitière journalière = `base_race × productivite × etat_sanitaire × alimentation_factor`.
- Gestation : 280 jours → vêlage → veau en `croissance` → adulte à ~24 mois.
- Tarissement : 60 jours avant vêlage, production = 0.

**Cycle de production (exemple bovin viande / porcin)**
- Animal en `croissance` : gain de poids journalier = `GMQ_base × alimentation_factor × etat_sanitaire`.
- Vente à poids cible (ex. 650 kg bovin, 110 kg porcin).

**Dégradation passive**
- `stock_aliment_j` décroît de 1/jour ; si = 0, `productivite` chute de -0.1/jour, `etat_sanitaire` de -0.05/jour.
- `etat_sanitaire` se dégrade de -0.01/jour sans entretien (litière, soins préventifs).
- Un `etat_sanitaire < 0.3` déclenche une alerte épidémie (événement) ; mortalité possible.

**Coûts fixes journaliers**
- Chaque atelier génère un coût fixe/jour (alimentation, charges, amortissement bâtiment) indépendamment de la production.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Suivi troupeau | Effectif + état sanitaire (icône) + stock aliment (jours) | Détail par lot/stade, courbe de production, ration décomposée |
| Alertes | "Stock aliment faible" / "Santé dégradée" | Seuils configurables, causes identifiées, coût estimé |
| Production | Total journalier (litres/kg/œufs) | Par animal/lot, tendance, projection mensuelle |
| Reproduction | "Inséminer" (bouton simple) | Calendrier de reproduction, taux de réussite, coût/vêlage |

### Interactions avec autres systèmes

- **Grandes cultures** : les céréales et fourrages produits sur l'exploitation alimentent les ateliers (réduction du coût d'alimentation acheté).
- **Sols** : le fumier/lisier produit par les ateliers est un intrant organique pour les parcelles (améliore MO en expert, fertilité en normal).
- **Stockage** : le lait et les œufs ont une durée de vie courte → contrainte de collecte/vente rapide ou transformation.
- **Transformation** : lait → produit laitier standard (chaîne V1) ; viande → découpe standard (chaîne V1).
- **Météo** : vague de chaleur dégrade `etat_sanitaire` et `productivite` ; grand froid augmente le coût d'alimentation.
- **Marché** : prix animaux et produits animaux soumis au spread bot + tag d'origine + rendements décroissants.


---

## 3. Maraîchage

> Rythme : cycle court (2–12 semaines). Cultures types : tomate, salade, carotte, haricot, courgette, poireau, oignon.

### Variables d'état

| Variable | Type | Description |
|---|---|---|
| `culture_id` | enum | Espèce maraîchère cultivée |
| `stade` | enum | `vide` · `préparation` · `semis_repiquage` · `croissance` · `récolte_prête` · `récolté` |
| `jours_dans_stade` | int | Compteur de jours dans le stade courant |
| `rendement_potentiel` | float [0–100] | Potentiel accumulé (dégradé par stress ou retard) |
| `stress_hydrique` | float [0–100] | Sensibilité eau (maraîchage très sensible) |
| `pression_ravageurs` | float [0–100] | Pression insectes/maladies (cycles courts = risque rapide) |
| `surface_m2` | float | Surface en m² (parcelles maraîchères plus petites) |
| `nb_cycles_annee` | int | Nombre de cycles réalisés sur la parcelle dans l'année |
| `stock_recolte_kg` | float | Kg récoltés en attente de transfert |

### Actions joueur

| Action | Prérequis | Coût ressources | Effet principal |
|---|---|---|---|
| **Préparer la planche** | stade `vide` ou `récolté` | Travail (manuel ou micro-tracteur) | Passe en `préparation` ; ameublit sol |
| **Semer / repiquer** | stade `préparation` ; fenêtre ouverte | Travail + semences/plants | Passe en `croissance` ; fixe date de début |
| **Irriguer** | stade `croissance` | Travail + eau | Réduit `stress_hydrique` (critique en maraîchage) |
| **Fertiliser** | stade `croissance` | Travail + intrants | Réduit stress nutritif ; maintient rendement |
| **Traiter ravageurs** | stade `croissance` | Travail + intrants | Réduit `pression_ravageurs` |
| **Récolter** | stade `récolte_prête` | Travail (manuel principalement) | Calcule rendement ; remplit `stock_recolte_kg` |
| **Vendre (marché / coop bot / circuit court)** | `stock_recolte_kg > 0` | Logistique | Encaisse prix ; produits frais = délai court obligatoire |

> **[V2+]** Serres chauffées, cultures sous abri, hydroponie, circuits courts avec contrats joueurs.

### Règles de simulation

**Durée des cycles**
- Cycles courts : 3–6 semaines (salade, radis, épinard).
- Cycles moyens : 6–12 semaines (tomate, courgette, haricot).
- Plusieurs cycles possibles par saison sur la même planche (rotation intra-annuelle).

**Calcul du rendement final**
```
rendement_final = rendement_base(culture)
                × humidité_sol_factor         -- très sensible : [0.4 – 1.1]
                × fertilité_sol_factor         -- [0.7 – 1.1]
                × (1 - stress_hydrique_moy × 0.6)
                × (1 - pression_ravageurs_moy × 0.5)
                × météo_factor                 -- gel = destruction totale possible
```
- Le maraîchage est plus sensible à l'eau et aux ravageurs que les grandes cultures.
- Un gel nocturne hors protection détruit les cultures sensibles (tomate, courgette) instantanément.

**Périssabilité**
- `stock_recolte_kg` se dégrade de -5 %/jour si non vendu ou stocké en chambre froide.
- Contrainte de vente rapide : crée une pression de décision différente des grandes cultures.

**Rotation intra-annuelle**
- Chaque cycle réalisé sur une planche incrémente `nb_cycles_annee`.
- Alterner familles botaniques réduit `pression_ravageurs` au cycle suivant (bonus rotation).

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Suivi | Stade + alerte stress + jours avant récolte | Détail stress hydrique/nutritif, courbe de croissance |
| Périssabilité | Alerte "à vendre sous X jours" | Taux de dégradation journalier visible |
| Rotation | Suggestion "changer de famille" | Historique cultural, impact NPK/MO par culture |
| Irrigation | "Irriguer" (bouton) | Volume, fréquence, coût eau détaillé |

### Interactions avec autres systèmes

- **Sols** : cycles courts épuisent rapidement la fertilité ; la rotation des familles botaniques est centrale pour maintenir les indicateurs sol.
- **Météo** : gel = risque de destruction ; canicule = stress hydrique critique ; pluie excessive = maladies fongiques.
- **Stockage** : chambre froide nécessaire pour différer la vente au-delà de 2–3 jours ; sans chambre froide, vente forcée au prix spot.
- **Marché** : produits frais ont un tag d'origine fort ; prix plus volatils que les grandes cultures.
- **Transformation** : légumes → conserves/jus (chaîne V1 simple si équipement disponible).

---

## 4. Sols

> Système transversal : chaque parcelle possède son propre état de sol, partagé par toutes les activités qui s'y déroulent.

### Variables d'état

**Mode Normal (indicateurs visibles)**

| Variable | Type | Description |
|---|---|---|
| `fertilite` | int [0–100] | Indicateur synthétique de richesse du sol (0 = épuisé, 100 = excellent) |
| `humidite` | float [0–100] | Teneur en eau du sol (0 = sec, 1 = saturé) |

**Mode Expert (indicateurs détaillés)**

| Variable | Type | Description |
|---|---|---|
| `N` | float (kg/ha) | Azote disponible |
| `P` | float (kg/ha) | Phosphore disponible |
| `K` | float (kg/ha) | Potassium disponible |
| `MO` | float (%) | Taux de matière organique |
| `pH` | float [4.5–8.5] | pH du sol |
| `historique_cultural` | list[string] | Cultures des N dernières années (utilisé pour calcul rotation) |
| `compaction` | float [0–100] | Tassement du sol (dégradé par passages machines répétés) |

> `fertilite` en normal est calculée à partir de N+P+K+MO en expert (agrégation pondérée). `humidite` en normal correspond à la teneur en eau réelle.

### Actions joueur

| Action | Effet Normal | Effet Expert |
|---|---|---|
| **Apport engrais minéral** | +fertilité | +N ou +P ou +K selon produit |
| **Apport fumier/compost** | +fertilité +humidité (rétention) | +MO +N +P +K (libération lente) |
| **Couvert végétal** | +fertilité (long terme) | +MO, fixation N (légumineuses), protection pH |
| **Jachère** | +fertilité (récupération lente) | Récupération MO, réduction pression adventices |
| **Chaulage** | — | +pH (correction acidité) |
| **Labour profond** | +humidité (aération) | Réduit compaction ; risque lessivage N |
| **Travail superficiel** | Prépare semis | Réduit compaction légère ; préserve MO |
| **Irrigation** | +humidité | Ajuste teneur en eau ; risque lessivage si excès |

### Règles de simulation

**Dynamique de fertilité (normal)**
```
fertilite_j+1 = fertilite_j
              - prelevement_culture_j      -- selon culture et stade
              + apport_engrais_j
              + apport_organique_j × 0.3   -- libération lente
              + recuperation_passive_j     -- très lente sans action
```

**Dynamique NPK (expert)**
- N : prélevé par la culture selon stade ; lessivé par pluie excessive ; apporté par engrais/fumier/légumineuses.
- P : peu mobile ; prélevé lentement ; apporté par fumier/engrais P.
- K : mobile ; prélevé par culture ; apporté par fumier/engrais K.
- MO : augmente avec apports organiques et couverts ; diminue avec cultures intensives sans restitution.
- pH : stable à court terme ; corrigé par chaulage ; acidifié par engrais azotés répétés.

**Humidité**
```
humidite_j+1 = humidite_j
             + pluie_j / capacite_retention
             - evapotranspiration_j(culture, température)
             - prelevement_culture_j
             + irrigation_j
```
- Saturation (humidite > 0.95) : risque d'asphyxie racinaire, blocage des travaux.
- Sécheresse (humidite < 0.15) : stress hydrique critique.

**Rotations**
- L'`historique_cultural` est mis à jour à chaque récolte.
- Bonus rotation : alterner familles (céréales / oléagineux / légumineuses / maraîchage) donne un multiplicateur `rotation_factor` [0.9–1.15] sur `rendement_potentiel` de la culture suivante.
- Malus monoculture : même culture 2 ans de suite → `rotation_factor` = 0.9 ; 3 ans → 0.8 (plafonné).
- En expert : l'historique montre l'effet attendu sur NPK et les risques de maladies spécifiques.

**Compaction** *(expert uniquement)*
- Augmente avec chaque passage machine lourd sur sol humide.
- Réduite par labour profond ou travail du sol.
- Compaction élevée réduit la pénétration racinaire → pénalise rendement.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Affichage | 2 barres : Fertilité + Humidité | Tableau NPK + MO + pH + historique + compaction |
| Actions sol | Effet sur les 2 barres affiché directement | Décomposition de l'effet par nutriment, délai de libération |
| Rotation | Suggestion colorée (bon/moyen/mauvais) | Détail agronomique : famille, effet NPK, risque maladie |
| Alertes | "Sol épuisé" / "Sol trop sec" | Seuils par nutriment, recommandation de correction |

### Interactions avec autres systèmes

- **Grandes cultures / Maraîchage** : chaque cycle cultural prélève des nutriments et modifie l'humidité.
- **Élevage** : fumier/lisier = intrant organique vers les parcelles.
- **Météo** : pluie recharge l'humidité ; sécheresse prolongée épuise l'humidité ; gel peut détruire la structure du sol.
- **Foncier** : l'état du sol est attaché à la parcelle ; une parcelle achetée hérite de l'état de sol existant.
- **Transformation** : sans interaction directe en V1.


---

## 5. Météo

> Décision figée : granularité **régionale avec modificateurs locaux** ; prévision **moyenne avec incertitude croissante**.

### Variables d'état

**Région météo**

| Variable | Type | Description |
|---|---|---|
| `region_id` | enum | Grande zone climatique (ex. Nord, Bassin parisien, Atlantique, Méditerranée, Montagne, Est) |
| `temperature_min_j` | float (°C) | Température minimale du jour |
| `temperature_max_j` | float (°C) | Température maximale du jour |
| `precipitations_j` | float (mm) | Précipitations du jour |
| `vent_j` | float (km/h) | Vitesse du vent du jour |
| `ensoleillement_j` | float [0–100] | Indice d'ensoleillement du jour |
| `evenement_meteo` | enum | `aucun` · `gel` · `canicule` · `orage` · `grele` · `inondation` · `secheresse` |

**Prévision (horizon 7 jours)**

| Variable | Type | Description |
|---|---|---|
| `prevision_j+n` | struct | Valeurs prévues pour J+n (température, pluie, vent) |
| `incertitude_j+n` | float [0–100] | Niveau d'incertitude de la prévision (0 = certain, 1 = très incertain) |
| `alerte_active` | bool | Alerte météo en cours (gel, canicule, orage fort) |

**Modificateur local (par département / bassin)**

| Variable | Type | Description |
|---|---|---|
| `modificateur_temperature` | float (°C) | Écart par rapport à la région (ex. +2°C en fond de vallée) |
| `modificateur_precipitations` | float (%) | Écart pluviométrique local (ex. +20 % en zone littorale) |

### Actions joueur

Le joueur n'agit pas directement sur la météo. Ses actions sont des **réponses** aux conditions météo :

| Réponse joueur | Déclencheur météo | Effet |
|---|---|---|
| **Consulter la prévision** | Toujours disponible | Affiche J+1 à J+7 avec incertitude |
| **Décaler une tâche** | Prévision défavorable | Repousse une tâche dans la file |
| **Activer l'irrigation** | Sécheresse prévue | Anticipe le stress hydrique |
| **Récolter en urgence** | Pluie/grêle prévue dans 2 jours | Avance la récolte si stade `récolte_prête` |
| **Souscrire assurance récolte** | Toujours disponible | Réduit l'impact financier d'un événement extrême |

> **[V2+]** Assurance récolte avec contrats détaillés, stations météo locales achetables, prévisions longues terme.

### Règles de simulation

**Génération météo**
- La météo est générée par région pour chaque tick quotidien selon des distributions saisonnières paramétrées.
- Les événements extrêmes (gel, grêle, canicule) ont une probabilité faible mais non nulle, variable par région et saison.
- La prévision J+1 est fiable à ~90 % ; J+3 à ~70 % ; J+7 à ~50 % (incertitude croissante).

**Effets sur les systèmes**

| Événement | Effet Grandes cultures | Effet Élevage | Effet Maraîchage | Effet Logistique |
|---|---|---|---|---|
| Gel (< -2°C) | Destruction cultures sensibles en levée | +coût alimentation ; stress sanitaire | Destruction cultures non protégées | Blocage transport si verglas |
| Canicule (> 35°C) | +stress hydrique fort | -productivité ; -santé troupeau | +stress hydrique critique | — |
| Orage / grêle | -rendement_potentiel (-10 à -40 %) | Stress sanitaire | Destruction partielle ou totale | Blocage temporaire |
| Pluie excessive | Blocage récolte ; lessivage N | — | Maladies fongiques | Blocage champs lourds |
| Sécheresse prolongée | +stress hydrique cumulatif | +coût alimentation (fourrages) | Destruction si non irrigué | — |

**Fenêtres de travail**
- Certaines tâches sont bloquées par la météo : récolte bloquée si pluie > 5 mm/j ; labour bloqué si sol saturé ; semis bloqué si gel prévu dans 48h.
- Le joueur voit ces blocages dans sa file de tâches (indicateur rouge + raison).

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Affichage | Icônes météo J+1 à J+5 + alerte colorée | Courbes température/pluie/vent J+7 + intervalles d'incertitude |
| Modificateurs locaux | Non visibles | Écart local affiché par département/bassin |
| Impact sur tâches | "Tâche bloquée" (raison simple) | Détail de la condition bloquante + alternatives suggérées |
| Événements extrêmes | Alerte push + impact résumé | Probabilité de l'événement + impact estimé par culture/atelier |

### Interactions avec autres systèmes

- **Grandes cultures** : détermine les fenêtres de travail, le stress hydrique, les risques de destruction.
- **Élevage** : chaleur et froid extrêmes dégradent productivité et santé.
- **Maraîchage** : gel et sécheresse sont des risques critiques.
- **Sols** : pluie recharge l'humidité ; excès lessive les nutriments.
- **Logistique** : événements extrêmes peuvent bloquer les transports (délai augmenté).
- **Marché** : un événement météo régional majeur peut créer un choc d'offre local (prix spot affectés via tag d'origine).

---

## 6. Foncier

> **Source de vérité pour la struct Parcelle** : 	erritoire-foncier-v1.md §4. Cette section ne redéfinit que les variables spécifiques au système cultural ; toutes les autres variables (surface, qualite_agronomique, acces, statut_propriete, bloc_id, distance_siege) sont définies dans territoire-foncier-v1.

> Décision figée : parcelles **abstraites** (taille + type, pas de géométrie), fusion **permanente**, territoire **départemental**.

### Variables d'état

**Parcelle**

| Variable | Type | Description |
|---|---|---|
| `parcelle_id` | uuid | Identifiant unique |
| `surface_ha` | float | Surface en hectares |
| `type_sol` | enum | `limon` · `argile` · `sable` · `calcaire` · `tourbe` (influence sol initial) |
| `statut` | enum | `propriete` · `location` · `disponible_achat` · `disponible_location` · `indisponible` |
| `departement_id` | string | Département d'appartenance |
| `bassin_local_id` | string | Bassin local (sous-zone du département) |
| `etat_sol` | ref SolState | Référence vers l'état de sol de la parcelle |
| `activite_courante` | enum | `vide` · `grande_culture` · `maraichage` · `prairie` · `jachère` |
| `loyer_annuel` | float | Loyer annuel si en location (€/ha) |
| `prix_achat` | float | Prix d'achat si disponible (€/ha) |

**Territoire**

| Variable | Type | Description |
|---|---|---|
| `departement_id` | string | Code département |
| `nb_parcelles_disponibles` | int | Parcelles disponibles à l'achat ou location dans le département |
| `pression_fonciere` | float [0–100] | Tension sur le marché foncier local (influence prix et disponibilité) |
| `coop_bot_localisation` | string | Préfecture / capitale du département |

### Actions joueur

| Action | Prérequis | Coût | Effet |
|---|---|---|---|
| **Acheter une parcelle** | Parcelle `disponible_achat` ; argent suffisant | Prix d'achat (€/ha × surface) | Passe en `propriete` ; état sol hérité |
| **Louer une parcelle** | Parcelle `disponible_location` | Loyer annuel (prélevé chaque année) | Passe en `location` ; résiliable avec préavis |
| **Résilier une location** | Statut `location` | Préavis (délai) | Libère la parcelle ; retour en `disponible_location` |
| **Vendre une parcelle** | Statut `propriete` ; parcelle vide | — | Encaisse prix de vente ; parcelle retourne au marché |
| **Fusionner des parcelles** | ≥ 2 parcelles `propriete` contiguës (même bassin) | Coût administratif + délai (jours) | Crée une nouvelle parcelle unique ; **irréversible** |
| **Affecter une activité** | Parcelle `propriete` ou `location` ; stade `vide` | — | Définit l'activité prévue sur la parcelle |

> **[V2+]** Marché foncier joueur (vente entre joueurs), remembrement territorial, parcelles avec contraintes environnementales (zones humides, NATURA 2000).

### Règles de simulation

**Disponibilité foncière**
- Le nombre de parcelles disponibles par département est limité et évolue lentement.
- La `pression_fonciere` augmente si beaucoup de joueurs cherchent à acheter dans le même département → prix et loyers augmentent.
- Des parcelles se libèrent périodiquement (événements : départ à la retraite d'un exploitant bot, succession).

**Fusion permanente**
- La fusion est irréversible : deux parcelles de 10 ha fusionnées donnent une parcelle de 20 ha impossible à rediviser.
- Coût administratif fixe + délai de 7 jours (simulation des démarches).
- Avantage : réduction du temps machine par hectare (moins de déplacements) ; meilleure efficacité des travaux.
- Contrainte : les deux parcelles doivent être dans le même bassin local.

**Location vs propriété**
- Location : loyer annuel prélevé automatiquement ; le joueur ne peut pas fusionner une parcelle louée.
- Propriété : investissement initial élevé mais pas de loyer ; peut être fusionnée, vendue, transmise.

**Territoire départemental**
- Chaque joueur est ancré dans un département de départ.
- Il peut acquérir des parcelles dans d'autres départements, mais les coûts logistiques augmentent avec la distance.
- La coop bot est localisée dans la préfecture du département : livraisons vers la coop = coût logistique de base.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Vue parcelles | Liste avec surface, statut, activité, alerte sol | + type sol, état NPK/MO/pH, historique cultural, loyer/prix détaillé |
| Marché foncier | Parcelles disponibles avec prix indicatif | Pression foncière par bassin, tendance prix, comparaison loyer/achat |
| Fusion | Bouton "Fusionner" avec avertissement irréversible | Détail des gains d'efficacité machine estimés |
| Territoire | Vue département simple | Carte abstraite des bassins locaux avec indicateurs météo/sol |

### Interactions avec autres systèmes

- **Sols** : chaque parcelle porte son propre état de sol ; l'achat d'une parcelle dégradée est un risque calculé.
- **Météo** : le bassin local de la parcelle détermine les modificateurs météo locaux.
- **Stockage** : la distance entre parcelles et silos influence le coût logistique de transfert.
- **Marché** : le tag d'origine est lié au département de la parcelle.
- **Grandes cultures / Maraîchage / Élevage** : la surface totale des parcelles détermine la capacité de production maximale.


---

## 7. Stockage & logistique

> Décision figée : stockage = **contrainte moyenne structurante** ; logistique = **coût + délai** (flux fins = V2+).

### Variables d'état

**Silo / entrepôt**

| Variable | Type | Description |
|---|---|---|
| `stockage_id` | uuid | Identifiant |
| `type` | enum | `silo_cereales` · `entrepot_sec` · `chambre_froide` · `citerne_liquide` |
| `capacite_t` | float | Capacité maximale en tonnes (ou litres pour citerne) |
| `stock_actuel_t` | float | Volume actuellement stocké |
| `produit_stocke` | enum | Type de produit (blé, orge, lait, légumes…) |
| `qualite_stock` | float [0–100] | Qualité du stock (dégradation possible si mauvaises conditions) |
| `cout_stockage_j` | float | Coût journalier de stockage (€/t/jour) |
| `localisation` | ref Parcelle/Exploitation | Où se trouve le stockage |

**Logistique (mouvement)**

| Variable | Type | Description |
|---|---|---|
| `trajet_id` | uuid | Identifiant du mouvement en cours |
| `origine` | ref | Parcelle ou stockage source |
| `destination` | ref | Acheteur, coop bot, autre stockage |
| `volume_t` | float | Volume transporté |
| `cout_total` | float | Coût du transport (€) |
| `delai_j` | int | Jours avant arrivée à destination |
| `statut` | enum | `planifie` · `en_transit` · `livre` |

### Actions joueur

| Action | Prérequis | Coût | Effet |
|---|---|---|---|
| **Transférer vers silo** | Récolte disponible ; capacité silo suffisante | Travail + logistique (distance) | Déplace le stock de la parcelle vers le silo |
| **Vendre depuis silo** | Stock en silo ; acheteur disponible | Logistique (coût+délai selon distance) | Lance un trajet vers l'acheteur ; encaisse à la livraison |
| **Vendre à la coop bot** | Stock disponible | Logistique vers préfecture | Prix bot (spread) ; livraison garantie |
| **Vendre sur marché joueur** | Stock disponible | Logistique vers acheteur | Prix marché ; délai variable selon distance |
| **Construire un silo** | Argent + parcelle disponible | Investissement + délai construction | Augmente capacité de stockage |
| **Agrandir un silo** | Silo existant | Investissement + délai | Augmente `capacite_t` |
| **Utiliser transport coop bot** | Stock à livrer | Tarif transport coop | Délai standard ; libère la capacité machine joueur |

> **[V2+]** Gestion de tournées, optimisation de chargements, contrats de stockage tiers, qualité différenciée par lot.

### Règles de simulation

**Contrainte de stockage**
- Si `stock_actuel_t = capacite_t` : la récolte ne peut pas être transférée → vente forcée au prix spot (souvent défavorable).
- Le joueur doit anticiper la capacité avant la récolte (réservation prévisionnelle dans la file de tâches).

**Coût logistique**
```
cout_transport = volume_t × tarif_base_km × distance_km × facteur_meteo
```
- `distance_km` : calculée entre l'origine et la destination (abstrait : bassin → département → national).
- `facteur_meteo` : +20 % si événement météo bloquant en cours.
- Le délai est proportionnel à la distance : local (1 j), départemental (1–2 j), national (2–4 j).

**Dégradation du stock**
- Céréales en silo : dégradation très lente (-0.1 %/mois) si conditions normales.
- Produits frais (légumes, lait) : dégradation rapide (-5 pts/jour [0–100]) sans chambre froide.
- `qualite_stock` < 0.7 : décote sur le prix de vente.

**Coût de stockage journalier**
- Chaque tonne stockée génère un coût journalier (amortissement + énergie).
- Incite à vendre plutôt qu'à stocker indéfiniment.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Affichage | Jauge de remplissage + alerte saturation | Détail par produit, coût journalier, projection de saturation |
| Logistique | "Vendre" avec coût et délai affichés | Décomposition coût (distance, volume, météo), comparaison coop bot vs marché |
| Dégradation | Alerte "stock à vendre rapidement" | Taux de dégradation journalier + impact qualité sur prix |
| Planification | Alerte si récolte prévue > capacité disponible | Simulation de remplissage prévisionnel |

### Interactions avec autres systèmes

- **Grandes cultures / Maraîchage** : la récolte doit trouver un silo disponible ; sinon vente forcée.
- **Élevage** : le lait et les œufs ont une contrainte de fraîcheur forte.
- **Transformation** : le stock peut être orienté vers la transformation avant la vente.
- **Marché** : le stockage permet de différer la vente pour attendre un meilleur prix.
- **Météo** : événements extrêmes augmentent les délais et coûts logistiques.
- **Foncier** : les silos sont localisés sur des parcelles ; la distance aux champs influence le coût de transfert.

---

## 8. Transformation V1

> Décision figée : **quelques chaînes simples** en V1. Rôle : introduire la valeur ajoutée sans créer un jeu dans le jeu.

### Variables d'état

**Unité de transformation**

| Variable | Type | Description |
|---|---|---|
| `unite_id` | uuid | Identifiant |
| `type` | enum | `laiterie_simple` · `meunerie_simple` · `conserverie_simple` |
| `capacite_t_j` | float | Capacité de traitement par jour (tonnes/jour) |
| `stock_entrant_t` | float | Matière première en attente de traitement |
| `stock_sortant_t` | float | Produit transformé prêt à la vente |
| `en_fonctionnement` | bool | L'unité tourne ou est à l'arrêt |
| `cout_fixe_j` | float | Coût journalier de fonctionnement |

### Chaînes V1 retenues

| Matière première | Produit transformé | Ratio | Valeur ajoutée estimée |
|---|---|---|---|
| Lait (litres) | Produit laitier standard (kg) | 10 L → 1 kg | +30–50 % vs vente lait brut |
| Céréales (t) | Farine / aliment bétail (t) | 1 t → 0.85 t | +15–25 % vs vente grain |
| Légumes (kg) | Conserves / jus (kg/L) | 1 kg → 0.7 kg | +20–40 % vs vente frais |

> **[V2+]** Affinage fromage, labels AOP/IGP, transformation viande élaborée, filières longues, qualités différenciées, contrats de transformation avec d'autres joueurs.

### Actions joueur

| Action | Prérequis | Coût | Effet |
|---|---|---|---|
| **Construire une unité** | Argent + parcelle | Investissement + délai | Débloque la chaîne de transformation |
| **Lancer la transformation** | Stock entrant > 0 ; unité disponible | Coût opérationnel (énergie, main-d'œuvre) | Convertit stock entrant → stock sortant selon ratio |
| **Vendre produit transformé** | Stock sortant > 0 | Logistique | Encaisse prix transformé (supérieur au brut) |
| **Arrêter l'unité** | Unité en fonctionnement | — | Stoppe les coûts fixes ; stock entrant conservé |

### Règles de simulation

**Rentabilité**
- La transformation est rentable si : `(prix_transformé × ratio) - coût_opérationnel > prix_brut`.
- Elle n'est pas toujours rentable : si le prix brut est élevé (bonne saison), vendre brut peut être préférable.
- Cette tension crée une vraie décision pour le joueur.

**Capacité et délai**
- La transformation prend du temps : `jours_traitement = volume_t / capacite_t_j`.
- Pendant ce temps, le stock entrant est immobilisé (ne peut pas être vendu brut).

**Coûts fixes**
- L'unité génère un coût fixe journalier même à l'arrêt (amortissement).
- Incite à utiliser l'unité régulièrement pour amortir l'investissement.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| Affichage | Jauge entrée/sortie + rentabilité estimée (€) | Décomposition coûts, ratio détaillé, comparaison brut vs transformé |
| Décision | "Transformer" ou "Vendre brut" (choix simple) | Simulation de rentabilité avec prix actuels et prévisions |

### Interactions avec autres systèmes

- **Élevage** : lait → laiterie simple.
- **Grandes cultures** : céréales → meunerie/aliment bétail.
- **Maraîchage** : légumes → conserverie simple.
- **Stockage** : le stock entrant vient des silos/entrepôts ; le stock sortant retourne en stockage avant vente.
- **Marché** : les produits transformés ont un prix distinct des matières premières ; soumis au même spread bot.

---

## 9. Services V1

> Décision figée : **ETA bot** (travaux de champs) + **transport coop bot** (livraisons). Prestataires joueurs = **[V2+]**.

### Variables d'état

**ETA bot (prestataire travaux)**

| Variable | Type | Description |
|---|---|---|
| `service_id` | enum | `labour` · `semis` · `recolte` · `traitement` · `fertilisation` · `insemination` |
| `disponibilite` | float [0–100] | Capacité disponible du bot dans le département (peut être saturée en pic) |
| `delai_intervention_j` | int | Jours avant que le bot puisse intervenir |
| `tarif_ha` | float | Coût par hectare pour le service |
| `qualite_execution` | float [0–100] | Qualité d'exécution (légèrement inférieure à un joueur bien équipé) |

**Transport coop bot**

| Variable | Type | Description |
|---|---|---|
| `capacite_j` | float (t) | Tonnes transportables par jour dans le département |
| `tarif_t_km` | float | Tarif par tonne-kilomètre |
| `delai_standard_j` | int | Délai de livraison standard (1–2 jours local, 2–4 national) |
| `disponibilite` | float [0–100] | Saturation possible en période de récolte |

### Actions joueur

**ETA bot**

| Action | Prérequis | Coût | Effet |
|---|---|---|---|
| **Commander un travail ETA** | Tâche éligible ; bot disponible | Tarif ETA (€/ha) | Exécute la tâche avec délai ; libère travail+machine joueur |
| **Annuler une commande ETA** | Commande planifiée | Frais d'annulation | Remet la tâche dans la file joueur |

**Transport coop bot**

| Action | Prérequis | Coût | Effet |
|---|---|---|---|
| **Commander un transport** | Stock à livrer ; destination définie | Tarif transport (€/t) | Lance le trajet avec délai standard |
| **Suivre une livraison** | Trajet en cours | — | Affiche statut et ETA |

### Règles de simulation

**ETA bot — disponibilité**
- La disponibilité du bot diminue en période de pic (semis de printemps, récolte d'été).
- Si `disponibilite < 0.2` : délai d'intervention augmente (jusqu'à 3–5 jours).
- Le bot n'est jamais totalement indisponible (filet de sécurité), mais peut être coûteux en pic.

**ETA bot — qualité d'exécution**
- `qualite_execution` = 0.85 par défaut (légèrement sous-optimal vs joueur bien équipé).
- Cela se traduit par un léger malus sur `rendement_potentiel` (-5 à -10 %) pour les tâches déléguées.
- Incite le joueur à s'équiper plutôt qu'à déléguer systématiquement.

**Transport coop bot — tarification**
- Tarif fixe par tonne-kilomètre, légèrement supérieur au coût d'un transport joueur optimisé.
- Disponible 24h/24 ; pas de négociation de prix.
- En période de forte demande, le délai peut augmenter mais le tarif reste fixe.

**Équilibre économique**
- Les services bot sont rentables pour le joueur quand sa capacité travail/machine est saturée.
- Ils ne doivent pas être systématiquement plus rentables que l'investissement en équipement propre.

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|---|---|---|
| ETA bot | Bouton "Faire intervenir un prestataire" sur tâches éligibles ; coût + délai affichés | Détail coût décomposé, impact sur rendement, comparaison vs faire soi-même |
| Transport | "Envoyer à la coop" ou "Envoyer au marché" avec coût+délai | Détail tarif/km, capacité disponible, comparaison coop bot vs marché joueur |
| Disponibilité | Indicateur simple (disponible / délai allongé) | Taux de saturation par service, prévision de disponibilité sur 7 jours |

### Interactions avec autres systèmes

- **Grandes cultures / Maraîchage** : ETA bot exécute labour, semis, récolte, traitements.
- **Élevage** : insémination standard disponible via ETA bot.
- **Stockage & logistique** : transport coop bot est le principal vecteur de livraison vers la coop ou le marché.
- **Marché** : le coût du transport coop bot est déduit du prix de vente net.
- **Météo** : événements extrêmes peuvent retarder les interventions ETA et les transports.
- **Foncier** : la distance entre les parcelles et la coop bot (préfecture) détermine le coût de transport de base.

---

## Annexe — Récapitulatif des décisions figées appliquées

| Domaine | Décision appliquée dans cette spec |
|---|---|
| Activités V1 | Grandes cultures + élevage + maraîchage (§1, §2, §3) |
| Sols normal | Fertilité + humidité (§4) |
| Sols expert | NPK + MO + pH + historique cultural (§4) |
| Météo | Régionale + modificateurs locaux ; prévision avec incertitude (§5) |
| Foncier | Parcelles abstraites, fusion permanente, territoire départemental (§6) |
| Stockage | Contrainte moyenne structurante (§7) |
| Logistique | Coût + délai uniquement (§7) |
| Transformation | Quelques chaînes simples : lait, céréales, légumes (§8) |
| Services | ETA bot + transport coop bot (§9) |
| Market price | Spread bot + tag d'origine + rendements décroissants (§7, §9) |
| Events | Motivation secondaire ; concours/défis ; impact léger ; calendrier fixe (§5 météo, interactions) |
| Normal/Expert | Bascule par système ; profil global = preset (tous les §) |

## Annexe — Éléments explicitement hors scope V1

Tous les éléments ci-dessous sont **[V2+]** et ne doivent pas être implémentés en V1 :

- Viticulture, arboriculture, foresterie, horticulture, aquaculture
- Irrigation par pivot automatisé, agriculture de précision, modulation intra-parcellaire
- Sélection génétique animale, gestion fine de la ration, bien-être animal comme KPI
- Serres chauffées, hydroponie, circuits courts avec contrats joueurs
- Marché foncier joueur, remembrement territorial, contraintes environnementales parcellaires
- Gestion de tournées logistiques, optimisation de chargements, contrats de stockage tiers
- Affinage fromage, labels AOP/IGP, transformation viande élaborée, filières longues
- Prestataires joueurs spécialisés, services de conseil avancé, contrats de service complexes
- Assurance récolte avec contrats détaillés, stations météo locales achetables
- Sandbox joueur, scénarios scriptés, modes de jeu alternatifs
