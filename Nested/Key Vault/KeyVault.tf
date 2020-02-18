data "azurerm_client_config" "current" {
}
resource "azurerm_resource_group" "KeyvaultRG" {
  name     = "${var.RGNameforKeyVault}"
  location = "${var.Location}"  
}
resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.NameforKeyVault}"
  location                    = azurerm_resource_group.KeyvaultRG.location
  resource_group_name         = azurerm_resource_group.KeyvaultRG.name
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "accesspolicy" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  object_id = "${data.azurerm_client_config.current.object_id}"

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set"

  ]
}

resource "azurerm_key_vault_secret" "DefaultPw" {
  name         = "DefaultPw"
  key_vault_id = azurerm_key_vault.keyvault.id
  value        = "FXR-ty-'DT=)4YHA"
}