output "project" {
  value = local.project
}
output "gae" {
  value = local.gae == {} ? {None: "No App Engine config as no gcp_ae.yml file"} : local.gae
}

output "gae_flex" {
  value = local.as_flex_specs
}

output "gae_std" {
  value = local.as_std_specs
}

output "kubernetes" {
  value = local.k8s
}

output "cloudrun" {
  value = local.cloudrun
}

