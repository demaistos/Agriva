# CULTIVIA — Game Design Document (GDD)
## Version 2.0 — Mis à jour le 2026-04-08

> Voir `08_ACTIONS_DETAILLEES.md` (324 actions) pour le détail step-by-step.
> Voir `09_STEERING.md` pour les décisions de pilotage et la roadmap.

---

# 1. VISION DU JEU

**Cultivia** est un jeu de simulation agricole multijoueur par navigateur. Le joueur gère une exploitation agricole complète : élevage, cultures, matériel, commerce, et peut développer des activités secondaires (transport, concessionnaire, fromagerie, viticulture...).

**Inspiré de** : SimAgri (2005-2026, 7 serveurs, ~500 joueurs actifs par serveur)
**Différenciateur** : UI/UX moderne, desktop-first, temps réel, économie dynamique

---

# 2. SYSTÈME GLOBAL

## 2.1 Unités de temps
| Réel | Cultivia |
|------|----------|
| 1 jour | 1 jour Cultivia |
| 7 jours (1 semaine) | 1 mois Cultivia |
| 84 jours (12 semaines) | 1 année Cultivia (12 mois, 4 saisons) |

## 2.2 Saisons
- **Hiver** : Décembre, Janvier, Février
- **Printemps** : Mars, Avril, Mai
- **Été** : Juin, Juillet, Août
- **Automne** : Septembre, Octobre, Novembre

## 2.3 HT (Heures Travaillées) — remplace les PA SimAgri
Chaque joueur dispose de **35 HT/jour** pour réaliser toutes les actions sur son exploitation.

| Concept | Détail |
|---------|--------|
| HT de base | 35 HT/jour |
| HT employé | +35 HT/jour par employé embauché |
| Coût employé | 1 750 €/mois Cultivia |
| Achat HT | 10 €/HT acheté à un autre joueur (marché régional) |
| Vente HT | Vendre ses HT excédentaires aux autres joueurs |
| Déplacement | 0.01 HT/km (distance réelle entre communes) |
| Coopérative | 1 HT pour s'y rendre |

### Coût HT par action type
| Action | HT |
|--------|-----|
| Nourrir animaux (manuel) | Variable selon espèce/nombre |
| Nourrir animaux (robot) | 0 (automatique si stock suffisant) |
| Pailler litière (pailleuse) | Variable |
| Retirer fumier | Variable (chargeur+tracteur+benne) |
| Entretien bâtiment | 0.3 HT/bâtiment/mois |
| Entretien matériel | 1 HT/matériel/mois |
| Traite | Variable selon nb animaux + taille salle |
| Semer/Récolter | Variable selon surface + matériel |
| Transport camion | 0.01 HT/km (chauffeur: 32 HT/jour) |

## 2.4 Monnaie
Euro virtuel (€). Solde visible en permanence dans l'en-tête.

## 2.5 Localisation (France réelle)

Hiérarchie administrative réelle :
```
Région (18) → Département (101) → Arrondissement → Préfecture / Sous-préfecture
```

- À la création, le joueur choisit : **Région → Département → Préfecture ou Sous-préfecture**
- Chaque exploitation est rattachée à **1 commune chef-lieu** (préfecture ou sous-préfecture)
- **Distance** : calculée en km réels entre communes (API géocodage ou table précalculée)
- **Impact HT transport** : proportionnel à la distance réelle (ex: 0.01 HT/km)
- **Marché régional** : joueurs du même département
- **Marché national** : tous les joueurs

### Données géographiques (seed BDD)
- Source : [geo.api.gouv.fr](https://geo.api.gouv.fr/) — API officielle
- 101 préfectures (1 par département) + ~2 162 sous-préfectures (communes > 5 000 hab)
- ~2 263 communes jouables au total
- Coordonnées GPS pour calcul distances (Haversine) — ~2.5M paires précalculées
- Population pour pondérer la demande marchés/grossistes

## 2.6 Météo dynamique (données réelles)

La météo est **dynamique et basée sur les min/max réels** de chaque département.

### Source de données
- **API Open-Meteo** (gratuit, sans clé) : `https://api.open-meteo.com/v1/forecast`
- Paramètres récupérés par département (coordonnées GPS du chef-lieu) :
  - `temperature_2m_min` / `temperature_2m_max`
  - `precipitation_sum` (mm)
  - `sunshine_duration` (secondes)
  - `wind_speed_10m_max` (km/h)

### Mapping météo → gameplay
| Donnée réelle | Effet jeu |
|---------------|-----------|
| Précipitations > 20mm/jour | **Forte pluie** → impossible travailler parcelles |
| Précipitations 5-20mm | **Pluie** → jauge eau ↑ |
| Précipitations < 5mm + soleil > 6h | **Ensoleillé** → jauge soleil ↑ |
| Soleil > 10h + T° > 25°C | **Très ensoleillé** → attention sécheresse |
| Vent > 30 km/h | **Vent** → impossible pulvériser |
| T° < -5°C + précipitations | **Grêle** (probabilité) → dégâts arboriculture |
| T° min/max | Influence pousse cultures, chauffage serres |

### Cron météo
```
Toutes les 6h → fetch Open-Meteo pour chaque département
→ Stocker en Redis (cache 6h)
→ Appliquer effets sur parcelles lors du DAILY_UPDATE
```

### Avantage compétitif
- Un joueur en Bretagne aura plus de pluie qu'en PACA → choix stratégique à l'inscription
- Les rendements réels par région sont déjà dans le GDD (blé: 8.1 t/ha Basse-Normandie vs 3.4 Corse)
- La météo réelle crée de la **variabilité naturelle** et de l'imprévisibilité
