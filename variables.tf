variable "resource_group_name" {
  default = "CloudmoreRg"
  type    = string
}

variable "location" {
  default = "West Europe"
  type    = string
}

variable "standard_tags" {
  type        = map(string)
  description = "Standard Tags to apply to each resource"
  default = {
    environment        = "Cloudmore",
    applicationContact = "",
    applicationName    = "Tallinn",
    businessArea       = "",
    businessUnit       = "",
    managedby          = "Cloudmore",
    created_with       = "Olaitan Falolu",
    solutionOwner      = "",
    dataClassification = "",
    automation         = "",
    costCentre         = "",
    review             = "",
    criticality        = ""
  }
}

variable "vnet_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "cloudmorevnet"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The cidr address space for the primary vnet"
  default     = ["10.150.16.0/22"]
}

variable "subnet_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "cloudmoresubnet"
}

variable "subnet_cidr" {
  type        = list(string)
  description = "Subnet 2 CIDR address"
  default     = ["10.150.16.0/26"]
}
variable "cloudmoreIp" {
  type        = string
  description = "Subnet 2 CIDR address"
  default     = "Cloudmorepublic-IP"
}

variable "domain_name" {
  type        = string
  description = "Subnet 2 CIDR address"
  default     = "cloudmore-temp_gauge"
}

variable "nsg-cloudmore" {
  type        = string
  description = "Subnet 2 CIDR address"
  default     = "Cloudmore-NSG"
}

variable "cloudmore_int" {
  type        = string
  description = "Subnet 2 CIDR address"
  default     = "Cloudmore-interface"
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
  default     = "cloudmorevm"
}
variable "os_flavor" {
  description = "Specify the flavor of the operating system image to deploy Virtual Machine. Valid values are `windows` and `linux`"
  default     = "linux"
}
variable "computer_name" {
  description = "The name of the virtual machine."
  default     = "cloudmorevm"
}

variable "virtual_machine_size" {
  description = "The Virtual Machine SKU for the Virtual Machine, Default is Standard_A2_V2"
  default     = "Standard_A2_v2"
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}
variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine? Defaults to true."
  default     = true
}
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}
variable "source_image_id" {
  description = "The ID of an Image which each Virtual Machine should be based on"
  default     = null
}
variable "enable_encryption_at_host" {
  description = " Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
}
variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "Premium_LRS"
}
variable "os_disk_disk_size_gb" {
  description = "Strorage size of OS Disk in GB. Default is 150GB."
  default     = 150
}

variable "enable_ultra_ssd_data_disk_storage_support" {
  description = "Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine"
  default     = false
}
variable "random_password_length" {
  description = "The desired length of random password created by this module"
  default     = 24
}
