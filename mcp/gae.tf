locals {
  gae_files = fileset(path.root, "../**/app.y?ml")
  gae_app = {
    for app_file in local.gae_files:
      basename(dirname(app_file)) => yamldecode(file(app_file))
      if !contains(split("/", app_file), "terraform") &&
         substr(app_file, 2, 18) != "/build/staged-app/"
  }
}
//resource "google_project" "my_project" {
//  name = "appeng-flex"
//  project_id = "appeng-flex"
//  org_id = "123456789"
//  billing_account = "000000-0000000-0000000-000000"
//}
//
//resource "google_app_engine_application" "app" {
//  project     = google_project.my_project.project_id
//  location_id = "us-central"
//}
//
//resource "google_project_service" "service" {
//  project = google_project.my_project.project_id
//  service = "appengineflex.googleapis.com"
//
//  disable_dependent_services = false
//}
//
//resource "google_project_iam_member" "gae_api" {
//  project = google_project_service.service.project
//  role    = "roles/compute.networkUser"
//  member  = "serviceAccount:service-${google_project.my_project.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
//}
//
//resource "google_app_engine_flexible_app_version" "myapp_v1" {
//  version_id = "v1"
//  project    = google_project_iam_member.gae_api.project
//  service    = "default"
//  runtime    = "nodejs"
//
//  liveness_check {
//    path = "/"
//  }
//
//  readiness_check {
//    path = "/"
//  }
//
//  env_variables = {
//    port = "8080"
//  }
//
//  automatic_scaling {
//    cool_down_period = "120s"
//    cpu_utilization {
//      target_utilization = 0.5
//    }
//  }
//
//  noop_on_destroy = true
//}