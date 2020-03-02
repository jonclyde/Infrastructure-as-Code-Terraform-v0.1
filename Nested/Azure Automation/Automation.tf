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
    #uri = "https://www.powershellgallery.com/api/v2/package/ComputerManagementDsc.7.1.0.nupkg"
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

resource "azurerm_automation_dsc_configuration" "DSCConfigurations" {
  count                   = "${length(var.DSCConfigurations)}"
  name                    = "${element(var.DSCConfigurations, count.index)}"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name
  location                = azurerm_resource_group.automation.location
  content_embedded = "${file("${path.cwd}/../../Configuration Management/PowerShell DSC/${element(var.DSCConfigurations, count.index)}.ps1")}"
}

/*
resource "null_resource" "compile_dsc_config_test1" {
  depends_on              = azurerm_automation_dsc_configuration.DSCConfigurations
  provisioner "local-exec" {
    command = "Install-Module Az ; Get-AzAutomationdscconfiguration -ResourceGroupName ${azurerm_resource_group.automation.name} -AutomationAccountName ${azurerm_automation_account.automation.name} | Start-AzAutomationDscCompilationJob"
    interpreter = ["PowerShell", "-Command"]

  }

}
*/
resource "null_resource" "compile_dsc_config_test2" {
  provisioner "local-exec" {
    command = "powershell.exe -command 'dir'"

  }

}

/*
resource "azurerm_automation_dsc_nodeconfiguration" "RSATFeature" {
  name                    = "RSATFeature.localhost"
  resource_group_name     = azurerm_resource_group.automation.name
  automation_account_name = azurerm_automation_account.automation.name
  depends_on              = [azurerm_automation_dsc_configuration.RSATFeature]

  content_embedded = local_file.foo

}
*/
