locals {
  list_cr_services = [for service in var.cloud_run_services : service.service_name]
  list_cr_regions = [for region in var.cloud_run_services : region.region]
  cloud_run_groups = [
    for index, service in local.list_cr_services :
          {
            group = "projects/${var.project}/regions/${local.list_cr_regions[index]}/networkEndpointGroups/${service}-${var.serverless_neg_name}"
          }
  ]

  list_ae_services = [for service in var.app_engine_services : service.service_name]
  list_ae_regions = [for region in var.app_engine_services : region.region]
  app_engine_groups = [
    for index, service in local.list_ae_services :
          {
            group = "projects/${var.project}/regions/${local.list_ae_regions[index]}/networkEndpointGroups/${service}-${var.serverless_neg_name}"
          }
  ]

  list_cf_services = [for function in var.cloud_functions : function.function_name]
  list_cf_regions = [for region in var.cloud_run_services : region.region]
  cloud_function_groups = [
    for index, service in local.list_cr_services :
          {
            group = "projects/${var.project}/regions/${local.list_cf_regions[index]}/networkEndpointGroups/${service}-${var.serverless_neg_name}"
          }
  ]

  cloud_run_backend = {
    cloud_run = {
      description = "Cloud Run backend"
      security_policy = var.security_policy
      enable_cdn = false
      custom_request_headers = null
      custom_response_headers = null
      groups = local.cloud_run_groups
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

  app_engine_backend = {
    app_engine = {
      description = "App Engine backend"
      security_policy = var.security_policy
      enable_cdn = false
      custom_request_headers = null
      custom_response_headers = null
      groups = local.app_engine_groups
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

  cloud_function_backend = {
    cloud_function = {
      description = "Cloud Function backend"
      security_policy = var.security_policy
      enable_cdn = false
      custom_request_headers = null
      custom_response_headers = null
      groups = local.cloud_function_groups
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

  all_backends = merge(local.cloud_run_backend, local.app_engine_backend, local.cloud_function_backend)
}
