
variable "credenciais" {
  type = object({
    usuario = string
    senha   = string
  })
}

variable "conexao" {
  type = object({
    tipo    = string
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
  type = map(object({
      nome        = string
      cpus        = string
      memoria     = string  #MiB em binário
      disco       = string
      quantidade  = string
      hostname    = string
      ipv4        = string
      script      = object({
        argumentos = list
        arquivo   = string            
      })
    }))
}

variable "lista_ip" {
  #for_each var = vm_params

}