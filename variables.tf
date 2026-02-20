variable "linux_virtual_machine" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "managed_disk" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "virtual_machine_data_disk_attachment" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    # resource definition
    linux_virtual_machine = {
      name                            = ""
      computer_name                   = ""
      admin_password                  = null
      license_type                    = null
      allow_extension_operations      = false // defined default
      availability_set_id             = null
      custom_data                     = null
      dedicated_host_id               = null
      disable_password_authentication = true // defined default
      encryption_at_host_enabled      = null
      eviction_policy                 = null
      extensions_time_budget          = "PT1H30M"      // defined default
      patch_mode                      = "ImageDefault" // defined default
      max_bid_price                   = "-1"           // defined default
      platform_fault_domain           = null
      priority                        = "Regular" // defined default
      provision_vm_agent              = true      // defined default
      proximity_placement_group_id    = null
      secure_boot_enabled             = null
      source_image_id                 = null
      user_data                       = null
      vtpm_enabled                    = null
      virtual_machine_scale_set_id    = null
      zone                            = null
      admin_ssh_key                   = {}
      os_disk = {
        name                      = ""
        caching                   = "ReadWrite" // defined default
        storage_account_type      = "Standard_LRS"
        disk_encryption_set_id    = null
        disk_size_gb              = null
        write_accelerator_enabled = null
        diff_disk_settings        = {}
      }
      additional_capabilities = {
        ultra_ssd_enabled = false // defined default
      }
      boot_diagnostics = {
        storage_account_uri = null
      }
      identity = {
        type         = null
        identity_ids = null
      }
      plan   = {}
      secret = {}
      source_image_reference = {
        publisher = null
        offer     = null
        sku       = null
        version   = null
      }
      tags = {}
    }
    managed_disk = {
      name                          = ""
      disk_encryption_set_id        = null
      zone                          = null
      hyper_v_generation            = null
      image_reference_id            = null
      logical_sector_size           = null
      os_type                       = null
      source_resource_id            = null
      source_uri                    = null
      storage_account_id            = null
      tier                          = null
      max_shares                    = null
      trusted_launch_enabled        = null
      on_demand_bursting_enabled    = null
      network_access_policy         = null
      public_network_access_enabled = true // defined default
      encryption_settings = {
        disk_encryption_key = {}
        key_encryption_key  = {}
      }
    }
    virtual_machine_data_disk_attachment = {
      create_option             = "Attach" // defined default
      write_accelerator_enabled = null
      caching                   = "ReadWrite" // defined default
      lun                       = null
    }
  }

  // compare and merge custom and default values
  linux_virtual_machine_values = {
    for linux_virtual_machine in keys(var.linux_virtual_machine) :
    linux_virtual_machine => merge(local.default.linux_virtual_machine, var.linux_virtual_machine[linux_virtual_machine])
  }
  managed_disk_values = {
    for managed_disk in keys(var.managed_disk) :
    managed_disk => merge(local.default.managed_disk, var.managed_disk[managed_disk])
  }

  // merge all custom and default values
  linux_virtual_machine = {
    for linux_virtual_machine in keys(var.linux_virtual_machine) :
    linux_virtual_machine => merge(
      local.linux_virtual_machine_values[linux_virtual_machine],
      {
        for config in [
          "os_disk",
          "additional_capabilities",
          "boot_diagnostics",
          "identity",
          "plan",
          "secret",
          "source_image_reference"
        ] :
        config => merge(local.default.linux_virtual_machine[config], local.linux_virtual_machine_values[linux_virtual_machine][config])
      },
      {
        for config in ["admin_ssh_key"] :
        config => {
          for key in keys(local.linux_virtual_machine_values[linux_virtual_machine][config]) :
          key => merge(local.default.linux_virtual_machine[config], local.linux_virtual_machine_values[linux_virtual_machine][config][key])
        }
      },
    )
  }
  managed_disk = {
    for managed_disk in keys(var.managed_disk) :
    managed_disk => merge(
      local.managed_disk_values[managed_disk],
      {
        for config in ["encryption_settings"] :
        config => merge(local.default.managed_disk[config], local.managed_disk_values[managed_disk][config])
      }
    )
  }
  virtual_machine_data_disk_attachment = {
    for virtual_machine_data_disk_attachment in keys(var.virtual_machine_data_disk_attachment) :
    virtual_machine_data_disk_attachment => merge(local.default.virtual_machine_data_disk_attachment, var.virtual_machine_data_disk_attachment[virtual_machine_data_disk_attachment])
  }
}
