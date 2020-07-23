provider "oci" {
  auth = "InstancePrincipal"
  region           = var.region
}

terraform {
  required_version = ">= 0.12.0"
}


variable "region" {
  default = "us-ashburn-1"
}



variable "compartment_ocid" {}

# variable "ssh_public_key" {}
# variable "existing_vcn_id" {
#   type    = string
#   default = ""
# }

# variable "subnet_cidr" {
#   type    = string
#   default = "10.0.1.0/24"
# }

# variable "existing_subnet_compartment_id" {
#   type    = string
#   default = ""
# }
# #variable "tenancy_ocid" {}

# variable "existing_subnet_id" {
#   type    = string
#   default = ""
# }
# variable "use_existing_subnet" {
#     type = bool
#     default = false
# }

# variable "object_storage_rdg_url" {
#   default = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/bltdA-dmMoS3qrFelT_3i2d65OOBGGewIgv8MhbIFOk/n/orasenatdhubsred01/b/ProductivityTrackerScreenshots/o/datagateway-linux-5.6.0.zip"
# }
