# DMAV GWR-Test ilivalidator

## Installation

ilivalidator:
interne Snapshot-Version `ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT`

ilivalid-gwr:
https://jars.interlis.ch/ch/interlis/ilivalid-gwr/1.0.0-SNAPSHOT/

Wichtig:
ilivalid-gwr ist ein Plugin für ilivalidator
benötigt die Ressource sqlite-jdbc-3.43.0.0.jar im selben Verzeichnis wie die ilivalid-gwr-1.0.0-SNAPSHOT.jar

## Constraint (Beispiel)

```
MANDATORY CONSTRAINT GWRC02a : DEFINED(EGID) => IliValidGwr_V1_0.egidExistsInGWR(EGID,PARAMETER IliVRuntime_V1_0.Scope);
```

PARAMETER `IliVRuntime_V1_0.Scope` definiert den spezifischen Scope der Validierung. zB. 449 für Gemeinde und matcht zum RefData-Matching:

```
<IliVRefData_V1_0:RefData ili:tid="449_5">
     <IliVRefData_V1_0:ignore>false</IliVRefData_V1_0:ignore>
     <IliVRefData_V1_0:scope>449</IliVRefData_V1_0:scope>
     <IliVRefData_V1_0:refdata>ilidata:dmav_OfficialIndesOfLocalities</IliVRefData_V1_0:refdata>
</IliVRefData_V1_0:RefData>
```

benötigt Modellreferenzen
```
IMPORTS UNQUALIFIED IliValidGwr_V1_0;
IMPORTS UNQUALIFIED IliVRuntime_V1_0;
```


## Aufruf ilivalidator

```
java -jar "C:\Program Files\INTERLIS\ilivalidator\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar" --metaConfig .\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini --scope 449 --modeldir "./repositories"  .\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1.xtf
```

Ergebnis:
```
Error: line 257098: DMAV_Bodenbedeckung_V1_1.Bodenbedeckung.Bodenbedeckung: tid ff64265b-45e0-4b3b-9136-f56dcbcc30e6: (GWRC02a) EGID existiert nicht im GWR
Error: line 303989: DMAV_Bodenbedeckung_V1_1.Bodenbedeckung.Bodenbedeckung: tid ff9ea53b-f742-4ce8-8b14-0029e67edbb6: (GWRC02a) EGID existiert nicht im GWR
```

## Weitere Hinweise

Der Download der GWR-Datenbank ch.zip-data.sqlite erfolgt nach C:\Users\ogrimm\.ilicache\https&003a&002f&002fpublic.madd.bfs.admin.ch&002fch.zip