variable "resource_group_name" { // fichero con las variables que vamos a utilizar de entrada
  default = "rg-createdbyTF_Jose"
}

variable "location_name" { // fichero con las variables que vamos a utilizar de entrada
  default = "uksouth"      // this location need to exists otherwise it will came up with error (you cant made up a location)
}

variable "network_name" { //defininmos una red
  default = "vnet1"
}

variable "Subnet_name" { //definimos una subred y como siempre el valor por defecto por si no se pasa nada por comandos
  default = "subnet1"
}

variable "registry_name" {
  type        = string
  description = "Nombre del registry de imágenes de contenedor"
  default     = "Joseflorescarmona"
}

variable "registry_sku" {
  type        = string
  description = "Tipo de SKU a utilizar por el registry. Opciones válidas: Basic, Standard, Premium."
  default     = "Basic"
}

variable "public_key_path" {
  type        = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  type        = string
  description = "Usuario para hacer ssh"
  default     = "contenedor"
}