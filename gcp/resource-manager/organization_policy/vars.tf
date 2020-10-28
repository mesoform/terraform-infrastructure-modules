variable organization_policies {
  description = "Map of all the policies to apply at the organization level"
  type = list(map(string))
  default = []
}

variable folder_policies {
  description = "Map of all the policies to apply at the folder level"
  type = list(map(string))
  default = []
}

variable project_policies {
  description = "Map of all the policies to apply at the project level"
  type = list(map(string))
  default = []
}

variable organization_id {
  description = "Google Cloud organization ID"
  type = string
}