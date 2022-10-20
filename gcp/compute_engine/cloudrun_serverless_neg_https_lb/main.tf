resource google_compute_region_network_endpoint_group serverless_neg {
  project = var.project
  region = var.region
  name = var.serverless_neg_name
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.cloudrun_service_name
  }
}

module cloudrun_serverless_https_lb {
  source  = "github.com/terraform-google-modules/terraform-google-lb-http//modules/serverless_negs?ref=v6.3.0"
  project = var.project
  name = var.serverless_https_lb_name
  http_forward = var.serverless_https_lb_http_forward
  ssl = var.serverless_https_lb_ssl
  managed_ssl_certificate_domains = var.managed_ssl_certificate_domains

  backends = var.serverless_https_lb_backends

  depends_on = [google_compute_region_network_endpoint_group.serverless_neg]
}
