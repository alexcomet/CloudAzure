data "azurerm_resource_group" "sandbox_rg" {
  name = "sandbox"
}

data "azurerm_virtual_network" "sandbox_vnet" {
  name                = "sandbox-vnet"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
}

data "azurerm_subnet" "subnet_1" {
  name                 = "sandbox-subnet"
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
}

# TODO : Add LB

resource "azurerm_network_security_group" "nsg_sandbox" {
  name                = "sandbox-nsg"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
}

resource "azurerm_network_interface" "nic_instance_1" {
  name                = "nic-instance-1"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name

  ip_configuration {
    name                          = "ip-instance-1"
    subnet_id                     = data.azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = data.azurerm_subnet.subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_sandbox.id
}

resource "azurerm_linux_virtual_machine" "instance_1" {
  name                = "instance-1"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  size                = "Standard_D2S_v3"
  admin_username      = "ravindra"

  network_interface_ids = [
    azurerm_network_interface.nic_instance_1.id,
  ]

  admin_ssh_key {
    username   = "ravindra"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "instance_2" {
  name                = "instance-2"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  size                = "Standard_D2S_v3"
  admin_username      = "ravindra"

  network_interface_ids = [
    azurerm_network_interface.nic_instance_2.id,
  ]

  admin_ssh_key {
    username   = "ravindra"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}