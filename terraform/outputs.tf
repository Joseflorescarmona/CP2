output "resource_group_id" { // varoables de salida con el id del resource group
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id //definimos otra variable de salida para cuando se cree la maquina virtual de linux
}
