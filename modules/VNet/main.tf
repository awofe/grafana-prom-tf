resource "azurerm_virtual_network" "created-vnet" {
  provider            = azurerm
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space

  tags = var.tags
}