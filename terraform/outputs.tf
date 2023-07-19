output "resource_group_id" { // varoables de salida con el id del resource group
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id //definimos otra variable de salida para cuando se cree la maquina virtual de linux
}

output "vip" {
  value = azurerm_public_ip.pip.ip_address
}

output "ssh_user" {
  value = var.ssh_user
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_user" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = false
}

output "acr_admin_pass" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}