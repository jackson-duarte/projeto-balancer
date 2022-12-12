variable "usuario" {
  type = string 
}

variable "senha" {
  type = string
}

variable vcenter_params {
 default =  {
   "datastore"    = "hydra01-local"
   "resourcepool" = "01 - Produção/Teste_resource_pool"
   "rede"         = "VM Network"
   "cluster"      = "01 - Producao"
} 
}

variable servidor {
  type = string
  default = "vcenter6.ufpe.br"
}

variable balancer_params {
  default =  {
        "hostname" = "balancer007"
       "cpus"      = "2"
       "memoria"   = "2048"  ##Em MB
} 
}
variable vm_count {
  default = "1"
}

variable rede {
  default =  {
    "nome"     = "intpost0"
    "end_ipv4" = "10.15.0." 
    "mascara"  = "24"
  } 
 
}

variable disco {
  default =  {
    "tamanho" = "200"
    "label"   = "disk00"
  } 
}
###variable serv_replicacao
###variable serv_postgresql



