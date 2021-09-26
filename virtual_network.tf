resource "azurerm_virtual_network" "webapp" {
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.workload_webapp.location
  name = "Vnetwork-webapp"
  resource_group_name = azurerm_resource_group.workload_webapp.name
}