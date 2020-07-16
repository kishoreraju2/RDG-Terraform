resource "oci_core_instance" "app-instance" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "RDG"
  shape               = local.instance_shape

  create_vnic_details {
    subnet_id        = local.subnet_id
    display_name     = "primaryvnic"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = local.images[var.region]
  }

  extended_metadata = {
    rdg_url = var.object_storage_rdg_url
  }


  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(var.user-data)
  }

  timeouts {
    create = "60m"
  }

  
}


# resource "null_resource" "remote-exec" {
#   depends_on = [oci_core_instance.app-instance]

#   provisioner "remote-exec" {
#     connection {
#       agent       = false
#       timeout     = "30m"
#       host        = oci_core_instance.app-instance.public_ip
#       user        = "opc"
#       private_key = file(var.ssh_private_key_path)
#     }

#     inline = [
#       "echo 'inventory_loc=/home/opc/oraInventory\ninst_group=opc' >> /home/opc/oraInst.loc",
#       "sudo cp /home/opc/oraInst.loc /etc/oraInst.loc",
#       "echo '[ENGINE]\n\n#DO NOT CHANGE THIS.\nResponse File Version=1.0.0.0.0\n\n[GENERIC]\nORACLE_HOME=/home/opc/Oracle/Middleware/Oracle_Home\nSELECT_RD_VERSION_RADIO_V1=false\nCREDENTIALS_PAGE_ADMIN_USERNAME=admin\nCREDENTIALS_PAGE_PASSWORD=Admin123' >> /home/opc/silentInstall.response",
#         "cd /home/opc",
#         "wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/bltdA-dmMoS3qrFelT_3i2d65OOBGGewIgv8MhbIFOk/n/orasenatdhubsred01/b/ProductivityTrackerScreenshots/o/datagateway-linux-5.6.0.zip",
#         "unzip /home/opc/datagateway-linux-5.6.0.zip",
#         "/home/opc/datagateway-linux-5.6.0.bin -silent -responseFile /home/opc/silentInstall.response -invPtrLoc /etc/oraInst.loc", 
# "sleep 5",        
# "/home/opc/Oracle/Middleware/Oracle_Home/domain/bin/startJetty.sh",
#        "sleep 60",
#  "/home/opc/Oracle/Middleware/Oracle_Home/domain/bin/status.sh",

#     ]
#   }
# }

variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '################### Preparing to install RDG #####################'
sudo echo "inventory_loc=/home/opc/oraInventory" >> /etc/oraInst.loc
sudo echo "inst_group=opc" >> /etc/oraInst.loc
RDG_URL=$(curl -L http://169.254.169.254/opc/v1/instance/metadata | jq --raw-output '.rdg_url')
sudo echo "[ENGINE]

#DO NOT CHANGE THIS.
Response File Version=1.0.0.0.0

[GENERIC]
ORACLE_HOME=/home/opc/Oracle/Middleware/Oracle_Home
SELECT_RD_VERSION_RADIO_V1=false
CREDENTIALS_PAGE_ADMIN_USERNAME=admin
CREDENTIALS_PAGE_PASSWORD=Admin123" >> /home/opc/silentInstall.response

cd /home/opc
wget $RDG_URL
unzip /home/opc/datagateway-linux-5.6.0.zip 
sudo su - opc
/home/opc/datagateway-linux-5.6.0.bin -silent -responseFile /home/opc/silentInstall.response -invPtrLoc /etc/oraInst.loc >> /home/opc/install
sleep 90
/home/opc/Oracle/Middleware/Oracle_Home/domain/bin/startJetty.sh >> /home/opc/userdata.start
sleep 30
/home/opc/Oracle/Middleware/Oracle_Home/domain/bin/status.sh >> /home/opc/userdata.start
if [ $? -ne 0 ]; then
   printf "Failure" >> /home/opc/userdata.start
else
   printf "Successful" >> /home/opc/userdata.start
fi

echo '################### Finished #######################'
EOF
}

// https://docs.cloud.oracle.com/iaas/images/image/4e74174f-0b44-4447-bb09-dc05b23cf3ee/
// Oracle-Linux-7.7-2019.08.28-0
locals  {
  images = {
    ap-mumbai-1    =	"ocid1.image.oc1.ap-mumbai-1.aaaaaaaanqnm77gq2dpmc2aih2ddlwlahuv2qwmokufb7zbi52v67pzkzycq"
    ap-seoul-1     =	"ocid1.image.oc1.ap-seoul-1.aaaaaaaav3lc5w7cvz5yr6hpjdubxupjeduzd5xvaroyhjg6vwqzsdvgus6q"
    ap-sydney-1    =	"ocid1.image.oc1.ap-sydney-1.aaaaaaaagtfumjxhosxrkgfci3dgwvsmp35ip5nbhy2rypxfh3rwtqsozkcq"
    ap-tokyo-1     =	"ocid1.image.oc1.ap-tokyo-1.aaaaaaaajousbvplzyrh727e3d4sb6bam5d2fomwhbtzatoun5sqcuvvfjnq"
    ca-toronto-1   =	"ocid1.image.oc1.ca-toronto-1.aaaaaaaavr35ze44lkflxffkhmt4xyamkfjpbjhsm5awxjwlnp3gpx7h7fgq"
    eu-frankfurt-1 =	"ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7gj6uot6tz6t34qjzvkldxtwse7gr5m7xvnh6xfm53ddxp3w37ja"
    eu-zurich-1    =	"ocid1.image.oc1.eu-zurich-1.aaaaaaaasl3mlhvgzhfglqqkwdbppmmgomkz6iyi42wjkceldqcpecg7jzgq"
    sa-saopaulo-1  =	"ocid1.image.oc1.sa-saopaulo-1.aaaaaaaawamujpmwxbjgrfeb66zpew5sgz4bimzb4wgcwhqdjyct53bucvoq"
    uk-london-1    =	"ocid1.image.oc1.uk-london-1.aaaaaaaa6trfxqtp5ib7yfgj725js3o6agntmv6vckarebsmacrhdxqojeya"
    us-ashburn-1   =	"ocid1.image.oc1.iad.aaaaaaaayuihpsm2nfkxztdkottbjtfjqhgod7hfuirt2rqlewxrmdlgg75q"
    us-langley-1   =	"ocid1.image.oc1.iad.aaaaaaaa2qha6744iebmhbasswf52id73aeoaeqf2icjesc5d5vngw4hnjaa"
    us-luke-1      =	"ocid1.image.oc2.us-luke-1.aaaaaaaa73qnm5jktrwmkutf6iaigib4msieymk2s5r5iweq5yvqublgcx5q"
    us-phoenix-1   =	"ocid1.image.oc1.phx.aaaaaaaadtmpmfm77czi5ghi5zh7uvkguu6dsecsg7kuo3eigc5663und4za"
  }

  
  instance_shape = "VM.Standard2.1"


}

output "public_ip" {
  value = oci_core_instance.app-instance.public_ip
}
