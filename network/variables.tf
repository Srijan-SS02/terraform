variable "location" {
  default = "centralindia"
  description = "Location"
}

variable "vnet_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/16"] 
  description = "Address space for the virtual network"
}

variable "master_subnet_CIDR" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.0.0/17"]  
}

variable "worker_subnet_CIDR" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.128.0/17"]  
}


variable "master_prefix" {
  default = "master_tfvmex"
}

variable "worker_prefix" {
  default = "worker_tfvmex"
}

variable "master_nodes_count" {
  description = "Number of master nodes"
  default = 2
}

variable "worker_nodes_count" {
  description = "Number of worker nodes"
  default = 3
}


variable "admin_nodes_count" {
  description = "Number of worker nodes"
  default = 1
}


