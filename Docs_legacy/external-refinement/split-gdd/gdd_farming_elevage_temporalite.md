# Agriva GDD — Farming — Élevage & Temporalité
> Élevage et temporalité commune, traduction animaux, règles d'équilibrage

---


---

# La temporarilite va devoir être utilisé pour l’élevage aussi

Oui, et c’est exactement pour ça qu’il faut définir une **temporalité unifiée du monde**, pas juste un calendrier pour les cultures. Dans Agriva, la même échelle de temps doit servir aux cultures, à l’élevage, aux travaux, à l’économie et à la reproduction, sinon le jeu devient incohérent ou impossible à équilibrer.[^22_1][^22_2][^22_3]

## Point clé

L’élevage supporte généralement **encore moins bien** des durées trop longues que les cultures, parce que le joueur attend des retours plus réguliers : production, reproduction, croissance, ventes, soins, alimentation. Les références autour des systèmes animaux dans Farming Simulator montrent que la production et la reproduction sont suivies en cycles mensuels ou quasi mensuels, avec des états comme âge, puberté, reproduction, naissance, lactation et productivité.[^22_4][^22_5][^22_6][^22_7]

## Conséquence design

Donc la bonne question n’est plus seulement “combien dure une culture ?”, mais :

- combien dure un **cycle de culture** ;
- combien dure un **cycle animal** ;
- combien de temps met un joueur à voir un **retour économique** ;
- et est-ce que ces rythmes cohabitent bien dans la même économie.

Les modèles dynamiques de troupeau travaillent justement avec des transitions mensuelles d’état, ce qui est un bon indice pour le design d’un jeu de gestion agricole : le mois de jeu est une unité très pratique pour faire évoluer à la fois cultures et animaux.[^22_1]

## Bonne règle pour Agriva

Je vous recommande donc de garder une temporalité qui fonctionne pour les deux mondes :

- culture = progression par stades mensuels ;
- élevage = progression par états mensuels ;
- économie = flux quotidiens et bilans mensuels ;
- serveur = saisons assez courtes pour générer de la rotation.

Cela renforce l’idée qu’**un mois de jeu doit être l’unité pivot** du système.[^22_2][^22_1]

## Mon avis sur la bonne échelle

Pour que ça marche à la fois pour cultures et élevage, je pense que votre meilleure base devient :

- **1 mois de jeu = 4 jours réels**.
- **1 saison = 3 mois = 12 jours réels**.
- **1 année = 48 jours réels**.

Pourquoi ? Parce que :

- une culture courte peut durer 1 à 2 mois, donc 4 à 8 jours ;
- une culture moyenne 3 à 4 mois, donc 12 à 16 jours ;
- un événement animal important, mise bas, montée en production, sevrage, croissance, peut arriver toutes les 1 à 3 semaines de temps réel selon l’espèce ;
- l’économie du joueur bouge régulièrement.

Cette cadence est bien plus exploitable qu’un système où une gestation ou une croissance animale durerait trop longtemps en temps réel.[^22_5][^22_6][^22_7][^22_4]

## Traduction élevage

Avec cette logique, vous pouvez ensuite remapper les animaux ainsi :

- **volailles** : cycles très courts, production quasi quotidienne ;
- **porcs** : croissance et reproduction moyennes ;
- **bovins lait** : production régulière, reproduction plus longue ;
- **bovins viande** : croissance plus lente mais plus rentable à terme.

Les jeux et mods de simulation animale montrent déjà cette logique : tous les animaux n’ont pas la même vitesse de retour, et c’est même une force économique si c’est bien équilibré.[^22_6][^22_8][^22_7][^22_5]

## Règle d’équilibrage

Je vous propose cette règle fondatrice :

**Chaque atelier doit produire un retour économique visible dans une fenêtre de 2 à 8 jours réels, mais avec des amplitudes différentes.**

Par exemple :

- œufs / lait : retour très fréquent ;
- cultures rapides : retour fréquent ;
- cultures longues : retour plus espacé mais plus gros ;
- reproduction bovine : retour rare mais structurant.

C’est cela qui fera respirer l’économie globale du serveur.[^22_3][^22_1]

## Ce qu’il faut éviter

- des gestations ou croissances animales trop longues ;
- des cultures longues sans revenus intermédiaires ;
- un début de partie où tout est bloqué pendant 2 semaines ;
- des ateliers qui ne produisent rien à court terme.


## Étape suivante

La suite logique est de définir un **cadre de temporalité global Agriva**, avec :

- 1 mois de jeu ;
- durée type des cultures ;
- durée type des cycles animaux ;
- fréquence des revenus ;
- fréquence des dépenses.
<span style="display:none">[^22_10][^22_11][^22_12][^22_13][^22_14][^22_15][^22_9]</span>

<div align="center">⁂</div>

[^22_1]: https://www.fao.org/4/x5528e/x5528e03.htm

[^22_2]: https://www.reddit.com/r/farmingsimulator/comments/1kw7l44/is_crop_growth_and_livestock_production_based_on/

[^22_3]: https://agromixproject.eu/knowledge/dynamix-a-serious-game-to-design-scenarios-of-exchange-of-animal-or-crop-co-roducts-between-farmers/

[^22_4]: https://www.youtube.com/watch?v=mjNvSyV6wnE

[^22_5]: https://www.ign.com/wikis/farming-simulator-22/How_to_Manage_Animals_-_Storing,_Feeding,_and_Breeding_Guide

[^22_6]: https://fs17.lt/enhanced-animal-system-v-2-2-1-1/

[^22_7]: https://www.farming-simulator.com/mod.php?mod_id=259964

[^22_8]: https://forum.giants-software.com/viewtopic.php?t=47726

[^22_9]: https://www.youtube.com/watch?v=clFGFaDLb88

[^22_10]: https://en.wikipedia.org/wiki/Farming_Simulator

[^22_11]: https://farmingsimulator25mods.com/enhanced-livestock-v1-1/

[^22_12]: https://academic.oup.com/af/article/7/3/5/4616839

[^22_13]: https://ruminants.ceva.pro/calving

[^22_14]: https://www.youtube.com/watch?v=LsNrVH6PSnc

[^22_15]: https://play.google.com/store/apps/details?id=com.whatme.farm.management\&hl=ln


---

# Et dans simagri qu’elle se le temps pour dj blé ?

Dans **SimAgri**, le **blé** (comme la plupart des céréales d’hiver) suit un cycle classique de **blé d’hiver** qui dure environ **8 à 9 mois de jeu**.[^23_1][^23_2][^23_3][^23_4]

## Temporalité SimAgri
