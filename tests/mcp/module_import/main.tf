variable "google_project" {
  type = string
  description = "project ID of the GCP project"
  default = null
}

module "deployment" {
  source = "../../../mcp"
  google_project = var.google_project
}
output "module_kubernetes_out" {
  value = module.deployment.kubernetes
}
output "module_gae_out" {
  value = module.deployment.gae
}
output "module_common_out" {
  value = module.deployment.common
}
