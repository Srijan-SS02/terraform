variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
}

variable "location" {
  default = "centralindia"
  description = "Location"
}

variable "master_nodes_count" {
  description = "Number of master nodes"
}

variable "worker_nodes_count" {
  description = "Number of worker nodes"
}

variable "prefix" {
  default = "tfvmex"
}

