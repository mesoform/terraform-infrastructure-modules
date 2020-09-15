//noinspection HILUnresolvedReference
locals {
  user_project_config_yml = file(var.user_project_config_yml)
  project = yamldecode(local.user_project_config_yml)

  user_cloudrun_config_yml = file(var.gcp_cloudrun_yml)
  cloudrun = yamldecode(local.user_cloudrun_config_yml)

  as_cloudrun_specs = local.cloudrun.components.specs
  cloudrun_iam = lookup(local.cloudrun.components.specs, "iam", {})
  cloudrun_iam_members = lookup(local.cloudrun_iam, "members", null)==null ? [] : [for user, tag in local.cloudrun_iam.members : "${tag}:${user}"]
}

//noinspection HILUnresolvedReference
data "google_project" "self" {
  project_id = local.cloudrun.project_id
}

data "google_container_registry_image" "default"{
  name = lookup(local.as_cloudrun_specs, "image_name", data.google_project.self.project_id)
  project = data.google_project.self.project_id
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service" "self" {
  location = local.cloudrun.location_id
  name     = local.as_cloudrun_specs.name
  project  = data.google_project.self.project_id
//  for_each = local.as_cloudrun_specs
  template {
    spec{
      //noinspection HILUnresolvedReference
      containers {
//        image = local.as_cloudrun_specs.container
        image = data.google_container_registry_image.default.image_url
        //noinspection HILUnresolvedReference
        dynamic "env"{
          for_each = lookup(local.as_cloudrun_specs, "environment_vars", {})
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    //noinspection HILUnresolvedReference
    metadata {
        name        = length(local.as_cloudrun_specs.metadata) > 0 ? lookup(local.as_cloudrun_specs.metadata, "name", null): null
        annotations = length(local.as_cloudrun_specs.metadata) > 0 ? lookup(local.as_cloudrun_specs.metadata, "annotations", null) : null
    }
  }
  #TODO: do traffic block
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}

data "google_iam_policy" "auth" {
  //noinspection HILUnresolvedReference
  binding {
    role = "roles/${lookup(local.cloudrun_iam, "role", "" )}"
    members = local.cloudrun_iam_members
  }
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_policy" "policy" {
  count       = lookup(local.cloudrun_iam, "replace_policy", true) ? 1 : 0
  location    = google_cloud_run_service.self.location
  project     = google_cloud_run_service.self.project
  service     = google_cloud_run_service.self.name

  policy_data = local.as_cloudrun_specs.auth ? data.google_iam_policy.auth.policy_data : data.google_iam_policy.noauth.policy_data
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_binding" "binding" {
  count    = local.as_cloudrun_specs.auth ? (lookup(local.cloudrun_iam,"binding", false ) ? 1 : 0) : 0
  project  = google_cloud_run_service.self.project
  location = google_cloud_run_service.self.location
  members  = local.cloudrun_iam_members
  role     = "roles/${lookup(local.cloudrun_iam, "role", "" )}"

  service  = google_cloud_run_service.self.name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_service_iam_member" "member" {
  count    = local.as_cloudrun_specs.auth ? (lookup(local.cloudrun_iam,"add_member", null ) == null ? 0 : 1) : 0
  project  = google_cloud_run_service.self.project
  location = google_cloud_run_service.self.location
  member   = lookup(local.cloudrun_iam,"add_member", null ) == null ? "" : "${local.cloudrun_iam.add_member.member_type}${local.cloudrun_iam.add_member.member}"
  role     = lookup(local.cloudrun_iam,"add_member", null ) == null ? "" : "roles/${local.cloudrun_iam.add_member.role}"

  service = google_cloud_run_service.self.name
}

//noinspection HILUnresolvedReference
resource "google_cloud_run_domain_mapping" "default" {
  count = lookup(local.as_cloudrun_specs, "domain", null) == null ? 0 : 1
  location = google_cloud_run_service.self.location
  name = lookup(local.as_cloudrun_specs, "domain", "")
  metadata {
    namespace = google_cloud_run_service.self.project
  }
  spec {
    route_name = google_cloud_run_service.self.name
  }
}



