




variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
  default     = ""
}

variable "resource_count" {
  type        = number
  description = "Number of resources to provision"
  default     = "1"
}

variable "ARM_CLIENT_ID" {
  type        = string
  description = "Azure Client ID"
  default     = ""
}

variable "ARM_CLIENT_SECRET" {
  type        = string
  description = "Azure Client secret"
  sensitive   = true
  default     = ""
}

variable "ARM_TENANT_ID" {
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