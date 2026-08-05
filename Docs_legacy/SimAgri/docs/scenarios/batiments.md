# Scénarios utilisateur — Bâtiments V1

## SC-01 : Nouveau joueur construit son premier poulailler

**Prérequis :** Joueur inscrit, 100 000€, 8h de travail
**Étapes :**
1. Aller sur la page Bâtiments
2. Cliquer "Construire"
3. Sélectionner "Poulailler" dans le catalogue
4. Choisir taille : 200 m²
5. Choisir mode : Label Rouge
6. Quantité : 1
7. Vérifier l'affichage : 40 000€, 2h/8h, énergie 6 kWh/jour (0.48€/jour), construction instantanée
8. Confirmer

**Résultat attendu :**
- Solde : 60 000€
- Heures restantes : 6h
- Bâtiment visible dans la liste avec ID unique (POU-1009)
- Nom par défaut : "Poulailler-POU-1009"
- Mode : Label Rouge (chip orange)
- État : OK (chip vert)

---

## SC-02 : Construire 3 hangars d'un coup

**Prérequis :** Joueur avec 100 000€, 8h
**Étapes :**
1. Construire → Hangar → 300 m² → Quantité 3
2. Vérifier : 90 000€ (30 000 × 3), 6h/8h, pas d'énergie
3. Confirmer

**Résultat attendu :**
- 3 hangars avec IDs uniques (HAN-1010, HAN-1011, HAN-1012)
- Solde : 10 000€, heures : 2h

---

## SC-03 : Heures insuffisantes

**Prérequis :** Joueur avec 2h restantes
**Étapes :**
1. Construire → Stabulation → 200 m² → Quantité 2
2. Vérifier : "4h / 2h disponibles" en rouge
3. Message "Heures de travail insuffisantes"
4. Bouton "Construire" grisé

**Résultat attendu :** Impossible de construire

---

## SC-04 : Renommer un bâtiment

**Étapes :**
1. Cliquer sur le nom du bâtiment dans la liste
2. Modale s'ouvre avec le nom actuel
3. Saisir "Ma belle étable"
4. Confirmer

**Résultat attendu :**
- Colonne "Nom" affiche "Ma belle étable"
- Colonne "Type" affiche toujours "Stabulation"

---

## SC-05 : Entretien mensuel

**Prérequis :** Bâtiment stabulation 200m² niv.1, usure 25%
**Étapes :**
1. Cliquer "Entretien" sur le bâtiment
2. Sélectionner "Mensuel"
3. Vérifier : coût 2 400€ (2% de 120 000€), 0.5h, usure 25% → 10%
4. Confirmer

**Résultat attendu :** Usure passe à 10%, solde -2 400€, heures -0.5h

---

## SC-06 : Entretien annuel ne monte pas l'usure

**Prérequis :** Bâtiment avec usure à 3%
**Étapes :**
1. Entretien → Annuel
2. Vérifier preview : usure 3% → 3% (pas 5%)

**Résultat attendu :** Usure reste à 3% (min(3, 5) = 3)

---

## SC-07 : Upgrade niveau

**Prérequis :** Bâtiment niv.1, usure < 80%
**Étapes :**
1. Cliquer "Niveau +"
2. Vérifier coût : 60 000€ (50% de 120 000€ pour niv.2)
3. Confirmer

**Résultat attendu :** Niveau passe à 2, bouton disparaît à niv.5

---

## SC-08 : Upgrade bloqué si usure trop élevée

**Prérequis :** Bâtiment niv.1, usure 85%
**Étapes :**
1. Cliquer "Niveau +"

**Résultat attendu :** Erreur "Usure trop élevée, entretenez d'abord"

---

## SC-09 : Agrandir un bâtiment vide

**Prérequis :** Hangar 300m² niv.1, vide
**Étapes :**
1. Cliquer "Agrandir"
2. Saisir +200 m²
3. Vérifier : coût 20 000€ (100€ × 200), 2h
4. Confirmer

**Résultat attendu :** Taille passe à 500 m²

---

## SC-10 : Agrandir bloqué si stock présent

**Prérequis :** Silo avec 50t de blé
**Étapes :**
1. Cliquer "Agrandir"

**Résultat attendu :** Erreur "Le bâtiment doit être vide"

---

## SC-11 : Détruire un bâtiment

**Prérequis :** Poulailler 200m² niv.1, vide
**Étapes :**
1. Cliquer "Détruire"
2. Modale rouge : "Poulailler-POU-1009", récupération 4 000€ (10% de 40 000€), 1h
3. Confirmer

**Résultat attendu :** Bâtiment supprimé, solde +4 000€, heures -1h

---

## SC-12 : Détruire bloqué si stock présent

**Prérequis :** Hangar avec du matériel
**Étapes :**
1. Cliquer "Détruire"

**Résultat attendu :** Erreur "Le bâtiment doit être vide"

---

## SC-13 : Construction avec délai (≥ 10 bâtiments)

**Prérequis :** Joueur avec 10 bâtiments existants
**Étapes :**
1. Construire → Bergerie → 300 m²
2. Vérifier : "3 jour(s) — prêt le JJ/MM/AAAA"
3. Confirmer

**Résultat attendu :**
- Bâtiment en liste avec chip orange "Fini le JJ/MM/AAAA"
- Boutons entretien/upgrade/agrandir non disponibles
- Worker daily tick passera à "OK" quand la date est atteinte

---

## SC-14 : Usure automatique (worker)

**Prérequis :** Bâtiment niv.1, usure 0%, saison printemps
**Après 1 tick daily :**
- Usure = 0.15% (0.15 × 1.0 × 1.0)

**Après 100 ticks :**
- Usure = 15%

**Après 200 ticks niv.5 été :**
- Usure = 200 × 0.15 × 0.40 × 0.8 = 9.6%

---

## SC-15 : Énergie automatique (worker)

**Prérequis :** Poulailler 200m² niv.1, saison printemps
**Après 1 tick daily :**
- 0.03 × 200 × 1.0 × 1.0 × 0.08 = 0.48€ débité du solde

**Après 30 ticks (1 mois) :**
- 30 × 0.48 = 14.40€/mois

---

## SC-16 : Mode élevage sur bâtiment non-élevage

**Étapes :**
1. Construire → Hangar
2. Vérifier : pas de sélecteur de mode d'élevage dans la modale
3. Dans le tableau : colonne Mode affiche "—"

**Résultat attendu :** Le mode n'est pertinent que pour l'élevage
