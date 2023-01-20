#!/bin/bash
####### PARTE COMUM A QUALQUER TIPO DE NÓ #######
## Para restartar todos os serviços necessários depois da instalação de pacotes sem a fatídica mensagem de prompt para escolha dos serviços que devem ser reinicializados. ###
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sudo adduser --disabled-password --gecos "" postgres
echo "postgres   ALL=NOPASSWD:    /usr/bin/pg_.* " | sudo tee -a  /etc/sudoers.d/postgres
# Adicionando repositório do PostgreSQL 
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
# Alguns pacotes... #
sudo apt-get install -y vim apt-utils ufw net-tools postgresql-client-10 wget gcc make libpq-dev 
# Instalação do PostgreSQL #
sudo apt-get install -y postgresql-10
#### OBS.: diretório de dados:  /var/lib/postgresql/10/main ####
# Dando permissões ao usuário postgres para restartar o serviço de banco #
echo "postgres   ALL=(ALL:ALL)NOPASSWD:   /usr/bin/pg_* " | sudo tee -a  /etc/sudoers.d/postgres
####### CONFIGURAÇÃO DO POSTGRESQL #######
# Configuração de variáveis de PostgreSQL #  
sudo su - postgres
echo "export PGDATA="/etc/postgresql/10/main"" >> ~/.bashrc 
source ~/.bashrc
mkdir /var/lib/postgresql/10/main/archivedir
sudo su - postgres
touch ~/.pgpass; chmod 0600 ~/.pgpass
declare -A credenciais=(["pgpool"]="pgp00l#." ["postgres"]="p0stgr3s#." ["replicador"]="r3pl1c@d0r#.")
for user in "${!credenciais[@]}"; do for porta in 5432  9898; do echo "*:$porta:*:"$user":"${credenciais[$user]}"" >> ~/.pgpass; done done
echo "export PGPASSFILE='$HOME/.pgpass'" >> ~/.bashrc ; source ~/.bashrc 
# Movendo o diretório de dados padrão de instalação 
sudo pg_ctlcluster 10 main stop
mv /var/lib/postgresql/10/main /var/lib/postgresql/10/main.backup
mkdir main; chmod 700 main/
pg_basebackup -v -h 150.161.0.175 -U replicador -D /var/lib/postgresql/10/main -R
sed -i 's/#listen_addresses/listen_addresses/' \
-e 's/localhost/*/1' $PGDATA/postgresql.conf
# Permissões dos usuários no pg_hba.conf 
echo "host   all   all  150.161.0.0/24   md5"            >> pg_hba.conf
echo "host   replication   all    150.161.0.0/24   md5"  >> pg_hba.conf
sudo pg_ctlcluster 10 main restart



