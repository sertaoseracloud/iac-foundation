resource "azuread_application_registration" "this" {
  display_name     = "Azure VPN"
  description      = "VPN para conectar no ambiente Hub-Spoke"
  sign_in_audience = "AzureADMyOrg"
}