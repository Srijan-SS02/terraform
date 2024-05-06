provider "azurerm" {
  features {}
}

data "terraform_remote_state" "resource_group" {
  backend = "local"

  config = {
    path = "../resource-group/terraform.tfstate" 
  }
}

# virtual network
resource "azurerm_virtual_network" "main" {
  name                = "k8s-vnet"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  address_space       = var.vnet_cidr
  location = var.location
}

# Subnets
resource "azurerm_subnet" "master_subnet" {
  name                = "master-subnet"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = var.master_subnet_CIDR
}

resource "azurerm_subnet" "worker_subnet" {
  name                = "worker-subnet"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = var.worker_subnet_CIDR
}

# network interface
resource "azurerm_network_interface" "master" {
  count = var.master_nodes_count
  name                = "${var.master_prefix}-nic-${count.index}"
  location            = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name

  ip_configuration {
    name                          = "testconfiguration_master-${count.index}"
    subnet_id                     = azurerm_subnet.master_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  
}

resource "azurerm_network_interface" "worker" {
  count = var.worker_nodes_count
  name                = "${var.worker_prefix}-nic-${count.index}"
  location            = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name

  ip_configuration {
    name                          = "testconfiguration_worker-${count.index}"
    subnet_id                     = azurerm_subnet.worker_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  
}

resource "azurerm_network_interface" "admin" {
  count               = var.admin_nodes_count
  name                = "admin-nic"
  location            = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name

  ip_configuration {
    name                          = "testconfiguration_admin-${count.index}"
    subnet_id                     = azurerm_subnet.master_subnet.id  # Using master_subnet currently 
    private_ip_address_allocation = "Dynamic"
  }
}


