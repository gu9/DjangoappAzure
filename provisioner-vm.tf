resource "null_resource" "ConfigureAnsibleLabelVariable" {
  provisioner "local-exec" {
    command = "echo [${var.dev_host_label}:vars] > hosts"
  }
  provisioner "local-exec" {
    command = "echo ansible_ssh_user=${data.vault_generic_secret.django-vm-credentials.data["admin_username"]} >> hosts"
  }
  provisioner "local-exec" {
    command = "echo ansible_ssh_private_key_file=${var.ssh_key_path} >> hosts"
  }
  provisioner "local-exec" {
    command = "echo [${var.dev_host_label}] >> hosts"
  }
}
resource "null_resource" "django-vm-provisioners" {
  count = var.vm_count

  #connection block
  connection {
    type = "ssh"
    host = data.azurerm_public_ip.vm-pub-ip-assigned[count.index].ip_address
    user = data.vault_generic_secret.django-vm-credentials.data["admin_username"]
    #private_key = file("${path.module}/scripts/tf.pem")
    private_key = data.vault_generic_secret.private-key.data["pk"]
    timeout = "1m"
    agent = false

  }

    provisioner "file"{
      source = "${path.module}/Application-release-v1.10"
      destination = "/tmp/Application-release"
  }

  provisioner "file"{
      source = "${path.module}/ansible"
      destination = "/tmp/ansible"
  }

  provisioner "local-exec" {
    command = "echo ${data.azurerm_public_ip.vm-pub-ip-assigned[count.index].ip_address} >> hosts"
  }

}
resource "null_resource" "ModifyApplyAnsiblePlayBook" {
  provisioner "local-exec" {
    command = "sed -i -e '/hosts:/ s/: .*/: ${var.dev_host_label}/' ${path.module}/ansible/play.yml"   #change host label in playbook dynamically
  }
  provisioner "local-exec" {
    command = "sleep 10; ansible-playbook -i hosts ${path.module}/ansible/play.yml"


  }

  depends_on = [null_resource.django-vm-provisioners,
    azurerm_postgresql_virtual_network_rule.azure_postgres_vnr]
}
