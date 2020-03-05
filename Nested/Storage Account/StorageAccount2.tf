provider "azurerm" {
  version = "~> 1.33.1"
}

resource "azurerm_resource_group" "lab2" {
  name     = "${var.rg}"
  location = "${var.loc}"
  tags = "${var.tags}" 
}

resource "random_string" "rnd" {
  length                   = 4
  lower                    = false
  number                   = true
  upper                    = false
  special                  = false
}

resource "azurerm_storage_account" "lab2sa" {
  name                     = "${var.tags["source"]}${random_string.rnd.result}"
  resource_group_name      = "${azurerm_resource_group.lab2.name}"
  location                 = "${azurerm_resource_group.lab2.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = "${azurerm_resource_group.lab2.tags}"
}