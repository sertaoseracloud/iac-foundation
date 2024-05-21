# modules/vpn_client_configuration/variables.tf`

variable "name" {
  description = "Nome da configuração do cliente VPN."
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos."
}

variable "virtual_network_gateway_id" {
  description = "ID do gateway da rede virtual."
}

variable "vpn_client_protocols" {
  description = "Protocolos do cliente VPN."
  type = list(string)
}
