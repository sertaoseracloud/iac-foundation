variable "name" {
  description = "O nome do gateway VPN"
  type        = string
}

variable "location" {
  description = "A localização do gateway VPN"
  type        = string
}

variable "resource_group_name" {
  description = "O nome do grupo de recursos"
  type        = string
}

variable "subnet_id" {
  description = "O ID da sub-rede onde o gateway VPN será criado"
  type        = string
}

variable "public_ip_id" {
  description = "O ID do IP público para o gateway VPN"
  type        = string
}

variable "vpn_client_protocols" {
  description = "Os protocolos de cliente VPN"
  type        = list(string)
  default     = ["SSTP", "IKEv2"]
}

variable "vpn_client_address_space" {
  description = "O espaço de endereço para o cliente VPN"
  type        = list(string)
}

variable "aad_tenant" {
  description = "Tenant onde vai ser criado a VPN com autenticação Microsoft Entra ID"
  type        = string
}

variable "aad_audience" {
  description = "Client Id gerado pelo Enteorisa Aplication onde vai ser criado a VPN com autenticação Microsoft Entra ID"
  type        = string
}