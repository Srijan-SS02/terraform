provider "azurerm" {
  features {}
}

data "terraform_remote_state" "networks" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

data "terraform_remote_state" "resource_group" {
  backend = "local"

  config = {
    path = "../resource-group/terraform.tfstate"
  }
}




# virtual machines
resource "azurerm_virtual_machine" "master_nodes" {
  count                 = var.master_nodes_count
  name                  = "master-${count.index}"
  location              = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name   = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  network_interface_ids = [element(data.terraform_remote_state.networks.outputs.master_nics, count.index)]
  vm_size               = var.machine_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "master-${count.index}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.storage_size_gb
  }

  os_profile {
    computer_name  = "master-${count.index}"
    admin_username = "adminuser"
    admin_password = "YourPassword1234!" # Will use secrets
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

resource "azurerm_virtual_machine" "worker_nodes" {
  count                 = var.worker_nodes_count
  name                  = "worker-${count.index}"
  location              = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name   = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  network_interface_ids = [element(data.terraform_remote_state.networks.outputs.worker_nics, count.index)]
  vm_size               = var.machine_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "worker-${count.index}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.storage_size_gb
  }

  os_profile {
    computer_name  = "worker-${count.index}"
    admin_username = "adminuser"
    admin_password = "YourPassword1234!" # Will use secrets
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  
}

resource "azurerm_virtual_machine" "admin_node" {
  count                 = var.worker_nodes_count
  name                  = "admin-node"
  location              = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name   = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  network_interface_ids = [element(data.terraform_remote_state.networks.outputs.worker_nics, count.index)]
  vm_size               = var.machine_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "admin-node-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.storage_size_gb
  }

  os_profile {
    computer_name  = "admin-node"
    admin_username = "adminuser"
    admin_password = "YourPassword1234!" # Will use secrets
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}