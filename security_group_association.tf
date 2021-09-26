resource "azurerm_subnet_network_security_group_association" "django-web-app-sga" {
  network_security_group_id = azurerm_network_security_group.django-web-app-nsg.id
  subnet_id = azurerm_subnet.webbapp-django.id
  depends_on = [azurerm_virtual_machine.django_webapp_vm]
}