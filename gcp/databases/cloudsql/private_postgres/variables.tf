variable project_id {
  description = "The project ID of the VPC network to peer. This can be a shared VPC host project"
  type        = string
}

variable vpc_network {
  description = "Name of the VPC network to peer"
  type        = string
}

variable private_address {
  description = "First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you"
  type        = string
  default     = ""
}

variable cloudsql_instance_name {
  type        = string
  description = "The name of the CloudSQL instance"
}

variable database_version {
  description = "The database version to use"
  type        = string
}

variable region {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "europe-west2"
}

variable zone {
  type        = string
  description = "The zone for the CloudSQL instance"
}

variable cloudsql_instance_tier {
  description = "The tier for the CloudSQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable deletion_protection {
  description = "Used to block Terraform from deleting a CloudSQL instance"
  type        = bool
  default     = false
}

variable database_flags {
  description = "The database flags for the CloudSQL instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable db_name {
  description = "The name of the default database to create"
  type        = string
  default     = "default"
}

variable user_name {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable additional_users {
  description = "A list of users to be created in your cluster"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable additional_databases {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}
