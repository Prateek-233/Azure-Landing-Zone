resource "azurerm_network_interface" "nic" {
  for_each            = var.virtual_machine
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rgname

  ip_configuration {
    name                          = "Axion-system-IP-Configuration"
    subnet_id                     = data.azurerm_subnet.subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.virtual_machine
  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.rgname

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each                  = var.virtual_machine
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each              = var.virtual_machine
  name                  = each.value.vm_name
  resource_group_name   = each.value.rgname
  location              = each.value.location
  size                  = each.value.vmsize
  admin_username        = each.value.admin_username
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  disable_password_authentication = false
  admin_password                  = each.value.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}
