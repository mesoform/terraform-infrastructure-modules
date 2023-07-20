provider google {
  project = "test-project"
}

resource google_cloud_run_service self {
  name     = "cloudrun-test"
  location = "europe-west2"
  project  = "test-project"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
}

resource google_cloud_run_service_iam_member public-access {
  location = google_cloud_run_service.self.location
  project  = google_cloud_run_service.self.project
  service  = google_cloud_run_service.self.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

module cloudrun_serverless_https_lb {
  source  = "../../gcp/compute_engine/cloudrun_serverless_neg_https_lb"
  project = "test-project"
  region = "europe-west2"
  serverless_neg_name = "cr-serverless-neg"
  cloudrun_service_name = google_cloud_run_service.self.name

  name = "serverless-lb"
  ssl = true
  managed_ssl_certificate_domains = [ "test.project.com" ]

  backends = {
    cloudrun = {
      description = "Cloud Run backend"
      security_policy = "cloudrun-policy"
      groups = [
        {
          group = "projects/test-project/regions/europe-west2/networkEndpointGroups/cr-serverless-neg"
        }
      ]
      log_config = {
        enable = false
        sample_rate = null
      }
    }
  }
}
