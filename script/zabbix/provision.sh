#!/bin/bash

# Permanent disable SELinux
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

# Update repos
# sudo dnf install -y centos-release-scl
sudo dnf update -y

# Install Zabbix repos
sudo rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
sudo dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-web-japanese zabbix-apache-conf zabbix-agent 

# Install MySQL
sudo dnf install -y mysql-server

# Launch MYSQL and auto launch settings
sudo systemctl start mysqld
sudo systemctl enable mysqld

# MySQL Secure settings
# (Please Use below command when you don't use autocreated pass)
# sudo mysql_secure_installation

# Variables as a password
# MYSQL_PASS = $(grep 'A temporary password' /var/log/mysql/mysqld.log | awk '{print $NF}')
DB_PASS = "Zabbix12345@"

# Create database for Zabbix on MySQL
sudo mysql -u root -p <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root12345@';
CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;
CREATE USER zabbix@localhost IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILAGES ON zabbix.* TO zabbix@localhost;
FLUSH PRIVILAGES;
EOF

# Create table for Zabbix
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p$DB_PASS zabbix

# Configure Zabbix Server
sudo sed -i "s/# DBPassword=/DBPassword=$DB_PASS/" /etc/zabbix/zabbix_server.conf

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