locals {
  cloud_run_negs = google_compute_region_network_endpoint_group.cloud_run.name
# loop over the list of NEGs and pull out instance name

#  backends = templatefile("${path.module}/backends.tftpl", { service = "cloud_run" })
#  backends = merge(var.serverless_https_lb_backends, {groups = google_compute_region_network_endpoint_group.self.self_link}
#  )
#  cloudrun = {
#      description = "Cloud Run backend"
#      security_policy = var.security_policy
#      enable_cdn = false
#      custom_request_headers = null
#      custom_response_headers = null
#      groups          = [
#        {
#          group = google_compute_region_network_endpoint_group.self.self_link
#        }
#      ]
#      iap_config = {
#        enable = false
#        oauth2_client_id = ""
#        oauth2_client_secret = ""
#      }
#      log_config = {
#        enable = false
#        sample_rate = 1.0
#      }
#    }
#    app_engine = {
#      description = "App engine backend"
#      security_policy = var.security_policy
#      enable_cdn = false
#      custom_request_headers = null
#      custom_response_headers = null
#      groups          = [
#        {
#          group = google_compute_region_network_endpoint_group.self.self_link
#        }
#      ]
#      iap_config = {
#        enable = false
#        oauth2_client_id = ""
#        oauth2_client_secret = ""
#      }
#      log_config = {
#        enable = false
#        sample_rate = 1.0
#      }
#    }
#    cloud_function = {
#      description = "Cloud Function backend"
#      security_policy = var.security_policy
#      enable_cdn = false
#      custom_request_headers = null
#      custom_response_headers = null
#      groups          = [
#        {
#          group = google_compute_region_network_endpoint_group.self.self_link
#        }
#      ]
#      iap_config = {
#        enable = false
#        oauth2_client_id = ""
#        oauth2_client_secret = ""
#      }
#      log_config = {
#        enable = false
#        sample_rate = 1.0
#      }
#    }
}
