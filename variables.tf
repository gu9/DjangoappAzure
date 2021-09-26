variable "VAULT_TOKEN" {
  default = ""
}

variable "dev_host_label" {
    default = "terra_ansible_host"
}
variable "ssh_key_path" {
    default = "~/.ssh/id_rsa"
}
variable "vm_count" {
  default = 1
}
variable "JUMP_BOX" {
  default = ""
}