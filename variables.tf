variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "devops-demo"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "europe-central2" # Warsaw, Poland
}

variable "zone" {
  description = "GCP zone for VM"
  type        = string
  default     = "europe-central2-a"
}

variable "subnet_1_cidr" {
  description = "CIDR block for subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "CIDR block for subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-micro" # Free tier eligible
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access (optional)"
  type        = string
  default     = ""
}
