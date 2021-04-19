variable google_directory_group_id {
  type = string
  description = "Unique ID of the group in Google directory to be managed. E.g. groups/00xvir7l0m3ajlz"
}

variable google_directory_group_members {
  type = map(list(string))
  description = "map of member IDs and a list of roles to give them in the group. I.e. 'OWNER', 'MEMBER', 'MANAGER'"
}