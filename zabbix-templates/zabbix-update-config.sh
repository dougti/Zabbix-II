#git clone https://github.com/fscomm/Zabbix-II.git &&
#cd Zabbix-II/zabbix-templates/linux-FIT-parkings/ &&
/bin/cp -rf usr-local-bin/* /usr/local/bin/ &&
/bin/cp -rvf zabbix_agentd/* /etc/zabbix/zabbix_agentd.d/ &&
cd ../linux-disk-io-stats/ &&
/bin/cp -rf usr-local-bin/* /usr/local/bin/ &&
/bin/cp -rf usr-local-sbin/* /usr/local/sbin/ &&
/bin/cp -rf etc-init.d/* /etc/init.d/ &&
/bin/cp -rvf zabbix_agentd/* /etc/zabbix/zabbix_agentd.d/ &&
cd ../linux-iptables &&
/bin/cp -rf usr-lib64-nagios-plugins/* /usr/lib64/nagios/plugins/ &&
/bin/cp -rf zabbix_agentd/* /etc/zabbix/zabbix_agentd.d/ &&

mkdir /var/lib/iostat-poller &&
useradd -r -d /var/lib/iostat-poller -s /bin/false iostat &&
touch /var/lib/iostat-poller/stats &&
chown -R iostat:iostat /var/lib/iostat-poller/ &&
service zabbix-agent restart &&
service iostat-poller start &&
cat /var/lib/iostat-poller/stats &&
chkconfig iostat-poller on
