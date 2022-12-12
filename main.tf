terraform {
 required_providers { 
   vsphere = {
     source = "hashicorp/vsphere"
     version = "2.2.0" 
   } 
 }
}

provider "vsphere" {
  user                 = var.usuario
  password             = var.senha
  vsphere_server       = var.servidor
  allow_unverified_ssl = true
}

###Resources do tipo "data"####
                        
data "vsphere_datacenter" "dc" {
  name = "UFPE"
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vcenter_params["cluster"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

#data "vsphere_resource_pool" "pool" {
# name = var.vcenter_params["resourcepool"]
# datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_datastore" "datastore" {
  name          = var.vcenter_params["datastore"] 
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "parent" {
  path            = "Projeto Balancer"
  type            = "vm"
  datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "rede"{
  name          = var.vcenter_params["rede"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "srv0" {
  count            = var.vm_count
  name             = "VM_teste"
  num_cpus         = var.balancer_params.cpus
  memory           = var.balancer_params.memoria
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  
  network_interface {
    network_id   = data.vsphere_network.rede.id
    #ipv4_address = var.rede["nome"]+"${count.index +1}"
    #ipv4_netmask = 24  ###Dito na hora compilação que não existem os parâmetros mencionados
  }

  disk {
    size  = var.disco["tamanho"]
    label = var.disco["label"]

  }
}
