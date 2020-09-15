//noinspection HILUnresolvedReference
locals {
  user_project_config_yml = file(var.user_project_config_yml)
  project = yamldecode(local.user_project_config_yml)

  user_crun_config_yml = file(var.gcp_crun_yml)
  crun = yamldecode(local.user_crun_config_yml)

  as_crun_specs = local.crun.components.specs
}

//noinspection HILUnresolvedReference
data "google_project" "self" {
  project_id = local.crun.project_id
}

data "google_container_registry_image" "default"{
  name = lookup(local.as_crun_specs, "image_name", data.google_project.self.project_id)
  project = data.google_project.self.project_id
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  location = local.crun.location_id
  name     = local.as_crun_specs.name
  project  = data.google_project.self.project_id
//  for_each = local.as_crun_specs
  template {
    spec{
      //noinspection HILUnresolvedReference
      containers {
//        image = local.as_crun_specs.container
        image = data.google_container_registry_image.default.image_url
        //noinspection HILUnresolvedReference
        dynamic "env"{
          for_each = lookup(local.as_crun_specs, "environment_vars", null)
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    //noinspection HILUnresolvedReference
    metadata {
        name        = length(local.as_crun_specs.metadata) > 0 ? lookup(local.as_crun_specs.metadata, "name", null): null
        annotations = length(local.as_crun_specs.metadata) > 0 ? lookup(local.as_crun_specs.metadata, "annotations", null) : null
    }
  }
  #TODO: do traffic block
}

#TODO: iam policy, currently cannot access service without authentication

#TODO: Domain mapping



