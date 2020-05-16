locals {
  gae_files = fileset(path.root, "../**/app.y{a,}ml")
  gae_apps = {
  for app_file in local.gae_files:
    basename(dirname(app_file)) => yamldecode(file(app_file))
    if !contains(split("/", app_file), "terraform") &&
        substr(app_file, 2, 18) != "/build/staged-app/"
  }
  gae_apps_list = {
    for app, config in local.gae_apps:
      app => merge(app, local.common[app])
  }
}
resource "google_project" "self" {
  name = var.google_project
  project_id = var.google_project
  org_id = var.google_org_id
  billing_account = var.google_billing_account
}

resource "google_app_engine_application" "self" {
  project = google_project.self.project_id
  location_id = "us-central"
}

resource "google_project_service" "self" {
  project = google_project.self.project_id
  service = "appengineflex.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_iam_member" "self" {
  project = google_project_service.self.project
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-${google_project.self.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
}

//noinspection HILUnresolvedReference
resource "google_app_engine_flexible_app_version" "myapp_v1" {
  for_each = local.gae_apps_list

  version_id = each.value.version_id == null ? v1 : each.value.version_id
  project = google_project_iam_member.self.project
  service = "default"
  runtime = "nodejs"

  liveness_check = each.value.liveness_check == null ? v1 : each.value.liveness_check

  readiness_check
  {
    path = "/"
  }

  env_variables = {
    port = "8080"
  }

  automatic_scaling {
    cool_down_period = "120s"
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  noop_on_destroy = true
}