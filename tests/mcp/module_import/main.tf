module "deployment" {
  source = "../../../mcp"
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
