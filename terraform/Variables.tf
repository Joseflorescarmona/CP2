variable "resource_group_name" { // fichero con las variables que vamos a utilizar de entrada
  default = "rg-createdbyTF_Jose"
}

variable "location_name" { // fichero con las variables que vamos a utilizar de entrada
  default = "uksouth"      // this location need to exists otherwise it will came up with error (you cant made up a location)
}

variable "network_name" {   //defininmos una red
  default = "vnet1"  
}

variable "Subnet_name" {   //definimos una subred y como siempre el valor por defecto por si no se pasa nada por comandos
  default = "subnet1"
}