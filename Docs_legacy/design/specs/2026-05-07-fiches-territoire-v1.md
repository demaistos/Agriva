# Fiches Territoire Agriva V1

**Version** : 1.0  
**Date** : 2026-05-07  
**Auteur** : Farming Systems Designer  
**Statut** : Validé V1  
**Sources** : `gdd_territoire_carte_france.md`, `2026-05-07-territoire-foncier-v1.md §1`

---

## R1 — Grand Ouest (Bretagne, Normandie, Pays de la Loire)

### Profil climatique
- Température moyenne : 11–13 °C
- Précipitations : 700–900 mm/an (jusqu'à 1 100 mm en Finistère)
- Risques météo principaux : excès d'eau printanier, vents forts côtiers, gel tardif rare, automne très pluvieux bloquant les chantiers
- Fenêtres de travail : larges au printemps (mars–mai) et en été (juin–août) ; automne souvent contraint par humidité sol (octobre–novembre) ; hiver doux mais sols portants limités

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Maïs grain/ensilage | +10 % | mi-avril – mi-mai | sept.–oct. |
| Blé tendre | +8 % | oct.–nov. | juil. |
| Colza | +8 % | fin août – mi-sept. | juil. |
| Prairies permanentes | +15 % (production herbe) | — | pâture continue + 3–4 coupes/an |
| Maïs fourrage | +12 % | mi-avril – mi-mai | sept. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Bovins lait | +12 % lait | Coût démarrage −15 % ; herbe abondante réduit coût alimentation |
| Porcs (naisseur-engraisseur) | +8 % GMQ | Filière intégrée dense ; débouchés abattoirs locaux |
| Volailles (poulet, dinde) | +8 % GMQ | Bâtiments standards ; filière LDC/Doux présente |
| Bovins allaitants | +5 % GMQ | Bocage favorable ; race Charolaise/Limousine possible |

### Spécialités locales (V1)
- **Lait de vache** : prix de collecte +5 % vs prix national de référence (filière Lactalis/Sodiaal dense)
- **Porc charcutier** : débouché abattoir garanti dans le département (pas de pénalité logistique vente)
- **Maïs ensilage** : contrat coopérative disponible dès l'année 1

> V2+ : Cidre/calvados (Normandie), volaille Label Rouge fermière, lin textile (Normandie), chou-fleur/artichaut (Bretagne)

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 5 000–8 000 €/ha |
| disponibilite_foncier | abondante (0.65) |
| difficulte_preset | facile |
| modificateur_meteo_risque | +10 % (excès eau automne) |
| bonus_culture_principale | +15 % rendement (prairies/maïs) |

---

## R2 — Bassin parisien (Île-de-France, Centre, Champagne)

### Profil climatique
- Température moyenne : 10–12 °C
- Précipitations : 550–700 mm/an (répartition régulière, été légèrement déficitaire)
- Risques météo principaux : sécheresse estivale modérée, gel de printemps (avril), orages de grêle (juin–juillet), excès eau rare
- Fenêtres de travail : excellentes au printemps (mars–mai) et automne (sept.–oct.) ; été sec favorable aux récoltes ; hiver froid mais sols portants corrects

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Blé tendre | +15 % | oct.–nov. | juil. |
| Betterave sucrière | +15 % | mars–avril | sept.–nov. |
| Colza | +12 % | fin août – mi-sept. | juil. |
| Orge d'hiver | +10 % | oct.–nov. | juin–juil. |
| Pois protéagineux | +8 % | févr.–mars | juil. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Bovins viande (extensif) | +5 % GMQ | Pâtures de bordure ; race Charolaise |
| Ovins viande | +5 % GMQ | Prairies temporaires en rotation |

> Note : l'élevage est secondaire dans cette région ; aucun atelier ne bénéficie du bonus −15 % démarrage natif.

### Spécialités locales (V1)
- **Blé tendre meunier** : contrat meunerie disponible avec prime qualité +8 % si PS ≥ 76 et protéines ≥ 11 %
- **Betterave sucrière** : contrat sucrier obligatoire (quota tonnes/ha) ; prix garanti sur 3 ans
- **Colza** : contrat trituration coopérative disponible dès l'année 1

> V2+ : Champagne viticole (Marne), moutarde de Bourgogne, endive (sous-région Nord du bassin)

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 7 000–12 000 €/ha |
| disponibilite_foncier | normale (0.40) |
| difficulte_preset | facile |
| modificateur_meteo_risque | +8 % (grêle estivale) |
| bonus_culture_principale | +15 % rendement (blé/betterave) |

---

## R3 — Nord/Nord-Est (Hauts-de-France, Grand Est)

### Profil climatique
- Température moyenne : 9–11 °C
- Précipitations : 600–800 mm/an (plus élevé en Ardennes/Vosges, plus sec en Champagne crayeuse)
- Risques météo principaux : hivers froids avec gel prolongé (−10 °C possible), printemps tardif, excès eau automne (Hauts-de-France), sécheresse estivale (Grand Est continental)
- Fenêtres de travail : printemps court mais intense (avril–mai) ; été favorable aux récoltes ; automne correct (sept.–oct.) ; hiver contraignant (nov.–mars)

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Blé tendre | +12 % | oct.–nov. | juil. |
| Betterave sucrière | +15 % | mars–avril | sept.–nov. |
| Pomme de terre | +15 % | avril–mai | août–oct. |
| Orge brassicole | +12 % | oct.–nov. (hiver) / mars (printemps) | juin–juil. |
| Colza | +8 % | fin août – mi-sept. | juil. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Bovins lait | +8 % lait | Coût démarrage −15 % ; race Prim'Holstein |
| Porcs | +8 % GMQ | Filière abattage présente (Hauts-de-France) |

### Spécialités locales (V1)
- **Pomme de terre de consommation** : contrat négoce disponible ; prime +10 % si calibre A/B garanti
- **Betterave sucrière** : contrat sucrier (Tereos/Cristal Union) ; prix garanti
- **Orge brassicole** : contrat malterie disponible avec prime qualité +12 % si teneur protéines ≤ 11.5 %

> V2+ : Chicorée à café (Nord), endive (Nord), houblon (Alsace), bière artisanale, choucroute (Alsace)

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 6 000–10 000 €/ha |
| disponibilite_foncier | normale (0.45) |
| difficulte_preset | standard |
| modificateur_meteo_risque | +15 % (gel hivernal + excès eau) |
| bonus_culture_principale | +15 % rendement (betterave/pomme de terre) |

---

## R4 — Sud-Ouest (Nouvelle-Aquitaine, Occitanie ouest)

### Profil climatique
- Température moyenne : 13–15 °C
- Précipitations : 600–900 mm/an (plus humide côté Pyrénées, plus sec vers Garonne aval)
- Risques météo principaux : sécheresse estivale (juillet–août), orages violents de grêle (mai–juin), gel tardif rare mais possible, canicule
- Fenêtres de travail : très larges (mars–octobre) ; été chaud favorable au maïs irrigué ; hiver doux permettant travaux précoces

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Maïs grain irrigué | +15 % | mi-avril – mi-mai | sept.–oct. |
| Tournesol | +15 % | avril–mai | sept. |
| Soja | +12 % | mai | sept.–oct. |
| Blé tendre | +8 % | nov.–déc. | juil. |
| Sorgho | +10 % | mai–juin | sept.–oct. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Canards (gavage) | +15 % production foie gras | Coût démarrage −15 % ; filière Périgord/Gers |
| Bovins allaitants (Gascon, Blonde d'Aquitaine) | +10 % GMQ | Coût démarrage −15 % ; pâtures extensives |
| Volailles fermières | +8 % GMQ | Label Rouge Landes possible |

### Spécialités locales (V1)
- **Maïs grain** : contrat coopérative (Maïsadour/Arterris) disponible dès l'année 1 ; prix +5 % vs référence nationale
- **Tournesol** : contrat trituration disponible ; prime oléique +15 % si variété HO
- **Canard gras** : débouché conserverie garanti dans le département ; prix foie gras +20 % vs référence

> V2+ : Armagnac, Cognac, pruneaux d'Agen, vins AOC Bordeaux/Cahors, fraises du Périgord, kiwi de l'Adour

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 4 000–7 000 €/ha |
| disponibilite_foncier | abondante (0.60) |
| difficulte_preset | standard |
| modificateur_meteo_risque | +12 % (sécheresse + grêle) |
| bonus_culture_principale | +15 % rendement (maïs irrigué/tournesol) |

---

## R5 — Massif central (Auvergne, Limousin)

### Profil climatique
- Température moyenne : 8–11 °C (forte variation altitudinale : 6–9 °C en altitude, 10–12 °C en plaine)
- Précipitations : 800–1 200 mm/an (plus élevé sur les reliefs exposés ouest)
- Risques météo principaux : gel tardif fréquent (mai), neige printanière possible, sécheresse estivale sur versants sud, orages violents (juin–août), automne précoce
- Fenêtres de travail : courtes et contraintes (mai–septembre en altitude, avril–octobre en plaine) ; printemps tardif ; automne humide

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Prairies permanentes | +15 % (production herbe) | — | pâture + 2–3 coupes/an |
| Seigle | +12 % | sept.–oct. | juil.–août |
| Lentilles vertes | +15 % | mars–avril | juil.–août |
| Orge de printemps | +8 % | mars–avril | juil.–août |
| Triticale | +10 % | oct.–nov. | juil. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Bovins allaitants (Salers, Limousine, Aubrac) | +15 % GMQ | Coût démarrage −15 % ; label Bœuf de Salers/Fin Gras du Mézenc possible |
| Ovins viande (Lacaune, Blanche du Massif central) | +12 % GMQ | Coût démarrage −15 % ; estive possible (V2+) |
| Bovins lait (Salers, Montbéliarde) | +8 % lait | Fromages AOP (Saint-Nectaire, Cantal, Bleu d'Auvergne) |

### Spécialités locales (V1)
- **Lentille verte du Puy** : AOP — prix de vente +30 % vs lentille standard ; disponible uniquement dans les départements Haute-Loire/Puy-de-Dôme
- **Bœuf allaitant** : contrat Label Rouge/IGP disponible ; prime +15 % sur prix vif
- **Lait fromager** : contrat fromagerie AOP disponible (Saint-Nectaire, Cantal) ; prix collecte +10 %

> V2+ : Fromages AOP affinés (Cantal, Saint-Nectaire, Bleu d'Auvergne, Fourme d'Ambert), miel de montagne, gentiane, châtaigne du Limousin

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 2 000–4 500 €/ha |
| disponibilite_foncier | abondante (0.70) |
| difficulte_preset | standard |
| modificateur_meteo_risque | +20 % (gel tardif + fenêtres courtes) |
| bonus_culture_principale | +15 % rendement (prairies/lentilles) |

---

## R6 — Vallée du Rhône / Sud-Est intérieur (Rhône-Alpes hors montagne)

### Profil climatique
- Température moyenne : 12–14 °C
- Précipitations : 600–800 mm/an (répartition irrégulière : printemps et automne pluvieux, été sec)
- Risques météo principaux : mistral (vents forts perturbant les chantiers), sécheresse estivale, gel de printemps (avril), orages violents d'automne, grêle
- Fenêtres de travail : bonnes au printemps (mars–mai) et automne (sept.–oct.) ; été chaud favorable aux cultures thermophiles ; mistral peut bloquer les traitements phytosanitaires

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Maïs grain | +10 % | mi-avril – mi-mai | sept.–oct. |
| Fruits (pêche, abricot, cerise) | +15 % | — (plantation) | juin–août |
| Légumes plein champ (tomate, courgette) | +12 % | avril–mai | juil.–sept. |
| Noix | +12 % | — (plantation) | oct. |
| Blé tendre | +8 % | nov.–déc. | juil. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Volailles (poulet, pintade) | +10 % GMQ | Coût démarrage −15 % ; filière Bresse possible (V2+) |
| Bovins allaitants | +5 % GMQ | Pâtures de plaine |

### Spécialités locales (V1)
- **Noix de Grenoble** : AOP — prix de vente +25 % vs noix standard ; disponible uniquement département Isère/Drôme
- **Fruits d'été** (pêche, abricot) : contrat expéditeur disponible ; prime calibre +10 %
- **Légumes plein champ** : contrat industrie agroalimentaire (conserverie) disponible dès l'année 1

> V2+ : Volaille de Bresse AOP, vins Côtes-du-Rhône/Hermitage/Crozes, huile de noix, lavande (Drôme), ravioles du Dauphiné

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 5 000–9 000 €/ha |
| disponibilite_foncier | normale (0.40) |
| difficulte_preset | standard |
| modificateur_meteo_risque | +15 % (mistral + sécheresse estivale) |
| bonus_culture_principale | +15 % rendement (fruits/légumes) |

---

## R7 — Méditerranée (PACA, Occitanie côtière, Corse)

### Profil climatique
- Température moyenne : 14–17 °C
- Précipitations : 300–600 mm/an (très irrégulières : longues sécheresses estivales, épisodes cévenols violents en automne)
- Risques météo principaux : sécheresse estivale sévère (juin–sept.), épisodes cévenols/méditerranéens (oct.–nov.) avec inondations, mistral, canicule, gel rare mais possible (jan.–févr. en arrière-pays)
- Fenêtres de travail : hiver doux permettant travaux (déc.–mars) ; printemps court et favorable (mars–mai) ; été très contraint par chaleur et sécheresse ; automne risqué (épisodes pluvieux violents)

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Vignes | +15 % | — (plantation) | août–oct. |
| Oliviers | +15 % | — (plantation) | nov.–déc. |
| Maraîchage sous abri/plein champ | +12 % | sept.–mars (hiver) / févr.–avril (printemps) | toute l'année |
| Tournesol | +8 % | avril–mai | sept. |
| Herbes aromatiques (thym, romarin) | +15 % | mars–avril | juin–sept. |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Ovins viande/lait (Mérinos, Lacaune) | +12 % GMQ/lait | Coût démarrage −15 % ; transhumance simulée (V2+) |
| Caprins (fromage) | +12 % lait | [V2+] — hors scope V1 |
| Abeilles (apiculture) | +10 % miel | [V2+] — hors scope V1 |

### Spécialités locales (V1)
- **Huile d'olive** : AOP (Vallée des Baux, Nyons) — prix de vente +35 % vs huile standard ; disponible uniquement si plantation oliviers ≥ 3 ha
- **Maraîchage primeur** : prix de vente +15 % vs référence nationale (précocité climatique) ; contrat MIN (Marché d'Intérêt National) disponible
- **Herbes aromatiques** : contrat distillerie/herboristerie disponible ; prix +20 % vs marché spot

> V2+ : Vins AOC (Châteauneuf-du-Pape, Bandol, Corse), lavande AOP, fleurs coupées (Var), fromages de brebis (Roquefort côté Occitanie), agrumes (Corse)

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 4 000–8 000 €/ha |
| disponibilite_foncier | rare (0.25) |
| difficulte_preset | expert |
| modificateur_meteo_risque | +25 % (sécheresse + épisodes cévenols) |
| bonus_culture_principale | +15 % rendement (vigne/olive/maraîchage) |

---

## R8 — Montagne (Alpes, Pyrénées, Vosges, Jura)

### Profil climatique
- Température moyenne : 5–9 °C (forte variation : 3–7 °C en altitude > 800 m, 8–11 °C en fond de vallée)
- Précipitations : 900–1 500 mm/an (enneigement hivernal significatif ; fonte des neiges alimente les prairies)
- Risques météo principaux : gel prolongé (oct.–avril en altitude), neige bloquante, avalanches (hors scope gameplay), sécheresse estivale sur versants sud, orages violents d'été, fenêtres de travail très courtes
- Fenêtres de travail : très courtes (juin–septembre en altitude, mai–octobre en vallée) ; hiver long rendant toute culture impossible ; printemps tardif et automne précoce

### Cultures favorisées
| Culture | Bonus rendement | Fenêtre semis | Fenêtre récolte |
|---------|----------------|---------------|-----------------|
| Prairies d'altitude | +15 % (production herbe) | — | 2 coupes/an (juin–août) |
| Orge de printemps | +10 % | avril–mai | août–sept. |
| Seigle | +12 % | avril–mai | août |
| Pomme de terre de montagne | +10 % | mai | sept. |
| Lentilles (Jura/Vosges) | +8 % | avril–mai | août |

### Élevages favorisés
| Atelier | Bonus production | Spécificité |
|---------|-----------------|-------------|
| Bovins lait (Abondance, Tarentaise, Montbéliarde) | +15 % lait | Coût démarrage −15 % ; fromages AOP (Beaufort, Comté, Reblochon, Abondance) |
| Bovins allaitants (Salers, Aubrac) | +10 % GMQ | Coût démarrage −15 % ; pâtures d'altitude |
| Ovins lait/viande (Manech, Basco-Béarnaise) | +12 % GMQ/lait | Coût démarrage −15 % ; fromages Pyrénées |
| Abeilles (apiculture de montagne) | +12 % miel | [V2+] — hors scope V1 |

### Spécialités locales (V1)
- **Lait fromager AOP** : contrat fruitière/coopérative fromagère disponible ; prix collecte +20 % vs référence nationale (Beaufort, Comté, Reblochon)
- **Bœuf de montagne** : contrat Label Rouge disponible ; prime +12 % sur prix vif
- **Miel de montagne** : prix de vente +25 % vs miel standard ; contrat épicerie fine disponible

> V2+ : Fromages AOP affinés (Beaufort, Comté, Reblochon, Abondance, Ossau-Iraty), génépi, vins de Savoie, eau-de-vie de poire (Vosges), transhumance estivale

### Paramètres gameplay
| Paramètre | Valeur |
|-----------|--------|
| prix_foncier_base | 1 500–3 500 €/ha |
| disponibilite_foncier | normale (0.50) |
| difficulte_preset | expert |
| modificateur_meteo_risque | +30 % (gel prolongé + fenêtres très courtes) |
| bonus_culture_principale | +15 % rendement (prairies d'altitude/lait fromager) |

---

## Récapitulatif comparatif

| ID | Région | Temp. (°C) | Pluie (mm/an) | Prix foncier (€/ha) | Dispo foncier | Difficulté | Risque météo |
|----|--------|-----------|---------------|---------------------|---------------|------------|--------------|
| R1 | Grand Ouest | 11–13 | 700–900 | 5 000–8 000 | abondante | facile | +10 % |
| R2 | Bassin parisien | 10–12 | 550–700 | 7 000–12 000 | normale | facile | +8 % |
| R3 | Nord/Nord-Est | 9–11 | 600–800 | 6 000–10 000 | normale | standard | +15 % |
| R4 | Sud-Ouest | 13–15 | 600–900 | 4 000–7 000 | abondante | standard | +12 % |
| R5 | Massif central | 8–11 | 800–1 200 | 2 000–4 500 | abondante | standard | +20 % |
| R6 | Vallée du Rhône | 12–14 | 600–800 | 5 000–9 000 | normale | standard | +15 % |
| R7 | Méditerranée | 14–17 | 300–600 | 4 000–8 000 | rare | expert | +25 % |
| R8 | Montagne | 5–9 | 900–1 500 | 1 500–3 500 | normale | expert | +30 % |
