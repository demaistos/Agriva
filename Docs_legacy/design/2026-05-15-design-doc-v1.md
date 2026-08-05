# Agriva — Design Doc V1

> Date : 2026-05-15
> Statut : Validé (brainstorming initial)

---

## Vision

Jeu de simulation agricole multijoueur par navigateur. Le joueur gère une exploitation agricole complète. Interface de gestion (pas de rendu graphique). Réaliste accessible.

## Cible

- Joueurs PC principalement (responsive quand même)
- Nostalgiques SimAgri + amateurs de jeux de gestion
- Adultes avec un boulot — le jeu ne punit pas l'absence

## Modèle temporel

- **Tick : toutes les 4-6h** (~4 ticks/jour)
- **Compression : 1 semaine réelle = 1 mois de jeu**
- 1 saison = ~3 semaines réelles
- 1 année de jeu = ~3 mois réels
- File d'ordres entre les ticks

## Réalisme

- **Réaliste accessible** — systèmes réalistes, interface lisible
- Mode Normal (simplifié) / Mode Expert (détails)
- Aléas (météo, maladies) = impact réel mais jamais destructeur

## Multijoueur

- Commerce + services + coopératives
- Carte France avec régions → marché local par région + marché national
- Coopérative bot (gérée par le jeu) = filet de sécurité liquidité
- Tout le monde est agriculteur d'abord, diversification ensuite

## Classements

- Métriques de performance agricole : rendement/ha, génétique, production laitière, marge nette...
- N'impacte pas les débutants — ils jouent à leur rythme
- Récompenses cosmétiques uniquement

## Monétisation

- Free-to-play + abonnement confort (QoL)
- Jamais pay-to-win
- Abo = dashboards avancés, alertes, outils de planification, cosmétiques

## Scope V1 — 3 piliers

### Pilier 1 : La ferme qui tourne
- Parcelles + sols (fertilité simple)
- Grandes cultures (blé, orge, colza, maïs, tournesol)
- Météo régionale (impact travaux + rendements)
- Matériel (achat, usure, utilisation)
- Calendrier cultural (semis → croissance → récolte, saisons)

### Pilier 2 : L'économie qui fonctionne
- Trésorerie (revenus, charges, bilan)
- Marché bot/coopérative (acheter intrants, vendre récoltes, prix variables)
- Stockage

### Pilier 3 : Le multijoueur minimal
- Comptes joueurs, auth
- Régions (chaque joueur dans une région)
- Marché joueur (vente entre joueurs)
- Classements simples (rendement/ha, marge nette)

## Post-V1

- Élevage (V2)
- Maraîchage (V2)
- Activités secondaires : transport, fromagerie, viticulture (V3+)
- Coopératives joueurs, services entre joueurs (V2-V3)

## Stack technique

| Couche | Technologie |
|--------|-------------|
| Backend | Node.js + TypeScript + Fastify |
| ORM | Prisma |
| BDD | PostgreSQL |
| Cache/Queue | Redis |
| Frontend | React 19 + TypeScript + Vite |
| Tests | Vitest (unit) + Playwright (e2e) |
| Infra | Docker Compose (dev) → VPS (prod) |
| Auth | JWT (access + refresh) |

## Architecture

Monolithe modulaire. Chaque domaine = un module isolé. Extraction en services si nécessaire plus tard.

## Principes

- Robuste > large — chaque pilier complet et testé avant le suivant
- TDD obligatoire
- Incrémental — chaque sprint produit du logiciel fonctionnel
- Le joueur ne doit jamais être puni pour ne pas se connecter assez souvent
