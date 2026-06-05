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

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
}

variable "create_address" {
  type        = bool
  description = "Create a new global IPv4 address"
  default     = true
}

variable "address" {
  type        = string
  description = "Existing IPv4 address to use (the actual IP address value)"
  default     = null
}

variable "load_balancing_scheme" {
  type        = string
  description = "This signifies what the GlobalForwardingRule will be used for. Possible values are EXTERNAL, EXTERNAL_MANAGED, and INTERNAL_SELF_MANAGED"
  default     = "EXTERNAL_MANAGED"
}

variable "enable_ipv6" {
  type        = bool
  description = "Enable IPv6 address on the CDN load-balancer"
  default     = false
}

variable "create_ipv6_address" {
  type        = bool
  description = "Allocate a new IPv6 address. Conflicts with \"ipv6_address\" - if both specified, \"create_ipv6_address\" takes precedence."
  default     = false
}

variable "ipv6_address" {
  type        = string
  description = "An existing IPv6 address to use (the actual IP address value)"
  default     = null
}


variable "backends" {
  description = "Map backend indices to list of backend maps."
  type = map(object({

    description             = optional(string, "Backend service")
    security_policy         = string
    load_balancing_scheme   = optional(string, "EXTERNAL_MANAGED")
    protocol                = optional(string, "HTTPS")

    groups = list(object({
      group = string
    }))

    log_config = object({
      enable      = optional(bool)
      sample_rate = optional(number)
    })
  }))

  validation {
    condition     = alltrue([ for backend in var.backends : length(backend.security_policy) > 0 ])
    error_message = "Security policy can't be empty or null."
  }
}

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  type        = bool
  default     = true
}

variable "url_map" {
  description = "The url_map resource to use. Default is to send all traffic to first backend."
  type        = string
  default     = null
}

variable "http_forward" {
  description = "Set to `false` to disable HTTP port 80 forward"
  type        = bool
  default     = false
}

variable "ssl" {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  type        = string
  description = "Selfink to SSL Policy"
  default     = null
}

variable "quic" {
  type        = bool
  description = "Set to `true` to enable QUIC support"
  default     = false
}

variable "private_key" {
  description = "Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty."
  type        = string
  default     = null
}

variable "certificate" {
  description = "Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty."
  type        = string
  default     = null
}

variable "managed_ssl_certificate_domains" {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`."
  type        = list(string)
  default     = []
}

variable "use_ssl_certificates" {
  description = "If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`"
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "SSL cert self_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided."
  type        = list(string)
  default     = []
}

variable "security_policy" {
  description = "The resource URL for the security policy to associate with the backend service"
  type        = string
  default     = null
}

variable "cdn" {
  description = "Set to `true` to enable cdn on backend."
  type        = bool
  default     = false
}

variable "https_redirect" {
  description = "Set to `true` to enable https redirect on the lb."
  type        = bool
  default     = false
}

variable "random_certificate_suffix" {
  description = "Bool to enable/disable random certificate name generation. Set and keep this to true if you need to change the SSL cert."
  type        = bool
  default     = false
}
