#!/bin/bash

# Permanent disable SELinux
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

# Install httpd
sudo dnf update -y
sudo dnf upgrade -y
sudo dnf -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Configure Firewall
sudo firewall-cmd --add-service={http,https} --zone=public --permanent
sudo firewall-cmd --add-port=10050/tcp --zone=public --permanent
sudo firewall-cmd --reload

# Install zabbix agent
sudo rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
sudo dnf -y install zabbix-agent

# Configure zabbix agent
sed -i 's/Server=.*/Server=192.168.56.10/' /etc/zabbix/zabbix-agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix-agentd.conf

# Start and Enable zabbix agent
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
