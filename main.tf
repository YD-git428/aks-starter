module "lb" {
  source = "./modules/loadbalancer"
  resource_group_name = module.vnet.resource_group_name
  resource_group_location = module.vnet.resource_group_location
  lb_sku = "Basic"
  backend_address_pool_name = "coderco-backendips"
  public_ip_address_id = module.vnet.public_ip_id
  lb_name = "coderco-lb"
  lb_probe_name = "coderco-lb-probe"
  frontendip_config_name = "coderco-fe"
  lb_rule_name = "coderco-lb-rule"
}

module "vnet" {
  source = "./modules/vnet"
  pubip_sku = "Basic"
  allocation_method = "Dynamic"
  vnetwork_name = "vnet"
  sec_rule1_name = "http-access"
  sec_rule2_name = "ssh-access"
  secgrp_name = "lb-sec-grp"
  subnet_name = "subnet1"
  rg_name = "coderco-azureproj"
  rg_location = "UK South"
  public_ip_name = "coderco-pubip"
  
}

module "vmss" {
  source = "./modules/vmss" 
  backend_pool = module.lb.lb_backend_pool_id
  resource_group_name = module.vnet.resource_group_name
  resource_location = module.vnet.resource_group_location
  sku = "Standard_DS1_v2"
  vmss_name = "coderco-vmss"
  nic_name = "coderco-nic"
  backend_pool_addresses = [module.lb.lb_backend_pool_id]
  boolean_primary_ipconfig = true
  boolean_primary_nic = true
  offer = "UbuntuServer"
  publisher = "Canonical"
  sku_image_reference = "18.04-LTS"
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  ip_config_name = "coderco-ipconfig"
  instance_amount = 2
  subnet_id = module.vnet.subnet1_id
  admin_username = "coderco-admin"
  
}