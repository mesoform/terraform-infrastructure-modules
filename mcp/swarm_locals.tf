locals {

  docker_config_yml = fileexists(var.docker_yml) ? file(var.docker_yml) : null

  docker = local.docker_config_yml == null ? {} : yamldecode(local.docker_config_yml)

  docker_components       = try(lookup(local.docker, "components", {}), lookup(local.docker, "components"))
  docker_components_specs = lookup(local.docker_components, "specs", {})


  docker_container = { for app, config in local.docker_components :
    app => { docker_container : lookup(config, "docker_container", null) }
    if lookup(config, "docker_container", null) != null
  }
  docker_registry_image = { for app, config in local.docker_components :
    app => { docker_registry_image : lookup(config, "docker_registry_image", null) }
    if lookup(config, "docker_registry_image", null) != null
  }
  docker_image = { for app, config in local.docker_components :
    app => { docker_image : lookup(config, "docker_image", null) }
    if lookup(config, "docker_image", null) != null
  }
  docker_network = { for app, config in local.docker_components :
    app => { docker_network : lookup(config, "docker_network", null) }
    if lookup(config, "docker_network", null) != null
  }
  docker_plugin = { for app, config in local.docker_components :
    app => { docker_plugin : lookup(config, "docker_plugin", null) }
    if lookup(config, "docker_plugin", null) != null
  }
  docker_service = { for app, config in local.docker_components :
    app => { docker_service : lookup(config, "docker_service", null) }
    if lookup(config, "docker_service", null) != null
  }
  docker_secret = { for app, config in local.docker_components :
    app => { docker_secret : lookup(config, "docker_secret", null) }
    if lookup(config, "docker_secret", null) != null
  }
  docker_volume = { for app, config in local.docker_components :
    app => { docker_volume : lookup(config, "docker_volume", null) }
    if lookup(config, "docker_volume", null) != null
  }
  docker_config = { for app, config in local.docker_components :
    app => { docker_config : lookup(config, "docker_config", null) }
    if lookup(config, "docker_config", null) != null
  }
  
}
