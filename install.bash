#!/bin/bash

# run me as root plzz

SERVERINTERNALIP=$(hostname -i)

# PREREQS
apt-get -y update; apt-get -y install emacs24-nox; apt-get -y install make; apt-get -y install gcc; apt-get install ucspi-tcp

# INSTALLING DAEMONTOOLS
mkdir -p /package; chmod 1755 /package; cd /package; wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz; gunzip daemontools-0.76.tar; tar -xpf daemontools-0.76.tar; rm -f daemontools-0.76.tar; cd admin/daemontools-0.76; sed -i 's/-Wimplicit/-include \/usr\/include\/errno.h -Wimplicit/g' src/conf-cc; package/install; svscanboot &

# INSTALLING DJBDNs
cd ~; wget http://cr.yp.to/djbdns/djbdns-1.05.tar.gz; gunzip djbdns-1.05.tar; tar -xf djbdns-1.05.tar; cd djbdns-1.05; echo gcc -O2 -include /usr/include/errno.h > conf-cc; make; make setup check

# SPINNING UP SERVER
yes | adduser --no-create-home --disabled-login --shell /bin/false dnslog; yes | adduser --no-create-home --disabled-login --shell /bin/false tinydns; tinydns-conf tinydns dnslog /etc/tinydns/ $SERVERINTERNALIP; mkdir -p /service; cd /service ; ln -sf /etc/tinydns/; svc -d /service/tinydns; svc -u /service/tinydns; sleep 5; netstat -peanut
