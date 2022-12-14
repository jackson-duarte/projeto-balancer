vcenter_params    = { 
  datastore     = "hydra01-local"
  resourcepool  = "01 - Produção/Teste_resource_pool"
  rede          = "VM Network"
  cluster       = "01 - Producao"
}

vm_params = {

  replica = {
    nome     = "Projeto-replica"
    cpus     = "12"
    memoria  = "32000"
    disco    = "300"   
  }
  principal  = { 
    nome     = "Projeto-principal"
    cpus     = "12"
    memoria  = "32000"
    disco    = "300"
  }
  bouncer    = {
  nome       = "Projeto-Bouncer"
  cpus       = "4"
  memoria    = "4000"
  disco      = "100"
  } 
}
 
template = "Templates/Ubuntu 22 - Template(Winbind)"
     
guest_id = "ubuntu64Guest" 
