#! /bin/sh

chown -R xdmod /var/log/dailylogingest 
chmod -R 755 /var/log/dailylogingest
chown -R xdmod /var/xdmod
chmod -R 1777 /var/xdmod
crond -n 
