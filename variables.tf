provider "oci" {
  auth = "InstancePrincipal"
  region           = var.region
}

terraform {
  required_version = ">= 0.12.0"
}

variable "ssh_public_key" {}
variable "region" {
  default = "us-ashburn-1"
}

variable "ssh_private_key_path" {
    type = string
}

variable "compartment_ocid" {}


variable "existing_vcn_id" {
  type    = string
  default = ""
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "existing_subnet_compartment_id" {
  type    = string
  default = ""
}
#variable "tenancy_ocid" {}

variable "existing_subnet_id" {
  type    = string
  default = ""
}
variable "use_existing_subnet" {
    type = bool
    default = false
}
