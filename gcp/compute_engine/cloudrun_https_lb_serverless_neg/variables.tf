variable cloudrun_lb_projectid {
  type = string
}

variable cloudrun_lb_region {
  description = "Location for load balancer and Cloud Run resources"
  default     = "europe-west2"
}

variable cloudrun_lb_ssl {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = true
}

variable cloudrun_lb_domain {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
}

variable cloudrun_lb_name {
  description = "Name for load balancer and associated resources"
  default     = "tf-cr-lb"
}

variable cloudrun_service_name {
  description = "Cloud Run service name"
  type        = string
}
