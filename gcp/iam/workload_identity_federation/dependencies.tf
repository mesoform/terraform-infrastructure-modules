data google_project self {
  project_id = var.project_id
}

locals {
  default_audience = "https://iam.googleapis.com/projects/${data.google_project.self.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.self.id}/providers/%s"
}