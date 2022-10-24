resource google_cloud_run_service self {
  name     = "cloudrun-test"
  location = "europe-west2"
#  project  = "test-project"
  project = "cryptotraders-platform-test"

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

module test_lb {
  source  = "../../gcp/compute_engine/serverless_neg_https_lb"
#  project = "test-project"
  project = "cryptotraders-platform-test"
  region = "europe-west2"
  serverless_neg_name = "serverless-neg"
  cloud_run = [{ service = google_cloud_run_service.self.name }]

  serverless_https_lb_name = "serverless-lb"
  managed_ssl_certificate_domains = [ "test.project.com" ]

  security_policy = "cryptotraders-cloudrun-policy"
#  serverless_https_lb_backends = {
#    cloudrun = {
#      description = "Cloud Run backend"
#      security_policy = "cryptotraders-cloudrun-policy"
#      groups = [
#        {
#          group = "projects/cryptotraders-platform-test/regions/europe-west2/networkEndpointGroups/serverless-neg"
#        }
#      ]
#      iap_config = {
#        enable = false
#      }
#      log_config = {
#        enable = false
#      }
#    }
#  }
}
