data "vault_generic_secret" "django-vm-credentials"{
  path = "kv/django_vms_cred"
}

data "vault_generic_secret" "ssh-vm-credentials"{
  path = "kv/ssh_creds"
}
data "vault_generic_secret" "private-key"{
  path = "kv/private"
}

data "vault_generic_secret" "postgres-creds"{
  path = "kv/postgres_creds"
}

