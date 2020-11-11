
//noinspection HILUnresolvedReference
data "google_project" "default" {
  count      = lookup(local.cloudrun, "create_google_project", false) ? 0 : 1
  project_id = lookup(local.cloudrun, "project_id", "")
}

resource "google_project_service" "iam" {
  project = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "artifact_reg" {
  project = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service = "artifactregistry.googleapis.com"
}
resource "google_project_service" "cloudrun" {
  project = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id : data.google_project.default[0].project_id
  service = "run.googleapis.com"
}

//noinspection HILUnresolvedReference
resource "google_project" "default" {
  count           = lookup(local.cloudrun, "create_google_project", false) ? 1 : 0
  name            = lookup(local.cloudrun, "project_name", local.cloudrun.project_id)
  project_id      = lookup(local.cloudrun, "project_id", null)
  org_id          = lookup(local.cloudrun, "organization_name", null)
  folder_id       = lookup(local.cloudrun, "folder_id", null) == null ? null : local.gae.folder_id
  labels          = merge(lookup(local.project, "labels", {}), lookup(local.gae, "project_labels", {}))
  billing_account = lookup(local.cloudrun, "billing_account", null)
}

//noinspection HILUnresolvedReference
resource "google_artifact_registry_repository" "self" {
  count         = lookup(local.cloudrun, "create_artifact_registry", false) ? 1 : 0
  provider      = google-beta
  project       = google_project_service.artifact_reg.project
  location      = local.cloudrun.location_id
  format        = "DOCKER"
  repository_id = lookup(local.cloudrun, "repository_id", "cloudrun-repo")
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  for_each = local.cloudrun_specs
  location = local.cloudrun.location_id
  name     = each.value.name
  project  = google_project_service.cloudrun.project
  template {
    spec {
      //noinspection HILUnresolvedReference
      containers {
        image = local.cloudrun_specs[each.key].image_uri
        //noinspection HILUnresolvedReference
        dynamic "env" {
          for_each = lookup(each.value, "environment_vars", {})
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    //noinspection HILUnresolvedReference
    metadata {
      name        = length(each.value.metadata) > 0 ? lookup(each.value.metadata, "name", null) : null
      annotations = length(each.value.metadata) > 0 ? lookup(each.value.metadata, "annotations", null) : null
    }
  }
  dynamic "traffic" {
    for_each = local.cloudrun_traffic[each.key]
    //noinspection HILUnresolvedReference
    content {
      percent         = lookup(traffic.value, "percent", null)
      revision_name   = lookup(traffic.value, "revision_name", null)
      latest_revision = lookup(traffic.value, "latest_revision", null)
    }
  }

}

data "google_iam_policy" "noauth" {
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
    if lookup(local.cloudrun_iam[key], "replace_policy", true)
  }
  location = google_cloud_run_service.self[each.key].location
  project  = google_cloud_run_service.self[each.key].project
  service  = google_cloud_run_service.self[each.key].name

  policy_data = each.value.auth ? data.google_iam_policy.auth[each.key].policy_data : data.google_iam_policy.noauth.policy_data
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_binding" "self" {
  for_each = {
    for key, bindings in local.cloudrun_iam_bindings : key => bindings
    if local.cloudrun_specs[key].auth && ! lookup(local.cloudrun_iam[key], "replace_policy", true)
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
