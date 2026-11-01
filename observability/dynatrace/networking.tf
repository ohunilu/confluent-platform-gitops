resource "azurerm_resource_group" "observability" {
  name     = var.resource_group_name
  location = var.azure_location
}

resource "azurerm_virtual_network" "activegate" {
  name                = "vnet-observability"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.observability.location
  resource_group_name = azurerm_resource_group.observability.name
}

resource "azurerm_subnet" "activegate" {
  name                 = "snet-activegate"
  resource_group_name  = azurerm_resource_group.observability.name
  virtual_network_name = azurerm_virtual_network.activegate.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_public_ip" "activegate" {
  name                = "pip-activegate"
  location            = azurerm_resource_group.observability.location
  resource_group_name = azurerm_resource_group.observability.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "activegate" {
  name                = "nsg-activegate"
  location            = azurerm_resource_group.observability.location
  resource_group_name = azurerm_resource_group.observability.name

  security_rule {
    name                       = "allow-activegate-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9999"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "activegate" {
  name                = "nic-activegate"
  location            = azurerm_resource_group.observability.location
  resource_group_name = azurerm_resource_group.observability.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.activegate.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.activegate.id
  }
}

resource "azurerm_network_interface_security_group_association" "activegate" {
  network_interface_id      = azurerm_network_interface.activegate.id
  network_security_group_id = azurerm_network_security_group.activegate.id
}