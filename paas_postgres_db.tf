

resource "azurerm_postgresql_server" "django-db" {
  name                = "azure-django-psqlserver"
  location            = azurerm_resource_group.workload_webapp.location
  resource_group_name = azurerm_resource_group.workload_webapp.name

  administrator_login          = data.vault_generic_secret.postgres-creds.data["administrator_login"]
  administrator_login_password = data.vault_generic_secret.postgres-creds.data["administrator_login_password"]

  sku_name   = "GP_Gen5_4"
  version    = "9.6"
  storage_mb = 5120
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "dbs" {
  name                = "test-db1"
  resource_group_name = azurerm_resource_group.workload_webapp.name
  server_name         = azurerm_postgresql_server.django-db.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on = [azurerm_postgresql_firewall_rule.postdb-firewall_rules]
}
resource "azurerm_postgresql_virtual_network_rule" "azure_postgres_vnr" {
  name                                 = "postgresql-vnet-rule"
  resource_group_name                  = azurerm_resource_group.workload_webapp.name
  server_name                          = azurerm_postgresql_server.django-db.name
  subnet_id                            = azurerm_subnet.postgres-subnet.id
  ignore_missing_vnet_service_endpoint = true
}
resource "azurerm_postgresql_virtual_network_rule" "azure_postgres_allow_vm_subnet_vnr" {
  name                                 = "allow-vm-subnet-rule"
  resource_group_name                  = azurerm_resource_group.workload_webapp.name
  server_name                          = azurerm_postgresql_server.django-db.name
  subnet_id                            = azurerm_subnet.webbapp-django.id
  ignore_missing_vnet_service_endpoint = true
}