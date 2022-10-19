resource google_compute_region_network_endpoint_group serverless_neg {
  name = var.serverless_neg_name
  network_endpoint_type = "SERVERLESS"
  project = var.project
  region = var.region
  cloud_run {
    service = var.cloudrun_service_name
  }
}

### IPv4 block ###
resource google_compute_global_forwarding_rule http {
  count      = local.create_http_forward ? 1 : 0
  project    = var.project
  name       = var.name
  target     = google_compute_target_http_proxy.default[0].self_link
  ip_address = local.address
  port_range = "80"
}

resource google_compute_global_forwarding_rule https {
  count      = var.ssl ? 1 : 0
  project    = var.project
  name       = "${var.name}-https"
  target     = google_compute_target_https_proxy.default[0].self_link
  ip_address = local.address
  port_range = "443"
  load_balancing_scheme = var.load_balancing_scheme
}

resource google_compute_global_address default {
  count      = var.create_address ? 1 : 0
  project    = var.project
  name       = "${var.name}-address"
  ip_version = "IPV4"
}

### IPv6 block ###
resource google_compute_global_forwarding_rule http_ipv6 {
  count      = (var.enable_ipv6 && local.create_http_forward) ? 1 : 0
  project    = var.project
  name       = "${var.name}-ipv6-http"
  target     = google_compute_target_http_proxy.default[0].self_link
  ip_address = local.ipv6_address
  port_range = "80"
}

resource google_compute_global_forwarding_rule https_ipv6 {
  count      = (var.enable_ipv6 && var.ssl) ? 1 : 0
  project    = var.project
  name       = "${var.name}-ipv6-https"
  target     = google_compute_target_https_proxy.default[0].self_link
  ip_address = local.ipv6_address
  port_range = "443"
}

resource google_compute_global_address default_ipv6 {
  count      = (var.enable_ipv6 && var.create_ipv6_address) ? 1 : 0
  project    = var.project
  name       = "${var.name}-ipv6-address"
  ip_version = "IPV6"
}
### IPv6 block ###

# HTTP proxy when http forwarding is true
resource google_compute_target_http_proxy default {
  count   = local.create_http_forward ? 1 : 0
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = var.https_redirect == false ? local.url_map : join("", google_compute_url_map.https_redirect.*.self_link)
}

# HTTPS proxy when ssl is true
resource google_compute_target_https_proxy default {
  count   = var.ssl ? 1 : 0
  project = var.project
  name    = "${var.name}-https-proxy"
  url_map = local.url_map

  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default.*.self_link, google_compute_managed_ssl_certificate.default.*.self_link, ), )
  ssl_policy       = var.ssl_policy
  quic_override    = var.quic ? "ENABLE" : null
}

resource google_compute_ssl_certificate default {
  count       = var.ssl && length(var.managed_ssl_certificate_domains) == 0 && !var.use_ssl_certificates ? 1 : 0
  project     = var.project
  name_prefix = "${var.name}-certificate-"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource random_id certificate {
  count       = var.random_certificate_suffix == true ? 1 : 0
  byte_length = 4
  prefix      = "${var.name}-cert-"

  keepers = {
    domains = join(",", var.managed_ssl_certificate_domains)
  }
}

resource google_compute_managed_ssl_certificate default {
  project  = var.project
  count    = var.ssl && length(var.managed_ssl_certificate_domains) > 0 && !var.use_ssl_certificates ? 1 : 0
  name     = var.random_certificate_suffix == true ? random_id.certificate[0].hex : "${var.name}-cert"

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = var.managed_ssl_certificate_domains
  }
}

resource google_compute_url_map default {
  count           = var.create_url_map ? 1 : 0
  project         = var.project
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.default[keys(var.backends)[0]].self_link
}

resource google_compute_url_map https_redirect {
  count   = var.https_redirect ? 1 : 0
  project = var.project
  name    = "${var.name}-https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource google_compute_backend_service default {
  for_each = var.backends

  project = var.project
  name    = "${var.name}-backend-${each.key}"

  description                     = lookup(each.value, "description")
  load_balancing_scheme           = lookup(each.value, "load_balancing_scheme")
  protocol                        = lookup(each.value, "protocol")
  security_policy                 = lookup(each.value, "security_policy")

  dynamic backend {
    for_each = toset(each.value["groups"])
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group")
    }
  }

  dynamic log_config {
    for_each = lookup(lookup(each.value, "log_config", {}), "enable", true) ? [1] : []
    content {
      enable      = lookup(lookup(each.value, "log_config", {}), "enable", true)
      sample_rate = lookup(lookup(each.value, "log_config", {}), "sample_rate", "1.0")
    }
  }

  depends_on = [google_compute_region_network_endpoint_group.serverless_neg]
}
