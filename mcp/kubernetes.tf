locals {
  kube_files = fileset(path.module, "../**/kubernetes.yml")
  kubernetes = {
    for kube_file in local.kube_files:
      split("/", kube_file)[1] => yamldecode(file(kube_file))
  }
}
