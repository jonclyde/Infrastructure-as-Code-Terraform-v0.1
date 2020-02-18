resource "azurerm_resource_group" "NetworkRG" {
  name     = "${var.RGName}"
  location = "${var.location}"  
}
resource "azurerm_virtual_network" "VNet" {
  name          = "${var.VirtualNetwork.name}"
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  address_space = ["${var.VirtualNetwork.addressspace}"]
  location      = "${var.location}"

  
}
resource "azurerm_subnet" "FirewallSubnet" {
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  name = "${var.FirewallSubnet.name}"
  address_prefix = "${var.FirewallSubnet.addressspace}"
  virtual_network_name = "${azurerm_virtual_network.VNet.name}"
  
}
resource "azurerm_subnet" "ManagementSubnet" {
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  name = "${var.ManagementSubnet.name}"
  address_prefix = "${var.ManagementSubnet.addressspace}"
  virtual_network_name = "${azurerm_virtual_network.VNet.name}"
  
}
resource "azurerm_subnet" "DomainSubnet" {
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  name = "${var.DomainSubnet.name}"
  address_prefix = "${var.DomainSubnet.addressspace}"
  virtual_network_name = "${azurerm_virtual_network.VNet.name}"
  
}

resource "azurerm_network_security_group" "FirewallNSG" {
  name                = "${var.FirewallNSG.name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "ManagementNSG" {
  name                = "${var.ManagementNSG.name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "DomainNSG" {
  name                = "${var.DomainNSG.name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "FirewallNSGAssociation" {
  subnet_id                 = "${azurerm_subnet.FirewallSubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.FirewallNSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "ManagementNSGAssociation" {
  subnet_id                 = "${azurerm_subnet.ManagementSubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.ManagementNSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "DomainNSGAssociation" {
  subnet_id                 = "${azurerm_subnet.DomainSubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.DomainNSG.id}"
}