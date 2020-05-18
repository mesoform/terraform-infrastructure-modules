variable google_project {
  type = string
  default = null
}
variable "create_google_project" {
  type = bool
  default = false
}
variable google_org_id {
  type = string
  default = null
}
variable google_billing_account {
  type = string
  default = null
}
variable tf_noop_on_destroy {
  type = bool
  default = null
}
variable "google_location" {
  type = string
  default = null
}
variable tf_delete_service_on_destroy {
  type = bool
  default = null
}
