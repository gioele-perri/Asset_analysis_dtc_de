#!/bin/bash

set -e  

# Step 1: Deploy delle risorse che servono a Kestra
terraform apply -target=google_compute_instance.streamlit_vm -target=google_compute_firewall.allow_app_ports -auto-approve

# Step 2: Deploy Kestra
terraform apply -target=google_cloud_run_service.kestra -auto-approve

# Step 3: Recupera URL Kestra
KESRA_URL=$(terraform output -raw kestra_url)

echo "KESRA_URL trovato: $KESRA_URL"

# Step 4: Deploy delle risorse dipendenti da Kestra
terraform apply -var="kestra_url=$KESRA_URL" -auto-approve
