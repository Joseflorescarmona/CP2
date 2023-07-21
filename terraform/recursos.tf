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

resource "azurerm_public_ip" "pip" {
  name                = "VIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" { //definir el interfaz de red or nic con ip dinamica
  name                = "vnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration { //ip con direcion privada dynamica
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "NGS" {
  name                = "NGS1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Rule8080"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080" //8080if need only port 80 at the moment all open 
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Rule20"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22" //ssh port 
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
      security_rule {
    name                       = "Rule80"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80" //ssh port 
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "association1" { // asigna el securty group a la red
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.NGS.id
}

resource "azurerm_linux_virtual_machine" "vm" { // definimos los aspectos necestarios de la maquina virtual de Linux
  name                = "vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2" //tamaño segun el catalgo de azure
  admin_username      = var.ssh_user   //usuario
  disable_password_authentication = false
  admin_password      = "azurepassword55!" // password if need it
  network_interface_ids = [azurerm_network_interface.nic.id,
  ]


  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path) //clave publica el fichero de mi mac generada con "az sshkey create --location uksouth --resource-group rg-createdbyTF_Jose --name sshkey-ej-lb "
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

resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.registry_sku
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "AKS" {
  name                = "AKS1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "AKS1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_F2"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "assignment1" {
  principal_id                     = azurerm_kubernetes_cluster.AKS.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

