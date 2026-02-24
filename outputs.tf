output "linux_virtual_machine" {
  description = "Outputs all attributes of azurerm_linux_virtual_machine."
  value = {
    for linux_virtual_machine in keys(azurerm_linux_virtual_machine.linux_virtual_machine) :
    linux_virtual_machine => {
      for key, value in azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine] :
      key => value
    }
  }
}

output "managed_disk" {
  description = "Outputs all attributes of azurerm_managed_disk."
  value = {
    for managed_disk in keys(azurerm_managed_disk.managed_disk) :
    managed_disk => {
      for key, value in azurerm_managed_disk.managed_disk[managed_disk] :
      key => value
    }
  }
}

output "virtual_machine_data_disk_attachment" {
  description = "Outputs all attributes of azurerm_virtual_machine_data_disk_attachment."
  value = {
    for virtual_machine_data_disk_attachment in keys(azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment) :
    virtual_machine_data_disk_attachment => {
      for key, value in azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment[virtual_machine_data_disk_attachment] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      linux_virtual_machine = {
        for key in keys(var.linux_virtual_machine) :
        key => local.linux_virtual_machine[key]
      }
      managed_disk = {
        for key in keys(var.managed_disk) :
        key => local.managed_disk[key]
      }
      virtual_machine_data_disk_attachment = {
        for key in keys(var.virtual_machine_data_disk_attachment) :
        key => local.virtual_machine_data_disk_attachment[key]
      }
    }
  }
}
