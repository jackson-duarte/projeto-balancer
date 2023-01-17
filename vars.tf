#VARIÁVEIS CONSTANTES COMPARTILHADAS PELAS VÁRIAS INSTÂNCIAS DAS VMS:
locals {
  servidor       = "vcenter6.ufpe.br"
  diretorio      = "Projeto Balancer"
  disco_nome     = "disk0"
  guest_id       = "ubuntu64Guest"
  template       = "template-projeto-balancer" 
  origem_arquivo = "./"
  rede = { 
    mascara_ip     = "24"
    gateway        = "150.161.0.254"
    servidoresdns  = ["150.161.50.72","150.161.50.73","150.161.50.7","150.161.50.91"]
    adaptador_rede = "vmxnet3"
  }
  backend_nodes = flatten([ for objeto in var.vm_params : [
    for endereco in objeto.ip : endereco if objeto.tipo != "Balanceador"
  ]])

}

variable "credenciais" {
  type = object({
    usuario = string
    senha   = string
    chave   = string
  })
}

variable "vcenter_params" {
 type = object({
   datastore    = string  
   resourcepool = string
   rede         = string    
   cluster      = string   
  })
}

variable "vm_params" {
  type = list(object({
      nome         = string
      tipo         = string
      cpus         = string
      memoria      = string  #MiB em binário
      disco        = string
      hostname     = string
      ip           = list(string)
      script       = object({
        arquivo    = string
      })           
      }))
    }

    output "flatten_params" {
      value = flatten([
        for obj in var.vm_params: [
          for endereco in obj.ip: {
            "${i.hostname}${endereco.index}" => obj
          } 
        ]
      ])
      
    }


