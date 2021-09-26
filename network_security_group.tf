resource "azurerm_network_security_group" "django-web-app-nsg" {
  location = azurerm_resource_group.workload_webapp.location
  name = "django-web-app-nsg"
  resource_group_name = azurerm_resource_group.workload_webapp.name

}