data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_ocid
  ad_number      = 1
}

output "ad" {
    value = oci_identity_availability_domain.ad.name
}