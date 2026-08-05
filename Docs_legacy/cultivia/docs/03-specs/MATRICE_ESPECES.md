# Matrice Espèces — Spécificités par espèce animale

> Source : docs/00-reference/regle sim.txt + seeds existants
> Objectif : garantir que chaque boucle d'élevage est complète

---

## 1. Matrice Transport

| Espèce | Véhicule transport | Seed existant | Status |
|--------|-------------------|---------------|--------|
| Bovins | Bétaillère (tractée par tracteur) | ✅ betaillere | OK |
| Bisons | Bétaillère | ✅ betaillere | OK |
| Caprins | Bétaillère | ✅ betaillere | OK |
| Ovins | Bétaillère | ✅ betaillere | OK |
| Porcins | Bétaillère | ✅ betaillere | OK |
| Daims | Bétaillère | ✅ betaillere | OK |
| Volailles | **Utilitaire** (motorisé) | ❌ MANQUANT | À ajouter |
| Pintades | **Utilitaire** | ❌ MANQUANT | À ajouter |
| Lapins | **Utilitaire** | ❌ MANQUANT | À ajouter |
| Oies | **Utilitaire** | ❌ MANQUANT | À ajouter |
| Canards | **Utilitaire** | ❌ MANQUANT | À ajouter |
| Chevaux | **Van** (tracté par utilitaire) | ❌ MANQUANT | À ajouter |

**Action :** Ajouter `utilitaire` (2 modèles) et `van` (1 modèle) dans `05_vehicle_types.sql`.

---

## 2. Matrice Bâtiments

| Espèce | Bâtiment principal | Seed | Bâtiment plein-air | Seed |
|--------|-------------------|------|-------------------|------|
| Bovins | Stabulation | ✅ | Pré (parcelle) | ✅ |
| Caprins | Chèvrerie | ✅ | Pré | ✅ |
| Ovins | Bergerie | ✅ | Pré | ✅ |
| Porcins | Porcherie | ✅ | Parc à porcins | ❌ MANQUANT |
| Volailles | Poulailler | ✅ | Parc à volailles | ❌ MANQUANT |
| Pintades | Poulailler | ✅ | Parc à volailles | ❌ MANQUANT |
| Oies | Poulailler | ✅ | Parc à volailles | ❌ MANQUANT |
| Canards | Poulailler | ✅ | Parc à volailles | ❌ MANQUANT |
| Lapins | Clapier | ✅ | — | — |
| Chevaux | Écurie | ✅ | Pré | ✅ |
| Bisons | Stabulation | ✅ | Pré | ✅ |
| Daims | Stabulation | ✅ | Pré | ✅ |

**Bâtiments accessoires par production :**

| Production | Bâtiment requis | Seed |
|-----------|----------------|------|
| Lait (bovins, caprins, ovins) | Salle de traite + Cuve à lait | ✅ |
| Œufs (volailles, pintades, oies, canards) | Salle de conditionnement + Pièce stockage œufs | ❌ MANQUANT |
| Laine (ovins) | Aucun bâtiment spécifique | ✅ |
| Foie gras (oies, canards) | Salle de gavage | ❌ MANQUANT |

**Action :** Ajouter dans `04_building_types.sql` :
- `parc_volailles` (semi-liberté volailles/pintades/oies/canards)
- `parc_porcins` (plein-air porcins)
- `salle_conditionnement` (ramasser/conditionner œufs)
- `piece_stockage_oeuf` (stocker œufs)
- `salle_gavage` (foie gras — P3)

---

## 3. Matrice Productions

| Espèce | Production | Flow existant | Vente | Flow vente |
|--------|-----------|---------------|-------|------------|
| Bovins laitiers | Lait | F023 Traire ✅ | Marché Central | F024 ✅ |
| Bovins allaitants | Viande (carcasse) | F025 Abattoir ✅ | Abattoir | F025 ✅ |
| Caprins | Lait | F023 ✅ (générique) | Marché Central | F024 ✅ |
| Ovins laitiers | Lait | F023 ✅ (générique) | Marché Central | F024 ✅ |
| Ovins laine | Laine | F082 Tondre ✅ | Marché Central | ❌ MANQUANT |
| Porcins | Viande | F025 ✅ | Abattoir | F025 ✅ |
| Volailles | Œufs | F083 Ramasser ✅ | Marché Central | ❌ MANQUANT |
| Volailles | Viande | F025 ✅ | Abattoir | F025 ✅ |
| Pintades | Œufs | F083 ✅ | Marché Central | ❌ MANQUANT |
| Oies | Foie gras | ❌ MANQUANT (P3) | Marché Central | ❌ MANQUANT |
| Canards | Foie gras | ❌ MANQUANT (P3) | Marché Central | ❌ MANQUANT |
| Lapins | Viande | F025 ✅ | Abattoir | F025 ✅ |
| Chevaux | Aucune (loisir/vente) | — | Entre joueurs | F080 ✅ |
| Bisons | Viande | F025 ✅ | Abattoir | F025 ✅ |
| Daims | Viande | F025 ✅ | Abattoir | F025 ✅ |

**Action :** Ajouter flows :
- F099 Vendre laine au Marché Central
- F100 Vendre œufs au Marché Central

---

## 4. Matrice Alimentation

| Espèce | Ration | Aliments | Eau/jour |
|--------|--------|----------|----------|
| Bovins laitiers | Ration hivernale (nov-mars) + herbe (avr-oct) | Foin, maïs ensilé, tourteau, minéraux | 80-120L |
| Bovins allaitants | Idem + herbe toute l'année si au pré | Foin, herbe | 60-80L |
| Caprins | Ration caprine | Foin, céréales, minéraux | 8-12L |
| Ovins | Ration ovine | Foin, céréales, minéraux | 5-10L |
| Porcins | Ration porcine | Céréales, tourteau soja, minéraux | 10-15L |
| Volailles | Ration volaille | Blé/triticale, avoine, maïs, minéraux | 0.2-0.5L |
| Lapins | Ration lapin | Foin, granulés, légumes | 0.3-0.5L |
| Chevaux | Ration équine | Foin, avoine, granulés | 30-50L |
| Bisons | Ration bison (oct-mars) + herbe | Foin, herbe | 40-60L |

**Note :** Le flow F008 (nourrir) est déjà paramétré par `ration_id` — les rations sont dans `10_animal_rations.sql`. La logique est correcte, il faut juste vérifier que les rations par espèce sont complètes dans le seed.

---

## 5. Matrice Reproduction

| Espèce | Âge adulte | Gestation | Portée | Insém./jour max | Délai post-naissance |
|--------|-----------|-----------|--------|-----------------|---------------------|
| Bovins | 15 mois | 9 mois (63j) | 1 | 4 | 21j |
| Caprins | 7 mois | 5 mois (35j) | 2 | 6 | 14j |
| Ovins | 7 mois | 5 mois (35j) | 1-2 | 6 | 14j |
| Porcins | 8 mois | 4 mois (28j) | 6-12 | 3 | 7j |
| Volailles | 6 mois | 1 mois (7j) | 6-10 | — (auto) | 5j |
| Lapins | 3 mois | 1 mois (7j) | 4-8 | — | 3j |
| Chevaux | 36 mois | 11 mois (77j) | 1 | 2 | 42j |

**Note :** F018/F019 (inséminer) sont paramétrés par `species.max_inseminations_per_day` et `species.post_birth_delay`. La logique est correcte si les données seed sont bonnes.

---

## 6. Résumé des manques

### Seeds à ajouter
1. `05_vehicle_types.sql` : utilitaire (×2), van (×1)
2. `04_building_types.sql` : parc_volailles, parc_porcins, salle_conditionnement, piece_stockage_oeuf

### Flows à ajouter
3. F099 — Vendre laine au Marché Central
4. F100 — Vendre œufs au Marché Central

### Flows à modifier
5. F002 (acheter animal) : véhicule conditionnel par espèce (bétaillère OU utilitaire OU van)
6. F025 (abattoir) : idem véhicule
7. F029 (déplacer au pré) : idem véhicule
8. F083 (ramasser œufs) : ajouter requires salle_conditionnement + piece_stockage_oeuf

### Logique déjà correcte (paramétrée)
- F008 nourrir → ration_id par espèce ✅
- F018/F019 inséminer → params espèce ✅
- F023 traire → bovins + caprins + ovins ✅
- F082 tondre → ovins uniquement ✅
