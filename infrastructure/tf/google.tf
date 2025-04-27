
resource "google_compute_instance" "streamlit_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240415"  # Ubuntu 22.04 LTS
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

  metadata_startup_script = file("${path.module}/scripts/setup.sh")

  tags = ["streamlit-server"]
}

# Firewall rules for Streamlit (8501), Kestra (8080), and PostgreSQL (5432)
resource "google_compute_firewall" "allow_app_ports" {
  name    = "allow-streamlit-kestra"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8501", "8080", "5432"]
  }

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