# Zabbix_sample_VirtualBox&Vagrant
This repo is for building Zabbix test verification environment on Virtual Box using vagrant.

## Create Zabbix Server & Zabbix Agent

```bash
git clone 
cd zabbix-test
vagrant up zabbix_
vagrant up zabbix_agent
```

If you execute above commands, you can build AlmaLinux8 to installing, configuring and start zabbix agent.

### Configure
#### zabbix-server
1. After connect zabbix with ssh, excute some command to launch zabbix server reference below shell.
2. Please open the window ``localhost:8888/zabbix`` by your host browser.
3. Confirm first settings and login as Admin, password

```bash
# Launch MYSQL and auto launch settings
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Configure FirstSetting about MySQL
sudo mysql_secure_installation <<EOF


y
password
password
y
y
y
y
EOF

# Variables as a password
ZABBIX_DB_PASS="zabbix"

# Create database for Zabbix on MySQL
sudo mysql -u root -ppassword <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;
CREATE USER zabbix@localhost IDENTIFIED BY '$ZABBIX_DB_PASS';
GRANT ALL PRIVILAGES ON zabbix.* TO zabbix@'localhost';
FLUSH PRIVILAGES;
EOF
echo "MySQL zabbix user and password set and creating table complete!"

# Create table for Zabbix
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p$ZABBIX_DB_PASS zabbix

# Configure Zabbix Server
sudo sed -i "s/# DBPassword=/DBPassword=$ZABBIX_DB_PASS/" /etc/zabbix/zabbix_server.conf

# Configure php timezone
sudo sed -i 's/^; php_value[date.timezone] =$/php_value[date.timezone] = Asia\/Tokyo/' /etc/php-fpm.d/zabbix.conf

# Restart Zabbix Server and Web Server
sudo systemctl restart zabbix-server zabbix-agent php-fpm httpd

# Acitivate Firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Configure Firewall
sudo firewall-cmd --add-service={http,https} --zone=public --permanent
sudo firewall-cmd --reload
```

| Parameter | Explanation |
| ---- | ---- |
| MySQL Password for Root | password |
| MySQL Password for Zabbix| zabbix |

Please confirm ``/scripts/zabbix/provision.sh``.

#### zabbix-agent

Nothing.

### Notes
#### About zabbix-server
Various daemons are not enabled in provision.sh. 
Therefore, please execute ``systemctl start zabbix-server zabbix-agent php-fpm httpd`` at the second and subsequent startups.

## Environment
* VirtualBox 6.1.38
* Vagrant 2.2.19

* Ubuntu 22.04 (LTS)