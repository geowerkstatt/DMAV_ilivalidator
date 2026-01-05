# DMAV Validierung mit ilivalidator
Umsetzung der offiziellen Prüfregeln zum Datenmodell der Amtlichen Vermessung (DMAV) mit ilivalidator. Mit ilivalidator werden folgende zwei Arten von Constraints geprüft:
* native INTERLIS-Constraints: direkt in den Modellen formulierte Constraints
* nicht-native INTERLIS-Constraints: in zusätzlichen Validierungsmodellen werden weitere Constraints formuliert. Es bestehen folgende zusätzlichen Modelle:
  * DMAV_V1_0_Bodenbedeckung_Validierung
  * DMAV_V1_0_Einzelobjekte_Validierung
  * DMAV_V1_0_FixpunkteKategorie3_Validierung
  * DMAV_V1_0_Gebaeudeadressen_Validierung
  * DMAV_V1_0_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_0_Nomenklatur_Validierung
  * DMAV_V1_0_Rohrleitungen_Validierung
  * DMAV_V1_0_Toleranzstufen_Validierung
 
Beide Arten von Constraints wurden im Rahmen des Projekts https://github.com/geostandards-ch/DMAV-Testsuite mit sogenannten Failcases geprüft.

## Verwendung via ilicop
Der aktuellste 'Release' befindet sich jeweils auf https://dmav.ilicop.ch/ und kann über die Oberfläche von ilicop verwendet werden.
Für die Validierung der zusätzlichen Prüfregelen, muss das Profil 'DMAV mit Zusatzanforderungen' ausgewählt werden:
<br/>
<br/>
<img width="1645" height="485" alt="image" src="https://github.com/user-attachments/assets/65a69894-c322-41eb-908f-ea321bb562b5" />
<br/>
> [!TIP]
> Aktuell besteht eine Grössenlimitierung für XTF-Dateien bei 200 MB. Diese kann umgangen werden, in dem die XTF-Dateien vor dem Upload gezippt werden. Ilicop akzeptiert XTF- und ZIP-Dateien für den Upload.

## Installation
Unter [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases) befinden sich die aktuellsten Lieferobjekte. Diese können für eine lokale Installation verwendet werden. Dazu müssen die Dateien heruntergeladen und in einem Verzeichnis mit Lese- und Schreibrechten entzippt werden.

### Systemvoraussetzungen
Systemvoraussetzungen: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

### Anfoderungen an XTF-Datei
siehe auch Abschnitt [Offene Punkte](#offene-punkte--abgrenzung-der-aktuellen-umsetzung)
* Kompatibel mit den aktuellen Modellen sein (gemäss ilimodels\official_DMAV_models)
* Webdienstdaten müssen im Lieferumfang enthalten sein
* Für die Modellübergreifenden Tests müssen alle Topics aus dem Modell DMAVTYM_Alles_V1_0 im Lieferumfang enthalten sein

### Aufruf
```
java -jar [ilivalidatorDir]\ilivalidator-x.xx.x.jar --config [configDir]\DMAV_V1_0_Validierung_Alle_Modelle.ini --modeldir %ITF_DIR;http://models.interlis.ch/;[modelDir] [myXTFDir]\MyXTF.xtf
```
Vollständige Dokumentation ilivalidator: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung 

## Meldungen von Bugs und Featurewünschen
Bugs und Featurewünsche zur Validierung von DMAV mit ilivalidator können in der Rubrik **Issues** erfasst werden. Die gemeldeten Issues werden ggf. während der Bearbeitung in andere Repositories umverteilt (siehe [Quellen](#quellen)).

## Offene Punkte / Abgrenzung der aktuellen Umsetzung
Aktuell werden folgende Arten von nicht-nativen Constraints und Anforderungen an die DMAV-Validierung noch nicht unterstützt:
* GWR-Constraints
* Einbindung von Dienstdaten (müssen als statische Daten im Lieferumfang enthalten sein)
* Prüfung gegenüber weiterer Datenquellen
  * Gemeindeliste (Name/BFSNr)
  * Grenztests mit Referenzdaten

## Quellen
* Repository der Validierungsmodelle: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
