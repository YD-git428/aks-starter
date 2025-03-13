variable "resource_group_name" {
  type = string
}

variable "resource_location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "backend_pool" {
  type = string
}

variable "vmss_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "instance_amount" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "ip_config_name" {
  type = string
}

variable "boolean_primary_nic" {
    type = bool
}

variable "boolean_primary_ipconfig" {
    type = bool
}

variable "publisher" {
  type = string
}

variable "sku_image_reference" {
  type = string
}

variable "offer" {
  type = string
}

variable "storage_account_type" {
  type = string
}

variable "caching" {
  type = string
}

variable "backend_pool_addresses" {
  type = list(string)
}







