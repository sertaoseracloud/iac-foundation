# modules/vpn_client_configuration/main.tf`

resource "azurerm_vpn_client_configuration" "this" {
  name = var.name
  resource_group_name = var.resource_group_name
  virtual_network_gateway_id = var.virtual_network_gateway_id
  vpn_client_protocols = var.vpn_client_protocols
}
