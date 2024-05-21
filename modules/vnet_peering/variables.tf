# modules/vnet_peering/variables.tf`

variable "name" {
  description = "Nome do peering de rede virtual."
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos."
}

variable "virtual_network_name" {
  description = "Nome da rede virtual."
}

variable "remote_virtual_network_id" {
  description = "ID da rede virtual remota."
}
