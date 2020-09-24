//output "kubernetes" {
//  value = local.k8s_conf
//}

output "k8s_deployments" {
  value = local.k8s_deployments
}

output "k8s_services" {
  value = local.k8s_services
}

output "k8s_config" {
  value = local.k8s_config_map
}
