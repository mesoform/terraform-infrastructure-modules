terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.0, ~>2.0.2"
    }
    google = {
      source = "hashicorp/google"
      version = ">=3.55.0, <4.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=3.55.0, <4.0.0"
    }
  }
}

provider "google" {}
provider "google-beta" {}
provider "kubernetes" {}