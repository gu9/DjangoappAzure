resource "azurerm_subnet" "webbapp-django" {
  name = "django-subnet"
  resource_group_name = azurerm_resource_group.workload_webapp.name
  virtual_network_name = azurerm_virtual_network.webapp.name
  address_prefixes = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "postgres-subnet" {
  name                 = "postgres-internal-subnet"
  resource_group_name  = azurerm_resource_group.workload_webapp.name
  virtual_network_name = azurerm_virtual_network.webapp.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_postgresql_firewall_rule" "postdb-firewall_rules" {
  name                = "fw"
  resource_group_name = azurerm_resource_group.workload_webapp.name
  server_name         = azurerm_postgresql_server.django-db.name
  start_ip_address    = "104.205.237.246"
  end_ip_address      = "104.205.237.246"
}