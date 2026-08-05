# Audit 5 agents SimAgri — Features manquantes

---

## 🎮 Agent 1 — Éleveur laitier (200 vaches)

| Feature SimAgri | Dans Cultivia ? | Action |
|----------------|----------------|--------|
| Tarissement (arrêt traite 2 mois avant mise bas) | ❌ | F133 |
| Transfert animal entre bâtiments (pas juste au pré) | ❌ F029 = pré uniquement | Élargir F029 |
| Pesée animal | ✅ F124 | — |
| Lots d'animaux | ✅ F117-F120 | — |
| Carnet santé | ✅ F123 | — |
| Sevrage auto | ✅ F122 | — |

## 🎮 Agent 2 — Cultivateur 200ha

| Feature SimAgri | Dans Cultivia ? | Action |
|----------------|----------------|--------|
| Retourner le lin (séchage au sol) | ❌ | F134 (spécifique lin) |
| Achat matériel en commun (CUMA) | ❌ | F135 |
| Frais annonce P2P (1 500€ sur SimAgri) | ❌ gratuit chez nous | Ajouter frais 100€ ? |

## 🎮 Agent 3 — Multi-espèces

| Feature SimAgri | Dans Cultivia ? | Action |
|----------------|----------------|--------|
| Transfert entre bâtiments | ❌ | Élargir F029 |
| Tout le reste | ✅ | — |

## 🎮 Agent 4 — Économie/commerce

| Feature SimAgri | Dans Cultivia ? | Action |
|----------------|----------------|--------|
| Négocier prix matériel occasion | ❌ prix fixe P2P | F136 |
| Achat en commun matériel (CUMA, 5 joueurs max) | ❌ | F135 |
| Frais annonce matériel (1 500€) | ❌ | Ajouter frais |
| Enchères | ❌ | Post-MVP Sprint 15 |

## 🎮 Agent 5 — Social/politique

| Feature SimAgri | Dans Cultivia ? | Action |
|----------------|----------------|--------|
| Créer sa propre CAR | ❌ juste rejoindre | F137 |
| Forum in-game | ❌ | Post-MVP |
| Achat/vente entre CAR | ❌ | Post-MVP |

---

## Flows à ajouter

| Flow | Nom | Sprint |
|------|-----|--------|
| F133 | Tarir une vache (arrêt traite avant mise bas) | 7 |
| F134 | Retourner le lin (séchage au sol) | 11 |
| F135 | Achat matériel en commun (CUMA, 2-5 joueurs) | 15 |
| F136 | Négocier prix matériel occasion P2P | 15 |
| F137 | Créer une CAR | 13 |

## Modifications

| Flow | Modification |
|------|-------------|
| F029 | Élargir : déplacer entre bâtiments (pas juste au pré) |
| F080 | Ajouter frais annonce 100€ (SimAgri = 1 500€, on réduit) |
| F064 | Ajouter frais annonce 100€ pour matériel aussi |
