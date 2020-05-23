locals {
  k8s_services_files = fileset(path.root, "../**/k8s_service.y{a,}ml")
  k8s_services = {
    for kube_file in local.k8s_services_files:
      basename(dirname(kube_file)) => {service: yamldecode(file(kube_file))}
      if !contains(split("/", kube_file), "terraform")
  }
  k8s_deployments_files = fileset(path.root, "../**/k8s_deployment.y{a,}ml")
  k8s_deployments = {
    for kube_file in local.k8s_deployments_files:
      basename(dirname(kube_file)) => {deployment: yamldecode(file(kube_file))}
      if !contains(split("/", kube_file), "terraform")
  }
  k8s = {
    for app, config in local.k8s_services:
        app => merge(config, lookup(local.k8s_deployments, app, {}))
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

