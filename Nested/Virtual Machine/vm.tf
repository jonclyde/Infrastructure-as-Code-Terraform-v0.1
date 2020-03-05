data "azurerm_subnet" "ManagementSubnet" {
  name                 = "${var.ExistingServersVNet.ManagementSubnet}"
  resource_group_name  = "${var.ExistingServersVNet.VNetRG}"
  virtual_network_name = "${var.ExistingServersVNet.VNetName}"
}

/* Create the Key Vault before referencing it here */
data "azurerm_key_vault" "KeyVault" {
    name = "${var.KeyVaultName}"
    resource_group_name = "tf-rg-core-key"
}

data "azurerm_key_vault_secret" "DefaultPw" {
name = "${var.VMSecret.Secretname}"
vault_uri = "${data.azurerm_key_vault.KeyVault.vault_uri}"
}
/*
data "azurerm_automation_account" "automationAcc" {
    name = "${var.dscaa-account-name}"
    resource_group_name = "${var.dscaa-resource-group-name}"
}
*/
resource "azurerm_resource_group" "StorageAccountRG" {
  name = "${var.RGNameforStorage}"
  location = "${var.Location}"
}

resource "azurerm_resource_group" "ManagementVMRG" {
  name     = "${var.ManagementVMRG}"
  location = "${var.Location}"

}
resource "azurerm_storage_account" "BootDiag" {
  name                     = "${var.BootDiagStorageAccount}"
  resource_group_name      = azurerm_resource_group.StorageAccountRG.name
  location                 = "${var.Location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
resource "azurerm_network_interface" "LinuxMgmtVMsNIC" {
  count               = "${length(var.LinuxMgmtVMS)}"
  name                = "${element(var.LinuxMgmtVMS, count.index)}-nic"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.ManagementVMRG.name}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${data.azurerm_subnet.ManagementSubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "LinuxMgmtVMs" {
  count                 = "${length(var.LinuxMgmtVMS)}"
  name                  = "${element(var.LinuxMgmtVMS, count.index)}"
  location              = "${var.Location}"
  resource_group_name   = "${azurerm_resource_group.ManagementVMRG.name}"
  network_interface_ids = ["${element(azurerm_network_interface.LinuxMgmtVMsNIC.*.id, count.index)}"]
  vm_size               = "${element(var.ManagementVirtualMachineSizes, count.index)}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${element(var.LinuxMgmtVMS, count.index)}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb = "30"
  }
  os_profile {
    computer_name  = "${element(var.LinuxMgmtVMS, count.index)}"
    admin_username = "${var.VMSecret.Username}"
    admin_password = "${data.azurerm_key_vault_secret.DefaultPw.value}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_interface" "WindowsMgmtVMsNIC" {
  count               = "${length(var.WindowsMgmtVMS)}"
  name                = "${element(var.WindowsMgmtVMS, count.index)}-nic"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.ManagementVMRG.name}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${data.azurerm_subnet.ManagementSubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "WindowsMgmtVMS" {
  count                 = "${length(var.WindowsMgmtVMS)}"
  name                  = "${element(var.WindowsMgmtVMS, count.index)}"
  location              = "${var.Location}"
  resource_group_name   = "${azurerm_resource_group.ManagementVMRG.name}"
  network_interface_ids = ["${element(azurerm_network_interface.WindowsMgmtVMsNIC.*.id, count.index)}"]
  vm_size               = "${element(var.ManagementVirtualMachineSizes, count.index)}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${element(var.WindowsMgmtVMS, count.index)}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${element(var.WindowsMgmtVMS, count.index)}"
    admin_username = "${var.VMSecret.Username}"
    admin_password = "${data.azurerm_key_vault_secret.DefaultPw.value}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}
/*
resource "azurerm_virtual_machine_extension" "dsc_extension" {
  count                = "${length(var.WindowsMgmtVMS)}"
  name                 = "Microsoft.Powershell.DSC"
  location             = "${var.Location}"
  resource_group_name  = "${azurerm_resource_group.ManagementVMRG.name}"
  virtual_machine_name = "${element(var.WindowsMgmtVMS, count.index)}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS_JSON
        {
            "configurationArguments": {
                "RegistrationUrl" : "${data.azurerm_automation_account.automationAcc.endpoint}",
                "NodeConfigurationName" : "RSATFeature.localhost",
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
                    "Password": "${data.azurerm_automation_account.automationAcc.primary_key}"
                }
        }
    }
  PROTECTED_SETTINGS_JSON
}*/
