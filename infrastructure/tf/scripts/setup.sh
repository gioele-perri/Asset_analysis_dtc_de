#!/bin/bash

# Install Docker
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER

# Recupera il link della repository dai metadati della VM
REPO_URL=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo_url" -H "Metadata-Flavor: Google")

if [ -z "$REPO_URL" ]; then
  echo "Errore: Il link della repository non è stato fornito."
  exit 1
fi

# Clona il repository
git clone "$REPO_URL" /home/$USER/app
cd /home/$USER/app

docker-compose up -d

echo "======================================"
echo "Apps deployed successfully!"
echo "Streamlit: http://$(curl -s ifconfig.me):8501"
echo "Kestra:    http://$(curl -s ifconfig.me):8080"
echo "======================================"