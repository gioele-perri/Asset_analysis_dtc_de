#!/bin/bash

# Crea un nuovo utente con permessi di sudo e la possibilità di installare software
#NEW_USER="mng"  # Cambia questo nome con il nome utente che desideri creare
#NEW_USER_PASSWORD="psw"
# Crea l'utente
#sudo useradd -m -s /bin/bash $NEW_USER
#echo "$NEW_USER:$NEW_USER_PASSWORD" | sudo chpasswd
# Aggiungi l'utente ai gruppi 'sudo' (per permessi di amministratore) e 'docker' (per Docker)
#sudo usermod -aG sudo $NEW_USER

#echo $NEW_USER

# Concedi i permessi per creare cartelle e installare software
#sudo mkdir -p /home/$NEW_USER/folder
#sudo chown $NEW_USER:$NEW_USER /home/$NEW_USER/folder
#su - $NEW_USER
#echo "Logged in as $NEW_USER"

$FLD = "ws"
# Install Docker
sudo mkdir /home/$FLD
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
sudo apt-get install docker-compose -y
#sudo gpasswd -a $USER docker
#newgrp docker


# Recupera il link della repository dai metadati della VM
REPO_URL=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo_url" -H "Metadata-Flavor: Google")

# Clona il repository
git clone "$REPO_URL" /home/$FLD/app
cd /home/$FLD/app

docker-compose up -d

echo "======================================"
echo "Apps deployed successfully!"
echo "Streamlit: http://$(curl -s ifconfig.me):8501"
echo "Kestra:    http://$(curl -s ifconfig.me):8080"
echo "======================================"
