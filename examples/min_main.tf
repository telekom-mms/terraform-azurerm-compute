module "resource_group" {
  source = "registry.terraform.io/telekom-mms/resourcegroup/azurerm"
  resource_group = {
    rg-mms-github = {
      location = "westeurope"
    }
  }
}

module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vnet-mms-github = {
      location            = module.resource_group.resource_group["rg-mms-github"].location
      resource_group_name = module.resource_group.resource_group["rg-mms-github"].name
      address_space       = ["10.0.0.0/16"]
    }
  }
  subnet = {
    snet-mms-github = {
      resource_group_name  = module.resource_group.resource_group["rg-mms-github"].name
      virtual_network_name = module.network.virtual_network["vnet-mms-github"].name
      address_prefixes     = ["10.0.2.0/24"]
    }
  }
}

module "network_interface" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  network_interface = {
    nic-mms-github = {
      resource_group_name = module.resource_group.resource_group["rg-mms-github"].name
      location            = module.resource_group.resource_group["rg-mms-github"].location
      ip_configuration = {
        internal = {
          subnet_id                     = module.network.subnet["snet-mms-github"].id
          private_ip_address_allocation = "Dynamic"
        }
      }
    }
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "compute" {
  source = "registry.terraform.io/telekom-mms/compute/azurerm"

  linux_virtual_machine = {
    vm-mms-github = {
      resource_group_name   = module.resource_group.resource_group["rg-mms-github"].name
      location              = module.resource_group.resource_group["rg-mms-github"].location
      size                  = "Standard_B1s"
      admin_username        = "adminuser"
      network_interface_ids = [module.network_interface.network_interface["nic-mms-github"].id]
      admin_ssh_key = {
        key1 = {
          username   = "adminuser"
          public_key = tls_private_key.example.public_key_openssh
        }
      }
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      source_image_reference = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
      }
    }
  }

  managed_disk = {
    disk-mms-github = {
      resource_group_name = module.resource_group.resource_group["rg-mms-github"].name
      location            = module.resource_group.resource_group["rg-mms-github"].location
      disk_size_gb        = 10
    }
  }

  virtual_machine_data_disk_attachment = {
    disk-attachment-min = {
      managed_disk_id    = module.compute.managed_disk["disk-mms-github"].id
      virtual_machine_id = module.compute.linux_virtual_machine["vm-mms-github"].id
      lun                = 10
      caching            = "ReadWrite"
    }
  }
}
