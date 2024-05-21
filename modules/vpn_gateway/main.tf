resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }
  vpn_client_configuration {
    vpn_auth_types = ["AAD"]
    vpn_client_protocols = var.vpn_client_protocols
    address_space        = var.vpn_client_address_space
    aad_tenant = "https://login.microsoftonline.com/${var.aad_tenant}"
    aad_audience = var.aad_audience
    aad_issuer = "https://sts.windows.net/${var.aad_tenant}/"
  }
}

