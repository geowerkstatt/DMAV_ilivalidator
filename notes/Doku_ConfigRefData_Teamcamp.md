# Dokumentation: Konfigurationsdateien DMAV-Validator

## Überblick Konfigurationskette

Der ilivalidator wird mit einer MetaConfig-Datei gestartet. Diese orchestriert alle weiteren Einstellungen und verweist auf die eigentliche Config-Datei:

```
Kommandozeile
  --metaConfig  -->  MetaConfig_with_additional_rules.ini
                         |-- models        --> DMAVTYM_Alles_V1_1
                         |                     Gefunden via ilimodels.xml
                         |-- config        --> ilidata:config_dmav_v1_1_with_additional_rules
                         |                     Lookup in ilidata.xml
                         |                     --> Config_with_additional_rules.ini (diese Datei)
                         |-- allObjectsAccessible=true
                         |-- refmapping    --> <direkter Dateipfad zu refdata_mapping.xtf>
                         |                     ⚠ kein ilidata:-Präfix möglich (wird nicht aufgelöst)
                         `-- bannedBaskets --> <Modell.Topic>
```

---

## Rollen der Dateien im Repository (`repositories/`)

### `ilimodels.xml`

Verzeichnis aller INTERLIS-Modelle (`.ili`-Dateien) im lokalen Repository. Der Validator sucht hier nach Modellnamen (z.B. `DMAVTYM_Alles_V1_1`, `DMAV_V1_1_Bodenbedeckung_Validierung`) und erhält den zugehörigen Dateipfad. Diese Datei wird **nicht manuell bearbeitet** – sie wird mit `ilimanager` generiert.

### `ilidata.xml`

Verzeichnis aller Datensätze im Repository: Konfigurationen, Referenzdaten, Mappings. Jeder Eintrag hat eine eindeutige `<id>`, einen Typ (`<categories>`) und einen Dateipfad (`<path>`). Die `<id>` wird mit dem Präfix `ilidata:` referenziert — der Validator löst `ilidata:<id>` auf, indem er diese Datei nach dem passenden Eintrag durchsucht und dessen `<path>` zurückgibt.

#### Vollständige Einträge im DMAV-Repository

| `id` (TID) | Typ | Dateipfad |
|-----------|-----|-----------|
| `dmav_v1_1_plain` (1) | `metaconfig` | `dmav_V1_1/DMAV_V1_1_Validierung_Config_plain.ini` |
| `dmav_v1_1_with_additional_rules` (2) | `metaconfig` | `dmav_V1_1/DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini` |
| `config_dmav_v1_1_plain` (11) | `ilivalidatorconfig` | `dmav_V1_1/DMAV_V1_1_Validierung_Config_plain.ini` |
| `config_dmav_v1_1_with_additional_rules` (21) | `ilivalidatorconfig` | `dmav_V1_1/DMAV_V1_1_Validierung_Config_with_additional_rules.ini` |
| `dmav_refdata_mapping` (99) | `refDataMapping` | `refdata_mapping.xtf` |
| `dmav_Gemeinden95_V1_0` (92) | `referenceData` | `dmav_V1_1/refdata/Gemeinden95_2_4.xtf` |
| `dmav_LFP1_V1_0` (93) | `referenceData` | `dmav_V1_1/refdata/FixpunkteLV_V1_0_LFP1.xtf` |
| `dmav_HFP1_V1_0` (94) | `referenceData` | `dmav_V1_1/refdata/FixpunkteLV_V1_0_HFP1.xtf` |
| `dmav_OfficialIndesOfLocalities` (95) | `referenceData` | `dmav_V1_1/refdata/OfficialIndexOfLocalities_V1_0.xtf` |
| `dmav_LFP2_BE` (96) | `referenceData` | `dmav_V1_1/refdata/fpds2_BE.xtf` |
| `dmav_LFP3_449` (97) | `referenceData` | `dmav_V1_1/refdata/449_FixpunkteKategorie3.xtf` |
| `dmav_v1_10_hoheitsgrenzen_lv` (91) | *(kein Typ)* | `dmav_V1_1/refdata/hoheitsgrenze-landesvermessung_2056.xtf` |

#### Wie MetaConfig und Config-INI gegenseitig aufeinander verweisen

Der Schlüssel zum Verständnis: **beide INI-Dateien sind je zweimal in `ilidata.xml` registriert** — einmal als `metaconfig` (für den Einstieg über `--metaConfig`) und einmal als `ilivalidatorconfig` (für die interne Referenz via `config=ilidata:...`).

**Einstieg über `--metaConfig ilidata:dmav_v1_1_with_additional_rules`:**

```
--metaConfig ilidata:dmav_v1_1_with_additional_rules
         |
         | ilidata.xml lookup: id=dmav_v1_1_with_additional_rules
         |   Typ: metaconfig
         |   Pfad: dmav_V1_1/DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini
         v
MetaConfig_with_additional_rules.ini wird geladen
         |
         | Parameter: config=ilidata:config_dmav_v1_1_with_additional_rules
         |
         | ilidata.xml lookup: id=config_dmav_v1_1_with_additional_rules
         |   Typ: ilivalidatorconfig
         |   Pfad: dmav_V1_1/DMAV_V1_1_Validierung_Config_with_additional_rules.ini
         v
Config_with_additional_rules.ini wird geladen (Fehlermeldungen, bannedBaskets, ...)
```

**Warum dieselbe Datei manchmal mit zwei verschiedenen IDs registriert ist:**

Die Plain-Config (`DMAV_V1_1_Validierung_Config_plain.ini`) taucht in `ilidata.xml` gleich zweimal auf:
- Als `dmav_v1_1_plain` (Typ `metaconfig`): für den direkten Aufruf `--metaConfig ilidata:dmav_v1_1_plain` — der Validator behandelt sie dann direkt als MetaConfig und liest alle Sektionen darin.
- Als `config_dmav_v1_1_plain` (Typ `ilivalidatorconfig`): für die interne Referenz `config=ilidata:config_dmav_v1_1_plain` aus einer MetaConfig heraus.

**Zusammenfassung der Typen:**

| Typ | Wofür registriert | Wie referenziert |
|-----|------------------|-----------------|
| `metaconfig` | INI-Datei als Einstiegspunkt | `--metaConfig ilidata:<id>` auf der Kommandozeile |
| `ilivalidatorconfig` | INI-Datei als Config (Constraint-Meldungen, Parameter) | `config=ilidata:<id>` in der MetaConfig |
| `refDataMapping` | XTF mit Topic→Refdata-Mapping | `--refmapping <pfad>` (kein ilidata: möglich in MetaConfig) |
| `referenceData` | Referenz-XTF (Gemeinden, Fixpunkte, ...) | `ilidata:<id>` in `refdata_mapping.xtf` |

### `refdata_mapping.xtf`

XTF-Datei im Format `IliVRefData_V1_0`. Definiert pro INTERLIS-Topic, welche Referenzdatei zu laden ist (z.B. Gemeindeliste, Fixpunkte-Referenz, Hoheitsgrenzen). Der Validator nutzt dieses Mapping, wenn Validierungsconstraints `allObjects(>Topic.Class)` aufrufen – er schaut im Mapping nach, woher die Referenzobjekte für das jeweilige Topic zu holen sind.

---

## MetaConfig: `DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini`

```ini
[CONFIGURATION]

[ch.ehi.ilivalidator]
models=DMAVTYM_Alles_V1_1
config=ilidata:config_dmav_v1_1_with_additional_rules
allObjectsAccessible=true
#refmapping=ilidata:dmav_refdata_mapping
#bannedBaskets=DMAV_FixpunkteAVKategorie3_V1_1.FixpunkteAVKategorie3
```

### Sektion `[CONFIGURATION]`

Leer – aber das Vorhandensein dieser Sektion ist wichtig: Sie erzwingt den vollständigen Verarbeitungsweg im Validator, der alle `[ch.ehi.ilivalidator]`-Parameter korrekt behandelt.

### Sektion `[ch.ehi.ilivalidator]`

| Parameter | Wert | Wirkung |
|-----------|------|---------|
| `models` | `DMAVTYM_Alles_V1_1` | Das zu validierende INTERLIS-Modell. Der Validator lädt dieses Modell und alle Abhängigkeiten via `ilimodels.xml`. |
| `config` | `ilidata:config_dmav_v1_1_with_additional_rules` | Referenz auf die Config-Datei. Wird als ilidata-Lookup aufgelöst: `ilidata.xml` → `DMAV_V1_1_Validierung_Config_with_additional_rules.ini`. |
| `allObjectsAccessible` | `true` | Alle Objekte gelten als vollständig im Transfer vorhanden. Ermöglicht Existenz-Constraints (z.B. Referenzprüfungen mit `allObjects()`). Ohne diesen Parameter werden solche Constraints übersprungen. |
| `refmapping` | Dateipfad | Pfad zur Referenzdaten-Mapping-Datei (`refdata_mapping.xtf`). **Wichtig:** Der Wert muss ein direkter Dateipfad sein – `ilidata:`-Referenzen werden für diesen Parameter nicht aufgelöst. Alternativ per Kommandozeile mit `--refmapping` übergeben. |
| `bannedBaskets` | `<Modell.Topic>` | Basket, der im XTF-Transfer **verboten** ist. Ist er vorhanden, wird ein Fehler ausgegeben. Kann alternativ auch in der Config-Datei im `["PARAMETER"]`-Abschnitt gesetzt werden (ist dann äquivalent). |

---

## Config: `DMAV_V1_1_Validierung_Config_with_additional_rules.ini`

### Sektion `["PARAMETER"]`

Globale Validierungsparameter, die für alle Baskets/Topics gelten:

| Parameter | Wert | Wirkung |
|-----------|------|---------|
| `validation` | `"on"` | Schaltet die Constraint-Validierung ein. |
| `additionalModels` | `"Modell1;Modell2;..."` | Semikolon-getrennte Liste zusätzlicher INTERLIS-Validierungsmodelle, die beim Validieren hinzugezogen werden. Diese definieren zusätzliche `MANDATORY CONSTRAINT`-Regeln (CH-Codes) über die im Datenmodell enthaltenen Constraints hinaus. Alle Modelle werden via `ilimodels.xml` gefunden. |
| `bannedBaskets` | `<Modell.Topic>` | Basket, der im XTF-Transfer **verboten** ist (`→ Fehler`). Mehrere Einträge semikolon-getrennt. |
| `mandatoryBaskets` | `<Modell.Topic>[;...]` | Baskets, die im XTF-Transfer **obligatorisch** vorhanden sein müssen (`→ Fehler` wenn fehlend). Mehrere Einträge semikolon-getrennt. |

**Aktuell gesetzte `additionalModels`:**

- `DMAV_V1_1_Bodenbedeckung_Validierung`
- `DMAV_V1_1_Einzelobjekte_Validierung`
- `DMAV_V1_1_FixpunkteKategorie3_Validierung`
- `DMAV_V1_1_Gebaeudeadressen_Validierung`
- `DMAV_V1_1_Grundstuecke_Validierung`
- `DMAV_V1_0_HoheitsgrenzenAV_Validierung`
- `DMAV_V1_1_Nomenklatur_Validierung`
- `DMAV_V1_1_Rohrleitungen_Validierung`
- `DMAV_V1_1_Toleranzstufen_Validierung`

**Aktuell gesetztes `bannedBaskets`:**
- `DMAV_FixpunkteAVKategorie3_V1_1.FixpunkteAVKategorie3` — Der Fixpunkte-Kategorie-3-Basket darf **nicht** im Transfer enthalten sein (wird separat geliefert/validiert).

**Aktuell gesetzte `mandatoryBaskets`:**
- `DMAV_Bodenbedeckung_V1_1.Bodenbedeckung`
- `DMAV_Einzelobjekte_V1_1.Einzelobjekte`
- `DMAV_Gebaeudeadressen_V1_1.Gebaeudeadressen`
- `DMAV_Grundstuecke_V1_1.Grundstuecke`
- `DMAV_HoheitsgrenzenAV_V1_0.HoheitsgrenzenAV`
- `DMAV_Toleranzstufen_V1_1`

### Sektionen `["<Qualifizierter-Constraint-Name>"]`

Jede weitere Sektion überschreibt die Fehlermeldung eines spezifischen Constraints mit einer mehrsprachigen Version. Format des Sektionsnamens:

```
"<Modell>.<Topic>.<Klasse>.<ConstraintName>"
```

Verfügbare Keys pro Sektion:

| Key | Bedeutung |
|-----|-----------|
| `message` | Fehlermeldung (Fallback, wird angezeigt wenn keine Sprache passt) |
| `message_de` | Deutsche Fehlermeldung |
| `message_fr` | Französische Fehlermeldung |
| `message_it` | Italienische Fehlermeldung |

Die CH-Codes (z.B. `CH020101`) in den Constraint-Namen entsprechen der offiziellen DMAV-Prüfregel-Nummerierung und erscheinen so im Validierungslog.

**Beispiel:**

```ini
["DMAV_FixpunkteAVKategorie3_V1_1.FixpunkteAVKategorie3.LFP3Nachfuehrung.CH020101"]
message_de="(CH020101) Benutzerschlüssel ist nicht eindeutig (Attributkombination: NBIdent, Identifikator)"
message_fr="(CH020101) La clé utilisateur n'est pas unique (Combinaison d'attributs : IdentDN, Identification)"
message_it="(CH020101) La chiave utente non è univoca (Combinazione di attributi: IdentAN, Identificatore)"
```

In der Config-Datei sind Fehlermeldungen für folgende Themenblöcke definiert:

| Themenblock | Constraint-Codes |
|-------------|-----------------|
| FixpunkteAVKategorie3 (LFP3, HFP3) | CH020101, CH020201–CH020203, CH020205–CH020206, CH020601, CH020701–CH020702 |
| HoheitsgrenzenAV | CH030101, CH030601, CH030701–CH030703, CH031101, CH031201 |
| Grundstücke | CH040101, CH040201–CH040203, CH040601, CH040701, CH041101–CH041102, CH041201, CH041301–CH041302, CH041401–CH041402, CH041501, CH041601, CH041701–CH041702, CH041801–CH041802, CH042001, CH042101–CH042102, CH042201–CH042202, CH042401–CH042402 |
| Nomenklatur | CH070101 |
| Bodenbedeckung | CH080101, CH080401–CH080402, CH080801, CH080902 |
| Einzelobjekte | CH090101, CH090701, CH091201–CH091202 |
| Rohrleitungen | CH100101, CH100201, CH100501, CH101501–CH101502 |
| Toleranzstufen | CH110101 |
| Gebäudeadressen | CH120101, CH120501–CH120502, CH121701 |

---

## Validator-Aufruf (Kommandozeile)

```
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar \
  --metaConfig  c:\...\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini \
  --refmapping  C:\...\repositories\refdata_mapping.xtf \
  --log         c:\...\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log \
  --scope       446 \
  --modeldir    c:\...\repositories \
                c:\...\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1_withError.xtf
```

### Parameter im Detail

| Parameter | Wert | Bedeutung |
|-----------|------|-----------|
| `--metaConfig` | Pfad zur MetaConfig-INI | Lädt die MetaConfig als Einstiegspunkt. Alle weiteren Einstellungen (Modell, Config-Datei, `allObjectsAccessible`) werden von dort gelesen. Kann auch als `ilidata:<id>` angegeben werden wenn das Repository lokal verfügbar ist. |
| `--refmapping` | Pfad zur `refdata_mapping.xtf` | Lädt das Topic→Referenzdaten-Mapping. Dieser Parameter muss als direkter Dateipfad angegeben werden — `ilidata:` wird hier **nicht** aufgelöst (weder auf der Kommandozeile noch in der MetaConfig). |
| `--log` | Pfad zur Log-Datei | Schreibt das vollständige Validierungsprotokoll in diese Datei. Ohne diesen Parameter wird nur auf die Konsole ausgegeben. |
| `--scope` | `446` | Scope des zu validierenden Baskets — hier die BFS-Nummer der Gemeinde. Wird beim Laden der Referenzdaten aus `refdata_mapping.xtf` als Scope-Filter verwendet: Es werden nur Mapping-Einträge berücksichtigt, deren `scope` mit `446` übereinstimmt, oder die keinen Scope haben (gelten für alle). |
| `--modeldir` | Pfad zum `repositories/`-Verzeichnis | Verzeichnis, in dem der Validator nach INTERLIS-Modellen (`ilimodels.xml`) und Datensätzen (`ilidata.xml`) sucht. Entspricht dem lokalen Repository. Mehrere Verzeichnisse können semikolon-getrennt angegeben werden. |
| *(letztes Argument)* | Pfad zur XTF-Datei | Die zu validierende Transferdatei. Muss als letztes Argument ohne Flag übergeben werden. |

### Zusammenspiel der Parameter beim Aufruf

```
--metaConfig  -->  MetaConfig-INI liest: models, config, allObjectsAccessible
--refmapping  -->  refdata_mapping.xtf  \
--scope 446   -->  filtert Mapping-Einträge  >--> allObjects()-Constraints werden aufgelöst
--modeldir    -->  ilimodels.xml (Modelle) + ilidata.xml (ilidata:-Lookups)
XTF-Datei     -->  die eigentlichen Daten, die validiert werden
```

**Hinweis zu `--scope`:** Fehlt der Parameter, verwendet der Validator keinen Scope-Filter beim Mapping-Lookup — es werden dann nur Mapping-Einträge ohne `scope` berücksichtigt (Catch-all-Einträge). Einträge mit explizitem `scope` (z.B. `scope=446`) werden in diesem Fall ignoriert.
