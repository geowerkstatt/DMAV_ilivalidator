Create ilimodels
java -jar c:\INTERLIS\V14_5_0\ilimanager\ilimanager-0.9.2-SNAPSHOT.jar --createIliModels --out "./ilimodels.xml" --repos "./repositories"

**Vailidierung plain**
Hier wird rein die INTERLIS-Struktur geprüft und keine zusätzlichen Validierungen gemacht.

***Erfolgreicher Aufruf für beide Datensätze***

```jar
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini  --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1_withError.xtf 
```
```jar
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini  --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1_noError.xtf   
```

**Validierung mit Zusatzregeln**

***Mit Fehlern aus den Zusatzprüfungen***

```jar
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini --refmapping C:/Data/03_GIT_Repos/DMAV_ilivalidator/DMAV_ilivalidator/repositories/refdata_mapping.xtf --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --scope 449 --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1_withError.xtf
```

***Ohne Fehler aus Zusatzprüfungen***
```jar
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini --refmapping C:/Data/03_GIT_Repos/DMAV_ilivalidator/DMAV_ilivalidator/repositories/refdata_mapping.xtf --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --scope 449 --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1_noError.xtf
```