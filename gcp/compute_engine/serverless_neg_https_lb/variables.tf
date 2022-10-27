variable project {
  description = "The project to deploy to"
  type        = string
}

variable serverless_neg_name {
  description = "Name for serverless network endpoint group"
  type        = string
  default     = "serverless-neg"
}


variable serverless_https_lb_name {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
}

variable serverless_https_lb_http_forward {
  description = "Set to `false` to disable HTTP port 80 forward"
  type        = bool
  default     = false
}

variable managed_ssl_certificate_domains {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`."
  type        = list(string)
}

variable cloud_run_services {
  description = "List of Cloud Run services for backend"
  type = list(object(
    {
      service_name = string
      region = string
    }
  ))
  default = []
}

variable app_engine_services {
  description = "List of App Engine services for backend"
  type = list(object(
    {
      service_name = string
      region = string
    }
  ))
  default = []
}

variable cloud_functions {
  description = "List of Cloud Functions for backend"
  type = list(object(
    {
      function_name = string
      region = string
    }
  ))
  default = []
}

variable security_policy {
  description = "Security policy"
  type        = string
}

variable enable_iap_config {
  description = "Set to `false` to disable Cloud Identity Aware Proxy"
  type        = bool
  default     = false
}

variable enable_log_config {
  description = "Set to `false` to disable logging"
  type        = bool
  default     = false
}
