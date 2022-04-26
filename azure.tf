locals {
  location  = data.terraform_remote_state.backend.outputs.azure_location
  rg_name   = data.terraform_remote_state.backend.outputs.azure_rg_name
  subnet_id = data.terraform_remote_state.backend.outputs.azure_subnet_1_id
}

resource "azurerm_public_ip" "wspub_ip" {
  count               = var.resource_count
  name                = "wspub_ip-${count.index}"
  resource_group_name = local.rg_name
  location            = local.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "wsnic" {
  count               = var.resource_count
  name                = "wsnic-${count.index}"
  location            = local.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wspub_ip[count.index].id
  }
}

resource "azurerm_network_security_group" "wsnsg" {
  name                = "ssh_nsg"
  location            = local.location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "allow_nginx_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.resource_count
  network_interface_id      = azurerm_network_interface.wsnic[count.index].id
  network_security_group_id = azurerm_network_security_group.wsnsg.id
}

resource "azurerm_linux_virtual_machine" "wsvm" {
  count               = var.resource_count
  name                = "ws-0${count.index + 1}"
  resource_group_name = local.rg_name
  location            = local.location
  size                = "Standard_B2s"
  network_interface_ids = [
    azurerm_network_interface.wsnic[count.index].id,
  ]

  custom_data = base64encode(file("install.sh"))

  tags = merge(
    var.resource_tags,
    {
      department = var.department
      purpose = var.purpose
    }
  )

  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.azure_ssh_pubkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
}