#Like an autoscaling group but for Virtual Machines based on specified metrics such as CPU 
#Has advantages such as rolling updates if you wanted to update a VM without downtime - supports spot instances = cost effective based on workload
#It's integrated with the load balancer and AZs for redundancy and traffic distribution
resource "azurerm_linux_virtual_machine_scale_set" "coderco_vmss" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  sku                 = var.sku
  instances           = 2 
  admin_username      = var.admin_username

#This is done to ensure that we can ssh into our instances managed by the VMSS, remotely. 
#For public access = ensure that you use an Azure Bastion or an SSH Tunnel + inbound SGs to allow SSH, port 22
  admin_ssh_key {
  username   = var.admin_username
  public_key = file("~/.ssh/id_rsa.pub")
}


#Allows each VM to connect to a virtual network - ensure external communication
#uses the primary network interface, ensures that traffic is routed towards it by default from e.g. Load Balancer or in a DNS Resolution process
  network_interface {
    name    = var.nic_name
    primary = var.boolean_primary_nic

    ip_configuration {
      name                                   = var.ip_config_name
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.backend_pool_addresses
      primary                                = var.boolean_primary_ipconfig
    }
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku_image_reference
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.storage_account_type
    caching             = var.caching
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
echo "Hello! Your CoderCo Tech Test VM is working!" > /var/www/html/index.html
nohup busybox httpd -f -p 80 &
EOF
  )

  tags = {
    environment = "test"
  }
}
