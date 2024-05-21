variable "role_assignment" {
  description = "List of role assignments"
  type = list(object({
    role_definition_name = string
    group                = string
    scope                = string
  }))
}