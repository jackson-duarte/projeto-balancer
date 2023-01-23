#!/bin/sh
# Instalação de servidor postgreSQL
sudo apt-get update -y
sudo apt-get install -y postgresql-10
#### OBS.: diretório de dados:  /var/lib/postgresql/10/main ####
# Dando permissões ao usuário postgres para restartar o serviço de banco #
echo "postgres   ALL=(ALL:ALL)NOPASSWD:   /usr/bin/pg_* " | sudo tee -a  /etc/sudoers.d/postgres
# Arquivo .pgpass para que seja desnecessário login com senha para algumas rotinas, como a de replicação 
sudo touch ~/.pgpass; 
declare -A credenciais=(["pgpool"]="pgp00l#." ["postgres"]="p0stgr3s#." ["replicador"]="r3pl1c@d0r#.")
for user in "${!credenciais[@]}"; do
  for porta in 5432 9898 9999; do
    echo "*:$porta:*:$user:${credenciais[$user]}" >> ~/.pgpass 
      done; done
sudo chmod 0600 ~/.pgpass; sudo chown postgres ~/.pgpass
sudo mv ~/.pgpass /home/postgres/.pgpass
####### CONFIGURAÇÃO DO POSTGRESQL #######
# Configuração de variáveis de PostgreSQL #  
sudo su - postgres << 'EOF'
echo "export PGDATA="/var/lib/postgresql/10/main"" >> ~/.bashrc 
source ~/.bashrc
mkdir /var/lib/postgresql/10/main/archivedir
####### EDITANDO postgresql.conf #######
sed -i 's/#listen_addresses/listen_addresses/' /etc/postgresql/10/main/postgresql.conf
sed -i 's/localhost/*/1' /etc/postgresql/10/main/postgresql.conf
sed -i 's/#archive_mode = off/archive_mode = on/' /etc/postgresql/10/main/postgresql.conf
echo "archive_command = 'cp "%p" "/var/lib/postgresql/10/main/archivedir/%f"'" >> /etc/postgresql/10/main/postgresql.conf
sed -i "s/#archive_command = ''//" /etc/postgresql/10/main/postgresql.conf
####### CRIANDO USUÁRIOS #######
# Usuário pgpool
psql -c "CREATE ROLE pgpool WITH LOGIN PASSWORD 'pgp00l#.';"
psql -c "CREATE USER replicador WITH REPLICATION LOGIN PASSWORD 'r3pl1c@d0r#.';"
psql -c "ALTER USER postgres WITH PASSWORD 'p0stgr3s#.';"
psql -c "GRANT pg_monitor TO pgpool;"
# Permissões dos usuários no pg_hba.conf 
echo "host   all   all  150.161.0.0/24   md5"            >> /etc/postgresql/10/main/pg_hba.conf
echo "host   replication   all    150.161.0.0/24   md5"  >> /etc/postgresql/10/main/pg_hba.conf
echo "export PGPASSFILE='$HOME/.pgpass'" >> ~/.bashrc ; source ~/.bashrc
sudo pg_ctlcluster 10 main restart
EOF













