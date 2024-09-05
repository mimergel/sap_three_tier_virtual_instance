# Variables

# Mandatory 
sap_instance_name             = "M01"
location                      = "Germany West Central"
sap_fqdn                      = "sap.contoso.net"
sap_environment               = "NonProd"
sap_product                   = "S4HANA"
unique_identifier             = "c7b93e62"

storage_account_tier          = "Standard"
storage_account_replication_type = "LRS"

role_definition_name          = "Azure Center for SAP solutions service role"
vnet_name                     = "DEV-GWC-SAP01-vnet"
vnet_address_space            = ["10.0.0.0/16"]
subnet_name                   = "default"
subnet_address_prefixes       = ["10.0.0.0/24"]

secondary_ip_enabled          = false

app_instance_count            = 1
app_vm_size                   = "Standard_D16ds_v4"
vm_image_offer                = "RHEL-SAP-HA"
vm_image_publisher            = "RedHat"
vm_image_sku                  = "86sapha-gen2"
vm_image_version              = "latest"
admin_username                = "azureadm"

central_instance_count        = 1
central_vm_size               = "Standard_D16ds_v4"
database_instance_count       = 1
database_type                 = "HANA"
database_vm_size              = "Standard_E16ds_v4"
hana_data_disks               = 3
hana_data_disk_size           = 128
hana_data_disk_sku            = "Premium_LRS"
hana_log_disks                = 3
hana_log_disk_size            = 128
hana_log_disk_sku             = "Premium_LRS"
hana_shared_disks             = 1
hana_shared_disk_size         = 256
hana_shared_disk_sku          = "Premium_LRS"
usr_sap_disks                 = 1
usr_sap_disk_size             = 128
usr_sap_disk_sku              = "Premium_LRS"
backup_disks                  = 2
backup_disk_size              = 256
backup_disk_sku               = "Premium_LRS"
os_disks                      = 1
os_disk_size                  = 64
os_disk_sku                   = "Premium_LRS"

tags                          = {
  Env = "Test"
}