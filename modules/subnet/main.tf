# modules/subnet/main.tf

resource "azurerm_subnet" "this" {
  name = var.name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = var.address_prefixes
}

#resource "azurerm_subnet" "example" {
#  for_each = var.subnets
#  
#  name                 = each.value.name
#  resource_group_name  = each.value.resource_group_name
#  virtual_network_name = each.value.virtual_network_name
#  address_prefixes     = each.value.address_prefixes
#
#  tags = each.value.tags
#}
