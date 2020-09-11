resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

//noinspection HILUnresolvedReference
data "google_project" "self" {
  project_id = local.crun.project_id
}

data "google_container_registry_image" "default"{
  name = lookup(local.crun, "image_name", google_project.self.project_id)
}


//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  location = local.crun.location_id
  name     = local.crun.name
  for_each = local.as_crun_specs
  template {
    spec{
      //noinspection HILUnresolvedReference
      containers {
        image = local.crun.container
        #TODO: sort out references for nested dynamic blocks
        //noinspection HILUnresolvedReference
        dynamic "env"{
          for_each = lookup(each.value, "environment_vars", null) == null ? {} : {env: each.value.environment_vars}
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    //noinspection HILUnresolvedReference
    dynamic "metadata" {
      for_each = lookup(each.value.template,"metadata", null) == null ? {} : {metadata: each.value.metadata}
      content {
        name        = lookup(each.value, "name", null)
        annotations = lookup(each,value, "annotations", null)
      }
    }
  }
  dynamic "traffic"{
    for_each = lookup(each.value, )
    content {
      percent = lookup(each.value, "percent", 100 )
      revision_name = lookup(each.value,"revision_name", null)
      latest_revision = lookup(each.value,"latest_revision", null)
    }
  }
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_domain_mapping" "self" {
  count = length(local.crun.domain_mapping) > 0 ? 1:0
  #TODO: do required specs
}

#TODO: iam policy resources


