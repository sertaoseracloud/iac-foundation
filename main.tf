# Criar recursos para cada hub
module "hubs_resource_group" {
  source   = "./modules/resource_group"
  for_each = { for hub in local.hubs : hub.name => hub }
  name     = "rg-${each.value.name}"
  location = local.env_vars.location
  tags     = {
    environment = var.environment
  }
}


module "hubs" {
  source = "./modules/virtual_network"
  for_each = { for hub in local.hubs : hub.name => hub }
  name = "${each.value.name}-vnet"
  address_space = each.value.address_space
  location = local.env_vars.location
  resource_group_name = module.hubs_resource_group[each.key].name
  action_group_id = module.hubs_resource_group[each.key].action_group_id
  tags = { environment = "hub" }
}

module "hub_subnets" {
  source = "./modules/subnet"
  for_each = { for hub in local.hubs : hub.name => hub }
  name = "${each.value.name}-subnet"
  virtual_network_name = module.hubs[each.key].name
  address_prefixes = each.value.subnet_address_space
  resource_group_name = module.hubs_resource_group[each.key].name
}

# Criar recursos para spoke
module "spoke_resource_group" {
  source   = "./modules/resource_group"
  name     = "rg-${local.spoke.name}"
  location = local.env_vars.location
  tags     = {
    environment = var.environment
  }
}

module "spoke_network" {
  source = "./modules/virtual_network"
  name = "${local.spoke.name}-vnet"
  address_space = local.spoke.address_space
  location = local.env_vars.location
  resource_group_name = module.spoke_resource_group.name
  action_group_id = module.spoke_resource_group.action_group_id
  tags = { environment = "spoke" }
}

module "spoke_subnet" {
  source = "./modules/subnet"
  name = "GatewaySubnet" 
  virtual_network_name = module.spoke_network.name
  address_prefixes = local.spoke.subnet_address_space
  resource_group_name = module.spoke_resource_group.name
}


module "nsg" {
  source   = "./modules/nsg"
  location = local.env_vars.location
  allow_ports = local.allow_ports
  vpn_client_address_space = local.vpn_client_address_space 
  hubs = {
    for hub in local.hubs : hub.name => {
      name                 = hub.name
      resource_group_name  = module.hubs_resource_group[hub.name].name
      address_space        = hub.address_space
      subnet_address_space = hub.subnet_address_space
    }
  }
  spoke = {
    name                 = local.spoke.name
    resource_group_name  = module.spoke_resource_group.name
    address_space        = local.spoke.address_space
    subnet_address_space = local.spoke.subnet_address_space
  }
}


module "role_assignment" {
  source = "./modules/role_assignment"

  role_assignment = local.role_assignment
  depends_on      = [module.spoke_subnet, module.hub_subnets, module.nsg]
}

# Peering entre hubs e spoke
module "hub_to_spoke_peerings" {
  source = "./modules/vnet_peering"
  for_each = { for hub in local.hubs : hub.name => hub }
  name = "${each.value.name}-to-spoke"
  virtual_network_name = module.hubs[each.key].name
  remote_virtual_network_id = module.spoke_network.id
  resource_group_name = module.hubs_resource_group[each.key].name
}

module "spoke_to_hub_peerings" {
  source = "./modules/vnet_peering"
  for_each = { for hub in local.hubs : hub.name => hub }
  name = "spoke-to-${each.value.name}"
  virtual_network_name = module.spoke_network.name
  remote_virtual_network_id = module.hubs[each.key].id
  resource_group_name = module.spoke_resource_group.name
}

module "vpn_public_ip" {
  source = "./modules/public_ip"
  name = "vpn-public-ip"
  resource_group_name = module.spoke_resource_group.name
  location = local.env_vars.location
  action_group_id = module.spoke_resource_group.action_group_id
}

module "application_registration" {
  source = "./modules/application_registration"
}

module "vpn_gateway" {
  source = "./modules/vpn_gateway"
  name = "vpn-gateway"
  location = local.env_vars.location
  resource_group_name = module.spoke_resource_group.name
  subnet_id = module.spoke_subnet.id 
  public_ip_id = module.vpn_public_ip.id
  vpn_client_protocols = ["OpenVPN"]
  vpn_client_address_space = local.vpn_client_address_space 
  aad_tenant = local.tenantId
  aad_audience = module.application_registration.aad_audience

  depends_on = [ module.role_assignment ]
}
