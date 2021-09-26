data "azurerm_public_ip" "vm-pub-ip-assigned" {
  count = var.vm_count
  name                = azurerm_public_ip.django-webapp-vm-pub-ip[count.index].name
  resource_group_name = azurerm_resource_group.workload_webapp.name
  depends_on = [azurerm_virtual_machine.django_webapp_vm]
}
