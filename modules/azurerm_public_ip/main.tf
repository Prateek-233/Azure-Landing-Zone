resource "azurerm_public_ip" "public_ip" {
  for_each            = var.public_ip
  name                = each.value.public_ip_name
  resource_group_name = each.value.rgname
  location            = each.value.location
  allocation_method   = each.value.allocation_method
}
