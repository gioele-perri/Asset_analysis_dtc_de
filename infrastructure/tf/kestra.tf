# Kestra flow creation
resource "kestra_flow" "asset_analysis_flow" {
  namespace = "your.project"
  flow_id = "asset-analysis"
  content = file("kestra/flows/asset-analysis.yml")
}


# Kestra KV creation
resource "kestra_kv" "GCP_BQ_DATASET" {
  namespace = "your.project"
  key       = "GCP_BQ_DATASET"
  value     = var.dataset_id
  type      = "STRING"
}


resource "kestra_kv" "GCP_PROJECT_ID" {
  namespace = "your.project"
  key       = "GCP_PROJECT_ID"
  value     = var.project_id
  type      = "STRING"
}

resource "kestra_kv" "GCP_CREDENTIALS" {
  namespace = "your.project"
  key       = "GCP_CREDENTIALS"
  value     = file(var.gcp_kestra_sa_file)
  type      = "JSON"
}


resource "kestra_kv" "GCP_BQ_TABLE_NAME" {
  namespace = "your.project"
  key       = "GCP_BQ_TABLE_NAME"
  value     = var.table_id
  type      = "STRING"
}
