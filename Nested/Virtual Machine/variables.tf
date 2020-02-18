variable "Location" {
  default = "West Europe"
}
variable "BootDiagStorageAccount" {
  default = "tfsacorestac7824329"
}
variable "RGNameforStorage" {
  default = "tf-rg-core-stac"
}

variable "KeyVaultName" {
  default = "tf-kv-core-key"
}

variable "VMSecret" {
  type = "map"
  default = {
    Username = "CD-Admin"
    Secretname = "DefaultPw"
    vault_uri   = "https://tr-eus-keyvault.vault.azure.net/"
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