# Agriva — V1 Farming Systems

## Objet
Résumé des décisions V1 sur les systèmes agricoles : activités, météo, sols, foncier, territoire, stockage/logistique, transformation, services.

## Activités V1
- V1 : **grandes cultures + élevage + maraîchage**.
- V2+ : viticulture, arboriculture, foresterie, horticulture, aquaculture, transformation avancée.
- Logique : couvrir trois rythmes (long/moyen/court) sans multiplier les systèmes.

## Météo V1
- Granularité : **régionale avec modificateurs locaux**.
- Prévision : **prévision moyenne avec incertitude**.
- Effets : autorise la planification sur quelques jours, avec incertitude croissante ; différencie les grandes zones sans modèle hyper local.

## Sols V1
- Mode normal : indicateurs visibles = **fertilité + humidité**.
- Mode expert : **NPK + MO + pH + historique cultural**.
- Rotations : centrales, mais les détails agronomiques restent surtout visibles en expert.

## Foncier et territoire V1
- Parcelles : abstraites, pas de géométrie complexe, fusion **permanente**.
- Territoire : département + bassins locaux, avec impact sur météo, marchés, logistique, spécialisations.
- Coop bot : une par département (préfecture / capitale départementale).

## Stockage et logistique V1
- Stockage : **contrainte moyenne et structurante**.
- Logistique : **coût + délai**, sans modéliser les flux fins en V1.
- Effet recherché : le territoire et le choix des débouchés ont un vrai poids, sans transformer la logistique en micro-gestion.

## Transformation V1
- V1 : **quelques chaînes simples** (ex. lait → produit standard, céréales → aliment, fruits → jus).
- Rôle : introduire la **valeur ajoutée** sans créer un “jeu dans le jeu”.
- V2+ : filières complexes (qualités, affinage, labels, processus longs).

## Services et prestataires V1
- Services V1 :
  - ETA bot pour travaux de champs (labour, semis, récolte, travaux clés).
  - Services de transport simples via coop bot.
  - Éventuellement insémination standard.
- Services V2+ : prestataires joueurs, conseils avancés, services spécialisés, contrats complexes.
- Présentation :
  - Normal : boutons clairs “Faire intervenir un prestataire” avec coût/délai/effet sur la file.
  - Expert : détails de coûts, capacités, disponibilités territoriales.
