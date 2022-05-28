locals {

  docker_config_yml = fileexists(var.docker_yml) ? file(var.docker_yml) : null

  docker = local.docker_config_yml == null ? {} : yamldecode(local.docker_config_yml)

  docker_components       = try(lookup(local.docker, "components", {}), lookup(local.docker, "components"))
  k8s_components_specs = lookup(local.docker_components, "specs", {})


  docker_container = { for app, config in local.docker_components :
    app => { docker_container : lookup(config, "docker_container", null) }
    if lookup(config, "docker_container", null) != null
  }
  docker_registry_image = { for app, config in local.docker_components :
    app => { docker_registry_image : lookup(config, "docker_registry_image", null) }
    if lookup(config, "docker_registry_image", null) != null
  }
}
