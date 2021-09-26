#Terraform Block

terraform {
  required_version = ">=0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.46"
    }
    random = {
      source = "hashicorp/random"
      version = ">=3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
}
provider "vault" {
  address = "http://127.0.0.1:8200"
  token = var.VAULT_TOKEN
  skip_tls_verify = true
}
provider "random" {}
provider "null" {}
