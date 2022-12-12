#Projeto Balancer

Para não haver arquivo(s) com informação(ões) de login, ou seja, dados privados, o usuário que quiser realizar o deploy terá que adicionar a opção -input=true, para que ele digite as credenciais do UFPE-ID.

Assim,

$ terraform plan -input=true
$ terraform apply -input=true

São comandos com opções necessárias para que não resultem em erro.

Ou criar um arquivo <nomedoArquivo>.auto.tfvars e adicionar os valores de duas variáveis:
  
  usuario = "usuarioUFPE-ID@ufpe.br"
  senha   = "senhaDoUFPE-ID"
