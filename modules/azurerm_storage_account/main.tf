resource "azurerm_storage_account" "stg123" {

  for_each = var.stgaccount

  name                     = each.value.stg_name
  resource_group_name      = each.value.rg_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.art
}
