data "azurerm_subnet" "subnets" {
  for_each             = var.virtual_machine
  name                 = each.value.nic_subnet_name
  virtual_network_name = each.value.nic_vnet_name
  resource_group_name  = each.value.rgname
}

data "azurerm_public_ip" "public_ip" {
  for_each            = var.virtual_machine
  name                = each.value.nic_pip_name
  resource_group_name = each.value.rgname
}