# locals {
#   all_cidr            = "0.0.0.0/0"
#   existing_subnet_id = var.existing_subnet_id
#   use_existing_subnet = var.use_existing_subnet
# }

# data "oci_core_vcn" "vcn" {
#   vcn_id         = var.existing_vcn_id
# }

# locals {
#   vcn_id             =  join("", data.oci_core_vcn.vcn.*.id) 
#   vcn_compartment_id =  join("", data.oci_core_vcn.vcn.*.compartment_id) 
#   route_table_id     =  join("", data.oci_core_vcn.vcn.*.default_route_table_id) 
#   dhcp_options_id    =  join("", data.oci_core_vcn.vcn.*.default_dhcp_options_id) 
# }

# resource "oci_core_security_list" "rdg" {
#   compartment_id = local.vcn_compartment_id
#   vcn_id         = local.vcn_id
#   display_name   = "RDG-SL"

#   ingress_security_rules {
#     protocol  = "6"         // tcp
#     source    = local.all_cidr
#     stateless = false

#     tcp_options {
#       min = 22
#       max = 22
#     }
#   }

#   ingress_security_rules {
#     // Allow inbound ssh traffic...
#     protocol  = "6" // tcp
#     source    = local.all_cidr
#     stateless = false

#     tcp_options {
#       min = 80
#       max = 80
#     }
#   }

#   ingress_security_rules {
#     // Allow inbound ssh traffic...
#     protocol  = "6" // tcp
#     source    = local.all_cidr
#     stateless = false

#     tcp_options {
#       min = 4200
#       max = 4200
#     }
#   }

#   ingress_security_rules {
#     // allow inbound icmp traffic of a specific type
#     protocol  = 1
#     source    = local.all_cidr
#     stateless = false

#     icmp_options {
#       type = 3
#       code = 4
#     }
#   }

#   egress_security_rules {
#     // Allow all outbound traffic
#     destination      = local.all_cidr
#     destination_type = "CIDR_BLOCK"
#     protocol         = "all"
#   }
# }

# resource "oci_core_subnet" "subnet" {
#   count               = local.use_existing_subnet ? 0 : 1
#   availability_domain = data.oci_identity_availability_domain.ad.name
#   cidr_block          = var.subnet_cidr
#   display_name        = "RDG-subnet"
# #   dns_label           = "testsubnet"
#   security_list_ids   = oci_core_security_list.rdg.*.id
#   compartment_id      = var.compartment_ocid
#   vcn_id              = local.vcn_id
#   route_table_id      = local.route_table_id
#   dhcp_options_id     = local.dhcp_options_id
# }

# data "oci_core_subnet" "subnet" {
#   count     = local.use_existing_subnet ? 1 : 0
#   subnet_id = local.existing_subnet_id
# }

# locals {
#     subnet_id        = var.use_existing_subnet ? join("", data.oci_core_subnet.subnet.*.id) : join("", oci_core_subnet.subnet.*.id)
# }

# data "oci_identity_availability_domain" "ad" {
#   compartment_id = var.compartment_ocid
#   ad_number      = 1
# }
