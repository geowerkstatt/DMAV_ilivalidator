# Validation DMAV avec ilivalidator
Mise en œuvre des règles de validation officielles relatives au modèle de données de la mensuration officielle (DMAV) avec ilivalidator. Ilivalidator permet de vérifier les deux types de contraintes suivants:
* Contraintes INTERLIS natives : contraintes formulées directement dans les modèles
* Contraintes INTERLIS non natives : des contraintes supplémentaires sont formulées dans des modèles de validation supplémentaires. Il existent les modèles supplémentaires suivants :
  * DMAV_V1_0_Bodenbedeckung_Validierung
  * DMAV_V1_0_Einzelobjekte_Validierung
  * DMAV_V1_0_FixpunkteKategorie3_Validierung
  * DMAV_V1_0_Gebaeudeadressen_Validierung
  * DMAV_V1_0_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_0_Nomenklatur_Validierung
  * DMAV_V1_0_Rohrleitungen_Validierung
  * DMAV_V1_0_Toleranzstufen_Validierung
 
Les deux types de contraintes ont été testés dans le cadre du projet https://github.com/geostandards-ch/DMAV-Testsuite à l'aide de cas négatifs.

## Utilisation via ilicop
La dernière version est disponible sur https://dmav.ilicop.ch/ et peut être utilisée via l'interface d'ilicop.

## Installation
Les derniers objets livrés se trouvent sous [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases). Ceux-ci peuvent être utilisés pour une installation locale. Pour cela, les fichiers doivent être téléchargés et décompressés dans un répertoire avec des permissions en lecture et en écriture.

### Conditions système recommandées
Conditions système recommandées: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

### Prérequis pour les fichiers XTF
Voir aussi la section [Points en suspens](#points-en-suspens--limites-de-la-mise-en-œuvre-actuelle)
* Compatible avec les modèles actuels (selon ilimodels\official_DMAV_models)
* Les données du service Web doivent être comprises dans la livraison
* Pour les tests intermodèles, tous les thèmes du modèle DMAVTYM_Alles_V1_0 doivent être fournis

### Lancement
```
java -jar [ilivalidatorDir]\ilivalidator-x.xx.x.jar --config [configDir]\DMAV_V1_0_Validierung_Alle_Modelle.ini --modeldir %ITF_DIR;http://models.interlis.ch/;[modelDir] [myXTFDir]\MyXTF.xtf
```
Documentation complète ilivalidator : https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung 

## Rapports de bugs et demandes de nouvelles fonctions
Bugs et demandes de nouvelles fonctions peuvent être enregistrés dans la rubrique **Issues**. Les problèmes rapportés peuvent être redistribués vers d'autres référentiels pendant leur traitement (siehe [Sources](#sources)).

## Points en suspens / Limites de la mise en œuvre actuelle
Les types suivants de contraintes non natives et d'exigences de validation DMAV ne sont pas encore pris en charge :
* GWR contraintes
* Intégration des données de service (doivent être fournies sous forme de données statiques)
* Vérification à l'aide d'autres sources de données
  * liste des communes (Name/BFSNr)
  * tests limites territoriales 

## Sources
* Repository des modèles de validation: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
