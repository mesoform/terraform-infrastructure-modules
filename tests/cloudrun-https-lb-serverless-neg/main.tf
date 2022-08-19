module https-lb-serverless-neg-cloudrun {
  source = "../../gcp/compute_engine/https_lb_serverless_neg"
  project_id  = "cryptotraders-platform-test"
  region = "europe-west2"
  domain = "log-frontend-dev.consilienceventures.com"
  lb_name = "cloudrun-lb"
  ssl = "true"
}
