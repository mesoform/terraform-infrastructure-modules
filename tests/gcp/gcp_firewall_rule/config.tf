terraform {
  backend "gcs" {
    bucket  = "mesoform-terraform-state"
    prefix  = "terraform/state"
  }
}