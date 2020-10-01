terraform {
  required_version = "0.12.13"
}
provider "google" {
  region      = "europe-west2"
  project = "protean-buffer-230514"
  version = "2.20"
}
