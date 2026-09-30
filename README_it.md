# Validazione DMAV con ilivalidator
Implementazione delle regole di controllo ufficiali relative al modello di dati della misurazione ufficiale (DMAV) versione 1.1 con ilivalidator. In questo progetto vengono verificati i seguenti due tipi di constraints per i modelli DMAV con ilivalidator:
* constraints INTERLIS nativi: constraints formulati direttamente nei modelli
* constraints INTERLIS non nativi: nei modelli di validazione aggiuntivi sono formulati ulteriori constraints. Esistono i seguenti modelli aggiuntivi:
  * DMAV_V1_1_Bodenbedeckung_Validierung
  * DMAV_V1_1_Einzelobjekte_Validierung
  * DMAV_V1_1_FixpunkteKategorie3_Validierung
  * DMAV_V1_1_Gebaeudeadressen_Validierung
  * DMAV_V1_1_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_1_Nomenklatur_Validierung
  * DMAV_V1_1_Rohrleitungen_Validierung
  * DMAV_V1_1_Toleranzstufen_Validierung

Nel progetto https://github.com/geostandards-ch/DMAV-Testsuite questi due tipi di constraints sono stati verificati con i casi di errore.

I controlli tra modelli con i dati dei servizi web (punti fissi PFP1/PFA1/PFP2, confini nazionali, elenco dei comuni, elenco ufficiale delle località) sono integrati come dati di riferimento. I controlli rispetto al REA (GWR) vengono eseguiti tramite il plugin `ilivalid-gwr`.

## Utilizzo via ilicop
L'ultima versione è disponibile su https://dmav.ilicop.ch/ e può essere utilizzata tramite l'interfaccia di ilicop.
Per convalidare le regole di controllo aggiuntive, è necessario selezionare il profilo 'DMAV mit Zusatzanforderungen':
<br/>
<br/>
<img width="1645" height="485" alt="image" src="https://github.com/user-attachments/assets/65a69894-c322-41eb-908f-ea321bb562b5" />
<br/>
> [!TIP]
> Attualmente esiste un limite di grandezza per i file XTF pari a 200 MB. I file XTF più grandi possono essere compressi in formato ZIP prima del caricamento. Ilicop accetta file XTF e ZIP per il caricamento.

## Struttura del repository
```
ilitools/                       ilivalidator (versione snapshot interna) con libs
  plugins/                      plugin ilivalid-gwr + sqlite-jdbc (caricati automaticamente)
repositories/                   repository locale di modelli e dati (--modeldir)
  ilimodels.xml                 elenco dei modelli (generato con ilimanager)
  ilidata.xml                   elenco delle configurazioni e dei dati di riferimento (ilidata:<id>)
  refdata_mapping.xtf           assegnazione topic/scope --> dati di riferimento
  dmav_V1_1/
    *_MetaConfig_*.ini          punti di ingresso per --metaConfig
    *_Config_*.ini              configurazione ilivalidator (additionalModels, messaggi)
    official_models/            modelli ufficiali DMAV V1.1 e modelli dei servizi web
    validation_models/          modelli di validazione aggiuntivi
    internal_models/            modelli ausiliari (funzioni, RefData, GWR)
    refdata/                    dati di riferimento (dati dei servizi web)
data/dmav_V1_1/test_data/       dataset di test (log in logs/, non versionati)
notes/                          note di lavoro e documentazione (in tedesco)
```

Sono disponibili due profili:

| Profilo | MetaConfig | Contenuto |
|---------|------------|-----------|
| plain | `DMAV_V1_1_Validierung_MetaConfig_plain.ini` | solo struttura INTERLIS e constraints nativi |
| con regole aggiuntive | `DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini` | in aggiunta tutti i modelli di validazione, i dati di riferimento e i controlli REA |

## Installazione
Nella sezione [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases) sono disponibili gli oggetti di distribuzione più recenti. Questi possono essere utilizzati per un'installazione locale. È necessario scaricare i file e decomprimerli in una directory con diritti di lettura e scrittura.

In alternativa è possibile clonare il repository. A causa delle dimensioni, l'elenco ufficiale delle località (`OfficialIndexOfLocalities_V1_0.xtf`) non è versionato e deve essere scaricato separatamente in `repositories/dmav_V1_1/refdata/` (fonti vedi [notes/Doku_ConfigRefData_Teamcamp.md](notes/Doku_ConfigRefData_Teamcamp.md#download-der-webdienstdaten)).

### Prerequisiti di sistema
Prerequisiti di sistema: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

Per i controlli REA è inoltre necessario un accesso a Internet: al primo avvio il plugin scarica la banca dati del REA (`ch.zip` da public.madd.bfs.admin.ch) e la salva nella cache in `%USERPROFILE%\.ilicache\`.

### Richieste relative ai file XTF
vedi anche sezione [Questioni aperte](#questioni-aperte--limiti-della-realizzazione-attuale)
* Compatibile con i modelli attuali (secondo `repositories/dmav_V1_1/official_models`)
* Per i test tra modelli, tutti i topic del modello `DMAVTYM_Alles_V1_1` devono essere inclusi nella fornitura
* I dati dei servizi web non devono essere inclusi nella fornitura; vengono integrati come dati di riferimento tramite `refdata_mapping.xtf`

### Lancio
**Profilo plain**
```
java -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_plain.ini ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

**Profilo con regole aggiuntive**
```
java --enable-native-access=ALL-UNNAMED -jar ilitools\ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar ^
  --metaConfig repositories\dmav_V1_1\DMAV_V1_1_Validierung_MetaConfig_with_additional_rules.ini ^
  --refmapping [repoDir]\repositories\refdata_mapping.xtf ^
  --scope [N. UST] ^
  --modeldir repositories ^
  --log [logDir]\MyXTF.log ^
  [myXTFDir]\MyXTF.xtf
```

| Parametro | Significato |
|-----------|-------------|
| `--metaConfig` | profilo (vedi sopra) |
| `--refmapping` | assegnazione dei dati di riferimento. Deve essere indicato come percorso diretto del file (`ilidata:` non viene risolto) |
| `--scope` | numero UST del comune. Determina quali dati di riferimento di `refdata_mapping.xtf` vengono caricati e funge da filtro comunale per i controlli REA |
| `--modeldir` | percorso della directory `repositories` |
| `--enable-native-access=ALL-UNNAMED` | a partire da Java 24 sopprime l'avviso del driver sqlite (plugin REA) |

Altri esempi con i dati di test vedi [Aufruf_cmd.md](Aufruf_cmd.md). Documentazione completa ilivalidator: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung

## Rapporti di bug e richieste per nuove funzionalità
I bug e le richieste di funzionalità relative alla convalida di DMAV con ilivalidator possono essere registrati nella sezione **Issues**. Le issue riportate possono essere trasferite ad altri repository durante l'elaborazione (vedi [Fonte](#fonte)).

## Questioni aperte / Limiti della realizzazione attuale
* **Constraints REA:** parzialmente implementati (plugin `ilivalid-gwr`, versione snapshot). Alcuni controlli sono ancora in fase di elaborazione o commentati nel modello di validazione.
* **Dati di riferimento:** `refdata_mapping.xtf` contiene attualmente solo voci per il comune di test (scope 449). Per altri comuni occorre completare le voci e i dati di riferimento corrispondenti.
* **Dati dei servizi web:** integrati come file statici (`repositories/dmav_V1_1/refdata/`), non direttamente tramite i servizi web. Gli aggiornamenti devono essere effettuati manualmente.
* **Test dei confini con dati di riferimento** (confini nazionali): i dati di riferimento sono integrati, i controlli non sono ancora implementati.
* La versione di ilivalidator richiesta è una versione snapshot interna (`ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT`).

## Fonte
* Repository modelli aggiuntivi: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
* Plugin ilivalid-gwr: https://jars.interlis.ch/ch/interlis/ilivalid-gwr/1.0.0-SNAPSHOT/
* Documentazione del modello e FAQ DMAV: https://www.cadastre-manual.admin.ch (Manuale della misurazione ufficiale > Modello di geodati DMAV)
