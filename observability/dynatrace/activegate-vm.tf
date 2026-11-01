resource "azurerm_linux_virtual_machine" "activegate" {
  name                = "vm-dynatrace-activegate"
  resource_group_name = azurerm_resource_group.observability.name
  location            = azurerm_resource_group.observability.location
  size                = "Standard_B2s_v2"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.activegate.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.activegate.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "activegate" {
  name                 = "dynatrace-activegate-installer"
  virtual_machine_id   = azurerm_linux_virtual_machine.activegate.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    script = base64encode(templatefile("${path.module}/install-activegate.sh", {
      DYNATRACE_ENV_URL   = var.dynatrace_env_url
      DYNATRACE_PAAS_TOKEN = var.dynatrace_paas_token
    }))
  })
}

resource "tls_private_key" "activegate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}