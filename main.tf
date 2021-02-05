# terraform {
#   backend "remote" {
#     organization = "Software-Architecture"

#     workspaces {
#       name = "gh-actions-demo"
#     }
#   }
# }
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "32341447-fc9c-4b87-a11b-2d2e095ac487"
  client_id       = "3dccc277-e108-4a6e-a8d7-badd797bfd68"
  client_secret   = "qMxSk1eTj1Rd0vEDak6rU.hSboLlJ3i__p"
  tenant_id       = "6f4432dc-20d2-441d-b1db-ac3380ba633d"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "lab1-test"
  location = "Southeast Asia"
}

resource "azurerm_virtual_network" "main" {
  name                = "lab1-test-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "lab1-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "lab1-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "lab1-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = var.azure_username
  admin_password                  = var.azure_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update", "sudo apt install -y nodejs", "sudo apt install -y npm",
      "git clone https://github.com/ryan10599/INT493-SoftwareArchitecture.git",
      "sudo mv hello_node.service /lib/systemd/system/hello_node.service",
      "cd INT493-SoftwareArchitecture/Lab1/demo1",
      "npm install",
      "sudo systemctl start hello_node",
      "sudo systemctl enable hello_node"
    ]

    connection {
      host     = self.public_ip_address
      user     = var.azure_username
      password = var.azure_password
    }
  }
}
