> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# Matrice de couverture fonctionnelle — DÉFINITIVE

> Date : 2026-08-04
> Source : `INVENTAIRE_SYSTEMES.md` (119 sous-systèmes SimAgri)
> Cible : les 23 GDD de `docs/design/`
> Statut : ✅ audit final validé

## Synthèse

| Statut | Nombre | % |
|--------|:------:|:-:|
| ✅ Couvert (GDD avec paramètres chiffrés) | 112 | 94,1% |
| 🔧 Architecture (hors périmètre GDD) | 2 | 1,7% |
| 🗑️ Écarté volontairement (V2) | 5 | 4,2% |
| ❌ Absent | **0** | **0%** |
| **TOTAL** | **119** | **100%** |

## Verdict

### ✅ COUVERTURE FONCTIONNELLE COMPLÈTE — 100% des systèmes sont statués

Aucun système n'est laissé sans décision. Les 119 sous-systèmes de SimAgri sont soit conçus dans un GDD, soit renvoyés à la phase Architecture (détails techniques), soit écartés avec justification.

**Correction apportée après vérification manuelle** : deux systèmes signalés « absents » par l'audit automatique sont en réalité couverts :
- **4.15 Quotas** → `GDD-cultures.md` §8.6 (betterave 10% SAU ou 2 ha min, tabac 2 ha max, PDT 20%, lin 15% — mécaniques et conséquences de dépassement chiffrées)
- **4.16 Engrais verts / CIPAN** → `GDD-specialisations-vegetales.md` §6 (7 espèces avec coûts, dates de semis/destruction, effets azote/structure/MO chiffrés, CIVE méthanisation)

## Systèmes renvoyés à l'Architecture (2)

| # | Système | Justification |
|---|---------|---------------|
| 1.1 | Authentification | JWT, bcrypt, sessions = implémentation technique sans mécanique de jeu. À traiter dans `ADR-010`. |
| 1.12 | Short IDs | Format d'identifiant, séquence PostgreSQL = choix technique. À traiter dans `ADR-006`. |

## Systèmes écartés volontairement (5)

| # | Système | Justification de l'écartement |
|---|---------|------------------------------|
| 5.20 | Chien de troupeau | Bonus marginal de temps au pâturage. Reporté V2 — n'ouvre ni ne bloque aucun autre système. |
| 5.22 | Négociant en bestiaux | Redondant avec le marché joueur↔joueur déjà conçu (`GDD-marche` + `GDD-social-multijoueur`). |
| 6.14 | Location de matériel | Micro-fonctionnalité du concessionnaire. Le principe est décrit dans `GDD-materiel` §7.4 ; le détail opérationnel est reporté V2. |
| 6.15 | Assurance matériel | Couvert en principe dans `GDD-materiel` §4.6. Les variantes de contrat sont reportées V2. |
| 7.10 | Organisme Partcel | Fusionné : le mécanisme d'achat/vente de parcelles est couvert par `GDD-economie-base` §4 et `GDD-parcelles-sol`. Pas besoin d'un intermédiaire PNJ dédié. |

## Trous restants

**Aucun.**

> Date : 2026-08-04
> Source : INVENTAIRE_SYSTEMES.md (119 sous-systèmes SimAgri)
> Cible : les 23 GDD de docs/design/
> Statut : audit final

## Synthèse

| Statut | Nombre | % |
|--------|:------:|:-:|
| ✅ COUVERT | 112 | 94,1% |
| 🔧 ARCHITECTURE | 2 | 1,7% |
| 🗑️ ÉCARTÉ (V2 / fusionné) | 5 | 4,2% |
| ❌ ABSENT | 0 | 0% |
| **TOTAL** | **119** | **100%** |

**Couverture fonctionnelle effective (COUVERT + ARCHI + ÉCARTÉ)** : 119/119 = **100%**
**Couverture GDD directe (COUVERT uniquement)** : 112/119 = **94,1%**

## Verdict

✅ **COUVERTURE QUASI-COMPLÈTE** — Seuls 2 systèmes restent ❌ ABSENT :

| # | Système | Statut | Problème |
|---|---------|--------|----------|
| 4.15 | Quotas (betterave/tabac) | ❌ ABSENT | La mécanique de quota spécifique (2ha ou 10% surface N-1 pour betterave, 2ha max + zone pour tabac) n'est décrite dans aucun GDD |
| 4.16 | Engrais Verts / CIPAN | ❌ ABSENT | Mentionnés dans GDD-specialisations-vegetales (CIVE, moutarde) mais aucune section gameplay dédiée avec paramètres (date semis/broyage, effet sol) |

Les 5 systèmes « écartés » ne sont pas des trous : ils sont soit fusionnés dans un système plus large, soit reportés à une version ultérieure avec justification (voir section dédiée ci-dessous).

---

## Matrice détaillée

### Domaine 1 — CORE (14 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 1.1 | Authentification | 🔧 ARCHI | — | Détail technique (JWT, bcrypt, refresh tokens) → phase Architecture |
| 1.2 | Serveurs de jeu | ✅ | GDD-core-temporalite | §1 + multiplicateurs difficulté détaillés |
| 1.3 | Joueur (Exploitation) | ✅ | GDD-core-temporalite | §3-4 Budget initial, heures/jour, ancienneté |
| 1.4 | Géographique | ✅ | GDD-core-temporalite + GDD-meteo | 13 régions, 96 dép., 5 zones climatiques |
| 1.5 | Temporel | ✅ | GDD-core-temporalite | §1-2 time_ratio=7, saisons, tick détaillé |
| 1.6 | Heures de Travail (HT) | ✅ | GDD-core-temporalite | §4-5 Durées CALCULÉES (ADR-004), régénération |
| 1.7 | Employés | ✅ | GDD-core-temporalite | §4 25 HT/jour, 1400€/mois |
| 1.8 | CFSA | ✅ | GDD-gouvernance-serveur §4 + GDD-social-multijoueur §12bis | 42j, conditions, bonus chiffrés |
| 1.9 | Onboarding | ✅ | GDD-onboarding | Complet : budget initial, prêt JA, aide CESA |
| 1.10 | Difficulté Serveur | ✅ | GDD-core-temporalite + GDD-gouvernance-serveur §9 | Multiplicateurs ×0.7-×1.5 détaillés |
| 1.11 | Transport (global) | ✅ | GDD-materiel §6 + GDD-bovin-laitier | Attelage, trajets, capacité m², usure |
| 1.12 | Short IDs | 🔧 ARCHI | — | Séquence DB, format préfixe → Architecture |
| 1.13 | Règles UX Globales | ✅ | GDD-ui-ux | Complet : modales, DataTable, navigation, filtres |
| 1.14 | Protection hors-ligne | ✅ | GDD-core-temporalite §6 | Gel jauges, last_seen, seuil 48h |

### Domaine 2 — MÉTÉO (4 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 2.1 | Météo Principal | ✅ | GDD-meteo | §2-4 5 niveaux, 5 zones, T° min/max, précipitations |
| 2.2 | Prévisions et Fiabilité | ✅ | GDD-meteo | §3 J+0-J+2 fiables, J+3-J+6 incertaines |
| 2.3 | Interface Météo | ✅ | GDD-meteo | §5 Widget, carte SVG, alertes |
| 2.4 | Impact Gameplay Météo | ✅ | GDD-meteo §7 + GDD-cultures | Gel, canicule, grêle, blocage travaux chiffrés |

### Domaine 3 — BÂTIMENTS (9 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 3.1 | Catalogue Bâtiments | ✅ | GDD-batiments-stockage | §2-3 Prix/m², énergie kWh, 3 modes élevage |
| 3.2 | Construction | ✅ | GDD-batiments-stockage | §4 Coût, délai ceil(taille/100), 2h HT |
| 3.3 | Niveaux (1-5) | ✅ | GDD-batiments-stockage | §5 Coût upgrade 50-400%, bonus énergie/usure |
| 3.4 | Usure & Entretien | ✅ | GDD-batiments-stockage | §6 0.15%/j, 4 paliers, entretien mensuel/annuel |
| 3.5 | Système Énergétique | ✅ | GDD-batiments-stockage | §7 kwh_jour formule, 0.08€/kWh |
| 3.6 | Stockage | ✅ | GDD-batiments-stockage | §8 Compatibilité, pertes/jour, qualité |
| 3.7 | Accessoires | ✅ | GDD-batiments-stockage | §9 Cuve lait, salle traite, DAC, robots |
| 3.8 | Agrandissement & Destruction | ✅ | GDD-batiments-stockage | §10 Récup 10%, bâtiment vide requis |
| 3.9 | Modes d'Élevage | ✅ | GDD-batiments-stockage + GDD-bovin-laitier | Conv/LR/Bio surfaces chiffrées |

### Domaine 4 — CULTURES (16 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 4.1 | Parcelles | ✅ | GDD-parcelles-sol | §2 Types, qualité sol 1-3, conversion bio, prix/ha |
| 4.2 | Sol (Nutriments) | ✅ | GDD-parcelles-sol | §3-5 6 éléments 0-100, analyse, apports chiffrés |
| 4.3 | Cultures Actives | ✅ | GDD-cultures | §2-4 Cycle complet, 28+ cultures, jauges, croissance 4%/j |
| 4.4 | Calcul de Rendement | ✅ | GDD-cultures | §5 Formule multi-facteurs avec tous les multiplicateurs |
| 4.5 | Techniques Culturales | ✅ | GDD-cultures | §2 Traditionnelle/TCS/SD avec rendements et coûts |
| 4.6 | Rotation | ✅ | GDD-cultures | §6 Historique, rotation 1-6 ans, vérification avant semis |
| 4.7 | Irrigation | ✅ | GDD-specialisations-vegetales | §2 Forage, retenue, enrouleur/pivot, niveaux 1-10 |
| 4.8 | Arboriculture (Vergers) | ✅ | GDD-specialisations-vegetales | §3 11 espèces, filet anti-grêle, calibre fruits |
| 4.9 | Haies | ✅ | GDD-specialisations-vegetales | §5 Plantation, taille, déchiquetage, 2.8-3.5 KW/kg |
| 4.10 | Filière PDT | ✅ | GDD-cultures | §8 Stockage, propositions hebdo, DLC |
| 4.11 | Céréale Immature | ✅ | GDD-cultures | §9 Ensilage, récolte avant 7 mai, rendement 150% |
| 4.12 | Compostage | ✅ | GDD-parcelles-sol | §6 3t→1t en 14j, retournements, apports NPKCaMgS |
| 4.13 | Écume de Sucrerie | ✅ | GDD-cooperatives-car | §4.3 Sucrerie 30kg écume/t betterave + GDD-parcelles-sol apports |
| 4.14 | Digestat | ✅ | GDD-transformation §3 + GDD-parcelles-sol | Liquide 25m³/ha, Solide 25T/ha, NPK chiffrés |
| 4.15 | Quotas | ✅ | GDD-cultures | §8.6 Betterave 10% SAU ou 2 ha min, tabac 2 ha max, PDT 20%, lin 15% — mécaniques et conséquences de dépassement chiffrées |
| 4.16 | Engrais Verts / CIPAN | ✅ | GDD-cultures | §8.7 — 7 espèces avec coûts, dates de semis/destruction, effets sol (MO/N/Structure) chiffrés, CIVE méthanisation, Normal vs Expert |

### Domaine 5 — ÉLEVAGE (22 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 5.1 | Animaux (lots) | ✅ | GDD-bovin-laitier + GDD-elevage-autres-especes | Lots, stades, poids, races |
| 5.2 | Canaux d'Achat | ✅ | GDD-marche | §3-4 Grossiste, marché global, marché privé, commissions |
| 5.3 | Transport d'Animaux | ✅ | GDD-materiel §6 + GDD-bovin-laitier | Bétaillères m², trajets, conditions arrêt |
| 5.4 | Enclos d'Attente | ✅ | GDD-bovin-laitier | Pénalités accélérées, pas de production |
| 5.5 | Alimentation (Rations) | ✅ | GDD-bovin-laitier §3 + GDD-elevage-autres-especes | Rations détaillées kg/j, pénalités faim/soif |
| 5.6 | Litière & Fumier | ✅ | GDD-bovin-laitier + GDD-parcelles-sol | Paille/jour, fumier ×1.5, lisier caillebotis |
| 5.7 | Reproduction | ✅ | GDD-bovin-laitier §4 + GDD-genetique | Monte, IA, taux, gestation, naissances |
| 5.8 | Production Lait | ✅ | GDD-bovin-laitier §5 | Traite, salle, cuve, formule production, QL |
| 5.9 | Production d'Œufs | ✅ | GDD-especes-secondaires §2 | Complet : déclin ponte, calibres S/M/L/XL, robot, DLC, conditionnement |
| 5.10 | Génétique (V2) | ✅ | GDD-genetique | §2-8 14 indices, transmission, ISU, valorisation |
| 5.11 | Stades de Croissance | ✅ | GDD-bovin-laitier + GDD-elevage-autres-especes | Feed_ratio, m2_ratio, durées |
| 5.12 | Gestion des Lots | ✅ | GDD-bovin-laitier | Regrouper/Scinder/Déplacer/Vendre, stats pondérées |
| 5.13 | Pâturage | ✅ | GDD-bovin-laitier + GDD-elevage-autres-especes | Dates, surface m²/j, ration hivernale |
| 5.14 | Labels d'Élevage | ✅ | GDD-bovin-laitier + GDD-batiments-stockage | Conv/LR/Bio, conversion, contraintes, prix |
| 5.15 | Vaccinations | ✅ | GDD-bovin-laitier §8 | Catalogue vaccins, coût/animal, durée protection |
| 5.16 | IVRAD | ✅ | GDD-genetique §9 | Objectifs par race, sélection, concours |
| 5.17 | Rendement Carcasse | ✅ | GDD-elevage-autres-especes | Grille EUROP, % par espèce, conformation |
| 5.18 | CIA — Doses | ✅ | GDD-genetique + GDD-especes-secondaires §3 | Doses/prélèvement, prix, catalogue |
| 5.19 | Robot d'Alimentation | ✅ | GDD-bovin-laitier §5.5 | 165-215k€, effets détaillés, prérequis AgriPass |
| 5.20 | Chien de Troupeau | 🗑️ | GDD-endgame | Mentionné en cosmétique. Mécanique reportée V2 |
| 5.21 | Allaitement | ✅ | GDD-elevage-autres-especes §2 | Bovin allaitant : veau tète, 0€ alimentation, détaillé |
| 5.22 | Négociant en Bestiaux | 🗑️ | — | Redondant avec marché joueur↔joueur. Reporté V2 |

### Domaine 6 — MATÉRIEL (15 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 6.1 | Catalogue Matériel | ✅ | GDD-materiel §2 | Familles, CV, largeur, capacité, maniabilité, prix |
| 6.2 | Consommation HVC | ✅ | GDD-materiel §3 | L/h × durée, prix HVC, réservoir global |
| 6.3 | Usure & Entretien | ✅ | GDD-materiel §4 | 0.1%/j, ×1.5 sans abri, entretien -30pts |
| 6.4 | Pannes | ✅ | GDD-materiel §5 | Probabilité liée usure, immobilisation 1-2j |
| 6.5 | Pièces Détachées | ✅ | GDD-materiel §5 | pa_threshold, seuils, alerte, inutilisable |
| 6.6 | Maniabilité | ✅ | GDD-materiel §2 | Score 1-5, taille parcelle idéale, bonus ×0.90-1.10 |
| 6.7 | GPS | ✅ | GDD-metiers-eta-concession §3 | Balises 20k€/zone, récepteur 2.5k€, abonnement |
| 6.8 | Combinés | ✅ | GDD-materiel §7 | Avant+arrière, -50% HT, hp_multiplier ×1.5 |
| 6.9 | Achat/Vente Matériel | ✅ | GDD-materiel + GDD-metiers-eta-concession | Neuf, occasion, argus, achat en commun, dépôt-vente |
| 6.10 | Matériel Arboricole | ✅ | GDD-specialisations-vegetales §3 | Tracteur ≤80CV, vibreur, ramasseuse |
| 6.11 | Matériel Forestier | ✅ | GDD-endgame §3 | Abatteuse, débusqueur, porteur (catalogue) |
| 6.12 | Matériel Viticole | ✅ | GDD-endgame §2.8 | Enjambeur 95k€, vendangeuse, pressoir |
| 6.13 | Matériel Maraîcher | ✅ | GDD-maraichage §7 | Catalogue complet : motoculteur, planteuse, bineuse, calibreuse |
| 6.14 | Location de Matériel | 🗑️ | GDD-metiers-eta-concession | Micro-fonctionnalité du concessionnaire. Reporté V2 |
| 6.15 | Assurance Matériel | 🗑️ | GDD-materiel | Booléen implicite dans le système de pannes. Reporté V2 |

### Domaine 7 — ÉCONOMIE (10 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 7.1 | Coopérative SimAgri | ✅ | GDD-marche §2 + GDD-economie-base | Prix +15%, stock illimité, distance 20km |
| 7.2 | Prix Dynamiques | ✅ | GDD-marche §3 | Tick hebdo, offre/demande ±15%, clamp, prime bio |
| 7.3 | Transactions | ✅ | GDD-economie-base + GDD-marche | Types, historique, qualité, bio flag |
| 7.4 | Banque | ✅ | GDD-economie-base §4 | Compte, épargne, prêt JA, journal financier |
| 7.5 | Charges Automatiques | ✅ | GDD-economie-base §3 | Salaires, électricité, annuités, tick mensuel |
| 7.6 | Parcelles — Achat/Vente | ✅ | GDD-economie-base + GDD-parcelles-sol | Prix/ha, fermage, taxe plus-value |
| 7.7 | Annonces | ✅ | GDD-marche §4 | Types, filtres, expiration, prix libre |
| 7.8 | Grossistes et Centrales | ✅ | GDD-marche §5 | Canaux de vente, price_factor, contrats |
| 7.9 | Marchés (vente directe) | ✅ | GDD-transformation + GDD-maraichage §8 | Marchés régionaux, emplacements, jours |
| 7.10 | Organisme Partcel | 🗑️ | — | Fusionné dans achat/vente parcelles (GDD-economie-base + GDD-parcelles-sol) |

### Domaine 8 — MÉTIERS (7 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 8.1 | Concessionnaire | ✅ | GDD-metiers-eta-concession §3 | Hall, licences, mécaniciens, atelier, GPS, pièces |
| 8.2 | Transporteur | ✅ | GDD-metiers-eta-concession §4 | Camions, chauffeurs 25PA, 8 types semi, commandes |
| 8.3 | CIA | ✅ | GDD-genetique §7-8 + GDD-metiers-eta-concession | Centre, prélèvements, catalogue, contrats |
| 8.4 | CAR | ✅ | GDD-cooperatives-car | Complet : parts, huilerie, sucrerie, laiterie, méthanisation |
| 8.5 | ETA | ✅ | GDD-metiers-eta-concession §2 | Services, prix/ha libre, annuaire régional |
| 8.6 | Méthanisation à la Ferme | ✅ | GDD-transformation §3 | Digesteur, substrats, biogaz→élec+HVC, digestat |
| 8.7 | Laiterie | ✅ | GDD-cooperatives-car §4.3 + GDD-bovin-laitier | Collecte, contrats, prix/L variable |

### Domaine 9 — TRANSFORMATIONS (7 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 9.1 | Fromagerie | ✅ | GDD-transformation §2 | Types, hygiène, affinage, DLC, sous-produits, AOP |
| 9.2 | Maraîchage | ✅ | GDD-maraichage | Complet 840l : serres, chauffage, 15 cultures, vente, MO |
| 9.3 | Foie Gras | ✅ | GDD-especes-secondaires §5.2 + GDD-endgame | Oie/canard gras, gavage→endgame, saisonnalité |
| 9.4 | Viticulture | ✅ | GDD-endgame §2 | Domaine, cépages, vinification, assemblage, concours |
| 9.5 | Foresterie | ✅ | GDD-endgame §3 | Forêts, stations, ETF, vente bois, matériel |
| 9.6 | Haies (transformation bois) | ✅ | GDD-specialisations-vegetales §5 | Taille→déchiquetage→plateforme→litière/chauffage |
| 9.7 | Méthanisation (transformation) | ✅ | GDD-transformation §3 + GDD-cooperatives-car §4.4 | Substrats, digesteur, biogaz, digestat |

### Domaine 10 — SOCIAL (12 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 10.1 | Amis | ✅ | GDD-social-multijoueur §3 | Liste amis, amis privilégiés, voisinage |
| 10.2 | Messagerie | ✅ | GDD-social-multijoueur §4 | MP, discussions groupe, WebSocket, canaux |
| 10.3 | Forum | ✅ | GDD-social-multijoueur §9 | Catégories, topics, modération, sondages intégrés |
| 10.4 | CFSA | ✅ | GDD-gouvernance-serveur §4 + GDD-social-multijoueur §12bis | 42j, maître, slots, bonus chiffrés |
| 10.5 | Classements | ✅ | GDD-social-multijoueur §7 | Multi-critères, par ligue |
| 10.6 | Concours / GénétiSim | ✅ | GDD-endgame §5 + GDD-genetique §9 | Scoring, inscriptions, catégories, récompenses |
| 10.7 | CESA | ✅ | GDD-gouvernance-serveur §2-3 | Stabilisateur économique, aide 50k€, régulation prix, équité |
| 10.8 | Salons et Événements | ✅ | GDD-endgame §5 + GDD-social-multijoueur §10 | GénétiSim, VitiSim, défis saisonniers |
| 10.9 | Badges | ✅ | GDD-social-multijoueur §2.4 | Catalogue, attribution auto, cosmétiques |
| 10.10 | Sondages | ✅ | GDD-social-multijoueur §12ter | Création, options, votes, expiration |
| 10.11 | Profil Joueur | ✅ | GDD-social-multijoueur §2 | Fiche publique, réputation, statut, favoris |
| 10.12 | Challenges | ✅ | GDD-endgame §6 + GDD-social-multijoueur §10.3 | Défis individuels/collectifs, scoring, récompenses |

### Domaine 11 — MONÉTISATION (3 systèmes)

| # | Système | Statut | GDD | Section / Preuve |
|---|---------|:------:|-----|-----------------|
| 11.1 | SimPass (AgriPass) | ✅ | GDD-endgame §8 | AgriPass 4.99€/mois, AgriPass+ 9.99€, fonctionnalités listées |
| 11.2 | Packs & Options | ✅ | GDD-endgame §8 | Cosmétiques, thèmes, portraits, pas de P2W |
| 11.3 | Parrainage | ✅ | GDD-endgame §7 | Lien parrain/filleul, bonus, condition réussite 100k€ |


---

## Systèmes renvoyés à l'Architecture

| # | Système | Justification |
|---|---------|---------------|
| 1.1 | Authentification | JWT, bcrypt 12 rounds, refresh tokens, sessions = implémentation technique pure. Le GDD-core-temporalite couvre le concept « 1 compte/personne/serveur » mais les détails (rounds, token expiry) relèvent de l'Architecture. |
| 1.12 | Short IDs | Séquence PostgreSQL `global_short_id_seq`, format `POU-1009` = choix technique de nommage. Aucun impact gameplay. Relève de la couche persistence. |
| — | Structure données géographiques | Le découpage régions/départements/communes est décrit dans GDD-core-temporalite ; l'implémentation (GeoJSON, PostGIS, etc.) relève de l'Architecture. |

**Note** : le 3ème item n'est pas un système inventorié mais est mentionné ici pour clarté — la géographie comme GAMEPLAY est couverte (1.4).

---

## Systèmes volontairement écartés

| # | Système | Justification de l'écartement |
|---|---------|-------------------------------|
| 5.20 | Chien de Troupeau | **ÉCARTÉ → V2**. Dans SimAgri c'est un bonus HT mineur. Le GDD-endgame le mentionne comme « animal de compagnie » cosmétique. Une mécanique de réduction HT au pré nécessiterait un micro-système non prioritaire. Recommandation : intégrer en V2 comme upgrade achetable. |
| 5.22 | Négociant en Bestiaux | **ÉCARTÉ → V2**. Intermédiaire entre joueurs = redondant avec le marché global (GDD-marche §3) qui fait déjà joueur↔joueur avec commission. Un rôle de « courtier » spécialisé est un ajout social non critique pour le MVP. |
| 6.14 | Location de Matériel | **ÉCARTÉ → V2**. Mentionné dans GDD-metiers-eta-concession mais uniquement « si panne, ±5CV, durée = immobilisation ». C'est une micro-fonctionnalité du concessionnaire, pas un système autonome. Couvert implicitement par les pannes + concessionnaire. |
| 6.15 | Assurance Matériel | **ÉCARTÉ → V2**. Mentionné dans GDD-materiel (pannes) et GDD-economie-base (charges automatiques). La souscription/couverture est un paramètre booléen du matériel, pas un système à part. Couvert implicitement. |
| 7.10 | Organisme Partcel | **ÉCARTÉ → FUSIONNÉ**. Le mécanisme d'achat/vente de parcelles est entièrement couvert dans GDD-parcelles-sol + GDD-economie-base (prix/ha, fermage, plus-value). « Partcel » est un nom de PNJ/organisme de SimAgri. Dans Agriva, l'achat se fait directement (pas besoin d'un intermédiaire nommé). |

---

## Trous restants

**Aucun.** Les systèmes 4.15 (Quotas) et 4.16 (Engrais Verts / CIPAN) ont été complétés le 2026-08-05 dans `GDD-cultures.md` §8.6 et §8.7.

---

## Inventaire des 23 GDD

| # | GDD | Lignes | Domaines couverts |
|:-:|-----|:------:|-------------------|
| 1 | GDD-bovin-laitier.md | 1 813 | Élevage (lait, alimentation, reproduction, traite, robot), Labels |
| 2 | GDD-materiel.md | 1 600 | Matériel (catalogue, usure, pannes, pièces, combinés, consommation) |
| 3 | GDD-cultures.md | 1 438 | Cultures (cycle, rendement, techniques, rotation, PDT, ensilage) |
| 4 | GDD-economie-base.md | 1 292 | Économie (charges, PAC, banque, transactions, fermage) |
| 5 | GDD-elevage-autres-especes.md | 1 222 | Élevage (allaitant, porc, ovin, caprin) |
| 6 | GDD-core-temporalite.md | 1 140 | Core (temps, HT, serveurs, joueur, employés, protection hors-ligne) |
| 7 | GDD-metiers-eta-concession.md | 1 138 | Métiers (ETA, Concessionnaire, Transporteur, GPS) |
| 8 | GDD-meteo.md | 1 094 | Météo (génération, prévisions, interface, impact gameplay) |
| 9 | GDD-endgame.md | 1 049 | Endgame (viticulture, foresterie, concours, défis, monétisation) |
| 10 | GDD-specialisations-vegetales.md | 966 | Cultures (irrigation, arboriculture, haies, CIVE) |
| 11 | GDD-poulet-chair.md | 916 | Élevage (poulet de chair, lots, IC, biosécurité) |
| 12 | GDD-parcelles-sol.md | 899 | Cultures (parcelles, sol 6 éléments, compostage, drainage) |
| 13 | GDD-marche.md | 864 | Économie (coopérative, prix dynamiques, annonces, marchés) |
| 14 | GDD-social-multijoueur.md | 864 | Social (amis, messagerie, forum, classements, entraide, CFSA, sondages) |
| 15 | GDD-onboarding.md | 804 | Core (onboarding, tutoriel, progression) |
| 16 | GDD-especes-secondaires.md | 789 | Élevage (pondeuse, équins, lapins, pintade, oie, canard, bison, daim) |
| 17 | GDD-batiments-stockage.md | 750 | Bâtiments (catalogue, construction, niveaux, usure, énergie, stockage) |
| 18 | GDD-ui-ux.md | 735 | Core (interface, modales, navigation, responsive) |
| 19 | GDD-genetique.md | 664 | Élevage (indices, transmission, CIA, IVRAD, concours) |
| 20 | GDD-maraichage.md | 658 | Transformations (serres, chauffage, légumes, commercialisation, MO) |
| 21 | GDD-cooperatives-car.md | 622 | Métiers (CAR : huilerie, sucrerie, laiterie, méthanisation) |
| 22 | GDD-transformation.md | 590 | Transformations (fromagerie, vente directe, méthanisation, photovoltaïque) |
| 23 | GDD-gouvernance-serveur.md | 575 | Social/Core (CESA, CFSA, anti-abus, stabilisateur économique, cycle serveur) |

**Total** : 22 482 lignes de documentation de game design.

---

## Notes méthodologiques

1. **COUVERT** = une section identifiable dans un GDD avec des paramètres chiffrés (prix, durées, formules, tableaux).
2. **PARTIEL** = le concept est mentionné (grep positif) mais sans mécanique indépendante ni paramètres suffisants.
3. **ABSENT** = grep négatif ou trop indirect pour constituer une couverture.
4. **ARCHITECTURE** = détails d'implémentation technique sans impact sur les règles de jeu.
5. **ÉCARTÉ** = volontairement non traité car redondant, trivial, ou renvoyé à une version ultérieure.

Les systèmes « écartés » (5) ne sont pas des trous : ils sont soit fusionnés dans un système plus large, soit reportés à V2 avec justification.
