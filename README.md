> 🇮🇹 This README is also available in [Italiano](README.md).

# Financial Asset Metrics Dashboard

## Table of Contents

- [Description](#description)
- [Main Sections](#main-sections)
  - [Asset Behavioral Analysis](#asset-behavioral-analysis)
  - [Market Analysis](#market-analysis)
- [Architecture and Technology](#architecture-and-technology)
  - [Data Processing](#data-processing)
  - [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
  - [Containerization](#containerization)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Variables to Define](#variables-to-define)
  - [Local Execution](#local-execution)
- [Deploy](#deploy)

---

## Description

This project focuses on analyzing financial asset metrics, with a focus on U.S. markets.  
The dashboard offers two main sections, allowing users to gain detailed insights into asset behavior and overall market conditions:

### Main Sections:

1. **Asset Behavioral Analysis**:
   This section enables the analysis of historical financial asset data (through ticker symbols).  
   Using Yahoo Finance data, it calculates several statistical metrics, including:
   - Price trends across weekdays
   - Standard deviation of prices
   Users can input their desired tickers, and the dashboard will automatically compute these metrics over an aggregated time window.

2. **Market Analysis**:
   This section provides an overview of the general state of some of the most significant U.S. market assets.  
   It analyzes historical data and computes financial parameters such as the **Sharpe Ratio**.  
   The data is aggregated by period and displayed to allow easy comparison between different assets.  
   The data warehouse stores 10 years of historical data, all retrieved from Yahoo Finance.

---

## Architecture and Technology

![project](https://github.com/user-attachments/assets/94ab2564-1afd-4ad8-9b3e-09008aa854bc)

### Data Processing

- **Asset Behavioral Analysis**:
  - Data is batch extracted through the Yahoo Finance API.
  - Using the **Pandas** library, the data is transformed to calculate the necessary statistical metrics, which are then visualized through graphs.

- **Market Analysis**:
  - Data is retrieved every evening using the **Kestra** orchestrator, which loads the data into the **BigQuery** data warehouse.
  - The historical metrics are then visualized using **Looker Studio**.

### Infrastructure as Code (IaC)

The infrastructure is managed through **Terraform**, allowing the entire cloud environment to be defined as code, simplifying provisioning and deployment of Kestra and Google Cloud Platform (GCP) services.

### Containerization

The project is fully containerized using **Docker**.  
This allows the project to run in any environment, facilitating deployment and local execution.

---

## Installation

### Prerequisites
- **Google Cloud Platform (GCP)** account with the appropriate permissions for BigQuery and Google Cloud Storage.
- **Kestra** for workflow orchestration.
- **Docker** for project containerization.
- **Terraform** for infrastructure management.

### Variables to Define

- **variables.tf**: Contains the necessary variables for configuring the GCP and Kestra environment.
- **Kestra Variables**: Some specific Kestra variables are required to correctly configure task orchestration.
- **Looker Dashboard Link**: Insert the embedded Looker dashboard link in `app/variables.json`.

> **Attention**: Ensure that Google Cloud is correctly configured with proper access permissions. Terraform will automatically create all resources and set up IAM roles.  
Some additional project roles might need to be manually granted to the Terraform service account to allow full IAM management.

### Local Execution

> **Attention**: When running the project locally, only the **Streamlit** + **Pandas** (Asset Behavioral Analysis) part of the dashboard will be deployed.  
Kestra will still start, but without active configurations. The Warehousing section requires Google Cloud BigQuery.

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/financial-metrics-dashboard.git
    cd financial-metrics-dashboard
    ```

2. To start the project locally, run:
    ```bash
    pip install streamlit
    streamlit run ./main.py
    ```

   Or alternatively, using Docker:
    ```bash
    cd ./app
    docker-compose up 
    ```

**If you want to run Kestra locally** to view the flow (note: it will not work if you don't have Google Cloud Run or a similar environment):

    ```bash
    cd ./kestra
    docker-compose up 
    ```
> **Important Note**: To upload the flow to Kestra:
- Copy the content of the files inside the `kestra/flow` folder and configure them accordingly.

---

## Deploy

To deploy to a production environment:

1. **Google Cloud Settings**:
   - Create a service account and download the JSON credential file.
   - Set your SSH connection. Generate a key pair in your pc and store your public key in GCP

2. **Deploy using Terraform**:
   - Use Terraform to deploy the infrastructure and related services.

3. **After installing Terraform**:
    ```bash
    cd ./infrastructure/tf
    terraform init
    terraform apply -target="google_compute_instance.streamlit_vm" -target="google_compute_firewall.default"

    Kestra URL prompt : do not insert anything and press Enter

    terraform apply
    ```
> **Gentle reminder**:  
Ensure you have defined all variables inside `variables.tf` and set the Looker embed URL inside `variables.json`.
ter