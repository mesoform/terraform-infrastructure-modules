output "kubernetes" {
  value = local.kubernetes
}

output "k8s_components" {
  value = local.k8s_components
}

output "k8s_components_specs" {
  value = local.k8s_components_specs
}

output "k8s_file" {
  value = var.k8s_yml
}

output "k8s_config_map" {
  value = local.k8s_config_map
}
