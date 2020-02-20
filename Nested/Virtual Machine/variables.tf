variable "Location" {
  default = "West Europe"
}
variable "BootDiagStorageAccount" {
  default = "tfsacorestac7824329"
}
variable "RGNameforStorage" {
  default = "tf-rg-core-stac"
}
variable "VMSecret" {
  type = "map"
  default = {
    Username = "CD-Admin"
    Secretname = "DefaultPw"
  }
}
variable "ExistingServersVNet" {
  type = "map"
  default = {
    VNetName = "tf-vn-core-inf"
    VNetRG   = "tf-rg-core-inf"
    ManagementSubnet   = "management"
  }
}

variable "ManagementVMRG" {
  default = "tf-rg-core-mgmt"
}

variable "LinuxMgmtVMS" {
  default = ["tf-vm-core-jbx01"]
}

variable "WindowsMgmtVMS" {
  default = ["tf-vm-core-jb02"]
}

variable "ManagementVirtualMachineSizes" {
  default = ["Standard_B2S"]
}

locals {
  dsc_mode             = "ApplyAndAutoCorrect"
}
 
variable "dscaa-resource-group-name" {
  default = "tf-rg-core-aut"
  description = "Azure Automation azurerm_resource_group name"
}
variable "dscaa-account-name" {
  default = "tf-aa-core-aut"
  description = "Azure Automation azurerm_automation_account name"
}
variable "dscaa-server-endpoint" {
  default = ""
  description = "Azure Automation azurerm_automation_account endpoint URL"
}
variable "dscaa-access-key" {
  default = ""
 description = "Azure Automation azurerm_automation_account access key"
}
 