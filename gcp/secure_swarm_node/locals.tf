locals {
  service_account_email = var.service_account_email == "" ? "${data.google_project.default.number}@-compute@developer.gserviceaccount.com" : var.service_account_email
}

