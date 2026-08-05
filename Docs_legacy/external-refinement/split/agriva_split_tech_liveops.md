# Agriva — Tech & LiveOps
> Sections : 56-62, 72

---

## 56. Plateformes, technique et performances

### 56.1 Plateforme principale
- A. Navigateur desktop.
- B. Navigateur + mobile responsive.
- C. Navigateur + appli mobile dédiée.

### 56.2 Contraintes de performance
- A. Cible machines modestes, priorité à la légèreté.
- B. Cible moyenne, quelques effets visuels possibles.
- C. Cible mixte, optimisation avancée nécessaire.

### 56.3 Fréquence des calculs lourds
- A. Résolutions batch (jour/nuit) uniquement.
- B. Résolutions batch + certains recalculs en temps quasi-réel.
- C. Modèle plus continu avec optimisation forte côté serveur.

### 56.4 Tolérance à la latence
- A. Le jeu tolère latence modérée (modèle très asynchrone).
- B. Latence modérée mais ressentie sur certains écrans.
- C. Forte exigence de réactivité (plus cher techniquement).

## 57. Données, analytics et équilibrage

### 57.1 Niveau de télémétrie
- A. Minimal : rétention, revenus, quelques métriques clés.
- B. Moyen : rétention, progression, points de friction, économie.
- C. Avancé : parcours détaillés, économie, comportements par profil.

### 57.2 Utilisation des données
- A. Suivi de santé globale.
- B. Ajustements réguliers d’équilibrage.
- C. Ajustements + expérimentation (tests A/B sur certains systèmes).

### 57.3 Outils d’équilibrage
- A. Tableurs simples.
- B. Tableurs + simulateurs dédiés.
- C. Tableurs + simulateurs + outils internes d’édition/balancing.

### 57.4 Rythme de retouche de l’économie
- A. Rare (patchs ponctuels).
- B. Régulier (par saison, par mise à jour majeure).
- C. Continu (petits ajustements fréquents).

## 58. Live Ops, mises à jour et contenu

### 58.1 Stratégie Live Ops
- A. Peu ou pas de Live Ops, mises à jour rares.
- B. Mises à jour régulières (contenu + équilibrage) mais limitées.
- C. Live Ops structurés (événements, saisons, contenus réguliers).

### 58.2 Types de mise à jour
- A. Corrections et équilibrage seulement.
- B. Corrections + nouvelles activités / produits.
- C. Corrections + nouveaux systèmes + événements Live.

### 58.3 Calendrier cible
- A. Aucune promesse publique.
- B. Rythme trimestriel.
- C. Rythme mensuel ou bimensuel sur certains contenus.

### 58.4 Risque de casser le jeu
- A. Changement minimal, priorité à la stabilité.
- B. Changements modérés, avec phases de tests.
- C. Changements plus fréquents, compensés par de bons outils et du monitoring.

## 59. Monétisation et modèle économique

### 59.1 Modèle principal
- A. Achat unique / licence.
- B. Abonnement / pass récurrent.
- C. Free-to-play avec options premium.

### 59.2 Rôle de la monétisation dans le game design
- A. Strictement séparée du cœur de gameplay.
- B. Influence des boucles secondaires (cosmétiques, confort).
- C. Impact plus direct sur certaines boucles (à cadrer avec prudence).

### 59.3 Ce qui ne doit jamais être monétisé
- A. Les performances de base.
- B. Les performances de base + accès à certaines filières.
- C. Les performances de base + accès + météo/territoire.

### 59.4 Monétisation compatible avec la fantasy agricole
- A. Cosmétiques (skins de ferme, interfaces, badges).
- B. Packs de confort (slots, templates de rotations, assistants visuels).
- C. Contenus thématiques (régions, cultures, événements spéciaux).

## 60. Modding, API et extensibilité

### 60.1 Place du modding
- A. Aucune pour l’instant.
- B. API de données en lecture seule pour outils externes.
- C. Système plus ouvert (scénarios, règles, contenus paramétrables).

### 60.2 Risque sur l’équilibrage
- A. On protège très fortement l’équilibre (pas de modding).
- B. On autorise des outils externes qui n’affectent pas le cœur économique.
- C. On prévoit plus tard une “sandbox” séparée pour les expériences.

### 60.3 Bénéfices attendus
- A. Limités pour le moment.
- B. Communauté d’outils et d’analyses.
- C. Communauté de créateurs de contenu / règles.

---

## 61. QA, tests et validation gameplay

### 61.1 Stratégie de test
- A. Tests internes ad hoc.
- B. Tests internes + petit groupe de bêta.
- C. Tests internes + bêta organisée + retours structurés.

### 61.2 Focales de test prioritaires
- A. Bugs bloquants.
- B. Bugs + friction UX.
- C. Bugs + friction UX + qualité des décisions proposées.

### 61.3 Rythme de test
- A. En fin de cycle uniquement.
- B. À chaque jalon majeur.
- C. En continu avec itérations courtes.

---

## 62. Documentation et transmission

### 62.1 Niveau de documentation attendu
- A. GDD principal uniquement.
- B. GDD + docs par système.
- C. GDD + docs par système + guides pour les nouveaux.

### 62.2 Mise à jour de la doc
- A. Rare.
- B. À chaque grande décision.
- C. Processus régulier couplé aux releases.

### 62.3 Public cible de la doc
- A. Équipe cœur seulement.
- B. Équipe + contributeurs externes.
- C. Équipe + contributeurs + futurs partenaires / moddeurs.

---


---

## 72. Compatibilité et intégrations externes

### 72.1 Intégrations agri/pro potentielles (futur)
- A. Aucune prévue.
- B. Intégration de quelques données publiques (météo, indices).
- C. Intégrations plus avancées (par ex. données agronomiques ouvertes) dans des modes spécifiques.

### 72.2 Intégrations sociales
- A. Aucune.
- B. Partage simple de captures / stats.
- C. Partage structuré (profils, exploits, classements publics).

---
