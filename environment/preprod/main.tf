module "resource_group" {
  source = "../azurerm_resource_group"
  rgs = var.resource_group
}

module "storage_account" {
  depends_on = [ module.resource_group ]
  source = "../azurerm_storage_account"
  stgaccount = var.storages
}

module "virtual_network" {
  depends_on = [ module.resource_group ]
  source = "../azurerm_virtual_network"
  virtual_networks = var.vnet
}

module "subnet" {
  depends_on = [ module.virtual_network ]
  source = "../azurerm_subnet"
  subnets = var.subnets
}

module "virtual_machine" {
  depends_on = [ module.subnet, module.public-ip ]
  source = "../azurerm_virtual_machine"
  virtual_machine = var.virtual_machine
  
}

module "public-ip" {
  depends_on = [ module.resource_group ]
  source = "../azurerm_public_ip"
  public_ip = var.public_ip
}