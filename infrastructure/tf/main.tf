terraform {
  required_providers {
    kestra = {
      source = "kestra-io/kestra"
      version = "0.22.0"
    }
  }
}

provider "kestra" {
  url = "http://localhost:8080"
}

provider "google" {
  credentials = file(var.credentials_google_file)
  project = var.project_id
  region  = var.region
}


