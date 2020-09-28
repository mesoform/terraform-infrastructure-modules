
//noinspection HILUnresolvedReference
data "google_project" "default" {
  project_id = lookup(local.cloudrun, "project_id", "")
}

//noinspection HILUnresolvedReference
data "google_organization" "default" {
  count = lookup(local.cloudrun, "organization_name", null) != null ? 1 : 0
  domain = lookup(local.cloudrun, "organization_name", null)
}

resource "google_project_service" "artifact_reg" {
  project  = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id: data.google_project.default.project_id
  service = "artifactregistry.googleapis.com"
}

//noinspection HILUnresolvedReference
resource "google_project" "default" {
  count = lookup(local.cloudrun, "create_google_project", false) ? 1: 0
  name = lookup(local.cloudrun, "project_name", local.cloudrun.project_id)
  project_id = lookup(local.cloudrun,"project_id", null)
  org_id = lookup(local.cloudrun, "organization_name", null) == null ? null : data.google_organization.self[0].org_id
  folder_id = lookup(local.cloudrun, "folder_id", null) == null ? null : local.gae.folder_id
  labels = merge(lookup(local.project, "labels", {}), lookup(local.gae, "project_labels", {}))
  auto_create_network = lookup(local.cloudrun, "auto_create_network", true)
}

//noinspection HILUnresolvedReference
resource "google_artifact_registry_repository" "default" {
  count = lookup(local.cloudrun, "create_artifact_registry", false) ? 1: 0
  provider = google-beta
  project = google_project_service.artifact_reg.project
  location = local.cloudrun.location_id
  format = "DOCKER"
  repository_id = lookup(local.cloudrun, "repository_id", "cloudrun-repo")
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  for_each = local.cloudrun_specs
  location = local.cloudrun.location_id
  name     = each.value.name
  project  = lookup(local.cloudrun, "create_google_project", false) ? google_project.default[0].project_id: data.google_project.default.project_id
  template {
    spec{
      //noinspection HILUnresolvedReference
      containers {
        image = local.cloudrun_specs[each.key].image_uri
        //noinspection HILUnresolvedReference
        dynamic "env"{
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
      name        = length(each.value.metadata) > 0 ? lookup(each.value.metadata, "name", null): null
      annotations = length(each.value.metadata) > 0 ? lookup(each.value.metadata, "annotations", null) : null
    }
  }
  dynamic "traffic" {
    for_each = local.cloudrun_traffic[each.key]
    //noinspection HILUnresolvedReference
    content{
      percent = lookup(traffic.value, "percent", null)
      revision_name = lookup(traffic.value, "revision_name", null)
      latest_revision = lookup(traffic.value, "latest_revision", null)
    }
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}

data "google_iam_policy" "auth" {
  //noinspection HILUnresolvedReference
  for_each = local.cloudrun_specs
  binding {
    role = "roles/${lookup(local.cloudrun_iam[each.key], "role", "" )}"
    members = local.cloudrun_iam_members[each.key]
  }
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_policy" "policy" {
  for_each    = {
    for key, specs in local.cloudrun_specs: key => specs
      if lookup(local.cloudrun_iam[key], "replace_policy", true)
  }
  location    = google_cloud_run_service.self[each.key].location
  project     = google_cloud_run_service.self[each.key].project
  service     = google_cloud_run_service.self[each.key].name

  policy_data = each.value.auth ? data.google_iam_policy.auth[each.key].policy_data : data.google_iam_policy.noauth.policy_data
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_binding" "binding" {
  for_each = {
    for key, specs in local.cloudrun_specs: key => specs
      if local.cloudrun_specs[key].auth && lookup(local.cloudrun_iam[key], "binding", false)
  }
  project  = google_cloud_run_service.self[each.key].project
  location = google_cloud_run_service.self[each.key].location
  members  = local.cloudrun_iam_members[each.key]
  role     = "roles/${lookup(local.cloudrun_iam[each.key], "role", "" )}"

  service  = google_cloud_run_service.self[each.key].name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_member" "member" {
  for_each = {
    for key, specs in local.cloudrun_specs: key => specs
      if local.cloudrun_specs[key].auth && lookup(local.cloudrun_iam[key], "add_member", false) == true
  }
  project  = google_cloud_run_service.self[each.key].project
  location = google_cloud_run_service.self[each.key].location
  member   = lookup(local.cloudrun_iam[each.key],"add_member", null ) == null ? "" : "${local.cloudrun_iam[each.key].add_member.member_type}:${local.cloudrun_iam[each.key].add_member.member}"
  role     = lookup(local.cloudrun_iam[each.key],"add_member", null ) == null ? "" : "roles/${local.cloudrun_iam[each.key].add_member.role}"

  service = google_cloud_run_service.self[each.key].name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_domain_mapping" "default" {
  for_each =  {
    for key, specs in local.cloudrun_specs: key => specs
      if lookup(local.cloudrun_specs[key] , "domain", null) != null
  }
  location = google_cloud_run_service.self[each.key].location
  name = lookup(local.cloudrun_specs[each.key], "domain", "")
  metadata {
    namespace = google_cloud_run_service.self[each.key].project
  }
  spec {
    route_name = google_cloud_run_service.self[each.key].name
  }
}



