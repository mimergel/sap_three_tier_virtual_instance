variable "location" {
  description = "Location for resources"
  type        = string
}

variable "unique_identifier" {
  description = "A unique identifier for naming resources"
  type        = string
}

variable "role_definition_name" {
  description = "Name of the role definition for the role assignment"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage account"
  type        = string
}

variable "sap_instance_name" {
  description = "Name of the SAP instance"
  type        = string
}

variable "sap_environment" {
  description = "Environment for the SAP instance (e.g., NonProd)"
  type        = string
}

variable "sap_product" {
  description = "SAP product (e.g., S4HANA)"
  type        = string
}

variable "sap_fqdn" {
  description = "Fully qualified domain name for SAP"
  type        = string
}

variable "secondary_ip_enabled" {
  description = "Enable secondary IP for SAP configuration"
  type        = bool
}

variable "app_instance_count" {
  description = "Number of application server instances"
  type        = number
}

variable "app_vm_size" {
  description = "Size of the application server VM"
  type        = string
}

variable "vm_image_offer" {
  description = "VM image offer"
  type        = string
}

variable "vm_image_publisher" {
  description = "VM image publisher"
  type        = string
}

variable "vm_image_sku" {
  description = "VM image SKU"
  type        = string
}

variable "vm_image_version" {
  description = "VM image version"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
}

variable "central_instance_count" {
  description = "Number of central server instances"
  type        = number
}

variable "central_vm_size" {
  description = "Size of the central server VM"
  type        = string
}

variable "database_instance_count" {
  description = "Number of database server instances"
  type        = number
}

variable "database_type" {
  description = "Type of the database (e.g., HANA)"
  type        = string
}

variable "database_vm_size" {
  description = "Size of the database server VM"
  type        = string
}

variable "hana_data_disks" {
  description = "Number of data disks for HANA"
  type        = number
}

variable "hana_data_disk_size" {
  description = "Size of each HANA data disk in GB"
  type        = number
}

variable "hana_data_disk_sku" {
  description = "SKU for HANA data disks"
  type        = string
}

variable "hana_log_disks" {
  description = "Number of log disks for HANA"
  type        = number
}

variable "hana_log_disk_size" {
  description = "Size of each HANA log disk in GB"
  type        = number
}

variable "hana_log_disk_sku" {
  description = "SKU for HANA log disks"
  type        = string
}

variable "hana_shared_disks" {
  description = "Number of shared disks for HANA"
  type        = number
}

variable "hana_shared_disk_size" {
  description = "Size of each HANA shared disk in GB"
  type        = number
}

variable "hana_shared_disk_sku" {
  description = "SKU for HANA shared disks"
  type        = string
}

variable "usr_sap_disks" {
  description = "Number of disks for /usr/sap"
  type        = number
}

variable "usr_sap_disk_size" {
  description = "Size of each /usr/sap disk in GB"
  type        = number
}

variable "usr_sap_disk_sku" {
  description = "SKU for /usr/sap disks"
  type        = string
}

variable "backup_disks" {
  description = "Number of backup disks"
  type        = number
}

variable "backup_disk_size" {
  description = "Size of each backup disk in GB"
  type        = number
}

variable "backup_disk_sku" {
  description = "SKU for backup disks"
  type        = string
}

variable "os_disks" {
  description = "Number of OS disks"
  type        = number
}

variable "os_disk_size" {
  description = "Size of each OS disk in GB"
  type        = number
}

variable "os_disk_sku" {
  description = "SKU for OS disks"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
