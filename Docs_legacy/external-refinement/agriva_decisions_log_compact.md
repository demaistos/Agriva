# Agriva — Décisions V1 (compact)

> Référence rapide. Source complète : agriva_decisions_log.md

| Domaine | Décision figée |
|---------|---------------|
| Économie | Joueur dominant + bot filet de sécurité (jamais arbitrage profitable) |
| Activités V1 | Grandes cultures + élevage + maraîchage (V2+ : viti, arbori, forêt…) |
| UI densité | Synthétique avec détails sur demande |
| Progression | Agrandissement → spécialisation → diversification (progressif) |
| Normal/Expert | Bascule par système ; profil global = preset |
| Sols normal | Fertilité + humidité |
| Sols expert | NPK + MO + pH + historique cultural |
| Météo | Régionale + modificateurs locaux ; prévision avec incertitude |
| Foncier | Parcelles abstraites, fusion permanente, territoire départemental |
| Stockage | Contrainte moyenne structurante |
| Logistique | Coût + délai uniquement (flux fins = V2+) |
| Transformation | Quelques chaînes simples en V1 |
| Services | ETA bot + transport coop (prestataires joueurs = V2+) |
| Difficulté | Presets facile/standard/exigeant sur les amortisseurs, pas les règles |
| Classements | Segmentés mode × activité ; récompenses cosmétiques uniquement |
| Succès | Quelques jalons principaux, cosmétiques uniquement |
| Social | Messagerie limitée, pas de chat global |
| Modes | Mode principal uniquement en V1 |
| Market price | Spread bot + tag d'origine + rendements décroissants |
| Events | Motivation secondaire ; concours/défis ; impact léger ; calendrier fixe |
| Compétitions | Classements saisonniers mode×activité, métriques perf, cosmétiques |
| Prestataires (détail) | ETA bot + transport coop + insémination standard ; prestataires joueurs = V2+ |
| Activités (détail) | Grandes cultures : blé/orge/colza/maïs/tournesol/betterave ; Élevage : bovins lait/viande, ovins, porcins, **volailles** |
| Météo (détail) | 6 régions ; fiabilité J+1=haute, J+3=moyenne, J+7=faible |
| Sols (détail) | Normal : fertilité+humidité (0–100) ; Expert : N+P+K+MO+pH+historique+compaction ; rotation bonus +5/+15 ; malus monoculture -10% rendement si même culture 2 ans consécutifs |
| Transformation (détail) | 3 chaînes : lait→laiterie, céréales→meunerie, légumes→conserverie ; +20–40% valeur, bâtiment requis |
| Temporalité | 1 mois = 5j réels ; 1 saison = 15j ; 1 année = 60j réels |
| Saison compétitive | 1 saison de jeu = 15j réels |
| Activité dominante | ≥60% revenu brut sur 2 dernières saisons ; sinon = mixte |
| Score classement | Revenu net 40% + Marge nette 25% + Diversification 15% + % ventes hors bot 20% |
| MAJ classement | Quotidienne (fin de journée in-game) |
| Durées cultures | Courte 2 mois, Moyenne 3-4 mois, Longue 5-6 mois, Très longue 7-10 mois (blé/colza d'hiver) |
| Classements (définitif) | 8 classements : 2 modes × 4 activités (GC, élevage, maraîchage, mixte) |
| Succès (liste unique) | 20 succès — référence : economy-markets-v1.md §5 |
| Foncier | Achat + location ; marché local ; regroupement blocs V1 ; fusion physique avec coût |
| Carte France | Région → département → ville ; 6-8 macro-régions agroclimatiques |
| Action economy | Pas d'énergie abstraite ; file d'ordres 3 actions ; décisions immédiates, opérations temporisées |
| Normal/Expert prod. | Normal = stable ; Expert = variance + plafond maîtrise ; pas de multiplicateur automatique |
| Spread bot (précision) | 15-25% minimum (correction tech-liveops §3) |
| Échelle fertilité | 0-100 entier (correction farming §4 float→int) |

## Boucle de jeu

Observer → Évaluer → Planifier → Réserver → Exécuter → Vendre/Acheter → Investir → Progresser

## Règle fondamentale

Toute proposition doit : créer une vraie décision · renforcer la boucle · rester lisible en normal · pouvoir être détaillée en expert.
