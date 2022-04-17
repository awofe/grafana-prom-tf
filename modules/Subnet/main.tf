resource "azurerm_subnet" "created-subnet" {
  provider            = azurerm
  name                = var.subnet_name
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes       = var.subnet_address_prefixes
  service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
  enforce_private_link_service_network_policies = true

}

# resource "azurerm_subnet" "srv-transit-gateway" {
#   provider             = azurerm.transit
#   name                 = var.subnet_name_1
#   resource_group_name  = azurerm_resource_group.transit-rg.name
#   virtual_network_name = azurerm_virtual_network.transit-vnet.name
#   address_prefixes     = var.subnet_cidr_1

# }