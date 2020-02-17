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

resource "azurerm_automation_softwareUpdateConfigurations" "windows_batch" {
  location            = "West Europe"
  name                = "windows_batch"
  resource_group_name = azurerm_resource_group.automation.name

  update_configuration = {
    operating_system = "Windows"

    windows = {
      included_update_classifications = ""
      excludedKbNumbers               = ""
      reboot_setting                  = "IfRequired"
    }
    duration               = "120"
    azure_virtual_machines = []

    targets = {
      scope     = []
      locations = []

      tagSettings = {
        tags           = "UpdateGroup"
        filterOperator = "UpdateGroup01"
      }
    }
    scheduleInfo = {
      startTime = "07:00"
      expiryTime = ""
      expiryTimeOffsetMinutes ="",
      isEnabled =  true,
      nextRun = "string"
      nextRunOffsetMinutes= "number",
      interval= "integer",
      frequency= "string",
      timeZone= "string",
      advancedSchedule= {
        monthlyOccurrences= [
          {
            occurrence = "1"
            day = "tuesday"
          }
        ]
      }
    }
    tasks= {
      preTask = {
        parameters = "optional runbook parameters"
        source = "runbookname"
      }
      postTask = {
        parameters = "optional runbook parameters"
        source = "runbookname"
      }
    }
  }
}

resource "azurerm_automation_softwareUpdateConfigurations" "linux_batch" {
  location            = "West Europe"
  name                = "linux_batch"
  resource_group_name = azurerm_resource_group.automation.name

  update_configuration = {
    operating_system = "Linux"

    windows = {
      included_update_classifications = ""
      excludedKbNumbers               = ""
      reboot_setting                  = "IfRequired"
    }
    duration               = "120"
    azure_virtual_machines = []

    targets = {
      scope     = []
      locations = []

      tagSettings = {
        tags           = "UpdateGroup"
        filterOperator = "UpdateGroup01"
      }
    }
    scheduleInfo = {
      startTime = "07:00"
      expiryTime = ""
      expiryTimeOffsetMinutes ="",
      isEnabled =  true,
      nextRun = "string"
      nextRunOffsetMinutes= "number",
      interval= "integer",
      frequency= "string",
      timeZone= "string",
      advancedSchedule= {
        monthlyOccurrences= [
          {
            occurrence = "1"
            day = "tuesday"
          }
        ]
      }
    }
    tasks= {
      preTask = {
        parameters = "optional runbook parameters"
        source = "runbookname"
      }
      postTask = {
        parameters = "optional runbook parameters"
        source = "runbookname"
      }
    }
  }
}