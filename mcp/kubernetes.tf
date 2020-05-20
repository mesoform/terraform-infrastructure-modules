locals {
  kube_services_files = fileset(path.root, "../**/kubernetes-service.y{a,}ml")
  kubernetes_services = {
    for kube_file in local.kube_services_files:
      basename(dirname(kube_file)) => {service: yamldecode(file(kube_file))}
      if !contains(split("/", kube_file), "terraform")
  }
  kube_deployments_files = fileset(path.root, "../**/kubernetes-deployment.y{a,}ml")
  kubernetes_deployments = {
    for kube_file in local.kube_deployments_files:
      basename(dirname(kube_file)) => {deployment: yamldecode(file(kube_file))}
      if !contains(split("/", kube_file), "terraform")
  }
  kubernetes = {
    for app, config in local.kubernetes_services:
        app => merge(config, lookup(local.kubernetes_deployments, app, {}))
  }
}

//resource "kubernetes_deployment" "self" {
//  metadata {}
//  spec {
//    template {
//      metadata {}
//      spec {}
//    }
//  }
//}
//
//resource "kubernetes_service" "self" {
//  metadata {}
//  spec {}
//}

