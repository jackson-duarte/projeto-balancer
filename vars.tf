#VARIÁVEIS CONSTANTES COMPARTILHADAS PELAS VÁRIAS INSTÂNCIAS DAS VMS:
locals {
  servidor       = "vcenter6.ufpe.br"
  diretorio      = "Projeto Balancer"
  disco_nome     = "disk0"
  guest_id       = "ubuntu64Guest"
  template       = "vm_projeto_balancer" 
  origem_arquivo = "./"
  mascara_ip     = "24"
  gateway        = "150.161.50.254"
  servidoresdns  = ["150.161.50.72","150.161.50.73","150.161.50.7","150.161.50.91"]
  adaptador_rede = "vmxnet3"
}

variable "credenciais" {
  type = object({
    usuario = string
    senha   = string
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
      cpus         = string
      memoria      = string  #MiB em binário
      disco        = string
      hostname     = string
      ip           = string
      script       = object({
        arquivo    = string
      })           
      }))
    }


