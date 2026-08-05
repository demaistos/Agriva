# 🐄 Audit Boucle Élevage — Comparaison SimAgri vs Registry Cultivia

**Date** : 2026-04-06
**Auteur** : Expert Élevage IA
**Sources** : `docs/00-reference/regle sim.txt` + `docs/03-specs/ACTION_FLOW_REGISTRY.yaml`

---

## Synthèse

| Métrique | Valeur |
|----------|--------|
| Étapes de la boucle analysées | 15 |
| Flows existants dans le registry | 28 (élevage) |
| Manques critiques identifiés | 8 |
| Corrections mineures | 12 |
| Flows à créer | 3 |

---

## 1. Construire un bâtiment (F001)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F001 | ✅/❌ |
|---------|---------|---------------|-------|
| Solde suffisant | ✅ | ✅ `balance >= prix` | ✅ |
| PA/HT suffisants | 35 PA/jour | ✅ `ht >= 2.0` | ✅ |
| Pas de délai pour les 10 premiers | ✅ | ❌ Non modélisé | ⚠️ |

### Ressources consommées
- €, HT → ✅ modélisés
- Ledger `category='purchase'` → ✅

### Manques
- **M1** : SimAgri précise « pas de délai de construction pour les 10 premiers bâtiments ». Le registry ne distingue pas ce cas. → **Mineur**, à traiter en Phase 2+.

---

## 2. Acheter un animal au Marché Central (F002)

### Prérequis matériels/infra
| Critère | SimAgri | Registry F002 | ✅/❌ |
|---------|---------|---------------|-------|
| Bétaillère | ✅ (bovins, caprins, ovins, porcins) | ✅ `vehicle:trailer` | ✅ |
| Tracteur | ✅ (pour tracter bétaillère) | ✅ `vehicle:tractor` | ✅ |
| Bâtiment avec place | ✅ (surface par animal) | ✅ `building_has_space` | ✅ |
| HVC (carburant) | ✅ | ✅ `fuel:hvc` | ✅ |
| Kit éleveur/polyvalent | Cultivia-only | ✅ `kit:eleveur\|polyvalent` | ✅ |

### Ressources consommées
| Ressource | SimAgri | Registry | ✅/❌ |
|-----------|---------|----------|-------|
| € (prix animal) | ✅ | ✅ | ✅ |
| € (transport) | ✅ distance-based | ✅ `distance_km × 0.50` | ✅ |
| HT | PA variable | ✅ `0.5 + distance/100` | ✅ |
| HVC | ✅ | ✅ `distance_km × 0.15` | ✅ |
| Usure véhicules | ✅ | ✅ `distance_km × 0.02` | ✅ |

### Effets secondaires
- Ledger purchase + transport → ✅
- Panne si wear > 80% → ✅
- Animal `status='in_transit'` → ✅
- WS events → ✅

### Manques
- **M2** : SimAgri distingue bétaillère (bovins), utilitaire (volailles), van (chevaux). Le registry ne gère que `trailer`. → **Critique pour multi-espèces** mais OK pour MVP bovins.
- **M3** : SimAgri : « Les Jours 1,2,4,5 achat régional, Jours 3,6,7 national ». Non modélisé. → **Mineur**, feature Phase 3+.

---

## 3. Transporter l'animal (F048 — Tick arrivée)

### Prérequis
- Animal `status='in_transit'` + `arrival_at <= NOW()` → ✅

### Effets
- `status='available'` → ✅
- Notification → ✅

### Manques
- **M4** : Le registry F048 met `status='available'` mais ne précise pas `location_type='building'`. L'animal devrait être confirmé dans le bâtiment cible. → **Correction nécessaire**.

---

## 4. Loger l'animal (F021 — Placer depuis arrivage)

### Prérequis
| Critère | SimAgri | Registry F021 | ✅/❌ |
|---------|---------|---------------|-------|
| Bâtiment avec place | ✅ surface/animal | ✅ | ✅ |
| HT | ✅ | ✅ `0.2×N` | ✅ |

### Manques
- **M5** : SimAgri définit des surfaces par animal (taureau=15m², vache=12m², veau=5m²). Le registry utilise `animal_count/max_capacity` sans distinction de surface par type. → **Correction nécessaire** : la capacité doit être en m² et non en nombre d'animaux.

---

## 5. Nourrir les animaux (F008)

### Prérequis
| Critère | SimAgri | Registry F008 | ✅/❌ |
|---------|---------|---------------|-------|
| Ration sélectionnée | ✅ (multiples rations par âge/espèce) | ✅ `ration_selected` | ✅ |
| Stock suffisant | ✅ | ✅ | ✅ |
| HT | ✅ PA variable | ✅ | ✅ |
| Pas déjà nourri | ✅ 1×/jour | ✅ `not_already_fed` | ✅ |
| Désileuse si méthode désilage | ✅ tracteur+désileuse | ✅ `desilage without equipment` | ✅ |

### Ressources consommées
- Stock aliments (par composant de ration) → ✅
- HT → ✅
- `last_fed_at`, `days_unfed=0` → ✅

### Manques
- **M6** : SimAgri a 3 niveaux de qualité de nourriture (mauvaise/moyenne/bonne) qui influencent croissance et production lait. Le registry mentionne `★{quality}` dans le toast mais pas de logique de qualité dans la transaction. → **Correction nécessaire** : ajouter `ration_quality` dans le calcul.
- **M7** : SimAgri : « à la main ou avec tracteur+désileuse ». Le registry a `method: 'manual'|'desilage'` mais ne précise pas que `manual` ne nécessite pas de véhicule (plus de HT) vs `desilage` (moins de HT, nécessite tracteur+désileuse). → **Correction nécessaire**.
- **M8** : Les rations SimAgri sont très détaillées (foin+maïs ensilé, paille+maïs, etc.) avec des quantités par âge. Le registry est générique. → **OK** pour le registry, détail dans les seed data.

---

## 6. Abreuver les animaux (F009)

### Prérequis
| Critère | SimAgri | Registry F009 | ✅/❌ |
|---------|---------|---------------|-------|
| Cuve à eau | ✅ | ✅ `infra:cuve_eau` | ✅ |
| Eau disponible | ✅ | ✅ `water_available` | ✅ |
| HT | ✅ | ✅ `ht >= 0.3` | ✅ |
| Pas déjà abreuvé | ✅ | ✅ | ✅ |

### Ressources consommées
- Eau (quantité variable par espèce/âge) → ✅ `cuve -= 45L` dans test
- HT → ✅

### Manques
- **M9** : SimAgri : eau de pluie récupérée par toitures remplit la cuve automatiquement. Non modélisé. → **Mineur**, feature Phase 2+.
- **M10** : SimAgri : pour animaux au pré, il faut tonne à eau + bacs à eau. Le registry F009 ne gère que la cuve pour bâtiment. → **Critique** : il manque un flow « Remplir bacs au pré » avec `vehicle:tonne_eau`.

---

## 7. Mettre de la paille / Litière (F015)

### Prérequis
| Critère | SimAgri | Registry F015 | ✅/❌ |
|---------|---------|---------------|-------|
| Stock paille | ✅ | ✅ `straw_stock >= need` | ✅ |
| HT | ✅ | ✅ `ht >= 0.5` | ✅ |
| Litière pas fraîche | ✅ | ✅ `bedding fresh` | ✅ |

### Ressources consommées
- Paille (kg/jour par type animal) → ✅
- HT → ✅
- `bedding_ok=true` → ✅

### Manques
- **M11** : SimAgri : « pailleuse ou à la main ». Le registry ne distingue pas les méthodes. À la main = plus de HT, pailleuse = tracteur+pailleuse requis. → **Correction nécessaire** : ajouter `method: 'manual'|'pailleuse'` comme F008.
- **M12** : SimAgri : quantités de paille par type d'animal (taureau=90kg, vache=72kg, veau=30kg). Le registry est générique `need`. → **OK**, détail dans seed data.
- **M13** : SimAgri : élevage sur caillebotis = pas de paille, mais du lisier. Le registry ne modélise pas le choix litière/caillebotis au niveau du bâtiment. → **Correction nécessaire** dans F001 : ajouter `floor_type: 'litiere'|'caillebotis'`.
- **M14** : Le registry F015 ne mentionne pas la transformation paille→fumier. Le fumier devrait s'accumuler dans le bâtiment. → **Correction nécessaire** : ajouter `UPDATE building manure += paille_used × ratio`.

---

## 8. Retirer le fumier (F016) / Retirer le lisier (F017)

### F016 — Fumier
| Critère | SimAgri | Registry F016 | ✅/❌ |
|---------|---------|---------------|-------|
| Fumier présent | ✅ | ✅ `manure > 0` | ✅ |
| Fosse à fumier avec place | ✅ | ✅ `fosse_has_space` | ✅ |
| Tracteur + épandeur | ✅ | ✅ `vehicle:tractor + vehicle:epandeur` | ✅ |
| HVC | ✅ | ✅ `fuel:hvc` | ✅ |

### F017 — Lisier
- **M15** : F017 a une `chain: []` vide ! Aucune logique. → **Critique** : doit être complété avec la même structure que F016 mais pour lisier (fosse à lisier, tonne à lisier).

---

## 9. Soigner un animal (F012 / F013)

### Prérequis
| Critère | SimAgri | Registry F012 | ✅/❌ |
|---------|---------|---------------|-------|
| Animal malade | ✅ | ✅ `is_sick` | ✅ |
| € (vétérinaire) | ✅ | ✅ `balance >= cost` | ✅ |
| HT | ✅ | ✅ `ht >= 0.5` | ✅ |

### Effets
- `is_sick=false`, `health+=20` → ✅
- Ledger → ✅

### Manques
- **M16** : SimAgri : « Un animal peut mettre plusieurs jours à guérir ». Le registry guérit instantanément (`is_sick=false`). → **Correction nécessaire** : ajouter `healing_until = NOW() + Xd` au lieu de guérison instantanée.
- **M17** : SimAgri : « animal malade ne prend pas de poids, ne produit pas de lait, mâle ne peut pas inséminer ». Ces effets ne sont pas dans le tick santé F011. → **Correction nécessaire** dans F011.

---

## 10. Vacciner un animal (F014)

### Prérequis
| Critère | SimAgri | Registry F014 | ✅/❌ |
|---------|---------|---------------|-------|
| Non vacciné | ✅ | ✅ `vaccinated_until < now` | ✅ |
| € | ✅ | ✅ `50€` | ✅ |
| HT | ✅ | ✅ `0.5` | ✅ |

### Manques
- **M18** : SimAgri : « vacciné = protégé pendant un an ». Le registry dit `21d` (21 jours = 3 mois Cultivia). Un an Cultivia = 84 jours. → **Correction nécessaire** : `vaccinated_until = NOW() + 84d` (1 an Cultivia).

---

## 11. Inséminer — Mâle ferme (F018) / CIA (F019)

### F018 — Naturelle
| Critère | SimAgri | Registry F018 | ✅/❌ |
|---------|---------|---------------|-------|
| Femelle adulte | ✅ génisse ≥ 27 mois | ✅ `adult` | ✅ |
| Pas gestante | ✅ | ✅ `not_pregnant` | ✅ |
| En période | ✅ | ✅ `in_period` | ✅ |
| Mâle disponible | ✅ même race, > 3 ans | ✅ `male_available` | ✅ |
| HT | ✅ | ✅ `1.0` | ✅ |
| Max inséminations/jour mâle | ✅ 4/jour (bovins) | ❌ Non modélisé | ❌ |

### Manques
- **M19** : SimAgri : « taureau max 4 inséminations/jour ». Non vérifié dans F018. → **Correction nécessaire** : ajouter check `male.inseminations_today < max_per_day`.
- **M20** : SimAgri : « même race obligatoire, croisements impossibles ». Non vérifié explicitement. → **Correction nécessaire** : ajouter check `female.breed_id = male.breed_id`.
- **M21** : SimAgri : « nouvelle insémination au minimum 3 mois après dernière mise bas ». Non modélisé. → **Correction nécessaire** : ajouter check `last_birth_at + 21d < NOW()`.

### F019 — CIA
- **M22** : F019 a une `chain: []` vide ! → **Critique** : doit être complété. Logique : coût fixe (200€), pas besoin de mâle, même checks femelle.

---

## 12. Naissance (F020 — Tick)

### Logique
| Critère | SimAgri | Registry F020 | ✅/❌ |
|---------|---------|---------------|-------|
| Gestation terminée | ✅ 9 mois bovins | ✅ `pregnant_until <= NOW()` | ✅ |
| Création petit | ✅ 1 veau (bovins) | ✅ `INSERT new animal` | ✅ |
| Mère lactation | ✅ | ✅ `is_lactating=true` | ✅ |
| Génétique calculée | ✅ | ✅ `calculated genetics` | ✅ |

### Manques
- **M23** : SimAgri : nombre de petits variable par espèce (bovins=1, caprins=2, porcins=6-9, etc.). Le registry ne précise pas la logique de calcul du nombre. → **OK** pour MVP bovins, à enrichir multi-espèces.
- **M24** : Le nouveau-né a `location_type='arrival'` mais devrait être dans le même bâtiment que la mère. → **Correction nécessaire** : `location_type='building', building_id=mother.building_id`.
- **M25** : SimAgri : allaitement pour races allaitantes (veaux 0-3 mois nourris par la mère). Le registry mentionne `nursing_until=NOW()+21d` mais pas de logique d'allaitement (pas besoin de nourrir manuellement). → **Correction nécessaire** : ajouter flag `is_nursing` sur le veau.

---

## 13. Placer animal depuis arrivage (F021)

Couvert en §4. Pas de manque supplémentaire.

---

## 14. Traire les vaches (F023)

### Prérequis
| Critère | SimAgri | Registry F023 | ✅/❌ |
|---------|---------|---------------|-------|
| Salle de traite | ✅ | ✅ `milking_parlor` | ✅ |
| Cuve à lait non pleine | ✅ | ✅ `milk_tank_not_full` | ✅ |
| HT | ✅ PA variable selon nb animaux + taille salle | ✅ `ht >= 1.0` | ⚠️ |
| Vaches en lactation | ✅ | ✅ `lactating_cows` | ✅ |

### Manques
- **M26** : SimAgri : « traite jusqu'à 4 fois/jour, avant 6h, 12h, 18h, 24h ». Le registry a `already milked` mais ne modélise pas les 4 créneaux. → **Correction nécessaire** : ajouter `milking_slot: 1|2|3|4` et `last_milked_slot`.
- **M27** : SimAgri : « PA nécessaires dépendent du nombre d'animaux et de la taille de la salle de traite ». Le registry a un HT fixe de 1.0. → **Correction nécessaire** : HT dynamique.
- **M28** : SimAgri : production lait variable par jour (10-28L selon race). Le registry mentionne `Calculate production per cow` mais pas la formule. → **OK**, détail dans les formules.

---

## 15. Vendre lait au Marché Central (F024)

### Prérequis
| Critère | SimAgri | Registry F024 | ✅/❌ |
|---------|---------|---------------|-------|
| Stock lait > 0 | ✅ | ✅ | ✅ |
| HT | ✅ | ✅ `0.5` | ✅ |
| Tracteur + citerne lait | ✅ | ✅ `vehicle:tractor + vehicle:citerne_lait` | ✅ |
| HVC | ✅ | ✅ | ✅ |

### Manques
- **M29** : SimAgri : prix du lait variable selon indice Qualité Lait (265-400€/1000L bovins). Le registry ne modélise pas la valorisation QL. → **Correction nécessaire** : ajouter `price = base_price × ql_multiplier`.

---

## 16. Vendre animal à l'abattoir (F025)

### Prérequis
| Critère | SimAgri | Registry F025 | ✅/❌ |
|---------|---------|---------------|-------|
| HT | ✅ | ✅ `0.5` | ✅ |
| Tracteur + bétaillère | ✅ | ✅ `vehicle:tractor + vehicle:trailer` | ✅ |
| HVC | ✅ | ✅ | ✅ |

### Effets
- Prix = poids × cours → ✅ `weight × market_price`
- Transport déduit → ✅
- `life_stage='dead'` → ✅
- Capacity -= 1 → ✅
- Warnings gestante/lactation → ✅

### Manques
- **M30** : SimAgri : rendement carcasse (50-75% selon race) + classification qualité (conformation A-E, engraissement 1-5). Le registry utilise `weight × market_price` sans rendement carcasse. → **Correction nécessaire** : `revenue = weight × rendement_carcasse × prix_kg × quality_multiplier`.
- **M31** : SimAgri : valorisation génétique (+1 à +10% si bonne génétique). Non modélisé. → **Mineur**, Phase 3+.

---

## 17. Déplacer au pré (F029)

### Prérequis
| Critère | SimAgri | Registry F029 | ✅/❌ |
|---------|---------|---------------|-------|
| Place au pré | ✅ | ✅ `destination_has_space` | ✅ |
| Saison OK | ✅ Avril-Octobre (laitières) | ✅ `season_ok` | ✅ |
| Bétaillère | ✅ | ✅ `vehicle:trailer` | ✅ |
| HT | ✅ | ✅ | ✅ |

### Manques
- **M32** : SimAgri : races allaitantes peuvent rester au pré toute l'année (avec ration hivernale Nov-Mars). Le registry bloque en hiver pour tous. → **Correction nécessaire** : conditionner sur `breed.is_allaitante`.
- **M33** : SimAgri : chien de troupeau permet déplacement pré→pré sans bétaillère (même zone). Non modélisé. → **Mineur**, Phase 4+.

---

## Flows manquants à créer

### FM1 — Remplir bacs à eau au pré (nouveau flow)
SimAgri : « tonne à eau pour remplir bacs dans pré ». Aucun flow ne couvre l'abreuvement au pré.
- **Trigger** : bouton sur page pré
- **Prérequis** : `vehicle:tractor`, `vehicle:tonne_eau`, `infra:bac_eau` dans le pré, `cuve_eau > 0`
- **Consomme** : HT, HVC, eau de la cuve
- **Sprint suggéré** : 8 (avec F029)

### FM2 — Tick litière/fumier — accumulation quotidienne (nouveau tick)
SimAgri : la litière se transforme en fumier progressivement. Aucun tick ne gère l'accumulation.
- **Trigger** : worker_tick quotidien
- **Logique** : pour chaque bâtiment litière, `manure += Σ(paille_par_animal)`, `bedding_quality -= decay_rate`
- **Sprint suggéré** : 5 (avec F015/F016)

### FM3 — Tick abreuvement automatique (nouveau tick)
SimAgri : l'eau est consommée quotidiennement. Aucun tick ne décrémente la cuve.
- **Trigger** : worker_tick quotidien
- **Logique** : `cuve_eau -= Σ(eau_par_animal)`, si cuve=0 → risque maladie
- **Sprint suggéré** : 4 (avec F009)

---

## Récapitulatif des corrections

### Critiques (bloquent le gameplay)
| ID | Flow | Correction |
|----|------|------------|
| M15 | F017 | Compléter chain lisier (vide) |
| M22 | F019 | Compléter chain CIA (vide) |
| M4 | F048 | Confirmer `location_type='building'` à l'arrivée |
| M10 | — | Créer flow FM1 « Remplir bacs au pré » |
| FM2 | — | Créer tick accumulation fumier/litière |
| FM3 | — | Créer tick consommation eau quotidienne |

### Importants (fidélité SimAgri)
| ID | Flow | Correction |
|----|------|------------|
| M5 | F021 | Capacité en m² et non en nombre |
| M6 | F008 | Ajouter logique qualité ration |
| M7 | F008 | Distinguer manual (plus HT) vs desilage (tracteur+désileuse) |
| M11 | F015 | Distinguer manual vs pailleuse |
| M13 | F001 | Ajouter `floor_type` litière/caillebotis |
| M14 | F015 | Transformation paille→fumier |
| M16 | F012 | Guérison progressive, pas instantanée |
| M17 | F011 | Effets maladie : pas de poids/lait/insémination |
| M18 | F014 | Vaccination = 84j (1 an Cultivia), pas 21j |
| M19 | F018 | Max inséminations/jour par mâle |
| M20 | F018 | Vérifier même race |
| M21 | F018 | Délai post-mise-bas (21j = 3 mois) |
| M24 | F020 | Nouveau-né dans bâtiment de la mère |
| M25 | F020 | Flag allaitement pour veaux 0-3 mois |
| M26 | F023 | 4 créneaux de traite/jour |
| M27 | F023 | HT dynamique selon nb animaux + taille salle |
| M29 | F024 | Prix lait selon indice Qualité Lait |
| M30 | F025 | Rendement carcasse + classification qualité |
| M32 | F029 | Races allaitantes au pré toute l'année |

### Mineurs (Phase 3+)
| ID | Description |
|----|-------------|
| M1 | Pas de délai construction 10 premiers bâtiments |
| M2 | Utilitaire (volailles) / Van (chevaux) |
| M3 | Jours régionaux/nationaux pour achats |
| M9 | Eau de pluie récupérée par toitures |
| M23 | Nombre de petits variable par espèce |
| M25 | Allaitement races allaitantes |
| M31 | Valorisation génétique à la vente |
| M33 | Chien de troupeau déplacement pré→pré |
