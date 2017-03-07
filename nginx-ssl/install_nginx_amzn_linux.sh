#!/bin/bash
# INSTALL NGINX - https://www.digitalocean.com/community/tutorials/how-to-create-a-ssl-certificate-on-nginx-for-centos-6
# enabled epel repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/epel.repo
yum -y install nginx
sudo mkdir /etc/nginx/ssl
cd /etc/nginx/ssl

# Generate cert and CSR
# https://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr

# Required
domain=`hostname`
 
# Change to your company details
commonname=$domain
country=GB
state=London
locality=London
organization=example
organizationalunit=Infrastructure
email=pki@example.com
 
# Optional
password=TemporaryPassword
 
echo "Generating key request for $domain"
# Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout
 
# Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out $domain.key
 
# Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

# Signing the request
sudo openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt

# HTTPS server
echo -e "\nserver {\n    listen       443;\n    server_name $domain;\n    ssl on;\n    ssl_certificate /etc/nginx/ssl/$domain.crt;\n    ssl_certificate_key /etc/nginx/ssl/$domain.key; \n}" >> /etc/nginx/conf.d/virtual.conf
/etc/init.d/nginx restart

# Set to start at boot
sudo chkconfig nginx on
