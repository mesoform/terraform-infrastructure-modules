terraform {
  required_version = ">= 1.1.0"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
  }
}
