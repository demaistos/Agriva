# Agriva — Catalogue des cultures V1
> Date : 2026-05-07
> Statut : **Figé V1**
> Temporalité : 1 mois = 5j réels · 1 saison = 15j réels · 1 année = 60j réels
> Référence : farming-systems-v1.md · gdd_farming_logique_culturale.md · agriva_decisions_log_compact.md

---

## Sommaire

1. [Blé d'hiver](#blé-dhiver)
2. [Orge d'hiver](#orge-dhiver)
3. [Colza](#colza)
4. [Maïs](#maïs)
5. [Tournesol](#tournesol)
6. [Betterave sucrière](#betterave-sucrière)
7. [Orge de printemps](#orge-de-printemps)
8. [Soja](#soja)
9. [Carotte](#carotte)
10. [Haricot vert](#haricot-vert)
11. [Salade](#salade)

---

## Blé d'hiver

### Identité
- Famille : céréale
- Activité : grandes cultures
- Durée : 9 mois de jeu = 45 jours réels
- Fenêtre semis : octobre–novembre (mois 10–11)
- Fenêtre récolte : juillet–août (mois 7–8)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 7,5 t/ha | [4,0–10,0] | Mode Normal ; référence Beauce |
| prix_bot_achat | 180 €/t | [140–220] | Prix plancher bot (spread 15–25 %) |
| prix_marche_ref | 210 €/t | [160–280] | Référence marché joueur |
| besoin_eau | 8 pts/semaine | — | Stress hydrique si < seuil |
| besoin_fertilite | 60 pts/cycle | — | Prélèvement total sur la parcelle |
| sensibilite_meteo | moyenne | — | Gel levée critique ; pluie récolte bloquante |
| degradation_stock | 0,1 pts/jour | — | Silo céréales ; très lente |

### Matériel requis
- Semis : tracteur 100+ ch + semoir combiné
- Récolte : moissonneuse-batteuse + benne céréales

### Rotations
- Bon précédent : colza, tournesol, légumineuses (soja, pois) → bonus +10 % rendement
- Mauvais précédent : orge d'hiver, triticale → neutre
- Mauvais précédent : blé d'hiver → malus -10 %
- Monoculture 2 ans : -10 % rendement (règle générale V1)

### Régions favorables
- R2 (Bassin parisien) : +15 % rendement
- R3 (Nord) : +10 % rendement
- R4 (Atlantique) : 0 % (référence)
- R1 (Grand Ouest) : -10 % rendement
- R6 (Montagne) : -20 % rendement

### Mode Normal vs Expert
- Normal : fertilité (barre) + humidité (barre) · alerte fenêtre semis · fourchette rendement estimée (t/ha)
- Expert : N/P/K détaillé + MO + pH · décomposition facteurs rendement · calendrier stades phénologiques · probabilité gel levée par région

---

## Orge d'hiver

### Identité
- Famille : céréale
- Activité : grandes cultures
- Durée : 8 mois de jeu = 40 jours réels
- Fenêtre semis : octobre–novembre (mois 10–11)
- Fenêtre récolte : juin–juillet (mois 6–7)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 6,5 t/ha | [3,5–9,0] | Mode Normal |
| prix_bot_achat | 160 €/t | [125–200] | Prix plancher bot |
| prix_marche_ref | 190 €/t | [145–250] | Référence marché joueur |
| besoin_eau | 7 pts/semaine | — | Légèrement moins exigeant que blé |
| besoin_fertilite | 50 pts/cycle | — | |
| sensibilite_meteo | moyenne | — | Sensible gel tardif à épiaison |
| degradation_stock | 0,1 pts/jour | — | Silo céréales |

### Matériel requis
- Semis : tracteur 100+ ch + semoir combiné
- Récolte : moissonneuse-batteuse + benne céréales

### Rotations
- Bon précédent : colza, tournesol, légumineuses → bonus +10 %
- Mauvais précédent : blé d'hiver → malus -8 %
- Mauvais précédent : orge d'hiver → malus -10 %
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R2 (Bassin parisien) : +12 % rendement
- R3 (Nord) : +8 % rendement
- R5 (Est) : +5 % rendement
- R1 (Grand Ouest) : -5 % rendement
- R6 (Montagne) : -15 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte fenêtre semis · fourchette rendement
- Expert : NPK + MO + pH · risque gel épiaison par région · décomposition facteurs rendement · comparaison orge brassicole vs fourragère (qualité)


---

## Colza

### Identité
- Famille : oléagineux
- Activité : grandes cultures
- Durée : 10 mois de jeu = 50 jours réels
- Fenêtre semis : août–septembre (mois 8–9)
- Fenêtre récolte : juin–juillet (mois 6–7)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 3,5 t/ha | [1,8–5,0] | Mode Normal |
| prix_bot_achat | 430 €/t | [300–520] | Prix plancher bot |
| prix_marche_ref | 490 €/t | [420–600] | Référence marché joueur |
| besoin_eau | 9 pts/semaine | — | Sensible sécheresse automne |
| besoin_fertilite | 70 pts/cycle | — | Fort besoin en azote |
| sensibilite_meteo | forte | — | Gel hivernal critique ; verse possible |
| degradation_stock | 0,1 pts/jour | — | Silo céréales / entrepôt sec |

### Matériel requis
- Semis : tracteur 100+ ch + semoir de précision (petites graines)
- Récolte : moissonneuse-batteuse + coupe colza adaptée + benne

### Rotations
- Bon précédent : blé, orge, maïs → bonus +8 %
- Mauvais précédent : colza, tournesol, betterave → malus -15 % (sclérotinia)
- Monoculture 2 ans : -10 % rendement + risque maladie accru
- Note : retour colza recommandé minimum tous les 4 ans en agronomie française

### Régions favorables
- R2 (Bassin parisien) : +15 % rendement
- R3 (Nord) : +10 % rendement
- R4 (Atlantique) : +5 % rendement
- R1 (Grand Ouest) : -15 % rendement (sécheresse estivale)
- R6 (Montagne) : -25 % rendement (gel)

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte gel hivernal · fourchette rendement
- Expert : NPK + MO · risque sclérotinia lié à l'historique · stade vernalisation · décomposition facteurs rendement · alerte verse

---

## Maïs

### Identité
- Famille : céréale
- Activité : grandes cultures
- Durée : 5 mois de jeu = 25 jours réels
- Fenêtre semis : avril–mai (mois 4–5)
- Fenêtre récolte : septembre–octobre (mois 9–10)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 9,0 t/ha | [5,0–13,0] | Mode Normal ; maïs grain |
| prix_bot_achat | 190 €/t | [130–230] | Prix plancher bot |
| prix_marche_ref | 220 €/t | [180–270] | Référence marché joueur |
| besoin_eau | 14 pts/semaine | — | Très exigeant en eau (floraison critique) |
| besoin_fertilite | 80 pts/cycle | — | Fort besoin azote |
| sensibilite_meteo | forte | — | Sécheresse floraison = -30 à -50 % |
| degradation_stock | 0,1 pts/jour | — | Silo céréales |

### Matériel requis
- Semis : tracteur 120+ ch + semoir monograine
- Récolte : moissonneuse-batteuse + tête maïs + benne céréales

### Rotations
- Bon précédent : soja, pois, colza → bonus +10 %
- Bon précédent : blé, orge → neutre
- Mauvais précédent : maïs → malus -10 % (pyrale, fusariose)
- Monoculture 2 ans : -10 % rendement + pression ravageurs accrue

### Régions favorables
- R1 (Grand Ouest) : +10 % rendement (chaleur, ensoleillement)
- R4 (Atlantique / Sud-Ouest) : +15 % rendement
- R2 (Bassin parisien) : +5 % rendement (avec irrigation)
- R3 (Nord) : -10 % rendement (sommes de chaleur insuffisantes)
- R6 (Montagne) : -30 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte stress hydrique floraison · fourchette rendement
- Expert : NPK + MO · sommes de chaleur cumulées · stade floraison détaillé · risque pyrale/fusariose · décomposition facteurs rendement


---

## Tournesol

### Identité
- Famille : oléagineux
- Activité : grandes cultures
- Durée : 5 mois de jeu = 25 jours réels
- Fenêtre semis : avril–mai (mois 4–5)
- Fenêtre récolte : septembre–octobre (mois 9–10)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 2,5 t/ha | [1,2–3,8] | Mode Normal |
| prix_bot_achat | 460 €/t | [350–560] | Prix plancher bot |
| prix_marche_ref | 530 €/t | [450–640] | Référence marché joueur |
| besoin_eau | 8 pts/semaine | — | Résistant à la sécheresse modérée |
| besoin_fertilite | 40 pts/cycle | — | Peu exigeant en azote |
| sensibilite_meteo | faible | — | Tolérant sécheresse ; sensible verse |
| degradation_stock | 0,1 pts/jour | — | Entrepôt sec |

### Matériel requis
- Semis : tracteur 100+ ch + semoir monograine
- Récolte : moissonneuse-batteuse + tête tournesol + benne

### Rotations
- Bon précédent : blé, orge, maïs → bonus +8 %
- Mauvais précédent : colza, tournesol → malus -12 % (sclérotinia commun)
- Mauvais précédent : betterave → malus -8 %
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R1 (Grand Ouest) : +15 % rendement
- R4 (Atlantique / Sud-Ouest) : +20 % rendement
- R2 (Bassin parisien) : 0 % (référence)
- R3 (Nord) : -15 % rendement
- R6 (Montagne) : -30 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · fourchette rendement · alerte verse
- Expert : NPK + MO · risque sclérotinia lié à l'historique · stade floraison · décomposition facteurs rendement

---

## Betterave sucrière

### Identité
- Famille : racine industrielle
- Activité : grandes cultures
- Durée : 7 mois de jeu = 35 jours réels
- Fenêtre semis : mars–avril (mois 3–4)
- Fenêtre récolte : septembre–novembre (mois 9–11)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 80 t/ha | [50–110] | Mode Normal ; tonnes de racines fraîches |
| prix_bot_achat | 32 €/t | [22–39] | Prix plancher bot (prix sucre industriel) |
| prix_marche_ref | 38 €/t | [30–50] | Référence marché joueur |
| besoin_eau | 10 pts/semaine | — | Sensible sécheresse été |
| besoin_fertilite | 90 pts/cycle | — | Très exigeant (N+K élevés) |
| sensibilite_meteo | moyenne | — | Gel printanier semis critique |
| degradation_stock | 2,0 pts/jour | — | Produit frais ; livraison rapide requise |

### Matériel requis
- Semis : tracteur 120+ ch + semoir monograine betterave
- Récolte : arracheuse betterave (machine spécialisée) + benne lourde

### Rotations
- Bon précédent : blé, orge, maïs → bonus +8 %
- Mauvais précédent : betterave, colza → malus -15 % (nématodes, rhizomanie)
- Mauvais précédent : tournesol → malus -8 %
- Monoculture 2 ans : -10 % rendement + risque nématodes élevé
- Note : retour betterave recommandé minimum tous les 3 ans

### Régions favorables
- R2 (Bassin parisien) : +20 % rendement
- R3 (Nord) : +25 % rendement (zone historique betteravière)
- R5 (Est) : +10 % rendement
- R1 (Grand Ouest) : -20 % rendement
- R6 (Montagne) : culture impossible (hors scope V1)

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte livraison rapide (dégradation stock) · fourchette rendement
- Expert : NPK + K détaillé + MO · teneur en sucre estimée · risque nématodes lié à l'historique · décomposition facteurs rendement


---

## Orge de printemps

### Identité
- Famille : céréale
- Activité : grandes cultures
- Durée : 4 mois de jeu = 20 jours réels
- Fenêtre semis : mars–avril (mois 3–4)
- Fenêtre récolte : juillet–août (mois 7–8)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 5,5 t/ha | [3,0–7,5] | Mode Normal |
| prix_bot_achat | 165 €/t | [130–205] | Prix plancher bot ; prime brassicole possible |
| prix_marche_ref | 195 €/t | [150–250] | Référence marché joueur |
| besoin_eau | 7 pts/semaine | — | Cycle court = moins d'exposition |
| besoin_fertilite | 45 pts/cycle | — | |
| sensibilite_meteo | faible | — | Cycle court réduit les risques |
| degradation_stock | 0,1 pts/jour | — | Silo céréales |

### Matériel requis
- Semis : tracteur 100+ ch + semoir combiné
- Récolte : moissonneuse-batteuse + benne céréales

### Rotations
- Bon précédent : colza, tournesol, légumineuses → bonus +10 %
- Bon précédent : blé d'hiver → neutre (bon précédent classique)
- Mauvais précédent : orge d'hiver, orge de printemps → malus -10 %
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R2 (Bassin parisien) : +10 % rendement
- R3 (Nord) : +12 % rendement
- R5 (Est) : +8 % rendement
- R1 (Grand Ouest) : -8 % rendement
- R6 (Montagne) : -10 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · fourchette rendement · alerte fenêtre semis printanier
- Expert : NPK + MO · qualité brassicole (teneur protéines) · décomposition facteurs rendement

---

## Soja

### Identité
- Famille : légumineuse
- Activité : grandes cultures
- Durée : 5 mois de jeu = 25 jours réels
- Fenêtre semis : mai (mois 5)
- Fenêtre récolte : septembre–octobre (mois 9–10)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 3,0 t/ha | [1,5–4,5] | Mode Normal |
| prix_bot_achat | 380 €/t | [300–480] | Prix plancher bot |
| prix_marche_ref | 440 €/t | [340–560] | Référence marché joueur |
| besoin_eau | 10 pts/semaine | — | Sensible sécheresse floraison |
| besoin_fertilite | 20 pts/cycle | — | Fixation N symbiotique (légumineuse) |
| sensibilite_meteo | moyenne | — | Sensible gel tardif ; besoin chaleur |
| degradation_stock | 0,1 pts/jour | — | Entrepôt sec |

### Matériel requis
- Semis : tracteur 100+ ch + semoir monograine ou combiné
- Récolte : moissonneuse-batteuse + coupe adaptée (hauteur basse) + benne

### Rotations
- Bon précédent : blé, orge, maïs → bonus +5 % (effet légumineuse sur suivant)
- Effet sur suivant : la culture suivant le soja bénéficie de +10 % fertilité (fixation N)
- Mauvais précédent : soja → malus -12 % (sclérotinia, nématodes)
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R1 (Grand Ouest) : +15 % rendement
- R4 (Atlantique / Sud-Ouest) : +20 % rendement
- R2 (Bassin parisien) : 0 % (référence)
- R3 (Nord) : -20 % rendement (sommes de chaleur insuffisantes)
- R6 (Montagne) : culture déconseillée (-35 %)

### Mode Normal vs Expert
- Normal : fertilité + humidité · fourchette rendement · bonus fertilité pour culture suivante affiché
- Expert : NPK + MO · fixation N quantifiée · risque sclérotinia · sommes de chaleur · décomposition facteurs rendement


---

## Carotte

### Identité
- Famille : légume (ombellifère)
- Activité : maraîchage
- Durée : 3 mois de jeu = 15 jours réels
- Fenêtre semis : mars–juin (mois 3–6) ; possible août–septembre pour récolte automnale
- Fenêtre récolte : juin–novembre (mois 6–11) selon date de semis

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 40 t/ha | [20–60] | Mode Normal ; en kg/m² : 4 kg/m² |
| prix_bot_achat | 280 €/t | [200–380] | Prix plancher bot |
| prix_marche_ref | 380 €/t | [260–520] | Référence marché joueur |
| besoin_eau | 6 pts/semaine | — | Régulier ; irrégularité = racines fourchues |
| besoin_fertilite | 30 pts/cycle | — | Sol meuble requis (pas trop riche en N) |
| sensibilite_meteo | faible | — | Tolère froid modéré ; gel fort destructeur |
| degradation_stock | 1,5 pts/jour | — | Chambre froide recommandée |

### Matériel requis
- Semis : micro-tracteur ou tracteur léger + semoir maraîcher
- Récolte : arracheuse à carottes (ou récolte manuelle sur petites surfaces)

### Rotations
- Bon précédent : légumineuses (haricot, pois), salade → bonus +8 %
- Mauvais précédent : carotte, panais, céleri (ombellifères) → malus -12 % (nématodes, alternariose)
- Mauvais précédent : betterave → malus -8 %
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R2 (Bassin parisien) : +10 % rendement
- R3 (Nord) : +8 % rendement
- R4 (Atlantique) : +5 % rendement
- R1 (Grand Ouest) : -5 % rendement (chaleur excessive)
- R6 (Montagne) : -15 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte irrégularité hydrique · jours avant récolte · alerte dégradation stock
- Expert : NPK + MO · texture sol (impact racines fourchues) · risque nématodes · décomposition facteurs rendement · taux de dégradation stock journalier

---

## Haricot vert

### Identité
- Famille : légumineuse (légume)
- Activité : maraîchage
- Durée : 2 mois de jeu = 10 jours réels
- Fenêtre semis : mai–juillet (mois 5–7)
- Fenêtre récolte : juillet–septembre (mois 7–9)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 8 t/ha | [4–14] | Mode Normal |
| prix_bot_achat | 600 €/t | [450–800] | Prix plancher bot |
| prix_marche_ref | 800 €/t | [580–1 100] | Référence marché joueur |
| besoin_eau | 8 pts/semaine | — | Sensible sécheresse floraison |
| besoin_fertilite | 20 pts/cycle | — | Légumineuse : fixation N partielle |
| sensibilite_meteo | forte | — | Gel = destruction totale ; grêle destructeur |
| degradation_stock | 4,0 pts/jour | — | Très périssable ; vente sous 2–3 jours |

### Matériel requis
- Semis : micro-tracteur + semoir maraîcher (ou semis manuel)
- Récolte : récolte manuelle (V1) ou effileuse tractée sur grandes surfaces

### Rotations
- Bon précédent : salade, carotte, céréales → bonus +8 %
- Effet sur suivant : +8 % fertilité pour la culture suivante (fixation N)
- Mauvais précédent : haricot, pois, fève (légumineuses) → malus -10 %
- Monoculture 2 ans : -10 % rendement

### Régions favorables
- R1 (Grand Ouest) : +10 % rendement
- R4 (Atlantique) : +8 % rendement
- R2 (Bassin parisien) : 0 % (référence)
- R3 (Nord) : -10 % rendement
- R6 (Montagne) : -20 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte gel · jours avant récolte · alerte dégradation stock (urgence vente)
- Expert : NPK + MO · fixation N quantifiée · risque maladies fongiques (humidité) · décomposition facteurs rendement · taux dégradation journalier

---

## Salade

### Identité
- Famille : légume (composée)
- Activité : maraîchage
- Durée : 2 mois de jeu = 10 jours réels
- Fenêtre semis : mars–août (mois 3–8) ; plusieurs cycles possibles par saison
- Fenêtre récolte : mai–octobre (mois 5–10)

### Paramètres de simulation
| Variable | Valeur nominale | Range | Notes |
|----------|----------------|-------|-------|
| rendement_base | 25 t/ha | [12–40] | Mode Normal |
| prix_bot_achat | 500 €/t | [350–700] | Prix plancher bot |
| prix_marche_ref | 700 €/t | [480–1 000] | Référence marché joueur |
| besoin_eau | 10 pts/semaine | — | Très sensible à l'irrégularité hydrique |
| besoin_fertilite | 25 pts/cycle | — | Cycle court = prélèvement rapide |
| sensibilite_meteo | forte | — | Gel = destruction ; montaison chaleur |
| degradation_stock | 5,0 pts/jour | — | Très périssable ; vente sous 1–2 jours |

### Matériel requis
- Semis/repiquage : travail manuel ou micro-tracteur + planteuse maraîchère
- Récolte : récolte manuelle

### Rotations
- Bon précédent : légumineuses (haricot, pois) → bonus +10 %
- Bon précédent : carotte → bonus +5 %
- Mauvais précédent : salade, chicorée (composées) → malus -10 % (sclérotinia, botrytis)
- Monoculture 2 ans : -10 % rendement
- Note : culture idéale pour rotation rapide intra-annuelle (2–3 cycles/an possibles)

### Régions favorables
- R4 (Atlantique) : +10 % rendement (douceur)
- R1 (Grand Ouest) : +5 % rendement (printemps/automne) ; risque montaison été
- R2 (Bassin parisien) : 0 % (référence)
- R3 (Nord) : -5 % rendement
- R6 (Montagne) : -15 % rendement

### Mode Normal vs Expert
- Normal : fertilité + humidité · alerte gel · jours avant récolte · alerte dégradation stock (urgence critique)
- Expert : NPK + MO · risque montaison (température) · risque botrytis/sclérotinia (humidité) · décomposition facteurs rendement · taux dégradation journalier

---

## Annexe — Récapitulatif des cultures V1

| Culture | Famille | Durée (mois jeu) | Durée (j réels) | Rendement base | Prix marché ref |
|---------|---------|-----------------|-----------------|----------------|-----------------|
| Blé d'hiver | Céréale | 9 | 45 | 7,5 t/ha | 210 €/t |
| Orge d'hiver | Céréale | 8 | 40 | 6,5 t/ha | 190 €/t |
| Colza | Oléagineux | 10 | 50 | 3,5 t/ha | 490 €/t |
| Maïs | Céréale | 5 | 25 | 9,0 t/ha | 220 €/t |
| Tournesol | Oléagineux | 5 | 25 | 2,5 t/ha | 530 €/t |
| Betterave sucrière | Racine industrielle | 7 | 35 | 80 t/ha | 38 €/t |
| Orge de printemps | Céréale | 4 | 20 | 5,5 t/ha | 195 €/t |
| Soja | Légumineuse | 5 | 25 | 3,0 t/ha | 440 €/t |
| Carotte | Légume | 3 | 15 | 40 t/ha | 380 €/t |
| Haricot vert | Légumineuse (légume) | 2 | 10 | 8 t/ha | 800 €/t |
| Salade | Légume | 2 | 10 | 25 t/ha | 700 €/t |

### Règles transversales rappelées
- **Monoculture 2 ans** : -10 % rendement pour toutes les cultures (règle V1 universelle)
- **Spread bot** : 15–25 % minimum entre `prix_bot_achat` et `prix_marche_ref`
- **Dégradation stock** : céréales/oléagineux = très lente (silo) ; légumes frais = rapide (chambre froide requise)
- **Mode Normal** : fertilité (0–100) + humidité (0–100) visibles ; indicateurs agrégés
- **Mode Expert** : N + P + K + MO + pH + historique cultural + compaction visibles
