# API Routes — Générées depuis le registry (116 flows)

| Méthode | Route | Flow(s) |
|---------|-------|--------|
| DELETE | `/api/buildings/:id` | F070 Détruire un bâtiment |
| DELETE | `/api/employees/:id` | F028 Licencier un employé |
| GET | `/api/animals?species=cattle&page=1&limit=20` | F003 Voir liste animaux |
| GET | `/api/animals/:id` | F004 Consulter fiche animal |
| GET | `/api/animals/:id/pedigree?depth=3` | F022 Voir arbre généalogique |
| GET | `/api/animals/:id/production-history?months=12` | F114 Voir historique production animal |
| GET | `/api/animals/carcass-stats` | F097 Voir statistiques carcasses |
| GET | `/api/animals/dashboard` | F003 Voir liste animaux |
| GET | `/api/animals/milk-quality` | F098 Voir qualité lait détaillée |
| GET | `/api/buildings` | F072 Voir liste bâtiments |
| GET | `/api/buildings/energy` | F106 Voir énergie bâtiments |
| GET | `/api/cooperatives` | F093 Rejoindre une CAR |
| GET | `/api/dashboard` | F031 Voir dashboard complet |
| GET | `/api/finances/pnl?months=12` | F116 Voir P&L mensuel |
| GET | `/api/finances/summary` | F074 Voir finances |
| GET | `/api/ledger?page=1&limit=20` | F074 Voir finances |
| GET | `/api/market/prices` | F026 Voir cours du marché |
| GET | `/api/notifications?page=1&limit=50` | F104 Voir notifications |
| GET | `/api/parcels/:id/yield-history` | F115 Voir historique rendement parcelle |
| GET | `/api/players/:id/profile` | F096 Voir fiche joueur |
| GET | `/api/rankings?type=general&page=1&department_id=optional` | F095 Voir classements |
| GET | `/api/tutorial/status` | F112 Tutoriel onboarding |
| GET | `/api/vehicles` | F073 Voir liste matériel |
| GET | `/api/weather?prefecture_id={id}` | F030 Voir météo |
| POST | `/api/animals/:id/heal` | F012 Soigner un animal |
| POST | `/api/animals/:id/inseminate` | F018 Inséminer (mâle ferme), F019 Inséminer (CIA) |
| POST | `/api/animals/:id/list-for-sale` | F080 Vendre animal entre joueurs |
| POST | `/api/animals/:id/vaccinate` | F014 Vacciner un animal |
| POST | `/api/animals/auto-place` | F021 Placer animal depuis arrivage |
| POST | `/api/animals/batch-heal` | F013 Soigner tous (batch) |
| POST | `/api/animals/buy` | F002 Acheter un animal au Marché Central |
| POST | `/api/animals/milk` | F023 Traire les vaches |
| POST | `/api/animals/move` | F029 Déplacer animal au pré |
| POST | `/api/animals/slaughter` | F025 Vendre animal à l'abattoir |
| POST | `/api/buildings` | F001 Construire un bâtiment |
| POST | `/api/buildings/:id/auto-feed` | F010 Configurer nourrissage automatique |
| POST | `/api/buildings/:id/bedding` | F015 Mettre de la paille |
| POST | `/api/buildings/:id/expand` | F113 Agrandir un bâtiment |
| POST | `/api/buildings/:id/feed` | F008 Nourrir animaux (manuel) |
| POST | `/api/buildings/:id/manure` | F016 Retirer le fumier |
| POST | `/api/buildings/:id/slurry` | F017 Retirer le lisier |
| POST | `/api/buildings/:id/upgrade` | F069 Améliorer un bâtiment |
| POST | `/api/buildings/:id/water` | F009 Abreuver animaux |
| POST | `/api/compost/start` | F078 Composter du fumier |
| POST | `/api/employees` | F027 Embaucher un employé |
| POST | `/api/eta/order` | F046 Commander ETA Cultivia |
| POST | `/api/finances/loans` | F033 Demander un prêt |
| POST | `/api/finances/savings` | F032 Souscrire épargne |
| POST | `/api/loans/:id/early-repay` | F079 Rembourser prêt par anticipation |
| POST | `/api/market/buy` | F006 Acheter aliments au Marché Central, F007 Remplir cuve à eau, F068 Acheter HVC (carburant) |
| POST | `/api/market/negociant/buy` | F071 Appeler le négociant en bestiaux |
| POST | `/api/market/negociant/call` | F071 Appeler le négociant en bestiaux |
| POST | `/api/market/sell` | F024 Vendre lait au Marché Central, F042 Vendre récolte, F099 Vendre laine au Marché Central, F100 Vendre œufs au Marché Central |
| POST | `/api/messages` | F034 Envoyer un message |
| POST | `/api/parcels/:id/analyze-soil` | F036 Analyser le sol |
| POST | `/api/parcels/:id/defane` | F102 Défaner pommes de terre |
| POST | `/api/parcels/:id/drill` | F057 Forer une parcelle |
| POST | `/api/parcels/:id/fertilize` | F039 Épandre engrais |
| POST | `/api/parcels/:id/fill-water` | F051 Remplir bacs à eau au pré |
| POST | `/api/parcels/:id/harvest` | F041 Récolter |
| POST | `/api/parcels/:id/irrigate` | F058 Irriguer une parcelle |
| POST | `/api/parcels/:id/mulch-straw` | F060 Broyer paille |
| POST | `/api/parcels/:id/prepare` | F037 Préparer sol (déchaumer/labourer/herser) |
| POST | `/api/parcels/:id/press-straw` | F059 Presser paille |
| POST | `/api/parcels/:id/roll` | F054 Rouler une parcelle |
| POST | `/api/parcels/:id/sow` | F038 Semer |
| POST | `/api/parcels/:id/spread-manure` | F055 Épandre fumier sur parcelle |
| POST | `/api/parcels/:id/spread-slurry` | F056 Épandre lisier sur parcelle |
| POST | `/api/parcels/:id/treat` | F040 Traiter (fongicide/herbicide/insecticide) |
| POST | `/api/parcels/buy` | F035 Acheter une parcelle |
| POST | `/api/savings/:id/close` | F065 Clôturer épargne |
| POST | `/api/tenders` | F108 Créer appel d'offres |
| POST | `/api/vehicles/:id/buy-piece` | F061 Acheter pièce détachée |
| POST | `/api/vehicles/:id/insure` | F062 Souscrire assurance matériel |
| POST | `/api/vehicles/:id/list-for-sale` | F064 Vendre matériel entre joueurs |
| POST | `/api/vehicles/:id/maintain` | F044 Entretenir matériel |
| POST | `/api/vehicles/:id/repair` | F045 Réparer matériel en panne |
| POST | `/api/vehicles/:id/sell` | F047 Vendre matériel |
| POST | `/api/vehicles/buy` | F043 Acheter matériel neuf |
| PUT | `/api/animals/:id` | F005 Renommer un animal |
| PUT | `/api/player/notification-preferences` | F105 Configurer préférences notifications |

**Total : 81 routes uniques.**

## Notes

### POST /api/market/buy — Dispatch par product
Cette route unique gère 3 cas selon le champ `product` du body :
- `product: 'hay'|'corn_silage'|...` → `FeedService` (F006)
- `product: 'water'` → `WaterService` (F007)
- `product: 'hvc'` → `FuelService` (F068)

### Pattern ETA (F046)
L'ETA appelle les mêmes services que le joueur mais avec `eta_mode: true` :
- Skip vérification véhicule/HVC/usure (l'ETA a son propre matériel)
- Coût = grille ETA (€/ha) au lieu du coût matériel joueur
