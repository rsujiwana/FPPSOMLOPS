variable "credentials_file" {
  description = "Path to the service account key file"
  type        = string
  default     = "${{ secrets.GCP_KEY }}"
}

variable "project_id" {
  description = "The ID of the GCP project to use"
  type        = string
  default     = "fppsomlops"
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-central1"
}

variable "instance_type" {
  description = "The machine type to use for the VM"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "The image to use for the VM"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "service_account_email" {
  description = "The email of the service account to use"
  type        = string
  default     = "terraform-service-account@fppsomlops.iam.gserviceaccount.com"
}

variable "default_zone" {
  description = "Default zone for resources"
  type        = string
  default     = "us-central1-a"  # Ganti dengan zona default Anda
}

variable "gcp_user" {
  description = "Default GCP user"
  type        = string
  default     = "default"
}


