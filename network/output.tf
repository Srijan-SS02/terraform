output "master_nics" {
    value = azurerm_network_interface.master.id
    description = "azurerm_network_interface_master"
}

output "worker_nics" {
    value = azurerm_network_interface.worker.id
    description = "azurerm_network_interface_worker"
}