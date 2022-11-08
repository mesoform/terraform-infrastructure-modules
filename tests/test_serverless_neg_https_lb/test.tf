# create test cloud run services
resource google_cloud_run_service test1 {
  name     = "cloudrun-test1"
  location = "europe-west1"
  project  = "test-project"

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

resource google_cloud_run_service test2 {
  name     = "cloudrun-test2"
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

resource google_cloud_run_service_iam_member public-access-test2 {
  location = google_cloud_run_service.test2.location
  project  = google_cloud_run_service.test2.project
  service  = google_cloud_run_service.test2.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# create test cloud function
resource google_storage_bucket bucket {
  project  = "test-project"
  name = "cf-test1-source"
  location = "EUROPE-WEST2"
  uniform_bucket_level_access = true
}

resource google_storage_bucket_object object {
  name = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function-source.zip"
}

resource "google_cloudfunctions2_function" "function" {
  project  = "test-project"
  name = "cloudfunction-test1"
  location = "europe-west2"
  description = "Cloud function"

  build_config {
    runtime = "nodejs16"
    entry_point = "helloHttp"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

# create test LB
module test_serverless_lb {
  source  = "../../gcp/compute_engine/serverless_neg_https_lb"
  project = "test-project"
  serverless_neg_name = "serverless-neg"
  serverless_https_lb_name = "serverless-lb"
  managed_ssl_certificate_domains = [ "test.project.com" ]
  cloud_run_services = [
    { service_name = "cloudrun-test1", region = "europe-west1" },
    { service_name = "cloudrun-test2", region = "europe-west2" }
  ]
  cloud_functions = [
    { function_name = "cloudfunction-test1", region = "europe-west2" }
  ]
  security_policy = "security-policy"
  enable_iap_config = false
  enable_log_config = false
}
