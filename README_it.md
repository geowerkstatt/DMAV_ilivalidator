# Validazione DMAV con ilivalidator
Implementazione delle regole di controllo ufficiali relative al modello di dati della misurazione ufficiale (DMAV) con ilivalidator. Con ilivalidator vengono verificati i seguenti due tipi di constraints:
* constraints INTERLIS nativi: constraints formulati direttamente nei modelli
* constraints INTERLIS non nativi: nei modelli di validazione aggiuntivi sono formulati ulteriori constraints. Esistono i seguenti modelli aggiuntivi:
  * DMAV_V1_0_Bodenbedeckung_Validierung
  * DMAV_V1_0_Einzelobjekte_Validierung
  * DMAV_V1_0_FixpunkteKategorie3_Validierung
  * DMAV_V1_0_Gebaeudeadressen_Validierung
  * DMAV_V1_0_Grundstuecke_Validierung
  * DMAV_V1_0_HoheitsgrenzenAV_Validierung
  * DMAV_V1_0_Nomenklatur_Validierung
  * DMAV_V1_0_Rohrleitungen_Validierung
  * DMAV_V1_0_Toleranzstufen_Validierung
 
Nel progetto https://github.com/geostandards-ch/DMAV-Testsuite questi due tipi di vincoli sono stati verificati con i casi di errore.

## Utilizzo via ilicop
L'ultima versione è disponibile su https://dmav.ilicop.ch/ e può essere utilizzata tramite l'interfaccia di ilicop.

## Installazione
Nella sezione [Releases](https://github.com/geowerkstatt/DMAV_ilivalidator/releases) sono disponibili gli oggetti di distribuzione più recenti. Questi possono essere utilizzati per un'installazione locale. È necessario scaricare i file e decomprimerli in una directory con diritti di lettura e scrittura.

### Prerequisiti di sistema
Prerequisiti di sistema: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#laufzeitanforderungen

### Richieste relative ai file XTF
vedi anche sezione [Questioni aperte](#questioni-aperte--limiti-della-realizzazione-attuale)
* Compatibile con i modelli attuali (secondo ilimodels\official_DMAV_models)
* I dati del servizio web devono essere inclusi nella fornitura
* Per i test cross-modello, tutti gli argomenti del modello DMAVTYM_Alles_V1_0 devono essere inclusi nella fornitura

### Lancio
```
java -jar [ilivalidatorDir]\ilivalidator-x.xx.x.jar --config [configDir]\DMAV_V1_0_Validierung_Alle_Modelle.ini --modeldir %ITF_DIR;http://models.interlis.ch/;[modelDir] [myXTFDir]\MyXTF.xtf
```
Documentazione completa ilivalidator: https://github.com/claeis/ilivalidator/blob/master/docs/ilivalidator.rst#ilivalidator-anleitung 

## Rapporti di bug e richieste per nuove funzionalità
I bug e le richieste di funzionalità relative alla convalida di DMAV con ilivalidator possono essere registrati nella sezione **Issues**. Le issue riportate possono essere trasferite ad altri repository durante l'elaborazione (vedi [Fonte](#fonte)).

## Questioni aperte / Limiti della realizzazione attuale
Attualmente, i seguenti tipi di constraints non nativi e requisiti per la validazione DMAV non sono ancora supportati:
* constraints GWR
* Integrazione dei dati di servizio (devono essere inclusi nella fornitura come dati statici)
* Verificazione rispetto ad altre fonti di dati
  * Lista di tutti i comuni (Name/BFSNr)
  * Confini territoriali

## Fonte
* Repository modelli aggiuntivi: https://github.com/geostandards-ch/DMAV-Validierungsmodell
* Repository ilitools: https://github.com/claeis/ilivalidator
* Repository DMAV-Testsuite: https://github.com/geostandards-ch/DMAV-Testsuite
