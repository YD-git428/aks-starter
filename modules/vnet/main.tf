#This is a resource group which is a container of resources such as VMs or storage accounts etc
resource "azurerm_resource_group" "coderco" {
  name     = var.rg_name
  location = var.rg_location
}

#This is a virtual network which is an isolated network which allows communication between resources
resource "azurerm_virtual_network" "coderco_vnet" {
  name                = var.vnetwork_name
  location            = azurerm_resource_group.coderco.location
  resource_group_name = azurerm_resource_group.coderco.name
  address_space       = ["10.0.0.0/16"]
}

#A subnet is located within a virtual network and contains its own IP addresses which are assigned to resources for communication
resource "azurerm_subnet" "coderco_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.coderco.name
  virtual_network_name = azurerm_virtual_network.coderco_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#A public ip to connect your virtual network to the internet
resource "azurerm_public_ip" "coderco_pub_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.coderco.location
  resource_group_name = azurerm_resource_group.coderco.name
  allocation_method = var.allocation_method
  sku                = var.pubip_sku
}

resource "azurerm_network_security_group" "lb_securitygrp" {
  name = var.secgrp_name
  location = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "coderco_http" {
  name                        = var.sec_rule1_name
  resource_group_name         = azurerm_resource_group.coderco.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.lb_securitygrp.name
}

resource "azurerm_network_security_rule" "coderco_ssh" {
  name                        = var.sec_rule2_name
  resource_group_name         = azurerm_resource_group.coderco.name
  priority                    = 115
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.lb_securitygrp.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
  subnet_id                 = azurerm_subnet.coderco_subnet.id
  network_security_group_id = azurerm_network_security_group.lb_securitygrp.id
}