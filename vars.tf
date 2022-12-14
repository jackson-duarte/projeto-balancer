variable "usuario" {
  type = string 
}

variable "senha" {
  type = string
}

variable "vcenter_params" {
 type = map
 default = {
   datastore    = "0"   
   resourcepool = "0" 
   rede         = "0"        
   cluster      = "0"      
  }
}

variable "servidor" {
  type = string
  default = "vcenter6.ufpe.br"
}

variable "vm_params" {
  type = map(object({
      nome      = string
      cpus      = string
      memoria   = string  #MB em binário
      disco     = string
    }))
}

variable "template" {
  type = string
} 

variable "guest_id" {
  type = string
}








