
output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.django-vm-nic.*.private_ip_address
}

output "public_ip_address" {
  value = data.azurerm_public_ip.vm-pub-ip-assigned.*.ip_address
}

output "jump_box_ip" {
  value = var.JUMP_BOX
}
output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the PostgreSQL server"
  value       = azurerm_postgresql_server.django-db.fqdn
}

