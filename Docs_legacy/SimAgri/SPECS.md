# SimAgri — Spécifications techniques complètes

> État actuel : Phase 0 quasi terminée (auth, players, tick engine, docker).
> Source : règles officielles SimAgri + export france3.simagri.com (Avril 2026).

---

## 1. Architecture existante

| Couche | Tech | État |
|--------|------|------|
| Frontend | Vue.js 3 + Vite | ✅ Squelette (App.vue + health check) |
| API | Fastify + JWT | ✅ Auth (register/login/me) + Players (create/me/servers/regions) |
| Worker | BullMQ + node-cron | ✅ Ticks hourly/daily/weekly (basiques) |
| BDD | PostgreSQL 17 | ✅ Schema init.sql (users, players, servers, regions, departments, game_time, buildings, storage, equipment, parcels, parcel_soil, crops, animals) |
| Cache | Redis 7 | ✅ Connecté (BullMQ) |
| Shared | Types TS | ✅ Player, GameTime, constantes temps |
| Docker | Compose | ✅ postgres + redis + server + worker |

### Code existant (routes)
- `POST /auth/register` — inscription (email, password, name)
- `POST /auth/login` — connexion → JWT
- `GET /auth/me` — profil user
- `POST /players` — créer exploitation (regionId, zone, name)
- `GET /players/me` — ma ferme + région
- `GET /players/servers` — liste serveurs
- `GET /players/regions` — régions + départements

### Ticks existants
- **Hourly** : croissance cultures +0.17% (brut, sans météo)
- **Daily** : reset PA, ancienneté +1, usure matériel, faim animaux -10, santé -5 si faim<30
- **Weekly** : avancement game_time (mois, saison, année)

---

## 2. Système temporel

| Réel | SimAgri |
|------|---------|
| 1 jour | 1 jour |
| 7 jours | 1 mois |
| 21 jours | 1 saison |
| 84 jours | 1 année (12 mois, 4 saisons) |

Mois : Jan=J1-7, Fév=J8-14, Mar=J15-21, Avr=J22-28, Mai=J29-35, Jun=J36-42, Jul=J43-49, Août=J50-56, Sep=J57-63, Oct=J64-70, Nov=J71-77, Déc=J78-84.

Saisons : Hiver (Déc-Fév), Printemps (Mar-Mai), Été (Jun-Août), Automne (Sep-Nov).

---

## 3. Points d'Action (PA)

- Base : 35 PA/jour, reset à 00:00 UTC
- Déplacement : 0.25 PA/zone traversée
- Employé : +25 PA/jour, salaire 1400€/mois SimAgri
- Travail parcelle : variable selon surface + matériel + maniabilité
- Entretien bâtiment : 0.3 PA/mois
- Entretien matériel : 1 PA/mois

---

## 4. Météo

4 zones : nord-ouest, nord-est, sud-est, sud-ouest.

| Niveau | Nom | Eau | Soleil | Travail | Pulvérisation |
|--------|-----|-----|--------|---------|---------------|
| 1 | Très ensoleillé | -2 | +4 | OK | OK |
| 2 | Ensoleillé | -1 | +2 | OK | OK |
| 3 | Mitigé | +1 | +1 | OK | OK |
| 4 | Pluie | +3 | -1 | OK | OK |
| 5 | Forte pluie | +5 | -2 | INTERDIT | INTERDIT |

Vent : 10% chance/jour → pulvérisation impossible.
Grêle : 2% chance printemps/été → dégâts arboricoles (filet anti-grêle protège).

Génération : pondérée par saison (plus pluie automne/hiver, plus soleil été).

---

## 5. Cultures

### 5.1 Données de référence (25+ cultures)

Céréales : blé, orge, orge printemps, avoine, avoine printemps, triticale, seigle (CA/US/Expert).
Oléo-protéagineux : colza, tournesol, pois, féverole, soja, lin.
Autres : maïs grain, maïs ensilé, sorgho ensilé, betterave, pomme de terre, chanvre, tabac, épinard, haricot vert, lentille, coton (US).
Fourragères : herbe (7 graminées), miscanthus, luzerne.

Chaque culture : mois semis, mois récolte, prix moyen, rotation (ans), quantité semence/ha, outil récolte, possibilité paille, nombre traitements.

### 5.2 Rendements par région
22 régions FR + 2 BE + 3 CH. Rendement en T/ha par culture par région (tableaux complets dans les règles extraites).

### 5.3 Cycle cultural
Préparation sol (déchaumeur/cultivateur → charrue → herse) → Semis → Croissance (jauges eau/soleil) → Traitements (fongicide/herbicide/insecticide, 1.6L/ha, 9€/L) → Récolte → Paille optionnelle.

### 5.4 Techniques culturales
| Technique | Rendement | Coût | Restrictions |
|-----------|-----------|------|-------------|
| Traditionnelle | Bon | Élevé | Aucune |
| TCS | Bon/Moyen | Modéré | Aucune |
| Semis direct | Moyen/Faible | Faible | Pas maïs ni PDT |

### 5.5 Sol — 6 éléments nutritifs
Azote (N), Phosphore (P), Potassium (K), Calcium (Ca), Magnésium (Mg), Soufre (S).
Analyse de sol : 150€, 1 fois/5 saisons. Qualité terre : 3 niveaux.
Pierres : -5% rendement, broyeur de pierres (effet 3 saisons).

### 5.6 Épandages (kg/ha)
| Type | N | P | K | Ca | Mg | S |
|------|---|---|---|----|----|---|
| Fumier (25T/ha) | 137.5 | 65 | 180 | 75 | 50 | 70 |
| Lisier (15m³/ha) | 75 | 60 | 45 | 45 | 15 | 35 |
| Compost (15T/ha) | 95 | 60 | 120 | 180 | 35 | 60 |
| Écume sucrerie (15T/ha) | 45 | 120 | 15 | 3600 | 90 | 0 |
| Digestat liquide (25m³/ha) | 125 | 50 | 300 | 47.5 | 17.5 | 14.25 |
| Digestat solide (25T/ha) | 100 | 50 | 225 | 135 | 82.5 | 62.5 |

### 5.7 Calcul rendement récolte
```
base = rendement_region(culture, region)
× qualité_terre [0.8, 1.0, 1.2]
× nutriments [0.5..1.3]
× engrais (+15% si oui)
× fumier (+10% si oui)
× traitements (×0.7 si maladie non traitée)
× jauges eau/soleil [0.6..1.1]
× maturation [pénalité si ≠100%]
× rouleau (+3-5% céréales/herbe)
× pierres (×0.95 si non broyées)
× technique [1.0, 0.95, 0.85]
× BIO (×0.85)
```

### 5.8 Engrais verts / CIPAN
Moutarde (Sep), Phacélie (Août), Seigle (Oct), Ray-grass Italie (Jul) → broyage Janvier → bonus semis printemps.

### 5.9 BIO
Conversion 2 saisons. Pas de traitements phyto. Rotation +1 an. Prix vente +20% min.

### 5.10 Quotas
Betterave : 2 ha ou 10% surface cultivée. Tabac : 2 ha max, région exploitation.

### 5.11 Arboriculture
11 cultures (pommier→myrtillier). Verger max 5 ha. Matériel ≤80CV. Rendement selon âge arbres.

### 5.12 Haies
Plantation Sep-Nov → Taille Déc-Fév → Déchiquetage → Bois déchiqueté (litière ou chauffage serre 2.8-3.5 KW/kg). Bonus rendement + réduction maladies + réduction eau animaux.

---

## 6. Élevage

### 6.1 Espèces (13)
Bovins (laitiers/allaitants), bisons, caprins, porcins, lapins, volailles, pintades, ovins, daims, oies, canards, chevaux (selle/trait/poney).

### 6.2 Mécaniques communes
- Alimentation : rations détaillées par espèce/âge/saison (kg/jour)
- Abreuvement : litres/jour par animal
- Litière : paille (kg/jour) → fumier. Caillebotis → lisier.
- Pâturage : Avr-Oct (m²/jour par animal). Hivernal possible pour allaitants/bisons/daims/chevaux.
- Santé : maladies si manque nourriture/litière. Vaccins (protection 1 an).
- 3 niveaux qualité nourriture → influence croissance et production lait.

### 6.3 Reproduction
| Espèce | Âge min ♀ | Gestation | Portée | Délai entre naissances |
|--------|-----------|-----------|--------|----------------------|
| Bovins | 27 mois | 9 mois | 1 | 3 mois |
| Caprins | 12 mois | 5 mois | 2 | 6 mois |
| Porcins | 12 mois | 4 mois | 6-9 | 1 mois |
| Lapins | 3 mois | 1 mois | 6-7 | 1 mois |
| Volailles | 6 mois | 1 mois | 6-10 | 5 jours |
| Ovins | 12 mois | 5 mois | 1-2 | 7 mois |
| Bisons | 27 mois | 9 mois | 1 | 3 mois (Jul-Oct) |
| Daims | 16 mois | 8 mois | 1 | Oct seul |
| Oies | 6 mois | 9 jours ponte | 4-10 | Saisonnier (Jan-Fév→Mar-Jun) |
| Canards | 6 mois | 7-9 jours ponte | 3-12 | Saisonnier (Avr) |
| Chevaux | 36 mois | 11 mois | 1 | 1 mois |

### 6.4 Génétique — 14 indices
Croissance, Prolificité, Allure générale, Lait, Qualité Lait, Laine, Oeuf, Eclosion, Résistance, Sociabilité, Fertilité, Duvet, Physique, Mental.
Héritage : `(mère + père) / 2 + random(-5, +5)`, clamp 1-100.

### 6.5 BIO élevage
Contraintes par espèce : plein-air min %, lieu, tolérance nourriture conv., âge min/max. Productions BIO +20%.

### 6.6 Abattoir
Rendement carcasse 45-80% selon espèce. Qualité : conformation A-E + engraissement 1-5.

### 6.7 Prix lait par indice QL
Bovins : 265-400€/1000L (conv), 318-480€ (BIO). Caprins : 550-640€ / 660-768€. Ovins : 850-940€ / 1020-1128€.

---

## 7. Bâtiments

Types : hangar, stabulation, porcherie, chèvrerie, bergerie, poulailler, clapier, écurie, entrepôt, silo, silo taupe, fosse fumier, fosse lisier, cuve lait, cuve HVC, salle traite, citerne eau, bac eau, parc volailles, parc porcins, salle conditionnement, pièce stockage œufs/laine, aire chargement, silo chargement, aire stockage paille/foin, corral, entrepôt arboricole, chambre froide, aire compostage, plateforme bois déchiqueté, plateforme substrat.

- 10 premiers : construction instantanée. Ensuite : délai.
- Niveau équipement 1-5 (influence conso énergie).
- Électricité : 0.08€/kWh, facture mensuelle.
- Usure : entretien 0.3 PA/mois. Destruction : récupère 10%.

---

## 8. Matériel

Familles : tracteurs, télescopiques, moissonneuses, ensileuses, arracheuses, cultivateurs, déchaumeurs, charrues, herses, semoirs, pulvérisateurs, épandeurs, bennes, plateaux, bétaillères, presses, faucheuses, faneuses, andaineurs, enrubanneuses, autochargeuses, broyeurs, désileuses, tonnes à lisier, tonnes à eau, chargeurs frontaux.
+ Arboricole, forestier, viticole, maraîcher, routier.

- Puissance requise (CV). Maniabilité 1-5. Usure quotidienne (+50% si non abrité).
- Pannes : probabilité liée usure >50%. Immobilisation 1-2 jours. Assurance.
- Pièces détachées : 1-5 pièces, remplacement selon PA utilisés.
- HVC : trajet 0.05 L/CV/PA + travail 0.08-0.20 L/CV/PA.
- GPS : récepteur 3000€, balise 20000€/zone, abonnement 400-600€/an.
- Combinés : actions multiples en 1 passage.

---

## 9. Économie

- Prix dynamiques offre/demande (±15%/mois, clamp 50-200% base).
- Coopérative SimAgri : achat/vente immédiate.
- Annonces entre joueurs (1500€ frais).
- Parcelles : 3000-7000€/ha selon pays. Taxe plus-value 50-90%.
- Organisme Partcel : vente parcelles (BIO +50%).
- Banque : épargne + emprunts via CAR.
- Filière PDT : stockage → propositions vente hebdo Déc-Jun.

---

## 10. Métiers annexes

- **Concessionnaire** : 90j ancienneté + SimPass. Halls, licences (100 pts), atelier (mécaniciens compétences 1-10, retraite 60 ans), GPS, pièces détachées, dépôt-vente, location.
- **Transporteur** : camions (8 types semi), chauffeurs, licences.
- **CIA** : laboratoire 50m², inséminateur (1750€/mois), utilitaire. Contrats race → contrats animal → prélèvements → doses → inséminations.
- **CAR** : associés, parts sociales, magasin, huilerie, sucrerie, laiterie, méthanisation, emprunts.
- **ETA** : services avec propre matériel, tarifs/ha.

---

## 11. Transformations

- **Fromagerie** : artisanale (20-100K€, 250-1250L/j, marchés) ou industrielle (198-910K€, 2200-11000L/j, grossistes). Hygiène + matériel à entretenir. Affinage + DLC.
- **Maraîchage** : serres plastique/verre, chauffage polycombustible (miscanthus 5KW/kg), personnel, cultures légumières.
- **Foie gras** : élevage → pré-gavage → gavage → abattage → commercialisation.
- **Viticulture** : domaine, cépages, vendanges, vinification, assemblage, élevage fût/cuve, mise en bouteille, concours.
- **Foresterie** : forêt, station, ETF, vente bois.
- **Méthanisation ferme** : substrats → digesteur → biogaz → électricité + HVC + digestat.

---

## 12. Social

- Forum, messagerie, MP-Live (WebSocket).
- Amis / amis privilégiés.
- CFSA : stagiaire <14j, maître 168+j, durée 42j, bonus SimPass+25000€.
- Classements, statistiques, badges, challenges.
- Concours animaux (GénétiSim), concours vins.
- Salons (GénétiSim, VitiSim, GénétIvrad).
- Profil joueur, carte ISO, favoris, préférences.

---

## 13. Monétisation

- SimPass : ~2€/trimestre (84j). Débloque activités annexes, stats avancées, pas de pub.
- Packs/options cosmétiques.
- Parrainage : bonus SimPass parrain+filleul.
