terraform {
  required_version = ">= 0.14.0, < 2.0.0"
  experiments = [module_variable_optional_attrs]
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.1.0"
    }
  }
}