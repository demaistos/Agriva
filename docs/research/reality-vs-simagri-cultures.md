# Cultures — Réalité vs SimAgri

> Date : 2026-08-03
> Statut : Document de référence
> Objectif : Analyse comparative exhaustive entre la réalité agricole française et la modélisation SimAgri pour les grandes cultures. Base de conception pour Agriva.

---

## Méthodologie

Pour chaque sous-processus :
1. **RÉALITÉ** — Comment ça fonctionne en France (données Agreste, ARVALIS, Chambres d'agriculture)
2. **SIMAGRI** — Comment le jeu le modélise
3. **CORRECT** — Ce que SimAgri fait bien
4. **SIMPLIFIÉ** — Simplifications acceptables pour un jeu
5. **FAUX/MANQUANT** — Erreurs ou lacunes significatives
6. **RECOMMANDATION AGRIVA** — Garder / Modifier / Ajouter

---

## 1. Préparation du sol

### 1.1 Labour

#### RÉALITÉ (France)

Le labour est un retournement complet de la couche arable à l'aide d'une charrue à socs ou à versoirs.

**Paramètres techniques :**
- **Profondeur** : 20-30 cm (labour classique), 15-20 cm (labour agronomique), rarement >30 cm
- **Période** : 
  - Labour d'automne (octobre-novembre) : sols argileux, avant cultures de printemps
  - Labour d'hiver (décembre-février) : action du gel sur les mottes (effet "gel-dégel")
  - Labour de printemps (mars) : sols légers, avant semis de printemps
- **Conditions requises** :
  - Sol ressuyé (capacité au champ) — ni trop sec (effort traction excessif), ni trop humide (lissage, semelle)
  - Humidité optimale : 60-80% de la capacité de rétention
  - Pas de gel profond (charrue ne pénètre pas)
  - Portance suffisante pour le tracteur (>0.5 bar de résistance)
- **Débit de chantier** : 0.8-1.5 ha/h selon largeur charrue (3-5 socs) et puissance tracteur
- **Consommation carburant** : 20-35 L/ha (le plus énergivore des travaux du sol)
- **Puissance requise** : 40-50 CV/soc (charrue 4 socs = 160-200 CV)
- **Coût** : 80-120 €/ha (prestation ETA)

**Tendances actuelles :**
- 60% des surfaces en France sont encore labourées au moins occasionnellement
- Tendance à la réduction du labour (TCS, semis direct) pour :
  - Économie de carburant et temps
  - Préservation de la vie biologique
  - Réduction de l'érosion
  - Stockage carbone

#### SIMAGRI

- La charrue existe dans le catalogue matériel
- Technique culturale "traditionnelle" implique le labour (vs TCS et semis direct)
- Consomme des PA (Points d'Action) et du HVC (carburant)
- Pas de notion de profondeur ni de conditions de sol
- Pas de période optimale modélisée pour le labour lui-même
- Impact indirect via le multiplicateur technique : traditionnelle = 1.0, TCS = 0.95, semis direct = 0.85

#### CORRECT
- Distinction entre techniques culturales (traditionnelle/TCS/semis direct)
- Consommation de carburant et temps de travail
- Le labour nécessite un tracteur suffisamment puissant

#### SIMPLIFIÉ (acceptable)
- Pas de notion de profondeur de labour
- Pas de conditions météo spécifiques pour labourer (sauf "forte pluie = impossible de travailler")
- Pas de risque de semelle de labour

#### FAUX ou MANQUANT
- Le rendement en semis direct est pénalisé à -15% systématiquement, alors qu'en réalité un semis direct bien conduit (après 5+ ans de transition) peut égaler le labour
- Pas de notion de structure du sol qui évolue dans le temps
- Pas de bénéfice environnemental modélisé (érosion, vie du sol)
- TCS à -5% est une approximation grossière : en réalité les TCS donnent souvent des rendements équivalents au labour

#### RECOMMANDATION AGRIVA
- **Garder** : les 3 techniques culturales comme choix stratégique
- **Modifier** : le malus semis direct devrait diminuer avec les années de pratique (courbe d'apprentissage du sol sur 3-5 ans)
- **Modifier** : TCS ne devrait pas avoir de malus systématique (-5% trop pénalisant)
- **Ajouter** : conditions de sol minimales (pas de travail sur sol gelé ou détrempé — lié à la météo)
- **Ajouter** : notion de compaction progressive si travail en mauvaises conditions

---

### 1.2 Déchaumage (post-récolte)

#### RÉALITÉ (France)

Le déchaumage est le premier travail du sol après moisson. Il est quasi-systématique.

**Objectifs :**
- Enfouir les résidus de récolte (chaumes) pour accélérer leur décomposition
- Provoquer la levée des adventices (faux-semis)
- Interrompre le cycle des ravageurs (limaces, pyrale)
- Incorporation superficielle de la paille broyée
- Préparer un lit de semence grossier pour un CIPAN ou la culture suivante

**Paramètres :**
- **Profondeur** : 5-10 cm (superficiel)
- **Période** : immédiatement après récolte (juillet-août pour céréales)
- **Outils** : déchaumeur à disques (cover-crop), déchaumeur à dents (type Smaragd), cultivateur lourd
- **Débit** : 3-5 ha/h
- **Consommation** : 8-15 L/ha
- **Coût** : 30-50 €/ha
- **Nombre de passages** : souvent 2 (un immédiatement, un 2-3 semaines après pour le faux-semis)

**Importance agronomique :**
- Gestion des limaces (destruction des œufs par assèchement)
- Gestion des repousses de la culture précédente
- Mélange paille/terre pour une décomposition rapide (ratio C/N)

#### SIMAGRI

- Les déchaumeurs existent dans le catalogue matériel (catégorie "travail du sol")
- Pas d'obligation de déchaumage entre deux cultures
- Pas de conséquence si on ne déchaûme pas
- Le broyage de paille est modélisé (restitution d'éléments au sol) mais séparé du déchaumage

#### CORRECT
- Les outils de déchaumage existent dans le catalogue
- Le broyage de paille comme alternative à la récolte de paille

#### SIMPLIFIÉ (acceptable)
- Pas d'obligation de faux-semis
- Pas de timing post-récolte critique

#### FAUX ou MANQUANT
- Aucune conséquence si on enchaîne récolte → semis sans travail intermédiaire
- Pas de gestion des résidus (impact sur maladies, limaces)
- Pas de notion de faux-semis (technique agronomique majeure en réduction de phytos)
- Pas de lien déchaumage → pression adventices pour la culture suivante

#### RECOMMANDATION AGRIVA
- **Ajouter** : le déchaumage comme opération bénéfique (réduction pression adventices -10-20% pour la culture suivante)
- **Ajouter** : conséquence si résidus non gérés (pression maladie +, limaces +)
- **Garder simple** : pas besoin de modéliser le nombre exact de passages

---

### 1.3 Travail superficiel (herse, cultivateur)

#### RÉALITÉ (France)

**Outils et usages :**
- **Herse rotative** : préparation fine du lit de semence (3-5 cm), souvent combinée au semoir
- **Cultivateur** : travail intermédiaire (10-20 cm), ameublissement sans retournement
- **Vibroculteur** : finition avant semis (5-8 cm)
- **Herse étrille** : désherbage mécanique (bio et conventionnel)
- **Rouleau (type Cambridge, Croskill)** : rappuyage du sol, casse-mottes, contact terre-graine

**Contexte TCS :**
En Techniques Culturales Simplifiées, ces outils remplacent la charrue :
- 2-3 passages de cultivateur/déchaumeur à profondeurs décroissantes
- Finition herse rotative ou vibroculteur

**Coûts :**
- Herse rotative : 20-35 €/ha
- Cultivateur : 25-40 €/ha
- Vibroculteur : 20-30 €/ha

#### SIMAGRI

- Herses rotatives et cultivateurs présents dans le catalogue
- Le rouleau est modélisé avec un bonus rendement (+3 à +5%)
- La herse de prairie existe (bonus croissance herbe +25%)
- Pas de distinction fine entre les outils de travail superficiel

#### CORRECT
- Bonus du rouleau sur le rendement (réaliste : meilleur contact terre-graine, moins de pertes à la levée)
- Présence des principaux outils dans le catalogue

#### SIMPLIFIÉ (acceptable)
- Pas de profondeur de travail paramétrable
- Tous les outils superficiels ont le même effet

#### FAUX ou MANQUANT
- Le bonus rouleau de +3-5% est un peu surestimé pour les céréales (réalité : +2-3% en conditions sèches, neutre en conditions humides)
- Pas de combinaison herse + semoir (combiné de semis)
- Pas de herse étrille pour le désherbage mécanique

#### RECOMMANDATION AGRIVA
- **Garder** : le bonus rouleau (calibrer à +2-4% selon conditions)
- **Ajouter** : herse étrille comme alternative au désherbage chimique (important pour le bio et les stratégies bas-intrants)
- **Ajouter** : les combinés (herse + semoir = 1 passage au lieu de 2, gain de PA/temps)

---

### 1.4 Conditions de sol (humidité, portance, gel)

#### RÉALITÉ (France)

**Fenêtres de travail :**
Les agriculteurs français ont en moyenne 150-180 jours "travaillables" par an, très variable selon :
- **Texture du sol** : les argiles sont praticables 100-120 jours, les sables 200+ jours
- **Pluviométrie régionale** : Bretagne/Nord = moins de jours disponibles que Beauce/Sud-Est
- **Saison** : automne et printemps = périodes critiques souvent humides

**Indicateurs praticiens :**
- **Test de la boulette** : presser une poignée de terre — si elle colle et se moule = trop humide
- **Portance** : profondeur d'enfoncement des roues (ornières >10 cm = stop)
- **Gel** : sol gelé superficiellement = rouleau OK, épandage OK ; gel profond = aucun travail du sol profond

**Conséquences d'un travail en mauvaises conditions :**
- Compaction en profondeur (semelle à 25-30 cm) → pénalité rendement 10-30% pendant 3-5 ans
- Lissage des parois (imperméabilisation) → problèmes de drainage
- Mottes grossières impossibles à reprendre → mauvaise levée

#### SIMAGRI

- **Seule restriction** : "forte pluie" (niveau 5) = impossible de travailler dans les parcelles
- Pas de notion de portance, d'humidité du sol, ni de gel
- Le vent empêche la pulvérisation uniquement
- Pas de conséquence à long terme d'un travail en conditions limites

#### CORRECT
- L'interdiction de travailler par forte pluie est un bon début

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser tous les types de sol avec leurs jours disponibles
- Simplifier à quelques niveaux de restriction météo

#### FAUX ou MANQUANT
- Seulement 1 niveau de restriction sur 5 est très insuffisant
- Pas de conséquence du travail en conditions limites (compaction)
- Le gel n'est pas modélisé comme facteur limitant les travaux
- Pas de variabilité régionale des fenêtres de travail
- Les sols argileux et sableux réagissent de la même façon à la météo

#### RECOMMANDATION AGRIVA
- **Modifier** : ajouter au moins 2-3 niveaux de praticabilité (OK / Risqué / Impossible) selon météo + type de sol
- **Ajouter** : le type de sol influence les jours disponibles (argile = plus de restrictions que sable)
- **Ajouter** : conséquence légère si travail en conditions "risquées" (compaction = -5% rendement sur 1-2 saisons)
- **Garder simple** : pas besoin de modéliser l'enfoncement des roues au cm près

---

### 1.5 Préparation du lit de semence

#### RÉALITÉ (France)

**Objectif :** Créer une couche superficielle (3-5 cm) de terre fine, rappuyée, avec un bon contact terre-graine pour assurer une levée homogène.

**Critères d'un bon lit de semence :**
- Terre fine en surface (agrégats <5 mm pour céréales, <2 mm pour betterave)
- Sol rappuyé en profondeur (pas de creux = enracinement continu)
- Humidité suffisante dans la zone de semis
- Absence de résidus en surface (sauf semis direct)

**Opérations typiques :**
- Après labour : 1 passage herse rotative ou vibroculteur
- En TCS : dernier passage de cultivateur à faible profondeur + rouleau
- Pour betterave/colza : exigence de finesse supérieure (petites graines)

**Impact sur la levée :**
- Bon lit de semence : 85-95% de levée
- Mauvais lit de semence : 50-70% de levée → compensé par sur-semis ou re-semis (coûteux)

#### SIMAGRI

- Pas de notion explicite de "lit de semence"
- On peut semer directement après achat de la parcelle
- Le rouleau apporte un bonus mais n'est pas lié à la préparation
- Pas de taux de levée modélisé

#### CORRECT
- Le rouleau comme opération bénéfique pré/post-semis

#### SIMPLIFIÉ (acceptable)
- Ne pas exiger une séquence précise d'outils avant semis
- Ne pas modéliser la taille des agrégats

#### FAUX ou MANQUANT
- Aucune préparation n'est requise avant semis (irréaliste)
- Pas de taux de levée (la densité semée = la densité levée implicitement)
- Pas de distinction entre cultures exigeantes (betterave, colza) et tolérantes (blé, orge)
- Pas de possibilité de re-semis en cas d'échec

#### RECOMMANDATION AGRIVA
- **Ajouter** : un "état de préparation" de la parcelle qui influence le taux de levée
- **Ajouter** : au moins 1 passage d'outil de travail du sol requis avant semis (sauf en semis direct)
- **Ajouter** : taux de levée variable (80-95%) selon la qualité de préparation et les conditions météo post-semis
- **Garder simple** : ne pas exiger la séquence exacte charrue → reprise → semoir




---

## 2. Fertilisation

### 2.1 Analyse de sol

#### RÉALITÉ (France)

**Fréquence :**
- Analyse complète tous les 4-5 ans (obligation en Zones Vulnérables pour le plan de fumure)
- Reliquats azotés sortie hiver (RSH) : chaque année en février (obligatoire en ZV)
- Analyses complémentaires ponctuelles (oligo-éléments, nématodes...)

**Paramètres mesurés :**
- **pH eau** : 6.0-7.5 optimal selon culture (blé = 6.5-7.5, pomme de terre = 5.5-6.5)
- **pH KCl** : pH "réserve", toujours inférieur au pH eau
- **Matière organique (MO)** : % de la terre fine (optimal : 2-4% selon sol)
- **Azote total** : en g/kg (C/N = 8-12 optimal)
- **Phosphore assimilable (P2O5)** : méthode Olsen ou Joret-Hébert selon pH
- **Potassium échangeable (K2O)** : en mg/kg ou ppm
- **CEC (Capacité d'Échange Cationique)** : en meq/100g (indicateur de fertilité)
- **Calcium (CaO), Magnésium (MgO)** : saturation du complexe
- **Oligo-éléments** : Bore, Manganèse, Zinc, Cuivre, Fer (si suspicion carence)
- **Granulométrie** : % argile, limon, sable (triangle des textures)

**Coût :**
- Analyse standard (pH, MO, P, K, CEC, Ca, Mg) : 50-80 €
- Analyse complète avec oligos : 100-150 €
- Reliquat azoté : 30-50 € par horizon (3 horizons = 90-150 €)

#### SIMAGRI

- Analyse de sol possible tous les 5 saisons (= 5 semaines réelles)
- Coût : 150 €
- Paramètres affichés : N, P, K, Ca, Mg, S (6 éléments, échelle 0-100)
- Pas de pH, pas de MO, pas de CEC, pas de granulométrie
- Pas de reliquat azoté

#### CORRECT
- Fréquence tous les 5 cycles est cohérente (5 ans réels)
- 6 éléments nutritifs couvrent l'essentiel
- Le coût de 150€ est dans l'ordre de grandeur

#### SIMPLIFIÉ (acceptable)
- Échelle 0-100 au lieu de valeurs en mg/kg ou ppm
- Pas de méthode d'analyse différente selon le pH
- Pas de notion d'horizon (profondeur d'échantillonnage)

#### FAUX ou MANQUANT
- **pH absent** : c'est LE paramètre le plus important (influence la disponibilité de tous les autres éléments)
- **Matière organique absente** : indicateur fondamental de la fertilité
- **CEC absente** : détermine la capacité du sol à retenir les éléments
- **Reliquat azoté absent** : base de tout calcul de fertilisation azotée
- Le soufre (S) est présent mais pas le Bore (essentiel pour le colza)
- Pas de conseil de fertilisation associé à l'analyse

#### RECOMMANDATION AGRIVA
- **Garder** : les 6 éléments NPK + Ca Mg S
- **Ajouter** : pH (influence l'efficacité des apports et le choix des cultures)
- **Ajouter** : taux de MO (évolue lentement, influence la structure et la rétention d'eau)
- **Ajouter** : un conseil simplifié post-analyse ("sol acide → chauler", "P faible → engrais de fond")
- **Optionnel** : CEC comme attribut fixe du type de sol (pas besoin de la mesurer en jeu)

---

### 2.2 Plan de fumure prévisionnel

#### RÉALITÉ (France)

**Obligation réglementaire :**
- Obligatoire dans toutes les Zones Vulnérables (ZV) aux nitrates = 70% de la SAU française
- Document écrit AVANT les apports, conservé 5 ans
- Contrôlable par la DDT (Direction Départementale des Territoires)

**Contenu :**
- Bilan azoté parcelle par parcelle (méthode du bilan prévisionnel)
- Dose totale N = Besoins culture − Fournitures sol (reliquat + minéralisation MO + précédent)
- Justification des apports P et K
- Calendrier prévisionnel d'épandage
- Prise en compte des apports organiques (fumier, lisier)

**Méthode du bilan azoté (simplifiée) :**
```
Dose N = (Objectif rendement × b) − RSH − Mn − Mh − Mr − Nirr − Xa
```
Où : b = besoin unitaire (kg N/q), RSH = reliquat, Mn = minéralisation nette, etc.

#### SIMAGRI

- Aucun plan de fumure
- Aucune limitation de dose
- Pas de bilan azoté
- On peut épandre autant d'engrais qu'on veut, autant de fois qu'on veut
- Pas de Zone Vulnérable

#### CORRECT
- (Rien de directement comparable)

#### SIMPLIFIÉ (acceptable)
- Ne pas exiger un document écrit dans un jeu
- Ne pas modéliser la réglementation ZV dans toute sa complexité

#### FAUX ou MANQUANT
- Aucune limite d'apport = irréaliste et anti-pédagogique
- En réalité, un excès d'azote est néfaste (verse du blé, pollution nappe, amende)
- Pas de notion de surfertilisation et ses conséquences
- Pas de rendement décroissant au-delà de l'optimum (loi des rendements décroissants)

#### RECOMMANDATION AGRIVA
- **Ajouter** : une dose optimale par culture au-delà de laquelle le rendement stagne ou diminue
- **Ajouter** : conséquence négative de la surfertilisation azotée (verse sur céréales, pollution → amende si contrôle)
- **Ajouter** : un système simplifié de "budget N" par parcelle basé sur l'objectif de rendement
- **Optionnel** : en mode "réaliste", obligation de justifier les apports (pédagogique)

---

### 2.3 Types d'engrais

#### RÉALITÉ (France)

**Engrais minéraux simples :**
| Engrais | Composition | Prix indicatif (€/t) | Usage |
|---------|-------------|---------------------|-------|
| Ammonitrate 33.5% | 33.5% N | 350-450 | Azote, fractionnement |
| Urée 46% | 46% N | 400-500 | Azote, moins cher/unité |
| Solution azotée 39 | 39% N (liquide) | 250-350 | Azote, pulvérisation |
| Superphosphate triple | 46% P2O5 | 400-500 | Phosphore |
| Chlorure de potasse | 60% K2O | 350-450 | Potassium |
| Sulfate d'ammoniaque | 21% N + 24% SO3 | 250-350 | Azote + Soufre |
| Kiesérite | 25% MgO + 50% SO3 | 300-400 | Magnésium + Soufre |

**Engrais composés (NPK) :**
- 18-46-0 (DAP) : starter au semis
- 15-15-15 : entretien équilibré
- 0-25-25 : fond P+K automne
- Formulations sur mesure selon analyse de sol

**Engrais organiques :**
| Produit | N | P2O5 | K2O | Dose/ha | Coût |
|---------|---|------|-----|---------|------|
| Fumier bovin | 5-6 | 3-4 | 8-10 | 25-35 t | 5-15 €/t + épandage |
| Lisier porc | 4-5 | 2-3 | 3-4 | 30-40 m³ | 2-8 €/m³ |
| Fientes volailles | 20-30 | 15-20 | 15-20 | 3-5 t | 20-40 €/t |
| Compost déchets verts | 8-10 | 4-5 | 8-10 | 15-20 t | 0-10 €/t |
| Digestat méthanisation | 4-6 | 2-3 | 5-8 | 25-30 m³ | 0-5 €/m³ |

#### SIMAGRI

- **Engrais** : un seul type générique, épandu avec épandeur d'engrais (centrifuge)
- **Fumier** : 25 t/ha, épandu avec épandeur à fumier → bonus rendement +10%
- **Lisier** : 15 m³/ha, épandu avec tonne à lisier
- **Compost** : 15 t/ha (3t fumier → 1t compost), apports NPK+Ca+Mg+S détaillés
- **Écume de sucrerie** : 15 t/ha, très riche en Ca
- **Digestat** : liquide (25 m³/ha) ou solide (25 t/ha), apports détaillés
- **Engrais vert/CIPAN** : moutarde, phacélie, seigle, ray-grass (broyage = restitution)

#### CORRECT
- Distinction engrais minéral / fumier / lisier / compost / digestat
- Doses de fumier (25 t/ha) et lisier (15 m³/ha) réalistes
- Les apports nutritifs du compost et du digestat sont détaillés et plausibles
- L'écume de sucrerie comme amendement calcique est réaliste

#### SIMPLIFIÉ (acceptable)
- Un seul type d'engrais minéral (pas de distinction ammonitrate/urée/solution)
- Effet binaire (fertilisé ou non = +15%)
- Pas de distinction fond/entretien

#### FAUX ou MANQUANT
- **L'engrais minéral est trop générique** : en réalité on dose N, P et K séparément
- **L'effet +15% (engrais) et +10% (fumier) est binaire** : en réalité c'est proportionnel à la dose
- **Pas de fractionnement** : l'azote doit être apporté en 2-3 fois (tallage, montaison, épiaison)
- **Pas de surfertilisation possible** : on ne peut pas mettre "trop"
- **Pas de volatilisation/lessivage** : conditions d'épandage non prises en compte
- **Pas de distinction engrais starter (au semis) vs couverture**
- Le soufre est modélisé dans le sol mais pas dans les engrais simples

#### RECOMMANDATION AGRIVA
- **Garder** : la distinction organique (fumier, lisier, compost, digestat) / minéral
- **Modifier** : l'engrais minéral doit permettre de doser N, P, K séparément (3 produits ou formulation)
- **Modifier** : l'effet doit être proportionnel à la dose (pas binaire)
- **Ajouter** : fractionnement de l'azote (2-3 apports = meilleure efficience vs 1 seul apport)
- **Ajouter** : conséquence d'une surfertilisation (verse, gaspillage économique)
- **Ajouter** : période d'interdiction d'épandage (simplifiée : pas d'azote en hiver)

---

### 2.4 Périodes d'épandage et interdictions

#### RÉALITÉ (France)

**Directive Nitrates — Zones Vulnérables (70% de la SAU) :**

| Type de fertilisant | Période d'INTERDICTION |
|--------------------|----------------------|
| Engrais azotés minéraux | 1er sept → 31 janv (grandes cultures) |
| Fumier/compost (C/N > 8) | 15 nov → 15 janv |
| Lisier/digestat liquide | 1er oct → 31 janv |
| Engrais sur CIPAN | Autorisé si couvert en place |

**Conditions d'épandage :**
- Sol non gelé (sauf fumier compact sur sol gelé superficiellement)
- Sol non enneigé
- Sol non saturé en eau (pas de ruissellement)
- Pente >7% : interdiction sauf techniques anti-ruissellement
- Distance cours d'eau : 35 m (ou 5m avec bande enherbée)
- Capacités de stockage obligatoires (4-6 mois selon zone)

#### SIMAGRI

- Aucune restriction de période d'épandage
- Aucune condition météo pour l'épandage
- Pas de notion de Zone Vulnérable
- On peut épandre à tout moment de l'année

#### CORRECT
- (Rien — aucune restriction modélisée)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser toutes les nuances réglementaires par zone

#### FAUX ou MANQUANT
- L'absence totale de restriction est irréaliste
- En France, épandre de l'azote en hiver est interdit et passible d'amendes
- Pas de notion d'efficience selon la date (azote au 1er mars vs azote au 15 avril)

#### RECOMMANDATION AGRIVA
- **Ajouter** : une période d'interdiction simplifiée pour les engrais azotés (pas d'azote minéral de novembre à janvier)
- **Ajouter** : efficience de l'apport selon le stade de la culture (apport au bon moment = 100%, apport trop tôt = 60% d'efficience)
- **Optionnel** : amendes si contrôle aléatoire et non-conformité (gameplay réglementaire)

---

### 2.5 Doses réelles par culture

#### RÉALITÉ (France)

**Doses moyennes d'azote (kg N/ha) — objectif rendement moyen :**

| Culture | N total | P2O5 | K2O | Soufre |
|---------|---------|------|-----|--------|
| Blé tendre (80 q/ha) | 170-200 | 50-60 | 50-60 | 30-40 |
| Blé dur (60 q/ha) | 200-230 | 50-60 | 50-60 | 40-50 |
| Orge hiver (70 q/ha) | 140-170 | 50-60 | 60-70 | 25-35 |
| Orge printemps (55 q/ha) | 100-130 | 40-50 | 50-60 | 20-30 |
| Maïs grain (100 q/ha) | 180-220 | 60-80 | 80-100 | 20-30 |
| Colza (35 q/ha) | 150-180 | 60-80 | 60-80 | 60-75 |
| Tournesol (25 q/ha) | 60-80 | 50-60 | 80-100 | 20-30 |
| Pois | 0 (fixation) | 40-50 | 60-80 | 20 |
| Betterave (850 q/ha) | 120-150 | 60-80 | 150-200 | 30-40 |
| Pomme de terre (450 q/ha) | 150-180 | 80-100 | 200-250 | 30-40 |

**Prix de l'unité fertilisante (2024-2025) :**
- N : 1.0-1.5 €/unité
- P2O5 : 1.2-1.8 €/unité
- K2O : 0.9-1.3 €/unité

#### SIMAGRI

- Un seul type d'engrais → pas de notion de dose N/P/K séparée
- Effet binaire : fertilisé = +15%, non fertilisé = 0%
- Les éléments du sol sont consommés par la culture (N, P, K, Ca, Mg, S diminuent)
- Pas de notion de dose optimale par culture

#### CORRECT
- Les éléments du sol diminuent avec les cultures (exportations modélisées)
- Chaque culture a des besoins différents (implicite dans le nutrientFactor)

#### SIMPLIFIÉ (acceptable)
- Ne pas exiger la dose exacte en kg/ha par élément

#### FAUX ou MANQUANT
- Impossible de doser : c'est "on/off"
- Le pois devrait avoir besoin de 0 N (fixation symbiotique) — pas distingué
- Pas de notion de coût proportionnel à la dose
- La betterave et la pomme de terre ont des besoins K très élevés — pas différencié

#### RECOMMANDATION AGRIVA
- **Modifier** : remplacer le booléen par un système de doses (au minimum : faible/moyen/fort par élément)
- **Ajouter** : les légumineuses (pois, féverole) fixent l'azote atmosphérique (N = 0, et bonus N pour la culture suivante)
- **Ajouter** : coût proportionnel à la quantité épandue
- **Ajouter** : rendement qui suit une courbe de réponse (pas linéaire : plateau puis décroissance)

---

### 2.6 Fractionnement des apports azotés

#### RÉALITÉ (France)

Le fractionnement est LA technique agronomique clé pour optimiser l'efficience de l'azote.

**Céréales d'hiver (blé, orge) — 3 apports typiques :**

| Apport | Stade | Date indicative | % de la dose totale | Objectif |
|--------|-------|----------------|--------------------:|----------|
| 1er apport | Tallage (BBCH 21-25) | Février-début mars | 30-40% | Nombre de talles |
| 2ème apport | Épi 1 cm / Montaison (BBCH 30-31) | Mars-avril | 40-50% | Nombre d'épis |
| 3ème apport | Dernière feuille / Épiaison (BBCH 39-55) | Mai | 20-30% | Protéines grain |

**Colza — 2 apports :**
| Apport | Stade | Date | % dose |
|--------|-------|------|-------:|
| 1er | Reprise végétation | Février | 60% |
| 2ème | Montaison-boutons | Mars | 40% |

**Maïs — 1-2 apports :**
| Apport | Stade | Date | % dose |
|--------|-------|------|-------:|
| 1er (starter) | Semis | Avril-Mai | 30% (localisé) |
| 2ème | 6-8 feuilles | Juin | 70% |

**Pourquoi fractionner :**
- Réduire les pertes par lessivage (azote apporté trop tôt = lessivé par les pluies)
- Adapter la dose au potentiel réel (ajustement du 3ème apport selon état du peuplement)
- Réglementaire : dose totale en 1 fois interdite en ZV (max 80 kg N/apport pour le 1er)
- Efficience : +10-20% d'efficience de l'azote fractionné vs dose unique

#### SIMAGRI

- **Aucun fractionnement** : l'engrais est appliqué une seule fois (binaire)
- Pas de notion de stade cultural pour l'apport
- Pas de date optimale d'application
- Pas de lien entre moment d'apport et composante de rendement ciblée

#### CORRECT
- (Rien — le fractionnement n'existe pas dans SimAgri)

#### SIMPLIFIÉ (acceptable)
- Ne pas exiger 3 passages exactement calés sur les stades BBCH

#### FAUX ou MANQUANT
- Le fractionnement est la BASE de la fertilisation azotée en France — son absence est un manque majeur
- Pas de lien stade/apport → pas de stratégie agronomique
- Pas de "pilotage" de l'azote (ajustement selon l'état réel de la culture)
- Le 3ème apport (qualité protéines) n'existe pas → pas de notion de protéines du grain

#### RECOMMANDATION AGRIVA
- **Ajouter** : possibilité de fractionner l'azote en 2-3 apports
- **Ajouter** : bonus de rendement si apport au bon stade (vs malus si tout en 1 fois)
- **Ajouter** : le 3ème apport influence la qualité (protéines) et non le rendement
- **Garder simple** : proposer 3 "fenêtres" (début / milieu / fin de cycle) plutôt que des stades BBCH exacts

---

### 2.7 Amendements calciques (chaulage)

#### RÉALITÉ (France)

**Objectif :** Maintenir le pH du sol dans une fourchette optimale (6.0-7.5 pour la plupart des cultures).

**Produits :**
- Chite de sucrerie (écume) : 40-50% CaO, ~30 €/t
- Carbonate de calcium (CaCO3) : 50-55% CaO, ~40-60 €/t
- Chaux vive (CaO) : 80-90% CaO, action rapide, ~80-100 €/t
- Dolomie : CaCO3 + MgCO3, double action Ca+Mg, ~50-70 €/t

**Doses :**
- Entretien : 300-800 kg CaO/ha tous les 3-5 ans
- Redressement : 1500-3000 kg CaO/ha (sol très acide)
- Dose unique recommandée max : 2000 kg CaO/ha

**Fréquence :**
- Analyse pH tous les 4-5 ans
- Apport d'entretien tous les 3-5 ans sur sols sensibles à l'acidification
- Sols calcaires (Beauce, Champagne) : jamais besoin de chauler

**Conséquences d'un pH trop bas (<6.0) :**
- Toxicité aluminium (bloque les racines)
- Indisponibilité du phosphore
- Mauvaise activité biologique
- Rendement -20 à -40% dans les cas sévères

#### SIMAGRI

- **Écume de sucrerie** : 15 t/ha, une fois tous les 5 ans, apport Ca = 3600 unités
- Stockable en fosse à fumier
- Épandue à l'épandeur à fumier
- Pas d'autre forme de chaulage

#### CORRECT
- L'écume de sucrerie est un vrai produit utilisé en France
- Fréquence (1x/5 ans) est réaliste pour un entretien
- L'apport calcique est très élevé (réaliste pour l'écume)

#### SIMPLIFIÉ (acceptable)
- Un seul produit d'amendement calcique
- Pas de notion de pH explicite

#### FAUX ou MANQUANT
- Pas de pH dans le sol → le joueur ne sait pas s'il a besoin de chauler ou non
- Pas de conséquence d'un sol acide (pas de toxicité, pas de blocage P)
- Les sols calcaires n'ont pas besoin d'écume — pas de distinction
- Pas de chaux vive ou de carbonate (alternatives à l'écume)

#### RECOMMANDATION AGRIVA
- **Garder** : l'écume de sucrerie comme produit principal
- **Ajouter** : le pH comme paramètre du sol (lié au type de sol)
- **Ajouter** : conséquence d'un pH trop bas (malus rendement progressif)
- **Ajouter** : les sols calcaires n'ont jamais besoin de chaulage (caractéristique du type de sol)
- **Optionnel** : un 2ème produit (chaux/carbonate) pour les zones sans sucrerie

---

### 2.8 Engrais de fond vs entretien

#### RÉALITÉ (France)

**Engrais de fond (P, K) :**
- Apportés à l'automne, avant labour ou en surface
- Objectif : maintenir le stock du sol en P et K
- Fréquence : tous les ans ou tous les 2-3 ans en dose groupée
- Ne se lessive pas (P et K fixés sur le complexe argilo-humique)
- Dose = exportations de la culture (raisonnement "bilan")

**Engrais d'entretien (N) :**
- Apportés au printemps, en couverture
- Objectif : nourrir la culture en cours
- Fréquence : chaque année, fractionnés
- Se lessive facilement (azote = mobile dans le sol)
- Dose = bilan prévisionnel (besoins − fournitures sol)

**Logique agronomique :**
- P et K = gestion du STOCK (patrimoine sol, long terme)
- N = gestion du FLUX (nutrition annuelle, court terme)

#### SIMAGRI

- Pas de distinction fond/entretien
- Un seul geste "fertiliser" qui affecte tout
- Les éléments du sol sont tous traités de la même façon (diminution uniforme)

#### CORRECT
- Les 6 éléments du sol évoluent indépendamment

#### SIMPLIFIÉ (acceptable)
- Ne pas distinguer les dynamiques de chaque élément

#### FAUX ou MANQUANT
- N, P et K n'ont pas du tout le même comportement dans le sol :
  - N : très mobile, se lessive en hiver → besoin d'apports fréquents
  - P : très peu mobile → stock long terme, rare de descendre vite
  - K : intermédiaire
- Pas de notion de "capital sol" en P/K qui se constitue sur des années

#### RECOMMANDATION AGRIVA
- **Ajouter** : dynamiques différentes pour N (diminue vite, se lessive) vs P/K (diminuent lentement)
- **Ajouter** : le N apporté en automne est partiellement perdu (lessivage hivernal = 30-50% de perte)
- **Garder simple** : le joueur n'a pas besoin de comprendre la chimie du sol, juste que "N en hiver = gaspillage"




---

## 3. Semis

### 3.1 Densités réelles par culture

#### RÉALITÉ (France)

| Culture | Densité semis | PMG (g) | Dose kg/ha | Écartement |
|---------|--------------|---------|-----------|------------|
| Blé tendre | 250-350 grains/m² | 45-55 | 120-180 | 12.5-17 cm |
| Blé dur | 300-350 grains/m² | 45-55 | 140-190 | 12.5-17 cm |
| Orge hiver | 250-300 grains/m² | 45-55 | 120-160 | 12.5-17 cm |
| Orge printemps | 300-350 grains/m² | 45-50 | 140-175 | 12.5-17 cm |
| Maïs grain | 8-10 grains/m² | 250-350 | 20-25 (doses) | 75-80 cm |
| Colza | 30-50 grains/m² | 4-6 | 2-4 | 17-45 cm |
| Tournesol | 6-7.5 grains/m² | 50-80 | 5-6 (doses) | 50-80 cm |
| Pois | 70-90 grains/m² | 200-300 | 200-250 | 12.5-40 cm |
| Betterave | 11-13 grains/m² (monograine) | 10-15 | 1.2-1.5 (unités) | 45-50 cm |
| Pomme de terre | 4-5 tubercules/m² | - | 2500-3500 kg | 75-90 cm |

**Coût semences :**
- Blé certifié : 50-80 €/ha
- Blé fermier (trié à la ferme) : 20-35 €/ha
- Maïs hybride : 150-200 €/ha (pas de semence fermière possible)
- Colza hybride : 60-90 €/ha
- Tournesol : 80-120 €/ha
- Betterave (dose monograine) : 200-250 €/ha
- Pomme de terre (plants) : 800-1500 €/ha

#### SIMAGRI

- `seed_qty_per_ha` : donnée de référence par culture (défaut 150 kg/ha dans le schéma)
- Semences achetées en coopérative (SimAgri ou CAR)
- Distinction semence G (certifiée), P (fermière), GP (les deux)
- Semoir standard pour céréales, semoir monograine pour maïs/betterave/tournesol
- Pas de notion de densité en grains/m²
- Pas de notion de PMG

#### CORRECT
- Distinction semence certifiée (G) vs fermière (P) est pertinente
- Semoirs différents selon le type de culture (classique vs monograine)
- Coût des semences comme intrant économique

#### SIMPLIFIÉ (acceptable)
- Dose en kg/ha plutôt qu'en grains/m² (simplifie le calcul)
- Pas de PMG variable selon les variétés
- Pas d'écartement paramétrable

#### FAUX ou MANQUANT
- La dose par défaut de 150 kg/ha ne convient pas à toutes les cultures (maïs = 20 kg, colza = 3 kg, PDT = 3000 kg)
- Pas de notion de variété (précoce, tardive, résistante...)
- Pas de surdensité compensatoire (si semis tardif → +10-15% de densité)
- Pas de peuplement réel (grains semés ≠ plantes levées)
- Semence fermière : pas de tri à la ferme modélisé, pas de qualité variable

#### RECOMMANDATION AGRIVA
- **Garder** : la distinction certifiée/fermière avec impact économique
- **Modifier** : dose de semence réaliste par culture (calibrer les données de référence)
- **Ajouter** : notion de variété (au minimum précoce/tardive) qui influence dates et rendement
- **Ajouter** : la semence fermière a un rendement légèrement inférieur (-3-5%) sauf si "trieur à la ferme" (investissement bâtiment)
- **Optionnel** : taux de levée variable selon conditions (simplifié en multiplicateur)

---

### 3.2 Profondeur de semis

#### RÉALITÉ (France)

| Culture | Profondeur optimale | Tolérance |
|---------|--------------------:|-----------|
| Blé | 2-3 cm | 1.5-4 cm |
| Orge | 2-3 cm | 1.5-4 cm |
| Colza | 1-2 cm | 0.5-3 cm (très sensible) |
| Maïs | 4-5 cm | 3-6 cm |
| Tournesol | 3-4 cm | 2.5-5 cm |
| Betterave | 2-2.5 cm | 1.5-3 cm (très sensible) |
| Pois | 4-5 cm | 3-6 cm |
| Pomme de terre | 8-12 cm | 6-15 cm |

**Conséquences :**
- Trop profond : levée lente, plants chétifs, pertes d'énergie
- Trop superficiel : dessèchement, gel, oiseaux (corbeau sur maïs)
- Régulée par le semoir (réglage mécanique ou pneumatique)

#### SIMAGRI

- Aucune notion de profondeur de semis
- Le semis est un acte unique sans paramètre de réglage

#### CORRECT
- (Rien — non modélisé)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser la profondeur de semis comme paramètre joueur

#### FAUX ou MANQUANT
- Pas critique pour un jeu — la profondeur est un réglage mécanique que l'agriculteur fait une fois

#### RECOMMANDATION AGRIVA
- **Ne pas ajouter** : trop technique, pas d'intérêt gameplay. La profondeur est implicite dans "faire un semis correct"
- **Optionnel** : si on modélise la qualité du semis, la profondeur peut être un facteur interne (pas une action joueur)

---

### 3.3 Dates optimales par région et culture

#### RÉALITÉ (France)

**Céréales d'hiver :**
| Culture | Nord France | Centre | Sud |
|---------|------------|--------|-----|
| Blé tendre | 10-30 oct | 15 oct-10 nov | 20 oct-20 nov |
| Orge hiver | 1-20 oct | 5-25 oct | 10 oct-5 nov |
| Blé dur | - | 20 oct-15 nov | 25 oct-25 nov |
| Triticale | 5-25 oct | 10 oct-5 nov | 15 oct-15 nov |

**Colza (semis d'été) :**
| Région | Date optimale |
|--------|--------------|
| Nord | 20 août - 5 sept |
| Centre | 25 août - 10 sept |
| Sud | 1-15 sept |

**Cultures de printemps :**
| Culture | Date optimale (Centre France) | Condition sol |
|---------|------------------------------|--------------|
| Orge printemps | 15 fév - 15 mars | T° sol > 5°C |
| Pois | 15 fév - 15 mars | T° sol > 5°C |
| Betterave | 15 mars - 10 avril | T° sol > 8°C |
| Maïs | 15 avril - 10 mai | T° sol > 10°C |
| Tournesol | 1 avril - 1 mai | T° sol > 8°C |
| Soja | 20 avril - 20 mai | T° sol > 12°C |

**Conséquences d'un semis tardif :**
- Céréales hiver : -1 à -2 q/ha par semaine de retard (tallage insuffisant)
- Colza : -2 à -5 q/ha par semaine de retard (biomasse entrée hiver insuffisante)
- Maïs : variété plus précoce obligatoire, rendement potentiel réduit

#### SIMAGRI

- Chaque culture a des mois de semis autorisés (`sow_months`) : ex. blé = [10, 11] (Oct-Nov)
- Pas de date optimale au sein de la fenêtre
- Pas de différence régionale pour les dates de semis
- Pas de pénalité pour semis précoce ou tardif dans la fenêtre
- Hors fenêtre = semis impossible

#### CORRECT
- Les fenêtres de semis par culture sont globalement correctes
- L'interdiction de semer hors fenêtre est une bonne simplification

#### SIMPLIFIÉ (acceptable)
- Fenêtre de semis mensuelle (pas au jour près)
- Pas de date optimale intra-fenêtre

#### FAUX ou MANQUANT
- **Pas de variabilité régionale** : le colza se sème fin août au Nord, mi-septembre au Sud
- **Pas de pénalité semis tardif** : en réalité c'est un facteur majeur de rendement
- **Pas de condition température sol** : on ne peut pas semer du maïs si le sol est à 6°C
- **Pas d'ajustement densité** si semis tardif

#### RECOMMANDATION AGRIVA
- **Garder** : les fenêtres de semis comme garde-fou
- **Ajouter** : date optimale au sein de la fenêtre (bonus si semis dans le créneau idéal)
- **Ajouter** : pénalité progressive pour semis tardif (-1 à -3% par "semaine" de retard)
- **Ajouter** : variabilité régionale des fenêtres (au moins Nord/Centre/Sud)
- **Ajouter** : condition de température minimale du sol (liée à la saison/météo)

---

### 3.4 Conditions requises pour le semis

#### RÉALITÉ (France)

**Température du sol :**
- Céréales d'hiver : >5°C (germination)
- Colza : >10°C (été, pas un problème)
- Pois : >5°C
- Betterave : >8°C (risque montée à graine si froid post-levée)
- Maïs : >10°C (zéro de végétation du maïs = 6°C)
- Tournesol : >8°C
- Soja : >12°C

**Humidité du sol :**
- Suffisante pour la germination (contact terre-graine humide)
- Pas trop élevée (risque fonte de semis, compaction au passage du semoir)
- Idéal : sol ressuyé (capacité au champ)

**Autres conditions :**
- Pas de gel annoncé dans les 48h post-semis (sauf céréales d'hiver, tolérantes)
- Prévisions météo favorables (pas de pluie battante qui croûte le sol)
- Sol suffisamment réchauffé (cumul de températures positives)

#### SIMAGRI

- Seule restriction : forte pluie = impossible de travailler
- Pas de température de sol
- Pas de condition d'humidité
- On peut semer en décembre un maïs (si c'était dans la fenêtre, ce qui n'est pas le cas)

#### CORRECT
- La fenêtre de semis (par mois) empêche indirectement les semis aberrants

#### SIMPLIFIÉ (acceptable)
- La fenêtre mensuelle filtre les situations les plus absurdes

#### FAUX ou MANQUANT
- Pas de lien météo récente → conditions de semis
- Un semis juste après forte pluie devrait être pénalisé (croûte de battance)
- Pas de risque de gel post-semis pour les cultures de printemps

#### RECOMMANDATION AGRIVA
- **Ajouter** : lien entre météo des jours précédents et qualité du semis
- **Ajouter** : pour les cultures de printemps, un gel post-semis provoque des pertes (re-semis partiel)
- **Garder simple** : pas besoin de thermomètre de sol en temps réel — utiliser la date + zone comme proxy

---

### 3.5 Coût semences certifiées vs fermières

#### RÉALITÉ (France)

| Culture | Certifiée (€/ha) | Fermière (€/ha) | Économie | Contraintes fermière |
|---------|------------------|-----------------|----------|---------------------|
| Blé tendre | 50-80 | 20-35 | 40-55% | Tri, CVO (6-9€/t), -3% rendement potentiel |
| Orge | 55-85 | 25-40 | 40-55% | Tri, CVO |
| Triticale | 45-70 | 20-30 | 45-55% | Tri, CVO |
| Colza | 60-90 | Impossible | - | Hybride F1 obligatoire |
| Maïs | 150-200 | Impossible | - | Hybride F1 |
| Tournesol | 80-120 | Impossible | - | Hybride F1 |
| Betterave | 200-250 | Impossible | - | Hybride monogerme |
| Pois | 80-120 | 50-70 | 30-40% | Tri, qualité sanitaire |
| Pomme de terre | 800-1500 | 500-800 | 30-40% | Risque sanitaire (virus) |

**CVO (Contribution Volontaire Obligatoire)** : taxe sur les semences fermières de céréales (6-9 €/t récoltée), finance la recherche variétale.

**Trieur à la ferme** : investissement 15 000-40 000 € pour trier et traiter ses semences.

#### SIMAGRI

- Types : G (certifié), P (fermier), GP (les deux)
- Pas de différence de prix explicite entre G et P dans les règles consultées
- Pas de contrainte sur les hybrides (colza, maïs, tournesol peuvent théoriquement être en semence fermière)
- Pas de CVO
- Pas de trieur

#### CORRECT
- La distinction G/P existe et est un choix économique

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser la CVO (micro-gestion)
- Simplifier les contraintes hybrides

#### FAUX ou MANQUANT
- **Les hybrides doivent être OBLIGATOIREMENT en certifié** (maïs, tournesol, colza, betterave) — c'est une contrainte économique majeure
- Pas de différence de performance entre G et P
- Pas d'investissement "trieur" pour valoriser la semence fermière
- Pas d'impact sanitaire de la semence fermière (risque maladie si non traitée)

#### RECOMMANDATION AGRIVA
- **Garder** : la distinction certifié/fermier
- **Ajouter** : les hybrides (maïs, tournesol, colza, betterave) = certifié obligatoire
- **Ajouter** : la semence fermière est moins chère mais légèrement moins performante (-3-5%)
- **Ajouter** : investissement optionnel "trieur à grains" qui réduit le malus fermier
- **Gameplay** : c'est un choix stratégique intéressant (économie vs performance)

---

### 3.6 Traitement de semences

#### RÉALITÉ (France)

**Objectifs :**
- Protection contre les maladies fongiques de la levée (fonte de semis : Fusarium, Microdochium)
- Protection contre les ravageurs du sol (taupins, mouche grise)
- Stimulation de la levée (micro-nutriments, biostimulants)

**Produits courants :**
- **Fongicides semence** : Celest (fludioxonil), Vibrance (sedaxane) — quasi-systématiques sur céréales
- **Insecticides semence** : Force 20CS (téfluthrine) sur maïs — contre taupins
- **Néonicotinoïdes** : INTERDITS en France depuis 2018 (sauf dérogations betterave, retirées en 2023)
- **Biostimulants** : mycorhizes, Trichoderma, bactéries PGPR

**Coûts :**
- Traitement fongicide semence : 5-15 €/ha
- Traitement insecticide semence : 15-30 €/ha
- Inclus dans le prix de la semence certifiée (traitement industriel)
- En semence fermière : coût supplémentaire du traitement à façon (10-20 €/ha)

**Réglementation :**
- Les néonicotinoïdes (Gaucho, Cruiser) sont interdits depuis 2018
- Liste de produits autorisés en constante évolution (retraits réguliers)
- Le traitement de semence en bio est très limité (cuivre, soufre, antagonistes biologiques)

#### SIMAGRI

- Le "traitement de semences" n'est pas modélisé comme tel
- Les traitements sont : fongicide, herbicide, insecticide — appliqués en végétation
- Pas de distinction entre traitement semence et traitement en cours de culture
- `is_treated` est un objet JSON avec 3 booléens (fongicide, herbicide, insecticide)

#### CORRECT
- Les 3 catégories de traitement existent (fongicide, herbicide, insecticide)

#### SIMPLIFIÉ (acceptable)
- Pas de distinction semence traitée vs traitement en végétation
- Le traitement semence est "inclus" dans le prix de la semence certifiée (implicite)

#### FAUX ou MANQUANT
- Pas d'impact spécifique du non-traitement de semence (attaques précoces : taupins, fonte semis)
- En bio : l'absence de traitement semence est un vrai risque (pertes de levée)
- Pas de ravageurs du sol modélisés (taupins = jusqu'à 30% de pertes sur maïs)

#### RECOMMANDATION AGRIVA
- **Garder simple** : le traitement semence est implicite dans la semence certifiée
- **Ajouter** : en semence fermière, option "traitement à façon" (coût + protection)
- **Ajouter** : risque de ravageurs du sol (taupins) si parcelle à risque + pas de protection → pertes de levée
- **En bio** : pas de traitement insecticide semence → risque accru de pertes précoces




---

## 4. Protection des cultures

### 4.1 Herbicides

#### RÉALITÉ (France)

**Stratégies de désherbage :**

| Timing | Stade | Produits types | Cible |
|--------|-------|---------------|-------|
| Pré-semis | Avant semis | Glyphosate (si autorisé) | Vivaces, faux-semis raté |
| Pré-levée | BBCH 00-09 | Chlortoluron, pendiméthaline, prosulfocarbe | Graminées + dicot annuelles |
| Post-levée précoce | BBCH 12-21 | Atlantis, Abak, Archipel | Vulpin, ray-grass, dicot |
| Post-levée tardif | BBCH 25-32 | Axial, hormones (2,4-D) | Rattrapages |

**Programmes de désherbage (blé tendre) :**
- **Programme complet** : pré-levée (automne) + rattrapage printemps = 80-120 €/ha
- **Tout printemps** : 1 ou 2 passages post-levée = 50-90 €/ha
- **Désherbage mécanique** : herse étrille (bio) = 15-25 €/ha/passage × 2-3 passages

**Problématiques majeures :**
- Résistances : vulpin résistant aux inhibiteurs d'ALS (50% des populations en Picardie)
- Ray-grass résistant au glyphosate (émergent)
- Brome : adventice en expansion, peu de solutions chimiques
- Chardon, rumex (vivaces) : difficiles en non-labour

**IFT herbicide moyen France :**
- Blé tendre : 1.5-2.0
- Maïs : 1.0-1.5
- Colza : 1.5-2.5
- Betterave : 3.0-4.0 (culture très sensible à la concurrence)

#### SIMAGRI

- Herbicide = 1 traitement générique, 1.6 L/ha, 9 €/L = 14.4 €/ha
- Effet binaire : traité ou non
- Pas de timing (pré-levée vs post-levée)
- Pas de niveau d'enherbement
- Pas de résistance aux herbicides
- `is_treated.herbicide = true/false`
- Pas de désherbage mécanique comme alternative

#### CORRECT
- L'herbicide existe comme catégorie de traitement
- Il y a un coût associé

#### SIMPLIFIÉ (acceptable)
- Un seul type d'herbicide générique
- Pas de programmes complexes multi-passages

#### FAUX ou MANQUANT
- **Prix très sous-estimé** : 14.4 €/ha vs réalité 50-120 €/ha
- **Pas de timing** : le désherbage d'automne (pré-levée) est crucial pour les céréales d'hiver
- **Pas de pression adventices variable** : selon le précédent, la rotation, les années
- **Pas de résistance** : un problème agronomique majeur en France
- **Pas de désherbage mécanique** : essentiel pour le bio et les stratégies bas-intrants
- **Pas de conséquence du non-désherbage** : en réalité = -10 à -50% de rendement selon la pression

#### RECOMMANDATION AGRIVA
- **Garder** : l'herbicide comme catégorie de traitement
- **Modifier** : prix réaliste (50-100 €/ha pour un programme standard)
- **Ajouter** : pression adventices qui évolue (augmente sans désherbage, diminue avec bonnes rotations)
- **Ajouter** : désherbage mécanique comme alternative (herse étrille) — moins efficace mais compatible bio
- **Ajouter** : conséquence progressive du non-désherbage (pas binaire mais proportionnel à la pression)
- **Optionnel** : notion de résistance (si même produit utilisé 5+ ans de suite → perte d'efficacité)

---

### 4.2 Fongicides

#### RÉALITÉ (France)

**Programme fongicide blé (3 traitements typiques) :**

| Traitement | Stade BBCH | Période | Cible | Produit type | Coût |
|------------|-----------|---------|-------|-------------|------|
| T1 | 30-32 (1-2 nœuds) | Avril | Piétin verse, septoriose basse | Prothioconazole | 25-35 €/ha |
| T2 | 37-39 (dernière feuille) | Mai | Septoriose feuilles | SDHI + triazole | 35-50 €/ha |
| T3 | 55-65 (épiaison-floraison) | Juin | Fusariose épi (DON) | Tébuconazole | 15-25 €/ha |

**Total programme blé** : 75-110 €/ha (2-3 passages selon année)

**Autres cultures :**
- Orge : 1-2 passages (ramulariose, helminthosporiose) : 40-70 €/ha
- Colza : 0-1 passage (sclérotinia à la floraison) : 25-40 €/ha
- Maïs : rarement traité en fongicide
- Betterave : 2-4 passages (cercosporiose) : 60-100 €/ha

**Facteurs de décision :**
- Sensibilité variétale (variété résistante = 1 traitement de moins)
- Pression maladie (climat humide = plus de pression)
- OAD (Outils d'Aide à la Décision) : modèles de risque (Septo-LIS®, Yélo®)
- Seuil économique de traitement (coût traitement < perte évitée)

**Maladies principales par culture :**
| Culture | Maladies majeures |
|---------|-------------------|
| Blé | Septoriose, rouille brune, rouille jaune, fusariose, piétin |
| Orge | Ramulariose, helminthosporiose, rhynchosporiose |
| Colza | Sclérotinia, phoma |
| Maïs | Helminthosporiose (rare traitement) |
| Betterave | Cercosporiose, ramulariose |
| Pois | Anthracnose, botrytis |

#### SIMAGRI

- Fongicide = 1 traitement générique, 1.6 L/ha, 9 €/L = 14.4 €/ha
- Effet : si maladie active ET non traité → rendement × 0.7 (-30%)
- Les maladies apparaissent aléatoirement (`crop.disease`)
- Un seul traitement suffit pour toute la saison
- `treatment_count = 2` par défaut (nombre de traitements dans la culture)
- Pas de stade cultural associé au traitement

#### CORRECT
- Les maladies existent comme événement aléatoire
- Le fongicide protège contre les pertes de maladie
- Il y a un arbitrage économique (coût traitement vs perte potentielle)

#### SIMPLIFIÉ (acceptable)
- Un seul type de fongicide générique
- Effet protecteur global (pas par maladie)

#### FAUX ou MANQUANT
- **Prix très sous-estimé** : 14.4 €/ha vs réalité 75-110 €/ha (programme complet blé)
- **Pas de programme multi-passages** : en réalité 2-3 passages sur blé
- **Pas de timing** : le T2 (dernière feuille) est le traitement le plus important et doit être fait au bon stade
- **-30% si maladie non traitée est correct** en ordre de grandeur mais devrait être variable selon la maladie
- **Pas de notion de pression maladie** (climat humide = plus de risque)
- **Pas de variété résistante** : choix variétal = levier majeur contre les maladies
- **Pas de lien avec la météo** : champignons = humidité + chaleur

#### RECOMMANDATION AGRIVA
- **Garder** : le système maladie/traitement comme risque aléatoire
- **Modifier** : prix réaliste (total programme 60-100 €/ha selon culture)
- **Modifier** : permettre 2-3 traitements fongicides dans la saison (pas 1 seul)
- **Ajouter** : lien météo → pression maladie (printemps humide = plus de septoriose)
- **Ajouter** : timing du traitement = efficacité (traiter au bon stade = 100%, trop tard = 50%)
- **Ajouter** : variétés résistantes comme alternative partielle aux fongicides
- **Ajouter** : qualité (mycotoxines fusariose) si T3 non fait en année à risque

---

### 4.3 Insecticides

#### RÉALITÉ (France)

**Principaux ravageurs par culture :**

| Culture | Ravageur | Période | Impact | Traitement |
|---------|----------|---------|--------|-----------|
| Céréales | Pucerons d'automne (BYDV) | Oct-Nov | Jaunisse nanisante -20-50% | Insecticide automne 15-20 €/ha |
| Céréales | Cécidomyies | Mai-Juin | -10-30% | Pyréthrinoïde 10-15 €/ha |
| Colza | Méligèthes | Mars-Avril | -10-30% (boutons détruits) | Pyréthrinoïde 10-15 €/ha |
| Colza | Charançon tige | Fév-Mars | -10-20% | Piège + seuil → traitement |
| Maïs | Pyrale | Juin-Juillet | -5-15% | Trichogramme (bio-contrôle) ou insecticide |
| Betterave | Pucerons (jaunisse) | Avril-Mai | -20-50% | Plus de néonicotinoïdes → problème majeur |
| Pomme de terre | Doryphore | Juin-Août | -30-80% si non traité | 2-3 traitements |

**Tendances réglementaires :**
- Interdiction des néonicotinoïdes (2018)
- Réduction progressive des pyréthrinoïdes
- Développement du biocontrôle (trichogrammes, auxiliaires)
- Prophylaxie : décalage dates de semis, variétés tolérantes

**IFT insecticide moyen :**
- Blé : 0.5-1.0
- Colza : 1.0-2.0
- Maïs : 0-0.5

#### SIMAGRI

- Insecticide = 1 traitement générique, 1.6 L/ha, 9 €/L = 14.4 €/ha
- Même système que fongicide (protège contre les dégâts de maladie/ravageur)
- Pas de ravageur spécifique nommé
- Pas de période critique
- Pas de biocontrôle

#### CORRECT
- L'insecticide comme protection contre les ravageurs existe
- Le coût (14.4 €/ha) est plus proche de la réalité que pour les fongicides (10-20 €/ha réel)

#### SIMPLIFIÉ (acceptable)
- Un seul type d'insecticide générique
- Pas de ravageurs nommés individuellement

#### FAUX ou MANQUANT
- Pas de période critique (pucerons d'automne = risque seulement Oct-Nov)
- Pas de seuil de traitement (on traite seulement si le ravageur est présent)
- Pas de biocontrôle (trichogrammes, auxiliaires)
- Pas de lien avec les haies/biodiversité (auxiliaires naturels = prédateurs)
- Pas de distinction automne/printemps pour les ravageurs

#### RECOMMANDATION AGRIVA
- **Garder** : l'insecticide comme protection
- **Ajouter** : types de ravageurs saisonniers (automne : pucerons ; printemps : méligèthes colza)
- **Ajouter** : biocontrôle comme alternative (plus cher mais compatible bio, meilleur pour l'image)
- **Ajouter** : les haies réduisent la pression insectes (SimAgri le fait déjà partiellement !)
- **Ajouter** : seuil de présence (pas toujours nécessaire de traiter → économie possible)

---

### 4.4 Régulateurs de croissance

#### RÉALITÉ (France)

**Objectif :** Raccourcir les tiges des céréales pour éviter la verse (couchage des tiges par le vent/pluie).

**Cultures concernées :**
- Blé tendre : 60-70% des surfaces traitées
- Orge : 50-60% des surfaces
- Triticale : quasi-systématique (espèce très haute)
- Colza : pas de régulateur (mais raccourcisseur à l'automne = metconazole)

**Produits :**
- CCC (chlorméquat) : le plus utilisé, 15-20 €/ha, stade épi 1 cm
- Trinexapac-éthyl (Moddus) : 20-30 €/ha, stade 1-2 nœuds
- Raccourcisseur colza (Toprex) : 25-35 €/ha, automne

**Facteurs de risque de verse :**
- Forte fertilisation azotée
- Variété haute et sensible
- Sol limoneux (enracinement superficiel)
- Orage de juin (pluie + vent)
- Forte densité de peuplement

**Impact de la verse :**
- Verse précoce (avant remplissage grain) : -20 à -40% de rendement
- Verse tardive : -5 à -15% + difficultés de récolte
- Grain germé sur pied (déclassement qualité)
- Temps de récolte × 2

#### SIMAGRI

- **Non modélisé** : pas de régulateur de croissance
- Pas de verse
- Pas de risque lié à la surfertilisation + vent

#### CORRECT
- (Rien — absent du jeu)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser les régulateurs comme produit à part

#### FAUX ou MANQUANT
- La verse est un risque réel majeur, absent du jeu
- Pas de lien excès d'azote → verse
- Pas de lien vent/orage → dégâts mécaniques sur céréales hautes

#### RECOMMANDATION AGRIVA
- **Ajouter** : risque de verse (probabilité augmente avec : forte dose N, vent/orage, variété sensible)
- **Ajouter** : régulateur comme traitement préventif (réduit le risque de verse)
- **Ajouter** : conséquence de la verse (perte rendement + difficulté récolte)
- **Gameplay** : crée un vrai arbitrage azote élevé (rendement) vs risque de verse → intéressant

---

### 4.5 Biocontrôle

#### RÉALITÉ (France)

**Définition :** Utilisation d'organismes vivants ou de substances naturelles pour protéger les cultures.

**Principales solutions :**
| Solution | Cible | Culture | Efficacité | Coût |
|----------|-------|---------|-----------|------|
| Trichogrammes | Pyrale du maïs | Maïs | 70-80% | 40-50 €/ha |
| Bacillus thuringiensis (Bt) | Chenilles | Multi | 60-80% | 20-40 €/ha |
| Contans WG (Coniothyrium) | Sclérotinia | Colza | 50-70% | 35-50 €/ha |
| Soufre | Oïdium | Vigne, légumes | 70-90% | 10-20 €/ha |
| Cuivre (bouillie bordelaise) | Mildiou | Vigne, PDT | 70-80% | 15-25 €/ha |
| Phéromones (confusion) | Carpocapse | Pommier | 80-95% | 200-300 €/ha |

**Tendances :**
- Plan Écophyto : objectif -50% d'usage de phytos (non atteint)
- Le marché du biocontrôle croît de 15-20% par an en France
- Certains produits de biocontrôle sont déjà intégrés dans les programmes conventionnels
- Souvent utilisé en complément (pas en remplacement total) sauf en bio

#### SIMAGRI

- **Non modélisé** : pas de biocontrôle
- Seuls les produits phytosanitaires chimiques existent (fongicide, herbicide, insecticide)
- Le mode BIO interdit les traitements → rendement -15% sans alternative

#### CORRECT
- (Rien — absent)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser chaque produit de biocontrôle individuellement

#### FAUX ou MANQUANT
- Le bio sans AUCUNE protection est irréaliste (en réalité le bio utilise cuivre, soufre, Bt, trichogrammes)
- Pas d'alternative entre chimie et biocontrôle
- Le malus bio -15% est trop simpliste (en réalité c'est variable : -5% à -30% selon culture et pression)

#### RECOMMANDATION AGRIVA
- **Ajouter** : catégorie "biocontrôle" comme alternative aux phytos chimiques
- **Ajouter** : en bio, accès au biocontrôle (efficacité 60-80% vs 90% chimie, mais autorisé)
- **Modifier** : le malus bio devrait être variable selon les protections alternatives utilisées
- **Gameplay** : choix stratégique chimie (efficace, pas cher, image −) vs biocontrôle (plus cher, compatible bio, image +)

---

### 4.6 IFT et contraintes réglementaires

#### RÉALITÉ (France)

**IFT (Indice de Fréquence de Traitement) :**
- Nombre de "doses homologuées" appliquées par hectare et par an
- IFT = 1.0 = une application à dose pleine
- Référence nationale par culture (objectif = IFT de référence)

**IFT de référence (grandes cultures, France) :**
| Culture | IFT herbicide | IFT hors herbicide | IFT total |
|---------|:---:|:---:|:---:|
| Blé tendre | 1.8 | 2.5 | 4.3 |
| Orge hiver | 1.5 | 2.0 | 3.5 |
| Maïs | 1.3 | 0.3 | 1.6 |
| Colza | 2.0 | 3.0 | 5.0 |
| Tournesol | 1.5 | 0.5 | 2.0 |
| Betterave | 3.5 | 1.5 | 5.0 |

**Contraintes réglementaires :**
- Certiphyto obligatoire pour tout utilisateur de phytos (formation 2 jours)
- ZNT (Zones de Non-Traitement) : 5-20 m des habitations
- Contrôle technique pulvérisateur tous les 3 ans
- Registre phytosanitaire (traçabilité de chaque application)
- CEPP (Certificats d'Économie de Produits Phytopharmaceutiques)

**Aides liées à la réduction IFT :**
- MAEC (Mesures Agro-Environnementales et Climatiques) : -30% IFT = prime ~150 €/ha
- HVE (Haute Valeur Environnementale) niveau 3 : accès à certaines aides

#### SIMAGRI

- `treatment_count = 2` dans les définitions de culture (nombre de traitements standards)
- Pas d'IFT
- Pas de réglementation sur l'usage des phytos
- Pas de ZNT, pas de Certiphyto
- Pas d'aide à la réduction des traitements
- Pas de registre

#### CORRECT
- Le nombre de traitements par culture est limité (treatment_count)

#### SIMPLIFIÉ (acceptable)
- Pas d'IFT calculé exactement
- Pas de Certiphyto comme prérequis

#### FAUX ou MANQUANT
- Pas de limite au nombre de traitements dans l'année (en fait si : treatment_count, mais pas de conséquence de dépassement)
- Pas de ZNT (distance aux habitations/cours d'eau)
- Pas d'incitation à réduire les traitements (ni économique ni réglementaire)
- Pas de registre ou traçabilité
- Pas de label HVE ou MAEC

#### RECOMMANDATION AGRIVA
- **Garder** : le nombre de traitements par culture comme métrique interne
- **Ajouter** : un "score environnemental" qui s'améliore avec moins de traitements
- **Ajouter** : labels/certifications (HVE) qui récompensent les bas-intrants (accès prix premium)
- **Ajouter** : ZNT simplifiée (parcelles proches d'habitations = restrictions supplémentaires)
- **Optionnel** : contrôle réglementaire aléatoire avec amendes si non-conformité

---

### 4.7 Conditions d'application des traitements

#### RÉALITÉ (France)

**Conditions météo obligatoires :**
| Paramètre | Seuil | Conséquence si non respecté |
|-----------|-------|----------------------------|
| Vent | <19 km/h (force 3) | Dérive, amende, inefficacité |
| Température | <25°C (herbicides) | Volatilisation, phytotoxicité |
| Hygrométrie | >60% | Absorption foliaire correcte |
| Pluie | Pas de pluie dans les 2h suivantes | Lessivage du produit |
| Rosée | Pas de rosée (dilution) ou rosée voulue (certains herbicides) | Variable |

**Horaires optimaux :**
- Matin tôt (avant 9h) ou soir (après 18h) : hygrométrie favorable, vent faible
- Jamais en pleine journée chaude et venteuse

**Stade de la culture :**
- Chaque produit a un stade d'application recommandé
- Appliquer trop tôt ou trop tard = efficacité réduite (50-70%)
- Certains produits sont phytotoxiques sur des stades sensibles

#### SIMAGRI

- **Vent** : si vent = impossible de pulvériser (seule restriction)
- Pas de température
- Pas d'hygrométrie
- Pas de stade cultural requis pour traiter
- Pas de risque de phytotoxicité

#### CORRECT
- Le vent empêche la pulvérisation (réaliste et important)
- Le pulvérisateur comme outil requis

#### SIMPLIFIÉ (acceptable)
- Pas de modélisation de l'hygrométrie et de la température exacte
- Pas de fenêtre horaire dans la journée

#### FAUX ou MANQUANT
- Pas de lien stade cultural → efficacité du traitement
- Pas de risque pluie post-traitement (lessivage)
- Pas de température comme facteur limitant

#### RECOMMANDATION AGRIVA
- **Garder** : le vent comme restriction de pulvérisation
- **Ajouter** : si pluie dans les 24h après traitement → efficacité réduite (-30-50%)
- **Ajouter** : traiter au bon stade = pleine efficacité, traiter trop tard = efficacité réduite
- **Garder simple** : pas besoin de modéliser l'hygrométrie horaire




---

## 5. Irrigation

### 5.1 Besoins en eau par culture

#### RÉALITÉ (France)

**Besoins en eau totaux (ETM — Évapotranspiration Maximale) :**

| Culture | Besoins totaux (mm) | Période critique | Apport irrigation typique (mm) |
|---------|:---:|---|:---:|
| Blé tendre | 400-500 | Montaison-remplissage (mai-juin) | 0-80 (rarement irrigué) |
| Maïs grain | 500-700 | Floraison-remplissage (juil-août) | 150-300 |
| Tournesol | 400-500 | Bouton floral-floraison | 50-150 |
| Betterave | 500-600 | Juin-septembre | 80-150 |
| Pomme de terre | 400-500 | Tubérisation (juin-juillet) | 100-200 |
| Soja | 450-550 | Floraison-remplissage | 100-200 |
| Colza | 400-500 | Floraison (avril-mai) | Rarement irrigué |
| Pois | 350-400 | Floraison-remplissage | 50-100 |

**En France :**
- 5-6% de la SAU est irriguée (~1.6 million d'hectares)
- Principales régions irriguées : Sud-Ouest, Centre-Ouest, Beauce, Vallée du Rhône
- Maïs = 50% des surfaces irriguées
- Tendance à l'irrigation du blé dur et des cultures de printemps dans le Sud

#### SIMAGRI

- Irrigation possible via forage (niveau 1-10 : 100K à 1M litres/jour)
- Enrouleur ou pivot central
- Retenue collinaire (alimentée par rivière)
- L'irrigation remplit la jauge eau de la culture
- Pas de dose en mm, mais un calcul basé sur litres/jour / surface
- Pas de période critique

#### CORRECT
- Les 3 méthodes (forage, enrouleur/pivot, retenue) sont réalistes
- L'irrigation est optionnelle (pas toutes les parcelles en ont besoin)
- Le forage a un débit limité (réaliste)

#### SIMPLIFIÉ (acceptable)
- Pas de dose en mm (système de jauge)
- Pas de distinction entre cultures plus ou moins demandeuses

#### FAUX ou MANQUANT
- **Pas de coût énergétique proportionnel** à la quantité d'eau pompée
- **Pas de période critique** : irriguer le maïs en floraison est 3× plus efficace qu'en végétation
- **Pas de restriction d'eau** : pas d'arrêtés sécheresse
- **Pas de nappe qui se vide** : le forage a un débit fixe sans notion d'épuisement
- **Pas de coût d'investissement progressif** : forage = 150€ seulement (réalité : 15 000-50 000€)

#### RECOMMANDATION AGRIVA
- **Garder** : le système forage + équipement (enrouleur, pivot)
- **Modifier** : coût du forage réaliste (15 000-50 000 € selon profondeur)
- **Modifier** : coût de fonctionnement proportionnel au volume pompé (énergie)
- **Ajouter** : période critique par culture (bonus si irrigation au bon moment)
- **Ajouter** : restrictions préfectorales en cas de sécheresse (gameplay événementiel)
- **Ajouter** : les cultures ont des besoins différents (maïs >> blé)

---

### 5.2 Méthodes d'irrigation

#### RÉALITÉ (France)

| Méthode | Débit | Efficience | Investissement | Surface couverte | Usage |
|---------|-------|-----------|---------------|-----------------|-------|
| Enrouleur | 20-50 m³/h | 70-80% | 30 000-60 000 € | 5-30 ha (mobile) | Le plus courant en grandes cultures |
| Pivot central | 50-150 m³/h | 85-90% | 50 000-150 000 € | 20-80 ha (fixe, circulaire) | Grandes parcelles |
| Rampe frontale | 50-100 m³/h | 85-90% | 80 000-200 000 € | 20-60 ha (rectangulaire) | Parcelles rectangulaires |
| Goutte-à-goutte | 1-5 m³/h/ha | 90-95% | 3 000-5 000 €/ha | Variable | Maraîchage, vergers |
| Aspersion (couverture intégrale) | Variable | 75-85% | 4 000-8 000 €/ha | Fixe | Betterave, PDT |

**Coûts de fonctionnement :**
- Pompage : 0.05-0.15 €/m³ (électricité ou gasoil)
- Main d'œuvre (enrouleur) : 1-2 h/ha/passage
- Maintenance : 3-5% de l'investissement/an
- Redevance agence de l'eau : 0.01-0.05 €/m³

**Coût total irrigation (maïs, 200 mm apportés) :**
- 200 mm = 2000 m³/ha
- Coût variable : 100-300 €/ha/an
- Amortissement matériel : 100-200 €/ha/an
- **Total : 200-500 €/ha/an**

#### SIMAGRI

- Enrouleur et pivot central disponibles
- Retenue collinaire comme source alternative
- Forage = 150 € (investissement dérisoire)
- Pas de notion d'efficience (pivot > enrouleur)
- Pas de coût de fonctionnement proportionnel

#### CORRECT
- Les deux méthodes principales (enrouleur, pivot) existent
- La retenue collinaire est une vraie alternative au forage

#### SIMPLIFIÉ (acceptable)
- Pas de rampe frontale ni goutte-à-goutte (cultures spécialisées)
- Pas d'efficience différente par méthode

#### FAUX ou MANQUANT
- **Forage à 150€ est absurde** : réalité = 15 000-50 000€
- **Pas de coût de fonctionnement** proportionnel au volume
- **Pas de choix stratégique** entre méthodes (le pivot est plus cher mais plus efficace et moins gourmand en main d'œuvre)
- Pas de limitation de surface par équipement

#### RECOMMANDATION AGRIVA
- **Modifier** : investissements réalistes (forage 20 000€, enrouleur 40 000€, pivot 100 000€)
- **Ajouter** : coût de fonctionnement par m³ pompé
- **Ajouter** : efficience différente (pivot 90% vs enrouleur 75%)
- **Ajouter** : le pivot couvre une surface fixe (dimensionné à la parcelle)
- **Gameplay** : vrai investissement stratégique à long terme

---

### 5.3 Restrictions préfectorales (sécheresse)

#### RÉALITÉ (France)

**4 niveaux d'alerte sécheresse :**
| Niveau | Couleur | Restrictions irrigation |
|--------|---------|------------------------|
| Vigilance | Gris | Information, incitation aux économies |
| Alerte | Jaune | Réduction 25% (jours interdits, horaires) |
| Alerte renforcée | Orange | Réduction 50% (tours d'eau stricts) |
| Crise | Rouge | Interdiction totale sauf eau potable |

**Fréquence :**
- Chaque été, 30-60 départements en alerte (tendance croissante avec le changement climatique)
- Sud-Ouest et Centre particulièrement touchés
- 2022 : 93 départements en alerte, 78 en crise

**Tours d'eau :**
- Système d'alternance : chaque irrigant a des créneaux autorisés (ex : lundi-mercredi-vendredi)
- Volume prélevable limité par arrêté
- Contrôles par l'OFB (Office Français de la Biodiversité)
- Amendes : 1 500 à 75 000 € pour irrigation interdite

#### SIMAGRI

- **Aucune restriction** d'eau modélisée
- Pas de sécheresse réglementaire
- Pas de tours d'eau
- L'eau est illimitée si on a un forage

#### CORRECT
- (Rien — absent)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser les 4 niveaux exactement

#### FAUX ou MANQUANT
- L'eau illimitée est irréaliste, surtout dans le contexte climatique actuel
- Pas de tension sur la ressource en eau (enjeu sociétal majeur)
- Pas de gestion collective de l'eau

#### RECOMMANDATION AGRIVA
- **Ajouter** : événement "sécheresse" qui restreint ou interdit l'irrigation temporairement
- **Ajouter** : cela crée du gameplay (anticiper, stocker, choisir quelles parcelles irriguer)
- **Ajouter** : la retenue collinaire est moins affectée (stockage hivernal)
- **Gameplay** : excellent événement aléatoire qui force des décisions

---

## 6. Croissance et développement

### 6.1 Stades phénologiques réels

#### RÉALITÉ (France)

**Échelle BBCH (céréales) — stades principaux :**

| Code BBCH | Stade | Description | Date (blé Centre France) |
|:---------:|-------|-------------|--------------------------|
| 00 | Germination | Grain sec | Octobre |
| 07 | Levée | Coléoptile perce le sol | Oct-Nov |
| 10-13 | 1-3 feuilles | Feuilles déployées | Novembre |
| 21-29 | Tallage | Formation des talles | Nov-Fév |
| 30 | Épi 1 cm | Début montaison | Mars |
| 31-32 | 1-2 nœuds | Montaison | Mars-Avril |
| 37-39 | Dernière feuille | Feuille drapeau ligulée | Avril-Mai |
| 51-59 | Épiaison | Épi sort de la gaine | Mai |
| 61-69 | Floraison | Anthèse | Mai-Juin |
| 71-77 | Grain laiteux-pâteux | Remplissage | Juin |
| 83-87 | Grain dur | Maturation | Juin-Juillet |
| 92 | Maturité complète | Récolte possible | Juillet |

**Importance des stades :**
- Chaque intervention (fertilisation, traitement, irrigation) a un stade optimal
- Le passage d'un stade à l'autre dépend de la somme de températures
- Un stress à un stade critique est irréversible (ex : gel épiaison = 0% rendement)

**Colza — stades clés :**
- Levée (sept) → Rosette (oct-déc) → Reprise végétation (fév) → Montaison (mars) → Boutons (avril) → Floraison (avril-mai) → Siliques (mai-juin) → Maturité (juin-juillet)

**Maïs — stades clés :**
- Levée (mai) → 4-6 feuilles (juin) → 10-12 feuilles (juillet) → Floraison mâle/femelle (juillet) → Grain laiteux (août) → Grain pâteux (sept) → Maturité (oct)

#### SIMAGRI

- **Croissance linéaire** : 0 → 100% (4% par jour base, modifié par météo)
- Pas de stades phénologiques
- Pas de stade critique
- La croissance est un simple pourcentage
- Récolte possible à 100% (optimal) ou avant (pénalité)
- Céréale immature = récolte entre 60-80% (ensilage)

#### CORRECT
- La notion de progression vers la maturité (0-100%)
- La pénalité si récolte avant maturité complète
- La récolte immature comme option (ensilage)

#### SIMPLIFIÉ (acceptable)
- Un pourcentage unique plutôt que des stades BBCH détaillés
- Croissance continue plutôt que par stades discrets

#### FAUX ou MANQUANT
- **Pas de stade critique** : un gel à 50% de croissance (≈épiaison) devrait être catastrophique mais n'est pas modélisé différemment d'un gel à 20%
- **Pas de lien stade → interventions** : le bon moment pour fertiliser/traiter n'est pas lié au % de croissance
- **Croissance linéaire** : en réalité la croissance est sigmoïdale (lente au début, rapide en montaison, plateau en remplissage)
- **Pas de vernalisation** : les céréales d'hiver ont besoin de froid pour fleurir (non modélisé)
- **Pas de photopériodisme** : le maïs ne fleurit pas si les jours sont trop courts

#### RECOMMANDATION AGRIVA
- **Garder** : la progression 0-100% comme représentation simplifiée
- **Modifier** : découper en 4-5 phases (levée / développement / floraison / remplissage / maturité) plutôt qu'un continuum linéaire
- **Ajouter** : certaines phases sont des "fenêtres d'intervention" (fertilisation en phase 2, fongicide en phase 3...)
- **Ajouter** : sensibilité variable aux stress selon la phase (gel en floraison = catastrophique, gel en tallage = mineur)
- **Ajouter** : courbe de croissance sigmoïdale (ralentissement naturel début et fin)

---

### 6.2 Sommes de températures (degrés-jours)

#### RÉALITÉ (France)

**Principe :** La croissance des plantes dépend de la température. On cumule les degrés-jours au-dessus d'un seuil (base) pour prédire les stades.

**Formule :** `DJ = Σ max(0, Tmoy - Tbase)` par jour

**Bases et besoins par culture :**
| Culture | T° base | DJ semis→maturité | DJ semis→floraison |
|---------|:-------:|:-----------------:|:------------------:|
| Blé tendre | 0°C | 2000-2200 | 1200-1400 |
| Orge hiver | 0°C | 1800-2000 | 1100-1300 |
| Maïs grain | 6°C | 1700-2100 (selon précocité) | 800-1000 |
| Colza | 0°C | 2200-2500 | 1400-1600 |
| Tournesol | 6°C | 1600-1900 | 900-1100 |
| Betterave | 3°C | 2500-3000 | - (pas de floraison souhaitée) |

**Utilité pratique :**
- Prévoir la date de récolte
- Caler les interventions (T1 fongicide à 800 DJ base 0 depuis semis)
- Choisir la précocité variétale adaptée à la région
- Différences Nord/Sud : même variété = 2-3 semaines d'écart de maturité

#### SIMAGRI

- Croissance fixe : 4% par jour (0.17%/h) modifiée par la jauge soleil
- Pas de somme de températures
- Pas de lien entre température réelle et vitesse de croissance
- L'herbe ne pousse pas en hiver (seule distinction saisonnière)

#### CORRECT
- L'herbe s'arrête en hiver (réaliste : base 5°C, pas de croissance <5°C)
- La jauge soleil influence la croissance (proxy de la température/luminosité)

#### SIMPLIFIÉ (acceptable)
- Pas besoin de calculer les degrés-jours exactement
- La jauge soleil comme proxy est acceptable

#### FAUX ou MANQUANT
- **Croissance identique été et hiver** (sauf herbe) : un blé semé en octobre ne devrait quasiment pas pousser de décembre à février (repos hivernal)
- **Pas de différence de vitesse de croissance selon les saisons** pour les cultures en place
- **Pas de précocité variétale** : une variété précoce mûrit plus vite (moins de DJ nécessaires)
- **4%/jour est très rapide** : 25 jours semis→maturité ! En réalité blé = 9-10 mois (mais en temps SimAgri = 1 semaine/mois, soit ~9 semaines = ~63 jours)
- Le calcul est calibré pour le temps accéléré du jeu mais ne reflète pas les dynamiques saisonnières

#### RECOMMANDATION AGRIVA
- **Modifier** : la vitesse de croissance devrait varier fortement selon la saison (quasi-nulle en hiver pour les céréales d'hiver, rapide au printemps/été)
- **Ajouter** : concept de "repos hivernal" pour les cultures d'hiver (croissance ~0 en déc-fév, même si la jauge soleil n'est pas à 0)
- **Ajouter** : la température comme facteur principal de croissance (pas seulement le soleil)
- **Ajouter** : notion de précocité (variété précoce = cycle plus court = adapté aux régions fraîches)
- **Garder** : le principe d'un % de croissance qui progresse, mais moduler par la saison

---

### 6.3 Facteurs limitants

#### RÉALITÉ (France)

**Loi du minimum (Liebig) :** Le rendement est limité par le facteur le plus limitant, pas par la moyenne des facteurs.

**Principaux facteurs limitants :**

| Facteur | Impact potentiel | Fréquence | Gestion |
|---------|:---:|---|---|
| Stress hydrique (sécheresse) | -20 à -60% | Élevée (1 an/3) | Irrigation, variétés tolérantes |
| Stress azoté (carence N) | -10 à -40% | Modérée | Fertilisation adaptée |
| Maladies foliaires | -10 à -30% | Élevée | Fongicides, variétés résistantes |
| Adventices | -10 à -50% | Très élevée | Désherbage |
| Verse | -5 à -40% | Modérée | Régulateur, dose N modérée |
| Gel tardif (printemps) | -5 à -100% | Faible (1 an/10) | Rien (aléa) |
| Excès d'eau (asphyxie) | -10 à -30% | Modérée (sols lourds) | Drainage |
| Carence P ou K | -5 à -15% | Faible (sols bien entretenus) | Fertilisation de fond |
| Ravageurs | -5 à -30% | Variable | Insecticides, biocontrôle |
| Grêle | -10 à -100% | Faible | Assurance |
| Compaction | -5 à -20% | Modérée | Décompactage, non-labour |

**Interactions :**
- Stress hydrique + forte dose N = verse
- Excès d'humidité + chaleur = explosion maladies
- Sol compacté + sécheresse = impact décuplé (racines superficielles)

#### SIMAGRI

- **Jauge eau** : extrêmes (trop sec ou trop humide) = pénalité via `gaugeBonus` (0.6 à 1.1)
- **Jauge soleil** : idem
- **Maladie** : -30% si non traitée
- **Sol appauvri** : pénalité via `nutrientFactor` (0.5 à 1.3)
- **Pierres** : -5%
- **Grêle** : dégâts arboricoles uniquement (filet anti-grêle)
- Pas de verse, pas de gel tardif, pas de compaction, pas d'adventices comme facteur de rendement

#### CORRECT
- Les jauges eau et soleil comme facteurs limitants bidirectionnels (trop = mauvais, pas assez = mauvais)
- La maladie comme facteur de perte
- Les nutriments du sol comme facteur limitant
- La plage 0.5-1.3 pour les nutriments est un bon ordre de grandeur

#### SIMPLIFIÉ (acceptable)
- Système de jauges plutôt que modèle physiologique
- Pas d'interaction complexe entre facteurs

#### FAUX ou MANQUANT
- **Pas de gel tardif** : événement rare mais dévastateur (2021 = -30% vigne et fruits en France)
- **Pas de verse** : facteur limitant majeur des céréales
- **Pas d'adventices comme facteur limitant** : seulement comme traitement
- **Pas d'excès d'eau (asphyxie)** : en réalité un sol engorgé est aussi néfaste qu'un sol sec
- **La grêle n'affecte pas les grandes cultures** dans SimAgri (seulement les vergers)
- **Pas de compaction** comme facteur limitant durable
- **Pas de loi du minimum** : dans SimAgri les facteurs sont multiplicatifs (ce qui peut créer des situations où tout est moyen mais le rendement est très bas par multiplication)

#### RECOMMANDATION AGRIVA
- **Garder** : les jauges eau/soleil comme système central
- **Garder** : les multiplicateurs comme approche (c'est un bon système de jeu)
- **Ajouter** : gel tardif comme événement rare mais dévastateur (surtout au printemps sur cultures sensibles)
- **Ajouter** : verse (liée à vent + dose N + stade)
- **Ajouter** : grêle affecte aussi les grandes cultures (pas seulement les vergers)
- **Modifier** : changer la logique multiplicative pure — utiliser un système "plancher" (le pire facteur domine plus que les autres)

---

### 6.4 Composantes du rendement

#### RÉALITÉ (France)

**Blé tendre — décomposition du rendement :**
```
Rendement (q/ha) = Épis/m² × Grains/épi × PMG (g) / 100 000
```

| Composante | Valeur typique | Plage | Stade de mise en place |
|------------|:-:|:-:|---|
| Épis/m² | 400-600 | 300-700 | Tallage → montaison |
| Grains/épi | 30-45 | 20-55 | Montaison → floraison |
| PMG | 40-50 g | 30-55 | Floraison → maturité |

**Exemple :** 500 épis × 35 grains × 45g PMG / 100 000 = **78.8 q/ha**

**Principe clé :** Chaque composante se décide à un stade précis. Un stress à un stade donné pénalise la composante en cours de formation :
- Stress tallage → moins d'épis/m²
- Stress montaison-floraison → moins de grains/épi
- Stress remplissage → PMG faible

**Compensation partielle :** Si moins d'épis → chaque épi a plus de grains (mais compensation limitée à 10-20%).

**Maïs :**
```
Rendement = Pieds/m² × Grains/épi × PMG / 100 000
Typique : 8.5 pieds × 550 grains × 300g = 140 q brut (90-100 q sec)
```

#### SIMAGRI

- **Rendement = base × multiplicateurs** (pas de composantes)
- Le rendement est un nombre final calculé à la récolte
- Pas de notion d'épis/m², grains/épi, PMG
- Pas de construction progressive du rendement pendant le cycle

#### CORRECT
- Le rendement final dépend de multiples facteurs (cohérent avec la réalité, juste pas décomposé)
- Les multiplicateurs sont un proxy acceptable des composantes

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser épis × grains × PMG individuellement
- Le système de multiplicateurs est suffisant pour un jeu

#### FAUX ou MANQUANT
- **Pas de notion de "quand" le stress survient** : un stress en tallage et un stress en remplissage ont le même effet dans SimAgri, mais pas en réalité
- **Pas de compensation** : moins d'épis → grains plus gros (la plante s'adapte)
- **Pas de PMG** : or c'est ce qui définit la qualité PS (Poids Spécifique)

#### RECOMMANDATION AGRIVA
- **Garder** : le système de multiplicateurs comme moteur de rendement
- **Modifier** : les stress à différents moments du cycle devraient affecter des "dimensions" différentes (quantité vs qualité)
- **Ajouter** : le stress tardif (remplissage) affecte la qualité plus que la quantité
- **Ajouter** : le stress précoce (tallage) affecte le nombre d'épis → quantité
- **Garder simple** : pas besoin d'afficher épis/m² au joueur, mais en interne distinguer "quand" le stress intervient




---

## 7. Récolte

### 7.1 Conditions de récolte

#### RÉALITÉ (France)

**Humidité du grain à la récolte :**
| Culture | Humidité optimale | Humidité max commerce | Surcoût séchage |
|---------|:-:|:-:|---|
| Blé tendre | 14-15% | 15% | 1-2 €/t par point au-dessus |
| Orge | 14-15% | 15% | idem |
| Maïs grain | 24-32% à la récolte | 15% | 3-5 €/t par point (lourd !) |
| Colza | 8-9% | 9% | Rare |
| Tournesol | 9-11% | 9% | 1-2 €/t/point |
| Pois | 14-15% | 14.5% | Peu fréquent |

**Conditions météo requises :**
- Pas de pluie le jour de la récolte (grain ré-humidifié)
- Rosée matinale = attendre 10h-11h pour commencer
- Céréales : récolte entre 11h et 22h typiquement
- Maïs : récolte possible à humidité élevée (séchage obligatoire)
- Conditions sèches depuis 2-3 jours = idéal

**Maturité :**
- Grain dur (BBCH 87) : humidité ~20%
- Grain cassant sous la dent : humidité ~15% → optimal
- Surmaturité : égrenage naturel (pertes augmentent), problème qualité

**Fenêtre de récolte :**
- Blé/orge : 2-3 semaines de fenêtre optimale
- Au-delà : risque de germination sur pied (pluie), perte de PS, mycotoxines
- "Moisson, c'est quand c'est mûr, pas quand c'est pratique"

#### SIMAGRI

- Récolte possible dans les mois indiqués (`harvest_months`)
- Maturité 100% = optimal
- Pas d'humidité du grain
- Pas de condition météo spécifique pour la récolte (sauf forte pluie = pas de travail)
- Pas de surmaturité ni dégradation si on attend trop
- Pas de fenêtre qui se ferme

#### CORRECT
- La notion de maturité à 100% comme condition optimale
- Les mois de récolte sont corrects (juillet-août pour blé)
- La pénalité de rendement si récolte avant maturité

#### SIMPLIFIÉ (acceptable)
- Pas d'humidité du grain comme paramètre explicite
- Fenêtre mensuelle plutôt que journalière

#### FAUX ou MANQUANT
- **Pas de dégradation si on attend trop** : en réalité, ne pas récolter à maturité = pertes progressives
- **Pas de condition météo spécifique** : impossible de récolter des céréales à 15% si pluie la veille
- **Le maïs récolté humide n'est pas modélisé** (coût séchage = charge majeure)
- **Pas de rosée/horaire** (détail trop fin pour un jeu, acceptable)

#### RECOMMANDATION AGRIVA
- **Garder** : la fenêtre de récolte par culture
- **Ajouter** : dégradation progressive après la date optimale (-1%/jour de retard passé la maturité)
- **Ajouter** : condition météo minimale (pas de récolte si pluie récente pour céréales — 1-2 jours secs requis)
- **Ajouter** : maïs = humidité élevée → coût de séchage obligatoire
- **Gameplay** : tension entre "attendre la maturité" et "récolter avant la pluie annoncée"

---

### 7.2 Pertes à la récolte

#### RÉALITÉ (France)

**Pertes mécaniques (moissonneuse-batteuse) :**
| Source de perte | % perte | Facteurs aggravants |
|----------------|:-------:|---------------------|
| Coupe (barre de coupe) | 1-2% | Verse, culture haute, vitesse excessive |
| Battage (batteur) | 0.5-1% | Réglage inadapté, grain humide |
| Séparation (secoueurs) | 0.5-1% | Débit trop élevé, paille humide |
| Nettoyage (grilles) | 0.5-1% | Réglage vent |
| **Total acceptable** | **2-3%** | Optimal avec bon réglage |
| Total en conditions difficiles | 5-8% | Verse + humidité + vitesse |

**Pertes pré-récolte :**
- Égrenage naturel (maturité dépassée) : 1-5%
- Dégâts oiseaux (tournesol) : 1-3%
- Dégâts gibier (maïs, sangliers) : 2-10% en bordure de forêt

**Coût de la récolte :**
- Moissonneuse en propre : amortissement 30-50 €/ha
- Prestation ETA/CUMA : 80-130 €/ha (céréales), 150-200 €/ha (maïs)

#### SIMAGRI

- Pas de pertes à la récolte modélisées
- Le rendement calculé = le rendement stocké (100% récupéré)
- Pas de réglage de moissonneuse
- Pas de dégâts pré-récolte (oiseaux, gibier)
- La qualité de la récolte dépend des facteurs de culture, pas du processus de récolte

#### CORRECT
- (Rien — pertes non modélisées)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser les réglages de la moissonneuse
- Pas de perte par les oiseaux (trop aléatoire)

#### FAUX ou MANQUANT
- Aucune perte = légèrement irréaliste mais acceptable pour un jeu
- Pas de perte supplémentaire en cas de verse (lien avec le système de verse si ajouté)
- Pas de dégâts sangliers (pourtant un vrai problème rural français)

#### RECOMMANDATION AGRIVA
- **Optionnel** : perte fixe de 2-3% systématique (réalisme) — mais risque d'être frustrant sans gameplay
- **Ajouter** : perte supplémentaire si verse (+5-10% de perte à la récolte)
- **Ajouter** : perte si récolte trop tardive (égrenage naturel)
- **Optionnel fun** : dégâts sangliers en bordure de forêt (événement aléatoire, solution = clôture ou chasse)

---

### 7.3 Rendements réels par culture et par région

#### RÉALITÉ (France — données Agreste 2019-2023)

**Rendements moyens nationaux (quintaux/ha) :**
| Culture | Moyenne France | Beauce/IDF | Nord-Picardie | Ouest | Sud-Ouest | Sud-Est |
|---------|:-:|:-:|:-:|:-:|:-:|:-:|
| Blé tendre | 72 | 80-85 | 85-90 | 70-75 | 55-65 | 50-60 |
| Blé dur | 55 | 60-65 | - | - | 45-55 | 45-55 |
| Orge hiver | 67 | 75-80 | 80-85 | 65-70 | 50-60 | 45-55 |
| Orge printemps | 58 | 60-65 | 65-70 | 55-60 | 45-50 | 40-50 |
| Maïs grain | 90 | 95-105 | 90-100 | 85-95 | 80-90 | 85-100 |
| Colza | 33 | 35-38 | 38-42 | 32-36 | 25-30 | 22-28 |
| Tournesol | 24 | 25-28 | - | 22-26 | 22-26 | 20-24 |
| Pois | 40 | 42-48 | 45-50 | 38-42 | 30-35 | 28-35 |
| Betterave | 850 | 900-950 | 850-900 | - | - | - |
| Pomme de terre | 450 | 450-500 | 450-480 | 400-450 | - | - |

**Variabilité interannuelle :**
- Blé : écart-type ~8-10 q/ha (±15% d'une année à l'autre)
- 2016 (mauvaise année) : 54 q/ha (sécheresse + maladies)
- 2019 (bonne année) : 78 q/ha
- 2023 : 73 q/ha (année moyenne)

#### SIMAGRI

- Table `culture_yields` avec rendement par culture × région
- Valeurs non explicitement listées dans les règles consultées mais le système existe
- Le rendement de base est modifié par les multiplicateurs (0.5× à ~1.5× possible)
- Les prix moyens sont donnés (blé = 100 €/t = cohérent avec des rendements en tonnes)

#### CORRECT
- Le principe de rendements différents par région est bon
- Le système de multiplicateurs permet d'atteindre une variabilité réaliste

#### SIMPLIFIÉ (acceptable)
- Des rendements moyens par "grande région" plutôt que par département

#### FAUX ou MANQUANT
- **Pas de variabilité interannuelle** : chaque année, si mêmes actions → même résultat (pas d'effet "année")
- **Pas de très bonnes ni très mauvaises années** comme événement global
- Les multiplicateurs sont déterministes (pas d'aléa résiduel)

#### RECOMMANDATION AGRIVA
- **Garder** : rendements de base par région (calibrer sur données Agreste)
- **Ajouter** : variabilité interannuelle aléatoire (±10-15%) indépendante des actions du joueur
- **Ajouter** : effet "millésime" (certaines années sont globalement meilleures que d'autres pour une zone)
- **Calibrer** : vérifier que le rendement atteignable avec tous les bonus soit cohérent avec les records réels (~120 q blé max)

---

### 7.4 Qualité de la récolte

#### RÉALITÉ (France)

**Critères de qualité blé tendre (base de commerce) :**
| Critère | Norme | Bonus/Malus |
|---------|-------|-------------|
| Poids Spécifique (PS) | ≥76 kg/hl | +1 €/t par kg/hl au-dessus / -1.5 €/t en dessous |
| Humidité | ≤15% | -1.5 €/t par 0.5% au-dessus |
| Protéines | ≥11.5% (BPF) | +5-15 €/t si >11.5% (blé meunier premium) |
| Temps de chute Hagberg | ≥220 s | <180 = déclassement en fourrager (-30 €/t) |
| Impuretés | ≤2% | Réfaction si au-dessus |
| DON (mycotoxines) | <1250 µg/kg | >1750 = refusé en alimentation humaine |
| Grains germés | ≤3% | Déclassement si au-dessus |

**Classes de blé tendre :**
- **BPS (Blé Panifiable Supérieur)** : PS≥76, protéines≥11.5%, Hagberg≥220 → premium +15-25 €/t
- **BP (Blé Panifiable)** : PS≥75, protéines≥10.5%, Hagberg≥180 → standard
- **BAF (Blé Autre que Fourrager)** : ne remplit pas BP → -15-30 €/t
- **Fourrager** : qualité minimale → -30-50 €/t vs BPS

**Facteurs influençant la qualité :**
- Protéines : 3ème apport N (tardif) + rendement modéré (dilution)
- PS : remplissage correct (pas de stress hydrique terminal)
- Hagberg : pas de pluie à maturité (germination sur pied)
- Mycotoxines : fongicide T3 en année fusariose

#### SIMAGRI

- 3 niveaux de qualité (1, 2, 3) calculés à la récolte
- Influence le prix de vente et la valeur nutritionnelle (alimentation animale)
- Les facteurs de qualité ne sont pas explicités dans le calcul
- Pas de protéines, PS, Hagberg individuels
- Qualité = fonction globale des multiplicateurs

#### CORRECT
- 3 niveaux de qualité = simplification acceptable de BPS/BP/Fourrager
- La qualité influence le prix (réaliste)
- La qualité influence la valeur nutritionnelle pour l'alimentation animale (réaliste)

#### SIMPLIFIÉ (acceptable)
- 3 niveaux au lieu de critères numériques individuels
- Pas de Hagberg, DON, impuretés détaillées

#### FAUX ou MANQUANT
- **Pas de lien 3ème apport N → protéines → qualité** (le fractionnement manque)
- **Pas de lien météo à maturité → qualité** (pluie = germination = déclassement)
- **Pas de mycotoxines** comme critère (santé animale et humaine)
- **Pas de prime qualité explicite** dans le commerce (juste "qualité 1/2/3" → prix)
- **Pas de déclassement** en fourrager (pénalité majeure de prix)

#### RECOMMANDATION AGRIVA
- **Garder** : les 3 niveaux de qualité
- **Modifier** : expliciter les facteurs de qualité (N tardif → qualité haute, pluie maturité → qualité basse)
- **Ajouter** : prime/décote de prix explicite par niveau de qualité (+15% / standard / -25%)
- **Ajouter** : lien météo fin de cycle → risque de déclassement
- **Ajouter** : qualité des céréales fourragères a un impact sur la performance animale (liaison élevage)

---

## 8. Post-récolte

### 8.1 Stockage à la ferme vs organisme stockeur

#### RÉALITÉ (France)

**Stockage à la ferme :**
- 45-50% des céréales sont stockées à la ferme (tendance croissante)
- Investissement silo : 100-150 €/t de capacité (cellules métalliques)
- Avantages : vendre au bon moment (spéculation), autonomie en alimentation animale
- Inconvénients : investissement lourd, responsabilité qualité, pertes possibles
- Capacité typique : 200-1000 t selon exploitation

**Organisme stockeur (coopérative, négoce) :**
- 50-55% des céréales livrées directement
- Frais : 15-25 €/t (réception + stockage + manutention)
- Avantages : pas d'investissement, pas de risque qualité, paiement rapide
- Inconvénients : moins de flexibilité commerciale, décote si humidité élevée
- Contrat possible : prix garanti à la moisson ou prix différé (stockage rémunéré)

**Choix économique :**
- Stockage ferme rentable à partir de 15-25 €/t de plus-value commerciale
- Plus-value moyenne par le stockage : 10-30 €/t (vente à contre-saison)
- Amortissement silo : 10-15 ans

#### SIMAGRI

- Silos de stockage à construire (en tonnes)
- Un silo par type de production
- Vente possible à tout moment à la coopérative SimAgri ou au marché
- Pas d'organisme stockeur externe
- Pas de frais de stockage externe
- Pas de dégradation dans le silo (qualité stable)
- Stockage obligatoire avant vente (dans le silo ou la filière PDT)

#### CORRECT
- Les silos comme investissement en capacité
- La possibilité de stocker pour vendre plus tard
- Un silo par type de production (réaliste : on ne mélange pas blé et orge)

#### SIMPLIFIÉ (acceptable)
- Pas d'organisme stockeur (simplifie la logistique)
- Pas de frais de stockage annuels

#### FAUX ou MANQUANT
- **Pas de dégradation en stockage** (insectes, moisissures, échauffement)
- **Pas de coût de fonctionnement du silo** (ventilation = électricité)
- **Pas de choix entre livraison directe et stockage** (stratégie commerciale)
- **Pas de saisonnalité des prix** : en réalité les prix sont bas à la moisson et remontent ensuite

#### RECOMMANDATION AGRIVA
- **Garder** : les silos comme investissement
- **Ajouter** : option "livraison directe" (pas besoin de silo mais prix moisson = bas)
- **Ajouter** : saisonnalité des prix (bas en juillet-août, remontent sept-mars) → incitation au stockage
- **Ajouter** : risque de dégradation si pas de ventilation (investissement ventilateur)
- **Ajouter** : coût de fonctionnement (électricité ventilation) — charge annuelle légère
- **Gameplay** : arbitrage stockage (investissement + risque) vs vente immédiate (sécurité)

---

### 8.2 Séchage

#### RÉALITÉ (France)

**Cultures nécessitant un séchage :**
| Culture | Humidité récolte | Humidité stockage | Séchage nécessaire |
|---------|:-:|:-:|---|
| Maïs grain | 25-35% | 14-15% | TOUJOURS (10-20 points) |
| Blé | 14-18% | 14-15% | Rarement (0-3 points) |
| Orge | 14-18% | 14-15% | Rarement |
| Tournesol | 10-14% | 9% | Parfois (1-5 points) |
| Colza | 8-12% | 9% | Très rarement |

**Coût du séchage :**
- 1.5-3.0 €/t par point d'humidité séché
- Maïs (15 points à sécher) : 25-45 €/t de coût de séchage
- Sur un rendement de 10 t/ha : **250-450 €/ha de séchage** pour le maïs !
- Carburant (gaz, fioul) = 70% du coût de séchage

**Types de séchoirs :**
- Séchoir à colonne (continu) : 20-100 t/h, investissement 100 000-500 000 €
- Séchoir à grille (batch) : 10-30 t/batch
- Ventilation en silo (silo-séchoir) : lent mais peu coûteux

**Qui sèche :**
- 60% des agriculteurs livrent en humide → la coopérative sèche et facture
- 40% ont un séchoir ou un silo-séchoir à la ferme

#### SIMAGRI

- **Non modélisé** : pas de séchage
- Le maïs est récolté "sec" implicitement
- Pas de coût de séchage
- Pas de distinction humide/sec
- Pas de séchoir comme investissement

#### CORRECT
- (Rien — absent)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser l'humidité de chaque lot

#### FAUX ou MANQUANT
- **Le séchage du maïs est une charge ÉNORME** (250-450 €/ha) — ne pas la modéliser sous-estime le coût du maïs
- **Pas de décision "récolter humide à la coop vs sécher soi-même"**
- La rentabilité du maïs est surestimée sans le coût de séchage
- En année humide, même le blé nécessite du séchage

#### RECOMMANDATION AGRIVA
- **Ajouter** : pour le maïs grain, un coût de séchage obligatoire (30-50 €/t) qui affecte directement la marge
- **Ajouter** : investissement séchoir comme alternative (réduit le coût par t sur le long terme)
- **Optionnel** : humidité de récolte variable selon la météo de la semaine (si pluie = plus humide = plus cher à sécher)
- **Impact** : rééquilibre la rentabilité du maïs vs céréales d'hiver (qui n'ont pas de séchage)

---

### 8.3 Ventilation et thermométrie

#### RÉALITÉ (France)

**Ventilation de refroidissement :**
- Objectif : refroidir le grain à <12°C pour stopper les insectes et moisissures
- 3 paliers : 20°C (moisson) → 15°C (automne) → 8-10°C (hiver)
- Débit : 10-15 m³/h/m³ de grain
- Durée : 150-300 h de ventilation par campagne
- Coût : 0.5-1.0 €/t/an (électricité)
- Ventilateur : 3 000-8 000 € par cellule

**Thermométrie :**
- Sondes dans le grain (1 par cellule ou par couche)
- Détection d'échauffement (>25°C = alerte)
- Investissement : 1 000-3 000 € par silo
- Surveillance hebdomadaire

**Conséquences d'un mauvais stockage :**
- Échauffement → développement insectes (charançons, sylvains)
- Moisissures → mycotoxines (aflatoxines, ochratoxines)
- Prise en masse → grain inutilisable
- Pertes : 1-3% en bon stockage, 5-10% en mauvais stockage

#### SIMAGRI

- **Non modélisé** : pas de ventilation ni thermométrie
- Le grain stocké en silo reste en bon état indéfiniment
- Pas d'insectes de stockage
- Pas de pertes de stockage

#### CORRECT
- (Rien — absent)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser la thermométrie en détail
- Simplifier en "silo ventilé" vs "silo non ventilé"

#### FAUX ou MANQUANT
- Pas de dégradation du grain en stock (irréaliste sur une longue période)
- Pas d'investissement de ventilation/thermométrie
- Le stockage "gratuit et sans risque" pousse à stocker toujours (pas de coût d'opportunité)

#### RECOMMANDATION AGRIVA
- **Ajouter** : le silo a un niveau d'équipement (ventilé ou non)
- **Ajouter** : risque de perte si stockage long + silo non ventilé (1-3% si ventilé, 5-10% sinon)
- **Ajouter** : coût de fonctionnement annuel de la ventilation (charge légère)
- **Garder simple** : pas de thermométrie comme action joueur quotidienne

---

### 8.4 Paille

#### RÉALITÉ (France)

**Rendement paille :**
| Culture | Ratio paille/grain | Rendement paille (t/ha) | Indice récolte |
|---------|:-:|:-:|:-:|
| Blé tendre | 0.8-1.0 | 4-6 | 0.50-0.55 |
| Orge | 0.7-0.9 | 3-5 | 0.50-0.55 |
| Colza | 1.0-1.5 | 3-5 | 0.30-0.35 |
| Triticale | 1.0-1.2 | 5-7 | 0.45-0.50 |
| Maïs | 1.0 | 8-10 | 0.45-0.50 (mais rarement récoltée) |

**Conditionnement :**
- Balles rondes : 250-350 kg, ø1.5m, faciles à manipuler
- Balles carrées HD : 400-500 kg (80×80×240 cm)
- Balles géantes : 300-400 kg (120×90×240 cm) — transport longue distance
- Vrac (ensilage) : rare pour la paille

**Prix de la paille (2022-2024) :**
- Sur pied (vente au champ) : 10-20 €/t
- Rendue ferme (transport inclus) : 60-100 €/t
- Pénurie (année sèche/faible rendement) : jusqu'à 120-150 €/t
- En Bretagne (forte demande élevage) : +20-30% vs Beauce

**Usages :**
- Litière animaux : 65% de l'utilisation
- Alimentation (paille hachée dans les rations) : 15%
- Restitution au sol (broyage) : 15%
- Énergie (chauffage, méthanisation) : 5%
- Champignonnières : <1%

**Valeur agronomique de la paille restituée :**
- Matière organique : maintien du taux de MO du sol
- Éléments : 5-8 kg N, 2-3 kg P2O5, 10-15 kg K2O par tonne broyée
- Si exportée chaque année : appauvrissement progressif du sol en MO

#### SIMAGRI

- `has_straw = true` pour les céréales → paille disponible après moisson
- `straw_available = true` sur le crop si paille récoltée
- Broyage de paille = restitution d'éléments au sol
- Alternative : récolte (presse) → stockage → litière ou vente
- Pas de notion de rendement paille variable
- Pas de prix variable selon la zone ou l'année

#### CORRECT
- Le choix broyage/récolte est modélisé (bon arbitrage agronomique)
- La paille est liée à la litière animale (lien cultures-élevage)
- Le broyage restitue des éléments (réaliste)

#### SIMPLIFIÉ (acceptable)
- Pas de rendement paille variable selon la culture
- Prix fixe plutôt que variable

#### FAUX ou MANQUANT
- **Pas de conséquence à long terme** de l'exportation systématique de paille (baisse MO)
- **Pas de prix variable** selon la zone (excédentaire/déficitaire) ou l'année
- **Pas de conditionnement** (balles rondes vs carrées — impact logistique et stockage)
- Pas de quantité de paille proportionnelle au rendement grain

#### RECOMMANDATION AGRIVA
- **Garder** : le choix broyage vs récolte
- **Garder** : la paille comme lien avec l'élevage (litière)
- **Ajouter** : quantité de paille proportionnelle au rendement grain (ratio ~0.8-1.0)
- **Ajouter** : l'exportation répétée de paille fait baisser la MO du sol (effet long terme sur rendement)
- **Ajouter** : prix variable selon zone (excédentaire = 50€/t, déficitaire = 100€/t)
- **Optionnel** : format de balle (rond/carré) pour le stockage et le transport




---

## 9. Rotation des cultures

### 9.1 Principes agronomiques

#### RÉALITÉ (France)

**Pourquoi la rotation est essentielle :**
1. **Santé des sols** : chaque culture exploite des nutriments et laisse des résidus différents
2. **Pression parasitaire** : les ravageurs et maladies sont souvent spécifiques (piétin-échaudage du blé sur blé, nématodes de la betterave)
3. **Gestion des adventices** : alterner cultures d'hiver et de printemps casse le cycle des adventices
4. **Structure du sol** : alternance racines pivotantes (colza) et fasciculées (céréales)
5. **Fixation d'azote** : les légumineuses (pois, féverole) laissent 30-40 kg N/ha au suivant

**Notion de précédent cultural :**
| Précédent | Effet sur blé suivant | Mécanisme |
|-----------|:---------------------:|-----------|
| Pois / Féverole | +5 à +10 q/ha | Azote résiduel + effet "break" |
| Colza | +5 à +8 q/ha | Effet structurant + break parasitaire |
| Betterave | +3 à +5 q/ha | Sol propre + structure |
| Pomme de terre | +3 à +5 q/ha | Sol meuble + propre |
| Maïs | 0 à +3 q/ha | Résidus difficiles à gérer |
| Blé sur blé | -5 à -10 q/ha | Piétin-échaudage, adventices, fatigue |
| Tournesol | +2 à +5 q/ha | Break modéré |

**Tête de rotation :**
- Culture qui "ouvre" la rotation = le meilleur précédent
- En France : colza ou pois/féverole = meilleures têtes de rotation pour blé
- Betterave = excellente tête de rotation (sol propre et structuré)

**Notion de culture de "rente" vs culture de "service" :**
- Rente : blé, maïs (les plus rentables/ha)
- Service : colza (valorise le blé suivant), pois (fixe N, break maladies)

#### SIMAGRI

- `rotation_years` : nombre de saisons minimum avant de resemer la même culture
- Vérification : la culture ne doit pas avoir été faite dans les N dernières saisons
- En bio : rotation +1 an supplémentaire
- Pas de notion de "bon" ou "mauvais" précédent
- Pas de bonus/malus selon le précédent
- Historique parcellaire (`parcel_history`) : saison, culture, rendement

#### CORRECT
- L'obligation de rotation est modélisée (pas de monoculture)
- La rotation plus stricte en bio est réaliste
- L'historique parcellaire est conservé

#### SIMPLIFIÉ (acceptable)
- Un délai minimum plutôt qu'un système de précédent complexe
- Pas de distinction entre "bon" et "mauvais" précédent

#### FAUX ou MANQUANT
- **Pas d'effet précédent** : le colza avant blé et le blé avant blé donnent le même rendement (en réalité : +5-10 q/ha de différence !)
- **Pas de pénalité blé/blé** au-delà de l'interdiction de rotation (rotation_years = 1 an pour blé → blé/blé est autorisé !)
- **Pas de fixation d'azote par les légumineuses** → pas d'intérêt agronomique à mettre du pois
- **Pas de pression maladie cumulative** (piétin-échaudage augmente avec les blés successifs)
- **Rotation blé = 1 an** signifie qu'on peut faire blé/blé en permanence → irréaliste (en réalité possible mais très pénalisant)

#### RECOMMANDATION AGRIVA
- **Garder** : la rotation minimum comme garde-fou
- **Ajouter** : BONUS de rendement selon le précédent (le plus important !) :
  - Légumineuse avant blé : +8%
  - Colza avant blé : +6%
  - Blé après blé : -8% (et -15% en 3ème blé)
  - Betterave/PDT avant blé : +5%
- **Ajouter** : les légumineuses restituent de l'azote au sol (économie de 40-50 kg N pour le suivant)
- **Ajouter** : pression maladie croissante si même famille botanique répétée
- **Gameplay** : rend la planification de rotation stratégique et intéressante (pas juste une contrainte)

---

### 9.2 Exemples de rotations réelles par région

#### RÉALITÉ (France)

**Beauce / Île-de-France (grandes cultures, sols profonds) :**
- Colza → Blé → Orge (3 ans, la plus classique)
- Colza → Blé → Blé → Orge (4 ans)
- Betterave → Blé → Colza → Blé (4 ans, zone betteravière)
- Pois → Blé → Colza → Blé (4 ans, avec légumineuse)

**Nord / Picardie (sols limoneux, polyculture) :**
- Betterave → Blé → Pois → Blé → Colza → Blé (6 ans)
- PDT → Blé → Betterave → Blé → Lin → Blé (6 ans)

**Sud-Ouest (conditions sèches, irrigation) :**
- Maïs → Blé → Tournesol (3 ans irrigué)
- Soja → Blé → Maïs → Tournesol (4 ans)
- Sorgho → Blé → Tournesol (3 ans sec)

**Ouest / Bretagne (polyculture-élevage) :**
- Maïs ensilage → Blé → RGI (Ray-grass) → Maïs (3-4 ans)
- Prairie temporaire (3 ans) → Blé → Maïs → Blé (6 ans)

**Bio (rotations longues obligatoires) :**
- Luzerne (3 ans) → Blé → Féverole → Triticale → Méteil → Retour luzerne (8 ans)
- Prairie (4 ans) → Maïs → Blé → Pois → Blé (9 ans)

#### SIMAGRI

- Pas de rotation type suggérée
- Le joueur est libre de choisir (dans les limites du rotation_years)
- Pas de distinction régionale des assolements

#### CORRECT
- La liberté de choix du joueur est réaliste (chaque agriculteur construit sa rotation)

#### SIMPLIFIÉ (acceptable)
- Pas de rotation "type" imposée

#### FAUX ou MANQUANT
- Pas d'aide ou de suggestion de rotation
- Pas d'incitation économique à diversifier (sauf l'interdiction de retour)
- Pas de rotation spécifique au bio (plus longue, plus diversifiée)

#### RECOMMANDATION AGRIVA
- **Ajouter** : système de conseil/suggestion de rotation (aide au joueur novice)
- **Ajouter** : les bonus précédent rendent naturellement certaines rotations plus rentables
- **Ajouter** : en bio, rotation minimum plus longue (déjà dans SimAgri : +1 an, mais insuffisant)
- **Optionnel** : bonus PAC/MAEC si rotation diversifiée (≥4 cultures différentes sur l'exploitation)

---

### 9.3 Contraintes réglementaires (BCAE, diversification PAC)

#### RÉALITÉ (France)

**BCAE 7 (Rotation des cultures) — PAC 2023-2027 :**
- Obligation de rotation : chaque parcelle doit avoir une culture différente au moins 1 an sur 3
- OU la parcelle doit avoir un couvert intermédiaire (CIPAN) entre 2 cultures identiques

**BCAE 8 (Éléments non productifs) :**
- 4% de la SAU en jachère ou éléments non productifs (haies, mares...)
- Ou 7% avec cultures fixatrices d'azote incluses

**Diversification :**
- Au moins 2 cultures si SAU > 10 ha (culture principale < 75%)
- Au moins 3 cultures si SAU > 30 ha (2 principales < 95%, 1ère < 75%)

**Éco-régime (bonus PAC +70 €/ha environ) :**
- Voie diversification : ≥4 cultures, chaque culture 5-60% de la SAU
- Voie certification : HVE niveau 3 ou bio

**Sanctions :**
- Non-conformité BCAE = réduction des aides PAC (3-5% la première année, jusqu'à 100% en cas de répétition)

#### SIMAGRI

- **Quotas** : betterave (2 ha ou 10% SAU), tabac (2 ha max)
- Pas de BCAE, pas de diversification obligatoire
- Pas de PAC, pas d'éco-régime
- Pas de jachère obligatoire

#### CORRECT
- Les quotas de betterave et tabac sont des formes de limitation (bon gameplay)

#### SIMPLIFIÉ (acceptable)
- Pas de PAC complète (trop administratif pour un jeu)

#### FAUX ou MANQUANT
- Pas de diversification obligatoire (un joueur peut faire 100% blé partout sauf contrainte rotation)
- Pas de jachère
- Pas de récompense pour la diversification
- Pas d'aide découplée (PAC = 260 €/ha en moyenne en France, soit 50% du revenu !)

#### RECOMMANDATION AGRIVA
- **Ajouter** : une forme simplifiée de "subvention PAC" (revenu de base par ha, conditionné à des bonnes pratiques)
- **Ajouter** : bonus si diversification (≥3-4 cultures) → "éco-prime"
- **Ajouter** : obligation de 4-5% de surfaces en jachère ou haies
- **Gameplay** : la PAC simplifiée crée un vrai système de récompense de la bonne gestion
- **Impact** : sans PAC, la marge nette des grandes cultures serait souvent négative → économie irréaliste

---

## 10. Sol

### 10.1 Types de sol en France

#### RÉALITÉ (France)

**Principaux types de sol agricole :**

| Type | Régions typiques | Argile % | Limon % | Sable % | Caractéristiques |
|------|-----------------|:-------:|:-------:|:-------:|------------------|
| Argilo-calcaire | Champagne, Beauce (sud) | 30-45 | 30-40 | 15-30 | Très fertile, difficile à travailler humide |
| Limoneux profond | Beauce, Picardie, Nord | 15-25 | 50-70 | 10-25 | Très fertile, battance, érosion |
| Limon argileux | Bassin parisien (périphérie) | 25-35 | 40-50 | 15-25 | Bon compromis, polyvalent |
| Argile lourde | Lauragais, Garonne | 40-60 | 20-30 | 10-20 | Riche mais difficile (fenêtres travail étroites) |
| Sablo-limoneux | Landes, Sologne | 5-15 | 20-40 | 40-60 | Facile à travailler, séchant, pauvre |
| Sableux | Landes, Champagne pouilleuse | 3-10 | 10-20 | 60-80 | Très séchant, acide, irrigation nécessaire |
| Limon battant | Haute-Normandie, Vexin | 10-18 | 60-75 | 10-25 | Très fertile mais croûte de battance |
| Craie (rendzine) | Champagne | 15-25 | 30-40 | 20-30 | Superficiel, calcaire, drainage naturel |
| Boulbène | Sud-Ouest | 10-20 | 50-65 | 20-35 | Acide, battant, fragile |
| Terres noires | Limagne | 30-40 | 30-40 | 15-25 | Extrêmement fertile (MO 4-6%) |

**Impact du type de sol sur l'agriculture :**
| Caractéristique | Argile | Limon | Sable |
|-----------------|--------|-------|-------|
| Réserve en eau (RU) | 120-180 mm/m | 150-200 mm/m | 60-100 mm/m |
| Jours travaillables | 100-120/an | 140-160/an | 200+/an |
| Fertilité naturelle | Élevée | Élevée | Faible |
| Risque érosion | Faible | Élevé (battance) | Faible |
| Risque compaction | Élevé | Moyen | Faible |
| Drainage nécessaire | Souvent | Parfois | Jamais |
| pH naturel | Variable | Variable | Acide (5-6) |
| Potentiel rendement | Élevé | Très élevé | Moyen-Faible |

#### SIMAGRI

- `soil_quality` : 3 niveaux (1, 2, 3) → multiplicateur (0.8, 1.0, 1.2)
- `stones` : booléen (pierres dans le sol → -5%)
- Pas de type de sol (texture)
- Pas de réserve utile en eau
- Pas de comportement différent selon le sol face à la météo
- La qualité est fixe (pas d'évolution)

#### CORRECT
- 3 niveaux de qualité capturent la variabilité inter-parcelles
- Les pierres comme facteur pénalisant (réaliste pour les sols crayeux)

#### SIMPLIFIÉ (acceptable)
- 3 niveaux au lieu de la granulométrie complète
- Pas de triangle des textures

#### FAUX ou MANQUANT
- **Pas de type de sol** : un sol argileux et un sol sableux se comportent identiquement dans SimAgri
- **Pas de réserve utile en eau** : un sol sableux devrait sécher 2× plus vite qu'une argile
- **Pas de fenêtres de travail différentes** : l'argile est impraticable après pluie (4-5 jours de ressuyage) vs sable (1 jour)
- **Pas d'érosion** sur les limons battants
- **Pas de drainage** nécessaire sur certains sols
- **La qualité ne change pas** : en réalité, un sol peut se dégrader (compaction, perte MO) ou s'améliorer (amendements, couverts)

#### RECOMMANDATION AGRIVA
- **Modifier** : remplacer la qualité 1-2-3 par un TYPE de sol (3-5 types) avec des propriétés distinctes :
  - Limon profond : haute fertilité, risque battance, bonne réserve eau
  - Argile : haute fertilité, fenêtres travail réduites, haute réserve eau
  - Sablo-limoneux : fertilité moyenne, facile à travailler, réserve eau faible
  - Craie : fertilité moyenne, drainage naturel, superficiel
- **Ajouter** : chaque type de sol réagit différemment à la météo (séchage, praticabilité)
- **Ajouter** : la qualité peut évoluer lentement (MO monte avec couverts et fumier, baisse avec export paille)
- **Garder** : les pierres comme élément de gameplay (broyeur)

---

### 10.2 Matière organique

#### RÉALITÉ (France)

**Rôle de la matière organique (MO) :**
- Structure du sol (stabilité des agrégats, porosité)
- Rétention d'eau (+2-3 mm RU par % de MO)
- Fourniture d'azote (minéralisation : 15-30 kg N/ha/an par % de MO)
- Vie biologique (nourriture pour les organismes)
- CEC (1% MO ≈ 2-3 meq/100g de CEC)
- Stockage carbone (enjeu climatique)

**Taux optimaux :**
| Type de sol | MO optimale | Seuil d'alerte |
|-------------|:-:|:-:|
| Limon profond | 2.0-3.0% | <1.8% |
| Argile | 2.5-4.0% | <2.0% |
| Sable | 1.5-2.5% | <1.2% |
| Craie | 3.0-5.0% | <2.5% |

**Bilan humique annuel :**
- Pertes (minéralisation) : coefficient k2 = 1.5-2.5% du stock/an
- Apports : résidus de culture, paille broyée, fumier, couverts végétaux
- Un sol à 2% MO perd ~600 kg MO/ha/an par minéralisation
- Pour maintenir : 3-4 t de résidus/ha/an OU 15-20 t fumier/ha/3 ans

**Évolution :**
- Très lente : +0.1% de MO nécessite 5-10 ans de bonnes pratiques
- Prairies et couverts permanents = meilleurs constructeurs de MO
- Labour profond accélère la minéralisation (perte MO)
- Semis direct et TCS préservent la MO

#### SIMAGRI

- Pas de taux de MO dans le modèle de sol
- Les éléments nutritifs (N, P, K, Ca, Mg, S) sont modélisés mais pas la MO
- Le broyage de paille restitue des "unités" aux éléments mais pas à la MO spécifiquement
- Pas de minéralisation annuelle
- Pas de bilan humique

#### CORRECT
- Le broyage de paille comme restitution est un début de gestion MO
- Le compost et le fumier apportent des éléments (proxy de la MO)

#### SIMPLIFIÉ (acceptable)
- Ne pas modéliser le C/N des résidus et la cinétique de décomposition

#### FAUX ou MANQUANT
- **La MO est LE paramètre de fertilité long terme** — son absence est un manque fondamental
- Pas de lien entre MO et fourniture d'azote (économie d'engrais)
- Pas de lien entre MO et rétention d'eau (résilience à la sécheresse)
- Pas de dégradation progressive du sol si mauvaises pratiques (export paille systématique, pas de fumure organique)
- Pas de lien technique culturale → évolution MO (semis direct > TCS > labour)

#### RECOMMANDATION AGRIVA
- **Ajouter** : taux de MO comme paramètre du sol (entre 1 et 5%)
- **Ajouter** : la MO évolue lentement (+0.05%/an avec bonnes pratiques, -0.05%/an avec mauvaises)
- **Ajouter** : la MO influence : rendement (+2% rendement par +0.5% MO), rétention eau, fourniture N
- **Ajouter** : facteurs positifs (fumier, couverts, broyage paille, prairie temporaire) et négatifs (export paille, pas d'apport organique)
- **Gameplay** : dimension stratégique long terme (investir dans son sol = rendements futurs)

---

### 10.3 Structure du sol (compaction)

#### RÉALITÉ (France)

**Compaction :**
- Causée par le passage de machines lourdes en conditions humides
- Semelle de labour à 25-30 cm (passage répété de la charrue à même profondeur)
- Compaction profonde (>30 cm) : quasi-irréversible naturellement
- Compaction superficielle : corrigeable par travail du sol

**Effets :**
- Réduction de la porosité → mauvaise infiltration d'eau
- Asphyxie racinaire → racines superficielles
- Rendement -10 à -30% (en interaction avec le stress hydrique)
- Favorise le ruissellement et l'érosion

**Indicateurs :**
- Profil cultural (observation à la bêche)
- Pénétromètre (résistance >2.5 MPa = compacté)
- Test de l'enracinement (racines horizontales = semelle)

**Solutions :**
- Décompacteur/sous-soleur (travail à 35-40 cm) : 40-60 €/ha
- Réduction du poids des machines (pneus basse pression)
- Non-travail du sol (le gel et la biologie décompactent lentement)
- Cultures à racines pivotantes (colza, luzerne)

#### SIMAGRI

- **Non modélisé** : pas de compaction
- Pas de conséquence du passage de machines lourdes
- Pas de sous-soleur/décompacteur dans le catalogue
- Pas de lien entre météo + travail → dégradation structure

#### RECOMMANDATION AGRIVA
- **Ajouter** : risque de compaction si travail du sol en conditions humides (lié à la météo)
- **Ajouter** : pénalité progressive de rendement (-5 à -15%) si compaction
- **Ajouter** : décompactage comme opération corrective (coût + temps)
- **Garder simple** : pas de modèle de porosité, juste un indicateur "compacté" oui/non avec gravité

---

### 10.4 Vie biologique du sol

#### RÉALITÉ (France)

**Organismes clés :**
| Organisme | Quantité/ha sol sain | Rôle | Menace |
|-----------|:---:|---|---|
| Vers de terre | 1-4 t/ha (1-3 millions) | Structure, drainage, MO | Labour, pesticides |
| Bactéries | 1-2 t/ha | Minéralisation N, cycles | Faible MO |
| Champignons | 2-5 t/ha | Décomposition, mycorhizes | Fongicides sol, labour |
| Mycorhizes | 80-90% des plantes | Absorption P, eau, résistance stress | Labour, phosphore excès |
| Collemboles, acariens | Milliards | Fragmentation MO | Insecticides sol |

**Impact sur les rendements :**
- Sol biologiquement actif : +5 à +15% de rendement vs sol "mort"
- Mycorhizes : +10-30% d'absorption du phosphore
- Vers de terre : drainage naturel (galeries), meilleure structure

**Facteurs favorables :**
- Non-labour (semis direct)
- Couverture permanente du sol (couverts, mulch)
- Apports organiques réguliers
- Réduction des pesticides (surtout insecticides et fongicides de sol)
- Rotations diversifiées

#### SIMAGRI

- **Non modélisé** : pas de vie biologique du sol
- Les haies apportent un "bonus rendement" et "réduction maladies" (proxy indirect)
- Pas de vers de terre, mycorhizes, activité biologique
- Le BIO n'a pas de bonus lié à la vie du sol

#### RECOMMANDATION AGRIVA
- **Ajouter** : un indicateur "santé biologique du sol" (simplifié en score 1-5)
- **Ajouter** : influencé par : technique culturale (SD > TCS > labour), couverts, pesticides, MO
- **Ajouter** : bonus rendement progressif (+2 à +8%) quand le score est élevé
- **Ajouter** : le bio bénéficie naturellement d'un meilleur score biologique à long terme
- **Garder simple** : un seul score composite, pas chaque organisme séparément
- **Gameplay** : récompense les stratégies de long terme (5-10 saisons pour construire un sol vivant)

---

### 10.5 Drainage

#### RÉALITÉ (France)

**Nécessité :**
- 10-15% de la SAU française est drainée (~3 millions ha)
- Sols concernés : argiles, limons hydromorphes, zones de nappe haute
- Sans drainage : asphyxie racinaire, portance insuffisante, semis impossible au printemps

**Types :**
- Drainage enterré (drains PVC perforés à 80-120 cm) : le plus courant
- Drainage de surface (fossés, rigoles) : zones humides
- Mole-drainage (galeries mécaniques) : complément temporaire

**Coûts :**
- Installation : 2 000-4 000 €/ha (drains + collecteur + émissaire)
- Durée de vie : 30-50 ans
- Entretien : curage émissaire tous les 5-10 ans (500-1 000 €)
- Amortissement annuel : 50-100 €/ha

**Impact :**
- Rendement sur sol drainé vs non drainé (quand nécessaire) : +20 à +50%
- Jours travaillables : +20-40 jours/an
- Permet les cultures de printemps (sol ressuyé à temps)

#### SIMAGRI

- **Non modélisé** : pas de drainage
- Pas d'hydromorphie
- Pas de nappe haute
- Pas de sol engorgé

#### RECOMMANDATION AGRIVA
- **Optionnel** : si le type de sol est modélisé, certains sols argileux pourraient nécessiter un drainage
- **Ajouter** : investissement drainage (2000-4000 €/ha) comme amélioration permanente de la parcelle
- **Ajouter** : sur sol argileux non drainé, les jours de travail sont réduits et les cultures de printemps risquées
- **Garder simple** : drainage = oui/non, avec un coût d'installation et un bénéfice permanent

---

### 10.6 Érosion

#### RÉALITÉ (France)

**Ampleur :**
- 18% des sols agricoles français affectés par l'érosion hydrique
- Perte moyenne : 1-5 t/ha/an (sols limoneux du Nord)
- Événements extrêmes : 10-50 t/ha en un seul orage (coulées de boue)
- Renouvellement naturel du sol : 0.1-0.5 t/ha/an → perte nette

**Facteurs de risque :**
- Sols limoneux battants (nord de la France, Normandie, Picardie)
- Pentes >2%
- Sol nu en hiver (interculture sans couvert)
- Grandes parcelles sans haies ni talus
- Labour dans le sens de la pente
- Cultures à faible couverture (betterave, maïs au printemps)

**Solutions :**
- Couverts végétaux d'interculture (obligation BCAE)
- Bandes enherbées le long des cours d'eau (obligation)
- Haies et talus perpendiculaires à la pente
- Non-labour / TCS (résidus en surface protègent le sol)
- Travail perpendiculaire à la pente

**Impact économique :**
- Perte de terre = perte de fertilité à long terme (irréversible à l'échelle humaine)
- Coulées de boue = dommages aux villages en aval (responsabilité de l'exploitant)
- Curage des fossés : coût collectivité

#### SIMAGRI

- **Non modélisé** : pas d'érosion
- Pas de pente
- Pas de couvert d'interculture obligatoire (les CIPAN existent mais sans obligation)
- Les haies ont un bonus mais pas lié à l'anti-érosion

#### RECOMMANDATION AGRIVA
- **Optionnel** : l'érosion est un processus très lent, difficile à rendre fun en jeu
- **Ajouter simplement** : les couverts d'interculture (CIPAN) comme bonne pratique avec un petit bonus (qualité sol +)
- **Ajouter** : les haies protègent contre l'érosion (déjà un bonus dans SimAgri, à renforcer)
- **Si ajouté** : perte très lente de qualité du sol sans couverts ni haies sur sols à risque (limoneux + pente)
- **Gameplay** : incitation aux couverts et haies plutôt que punition




---

## 11. Rendements réels de référence

### Tableau des rendements moyens France (2019-2023)

#### RÉALITÉ (France — source Agreste, FranceAgriMer)

| Culture | Rendement moyen (q/ha) | Min 5 ans | Max 5 ans | Écart-type | Surface (Mha) |
|---------|:----------------------:|:---------:|:---------:|:----------:|:-------------:|
| Blé tendre | 72 | 63 (2020) | 78 (2019) | 6 | 4.8 |
| Blé dur | 55 | 48 | 62 | 5 | 0.3 |
| Orge hiver | 67 | 58 | 73 | 5 | 1.3 |
| Orge printemps | 58 | 50 | 63 | 5 | 0.6 |
| Triticale | 52 | 45 | 57 | 4 | 0.3 |
| Avoine | 42 | 36 | 47 | 4 | 0.1 |
| Maïs grain | 90 | 82 | 98 | 6 | 1.5 |
| Maïs ensilage | 140 (MS) | 120 | 155 | 12 | 1.4 |
| Colza | 33 | 28 | 37 | 3 | 1.1 |
| Tournesol | 24 | 20 | 27 | 3 | 0.7 |
| Pois protéagineux | 40 | 32 | 45 | 5 | 0.2 |
| Féverole | 35 | 28 | 40 | 5 | 0.08 |
| Soja | 26 | 22 | 30 | 3 | 0.2 |
| Lin fibre | 68 (tiges) | 55 | 78 | 8 | 0.1 |
| Betterave sucrière | 850 (racines) | 750 | 920 | 60 | 0.4 |
| Pomme de terre (conso) | 450 | 380 | 500 | 40 | 0.15 |
| Pomme de terre (fécule) | 480 | 400 | 530 | 45 | 0.02 |
| Luzerne | 100 (MS total/an) | 80 | 120 | 15 | 0.3 |

### Rendements records (potentiel génétique en conditions optimales)

| Culture | Record France (q/ha) | Conditions |
|---------|:---:|---|
| Blé tendre | 130-140 | Picardie, sol profond, irrigué, tout optimum |
| Orge | 110-120 | Nord, excellent précédent |
| Maïs grain | 150-170 | Alsace/Sud-Ouest irrigué |
| Colza | 55-60 | Picardie, année exceptionnelle |
| Betterave | 1200+ | Picardie, variété performante |
| Pomme de terre | 700+ | Variétés industrielles, irrigation |

### Prix de vente moyens (2022-2024, €/t départ ferme)

| Culture | Prix moyen | Plage | Prix BIO | Volatilité |
|---------|:----------:|:-----:|:--------:|:----------:|
| Blé tendre | 210-250 | 150-350 | 350-450 | Élevée |
| Blé dur | 280-350 | 200-450 | 450-550 | Élevée |
| Orge | 190-230 | 140-300 | 300-400 | Élevée |
| Maïs grain | 190-230 | 140-280 | 320-400 | Élevée |
| Colza | 450-520 | 350-700 | 700-900 | Très élevée |
| Tournesol | 400-480 | 300-600 | 650-850 | Élevée |
| Pois | 250-300 | 200-400 | 400-500 | Modérée |
| Betterave (16° polarisation) | 30-35 €/t | 25-45 | 50-60 | Faible (contractuel) |
| Pomme de terre (contrat) | 120-180 | 80-250 | 250-350 | Élevée |
| Pomme de terre (libre) | 80-400 | 50-1000 | - | Extrême |

**Note sur la volatilité des prix :**
- 2021 : blé = 200 €/t → 2022 (guerre Ukraine) : blé = 350 €/t → 2023 : retour à 220 €/t
- La volatilité est un élément majeur du risque économique agricole
- Les contrats à terme (MATIF) permettent de se couvrir

#### SIMAGRI

- Prix moyen fixe par culture dans `culture_definitions` (blé = 100 €/t dans le document)
- Prix dynamiques selon offre/demande entre joueurs
- Pas de données de rendement par région dans les docs consultées (mais table `culture_yields` existe)
- Pas de prix BIO distinct dans les données de base (mais le bio vend +20% minimum)

#### CORRECT
- Les prix dynamiques existent (offre/demande joueurs)
- Le bio a un premium (+20% min)
- Les rendements sont régionalisés (table culture_yields)

#### SIMPLIFIÉ (acceptable)
- Prix de base fixe ajusté par le marché
- Pas de volatilité "mondiale" (guerre, pandémie)

#### FAUX ou MANQUANT
- **Prix blé = 100 €/t** dans SimAgri est très en dessous de la réalité actuelle (200-250 €/t) — mais c'est cohérent dans l'économie interne du jeu
- **Pas de volatilité macro-économique** (événements mondiaux qui font varier les prix)
- **Pas de prix contractuel** (betterave, pomme de terre = contrats, pas de marché spot)
- **Pas de saisonnalité des prix** (prix bas à la moisson, remonte ensuite)
- Les prix SimAgri sont calibrés pour l'économie du jeu, pas sur les prix réels

#### RECOMMANDATION AGRIVA
- **Garder** : le système de prix dynamiques joueur
- **Ajouter** : saisonnalité des prix (bas en récolte, haut en hiver/printemps) → stratégie stockage
- **Ajouter** : événements mondiaux aléatoires qui font varier les prix (gameplay)
- **Ajouter** : contrats pour certaines cultures (betterave, PDT) = prix garanti mais engagement
- **Calibrer** : les prix relatifs entre cultures doivent refléter la réalité (colza > blé > maïs > orge en €/t, mais rendements différents)
- **Important** : l'économie du jeu ne doit pas refléter les prix réels en absolu, mais les RATIOS et la dynamique doivent être cohérents




---

## 12. Calendrier cultural réel

### 12.1 Blé tendre d'hiver (Centre France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Août** | Déchaumage | 1-2 passages post-récolte précédent |
| **Septembre** | Labour ou TCS, CIPAN si interculture longue | Préparation profonde |
| **Octobre** | Préparation lit semence + SEMIS (15-30 oct) | Herse rotative + semoir combiné |
| **Novembre** | Herbicide pré-levée (si programme automne) | Prosulfocarbe, chlortoluron |
| **Décembre** | Repos hivernal — surveillance limaces | Piège à limaces si pression |
| **Janvier** | Repos hivernal — plan de fumure | Analyse reliquat azoté (RSH) |
| **Février** | 1er apport azote (tallage), analyse RSH | 50-60 uN, ammonitrate |
| **Mars** | 2ème apport azote (épi 1cm), herbicide rattrapage | 60-80 uN + désherbage |
| **Avril** | Régulateur (1 nœud), T1 fongicide (2 nœuds), 3ème apport N | 40-50 uN, CCC, prothioconazole |
| **Mai** | T2 fongicide (dernière feuille), insecticide si pression | SDHI+triazole, surveillance cécidomyies |
| **Juin** | T3 fongicide (épiaison, si fusariose), irrigation (rare) | Tébuconazole si risque DON |
| **Juillet** | RÉCOLTE (5-25 juillet), pressage paille ou broyage | Moissonneuse, presse si récolte paille |

### 12.2 Orge d'hiver (Centre France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Août-Sept** | Déchaumage + préparation | Idem blé |
| **Octobre** | SEMIS (1-20 oct, plus précoce que blé) | Densité 250-300 gr/m² |
| **Novembre** | Herbicide automne | Programme précoce |
| **Déc-Janv** | Repos hivernal | - |
| **Février** | 1er apport N (tallage) | 40-50 uN |
| **Mars** | 2ème apport N, herbicide rattrapage, régulateur | 50-70 uN |
| **Avril** | Fongicide T1 (helminthosporiose, rhynchosporiose) | 1 passage souvent suffisant |
| **Mai** | Fongicide T2 (ramulariose, si pression) | Pas toujours nécessaire |
| **Juin** | RÉCOLTE (15-30 juin, 2-3 semaines avant blé) | Pressage paille |

### 12.3 Colza d'hiver (Centre France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Juillet** | Déchaumage dès récolte du précédent | Rapide ! Semis en août |
| **Août** | Préparation fine + SEMIS (20 août - 5 sept) | 35-50 gr/m², semoir céréales ou monograine |
| **Septembre** | Levée, surveillance altises | Insecticide si seuil atteint |
| **Octobre** | Insecticide charançon du bourgeon terminal si nécessaire | Piège jaune |
| **Novembre** | Raccourcisseur (metconazole) si biomasse forte | Régulation avant hiver |
| **Déc-Janv** | Repos hivernal | Évaluation pertes gel |
| **Février** | 1er apport azote (reprise) | 80-100 uN |
| **Mars** | 2ème apport azote, insecticide méligèthes + charançon tige | 60-80 uN, pyréthrinoïde |
| **Avril** | Fongicide sclérotinia (floraison) | 1 passage si risque |
| **Mai** | Surveillance siliques (charançon, puceron cendré) | Traitement si seuil |
| **Juin-Juillet** | RÉCOLTE (25 juin - 10 juillet) | Andainage possible, moissonneuse |

### 12.4 Maïs grain (Centre-Ouest France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Octobre-Nov** | CIPAN ou couvert après précédent | Moutarde, phacélie |
| **Février-Mars** | Destruction couvert, labour ou TCS | Glyphosate ou broyage + incorporation |
| **Avril** | Préparation lit semence, engrais de fond (P, K) | Herse rotative |
| **Avril-Mai** | SEMIS (15 avril - 10 mai, T° sol >10°C) | 85 000-95 000 grains/ha, semoir monograine |
| **Mai** | Herbicide post-levée (si programme tout chimique) | ou pré-levée au semis |
| **Juin** | 2ème apport N (8 feuilles), binage (si désherbé méca) | 120-150 uN |
| **Juillet** | Irrigation intensive (floraison = période critique) | 30-40 mm/semaine |
| **Août** | Irrigation (remplissage grain) | 20-30 mm/semaine |
| **Septembre** | Fin irrigation, dessication naturelle | Grain pâteux → dur |
| **Octobre-Nov** | RÉCOLTE (15 oct - 15 nov, humidité 25-32%) | Moissonneuse + séchage obligatoire |

### 12.5 Tournesol (Sud-Ouest France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Novembre-Fév** | Labour ou TCS, préparation | Sol nu hivernal |
| **Mars** | Préparation lit semence, engrais de fond | P, K, Bore |
| **Avril** | SEMIS (1-20 avril, T° sol >8°C) | 65 000-75 000 gr/ha, écartement 50-80 cm |
| **Mai** | Herbicide (pré ou post précoce), azote (60-80 uN) | Dose N modérée |
| **Juin** | Binage (désherbage mécanique possible) | Interrang large = binage facile |
| **Juillet** | Floraison (période critique eau) | Irrigation si disponible (50-100 mm) |
| **Août** | Dessication naturelle | Capitule se retourne |
| **Septembre** | RÉCOLTE (1-25 sept, humidité 9-11%) | Moissonneuse + kit tournesol |

### 12.6 Betterave sucrière (Nord France)

| Mois | Opérations | Détail |
|------|-----------|--------|
| **Septembre-Oct** | Déchaumage après récolte précédent | 1-2 passages |
| **Octobre-Nov** | Labour profond (sol argileux) ou TCS | 25-30 cm |
| **Janvier-Fév** | Reprise labour si nécessaire | Conditions permettent |
| **Mars** | Préparation fine (lit de semence très exigeant) | Betterave = petite graine |
| **Mars-Avril** | SEMIS (15 mars - 10 avril, T° sol >8°C) | 110 000-130 000 gr/ha, monograine 45 cm |
| **Avril** | Herbicide pré-levée | Programme démarrage |
| **Mai** | 2-3 passages herbicide post-levée | Betterave très sensible concurrence |
| **Juin** | Dernier herbicide, surveillance cercosporiose | Binage possible |
| **Juillet** | Fongicide cercosporiose (1er passage) | Si seuil dépassé |
| **Août** | Fongicide (2ème passage si nécessaire), irrigation | Maintien végétation active |
| **Septembre** | Effeuillage (si arraché tôt) | Début campagne sucrière |
| **Octobre-Nov** | RÉCOLTE (arracheuse 6 rangs) | Campagne sucrerie sept-janv, livraison programmée |

### 12.7 Synthèse calendrier (toutes cultures, Centre France)

| Mois | Blé H | Orge H | Colza | Maïs | Tournesol | Betterave |
|------|--------|--------|-------|------|-----------|-----------|
| **Jan** | Repos/RSH | Repos | Repos | CIPAN | Labour | Repos |
| **Fév** | N1 tallage | N1 tallage | N1 reprise | Dest. couvert | - | - |
| **Mar** | N2, herbi | N2, herbi, régul | N2, insecti | Labour/TCS | Prépa, engrais | Prépa fine |
| **Avr** | Régul, T1, N3 | T1 fongi | Fongi scléro | **SEMIS** | **SEMIS** | **SEMIS**, herbi |
| **Mai** | T2 fongi | T2 si nécess. | Surveil. siliques | Herbi, N2 | Herbi, N | Herbi ×3 |
| **Jun** | T3 si fusario | **RÉCOLTE** | **RÉCOLTE** | Irrigation | Binage | Fongi cerco |
| **Jul** | **RÉCOLTE** | Déchaum. | Déchaum. | Irrigation +++ | Floraison/irrig | Fongi, irrig |
| **Aoû** | Déchaum. | - | **SEMIS** colza | Irrigation | Dessication | Irrig |
| **Sep** | Prépa sol | Prépa sol | Levée, altises | Fin irrig | **RÉCOLTE** | **RÉCOLTE** début |
| **Oct** | **SEMIS** | **SEMIS** | Insecti CBT | **RÉCOLTE** | - | **RÉCOLTE** |
| **Nov** | Herbi aut. | Herbi aut. | Raccourcisseur | - | - | **RÉCOLTE** fin |
| **Déc** | Repos | Repos | Repos | - | - | - |

**Légende :** Gras = opération majeure (semis/récolte). N1/N2/N3 = apports azote. T1/T2/T3 = fongicides.




---

## 13. Coûts de production réels

### 13.1 Charges opérationnelles par culture (€/ha, 2022-2024)

| Poste | Blé tendre | Orge hiver | Colza | Maïs irrigué | Tournesol | Betterave | Pois |
|-------|:----------:|:----------:|:-----:|:------------:|:---------:|:---------:|:----:|
| Semences | 60 | 65 | 75 | 180 | 100 | 230 | 100 |
| Engrais (N+P+K) | 250 | 210 | 250 | 280 | 130 | 200 | 80 |
| Herbicides | 80 | 70 | 90 | 70 | 50 | 150 | 60 |
| Fongicides | 85 | 55 | 35 | 0 | 0 | 70 | 30 |
| Insecticides | 15 | 10 | 25 | 15 | 10 | 20 | 10 |
| Régulateur | 20 | 20 | 15 | 0 | 0 | 0 | 0 |
| Irrigation | 0 | 0 | 0 | 350 | 80 | 100 | 0 |
| Séchage | 0 | 0 | 0 | 300 | 15 | 0 | 0 |
| **TOTAL charges opé** | **510** | **430** | **490** | **1195** | **385** | **770** | **280** |

### 13.2 Charges de mécanisation (€/ha)

| Poste | Blé tendre | Colza | Maïs irrigué | Betterave |
|-------|:----------:|:-----:|:------------:|:---------:|
| Travail du sol | 80-120 | 80-120 | 80-120 | 100-140 |
| Semis | 30-45 | 30-45 | 40-55 | 50-70 |
| Fertilisation | 20-30 | 20-30 | 25-35 | 20-30 |
| Traitements | 30-50 | 40-60 | 20-30 | 50-70 |
| Récolte | 80-120 | 80-120 | 100-140 | 150-200 |
| Paille (pressage) | 30-50 | - | - | - |
| **TOTAL mécanisation** | **270-415** | **250-375** | **265-380** | **370-510** |
| **Moyenne** | **340** | **310** | **320** | **440** |

**Composition du coût de mécanisation :**
- Amortissement matériel : 45%
- Carburant : 25%
- Entretien/réparations : 20%
- Assurance matériel : 10%

### 13.3 Charges de structure (€/ha, réparties sur la SAU)

| Poste | Montant indicatif | Détail |
|-------|:-:|---|
| Fermage (location terre) | 150-250 | Variable selon région (Beauce 200-250, Sud-Ouest 100-150) |
| MSA (cotisations sociales) | 80-120 | Proportionnel au revenu |
| Assurance récolte | 30-50 | Multirisque climatique |
| Comptabilité/gestion | 20-30 | Centre de gestion |
| Divers (taxes, CFE, eau) | 20-40 | Charges fixes |
| **TOTAL structure** | **300-490** | |
| **Moyenne** | **380** | |

### 13.4 Marge brute par culture (€/ha)

```
Marge brute = Produit (rendement × prix) − Charges opérationnelles
```

| Culture | Rendement | Prix (€/t) | Produit brut | Charges opé | **Marge brute** | Paille | **MB + paille** |
|---------|:---------:|:----------:|:------------:|:-----------:|:---------------:|:------:|:---------------:|
| Blé tendre | 75 q | 220 | 1650 | 510 | **1140** | +150 | **1290** |
| Orge hiver | 70 q | 200 | 1400 | 430 | **970** | +120 | **1090** |
| Colza | 34 q | 480 | 1632 | 490 | **1142** | - | **1142** |
| Maïs irrigué | 100 q | 200 | 2000 | 1195 | **805** | - | **805** |
| Tournesol | 25 q | 440 | 1100 | 385 | **715** | - | **715** |
| Betterave | 85 t | 32 | 2720 | 770 | **1950** | - | **1950** |
| Pois | 40 q | 270 | 1080 | 280 | **800** | - | **800** |
| PDT contrat | 45 t | 150 | 6750 | 3500 | **3250** | - | **3250** |

**Observations :**
- Betterave et PDT = marges brutes les plus élevées mais investissements lourds et quotas
- Blé et colza = base stable et fiable du revenu en grandes cultures
- Maïs irrigué = marge correcte MAIS très sensible au prix de l'eau et de l'énergie
- Tournesol = marge modeste mais charges faibles → culture de "sécurité"
- Pois = marge faible mais économie d'engrais N + effet précédent sur le blé suivant (+80-120 €/ha de blé)

### 13.5 Marge nette et revenu (€/ha)

```
Marge nette = Marge brute − Charges mécanisation − Charges structure
```

| Culture | Marge brute | Mécanisation | Structure | **Marge nette** |
|---------|:-----------:|:------------:|:---------:|:---------------:|
| Blé tendre (+paille) | 1290 | 340 | 380 | **570** |
| Orge hiver (+paille) | 1090 | 310 | 380 | **400** |
| Colza | 1142 | 310 | 380 | **452** |
| Maïs irrigué | 805 | 320 | 380 | **105** |
| Tournesol | 715 | 280 | 380 | **55** |
| Betterave | 1950 | 440 | 380 | **1130** |
| Pois | 800 | 270 | 380 | **150** |

**Marge nette moyenne exploitation grandes cultures (150 ha, rotation classique) :**
- Rotation Colza-Blé-Orge : ~470 €/ha net en moyenne
- 150 ha × 470 €/ha = **70 500 € de revenu** avant rémunération exploitant et prélèvements privés
- Revenu net agricole moyen en grandes cultures : **30 000-50 000 €/an** (très variable)

### 13.6 Seuils de rentabilité (prix minimum pour couvrir les charges)

| Culture | Charges totales (€/ha) | Rendement moyen | **Seuil prix (€/t)** |
|---------|:----------------------:|:---------------:|:-------------------:|
| Blé tendre | 1230 (hors paille) | 75 q | **164** |
| Blé tendre (avec paille) | 1080 (net paille) | 75 q | **144** |
| Orge hiver | 1120 | 70 q | **160** |
| Colza | 1180 | 34 q | **347** |
| Maïs irrigué | 1895 | 100 q | **190** |
| Tournesol | 1045 | 25 q | **418** |
| Betterave | 1590 | 850 q | **19** |

**Interprétation :**
- Si le blé tombe sous 165 €/t → l'agriculteur perd de l'argent (hors paille)
- Le colza est rentable au-dessus de 350 €/t (actuellement à 450-520 → correct)
- Le tournesol a besoin de 420 €/t minimum (actuellement à 400-480 → marginal)
- La betterave est quasiment toujours rentable (prix contractuel garanti)

### 13.7 Subventions PAC (contexte économique crucial)

| Type d'aide | Montant indicatif (€/ha) | Condition |
|-------------|:------------------------:|-----------|
| DPB (Droit à Paiement de Base) | 120-140 | Détenir des droits, respecter BCAE |
| Paiement redistributif | 50-55 | Premiers 52 ha |
| Éco-régime | 60-80 | Diversification ou certification |
| Paiement vert (ancien) | - | Remplacé par éco-régime |
| MAEC (optionnel) | 70-200 | Engagement 5 ans, pratiques vertueuses |
| **TOTAL PAC moyen** | **230-275** | Pour 80% des exploitations |

**Impact sur la rentabilité :**
- Sans PAC, la marge nette moyenne serait de **200-250 €/ha** (au lieu de 430-500 €/ha)
- La PAC représente **40-55% du revenu** des grandes cultures en France
- C'est un élément structurel de l'économie agricole française

#### SIMAGRI et comparaison

**SimAgri ne modélise pas :**
- Les charges de structure (fermage, MSA, assurance récolte)
- Les charges de mécanisation détaillées (amortissement)
- La PAC (aucune subvention)
- Le séchage (maïs)
- Le fermage (achat de terre uniquement)
- Les cotisations sociales

**SimAgri modélise :**
- Achat d'intrants (semences, engrais, phytos) — mais à prix déconnectés de la réalité
- Carburant (HVC)
- Entretien matériel et bâtiments
- Électricité
- Salaires employés

#### RECOMMANDATION AGRIVA

**Économie :**
- **Ajouter** : charges de structure simplifiées (fermage, cotisations, assurance) comme charges fixes annuelles
- **Ajouter** : une forme de subvention PAC (revenu de base conditionnel) — sans cela l'économie est irréaliste
- **Ajouter** : séchage maïs comme coût obligatoire
- **Calibrer** : les prix des intrants pour que les marges soient cohérentes avec la réalité en ratio (pas en absolu)
- **Ajouter** : seuil de rentabilité visible par le joueur (outil d'aide à la décision)

**Gameplay :**
- Le joueur doit sentir la tension économique (pas toujours rentable, dépend du prix de vente)
- Les cultures à haute marge (betterave, PDT) doivent nécessiter plus d'investissement et de compétence
- Le choix de rotation doit avoir un vrai impact économique (pas seulement agronomique)
- La PAC simplifiée récompense les bonnes pratiques (diversification, couverts, bio)

---

## Synthèse — Recommandations prioritaires pour Agriva

### TOP 10 des ajouts les plus importants (par impact gameplay × réalisme)

| # | Ajout | Impact gameplay | Réalisme | Complexité dev |
|:-:|-------|:-:|:-:|:-:|
| 1 | **Effet précédent cultural** (bonus/malus selon rotation) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Faible |
| 2 | **Fractionnement azote** (2-3 apports, timing = efficacité) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Moyenne |
| 3 | **Saisonnalité des prix** (bas moisson, haut hiver) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Faible |
| 4 | **Variabilité rendement inter-annuelle** (météo globale) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Faible |
| 5 | **Phases de croissance** (4-5 phases au lieu de linéaire) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Moyenne |
| 6 | **Type de sol** (3-5 types avec propriétés distinctes) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Moyenne |
| 7 | **Dose engrais proportionnelle** (pas binaire) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Moyenne |
| 8 | **Verse** (risque lié à vent + azote + variété) | ⭐⭐⭐ | ⭐⭐⭐⭐ | Moyenne |
| 9 | **Restrictions sécheresse** (événement limitant irrigation) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Faible |
| 10 | **PAC simplifiée** (subvention conditionnelle) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Moyenne |

### Ce qui est BON dans SimAgri et à garder tel quel

1. ✅ Les 3 techniques culturales (traditionnelle, TCS, semis direct) comme choix stratégique
2. ✅ Le système de jauges eau/soleil comme proxy de la météo
3. ✅ Les multiplicateurs de rendement (approche correcte)
4. ✅ La distinction fumier/lisier/engrais/compost/digestat
5. ✅ Le choix broyage paille vs récolte
6. ✅ Les fenêtres de semis/récolte par culture
7. ✅ Le bonus haies (réduction maladies, rendement)
8. ✅ La rotation comme contrainte
9. ✅ Les 3 niveaux de qualité
10. ✅ Les CIPAN/engrais verts

### Ce qui est FAUX et à corriger en priorité

1. ❌ Fertilisation binaire (on/off au lieu de proportionnelle)
2. ❌ Pas d'effet précédent (colza avant blé = blé avant blé)
3. ❌ Croissance linéaire identique toute l'année
4. ❌ Forage à 150€ (devrait être 20 000-50 000€)
5. ❌ Semis direct à -15% systématique (devrait s'améliorer avec le temps)
6. ❌ Prix phytos très sous-estimés (14€/ha vs 80-120€/ha réels)
7. ❌ Pas de dégradation post-maturité (récolte tardive sans conséquence)
8. ❌ Eau illimitée (pas de restriction sécheresse)
9. ❌ Pas de coût de séchage maïs
10. ❌ Pas de saisonnalité des prix

---

> **Ce document est une base de conception. Les données chiffrées sont des ordres de grandeur basés sur les statistiques françaises 2019-2024 (Agreste, ARVALIS, Chambres d'agriculture, FranceAgriMer). Pour le calibrage final du simulateur, une validation par un ingénieur agronome est recommandée.**

