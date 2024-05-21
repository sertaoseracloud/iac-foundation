# modules/public_ip/main.tf

resource "azurerm_public_ip" "this" {
  name = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Dynamic"
}

resource "azurerm_monitor_activity_log_alert" "this" {
  name                = "alert-${var.name}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_public_ip.this.id]
  criteria {
    category = "Administrative"
  }
  action {
    action_group_id = var.action_group_id
  }
}
