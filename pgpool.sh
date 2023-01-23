#!/bin/bash
####### INSTALAÇÃO DO PGPOOL-II #######
sudo apt-get install -y pgpool2
echo "export PGPOOL_HOME='/etc/pgpool2'" >> ~/.bashrc && source ~/.bashrc
touch ~/.pgpass; chmod 0600 ~/.pgpass
declare -A credenciais=(["pgpool"]="pgp00l#." ["postgres"]="p0stgr3s#." ["replicador"]="r3pl1c@d0r#.")
for user in "${!credenciais[@]}"; do for porta in 5432 9999 9898; do echo "*:$porta:*:"$user":"${credenciais[$user]}"" >> ~/.pgpass; done done
echo "export PGPASSFILE='$HOME/.pgpass'" >> ~/.bashrc ; source ~/.bashrc 
####### CONFIGURAÇÃO DO PGPOOL-II #######
cd $PGPOOL_HOME/
# Modificando parâmetros de pgpool.conf #
# Source replication: #
sudo sed -i \
-e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" \
-e "s/#sr_check_user = 'nobody'/sr_check_user = 'pgpool'/" \
-e "s/#sr_check_password = ''/sr_check_password = 'pgp00l#.'/" \
pgpool.conf
# Para health_check: #
sudo sed -i \
-e "s/#health_check_user = 'nobody'/health_check_user = 'pgpool'/" \
-e "s/#port = 5433/port= 9999/" \
-e "s/#health_check_password = ''/health_check_password = 'pgp00l#.'/" \
-e "s/#health_check_period = 0/health_check_period = 5/" \
-e "s/#health_check_timeout0 = 20/health_check_timeout0 = 30/" \
-e "s/#health_check_max_retries = 0/health_check_max_retries = 3/" \
pgpool.conf
# Ajustando os backends: #
contador=0
for IP in $1; do
echo "
backend_hostname$contador = '$IP'
backend_port$contador = 5432
backend_weight$contador = 1
backend_data_directory = '/var/lib/postgresql/10/main'
backend_flag$contador = 'ALLOW_TO_FAILOVER'
"
contador=$(($contador+1))
done
sudo systemctl restart pgpool