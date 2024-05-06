variable "master_nodes_count" {
  description = "Number of master nodes"
  default = 2
}

variable "worker_nodes_count" {
  description = "Number of worker nodes"
  default = 4
}


variable "admin_nodes_count" {
  description = "Number of worker nodes"
  default = 1
}

variable "machine_size" {
  description = "Virtual machine size for each node"
  default = "Standard_DS2_v2"
}

variable "storage_size_gb" {
  description = "Storage size for each node in GB"
  default = 30
}


