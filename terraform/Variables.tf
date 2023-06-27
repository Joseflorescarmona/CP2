variable "resource_group_name"{   // fichero con las variables que vamos a utilizar de entrada
    default = "rg-createdbyTF"
}
variable "location_name"{        // fichero con las variables que vamos a utilizar de entrada
    default = "uksouth"          // this location need to exists otherwise it will came up with error (you cant made up a location)
}