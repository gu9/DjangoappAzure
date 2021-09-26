resource "azurerm_network_security_rule" "django-vm-in-ssh" {
  access = "Allow"
  direction = "Inbound"
  name = "SSH"
  network_security_group_name = azurerm_network_security_group.django-web-app-nsg.name
  priority = 1001
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.workload_webapp.name

}
