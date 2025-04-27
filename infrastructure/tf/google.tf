
resource "google_compute_instance" "streamlit_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20250415"  # Ubuntu 22.04 LTS
      size  = 30  # GB
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Assigns a public IP
  }

    metadata = {
    repo_url = var.repo_url
  }

   provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = google_compute_instance.streamlit_vm.network_interface.0.access_config.0.nat_ip
      user        = "var.p" 
      private_key = file(var.private_ssh_key)
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io git",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/2.20.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "git clone ${var.repo_url} /home/${var.user_ssh}/app",
      "cd /home/${var.user_ssh}/app",
      "sudo docker-compose up -d"
    ]
  }
  tags = ["streamlit-server"]
}

# Firewall rules for Streamlit (8501), Kestra (8080), and PostgreSQL (5432)
resource "google_compute_firewall" "default" {
  name    = "allow-streamlit-kestra"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8501", "8080", "5432"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["streamlit-server"]
}


# BigQuery Dataset and Table Creation
resource "google_bigquery_dataset" "asset_analysis_dataset" {
  dataset_id = var.dataset_id
  project    = var.project_id
  location   = var.region
}


resource "google_bigquery_table" "asset_analysis_table" {
  dataset_id = google_bigquery_dataset.asset_analysis_dataset.dataset_id
  table_id   = var.table_id
  project    = var.project_id

  schema = jsonencode([
    {
      name = "Ticker"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "Mean_Return"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "Volatility"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "Year"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "Month"
      type = "INTEGER"
      mode = "NULLABLE"
    }
  ])
}