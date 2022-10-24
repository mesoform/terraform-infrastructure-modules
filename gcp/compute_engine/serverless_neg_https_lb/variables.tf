variable project {
  description = "The project to deploy to"
  type        = string
}

variable region {
  description = "Location for serverless_neg and load balancer"
  type        = string
}

variable serverless_neg_name {
  description = "Name for serverless network endpoint group"
  type        = string
  default     = "serverless-neg"
}

variable cloud_run_negs {
  type = map(object(
    {
      project = string
      region = string
      service_name = string
      tag = string
      url_mask = string
    }
  ))
}

variable cloud_function_negs {
  type = map(object(
    {
      project = string
      region = string
      function_name = string
      url_mask = string
    }
  ))
}

variable cloud_run {
  description = "Cloud run service"
  type = set(object(
    {
      service = string
    }
  ))
  default = []
}

variable app_engine {
  description = "App engine service"
  type = set(object(
    {
      service = string
    }
  ))
  default = []
}

variable cloud_function {
  description = "Cloud function"
  type = set(object(
    {
      function = string
    }
  ))
  default = []
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

variable cloud_run_backends {
  description = "Map backend indices to list of backend maps."
  type = map(object({

    description             = optional(string, "Backend service")
    security_policy         = string
    enable_cdn              = optional(bool, false)
    custom_request_headers  = optional(list(string))
    custom_response_headers = optional(list(string))

    groups = list(object({
      group = string
      tag = string
      url_mask = string
    }))

    iap_config = object({
      enable               = optional(bool, false)
      oauth2_client_id     = optional(string)
      oauth2_client_secret = optional(string)
    })

    log_config = object({
      enable      = optional(bool, false)
      sample_rate = optional(number)
    })
  }))

  validation {
    condition     = alltrue([ for backend in var.cloud_run_backends : length(backend.security_policy) > 0 ])
    error_message = "Security policy can't be empty or null."
  }
}

variable cloud_function_backends {
  description = "Map backend indices to list of backend maps."
  type = map(object({

    description             = optional(string, "Cloud Function Backend service")
    security_policy         = string
    enable_cdn              = optional(bool, false)
    custom_request_headers  = optional(list(string))
    custom_response_headers = optional(list(string))

    groups = list(object({
      group = string
      url_mask = string
    }))

    iap_config = object({
      enable               = optional(bool, false)
      oauth2_client_id     = optional(string)
      oauth2_client_secret = optional(string)
    })

    log_config = object({
      enable      = optional(bool, false)
      sample_rate = optional(number)
    })
  }))

  validation {
    condition     = alltrue([ for backend in var.cloud_function_backends : length(backend.security_policy) > 0 ])
    error_message = "Security policy can't be empty or null."
  }
}

variable security_policy {
  description = "Security policy"
  type        = string
}