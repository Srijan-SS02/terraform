variable "master_nodes_count" {
  description = "Number of master nodes"
}

variable "worker_nodes_count" {
  description = "Number of worker nodes"
}

variable "admin_nodes_count" {
  description = "Number of admin nodes"
}

variable "machine_size" {
  description = "Virtual machine size for each node"
}

variable "storage_size_gb" {
  description = "Storage size for each node in GB"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnets"
}

