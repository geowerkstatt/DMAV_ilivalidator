# Validation DMAV avec ilivalidator
Mise en œuvre des règles de validation officielles relatives au modèle de données de la mensuration officielle (DMAV) version 1.1 avec ilivalidator. Dans ce projet, les deux types de contraintes suivants sont vérifiés pour les modèles DMAV avec ilivalidator :
* Contraintes INTERLIS natives : contraintes formulées directement dans les modèles
* Contraintes INTERLIS non natives : des contraintes supplémentaires sont formulées dans des modèles de validation supplémentaires. Il existe les modèles supplémentaires suivants :
  * DMAV_V1_1_Bodenbedeckung_Validierung
  * DMAV_V1_1_Einzelobjekte_Validierung
  * DMAV_V1_1_FixpunkteKategorie3_Validierung
  * DMAV_V1_1_Gebaeudeadressen_Validierung
  * DMAV_V1_1_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_1_Nomenklatur_Validierung
  * DMAV_V1_1_Rohrleitungen_Validierung
  * DMAV_V1_1_Toleranzstufen_Validierung

Les deux types de contraintes ont été testés dans le cadre du projet https://github.com/geostandards-ch/DMAV-Testsuite à l'aide de cas négatifs.

Les contrôles intermodèles avec les données des services web (points fixes PFP1/PFA1/PFP2, frontières nationales, liste des communes, répertoire officiel des localités) sont intégrés sous forme de données de référence. Les contrôles par rapport au RegBL (GWR) sont effectués au moyen du plugin `ilivalid-gwr`.

## Utilisation via ilicop
La dernière version est disponible sur https://dmav.ilicop.ch/ et peut être utilisée via l'interface d'ilicop.
Pour valider les règles de contrôle supplémentaires, il faut sélectionner le profil 'DMAV mit Zusatzanforderungen':
<br/>
<br/>
<img width="1645" height="485" alt="image" src="https://github.com/user-attachments/assets/65a69894-c322-41eb-908f-ea321bb562b5" />
<br/>
> [!TIP]
> Actuellement, la limite de taille pour les fichiers XTF est de 200 MB. Les fichiers XTF plus grands peuvent être compressés avant le téléchargement afin de réduire leur taille. Ilicop accepte les fichiers XTF et ZIP pour le téléchargement.

## Structure du repository
```
ilitools/                       ilivalidator (version snapshot interne) avec libs
  plugins/                      plugin ilivalid-gwr + sqlite-jdbc (chargés automatiquement)
repositories/                   repository local des modèles et des données (--modeldir)
  ilimodels.xml                 répertoire des modèles (généré avec ilimanager)
  ilidata.xml                   répertoire des configurations et des données de référence (ilidata:<id>)
  refdata_mapping.xtf           attribution topic/scope --> données de référence
  dmav_V1_1/
    *_MetaConfig_*.ini          points d'entrée pour --metaConfig
    *_Config_*.ini              configuration ilivalidator (additionalModels, messages)
    official_models/            modèles officiels DMAV V1.1 et modèles des services web
    validation_models/          modèles de validation supplémentaires
    internal_models/            modèles auxiliaires (fonctions, RefData, GWR)
    refdata/                    données de référence (données des services web)
data/dmav_V1_1/test_data/       jeux de données de test (logs sous logs/, non versionnés)
notes/                          notes de travail et documentation (en allemand)
```

Deux profils sont disponibles :

| Profil | MetaConfig | Contenu |
|--------|------------|---------|
| plain | `DMAV_V1_1_Validierung_MetaConfig_plain.ini` | uniquement la structure INTERLIS et les contraintes natives |
| avec règles supplémentaires | `DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini` | en plus tous les modèles de validation, les données de référence et les contrôles RegBL |

## Installation
Les derniers objets livrés se trouvent sous [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases). Ceux-ci peuvent être utilisés pour une installation locale. Pour cela, les fichiers doivent être téléchargés et décompressés dans un répertoire avec des permissions en lecture et en écriture.

Il est aussi possible de cloner le repository. En raison de sa taille, le répertoire officiel des localités (`OfficialIndexOfLocalities_V1_0.xtf`) n'est pas versionné et doit être téléchargé séparément dans `repositories/dmav_V1_1/refdata/` (sources voir [notes/Doku_ConfigRefData_Teamcamp.md](notes/Doku_ConfigRefData_Teamcamp.md#download-der-webdienstdaten)).

### Conditions système recommandées
Conditions système recommandées: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

Les contrôles RegBL nécessitent en outre un accès à Internet : lors du premier lancement, le plugin télécharge la base de données du RegBL (`ch.zip` de public.madd.bfs.admin.ch) et l'enregistre dans le cache sous `%USERPROFILE%\.ilicache\`.

### Prérequis pour les fichiers XTF
Voir aussi la section [Points en suspens](#points-en-suspens--limites-de-la-mise-en-œuvre-actuelle)
* Compatible avec les modèles actuels (selon `repositories/dmav_V1_1/official_models`)
* Pour les tests intermodèles, tous les topics du modèle `DMAVTYM_Alles_V1_1` doivent être fournis
* Les données des services web ne doivent pas être comprises dans la livraison ; elles sont intégrées comme données de référence via `refdata_mapping.xtf`

### Lancement
**Profil plain**
```
java -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

**Profil avec règles supplémentaires**
```
java --enable-native-access=ALL-UNNAMED -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini ^
  --refmapping [repoDir]\repositories\refdata_mapping.xtf ^
  --scope [N° OFS] ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

| Paramètre | Signification |
|-----------|---------------|
| `--metaConfig` | profil (voir ci-dessus) |
| `--refmapping` | attribution des données de référence. Doit être indiqué comme chemin de fichier direct (`ilidata:` n'est pas résolu) |
| `--scope` | numéro OFS de la commune. Détermine quelles données de référence de `refdata_mapping.xtf` sont chargées et sert de filtre communal pour les contrôles RegBL |
| `--modeldir` | chemin vers le répertoire `repositories` |
| `--enable-native-access=ALL-UNNAMED` | supprime à partir de Java 24 l'avertissement du pilote sqlite (plugin RegBL) |

D'autres exemples avec les données de test voir [Aufruf_cmd.md](Aufruf_cmd.md). Documentation complète ilivalidator : https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung

## Rapports de bugs et demandes de nouvelles fonctions
Bugs et demandes de nouvelles fonctions peuvent être enregistrés dans la rubrique **Issues**. Les problèmes rapportés peuvent être redistribués vers d'autres repositories pendant leur traitement (voir [Sources](#sources)).

## Points en suspens / Limites de la mise en œuvre actuelle
* **Contraintes RegBL :** partiellement mises en œuvre (plugin `ilivalid-gwr`, version snapshot). Certains contrôles sont encore en cours d'élaboration ou commentés dans le modèle de validation.
* **Données de référence :** `refdata_mapping.xtf` ne contient actuellement que des entrées pour la commune de test (scope 449). Pour d'autres communes, les entrées et données de référence correspondantes doivent être complétées.
* **Données des services web :** intégrées sous forme de fichiers statiques (`repositories/dmav_V1_1/refdata/`), pas directement via les services web. Les mises à jour doivent être effectuées manuellement.
* **Tests des limites avec données de référence** (frontières nationales) : les données de référence sont intégrées, les contrôles ne sont pas encore mis en œuvre.
* La version d'ilivalidator requise est une version snapshot interne (`ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT`).

## Sources
* Repository des modèles de validation: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
* Plugin ilivalid-gwr: https://jars.interlis.ch/ch/interlis/ilivalid-gwr/1.0.0-SNAPSHOT/
* Documentation du modèle et FAQ DMAV : https://www.cadastre-manual.admin.ch (Manuel de la mensuration officielle > Modèle de géodonnées DMAV)
