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