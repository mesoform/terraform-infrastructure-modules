resource "google_cloud_run_service" "self" {
  name     = "cloudrun-test"
  location = "europe-west2"
  project  = "project-test"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = google_cloud_run_service.self.location
  project  = google_cloud_run_service.self.project
  service  = google_cloud_run_service.self.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

module https-lb-serverless-neg-cloudrun {
  source = "../../gcp/compute_engine/cloudrun_https_lb_serverless_neg"
  cloudrun_lb_projectid  = "project-test"
  cloudrun_lb_region = "europe-west2"
  cloudrun_lb_domain = "test.project.com"
  cloudrun_lb_name = "cloudrun-lb"
  cloudrun_lb_ssl = "true"
  cloudrun_service_name = google_cloud_run_service.self.name
}
