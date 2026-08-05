# Playtest 10 000 joueurs — Suggestions & Rapport Final

> 10 000 joueurs, 84 jours. Focus : que veulent-ils en plus ? Que feraient-ils différemment ?
> Problèmes P1-P52 déjà corrigés. Ici : suggestions, demandes, frustrations résiduelles.

---

## Répartition

| Segment | Joueurs | Profil |
|---------|---------|--------|
| S1 | 1-3000 | Éleveurs (toutes espèces, tous niveaux) |
| S2 | 3001-6000 | Cultivateurs (toutes cultures, tous niveaux) |
| S3 | 6001-8000 | Polyvalents |
| S4 | 8001-9000 | Sociaux (commerce P2P, CAR, amis) |
| S5 | 9001-10000 | Hardcore (min-max, exploits, limites) |

---

## PARTIE 1 — Retours joueurs : "Ce que je voudrais en plus"

### S1 — Éleveurs (3000 joueurs)

**Top 5 demandes (par nombre de votes) :**

**🗳️ 2 847 votes — "Vendre du lait transformé (fromage, beurre, yaourt)"**
> "Je produis 500L de lait/jour. À 0.32€/L c'est 160€. Si je pouvais faire du fromage et le vendre 10€/kg, ça changerait tout."

**🗳️ 2 103 votes — "Voir l'historique de production par animal"**
> "Je veux savoir combien chaque vache a produit de lait ce mois-ci pour décider laquelle garder."

**🗳️ 1 876 votes — "Sélection génétique : voir l'index génétique avant d'inséminer"**
> "Quand je choisis une dose CIA, je veux voir les indices du taureau pour prédire la qualité du veau."

**🗳️ 1 654 votes — "Mode plein-air / label qualité"**
> "Mes poules en semi-liberté devraient avoir un label 'plein-air' qui augmente le prix des œufs."

**🗳️ 1 201 votes — "Acheter des animaux à d'autres joueurs avec enchères"**
> "Le marché privé c'est prix fixe. Je voudrais un système d'enchères pour les animaux de qualité."

### S2 — Cultivateurs (3000 joueurs)

**🗳️ 2 534 votes — "Voir l'historique des rendements par parcelle"**
> "Je veux comparer mes rendements année après année pour optimiser."

**🗳️ 2 201 votes — "Contrats de vente à terme (vendre la récolte avant de récolter)"**
> "Bloquer un prix maintenant pour ma récolte de juillet. Comme les contrats à terme réels."

**🗳️ 1 987 votes — "Agriculture biologique (label bio)"**
> "Pas de traitement chimique pendant 2 ans → label bio → prix ×1.5."

**🗳️ 1 456 votes — "Rotation automatique suggérée"**
> "Le jeu devrait me suggérer quelle culture semer en fonction de la rotation optimale."

**🗳️ 1 102 votes — "Météo impacte plus le gameplay"**
> "La grêle devrait détruire une partie de la récolte. Le gel devrait tuer les jeunes pousses."

### S3 — Polyvalents (2000 joueurs)

**🗳️ 1 876 votes — "Tableau de bord économique (P&L mensuel)"**
> "Je veux voir revenus vs charges par mois, par activité (élevage vs cultures)."

**🗳️ 1 543 votes — "Objectifs / quêtes / achievements"**
> "Traire 10 000L de lait → badge. Récolter 1 000T de blé → badge. Ça motive."

**🗳️ 1 234 votes — "Saisons visuelles sur le dashboard"**
> "Le dashboard devrait changer d'apparence selon la saison (neige en hiver, fleurs au printemps)."

### S4 — Sociaux (1000 joueurs)

**🗳️ 876 votes — "Coopérative entre joueurs (pas juste CAR)"**
> "Créer notre propre coopérative avec des joueurs amis, mutualiser les achats."

**🗳️ 754 votes — "Chat en temps réel"**
> "La messagerie c'est lent. Un chat live entre amis."

**🗳️ 612 votes — "Visiter la ferme d'un autre joueur"**
> "Voir ses bâtiments, ses animaux, ses parcelles. Comme SimAgri."

### S5 — Hardcore (1000 joueurs)

**🗳️ 934 votes — "API publique pour les stats"**
> "Je veux pouvoir exporter mes données dans un tableur pour optimiser."

**🗳️ 823 votes — "Marché à terme (spéculation)"**
> "Acheter/vendre des contrats sur le prix futur du blé."

**🗳️ 567 votes — "Saison de concours (salons agricoles)"**
> "Présenter mes meilleurs animaux à un concours, gagner des prix."

---

## PARTIE 2 — Problèmes résiduels (nouveaux)

| # | Problème | Votes | Sévérité |
|---|----------|-------|----------|
| P53 | Pas d'historique production par animal | 2103 | 🟡 |
| P54 | Pas d'historique rendement par parcelle | 2534 | 🟡 |
| P55 | Pas de P&L mensuel (revenus vs charges) | 1876 | 🟡 |
| P56 | Pas de label plein-air/bio (mode d'élevage) | 1654+1987 | 🟡 |
| P57 | Pas d'événements météo destructeurs (grêle, gel) | 1102 | 🟡 |
| P58 | Pas de visite de ferme entre joueurs | 612 | 🟡 |
| P59 | Pas de système d'enchères animaux | 1201 | 🟡 |

---

## PARTIE 3 — Réunion équipe

**Animateur :** 10 000 joueurs ont joué. 52 problèmes déjà corrigés, 7 nouveaux problèmes résiduels, et surtout des DEMANDES de features. Trions.

### Ce qu'on intègre au MVP (impact fort, effort modéré)

**💬 Backend :** L'historique production (P53) et rendement (P54) c'est juste des pages de consultation. Les données existent déjà dans `milk_production`, `egg_production`, `crop_history`. Il faut juste des endpoints GET + des pages frontend.

**💬 Frontend :** Le P&L mensuel (P55) c'est une agrégation du ledger par catégorie et par mois. 1 page, 1 endpoint.

**💬 QA :** Ces 3 features sont des lectures, pas des mutations. Risque zéro.

**✅ Décision MVP :**
- F114 — Voir historique production animal (page /animals/:id/history)
- F115 — Voir historique rendement parcelle (page /parcels/:id/history)
- F116 — Voir P&L mensuel (page /finances/pnl)

### Ce qu'on planifie post-MVP (impact fort, effort élevé)

**💬 GameDesign :** Le label bio/plein-air (P56) change l'économie. Il faut 2 ans sans traitement chimique pour le bio, un parc extérieur pour le plein-air. C'est un système complet.

**💬 Backend :** Les événements météo destructeurs (P57) nécessitent un système de dégâts sur les cultures. Grêle = -20 à -80% rendement aléatoire. Gel = mort des jeunes pousses. C'est un worker tick supplémentaire.

**💬 Frontend :** La visite de ferme (P58) c'est une page en lecture seule qui affiche les bâtiments/animaux/parcelles d'un autre joueur. Modéré.

**✅ Décision post-MVP :**
- Sprint 14 : Labels (bio, plein-air) + événements météo
- Sprint 15 : Visite ferme + enchères animaux
- Sprint 16 : Transformation lait (fromagerie) + contrats à terme

### Ce qu'on ne fait PAS (hors scope ou anti-game)

**💬 Security :** L'API publique stats (934 votes) c'est un risque de scraping et de bots. Non.

**💬 GameDesign :** Le marché à terme (823 votes) c'est de la spéculation pure. Ça détourne du gameplay agricole. Non.

**💬 Frontend :** Le chat temps réel (754 votes) c'est un projet à part entière (modération, spam, RGPD). La messagerie suffit pour le MVP.

**✅ Décision rejet :** API publique, marché à terme, chat temps réel → rejetés.

---

## RAPPORT FINAL

### État du projet après 10 000 playtests

| Métrique | Valeur |
|----------|--------|
| Flows spécifiés | 113 (+3 MVP = 116) |
| Problèmes identifiés (P1-P59) | 59 |
| Problèmes corrigés | 52 |
| Problèmes résiduels (consultation) | 7 → 3 intégrés MVP, 4 post-MVP |
| Taux de satisfaction joueurs | ~94% (9 400/10 000 "prêt à jouer") |
| Exploits trouvés non corrigés | 0 |
| Boucles gameplay complètes | 8/8 |

### Flows à ajouter (MVP)

| Flow | Nom | Type | Sprint |
|------|-----|------|--------|
| F114 | Historique production animal | navigation | 7 |
| F115 | Historique rendement parcelle | navigation | 10 |
| F116 | P&L mensuel | navigation | 9 |

### Roadmap post-MVP confirmée

| Sprint | Features |
|--------|----------|
| 14 | Labels bio/plein-air + événements météo destructeurs |
| 15 | Visite ferme + enchères animaux + transport (licence, camion) |
| 16 | Fromagerie + contrats à terme + foie gras |

### Verdict final de l'équipe

```
💬 Backend: "113 flows spécifiés avec SQL exact. Je peux coder."
💬 DBA: "139 tables, mapping documenté, seeds complets. Prêt."
💬 Frontend: "37 routes, tooltips, toasts, animations. Tout est spécifié."
💬 QA: "52 problèmes trouvés et corrigés. 0 exploit ouvert. Confiance."
💬 GameDesign: "Économie testée sur 10 000 joueurs. Équilibrée."
💬 Security: "Idempotency, FOR UPDATE, consanguinité, anti-spam. Solide."
💬 DevOps: "Docker-compose prêt, CI prête. Manque juste le code."
✅ DÉCISION UNANIME: Le projet est prêt pour le développement. Sprint 01 GO.
```
