resource google_cloud_run_service test1 {
  name     = "cloudrun-test1"
  location = "europe-west1"
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

resource google_cloud_run_service test2 {
  name     = "cloudrun-test2"
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

resource google_cloud_run_service_iam_member public-access-test1 {
  location = google_cloud_run_service.test1.location
  project  = google_cloud_run_service.test1.project
  service  = google_cloud_run_service.test1.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource google_cloud_run_service_iam_member public-access-test2 {
  location = google_cloud_run_service.test2.location
  project  = google_cloud_run_service.test2.project
  service  = google_cloud_run_service.test2.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

module test_lb {
  source  = "../../gcp/compute_engine/serverless_neg_https_lb"
#  project = "test-project"
  project = "cryptotraders-platform-test"
  region = "europe-west2"
  serverless_neg_name = "serverless-neg"
#  cloud_run_services = { service_name = google_cloud_run_service.self.name }
  cloud_run_services = [
    { service_name = "cloudrun-test1", region = "europe-west1" },
    { service_name = "cloudrun-test2", region = "europe-west2" }
  ]
  serverless_https_lb_name = "serverless-lb"
  managed_ssl_certificate_domains = [ "test.project.com" ]

  security_policy = "cryptotraders-cloudrun-policy"

#  serverless_https_lb_backends = {
#    cloud_run = {
#      description = "Cloud Run backend"
#      security_policy = "cryptotraders-cloudrun-policy"
#      groups = [
#        {
#          group = "projects/cryptotraders-platform-test/regions/europe-west1/networkEndpointGroups/cloudrun-test1-serverless-neg"
#        },
#        {
#          group = "projects/cryptotraders-platform-test/regions/europe-west2/networkEndpointGroups/cloudrun-test2-serverless-neg"
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
