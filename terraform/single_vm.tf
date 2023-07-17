// es un lenguaje declarativo asi que el orde no importa pero suele ser buena practica hacer un orde jerarquico

resource "azurerm_resource_group" "rg" { // recurso de tipo grupo de recursos en azure y en terraform como se llama "rg" en este caso
  name     = var.resource_group_name     // variables que vienen de el fichero variables
  location = var.location_name           // localizacion en azure tambien se cojen de las variables
}

resource "azurerm_virtual_network" "vnet" { // definir la red, o definir su creacion mejor dicho
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" { // definir la subred
  name                 = var.Subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" { //definir el interfaz de red or nic con ip dinamica
  name                = "vnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration { //ip con direcion privada dynamica
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" { // definimos los aspectos necestarios de la maquina virtual de Linux
  name                = "vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2" //tamaño segun el catalgo de azure
  admin_username      = "azureuser"   //usuario
  network_interface_ids = [azurerm_network_interface.nic.id,
  ]


  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/ssh/id_rsa.pub") //clave publica el fichero de mi mac /ssh/id_rsa.pub
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan { // atributo llamado plan que es el sistema operativo a utilizar
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }

  source_image_reference { // versioin especifica del Sistem operativo
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"

  }
}
