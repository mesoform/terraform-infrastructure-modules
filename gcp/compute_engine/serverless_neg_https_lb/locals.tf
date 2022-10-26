locals {
  list_cr_services = [for service in var.cloud_run_services : service.service_name]
  list_cr_regions = [for region in var.cloud_run_services : region.region]
  cloud_run_groups = [
    for index, service in local.list_cr_services :
          {
            group = "projects/${var.project}/regions/${local.list_cr_regions[index]}/networkEndpointGroups/${service}-serverless-neg"
          }
  ]

#  cloud_run_groups = [
#    for service in var.cloud_run_services.*.service_name :
#          {
#            group = "projects/${var.project}/regions/${var.region}/networkEndpointGroups/${service}-serverless-neg"
#          }
#  ]

  #  cloud_run_negs = [
#    {
#      group = module.test_lb.google_compute_region_network_endpoint_group.cloud_run
#    }
#  ]

#  cloud_function_groups = [
#    for cloud_function_neg, config in var.cloud_function_negs:
#      { group = cloud_run_neg }
#  ]
#  all_negs = concat(local.cloud_function_negs, local.cloud_run_negs)

# loop over the list of NEGs and pull out instance name

#  backends = templatefile("${path.module}/backends.tftpl", { service = "cloud_run" })
#  backends = merge(var.serverless_https_lb_backends, {groups = google_compute_region_network_endpoint_group.self.self_link}
#  )

  cloud_run_backend = {
    cloud_run = {
      description = "Cloud Run backend"
      security_policy = var.security_policy
      enable_cdn = false
      custom_request_headers = null
      custom_response_headers = null
      groups = local.cloud_run_groups
      #    groups = [
      #      {
      #        group = google_compute_region_network_endpoint_group.self.self_link
      #      }
      #    ]
      iap_config = {
        enable = false
        oauth2_client_id = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable = false
        sample_rate = 1.0
      }
    }
  }

#    app_engine_backend = {
#      description = "App engine backend"
#      security_policy = var.security_policy
#      enable_cdn = false
#      custom_request_headers = null
#      custom_response_headers = null
#      groups = [
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

#    cloud_function_backend = {
#      description = "Cloud Function backend"
#      security_policy = var.security_policy
#      enable_cdn = false
#      custom_request_headers = null
#      custom_response_headers = null
#      groups = [
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
