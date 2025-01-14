data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rgid" {
  name     = "rg${local.alias}"
  location = "${local.region}"
}
resource "azurerm_virtual_network" "vnetid" {
  name                = "vnet${local.alias}"
  location            = "${azurerm_resource_group.rgid.location}"
  resource_group_name = "${azurerm_resource_group.rgid.name}"
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "default"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }
}

resource "azurerm_kubernetes_cluster" "aksid" {
  name                = "aks${local.alias}pe"
  location            = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
  dns_prefix          = "aks${local.alias}pe"

  agent_pool_profile {
    name            = "default"
    count           = local.workers
    vm_size         = "${local.instancia}"
    os_type         = "Linux"
    min_count       = local.workers
    max_count       = 5
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    vnet_subnet_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.rgid.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.vnetid.name}/subnets/default"
  }

  service_principal {
    client_id     = "${local.clientid}"
    client_secret = "${local.clientsecret}"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Production"
  }
}
resource "azurerm_api_management" "apimid" {
  name                = "apim${local.alias}"
  location            = "${azurerm_resource_group.rgid.location}"
  resource_group_name = "${azurerm_resource_group.rgid.name}"
  publisher_name      = "Microsoft"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}