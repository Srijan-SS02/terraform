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

data "external" "image_references" {
  program = ["cat", "./scripts/image-builder/images/capi/image_references.txt"]

}


# virtual machines
resource "azurerm_virtual_machine" "master_nodes" {
  count                 = var.master_nodes_count
  name                  = "master-${count.index}"
  location              = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name   = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  network_interface_ids = [element(data.terraform_remote_state.networks.outputs.azurerm_network_interface.master_nics.*.id, count.index)]
  vm_size               = var.machine_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    id = data.external.image_references.result["Ubuntu 22.04"]  # from the image builder
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

  provisioner "local-exec" {
    command = "${path.module}/scripts/image_builder.sh"
  }

}

resource "azurerm_virtual_machine" "worker_nodes" {
  count                 = var.worker_nodes_count
  name                  = "worker-${count.index}"
  location              = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name   = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  network_interface_ids = [element(data.terraform_remote_state.networks.outputs.azurerm_network_interface.worker_nics.*.id, count.index)]
  vm_size               = var.machine_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    id = data.external.image_references.result["Ubuntu 22.04"]
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

  provisioner "local-exec" {
    command = "${path.module}/scripts/image_builder.sh"
  }

}

