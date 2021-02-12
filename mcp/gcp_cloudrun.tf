
//noinspection HILUnresolvedReference
data "google_project" "default" {
  count      = local.cloudrun == {} || lookup(local.cloudrun, "create_google_project", false) ? 0 : 1
  project_id = lookup(local.cloudrun, "project_id", "")
}


resource "google_project_service" "iam" {
  count              = local.cloudrun == {} ? 0 : 1
  project            = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_reg" {
  count                      = lookup(local.cloudrun, "create_artifact_registry", false) ? 1 : 0
  project                    = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudrun" {
  count              = local.cloudrun == {} ? 0 : 1
  project            = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

//noinspection HILUnresolvedReference
resource "google_project" "default" {
  count           = local.cloudrun != {} && lookup(local.cloudrun, "create_google_project", false) ? 1 : 0
  name            = lookup(local.cloudrun, "project_name", local.cloudrun.project_id)
  project_id      = lookup(local.cloudrun, "project_id", local.cloudrun.project_id)
  org_id          = lookup(local.cloudrun, "organization_name", null)
  folder_id       = lookup(local.cloudrun, "folder_id", null) == null ? null : local.gae.folder_id
  labels          = merge(lookup(local.project, "labels", {}), lookup(local.gae, "project_labels", {}))
  billing_account = lookup(local.cloudrun, "billing_account", null)
}

//noinspection HILUnresolvedReference
resource "google_artifact_registry_repository" "self" {
  count         = lookup(local.cloudrun, "create_artifact_registry", false) ? 1 : 0
  provider      = google-beta
  project       = google_project_service.artifact_reg[0].project
  location      = local.cloudrun.location_id
  format        = "DOCKER"
  repository_id = lookup(local.cloudrun, "repository_id", "cloudrun-repo")
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  for_each = local.cloudrun_specs
  location = local.cloudrun.location_id
  name     = each.value.name
  project  = google_project_service.cloudrun[0].project
  dynamic metadata {
    for_each = {metadata = lookup(each.value,"metadata",{})}
    content{
      annotations      = merge(local.cloudrun_default.metadata.annotations, lookup(metadata.value, "annotations", {} ))
      generation       = lookup(metadata.value, "generation", null)
      labels           = lookup(metadata.value, "labels", null)
      namespace        = lookup(metadata.value, "namespace", null)
      resource_version = lookup(metadata.value, "resource_version", null)
      self_link        = lookup(metadata.value, "self_link", null)
      uid              = lookup(metadata.value, "uid", null)
    }
  }
  template {
    //noinspection HILUnresolvedReference
    spec {
      container_concurrency = lookup(each.value.template, "container_concurrency", 80)
      timeout_seconds       = lookup(each.value.template, "timeout_seconds", null)
      service_account_name  = lookup(each.value.template, "service_account_name", null)
      //noinspection HILUnresolvedReference
      containers {
        image   = each.value.template.containers.image
        args    = lookup(each.value.template.containers, "args", null)
        command = lookup(each.value.template.containers, "command", null)
        //noinspection HILUnresolvedReference
        dynamic "ports" {
          for_each = lookup(each.value.template.containers, "ports", {})
          content {
            name           = lookup(ports.value, "name", null)
            protocol       = lookup(ports.value, "protocol", null)
            container_port = ports.value.container_port
          }
        }
        //noinspection HILUnresolvedReference
        dynamic "resources" {
          for_each = lookup(each.value.template.containers, "resources", {})
          content {
            limits   = lookup(resources.value, "limits", null)
            requests = lookup(resources.value, "requests", null)
          }
        }
        //noinspection HILUnresolvedReference
        dynamic "env" {
          for_each = lookup(each.value.template.containers, "environment_vars", {})
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    //noinspection HILUnresolvedReference
    dynamic metadata {
      for_each = {metadata: lookup(each.value.template, "metadata",{})}
      content {
        name             = lookup(metadata.value, "name", null)
        annotations      = merge(local.cloudrun_default.template_metadata.annotations, lookup(metadata.value, "annotations", {}))
        labels           = lookup(metadata.value, "labels", null)
        generation       = lookup(metadata.value, "generation", null)
        resource_version = lookup(metadata.value, "resource_version", null)
        self_link        = lookup(metadata.value, "self_link", null)
        uid              = lookup(metadata.value, "uid", null)
        namespace        = lookup(metadata.value, "namespace", null)
      }
    }
  }
  dynamic "traffic" {
    for_each = lookup(local.cloudrun_traffic, each.key, {}) == {} ? local.cloudrun_default.traffic: local.cloudrun_traffic[each.key]
//    for_each = lookup(local.cloudrun_traffic, each.key, local.cloudrun_default.traffic)
//    for_each = local.cloudrun_traffic[each.key] == {} ? local.cloudrun_default.traffic : local.cloudrun_traffic[each.key]
    //noinspection HILUnresolvedReference
    content {
      percent         = traffic.value
      revision_name   = traffic.key == "latest" ? null: traffic.key
      latest_revision = traffic.key == "latest" ? true: false
    }
  }

}

data "google_iam_policy" "noauth" {
  for_each = local.cloudrun_specs
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

data "google_iam_policy" "auth" {
  //noinspection HILUnresolvedReference
  for_each = local.cloudrun_specs
  dynamic "binding" {
    for_each = local.cloudrun_iam_bindings[each.key]
    content {
      role    = "roles/${binding.key}"
      members = lookup(binding.value, "members", [])
    }
  }
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_policy" "self" {
  for_each = {
    for key, specs in local.cloudrun_specs : key => specs
      if !specs.auth || (specs.auth && (lookup(local.cloudrun_iam[key], "replace_policy", false)))
  }
  location = google_cloud_run_service.self[each.key].location
  project  = google_cloud_run_service.self[each.key].project
  service  = google_cloud_run_service.self[each.key].name

  policy_data = each.value.auth ? data.google_iam_policy.auth[each.key].policy_data : data.google_iam_policy.noauth[each.key].policy_data
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_binding" "self" {
  for_each = {
    for key, bindings in local.cloudrun_iam_bindings : key => bindings
    if !lookup(local.cloudrun_iam[key], "replace_policy", false) && length(bindings) != 0
  }
  project  = google_cloud_run_service.self[each.key].project
  location = google_cloud_run_service.self[each.key].location
  members  = lookup(each.value[keys(each.value)[0]], "members", [])
  role     = "roles/${keys(each.value)[0]}"
  service  = google_cloud_run_service.self[each.key].name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_member" "self" {
  for_each = {
    for key, specs in local.cloudrun_iam : key => specs
    if local.cloudrun_specs[key].auth && lookup(local.cloudrun_iam[key], "add_member", {}) != {}
  }
  project  = google_cloud_run_service.self[each.key].project
  location = google_cloud_run_service.self[each.key].location
  member   = lookup(each.value.add_member, "member", "")
  role     = "roles/${lookup(each.value.add_member, "role", "")}"
  service  = google_cloud_run_service.self[each.key].name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_domain_mapping" "self" {
  for_each = {
    for key, specs in local.cloudrun_specs : key => specs
      if lookup(local.cloudrun_specs[key], "domain", null) != null
  }
  location = google_cloud_run_service.self[each.key].location
  name     = lookup(local.cloudrun_specs[each.key], "domain", "")
  metadata {
    namespace = google_cloud_run_service.self[each.key].project
  }
  spec {
    route_name = google_cloud_run_service.self[each.key].name
  }
}



