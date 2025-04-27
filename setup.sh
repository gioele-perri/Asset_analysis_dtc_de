#!/bin/bash


# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo gpasswd -a $USER docker
newgrp docker
sudo apt-get install docker-compose -y

# Recupera il link della repository dai metadati della VM
REPO_URL=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo_url" -H "Metadata-Flavor: Google")

# Clona il repository
git clone "$REPO_URL" /home/$USER/app
cd /home/$USER/app

docker-compose up -d

echo "======================================"
echo "Apps deployed successfully!"
echo "Streamlit: http://$(curl -s ifconfig.me):8501"
echo "Kestra:    http://$(curl -s ifconfig.me):8080"
echo "======================================"
