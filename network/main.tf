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
  address_space       = ["${var.vnet_cidr}"]
  location = var.location
}

# Subnets
resource "azurerm_subnet" "master_subnet" {
  name                = "master-subnet"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "worker_subnet" {
  name                = "worker-subnet"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = ["10.0.3.0/24"]
}

# network interface
resource "azurerm_network_interface" "master" {
  name                = "${var.prefix}-nic"
  location            = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.master_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  
}

resource "azurerm_network_interface" "worker" {
  name                = "${var.prefix}-nic"
  location            = data.terraform_remote_state.resource_group.outputs.default_resource_group_location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.default_resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.worker_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  
}


