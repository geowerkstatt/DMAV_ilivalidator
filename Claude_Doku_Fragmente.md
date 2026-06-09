# Dokumentationsfragmente

## Wie der Validator `refdata_mapping.xtf` verwendet

Das Mapping beantwortet die Frage: **"Welche Referenzdaten soll ich für einen bestimmten Behaelter (Basket) laden?"**

Der Validator schaut beim Auswerten einer `ObjectPool_V1_0.allObjects(>SomeModel.SomeTopic.SomeClass)`-Funktion:

1. Von welchem **Topic** kommt die gesuchte Klasse?
2. Welchen **Scope** hat der aktuelle Basket (z.B. BFSNr der Gemeinde)?
3. Schaut im Mapping nach: Gibt es einen Eintrag, der auf dieses Topic + Scope passt?
4. Lädt die dort referenzierte `refdata`-Datei und gibt die Objekte zurück.

### Die drei Felder im Detail

#### `topic`
Der qualifizierte INTERLIS-Topic-Name im Format `Modell:Topic`. Zum Beispiel:
```xml
<IliVRefData_V1_0:topic>Gemeinden95_V1_0:Gemeinden</IliVRefData_V1_0:topic>
```
Das bedeutet: "Wenn der ObjectPool Objekte vom Topic `Gemeinden95_V1_0.Gemeinden` sucht, verwende diese refdata."

#### `scope`
Ein optionaler Einschränkungswert — typischerweise eine BFSNr, ein Kantonskürzel oder ein NBIdent. Er filtert, **für welchen Basket** diese Referenzdaten gelten. Aus dem Modell-Kommentar:

> Falls scope fehlt, gilt die Konfig für **alle** Behaelter mit dem gegebenen topic.

Beispiel mit Scope (nur für Gemeinde 351):
```xml
<IliVRefData_V1_0:scope>351</IliVRefData_V1_0:scope>
<IliVRefData_V1_0:refdata>ilidata:gemeinden95_kanton_be</IliVRefData_V1_0:refdata>
```

Ohne Scope (für alle Gemeinden):
```xml
<!-- kein <scope> Element -->
<IliVRefData_V1_0:refdata>ilidata:dmav_Gemeinden95_V1_0</IliVRefData_V1_0:refdata>
```

#### `refdata`
Die URI der zu ladenden Referenzdatei. Kann sein:
- `ilidata:BID` — sucht in `ilidata.xml` nach dem BID
- `https://...` oder `http://...` — lädt direkt von URL
- Direkter Dateipfad

### Bezug zur Constraint CH112352

```interlis
INTERLIS.objectCount(
    ObjectPool_V1_0.filter(
        ObjectPool_V1_0.allObjects(>Gemeinden95_V1_0.Gemeinden.Gemeinde),
        "BFSNr == {BFSNummer} AND Name == {Name}"
    )
) == 1
```

Der Validator:
1. `allObjects(>Gemeinden95_V1_0.Gemeinden.Gemeinde)` — sucht im Mapping nach Topic `Gemeinden95_V1_0:Gemeinden`
2. Findet in `refdata_mapping.xtf` den Eintrag — lädt `ilidata:dmav_Gemeinden95_V1_0` — lädt `Gemeinden95_2_4.xtf`
3. `filter(...)` — filtert auf `BFSNr == {BFSNummer} AND Name == {Name}` des aktuellen Gemeinde-Objekts
4. Count muss == 1 sein — Gemeinde ist in der Referenzliste bekannt

### Konfigurationskette

```
MetaConfig (refmapping=ilidata:dmav_refdata_mapping)
  → ilidata.xml (BID dmav_refdata_mapping → refdata_mapping.xtf)
    → refdata_mapping.xtf (Topic Gemeinden95_V1_0:Gemeinden → ilidata:dmav_Gemeinden95_V1_0)
      → ilidata.xml (BID dmav_Gemeinden95_V1_0 → Gemeinden95_2_4.xtf)
        → Gemeinden95_2_4.xtf wird in ObjectPool geladen
          → Constraint CH112352 kann prüfen ob Gemeinde bekannt ist
```

**Hinweis**: Kein `scope` im Mapping-Eintrag bedeutet "gilt für alle Baskets, unabhängig von der Gemeinde".

---

## Warum es ohne `topic` funktioniert — und welches Format korrekt ist

### Die drei Lookups in `RefMapping.mergeRefData()`

Beim Auswerten von `allObjects(>Gemeinden95_V1_0.Gemeinden.Gemeinde)` ruft der Validator intern `getRefData(topic, scopes)` auf. Für jeden Scope macht `mergeRefData()` immer **drei Lookups** im internen Pool:

```
1. MappingKey(scope_from_query,  topic_from_query)   // exakter Match
2. MappingKey(scope_from_query,  null)               // kein Topic-Filter
3. MappingKey(null,              topic_from_query)   // kein Scope-Filter
```

Die `MappingKey.equals()`-Methode verwendet **Standard-Gleichheit** — `null` ist kein Wildcard, sondern muss explizit `null == null` sein.

### Ohne `topic` (topic weggelassen)

Der Eintrag wird als `MappingKey(null, null)` gespeichert.  
Weil der Basket keinen Scope hat, fragt der Validator mit `scope = null` ab.  
→ Lookup #2 ergibt `MappingKey(null, null)` → **Match** ✓

### Mit `topic="Gemeinden95_V1_0.Gemeinden"` (Punkt)

Gespeichert als `MappingKey(null, "Gemeinden95_V1_0.Gemeinden")`.  
Der Validator verwendet intern das **Doppelpunkt-Format** `"Gemeinden95_V1_0:Gemeinden"` (INTERLIS-Konvention für qualifizierte Namen).  
→ Lookup #3 fragt `MappingKey(null, "Gemeinden95_V1_0:Gemeinden")` ab  
→ `"Gemeinden95_V1_0:Gemeinden"` ≠ `"Gemeinden95_V1_0.Gemeinden"` → **kein Match** ✗

### Mit `topic="Gemeinden95_V1_0:Gemeinden"` (Doppelpunkt)

Gespeichert als `MappingKey(null, "Gemeinden95_V1_0:Gemeinden")`.  
→ Lookup #3 fragt `MappingKey(null, "Gemeinden95_V1_0:Gemeinden")` ab → **Match** ✓

### Empfehlung

| `topic`-Wert | Verhalten |
|---|---|
| *(weggelassen)* | Catch-all: Refdata gilt für alle Topics und alle Baskets |
| `Gemeinden95_V1_0:Gemeinden` (Doppelpunkt) | Korrekt: wird vom Validator-internen Format gefunden |
| `Gemeinden95_V1_0.Gemeinden` (Punkt) | **Falsch**: kein Match, Validator verwendet Doppelpunkt intern |

Für den DMAV-Fall (eine Gemeindeliste gilt für alle Baskets) ist **topic weglassen** die einfachste und korrekte Lösung. Für feingranulare Konfigurationen (verschiedene Refdata pro Topic) muss das Doppelpunkt-Format verwendet werden.

---

## `http://codes.interlis.ch/type/` — Werden diese Codes vom Validator geprüft?

**Kurz: Nein.** Die Type-Codes in `<categories>` der `ilidata.xml` werden beim Lookup **nicht gefiltert**.

### Was im ilivalidator-Sourcecode steht

Der gesamte ilivalidator-Source (GitHub `claeis/ilivalidator`) enthält nur **einen einzigen** hardcodierten Type-String:

```java
// CreateIliDataTool.java — nur beim *Erzeugen* von ilidata.xml:
private static final String CODES_TYPE_REFERENCE_DATA = "http://codes.interlis.ch/type/referenceData";
```

Das wird nur beim `--createIliData`-Tool verwendet, nicht beim Validieren.

### Wie der Lookup wirklich funktioniert

Wenn der Validator `ilidata:dmav_refdata_mapping` auflöst, macht `IliManager.getLocalCopyOfReposFile()` einen **einfachen BID-Lookup** — er sucht `<id>dmav_refdata_mapping</id>` in der `ilidata.xml`. Die `<categories>` mit dem Type-Code werden dabei ignoriert.

### Übersicht der konventionellen Typen

| Type-Code | Kennzeichnet | Verwendet vom Validator wenn |
|-----------|-------------|------------------------------|
| `http://codes.interlis.ch/type/metaconfig` | MetaConfig-INI-Datei | `--metaConfig ilidata:BID` oder `baseConfig=ilidata:BID` |
| `http://codes.interlis.ch/type/ilivalidatorconfig` | Validierungskonfig-INI | `--config ilidata:BID` oder `config=ilidata:BID` |
| `http://codes.interlis.ch/type/referenceData` | Referenzdaten-XTF | `--refdata ilidata:BID` oder `ch.interlis.referenceData=ilidata:BID` |
| `http://codes.interlis.ch/type/refDataMapping` | IliVRefData_V1_0-Mapping | `--refmapping ilidata:BID` oder `refmapping=ilidata:BID` |

### Fazit

Die Typen sind **reine Konvention** für Repository-Maintainer und Tools wie `ilimanager`. Der Validator findet einen Datensatz unabhängig vom gesetzten Type-Code — solange die `<id>` stimmt. Korrekte Type-Codes zu setzen ist trotzdem empfehlenswert für Lesbarkeit und Tool-Kompatibilität.

---

## Wie der Validator `refdata_mapping.xtf` findet

Das läuft über dieselbe ilidata-Lookup-Kette wie alle anderen Konfigurationseinträge.

### Schritt 1: MetaConfig wird geladen

Der Validator liest die MetaConfig-INI-Datei und findet unter `[ch.ehi.ilivalidator]`:
```ini
refmapping=ilidata:dmav_refdata_mapping
```

### Schritt 2: ilidata-Lookup für `dmav_refdata_mapping`

Der Validator sieht `ilidata:dmav_refdata_mapping` und sucht in `ilidata.xml` (im konfigurierten `modeldir = repositories/`) nach einem Eintrag mit `<id>dmav_refdata_mapping</id>`.

### Schritt 3: Eintrag in `ilidata.xml` gefunden

```xml
<DatasetIdx16.DataIndex.DatasetMetadata TID="97">
    <id>dmav_refdata_mapping</id>
    ...
    <path>refdata_mapping.xtf</path>
```

Der Pfad `refdata_mapping.xtf` ist relativ zum Repository-Verzeichnis (`repositories/`), also wird `repositories/refdata_mapping.xtf` geladen.

### Schritt 4: `refdata_mapping.xtf` wird verarbeitet

Der Validator liest das `IliVRefData_V1_0`-Mapping und weiss jetzt, welche Referenzdaten für welche Topics zu laden sind.

### Warum `ch.interlis.referenceData` nicht funktioniert

Der Unterschied zu `ch.interlis.referenceData=ilidata:dmav_Gemeinden95_V1_0` (das nicht funktioniert hatte) ist:
`refmapping` ist ein explizit unterstützter `[ch.ehi.ilivalidator]`-Parameter — der Validator macht für ihn aktiv eine ilidata-Suche.
`ch.interlis.referenceData` im `[CONFIGURATION]`-Abschnitt hingegen wird nur als Konfigurationswert gesetzt, ohne dass eine ilidata-Suche ausgelöst wird.
Die [CONFIGURATION]-Sektion (auch wenn sie leer ist) erzwingt den Verarbeitungsweg über Validator.java:216, der alle [ch.ehi.ilivalidator]-Parameter als ilidata-Lookups behandelt. Ohne sie nimmt der Validator einen vereinfachten Pfad, der refmapping ignoriert.
