variable project {
  description = "The project to deploy to"
  type        = string
}

variable region {
  description = "Location for serverless_neg and load balancer"
  type        = string
  default     = "europe-west-2"
}

variable serverless_neg_name {
  description = "Name for serverless network endpoint group"
  type        = string
  default     = "serverless-neg"
}

variable cloudrun_service_name {
  description = "Cloud run service name"
  type        = string
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

variable serverless_https_lb_ssl {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  type        = bool
  default     = true
}

variable managed_ssl_certificate_domains {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`."
  type        = list(string)
  default     = []
}

variable serverless_https_lb_backends {
  description = "Map backend indices to list of backend maps."
  type = map(object({

    description             = optional(string, "Backend service")
    security_policy         = string
    enable_cdn              = optional(bool, false)
    custom_request_headers  = optional(list(string))
    custom_response_headers = optional(list(string))

    groups = list(object({
      group = string
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
    condition     = alltrue([ for backend in var.serverless_https_lb_backends : length(backend.security_policy) > 0 ])
    error_message = "Security policy can't be empty or null."
  }
}
