




variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = ""
}

variable "resource_count" {
  type        = number
  description = "Number of resources to provision"
  default     = "1"
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client ID"
  default     = ""
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Client secret"
  sensitive   = true
  default     = ""
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
  default     = ""
}

variable "az_ssh_pubkey" {
  type        = string
  description = "Public key for SSH access"
  default     = ""
}

variable "department" {
  type        = string
  description = "Department requesting the infrastructure"
  default     = ""
}

variable "purpose" {
  type        = string
  description = "Purpose of the infrastructure"
  default     = ""
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type = map(string)
  default = {
    department = ""
    purpose = ""
  }
}