module "rg" {
  source = "./modules/ResourceGroup"
  providers = {
    azurerm = azurerm.assessment
  }

  resource_group_name                  = var.resource_group_name
  resource_group_location = var.location
  resource_group_tags                = var.standard_tags
}

module "cludmoreVnet" {
  source = "./modules/VNet"
  providers = {
    azurerm = azurerm.assessment
  }

  vnet_name          = var.vnet_name
  location           = var.location
  rg_name            = module.rg.resource_group_name 
  vnet_address_space = var.vnet_address_space

  tags = var.standard_tags

}

module "cloudmoreSubnet" {
  source = "./modules/Subnet"
  providers = {
    azurerm = azurer.assessment
  }
  subnet_name             = var.subnet_name
  rg_name                 = module.rg.resource_group_name 
  vnet_name               = module.cludmoreVnet.vnet_name
  subnet_address_prefixes = var.subnet_cidr
}

resource "azurerm_public_ip" "cloudmore-ip" {

  name              = var.cloudmoreIp
  location          = var.location
  resource_group_name          = module.rg.resource_group_name 
  allocation_method = "Static"
  domain_name_label = var.domain_name
  tags              = var.standard_tags
}


resource "azurerm_network_security_group" "cloudmoreNSG" {
  name     = var.nsg-cloudmore
  location = var.location
  resource_group_name  = module.rg.resource_group_name 

  security_rule {
    name                       = "SSH"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
  security_rule {
    name                       = "Grafana-access"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Grafana-access"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "prometheus-operator-access"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Network interface Creation
resource "azurerm_network_interface" "interface-cloudmore" {
  name     = var.cloudmore_int
  location = module.rg.resource_group_location
  resource_group_name  = module.rg.resource_group_name 

  ip_configuration {
    name                          = "cloudmorePublic-Ip"
    subnet_id                     = module.cloudmoreSubnet.subnet_name.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudmore-ip
  }

  tags = var.standard_tags
}

#connecting security group to network interface

resource "azurerm_network_interface_security_group_association" "cloud-association" {
  network_interface_id      = azurerm_network_interface.interface-cloudmore.id
  network_security_group_id = azurerm_network_security_group.cloudmoreNSG.id
}

resource "tls_private_key" "cloudmore_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key_output" {
  value     = tls_private_key.cloudmore_private.private_key_pem
  sensitive = true
}

resource "random_password" "passwd" {
  count       = var.disable_password_authentication != true || var.os_flavor == "linux" && var.admin_password == null ? 1 : 0
  length      = var.random_password_length
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false

  keepers = {
    admin_password = var.os_flavor
  }
}

# Virtual Machine creation 

resource "azurerm_linux_virtual_machine" "linux_vm" {
  provider                   = azurerm.assessment
  name                       = var.virtual_machine_name
  computer_name              = var.computer_name
  resource_group_name        = module.rg.resource_group_name 
  location                   = module.rg.resource_group_location
  size                       = var.virtual_machine_size
  admin_username             = var.admin_username
  admin_password             = var.disable_password_authentication != true && var.admin_password == null ? element(concat(random_password.passwd.*.result, [""]), 0) : var.admin_password
  network_interface_ids      = [azurerm_network_interface.interface-cloudmore.id]
  source_image_id            = var.source_image_id != null ? var.source_image_id : null
  provision_vm_agent         = true
  allow_extension_operations = true
  encryption_at_host_enabled = var.enable_encryption_at_host


  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.cloudmore_private.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"

  }


  os_disk {
    storage_account_type = var.os_disk_storage_account_type
    caching              = "ReadWrite"
    disk_size_gb         = var.os_disk_disk_size_gb
  }

  additional_capabilities {
    ultra_ssd_enabled = var.enable_ultra_ssd_data_disk_storage_support
  }

}