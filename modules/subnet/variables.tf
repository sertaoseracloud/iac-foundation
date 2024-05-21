# modules/subnet/variables.tf

variable "name" {
  description = "Nome da sub-rede."
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos."
}

variable "virtual_network_name" {
  description = "Nome da rede virtual."
}

variable "address_prefixes" {
  description = "Prefixos de endereçamento da sub-rede."
}

#variable "subnets" {
#  description = "Lista de sub-redes a serem criadas."
#  type = map(object({
#    name                 = string
#    resource_group_name  = string
#    virtual_network_name = string
#    address_prefixes     = list(string)
#    tags                 = optional(map(string))
#  }))
#}
