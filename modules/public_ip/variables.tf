# modules/public_ip/variables.tf`

variable "name" {
  description = "Nome do IP público."
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos."
}

variable "location" {
  description = "Localização do recurso."
}

variable "action_group_id" {
  description = "O ID do Action Group"
}