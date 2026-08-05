# Agriva — Farming Systems
> Sections : 4-12, 19, 26, 34-35

---

## 4. Temps, météo et calendrier

### 4.1 Structure temporelle
La journée doit rester l’unité de base la plus naturelle, avec une logique de tâches et de résolutions compatible navigateur.

### 4.2 Résolution du temps
- A. Ticks quotidiens.
- B. Temps continu.
- C. Modèle hybride avec queue de tâches.

### 4.3 Météo
La météo doit influencer :
- les tâches possibles ;
- les rendements ;
- le calendrier ;
- certaines décisions logistiques.

### 4.4 Granularité météo
- A. Départementale.
- B. Régionale avec modificateurs locaux.
- C. Bassin local précis.

### 4.5 Visibilité météo
- A. Prévision courte.
- B. Prévision moyenne avec incertitude.
- C. Prévision longue simplifiée.

### 4.6 Rôle des saisons
- A. Décoratif.
- B. Structurel.
- C. Structurel + économique + logistique.

### 4.7 Recommandation V1 — Météo
- Granularité retenue pour la V1 : **B. Régionale avec modificateurs locaux**.
- Prévision retenue pour la V1 : **B. Prévision moyenne avec incertitude**.
- Justification :
  - la météo doit différencier les grandes zones sans nécessiter un modèle hyper local complexe ;
  - les joueurs doivent pouvoir planifier sur quelques jours avec une marge d’erreur, ce qui renforce la valeur de la planification sans la détruire ;
  - les modificateurs locaux (effets de bassin, altitude, proximité littorale) peuvent enrichir l’expert plus tard.
- Conséquences design :
  - les écrans de météo montrent une vue régionale, avec des nuances locales plutôt en mode expert ;
  - les fenêtres météorologiques sont assez fiables sur le très court terme, plus incertaines au-delà ;
  - les risques météo majeurs doivent être anticipables (indices, alertes, historiques).

---

## 5. Ressources principales

### 5.1 Ressources de pilotage
- Argent.
- Capacité de travail.
- Capacité machine.
- Stockage.
- Logistique.

### 5.2 Argent
Usage : acheter, vendre, investir, payer les charges, absorber les aléas.

### 5.3 Capacité de travail
- Reset chaque jour.
- Représente les heures disponibles.
- Structure les arbitrages quotidiens.

### 5.4 Capacité machine
La capacité machine est liée au matériel possédé.

### 5.5 Question de base
- A. Argent + travail + machine.
- B. Argent + travail + machine + stockage.
- C. Argent + travail + machine + stockage + logistique.

### 5.6 Stocks et logistique
Ils servent à différer la vente, absorber les pics de production et donner du poids au territoire.

---

## 6. Travail et main-d’œuvre

### 6.1 Représentation du travail
- A. Heures de travail quotidiennes.
- B. Unités de travail.
- C. Heures visibles + unités internes.

### 6.2 Types de main-d’œuvre
- A. Familiale + salariée.
- B. Familiale + salariée + saisonnière.
- C. Familiale + salariée + saisonnière + prestataire.

### 6.3 Fatigue
- A. Absente.
- B. Légère.
- C. Structurante en expert.

### 6.4 Embauche et délégation
Elles doivent soulager la charge mentale du joueur, pas la compliquer.

---

## 7. Matériel et capacité machine

### 7.1 Structure du matériel
Le matériel doit donner une capacité opérationnelle réelle.

### 7.2 Question de modélisation
- A. Par famille de machines.
- B. Par machine précise en normal, détail en expert.
- C. Double système normal / expert.

### 7.3 Usure
- A. Absente en V1.
- B. Simplifiée.
- C. Détaillée.

### 7.4 Location et sous-traitance
- A. Propriété seulement.
- B. Propriété + location.
- C. Propriété + location + sous-traitance.

---

## 8. Planification

### 8.1 File de tâches
*(Voir aussi section 74.1 pour le catalogue d’actions de planification.)*

Le cœur de l’ergonomie doit être une file de tâches claire.

### 8.2 Réservation prévisionnelle
Le jeu doit montrer immédiatement les ressources consommées en prévisionnel.

### 8.3 Faisabilité
- A. Vert / orange / rouge.
- B. Pourcentage + couleur.
- C. Couleur + texte explicatif.

### 8.4 Réorganisation
Le joueur doit pouvoir réordonner, suspendre, annuler, optimiser ou demander de l’aide.

### 8.5 Question de planification
- A. File simple.
- B. File avec réservation de ressources.
- C. File avec simulation complète.

---

## 9. Activités et filières

### 9.1 Socle V1
*(Voir aussi section 74.3 pour le catalogue d’actions exploitation/élevage/cultures.)*

- Grandes cultures.
- Élevage.
- Maraîchage.

### 9.2 Extensions naturelles
- Viticulture.
- Arboriculture.
- Foresterie.
- Horticulture.
- Aquaculture.
- Transformation.

### 9.3 Différenciation
Chaque activité doit avoir sa propre identité de rythme, de contraintes, de matériel, de risques et de débouchés.

### 9.4 Question V1 activités

### 9.5 Recommandation V1 — Activités
- Option retenue pour la V1 : **A. Grandes cultures + élevage + maraîchage**.
- Justification : ce trio couvre déjà trois rythmes de jeu différents (cycle long, cycle moyen, cycle court) sans multiplier excessivement les systèmes ni les assets. Il permet de représenter une bonne partie de la réalité agricole française tout en restant concentré.
- Conséquences design :
  - viticulture, arboriculture, foresterie, horticulture et aquaculture sont préparées dans le design mais livrées en V2+ ;
  - la plupart des exemples, tutoriels et workflows de base doivent pouvoir se dérouler dans ces trois activités ;
  - le territoire et l’économie doivent déjà proposer des variations pertinentes pour ces trois filières.
- À reporter dans agriva_decisions_log.md comme liste officielle des activités V1.

- Noter ici l’option choisie (A/B/C) pour la V1 et justifier en quelques lignes.
- Reporter la décision dans agriva_decisions_log.md.

- A. Grandes cultures + élevage + maraîchage.
- B. Grandes cultures + élevage + viticulture.
- C. Grandes cultures + élevage + maraîchage + arboriculture.

---

## 10. Sols et agronomie

### 10.1 Mode normal
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

- A. Fertilité.
- B. Fertilité + humidité.
- C. Fertilité + humidité + fatigue culturale.

### 10.2 Mode expert
- A. NPK.
- B. NPK + matière organique.
- C. NPK + MO + pH + historique cultural.

### 10.3 Règle de design
Le mode normal montre les conséquences. Le mode expert montre les causes.

### 10.4 Rotations
- A. Bonus simples.
- B. Mécanique centrale.
- C. Mécanique centrale + expert détaillé.

### 10.5 Recommandation V1 — Sols
- Mode normal V1 : **B. Fertilité + humidité** comme indicateurs principaux visibles.
- Mode expert V1 : **C. NPK + MO + pH + historique cultural**, accessibles pour les joueurs qui veulent creuser l’agronomie.
- Justification :
  - deux indicateurs (fertilité + humidité) suffisent en normal pour que le joueur comprenne l’état de ses parcelles sans jargon ;
  - le mode expert doit pouvoir accueillir de vrais usages agronomiques pour les joueurs “métiers”, sans impacter la lisibilité pour les autres ;
  - les rotations doivent être centrales, mais leurs détails agronomiques restent surtout exposés en expert.
- Conséquences design :
  - en normal, les actions de gestion du sol (apports, couverts, jachère) affichent principalement l’effet sur ces deux barres ;
  - en expert, les écrans de parcelles doivent montrer des tableaux ou panneaux détaillés avec NPK, MO, pH, historique et effets attendus des pratiques ;
  - les outils d’aide à la décision agronomique doivent se brancher sur ces indicateurs experts sans surcharger le mode normal.

---

## 11. Foncier et parcelles

### 11.1 Représentation
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

Les parcelles doivent rester abstraites et lisibles.

### 11.2 Fusion
La vraie fusion permanente est préférable au regroupement temporaire.

### 11.3 Question de parcelles
- A. Parcelles textuelles sans géométrie.
- B. Parcelles avec taille et type abstraits.
- C. Parcelles abstraites + contraintes territoriales.

### 11.4 Question de fusion
- A. Permanente et coûteuse.
- B. Permanente avec délai.
- C. Permanente + limites par bassin.

---

## 12. Territoire

### 12.1 Niveaux territoriaux
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

- Département.
- Ville.
- Bassin local.
- Région.

### 12.2 Rôle du territoire
Le territoire doit influencer météo, économie, logistique, coûts, spécialisations et identité des joueurs.

### 12.3 Coopérative bot
Elle doit être départementale et située dans la préfecture / capitale du département.

### 12.4 Question de niveau territorial
- A. Département.
- B. Ville / bassin local.
- C. Double niveau département + localité.

---


---

## 19. Transformation

### 19.1 Place dans le jeu
- A. Hors V1.
- B. Limité en V1.
- C. Axe majeur plus tard.

### 19.2 Recommandation V1 — Transformation
- Option retenue pour la V1 : **B. Quelques chaînes simples en V1**.
- Justification :
  - la transformation est un élément important de la réalité agricole, mais elle peut rapidement devenir un jeu dans le jeu ;
  - quelques chaînes simples (ex : lait → fromage standard, céréales → farine ou aliment, fruits → jus) suffisent à introduire la notion de valeur ajoutée ;
  - les filières de transformation complexes (qualités, affinage, labels très spécifiques) peuvent attendre V2+.
- Conséquences design :
  - la transformation V1 doit rester lisible dans l’UI et associée à des bâtiments ou services facilement identifiables ;
  - elle doit être rentable mais pas au point d’éclipser complètement la vente de produits bruts ;
  - les futures extensions de transformation devront se brancher sur ce socle sans imposer de refonte.

### 19.2 Rôle
Elle doit créer de la valeur ajoutée et pas juste de la complexité.

---


---

## 26. Prestataires et services

### 26.1 Place dans le jeu
Les prestataires peuvent soulager la charge mentale et créer des décisions économiques.

### 26.2 Exemples
- travaux agricoles ;
- travaux forestiers ;
- transport ;
- insémination ;
- maintenance ;
- conseil.

### 26.3 Question de rôle
- A. Dépannage.
- B. Dépannage + spécialisation.
- C. Dépannage + spécialisation + réduction de charge mentale.

---


---

## 34. Services et prestataires

### 34.1 Quels services doivent exister en V1 ?
- A. Travaux agricoles uniquement.
- B. Travaux agricoles + transport.
- C. Travaux agricoles + transport + maintenance + conseil.

### 34.2 Qui fournit les services ?
- A. Le bot uniquement.
- B. Les joueurs uniquement.
- C. Un mix bot + joueurs selon le niveau de marché.

### 34.3 Quel rôle pour les prestataires ?
- A. Dépannage ponctuel.
- B. Réduction de charge mentale.
- C. Spécialisation stratégique et source de business.

### 34.4 Quels services sont experts ?

### 34.5 Recommandation V1 — Services et prestataires
- Services effectivement présents en V1 :
  - **ETA bot pour travaux de champs** (labour, semis, récolte, certains travaux spécifiques) ;
  - **services de transport simples** via la coop bot (prise en charge de livraisons/collectes standards) ;
  - éventuellement **quelques prestations élevage basiques** (ex : insémination standard) si la charge de design reste maîtrisée.
- Services explicitement repoussés à V2+ :
  - prestataires joueurs spécialisés ;
  - services de conseil avancé ;
  - services forestiers, viticoles, ou très spécialisés ;
  - services avec contrats complexes ou scénarisés.
- Présentation en mode normal :
  - mise en avant de quelques boutons clairs “Faire intervenir un prestataire” sur les tâches éligibles ;
  - information principale : coût, délai, effet sur la file de tâches ;
  - pas de détails techniques complexes.
- Présentation en mode expert :
  - détails sur les coûts décomposés, les impacts sur les ateliers, les limites de capacité des prestataires ;
  - visibilité accrue des prestataires disponibles par territoire et par période.
- Conséquences design :
  - les prestataires doivent être perçus comme un **levier pour soulager le joueur** plutôt que comme une optimisation obligatoire ;
  - l’économie doit rester équilibrée pour que le joueur puisse réussir sans recourir en permanence aux services.

- Lister les services effectivement présents en V1 (bot/joueurs) et ceux réservés aux versions ultérieures.
- Spécifier comment ils seront présentés en mode normal vs expert.

- A. Aucun.
- B. Les services logistiques.
- C. Les services techniques et de conseil avancé.

## 35. Événements et saisons

### 35.1 Quelle importance donner aux événements ?
- A. Cosmétique.
- B. Motivation secondaire.
- C. Mécanique structurante de rythme.

### 35.2 Quels types d’événements ?
- A. Saisons agricoles classiques.
- B. Concours et défis.
- C. Salons, enchères, festivals et compétitions.

### 35.3 Les événements ont-ils un impact économique ?
- A. Non.
- B. Oui, léger.
- C. Oui, significatif.

### 35.4 Les événements sont-ils ?
- A. Fixes.
- B. Systémiques.
- C. Systémiques + territoriaux.
