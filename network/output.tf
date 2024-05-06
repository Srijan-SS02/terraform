output "master_nics" {
    value = azurerm_network_interface.master[*].id
    description = "azurerm_network_interface_master_id"
}

output "worker_nics" {
    value = azurerm_network_interface.worker[*].id
    description = "azurerm_network_interface_worker_id"
}

output "admin_nics" {
    value = azurerm_network_interface.admin[*].id
    description = "azurerm_network_interface_worker_id"
}