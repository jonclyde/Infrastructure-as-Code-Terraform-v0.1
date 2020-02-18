variable "location" {
  default = "West Europe"
}
variable "RGName" {
  default = "tf-rg-core-inf"
}
variable "VirtualNetwork" {
    type = "map"
    default = {
      name = "tf-vn-core-inf"
      addressspace = "10.10.0.0/22"
    }
}
variable "FirewallSubnet" {
  type = "map"
  default = {
    name = "firewall"
    addressspace = "10.10.0.0/27"
  }
  
}
variable "ManagementSubnet" {
  type = "map"
  default = {
    name = "management"
    addressspace = "10.10.0.64/27"
  }
  
}
variable "DomainSubnet" {
  type = "map"
  default = {
    name = "addc"
    addressspace = "10.10.0.128/27"
  }
  
}

variable "FirewallNSG" {
  type = "map"
  default = {
    deploy = "true"
    name = "tf-nsg-core-fw"
}
}
variable "ManagementNSG" {
  type = "map"
  default = {
    deploy = "true"
    name = "tf-nsg-core-mgmt"
}
}
variable "DomainNSG" {
  type = "map"
  default = {
    deploy = "true"
    name = "tf-nsg-core-addc"
}
}
variable "ManagementRT" {
  default = "tf-rt-core-mgmt"
}
variable "DomainRT" {
  default = "tf-rt-core-addc"
}