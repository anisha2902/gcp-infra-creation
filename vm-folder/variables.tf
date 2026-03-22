variable "project_id" {
  description = "GCP Project ID to be created"
  type        = string
}

variable "project_name" {
  description = "GCP Project Name"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "Billing Account ID"
  type        = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "app_port" {
  type    = number
  default = 8080
}
