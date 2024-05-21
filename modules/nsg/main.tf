resource "azurerm_network_security_group" "hub_nsg" {
  for_each = var.hubs

  name                = "${each.key}-${var.spoke.name}-nsg"
  location            = var.location
  resource_group_name = each.value.resource_group_name

  security_rule  {
    name                       = "Allow_Internal_Inbound"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_ranges          = var.allow_ports
    destination_port_range     = "*"
    source_address_prefix      = var.spoke.address_space[0]
    destination_address_prefix = each.value.subnet_address_space[0]
  }

  # Add more rules as needed
}

resource "azurerm_network_security_group" "spoke_nsg" {
  name                = "${var.spoke.name}-nsg"
  location            = var.location
  resource_group_name = var.spoke.resource_group_name

  security_rule {
    name                       = "Allow_From_Hubs"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges     = var.allow_ports
    source_address_prefixes    = [for hub in var.hubs : hub.subnet_address_space[0]]
    destination_address_prefixes = var.spoke.address_space
  }

  security_rule {
    name                       = "Allow_VPN_to_Spoke"
    priority                   = 2002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.vpn_client_address_space
    destination_address_prefixes = var.spoke.address_space
  }

  security_rule {
    name                       = "Deny_all_to_Spoke"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.spoke.address_space[0]
  }

}