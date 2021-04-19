terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.64.0"
    }
    google-beta = {
      source = "hashicorp/google"
      version = "3.64.0"
    }
  }
}