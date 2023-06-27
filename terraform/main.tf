terraform {
  required_providers { // proveedores de azure de esta fuente harshicop de version 3.02 o superior del proveedor
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0" // version de terraform 1.1.0 o superior
}

provider "azurerm" { // version expefica para otras features, salvo casos puntuales no se añada nada
  features {}
}