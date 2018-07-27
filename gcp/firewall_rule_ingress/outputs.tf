output "rule_links" {
  value = "${list(
      google_compute_firewall.self_allow_accounts.self_link,
      google_compute_firewall.self_allow_tags.self_link,
      google_compute_firewall.self_deny_accounts.self_link,
      google_compute_firewall.self_deny_tags.self_link,
      google_compute_firewall.self_allow_ips.self_link,
      google_compute_firewall.self_deny_ips.self_link)}"
}