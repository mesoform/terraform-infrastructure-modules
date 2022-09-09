variable project {
  type        = string
  description = "The project ID to manage the secrets"
}

variable location {
  type        = string
  description = "The canonical IDs of the location to replicate data. For example: us-east1"
  default     = "europe-west2"
}

variable secret_id {
  description = "The unique secret ID"
  type        = string
}

variable secret_data {
  description = "The secret data. Must be no larger than 64KiB. Note: This property is sensitive and will not be displayed in the plan."
  type        = string
}
