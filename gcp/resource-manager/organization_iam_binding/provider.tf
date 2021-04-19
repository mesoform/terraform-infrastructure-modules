terraform {
  required_version = ">=0.13.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=2.19.0"
    }
  }
}