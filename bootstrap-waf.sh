
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
dir_ssl="/etc/openssl"

if [[ ! -e $dir_ssl ]]; then
    mkdir $dir_ssl
elif [[ ! -d $dir_ssl ]]; then
    echo "$dir_ssl already exists" 1>&2
fi

cd $dir_ssl

#Change to your company details
country=FR
state=Ile-de-France
locality=Paris
organization=admin@admin.net
organizationalunit=FR
email=admin@aslldmin.net

#####GENERATE server_key
openssl genrsa -out server.key 2048
echo "Creating domain Key "
echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat server.key


openssl req -new -key server.key -out $dir_ssl/server.csr \
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

mkdir -p $dir_ssl/waf/
cat $dir_ssl/server.crt $dir_ssl/server.key > $dir_ssl/waf/splunk.pem

echo
echo "---------------------------"
echo "-----Below is your splunk.pem-----"
echo "---------------------------"
echo
cat  $dir_ssl/waf/splunk.pem

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

    frontend https-in-search-head-https
         bind *:8100 ssl crt /etc/openssl/waf/splunk.pem
         reqadd X-Forwarded-Proto:\ https
         default_backend backend-splunk-https-search-head

     frontend https-in-https-api
         bind *:8089 ssl crt /etc/openssl/waf/splunk.pem
         reqadd X-Forwarded-Proto:\ https
         default_backend backend-splunk-https

     backend backend-splunk-https
         # Use load balancer session cookie persistence
         balance roundrobin
         cookie SERVERID insert indirect nocache
         server sh1 192.168.33.140:8089 ssl verify none check cookie s1
         server sh2 192.168.33.150:8089 ssl verify none check cookie s2
         server sh3 192.168.33.160:8089 ssl verify none check cookie s2

     backend backend-splunk-https-search-head
         # Use load balancer session cookie persistence
         balance roundrobin
         cookie SERVERID insert indirect nocache
         server sh1 192.168.33.140:8000 ssl verify none cookie s1
         server sh2 192.168.33.150:8000 ssl verify none cookie s2
         server sh2 192.168.33.160:8000 ssl verify none cookie s3


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

systemctl restart haproxy
systemctl restart rsyslog
fi

exit 0
