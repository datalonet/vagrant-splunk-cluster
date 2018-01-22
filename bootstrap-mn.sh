#!/usr/bin/env bash
###################################
#  INSTALL opensll                #
###################################
#Install openssl
sudo yum install mod_ssl openssl -y

# Generate Openssl crt

######################################
#  GENERATE SSL SELF-SIGNED          #
######################################
mkdir /etc/openssl
cd /etc/openssl/

#Change to your company details
country=FR
state=Ile-de-France
locality=Paris
organization=admin@admin.net
organizationalunit=FR
email=admin@admin.net

#####GENERATE server_key
openssl genrsa -out server.key 2048
echo "Creating domain Key "
echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat server.key


openssl req -new -key server.key -out server.csr \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat server.csr

openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

echo
echo "---------------------------"
echo "-----Below is your crt-----"
echo "---------------------------"
echo
cat server.key



#################################
# COCANTENATE crt and key to pem#
#################################
cd /etc/openssl

mkdir /etc/openssl/waf/
cat /etc/openssl/server.crt /etc/openssl/server.key > /etc/openssl/waf/splunk.pem

echo
echo "---------------------------"
echo "-----Below is your splunk.pem-----"
echo "---------------------------"
echo
cat  /etc/openssl/waf/splunk.pem

#################################
# HAPROXY INSTALLATION          #
#################################
echo "Starting Haproxy Configuration"
if [ ! -f /etc/haproxy/haproxy.cfg ]; then

# Install haproxy
sudo yum install haproxy -y

# Configure haproxy
  cat > /etc/default/haproxy <<EOD
# Set ENABLED to 1 if you want the init script to start haproxy.
ENABLED=1
# Add extra flags here.
#EXTRAOPTS="-de -m 16"
EOD
  cat > /etc/haproxy/haproxy.cfg <<EOD
  global
      daemon
      maxconn 256
      log 127.0.0.1 local2
  defaults
      mode http
      timeout connect 5000ms
      timeout client 50000ms
      timeout server 50000ms

      listen  stats   *:8080
         mode            http
         log             global
         stats enable
         stats hide-version
         stats refresh 30s
         stats show-node
         stats auth admin:password
         stats uri  /stats

  frontend splunk_secured
     mode http
     bind *:443 ssl crt /etc/openssl/waf/splunk.pem # Includes Cert/Root/Intermediate/PrivateKey
     reqadd X-Forwarded-Proto:\ https
     redirect scheme https if !{ ssl_fc }
     default_backend webservers

  backend webservers
      balance roundrobin
      mode http
      balance roundrobin # Load Balancing algorithm
      cookie SRV insert indirect nocache # Allows sticky sessions
      ## Define your servers to balance
      option httpchk
      option forwardfor
      option http-server-close
      server shc1 192.168.33.140:8000 check  port 8000
      server shc2 192.168.33.150:8000 check  port 8000
      server shc3 192.168.33.160:8000 check  port 8000


EOD

  cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
fi

### Logging
if [ ! -f /etc/rsyslog.d/haproxy.conf ]; then
	cat > /etc/rsyslog.d/haproxy.conf <<EOD
local2.*    /var/log/haproxy.log
EOD

	cat >> /etc/rsyslog.conf <<EOD
$ModLoad imudp
$UDPServerRun 514
$UDPServerAddress 127.0.0.1

EOD

service rsyslog restart
service haproxy restart
fi

exit 0
