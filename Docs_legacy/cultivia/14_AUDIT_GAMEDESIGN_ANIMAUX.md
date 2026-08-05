# CULTIVIA — Audit Game Design : Système Animaux
## 2026-04-14 — 20 agents spécialisés, revue exhaustive

---

# RÉSUMÉ EXÉCUTIF

| Catégorie | Problèmes trouvés | Critiques | Majeurs | Mineurs |
|-----------|-------------------|-----------|---------|---------|
| Données espèces/races | 26 | 4 | 10 | 12 |
| Nourrir (feed) | 14 | 5 | 6 | 3 |
| Abreuver (water) | 14 | 3 | 7 | 4 |
| Litière/fumier/lisier | 10 | 2 | 5 | 3 |
| Traite (milk) | 11 | 3 | 5 | 3 |
| Œufs + Laine/Duvet | 20 | 7 | 9 | 4 |
| Achat/Vente | 18 | 5 | 8 | 5 |
| Soins/Vaccin/Labels | 23 | 8 | 8 | 7 |
| Déplacements | 30 | 10 | 12 | 8 |
| Fusion/Gestion | 20 | 9 | 8 | 3 |
| Génétique | 17 | 3 | 10 | 4 |
| Worker DAILY_UPDATE | 25 | 4 | 11 | 10 |
| Coûts HT | 17 | 7 | 6 | 4 |
| Coûts € | 10 | 2 | 5 | 3 |
| UI Animaux | 17 | 4 | 6 | 7 |
| Constantes | 8 | 0 | 8 | 0 |
| Reproduction | ABSENT | — | — | — |
| **TOTAL** | **~280** | **~76** | **~124** | **~80** |

---

# TOP 20 PROBLÈMES CRITIQUES (à corriger en priorité)

## 🔴 1. Nourrir ne consomme pas de stock
Le feed action marque les animaux comme nourris mais ne vérifie ni ne déduit aucun stock de nourriture. Nourriture infinie gratuite.

## 🔴 2. Abreuver ne consomme pas d'eau
Le water action marque les animaux comme abreuvés sans vérifier ni consommer l'eau des cuves. Eau infinie gratuite.

## 🔴 3. Vente abattoir : pas de prix/kg
`sell_slaughter` calcule `poids × rendement × conformation × engraissement` mais ne multiplie jamais par un prix/kg. Une vache de 750kg rapporte ~435€ au lieu de ~1957€.

## 🔴 4. Reproduction : RIEN n'est implémenté
Zéro action d'insémination, zéro progression de gestation dans le worker, zéro naissance. Le schéma BDD est prêt mais aucune logique métier n'existe.

## 🔴 5. Génétique : seulement 3/14 indices générés
`buy_coop` ne génère que croissance, lait, allure. Manquent : prolificité, qualité_lait, laine, oeuf, éclosion, résistance, sociabilité, fertilité, duvet, physique, mental.

## 🔴 6. Vaccination non fonctionnelle
`vaccinated_until` est écrit en BDD mais jamais lu par le worker. Les animaux vaccinés tombent malades quand même.

## 🔴 7. Labels : aucun bonus appliqué à la vente
Plein-air (+5%), Bio (+20%), Veau sous la mère (+1.50€/kg), Agneau sous la mère (+0.30€/kg) — aucun n'est vérifié ni appliqué dans `sell_slaughter`.

## 🔴 8. Déplacements : aucune vérification d'équipement
`move_to_pasture` ne vérifie pas la possession d'une bétaillère + tracteur. Pas de consommation HVC.

## 🔴 9. Déplacements : pas de validation espèce↔bâtiment
On peut mettre des poulets dans une stabulation ou des vaches dans un poulailler.

## 🔴 10. Capacité bâtiment : formule fausse
Le code compare le nombre d'animaux directement à `surface_or_capacity` au lieu de diviser par `capacity_per_animal`.

## 🔴 11. 3 espèces sans races (Pintades, Oies, Canards)
Zéro race seedée pour ces 3 espèces. Impossible d'acheter ou d'élever ces animaux.

## 🔴 12. Seulement 30/80 races seedées
Le GDD cible ~80 races, seules 30 sont implémentées.

## 🔴 13. Unmerge crée des animaux à 0 kg
Les animaux défusionnés ont `weight_kg = 0`, cassant tous les calculs de vente.

## 🔴 14. Duvet et laine stockés dans le même champ
Le duvet d'oie (~10€/kg) et la laine ovine (~0.45€/kg) sont dans le même `contents.laine`. Prix unique de 5€/kg pour tout.

## 🔴 15. Ration libre : bonus client-trusted
Le serveur accepte `rationBonus` du client sans vérification. Un joueur peut envoyer `rationBonus: 9999`.

## 🔴 16. Vétérinaire soigne les animaux morts
`health_status != 'healthy'` matche aussi `'dead'`. Un animal mort peut être "soigné".

## 🔴 17. Pas de suivi plein-air (outdoor_days)
Aucun compteur de jours au pré. Impossible de calculer le label Plein-air.

## 🔴 18. Worker : robot feeding ne déduit pas le stock
Le robot nourrit les animaux mais ne consomme jamais la nourriture du silo.

## 🔴 19. Worker : pas de mort par déshydratation
`waterCheck` rend malade mais ne tue jamais (contrairement à `hungerCheck` qui tue après 5 jours).

## 🔴 20. Respond_offer : pas de vérification solde acheteur
L'acheteur peut avoir un solde négatif après acceptation d'une offre.

---

# SYSTÈMES ENTIÈREMENT ABSENTS

| Système | Statut |
|---------|--------|
| Reproduction (3 modes insémination) | ❌ Absent |
| Gestation + Naissances | ❌ Absent |
| Héritage génétique (moyenne parents ± variation) | ❌ Absent |
| Pipeline/canalisation auto-remplissage | ❌ Absent |
| Source naturelle eau | ❌ Absent |
| Récupération eau de pluie | ❌ Absent |
| Négociant (ELV-019) | ❌ Absent |
| Chien de berger (ELV-028) | ❌ Absent |
| Robot alimentation activation (ELV-002) | ❌ Absent |
| Nourrissage auto 15j (ELV-038) | ❌ Absent |
| Jours de marché (régional/national) | ❌ Absent |
| Vente privée création offre (ELV-021) | ❌ Absent |
| Calibre œufs (S/M/L/XL) | ❌ Absent |
| Bois déchiqueté litière | ❌ Absent |
| Conformation/engraissement calcul | ❌ Absent |
| Valorisation génétique vente | ❌ Absent |

---

# CONSTANTES MANQUANTES (game.ts)

8 constantes à ajouter : EQUIPMENT_MAINTENANCE_HT, COOP_VISIT_HT, DRIVER_DOUBLE_CREW_HT, FUMIER_PER_HECTARE, LISIER_PER_HECTARE, SOIL_ANALYSIS_COST, SAVINGS_TIERS, PARCEL_BUYBACK_RATE.

---

# POINTS POSITIFS ✅

- Les 9 constantes vérifiées sont toutes correctes
- Le schéma BDD est bien structuré et prêt pour les features manquantes
- Les 14 espèces sont présentes avec les bons noms
- Les données de gestation/reproduction dans le seed sont correctes
- Le worker a une bonne architecture (fonctions séparées, ordre logique)
- L'auth est en place sur toutes les routes
- Les transactions BDD sont utilisées pour les opérations multi-tables
