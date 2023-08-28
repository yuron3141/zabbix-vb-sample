# Zabbix_sample_VirtualBox&Vagrant
This repo is for building Zabbix test verification environment on Virtual Box using vagrant.

## Create Zabbix Server & Zabbix Agent

```bash
git clone 
cd zabbix-test
vagrant up
```

If you execute above commands, you can build AlmaLinux8 to installing, configuring and start zabbix agent.

### Parameters
#### zabbix-server

| Parameter | Explanation |
| ---- | ---- |
| MySQL Password for Root | Root12345@ |
| MySQL Password for Zabbix| Zabbix12345@ |

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