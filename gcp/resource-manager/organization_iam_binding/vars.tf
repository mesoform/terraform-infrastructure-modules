variable google_org_id {
  type = number
  description = "Google Cloud Organization ID "
}
variable role {
  type = string
  description = "name of the role to configure a binding for"
}
variable iam_binding {
  type = object({
    members = list(string)
    conditions = list(object({
      title = string
      expression = string
    }))
  })
  description = "Object containing the binding configuration a list of member identities and a list of conditions that may be needed"
}