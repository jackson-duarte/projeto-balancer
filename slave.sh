# Instalação do PostgreSQL #
sudo apt-get install -y postgresql-10
#### OBS.: diretório de dados:  /var/lib/postgresql/10/main ####
####### CONFIGURAÇÃO DO POSTGRESQL #######
# Configuração de variáveis de PostgreSQL #  
sudo su - postgres << EOF
echo "export PGDATA="/etc/postgresql/10/main"" >> ~/.bashrc 
source ~/.bashrc
mkdir /var/lib/postgresql/10/main/archivedir
EOF
# Arquivo .pgpass para que seja desnecessário login com senha para algumas rotinas, como a de replicação 
touch ~/.pgpass; 
declare -A credenciais=(["pgpool"]="pgp00l#." ["postgres"]="p0stgr3s#." ["replicador"]="r3pl1c@d0r#.")
for user in "${!credenciais[@]}"; do
  for porta in 5432 9898 9999; do
    echo "*:$porta:*:$user:${credenciais[$user]}" >> ~/.pgpass 
      done; done
sudo chmod 0600 ~/.pgpass; sudo chown postgres ~/.pgpass
sudo mv ~/.pgpass /home/postgres/.pgpass
# Movendo o diretório de dados padrão de instalação
sudo su - postgres << EOF 
echo "export PGPASSFILE='$HOME/.pgpass'" >> ~/.bashrc ; source ~/.bashrc
sudo pg_ctlcluster 10 main restart
sudo pg_ctlcluster 10 main stop
mv /var/lib/postgresql/10/main /var/lib/postgresql/10/main.backup
mkdir main; chmod 700 main/
pg_basebackup -v -h $1 -U replicador -D /var/lib/postgresql/10/main -R
sed -i 's/#listen_addresses/listen_addresses/' \
-e 's/localhost/*/1' $PGDATA/postgresql.conf
# Permissões dos usuários no pg_hba.conf 
echo "host   all   all  150.161.0.0/24   md5"            >> pg_hba.conf
echo "host   replication   all    150.161.0.0/24   md5"  >> pg_hba.conf
sudo pg_ctlcluster 10 main restart
EOF



