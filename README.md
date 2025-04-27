# Financial Asset Metrics Dashboard

## Descrizione

Il progetto è dedicato all'analisi delle metriche degli asset finanziari, con un focus sui mercati statunitensi. La dashboard fornisce due sezioni principali che permettono agli utenti di ottenere informazioni dettagliate riguardo il comportamento degli asset e lo stato del mercato:

### Sezioni principali:

1. **Asset Behavioral Analysis**:
   Questa sezione permette di analizzare i dati storici degli asset finanziari (tramite ticker). Utilizzando i dati di Yahoo Finance, vengono calcolate alcune metriche statistiche, tra cui:
   - Tendenza dei prezzi nei giorni della settimana
   - Deviazione standard dei prezzi
   Gli utenti possono inserire i ticker desiderati e la dashboard calcola automaticamente queste metriche su una dimensione temporale aggregata.

2. **Market Analysis**:
   La seconda sezione fornisce una panoramica sullo stato generale di alcuni degli asset più significativi del mercato USA. Analizza i dati storici e calcola parametri finanziari come lo **Sharp Ratio**. I dati vengono aggregati per periodo e visualizzati in modo da permettere un confronto tra diversi asset.
   Il data warehouse contiene 10 anni di dati storici, sempre prelevati da Yahoo Finance.

---

## Architettura e Tecnologia

[Project architetcture generated with Lucidchart](project.png)


### Processamento Dati

- **Asset Behavioral Analysis**:
  - I dati vengono estratti in batch tramite l'API di Yahoo Finance.
  - Utilizzando la libreria **Pandas**, i dati vengono trasformati per calcolare le metriche statistiche necessarie, che vengono poi visualizzate in grafici.

- **Market Analysis**:
  - I dati vengono prelevati ogni sera utilizzando l'orchestratore **Kestra**, che carica i dati nel data warehouse **BigQuery**.
  - Le metriche calcolate sui dati storici vengono visualizzate tramite **Looker Studio**.

### Infrastructure as Code (IaC)

L'infrastruttura è configurata con **Terraform**, che permette di gestire l'intera infrastruttura come codice, semplificando il processo di provisioning e deployment dei servizi di Kestra e Google Cloud Platform (GCP).

### Containerizzazione

Il progetto è completamente containerizzato utilizzando **Docker**. Questo consente di eseguire il progetto in qualsiasi ambiente, facilitando il deployment e l'esecuzione locale.

---

## Installazione

### Prerequisiti
- **Google Cloud Platform (GCP)** account con permessi adeguati per BigQuery e Google Cloud Storage.
- **Kestra** per l'orchestrazione dei flussi di lavoro.
- **Docker** per la containerizzazione del progetto.
- **Terraform** per la gestione dell'infrastruttura.

### Variabili da Definire

- **variables.tf**: Contiene le variabili necessarie per la configurazione dell'ambiente GCP e Kestra.
- **Kestra Variables**: Alcune variabili specifiche per Kestra sono necessarie per configurare correttamente l'orchestrazione dei task.
- **Link Dashboard looker**: Inserire il link embedded della dashboard looker in app/variables.json

> **Attenzione**:  Assicurati di avere configurato correttamente Google Cloud e i permessi per l'accesso. Terraform si occuperà di creare tutte le risore e settare la sezione IAM. Potrebbe essere necessario garantire alcuni ruoli di modifica sul progetto al service account di terraform, in modo da consetire la gestione IAM.


### Esecuzione Locale

> **Attenzione**: Quando esegui il progetto in locale, verrà deployata solamente la parte **Streamlit** + **Pandas** (Asset Behavioral Analysis) della dashboard. Kestra verrà comunque avviato, ma senza configurazioni. La sezione Warehousing necessita di Google Cloud BigQuery

1. Clona il repository:
    ```bash
    git clone https://github.com/tuo-username/financial-metrics-dashboard.git
    cd financial-metrics-dashboard
    ```

2. Per avviare il progetto in locale, esegui lo script:
    ```bash
    pip install streamlit
    streamlit run ./main.py
    ```

   O in alternativa se preferisci l'esecuzione docker locale
    ```bash
    cd ./app
    docker-compose up 
    ```

**Se vuoi avviare kestra in locale** per visualizzare il flusso (non funzionerà se non hai Google cloud run) o l'orchestrator
    ```bash
    cd ./kestra
    docker-compose up 
    ```
    > **Nota Importante**: Per caricare il flusso su kestra:
    - Copia il contenuto del file nella cartella `kestra/flow` e configurandolo di conseguenza.



---

## Deploy

Per il deploy su un ambiente di produzione, segui i seguenti passaggi:

1. **Impostazioni Google Cloud**:
   - Crea un account di servizio e scarica il file JSON delle credenziali.

2. **Esegui il deploy tramite Terraform**:
   - Utilizza Terraform per eseguire il deploy dell'infrastruttura e dei servizi associati.

3. **Dopo aver installato terraform sul tuo computer**:
    ```bash
    cd ./infrastructure/tf
    terraform init
    terraform apply
    ```
    > **Gentle reminder**: Assicurati di aver definito le variabili nel file variables.tf e l'embed url looker in variables.json