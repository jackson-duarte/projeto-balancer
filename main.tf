terraform {
 required_providers { 
   vsphere = {
     source = "hashicorp/vsphere"
     version = "2.2.0" 
   } 
 }
}

provider "vsphere" {
  user                 = var.credenciais.usuario
  password             = var.credenciais.senha
  vsphere_server       = local.servidor
  allow_unverified_ssl = true
}

###Blocos do tipo "data"####
                        
data "vsphere_datacenter" "dc" {
  name = "UFPE"
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vcenter_params.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
	  name          = var.vcenter_params.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "parent" {
  path            = local.diretorio
  type            = "vm"
  datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "rede"{
  name          = var.vcenter_params.rede
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Configuração das VMs

resource "vsphere_virtual_machine" "vms" {
  for_each         = var.vm_params
  folder           = local.diretorio
  count            = each.value.quantidade
  name             = each.value.nome
  num_cpus         = each.value.cpus
  memory           = each.value.memoria
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = var.guest_id
#Necessidade de un duplo for_each para os provisionadores#
  provisioner "file" {
    source      = local.origem_arquivo
    destination = "~/${each.value.script.arquivo}" 

    connection {
      type     = "ssh"
      user     = var.credenciais.usuario
      password = var.credenciais.senha
    }
      }

  provisioner "remote-exec" {
    inline = [
      "echo 'export '  ",
      "sh ${each.value.script.arquivo} ${each.value.script.argumentos}"

    ]
    connection {
      type     = "ssh"
      user     = var.credenciais.usuario
      password = var.credenciais.senha 
    }        
  }

  network_interface {
    network_id   = data.vsphere_network.rede.id
  }

  disk {
    size  = each.value.disco
    label = local.disco_nome
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
