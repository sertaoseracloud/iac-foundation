# modules/nsg/main.tf

variable "location" {
  description = "The location of the resources."
  type        = string
}

variable "hubs" {
  description = "A map of hubs with their configurations."
  type        = map(object({
    name                 = string
    resource_group_name  = string
    address_space        = list(string)
    subnet_address_space = list(string)
  }))
}

variable "spoke" {
  description = "Configuration of the spoke."
  type = object({
    name                 = string
    resource_group_name  = string
    address_space        = list(string)
    subnet_address_space = list(string)
  })
}

variable "vpn_client_address_space" {
    description = "address space to vpn client"
    type = list(string)
}

variable "allow_ports" {
  description = "ports to allow"
  type = list(string)
}



