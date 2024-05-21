output "name" {
  description = "O nome do Resource Group"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "A localização do Resource Group"
  value       = azurerm_resource_group.this.location
}

output "id" {
  description = "O ID do Resource Group"
  value       = azurerm_resource_group.this.id
}

output "action_group_id" {
  description = "O ID do Action Group"
  value       = azurerm_monitor_action_group.this.id
}