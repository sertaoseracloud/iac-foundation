# modules/virtual_network/main.tf

resource "azurerm_virtual_network" "this" {
  name = var.name
  address_space = var.address_space
  location = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_monitor_activity_log_alert" "this" {
  name                = "alert-${var.name}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_virtual_network.this.id]
  criteria {
    category = "Administrative"
  }
  action {
    action_group_id = var.action_group_id
  }
}
