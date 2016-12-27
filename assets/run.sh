#!/bin/sh

sed -e "s/##ZKADDRESS##/$ZKADDRESS/" /var/tmp/activemq.xml > /opt/activemq/conf/activemq.xml
python /app/init.py
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
