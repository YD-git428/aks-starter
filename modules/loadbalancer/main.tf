#Distributes traffic to healthy VMs
resource "azurerm_lb" "coderco_lb" {
  name                = var.lb_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.lb_sku

  frontend_ip_configuration {
    name                 = var.frontendip_config_name
    public_ip_address_id = var.public_ip_address_id
  }
}

resource "azurerm_lb_backend_address_pool" "coderco_backend_pool" {
  name            = var.backend_address_pool_name
  loadbalancer_id = azurerm_lb.coderco_lb.id
}

resource "azurerm_lb_probe" "lb_health_check" {
  loadbalancer_id = azurerm_lb.coderco_lb.id
  name            = var.lb_probe_name
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.coderco_lb.id
  name                           = var.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontendip_config_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.coderco_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_health_check.id
}