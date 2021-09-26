variable "envname" {
  default = "dev-blue"
}
resource "azurerm_network_interface" "django-vm-nic" {
  count = var.vm_count
  location = azurerm_resource_group.workload_webapp.location
  name = "${var.envname}-webapp-django-nic-${count.index}"
  resource_group_name = azurerm_resource_group.workload_webapp.name
  ip_configuration {
    name = "ipconfig1"
    subnet_id = azurerm_subnet.webbapp-django.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = length(azurerm_public_ip.django-webapp-vm-pub-ip.*.id) > 0 ? element(concat(azurerm_public_ip.django-webapp-vm-pub-ip.*.id, tolist([""])), count.index) : ""

  }

  depends_on = [azurerm_public_ip.django-webapp-vm-pub-ip]
  tags = {
    environment = "dev-blue"
    stack = count.index
  }
}

resource "azurerm_virtual_machine" "django_webapp_vm" {
  count = var.vm_count
  name                  = "${var.envname}-Webapp-VM-${count.index}"
  location              = azurerm_resource_group.workload_webapp.location
  resource_group_name   = azurerm_resource_group.workload_webapp.name
  network_interface_ids = [element(azurerm_network_interface.django-vm-nic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "os-disk-django-vm-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "syn-app-${count.index}"
    admin_username = data.vault_generic_secret.django-vm-credentials.data["admin_username"]
    admin_password = data.vault_generic_secret.django-vm-credentials.data["admin_password"]
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = data.vault_generic_secret.ssh-vm-credentials.data["ssh_pub"]
      path = "/home/${data.vault_generic_secret.django-vm-credentials.data["admin_username"]}/.ssh/authorized_keys"
    }
  }
  
  tags = {
    environment = "dev-blue"
    stack = count.index
  }
}

resource "azurerm_public_ip" "django-webapp-vm-pub-ip" {
  count = var.vm_count
  allocation_method = "Dynamic"
  location = azurerm_resource_group.workload_webapp.location
  name = "syn-app-vm-${count.index}-pub-ip"
  resource_group_name = azurerm_resource_group.workload_webapp.name
  tags = {
        environment = "dev-blue"
    }

}