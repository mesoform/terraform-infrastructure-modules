//variable user_project_config_yml {
//  type    = string
//  default = "../../tests/project.yml"
//}
variable "create_google_project" {
  type    = bool
  default = false
}
variable google_org_id {
  type    = string
  default = null
}
variable google_billing_account {
  type    = string
  default = null
}
variable tf_noop_on_destroy {
  type    = bool
  default = null
}
variable "google_location" {
  type    = string
  default = null
}
variable tf_delete_service_on_destroy {
  type    = bool
  default = null
}
variable gcp_ae_yml {
  description = "path to YAML file containing configuration for GAE Applications/Services"
  type        = string
  default     = "../gcp_ae.yml"
}

variable gcp_cloudrun_yml {
  description = "path to YAML file containing configuration for Cloudrun Applications/Services"
  type        = string
  default     = "../gcp_cloudrun.yml"
}

variable gcp_cloudrun_traffic {
  description = "Map of traffic for each revision in format {'revision_name` = percent}"
  type        = map
  default     = null
}

variable gcp_cloudrun_traffic_yml {
  description = "Path to YAML file containing traffic configuration for Cloud Run "
  type        = string
  default     = "../gcp_cloudrun_traffic.yml"
}

variable gcp_ae_traffic {
  description = "Map of traffic for each revision in format {'revision_name` = percent}"
  type        = map
  default     = null
}
variable gcp_ae_traffic_yml {
  description = "Path to YAML file containing traffic configuration for App engine "
  type        = string
  default     = "../gcp_ae_traffic.yml"
}
