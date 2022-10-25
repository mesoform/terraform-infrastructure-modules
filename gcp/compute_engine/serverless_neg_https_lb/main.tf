resource google_compute_region_network_endpoint_group cloud_run {
  for_each = {for service in var.cloud_run_services: service.service_name => service}
  project = var.project
  region = var.region
  name = join("-",[each.value.service_name, var.serverless_neg_name])
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = each.value.service_name != null ? each.value.service_name : null
  }
}

resource google_compute_region_network_endpoint_group app_engine {
  for_each = {for service in var.app_engine_services: service.service_name => service}
  project = var.project
  region = var.region
  name = join("-",[each.value.service_name, var.serverless_neg_name])
  network_endpoint_type = "SERVERLESS"

  app_engine {
    service = each.value.service_name != null ? each.value.service_name : null
  }
}

resource google_compute_region_network_endpoint_group cloud_function {
  for_each = {for function in var.cloud_functions: function.function_name => function}
  project = var.project
  region = var.region
  name = join("-",[each.value.function_name, var.serverless_neg_name])
  network_endpoint_type = "SERVERLESS"

  cloud_function {
    function = each.value.function_name != null ? each.value.function_name : null
  }
}

module serverless_neg_https_lb {
  source  = "github.com/terraform-google-modules/terraform-google-lb-http//modules/serverless_negs?ref=v6.3.0"
  project = var.project
  name = var.serverless_https_lb_name
  http_forward = var.serverless_https_lb_http_forward
  ssl = true
  managed_ssl_certificate_domains = var.managed_ssl_certificate_domains
  backends = var.serverless_https_lb_backends
#  backends = { merge(var.cloud_run_backends, var.cloud_function_backends) }

  depends_on = [
    google_compute_region_network_endpoint_group.cloud_run,
    google_compute_region_network_endpoint_group.app_engine,
    google_compute_region_network_endpoint_group.cloud_function
  ]

#  depends_on = [google_compute_region_network_endpoint_group.self]
}
