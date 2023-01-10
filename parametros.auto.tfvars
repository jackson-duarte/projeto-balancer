#PARÂMETROS BÁSICOS DO PROVIDER:
vcenter_params  = { 
  datastore     = "DataStore DRS - NL - Desenvolvimento/VV_VMWARE_NL_R6_10D2P_DEV_01"
  resourcepool  = "02 - Desenvolvimento/Resource Pool - Desenv"
  rede          = "DPG_HOMOLOG"
  cluster       = "02 - Desenvolvimento"
}

conexao = {
  senha   = credenciais.senha
  tipo    = "ssh" 
  usuario = credenciais.usuario
}
#Quais serão os tipos de VMs, e quantas cópias de cada serão criadas
vm_params = [
   {
    nome         = "Banco - Réplica"
    hostname     = "srv-slave"
    cpus         = "12"
    memoria      = "32000"
    disco        = "300"
    ip           = "150.161.0.175"
    script       = {
      arquivo = "pacotes.sh"
      } 
   }      
]
#  primario = {
#    tipo     = "Master"
#    cpus     = "12"
#    memoria  = "32000"
#    disco    = "300"
#    script   = {
      //
#    } 
  
#  balancer = {
#    tipo       = "Balanceador"
#    cpus       = "4"
#    memoria    = "4000"
#    disco      = "100"
#    script     = {
#    //
#    }
#  } 

 
    
