locals {
  dsc_mode             = "ApplyAndAutoCorrect"
  vm-name              = "myDSCedVM"
}
 
variable "dscaa-resource-group-name" {
  default = ""
  description = "Azure Automation azurerm_resource_group name"
}
variable "dscaa-account-name" {
  default = ""
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
 
#NOTE: Node data must already exist - otherwise the extension will fail with 'No NodeConfiguration was found for the agent.'
resource "azurerm_virtual_machine_extension" "dsc_extension" {
  name                 = "Microsoft.Powershell.DSC"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_machine_name = "${local.vm-name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"
  auto_upgrade_minor_version = true
  depends_on = ["module.azurerm_virtual_machine_winrmenabled"]
  #use default extension properties as mentioned here:
  #https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-template
  settings = <<SETTINGS_JSON
        {
            "configurationArguments": {
                "RegistrationUrl" : "${var.dscaa-server-endpoint}",
                "NodeConfigurationName" : "rootConfig.${local.vm-name}",
                "ConfigurationMode": "${local.dsc_mode}",
                "RefreshFrequencyMins": 30,
                "ConfigurationModeFrequencyMins": 15,
                "RebootNodeIfNeeded": false,
                "ActionAfterReboot": "continueConfiguration",
                "AllowModuleOverwrite": true
 
            }
        }
  SETTINGS_JSON
  protected_settings = <<PROTECTED_SETTINGS_JSON
    {
        "configurationArguments": {
                "RegistrationKey": {
                    "userName": "NOT_USED",
                    "Password": "${var.dscaa-access-key}"
                }
        }
    }
  PROTECTED_SETTINGS_JSON
}