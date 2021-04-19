variable google_directory_customer_id {
  type = string
  description = "ID of the Google directory or `gcloud organizations list`"
}
variable google_directory_group_id {
  type = string
  description = "ID of the group in Google directory to be managed something@somewhere.com"
}

variable google_directory_group_name {
  type = string
  description = "Human readable name of the group in Google directory to be managed"
}