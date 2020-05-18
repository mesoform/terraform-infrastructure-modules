variable "google_project" {
  type = string
  description = "project ID of the GCP project"
  default = null
}

variable "google_location" {
  type = string
  description = "geographical location for the application to be deployed to"
  default = null
}
variable "create_google_project" {
  type = bool
  default = true
}
module "deployment" {
  source = "../../../mcp"
  google_project = var.google_project
  google_location = var.google_location
  create_google_project = var.create_google_project
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
