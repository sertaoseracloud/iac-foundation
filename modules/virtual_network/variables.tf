# modules/virtual_network/variables.tf

variable "name" {
  description = "Nome da rede virtual."
}

variable "address_space" {
  description = "Espaço de endereçamento da rede virtual."
}

variable "location" {
  description = "Localização do recurso."
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos."
}

variable "tags" {
  description = "Tags associadas ao recurso."
  type = map(string)
}

variable "action_group_id" {
  description = "O ID do Action Group"
}