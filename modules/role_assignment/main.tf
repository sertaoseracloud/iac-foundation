resource "azuread_group" "this" {
  count            = length(var.role_assignment)
  display_name     = var.role_assignment[count.index].group
  owners           = [data.azurerm_client_config.this.object_id]
  security_enabled = true
}

resource "azurerm_role_assignment" "this" {
  count                    = length(var.role_assignment)
  scope                    = var.role_assignment[count.index].scope
  principal_id             = azuread_group.this[count.index].object_id
  role_definition_name     = var.role_assignment[count.index].role_definition_name
  depends_on = [azuread_group.this]
}
