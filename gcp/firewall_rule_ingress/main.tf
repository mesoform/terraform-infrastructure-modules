resource "google_compute_firewall" "self_deny_tags" {
  count     = "${var.directive == "deny" && var.type == "tags" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-deny-tags-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  deny {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges = "${var.source_ranges}"
  source_tags   = "${var.source_tags}"
  target_tags   = "${var.target_tags}"
}

resource "google_compute_firewall" "self_deny_accounts" {
  count     = "${var.directive == "deny" && var.type == "accounts" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-deny-accounts-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  deny {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges           = "${var.source_ranges}"
  source_service_accounts = "${var.source_service_accounts}"
  target_service_accounts = "${var.target_service_accounts}"
}

resource "google_compute_firewall" "self_allow_accounts" {
  count     = "${var.directive == "allow" && var.type == "accounts" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-allow-accounts-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges           = "${var.source_ranges}"
  source_service_accounts = "${var.source_service_accounts}"
  target_service_accounts = "${var.target_service_accounts}"
}

resource "google_compute_firewall" "self_allow_tags" {
  count     = "${var.directive == "allow" && var.type == "tags" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-allow-tags-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges = "${var.source_ranges}"
  source_tags   = "${var.source_tags}"
  target_tags   = "${var.target_tags}"
}

resource "google_compute_firewall" "self_allow_ips" {
  count     = "${var.directive == "allow" && var.type == "ips" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-allow-ips-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges      = "${var.source_ranges}"
  destination_ranges = "${var.destination_ranges}"
}

resource "google_compute_firewall" "self_deny_ips" {
  count     = "${var.directive == "deny" && var.type == "ips" ? 1 : 0 }"
  name      = "${var.name == "" ? format("%s-ingress-deny-ips-%s", var.network, var.protocol) : var.name}"
  project   = "${var.network_project == "" ? var.project : var.network_project}"
  network   = "${var.network}"
  priority  = "${var.priority}"
  direction = "INGRESS"

  deny {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges      = "${var.source_ranges}"
//  destination_ranges returns a conflict error with source_ranges
//  destination_ranges = "${var.destination_ranges}"
}
