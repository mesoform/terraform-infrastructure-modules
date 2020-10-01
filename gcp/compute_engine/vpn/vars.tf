variable "region" {}
variable "vpc_name" {}
variable "compute_address_name" {}
variable "gcp_fr_name_prefix" {description = "Forwarding rule name prefix"}
variable "vpn_gateway_name" {}
variable "vpn_tunnel_name_prefix" {}
variable "vpn_peer_ip" {}
variable "tunnel1_secret" {
  description = "needs passing at runtime"
  default = "CHANGEME"
}
variable "tunnel2_secret" {
  description = "needs passing at runtime"
  default = "CHANGEME"
}