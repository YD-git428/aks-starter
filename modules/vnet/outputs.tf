output "resource_group_name" {
  value = azurerm_resource_group.coderco.name
}

output "resource_group_location" {
  value = azurerm_resource_group.coderco.location
}

output "subnet1_id" {
    value = azurerm_subnet.coderco_subnet.id
}

output "public_ip_id" {
  value = azurerm_public_ip.coderco_pub_ip.id
}

output "sg-subnet-association" {
  value = azurerm_subnet_network_security_group_association.nsg_subnet_assoc
}