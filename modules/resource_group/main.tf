resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location

  tags = var.tags
}

resource "azurerm_monitor_action_group" "this" {
  name                = "${var.name}-action-group"
  resource_group_name = azurerm_resource_group.this.name
  short_name          = azurerm_resource_group.this.name

  email_receiver {
    name          = "admin"
    email_address = "pedagogico@sertaoseracloud.com"
  }
}

resource "azurerm_monitor_activity_log_alert" "this" {
  name                = "alert-${var.name}"
  resource_group_name = azurerm_resource_group.this.name
  scopes              = [azurerm_resource_group.this.id]
  criteria {
    category = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}


