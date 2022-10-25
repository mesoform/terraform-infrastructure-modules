resource google_compute_region_network_endpoint_group cloud_run {
  for_each = var.cloud_run_services
  project = var.project
  region = var.region
  name = each.key
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = each.value["service_name"] != null ? each.value["service_name"] : null
  }
}

#  dynamic app_engine {
#    for_each = var.app_engine
#    content {
#      service = app_engine.value["service"]
#      version = ""
#      url_mask = ""
#    }
#  }
#
#  dynamic cloud_function {
#    for_each = var.cloud_function
#    content {
#      function = cloud_function.value["function"]
#      url_mask = ""
#    }
#  }

#module serverless_neg_https_lb {
#  source  = "github.com/terraform-google-modules/terraform-google-lb-http//modules/serverless_negs?ref=v6.3.0"
#  project = var.project
#  name = var.serverless_https_lb_name
#  http_forward = var.serverless_https_lb_http_forward
#  ssl = true
#  managed_ssl_certificate_domains = var.managed_ssl_certificate_domains
#  backends = { var.cloud_run_backends }
##  backends = { merge(var.cloud_run_backends, var.cloud_function_backends) }
#  depends_on = [
#    google_compute_region_network_endpoint_group.cloud_run
##   ,google_compute_region_network_endpoint_group.cloud_function
#  ]
#
##  depends_on = [google_compute_region_network_endpoint_group.self]
#}
