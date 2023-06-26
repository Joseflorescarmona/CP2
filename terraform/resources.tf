resource "azurerm_resource_group" "rg"{      // recurso de tipo grupo de recursos en azure y en terraform como se llama "rg" en este caso
    name = var.resource_group_name   // variables que vienen de el fichero variables
    location = var.location_name             // localizacion en azure
}