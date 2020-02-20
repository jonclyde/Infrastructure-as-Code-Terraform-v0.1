provider "azurerm" {
  version = "~> 1.33.1"
}

resource "azurerm_resource_group" "automation" {
  name     = "tf-rg-core-aut"
  location = "West Europe"
}

resource "azurerm_automation_account" "automation" {
  name                = "tf-aa-core-aut"
  location            = azurerm_resource_group.automation.location
  resource_group_name = azurerm_resource_group.automation.name

  sku_name = "Basic"

  tags = {
    environment = "development"
  }
}

resource "azurerm_automation_module" "computermanagementdsc" {
  name                    = "ComputerManagementDsc"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name
  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/ComputerManagementDsc/8.0.0"
  }
}

resource "azurerm_automation_module" "xActiveDirectory" {
  name                    = "xActiveDirectory"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name

  module_link {
    uri = "https://devopsgallerystorage.blob.core.windows.net/packages/xactivedirectory.2.19.0.nupkg"
  }
}

resource "azurerm_automation_dsc_configuration" "RSATFeature" {
  name                    = "RSATFeature"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name
  location                = azurerm_resource_group.automation.location
  content_embedded        = "${file("${path.cwd}/../../Configuration Management/PowerShell DSC/RSATFeature.ps1")}"
}

resource "azurerm_automation_dsc_nodeconfiguration" "RSATFeature" {
  name                    = "RSATFeature.localhost"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name
  depends_on              = [azurerm_automation_dsc_configuration.RSATFeature]

  content_embedded = ""
}