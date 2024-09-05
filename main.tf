# main.tf

resource "tls_private_key" "deployment" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "deployment" {
  private_key_pem = tls_private_key.deployment.private_key_pem
}

# Get the current subscription
data "azurerm_subscription" "current" {}

# Resource Group for General Resources
resource "azurerm_resource_group" "deployment" {
  name     = local.resource_group_name
  location = var.location
}

# User Assigned Identity
resource "azurerm_user_assigned_identity" "deployment" {
  name                = local.uai_name
  location            = azurerm_resource_group.deployment.location
  resource_group_name = azurerm_resource_group.deployment.name
}

# Role Assignment
resource "azurerm_role_assignment" "deployment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.deployment.principal_id
}

# Virtual Network
resource "azurerm_virtual_network" "deployment" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.deployment.location
  resource_group_name = azurerm_resource_group.deployment.name
}

# Subnet
resource "azurerm_subnet" "deployment" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.deployment.name
  virtual_network_name = azurerm_virtual_network.deployment.name
  address_prefixes     = var.subnet_address_prefixes
}

# Resource Group for SAP Application
resource "azurerm_resource_group" "app" {
  name     = local.sap_app_resource_group_name
  location = var.location

  depends_on = [
    azurerm_subnet.deployment
  ]
}

# Storage Account
resource "azurerm_storage_account" "deployment" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.deployment.name
  location                 = azurerm_resource_group.deployment.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

# SAP Three Tier Virtual Instance
resource "azurerm_workloads_sap_three_tier_virtual_instance" "deployment" {
  name                        = var.sap_instance_name
  resource_group_name         = azurerm_resource_group.deployment.name
  location                    = azurerm_resource_group.deployment.location
  environment                 = var.sap_environment
  sap_product                 = var.sap_product
  managed_resource_group_name = local.managed_resource_group_name
  app_location                = azurerm_resource_group.app.location
  sap_fqdn                    = var.sap_fqdn

  three_tier_configuration {
    app_resource_group_name = azurerm_resource_group.app.name
    secondary_ip_enabled    = var.secondary_ip_enabled

    application_server_configuration {
      instance_count = var.app_instance_count
      subnet_id      = azurerm_subnet.deployment.id

      virtual_machine_configuration {
        virtual_machine_size = var.app_vm_size

        image {
          offer     = var.vm_image_offer
          publisher = var.vm_image_publisher
          sku       = var.vm_image_sku
          version   = var.vm_image_version
        }

        os_profile {
          admin_username  = var.admin_username
          ssh_private_key = tls_private_key.deployment.private_key_pem
          ssh_public_key  = data.tls_public_key.deployment.public_key_openssh
        }
      }
    }

    central_server_configuration {
      instance_count = var.central_instance_count
      subnet_id      = azurerm_subnet.deployment.id

      virtual_machine_configuration {
        virtual_machine_size = var.central_vm_size

        image {
          offer     = var.vm_image_offer
          publisher = var.vm_image_publisher
          sku       = var.vm_image_sku
          version   = var.vm_image_version
        }

        os_profile {
          admin_username  = var.admin_username
          ssh_private_key = tls_private_key.deployment.private_key_pem
          ssh_public_key  = data.tls_public_key.deployment.public_key_openssh
        }
      }
    }

    database_server_configuration {
      instance_count = var.database_instance_count
      subnet_id      = azurerm_subnet.deployment.id
      database_type  = var.database_type

      virtual_machine_configuration {
        virtual_machine_size = var.database_vm_size

        image {
          offer     = var.vm_image_offer
          publisher = var.vm_image_publisher
          sku       = var.vm_image_sku
          version   = var.vm_image_version
        }

        os_profile {
          admin_username  = var.admin_username
          ssh_private_key = tls_private_key.deployment.private_key_pem
          ssh_public_key  = data.tls_public_key.deployment.public_key_openssh
        }
      }

      disk_volume_configuration {
        volume_name     = "hana/data"
        number_of_disks = var.hana_data_disks
        size_in_gb      = var.hana_data_disk_size
        sku_name        = var.hana_data_disk_sku
      }

      disk_volume_configuration {
        volume_name     = "hana/log"
        number_of_disks = var.hana_log_disks
        size_in_gb      = var.hana_log_disk_size
        sku_name        = var.hana_log_disk_sku
      }

      disk_volume_configuration {
        volume_name     = "hana/shared"
        number_of_disks = var.hana_shared_disks
        size_in_gb      = var.hana_shared_disk_size
        sku_name        = var.hana_shared_disk_sku
      }

      disk_volume_configuration {
        volume_name     = "usr/sap"
        number_of_disks = var.usr_sap_disks
        size_in_gb      = var.usr_sap_disk_size
        sku_name        = var.usr_sap_disk_sku
      }

      disk_volume_configuration {
        volume_name     = "backup"
        number_of_disks = var.backup_disks
        size_in_gb      = var.backup_disk_size
        sku_name        = var.backup_disk_sku
      }

      disk_volume_configuration {
        volume_name     = "os"
        number_of_disks = var.os_disks
        size_in_gb      = var.os_disk_size
        sku_name        = var.os_disk_sku
      }
    }

    resource_names {
      application_server {
        availability_set_name = local.app_availability_set_name

        virtual_machine {
          host_name               = local.app_vm_host_name
          os_disk_name            = local.app_os_disk_name
          virtual_machine_name    = local.app_vm_name
          network_interface_names = local.app_network_interface_names

          data_disk {
            volume_name = "default"
            names       = local.app_data_disk_names
          }
        }
      }

      central_server {
        availability_set_name = local.central_availability_set_name

        load_balancer {
          name                            = local.central_lb_name
          backend_pool_names              = local.central_backend_pool_names
          frontend_ip_configuration_names = local.central_frontend_ip_names
          health_probe_names              = local.central_health_probe_names
        }

        virtual_machine {
          host_name               = local.central_vm_host_name
          os_disk_name            = local.central_os_disk_name
          virtual_machine_name    = local.central_vm_name
          network_interface_names = local.central_network_interface_names

          data_disk {
            volume_name = "default"
            names       = local.central_data_disk_names
          }
        }
      }

      database_server {
        availability_set_name = local.database_availability_set_name

        load_balancer {
          name                            = local.database_lb_name
          backend_pool_names              = local.database_backend_pool_names
          frontend_ip_configuration_names = local.database_frontend_ip_names
          health_probe_names              = local.database_health_probe_names
        }

        virtual_machine {
          host_name               = local.database_vm_host_name
          os_disk_name            = local.database_os_disk_name
          virtual_machine_name    = local.database_vm_name
          network_interface_names = local.database_network_interface_names

          data_disk {
            volume_name = "hanaData"
            names       = local.database_hana_data_disk_names
          }

          data_disk {
            volume_name = "hanaLog"
            names       = local.database_hana_log_disk_names
          }

          data_disk {
            volume_name = "usrSap"
            names       = local.database_usr_sap_disk_names
          }

          data_disk {
            volume_name = "hanaShared"
            names       = local.database_hana_shared_disk_names
          }
        }
      }

      shared_storage {
        account_name          = local.shared_storage_account_name
        private_endpoint_name = local.shared_storage_private_endpoint_name
      }
    }

    transport_create_and_mount {
      resource_group_id    = azurerm_resource_group.app.id
      storage_account_name = local.transport_storage_account_name
    }
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.deployment.id,
    ]
  }

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.deployment
  ]
}
