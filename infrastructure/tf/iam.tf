# IAM permissions for the service accounts to access Google Cloud resources

resource "google_project_iam_member" "compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${var.service_account_email}"
}


resource "google_project_iam_member" "kestra_bigquery_data_editor" {
  project = "pure-tribute-457710-m1"
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:kestra-workflow@pure-tribute-457710-m1.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "kestra_bigquery_job" {
  project = "pure-tribute-457710-m1"
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:kestra-workflow@pure-tribute-457710-m1.iam.gserviceaccount.com"
}


resource "google_service_account" "kestra_sa" {
  account_id   = "kestra-workflow"
  display_name = "Kestra Workflow Service Account"
}

resource "google_project_iam_member" "kestra_gcs" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.kestra_sa.email}"
}

resource "google_project_iam_member" "kestra_bq" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.kestra_sa.email}"
}
