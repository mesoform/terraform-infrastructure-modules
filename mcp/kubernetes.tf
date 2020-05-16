locals {
  kube_files = fileset(path.root, "../**/kubernetes.y?ml")
  kubernetes = {
    for kube_file in local.kube_files:
      basename(dirname(kube_file)) => yamldecode(file(kube_file))
      if !contains(split("/", kube_file), "terraform")
  }
}
