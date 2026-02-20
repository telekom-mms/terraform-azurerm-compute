/**
* # compute
*
* This module manages the azurerm compute resources, see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs.
*
* For more information about the module structure see https://telekom-mms.github.io/terraform-template.
*
*/

/* Linux Virtual Machine */
resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  for_each = var.linux_virtual_machine

  name                = local.linux_virtual_machine[each.key].name == "" ? each.key : local.linux_virtual_machine[each.key].name
  location            = local.linux_virtual_machine[each.key].location
  resource_group_name = local.linux_virtual_machine[each.key].resource_group_name

  admin_username                  = local.linux_virtual_machine[each.key].admin_username
  admin_password                  = local.linux_virtual_machine[each.key].admin_password
  computer_name                   = local.linux_virtual_machine[each.key].computer_name
  size                            = local.linux_virtual_machine[each.key].size
  network_interface_ids           = local.linux_virtual_machine[each.key].network_interface_ids
  license_type                    = local.linux_virtual_machine[each.key].license_type
  allow_extension_operations      = local.linux_virtual_machine[each.key].allow_extension_operations
  availability_set_id             = local.linux_virtual_machine[each.key].availability_set_id
  custom_data                     = local.linux_virtual_machine[each.key].custom_data
  dedicated_host_id               = local.linux_virtual_machine[each.key].dedicated_host_id
  disable_password_authentication = local.linux_virtual_machine[each.key].disable_password_authentication
  encryption_at_host_enabled      = local.linux_virtual_machine[each.key].encryption_at_host_enabled
  eviction_policy                 = local.linux_virtual_machine[each.key].eviction_policy
  extensions_time_budget          = local.linux_virtual_machine[each.key].extensions_time_budget
  patch_mode                      = local.linux_virtual_machine[each.key].patch_mode
  max_bid_price                   = local.linux_virtual_machine[each.key].max_bid_price
  platform_fault_domain           = local.linux_virtual_machine[each.key].platform_fault_domain
  priority                        = local.linux_virtual_machine[each.key].priority
  provision_vm_agent              = local.linux_virtual_machine[each.key].provision_vm_agent
  proximity_placement_group_id    = local.linux_virtual_machine[each.key].proximity_placement_group_id
  secure_boot_enabled             = local.linux_virtual_machine[each.key].secure_boot_enabled
  source_image_id                 = local.linux_virtual_machine[each.key].source_image_id
  user_data                       = local.linux_virtual_machine[each.key].user_data
  vtpm_enabled                    = local.linux_virtual_machine[each.key].vtpm_enabled
  virtual_machine_scale_set_id    = local.linux_virtual_machine[each.key].virtual_machine_scale_set_id
  zone                            = local.linux_virtual_machine[each.key].zone

  dynamic "admin_ssh_key" {
    for_each = local.linux_virtual_machine[each.key].admin_ssh_key

    content {
      public_key = local.linux_virtual_machine[each.key].admin_ssh_key[admin_ssh_key.key].public_key
      username   = local.linux_virtual_machine[each.key].admin_ssh_key[admin_ssh_key.key].username
    }
  }

  os_disk {
    name                      = local.linux_virtual_machine[each.key].os_disk.name == "" ? each.key : local.linux_virtual_machine[each.key].os_disk.name
    caching                   = local.linux_virtual_machine[each.key].os_disk.caching
    storage_account_type      = local.linux_virtual_machine[each.key].os_disk.storage_account_type
    disk_encryption_set_id    = local.linux_virtual_machine[each.key].os_disk.disk_encryption_set_id
    disk_size_gb              = local.linux_virtual_machine[each.key].os_disk.disk_size_gb
    write_accelerator_enabled = local.linux_virtual_machine[each.key].os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = local.linux_virtual_machine[each.key].os_disk.diff_disk_settings != {} ? [1] : []

      content {
        option = local.linux_virtual_machine[each.key].os_disk.diff_disk_settings.option
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = local.linux_virtual_machine[each.key].additional_capabilities.ultra_ssd_enabled != false ? [1] : []

    content {
      ultra_ssd_enabled = local.linux_virtual_machine[each.key].additional_capabilities.ultra_ssd_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = local.linux_virtual_machine[each.key].boot_diagnostics.storage_account_uri != "" ? [1] : []

    content {
      storage_account_uri = local.linux_virtual_machine[each.key].boot_diagnostics.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = local.linux_virtual_machine[each.key].identity.type != "" ? [1] : []

    content {
      type         = local.linux_virtual_machine[each.key].identity.type
      identity_ids = local.linux_virtual_machine[each.key].identity.identity_ids
    }
  }

  dynamic "plan" {
    for_each = local.linux_virtual_machine[each.key].plan != {} ? [1] : []

    content {
      name      = local.linux_virtual_machine[each.key].plan.name
      product   = local.linux_virtual_machine[each.key].plan.product
      publisher = local.linux_virtual_machine[each.key].plan.publisher
    }
  }

  dynamic "secret" {
    for_each = local.linux_virtual_machine[each.key].secret != {} ? [1] : []

    content {
      key_vault_id = local.linux_virtual_machine[each.key].secret.key_vault_id
      certificate {
        url = local.linux_virtual_machine[each.key].secret.certificate.url
      }
    }
  }

  dynamic "source_image_reference" {
    for_each = local.linux_virtual_machine[each.key].source_image_reference.publisher != "" ? [1] : []

    content {
      publisher = local.linux_virtual_machine[each.key].source_image_reference.publisher
      offer     = local.linux_virtual_machine[each.key].source_image_reference.offer
      sku       = local.linux_virtual_machine[each.key].source_image_reference.sku
      version   = local.linux_virtual_machine[each.key].source_image_reference.version
    }
  }

  tags = local.linux_virtual_machine[each.key].tags
}

resource "azurerm_managed_disk" "managed_disk" {
  for_each = var.managed_disk

  name                          = local.managed_disk[each.key].name == "" ? each.key : local.managed_disk[each.key].name
  location                      = local.managed_disk[each.key].location
  resource_group_name           = local.managed_disk[each.key].resource_group_name
  storage_account_type          = local.managed_disk[each.key].storage_account_type
  create_option                 = local.managed_disk[each.key].create_option
  disk_encryption_set_id        = local.managed_disk[each.key].disk_encryption_set_id
  zone                          = local.managed_disk[each.key].zone
  disk_size_gb                  = local.managed_disk[each.key].disk_size_gb
  hyper_v_generation            = local.managed_disk[each.key].hyper_v_generation
  image_reference_id            = local.managed_disk[each.key].image_reference_id
  logical_sector_size           = local.managed_disk[each.key].logical_sector_size
  os_type                       = local.managed_disk[each.key].os_type
  source_resource_id            = local.managed_disk[each.key].source_resource_id
  source_uri                    = local.managed_disk[each.key].source_uri
  storage_account_id            = local.managed_disk[each.key].storage_account_id
  tier                          = local.managed_disk[each.key].tier
  max_shares                    = local.managed_disk[each.key].max_shares
  trusted_launch_enabled        = local.managed_disk[each.key].trusted_launch_enabled
  on_demand_bursting_enabled    = local.managed_disk[each.key].on_demand_bursting_enabled
  network_access_policy         = local.managed_disk[each.key].network_access_policy
  public_network_access_enabled = local.managed_disk[each.key].public_network_access_enabled

  dynamic "encryption_settings" {
    for_each = length(compact(values(local.managed_disk[each.key].encryption_settings.disk_encryption_key), values(local.managed_disk[each.key].encryption_settings.key_encryption_key))) > 0 ? [0] : []

    content {
      dynamic "disk_encryption_key" {
        for_each = local.managed_disk[each.key].encryption_settings.disk_encryption_key
        content {
          secret_url      = local.managed_disk[each.key].encryption_settings.disk_encryption_key.secret_url
          source_vault_id = local.managed_disk[each.key].encryption_settings.disk_encryption_key.source_vault_id
        }
      }
      dynamic "key_encryption_key" {
        for_each = local.managed_disk[each.key].encryption_settings.key_encryption_key
        content {
          key_url         = local.managed_disk[each.key].encryption_settings.key_encryption_key.key_url
          source_vault_id = local.managed_disk[each.key].encryption_settings.key_encryption_key.source_vault_id
        }
      }
    }
  }

  tags = local.managed_disk[each.key].tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_data_disk_attachment" {
  for_each = var.virtual_machine_data_disk_attachment

  virtual_machine_id        = local.virtual_machine_data_disk_attachment[each.key].virtual_machine_id
  managed_disk_id           = local.virtual_machine_data_disk_attachment[each.key].managed_disk_id
  lun                       = local.virtual_machine_data_disk_attachment[each.key].lun
  caching                   = local.virtual_machine_data_disk_attachment[each.key].caching
  create_option             = local.virtual_machine_data_disk_attachment[each.key].create_option
  write_accelerator_enabled = local.virtual_machine_data_disk_attachment[each.key].write_accelerator_enabled
}
