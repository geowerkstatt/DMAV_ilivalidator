# DMAV Validierung mit ilivalidator
Umsetzung der offiziellen Prüfregeln zum Datenmodell der Amtlichen Vermessung (DMAV) Version 1.1 mit ilivalidator. In diesem Projekt werden folgende zwei Arten von Constraints für DMAV-Modelle mit ilivalidator geprüft:
* native INTERLIS-Constraints: direkt in den Modellen formulierte Constraints
* nicht-native INTERLIS-Constraints: in zusätzlichen Validierungsmodellen werden weitere Constraints formuliert. Es bestehen folgende zusätzlichen Modelle:
  * DMAV_V1_1_Bodenbedeckung_Validierung
  * DMAV_V1_1_Einzelobjekte_Validierung
  * DMAV_V1_1_FixpunkteKategorie3_Validierung
  * DMAV_V1_1_Gebaeudeadressen_Validierung
  * DMAV_V1_1_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_1_Nomenklatur_Validierung
  * DMAV_V1_1_Rohrleitungen_Validierung
  * DMAV_V1_1_Toleranzstufen_Validierung

Beide Arten von Constraints wurden im Rahmen des Projekts https://github.com/geostandards-ch/DMAV-Testsuite mit sogenannten Failcases geprüft.

Modellübergreifende Prüfungen gegen Webdienstdaten (Fixpunkte LFP1/HFP1/LFP2, Hoheitsgrenzen LV, Gemeindeliste, amtliches Ortschaftenverzeichnis) werden über Referenzdaten eingebunden. Prüfungen gegen das GWR laufen über das Plugin `ilivalid-gwr`.

## Verwendung via ilicop
Der aktuellste 'Release' befindet sich jeweils auf https://dmav.ilicop.ch/ und kann über die Oberfläche von ilicop verwendet werden.
Für die Validierung der zusätzlichen Prüfregelen, muss das Profil 'DMAV mit Zusatzanforderungen' ausgewählt werden:
<br/>
<br/>
<img width="1645" height="485" alt="image" src="https://github.com/user-attachments/assets/65a69894-c322-41eb-908f-ea321bb562b5" />
<br/>
> [!TIP]
> Aktuell besteht eine Grössenlimitierung für XTF-Dateien bei 200 MB. Grössere XTF-Dateien können vor dem Upload gezippt werden, um die Dateigrösse zu reduzieren. Ilicop akzeptiert XTF- und ZIP-Dateien für den Upload.

## Aufbau des Repositorys
```
ilitools/                       ilivalidator (interne Snapshot-Version) inkl. libs
  plugins/                      ilivalid-gwr Plugin + sqlite-jdbc (werden automatisch geladen)
repositories/                   lokales Modell- und Daten-Repository (--modeldir)
  ilimodels.xml                 Modellverzeichnis (generiert mit ilimanager)
  ilidata.xml                   Verzeichnis der Konfigurationen und Referenzdaten (ilidata:<id>)
  refdata_mapping.xtf           Zuordnung Topic/Scope --> Referenzdaten
  dmav_V1_1/
    *_MetaConfig_*.ini          Einstiegspunkte für --metaConfig
    *_Config_*.ini              ilivalidator-Konfiguration (additionalModels, Meldungstexte)
    official_models/            offizielle DMAV-Modelle V1.1 und Webdienst-Modelle
    validation_models/          zusätzliche Validierungsmodelle
    internal_models/            Hilfsmodelle (Funktionen, RefData, GWR)
    refdata/                    Referenzdaten (Webdienstdaten)
data/dmav_V1_1/test_data/       Testdatensätze (Logs unter logs/, nicht versioniert)
notes/                          Arbeitsnotizen und Dokumentation
```
Details zur Konfigurationskette (MetaConfig, Config, ilidata, Referenzdaten) siehe [notes/Doku_ConfigRefData_Teamcamp.md](notes/Doku_ConfigRefData_Teamcamp.md).

Es stehen zwei Profile zur Verfügung:

| Profil | MetaConfig | Inhalt |
|--------|------------|--------|
| plain | `DMAV_V1_1_Validierung_MetaConfig_plain.ini` | nur INTERLIS-Struktur und native Constraints |
| mit Zusatzregeln | `DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini` | zusätzlich alle Validierungsmodelle, Referenzdaten und GWR-Prüfungen |

## Installation
Unter [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases) befinden sich die aktuellsten Lieferobjekte. Diese können für eine lokale Installation verwendet werden. Dazu müssen die Dateien heruntergeladen und in einem Verzeichnis mit Lese- und Schreibrechten entzippt werden.

Alternativ kann das Repository geklont werden. Das amtliche Ortschaftenverzeichnis (`OfficialIndexOfLocalities_V1_0.xtf`) ist aufgrund der Dateigrösse nicht versioniert und muss separat nach `repositories/dmav_V1_1/refdata/` heruntergeladen werden (Bezugsquellen siehe [notes/Doku_ConfigRefData_Teamcamp.md](notes/Doku_ConfigRefData_Teamcamp.md#download-der-webdienstdaten)).

### Systemvoraussetzungen
Systemvoraussetzungen: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

Für die GWR-Prüfungen wird zusätzlich ein Internetzugang benötigt: Das Plugin lädt beim ersten Aufruf die GWR-Datenbank (`ch.zip` von public.madd.bfs.admin.ch) herunter und legt sie im Cache unter `%USERPROFILE%\.ilicache\` ab.

### Anforderungen an XTF-Datei
siehe auch Abschnitt [Offene Punkte](#offene-punkte--abgrenzung-der-aktuellen-umsetzung)
* Kompatibel mit den aktuellen Modellen sein (gemäss `repositories/dmav_V1_1/official_models`)
* Für die modellübergreifenden Tests müssen alle Topics aus dem Modell `DMAVTYM_Alles_V1_1` im Lieferumfang enthalten sein
* Webdienstdaten müssen nicht im Lieferumfang enthalten sein; sie werden über `refdata_mapping.xtf` als Referenzdaten eingebunden

### Aufruf
**Profil plain**
```
java -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

**Profil mit Zusatzregeln**
```
java --enable-native-access=ALL-UNNAMED -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini ^
  --refmapping [repoDir]\repositories\refdata_mapping.xtf ^
  --scope [BFS-Nr] ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

| Parameter | Bedeutung |
|-----------|-----------|
| `--metaConfig` | Profil (siehe oben) |
| `--refmapping` | Mapping der Referenzdaten. Muss als direkter Dateipfad angegeben werden (`ilidata:` wird nicht aufgelöst) |
| `--scope` | BFS-Nummer der Gemeinde. Steuert, welche Referenzdaten aus `refdata_mapping.xtf` geladen werden, und wird von den GWR-Prüfungen als Gemeindefilter verwendet |
| `--modeldir` | Pfad zum Verzeichnis `repositories` |
| `--enable-native-access=ALL-UNNAMED` | unterdrückt ab Java 24 die Warnung des sqlite-Treibers (GWR-Plugin) |

Weitere Beispielaufrufe mit den Testdaten siehe [Aufruf_cmd.md](Aufruf_cmd.md). Vollständige Dokumentation ilivalidator: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung

## Meldungen von Bugs und Featurewünschen
Bugs und Featurewünsche zur Validierung von DMAV mit ilivalidator können in der Rubrik **Issues** erfasst werden. Die gemeldeten Issues werden ggf. während der Bearbeitung in andere Repositories umverteilt (siehe [Quellen](#quellen)).

## Offene Punkte / Abgrenzung der aktuellen Umsetzung
* **GWR-Constraints:** teilweise umgesetzt (Plugin `ilivalid-gwr`, Snapshot-Version). Einzelne Prüfungen sind noch in Arbeit bzw. im Validierungsmodell auskommentiert.
* **Referenzdaten:** in `refdata_mapping.xtf` sind aktuell nur Einträge für die Testgemeinde (Scope 449) erfasst. Für weitere Gemeinden müssen entsprechende Einträge und Referenzdaten ergänzt werden.
* **Webdienstdaten:** werden als statische Dateien (`repositories/dmav_V1_1/refdata/`) eingebunden, nicht direkt über die Webdienste. Aktualisierungen müssen manuell nachgeführt werden.
* **Grenztests mit Referenzdaten** (Hoheitsgrenzen Landesvermessung): Referenzdaten sind eingebunden, Prüfungen noch nicht umgesetzt.
* Die benötigte ilivalidator-Version ist eine interne Snapshot-Version (`ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT`).

## Quellen
* Repository der Validierungsmodelle: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
* Plugin ilivalid-gwr: https://jars.interlis.ch/ch/interlis/ilivalid-gwr/1.0.0-SNAPSHOT/
* Modelldokumentation und FAQ DMAV: https://www.cadastre-manual.admin.ch (Handbuch Amtliche Vermessung > Geodatenmodell DMAV)
