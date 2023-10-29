provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = var.vsphere_admin_password
  vsphere_server       = "vcenter.vsphere.fenyo.net"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1-sabrent"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Expérimentations"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "corei9-9900K - prod - vlan 3 - nic on motherboard"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_folder" "folder" {
  path          = "terraform-openshift"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_file" "discovery_image_openshift" {
  datacenter         = "Datacenter"
  datastore          = "datastore1-sabrent"
  source_file        = "/tmp/debian-9.9.0-amd64-netinst.iso"
  destination_file   = "/terraform-openshift-images/debian-9.9.0-amd64-netinst.iso"
  create_directories = true
}

