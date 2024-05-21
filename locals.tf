# Carregar variáveis do arquivo JSON
locals {
  env_vars = jsondecode(file("${path.module}/environment/${var.environment}.json"))
}

locals {
  spoke = local.env_vars.spoke
  hubs = local.env_vars.hubs
  tenantId = local.env_vars.tenantId
  allow_ports = local.env_vars.allow_ports
  vpn_client_address_space = local.env_vars.vpn_client_address_space
}

variable "groups" {
  type = map(string)
  default = {
    developer  = "developer"
    reader     = "reader"
  }
}

variable "role_names" {
  type = map(string)
  default = {
    reader        = "Reader"
    backup_reader = "Backup Reader"
    contributor = "Contributor"
  }
}

locals {
  hub_rg_role_assignments = flatten([
    for group, group_name in var.groups : [
      for rg_key, rg in module.hubs_resource_group : [
        {
          role_definition_name = var.role_names["reader"]
          group                = upper("SSC_${group_name}_${rg.name}_${var.role_names["reader"]}")
          scope                = rg.id
        },
        {
          role_definition_name = var.role_names["backup_reader"]
          group                = upper("SSC_${group_name}_${rg.name}_${var.role_names["backup_reader"]}")
          scope                = rg.id
        },
        {
          role_definition_name = var.role_names["contributor"]
          group                = upper("SSC_${group_name}_${rg.name}_${var.role_names["contributor"]}")
          scope                = rg.id
        }
      ]
    ]
  ])
  hub_network_role_assignments = flatten([
    for group, group_name in var.groups : [
      for network_key, network in module.hubs : [
        {
          role_definition_name = var.role_names["reader"]
          group                = upper("SSC_${group_name}_${network.name}_${var.role_names["reader"]}")
          scope                = network.id
        },
        {
          role_definition_name = var.role_names["backup_reader"]
          group                = upper("SSC_${group_name}_${network.name}_${var.role_names["backup_reader"]}")
          scope                = network.id
        },
        {
          role_definition_name = var.role_names["contributor"]
          group                = upper("SSC_${group_name}_${network.name}_${var.role_names["contributor"]}")
          scope                = network.id
        }
      ]
    ]
  ])
  hub_nsg_role_assignments = flatten([
    for group, group_name in var.groups : [
      for idx in range(length(module.nsg.hub_nsg_ids)) : [
        {
          role_definition_name = var.role_names["reader"]
          group                = upper("SSC_${group_name}_${module.nsg.hub_nsg_names[idx]}_${var.role_names["reader"]}")
          scope                = module.nsg.hub_nsg_ids[idx]
        },
        {
          role_definition_name = var.role_names["backup_reader"]
          group                = upper("SSC_${group_name}_${module.nsg.hub_nsg_names[idx]}_${var.role_names["backup_reader"]}")
          scope                = module.nsg.hub_nsg_ids[idx]
        },
        {
          role_definition_name = var.role_names["contributor"]
          group                = upper("SSC_${group_name}_${module.nsg.hub_nsg_names[idx]}_${var.role_names["contributor"]}")
          scope                = module.nsg.hub_nsg_ids[idx]
        }
      ]
    ]
  ])
  spoke_rg_role_assignments = flatten([
    for group, group_name in var.groups : [
      {
        role_definition_name = var.role_names["reader"]
        group                = upper("SSC_${group_name}_${module.spoke_resource_group.name}_${var.role_names["reader"]}")
        scope                = module.spoke_resource_group.id
      },
      {
        role_definition_name = var.role_names["backup_reader"]
        group                = upper("SSC_${group_name}_${module.spoke_resource_group.name}_${var.role_names["backup_reader"]}")
        scope                = module.spoke_resource_group.id
      },
      {
        role_definition_name = var.role_names["contributor"]
        group                = upper("SSC_${group_name}_${module.spoke_resource_group.name}_${var.role_names["contributor"]}")
        scope                = module.spoke_resource_group.id
      }
    ]
  ])
  spoke_network_role_assignments = flatten([
    for group, group_name in var.groups : [
      {
        role_definition_name = var.role_names["reader"]
        group                = upper("SSC_${group_name}_${module.spoke_network.name}_${var.role_names["reader"]}")
        scope                = module.spoke_network.id
      },
      {
        role_definition_name = var.role_names["backup_reader"]
        group                = upper("SSC_${group_name}_${module.spoke_network.name}_${var.role_names["backup_reader"]}")
        scope                = module.spoke_network.id
      },
      {
        role_definition_name = var.role_names["contributor"]
        group                = upper("SSC_${group_name}_${module.spoke_network.name}_${var.role_names["contributor"]}")
        scope                = module.spoke_network.id
      }
    ]
  ])
  spoke_nsg_role_assignments = flatten([
    for group, group_name in var.groups : [
      {
        role_definition_name = var.role_names["reader"]
        group                = upper("SSC_${group_name}_${module.nsg.spoke_nsg_name}_${var.role_names["reader"]}")
        scope                = module.nsg.spoke_nsg_id
      },
      {
        role_definition_name = var.role_names["backup_reader"]
        group                = upper("SSC_${group_name}_${module.nsg.spoke_nsg_name}_${var.role_names["backup_reader"]}")
        scope                = module.nsg.spoke_nsg_id
      },
      {
        role_definition_name = var.role_names["contributor"]
        group                = upper("SSC_${group_name}_${module.nsg.spoke_nsg_name}_${var.role_names["contributor"]}")
        scope                = module.nsg.spoke_nsg_id
      }
    ]
  ])

  role_assignment = concat(
    local.hub_nsg_role_assignments, 
    local.hub_rg_role_assignments, 
    local.hub_network_role_assignments, 
    local.spoke_rg_role_assignments,
    local.spoke_network_role_assignments,
    local.spoke_nsg_role_assignments
  )
}




