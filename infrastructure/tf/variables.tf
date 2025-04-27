variable "project_id" {
    description = "The GCP project ID where the resources will be deployed."
    default     = ""
}

variable "region" {
    description = "The region to deploy the resources in."
    default = "europe-west1"
}

variable "service_name" {
    description = "The name of the service to be deployed."
    default = "asset-analysis-service"
}



variable "credentials_google_file" {
    description = "Path to the GCP credentials file."
    default     = ""
}

variable "service_account_email" {
    description = "The email of the service account."
    default     = "445748976210-compute@developer.gserviceaccount.com"
  
}

variable "gcp_kestra_sa_file"{
    description = "Path to the Kestra credentials file."
    default     = ""
}


variable "enable_bigquery_access" {
  description = "Whether to enable BigQuery write access for Kestra"
  type        = bool
  default     = false
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset to be created."
  default     = "asset_analysis_dataset"
  
}

variable "table_id" {
  description = "The ID of the BigQuery table to be created."
  default     = "asset_analysis_result"
  
}

variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "streamlit-vm"
}

variable "machine_type" {
  description = "VM machine type"
  type        = string
  default     = "e2-medium"
}

variable "repo_url" {
  description = "URL of the Git repository to clone"
  type        = string
  default     = "https://github.com/gioele-perri/Asset_analysis_dtc_de.git"
}

variable "kestra_url" {
  description = "URL di Kestra"
}

variable "private_ssh_key" {
  description = "Private SSH key for accessing the VM instance"
  default = "insert_your_private_key_path_here"
}

variable "user_ssh" {
  description = "SSH user for accessing the VM instance"
  default     = "ubuntu"
}