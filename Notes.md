Create ilimodels
java -jar c:\INTERLIS\V14_5_0\ilimanager\ilimanager-0.9.2-SNAPSHOT.jar --createIliModels --out "./ilimodels.xml" --repos "./repositories"

Vailidierung plain
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini  --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1.xtf   


Validierung mit Zusatzregeln
java -jar ./ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar --metaConfig c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini  --log c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\logs\DMAVTYM_Alles_V1_1.log --modeldir c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\repositories c:\Data\03_GIT_Repos\DMAV_ilivalidator\DMAV_ilivalidator\data\dmav_V1_1\test_data\DMAVTYM_Alles_V1_1.xtf
