mkdir /var/lib/iostat-poller
useradd -r -d /var/lib/iostat-poller -s /bin/false iostat
chown iostat:iostat /var/lib/iostat-poller/
touch /var/lib/iostat-poller/stats
cp usr-local-sbin/iostat-poller /usr/local/sbin/
cp etc-init.d/iostat-poller /etc/init.d/
