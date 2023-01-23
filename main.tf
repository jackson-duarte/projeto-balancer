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
#BLOCOS DO TIPO 'DATA'#                        
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
  name          = local.template
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
#CONFIGURAÇÃO DAS VMs#
resource "vsphere_virtual_machine" "vms" {
  for_each         = {for item in local.flatten_params : item.nome => item}
  folder           = local.diretorio
  name             = each.value.nome
  num_cpus         = each.value.cpus
  memory           = each.value.memoria
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = local.guest_id

  provisioner "file" {
    source      = "${local.origem_arquivo}/${each.value.script.arquivo}"
    destination = format("%s/%s/%s","/home",trim("${var.credenciais.usuario}","@ufpe.br"),"${each.value.script.arquivo}")

    connection {
      type     = "ssh"
      host     = each.value.ip
      user     = var.credenciais.usuario
      private_key = file("${var.credenciais.chave}")
    }
      }

  provisioner "remote-exec" {
    inline = [
      #"echo ${var.credenciais.senha} | sudo -S -v",
      "nohup sudo bash ~/${each.value.script.arquivo} 2>erros_script.txt"
    ]

    connection {
      type     = "ssh"
      host     = each.value.ip
      user     = var.credenciais.usuario
      private_key = file("${var.credenciais.chave}")
    }        
  }

  network_interface {
    network_id   = data.vsphere_network.rede.id
    adapter_type = local.rede.adaptador_rede
  }

  disk {
    size             = each.value.disco
    label            = local.disco_nome
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
           host_name = each.value.hostname
           domain    = "ufpe.br"
      }

      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = local.rede.mascara_ip
      }
      ipv4_gateway    = local.rede.gateway
      dns_server_list = local.rede.servidoresdns

     }
  }
}
