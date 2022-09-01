provider google {
  project = var.cloudrun_lb_projectid
}

provider google-beta {
  project = var.cloudrun_lb_projectid
}

resource google_compute_region_network_endpoint_group serverless_neg {
  provider              = google-beta
  name                  = "${var.cloudrun_lb_name}-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.cloudrun_lb_region
  cloud_run {
    service = var.cloudrun_service_name
  }
}

module lb-http {
  source  = "github.com/terraform-google-modules/terraform-google-lb-http//modules/serverless_negs?ref=v6.3.0"
  name    = var.cloudrun_lb_name
  project = var.cloudrun_lb_projectid

  ssl                             = var.cloudrun_lb_ssl
  managed_ssl_certificate_domains = [var.cloudrun_lb_domain]
  https_redirect                  = var.cloudrun_lb_ssl

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = null
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}
