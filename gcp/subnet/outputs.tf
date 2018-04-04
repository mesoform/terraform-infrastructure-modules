output "gateway_address" {
  value       = "${google_compute_subnetwork.self_external.gateway_address}"
  description = "The IP address of the gateway."
}

output "self_link" {
  value       = "${google_compute_subnetwork.self_external.self_link}"
  description = "The URL of the created resource"
}