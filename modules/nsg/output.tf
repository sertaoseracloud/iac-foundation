output "hub_nsg_ids" {
  description = "IDs of the hub NSGs"
  value       = [for nsg in azurerm_network_security_group.hub_nsg : nsg.id]
}

output "hub_nsg_names" {
  description = "IDs of the hub NSGs"
  value       = [for nsg in azurerm_network_security_group.hub_nsg : nsg.name]
}

output "spoke_nsg_id" {
  description = "ID of the spoke NSG"
  value       = azurerm_network_security_group.spoke_nsg.id
}

output "spoke_nsg_name" {
  description = "ID of the spoke NSG"
  value       = azurerm_network_security_group.spoke_nsg.name
}