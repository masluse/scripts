#!/bin/bash

# Set up variables for the script
DOMAIN="www.manuel.regli.users.bbw-it.ch"
NSUPDATE_SERVER="ns.users.bbw-it.ch"
TTL=120
ACME="$HOME/.acme.sh/acme.sh"
MAIL="manuel.1231231234@gmail.com"
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# The content of the NSUPDATE key
NSUPDATE_KEY_CONTENT=$(cat <<'EOF'
{ KEY }
EOF
)

# Update the package list and install necessary packages
sudo apt-get update
sudo apt-get install -y curl bind9utils nginx

# Install acme.sh
curl https://get.acme.sh | sh

mkdir /setup
cd /setup
# Create the NSUPDATE key file
echo "$NSUPDATE_KEY_CONTENT" > ./bbw.key
chmod 600 ./bbw.key

# Export environment variables for acme.sh
export NSUPDATE_SERVER
export NSUPDATE_KEY="./bbw.key"
export DOMAIN
export TTL
export ACME
export MAIL

# Download the generate_zerossl_certificate.sh script
curl -o ./generate_zerossl_certificate.sh https://raw.githubusercontent.com/masluse/scripts/main/bash/generate_zerossl_certificate/script.sh

# Make the script executable
chmod +x ./generate_zerossl_certificate.sh

# Execute the script
./generate_zerossl_certificate.sh

echo "server $NSUPDATE_SERVER
update delete $DOMAIN.
send
" | nsupdate -k $NSUPDATE_KEY

echo "server $NSUPDATE_SERVER
update add $DOMAIN. 300 IN A $PUBLIC_IP
send
" | nsupdate -k $NSUPDATE_KEY

# Move the generated certificate to the appropriate location for Nginx
sudo mv /etc/ssl/certs/cert.crt /tmp/
sudo mv /etc/ssl/private/cert.key /tmp/
sudo cp $HOME/.acme.sh/${DOMAIN}_ecc/$DOMAIN.cer /etc/ssl/certs/cert.crt
sudo cp $HOME/.acme.sh/${DOMAIN}_ecc/$DOMAIN.key /etc/ssl/private/cert.key

# Configure Nginx to use the new certificate
sudo bash -c "cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name $DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;

    server_name $DOMAIN;

    ssl_certificate /etc/ssl/certs/cert.crt;
    ssl_certificate_key /etc/ssl/private/cert.key;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
}
EOF"

# Restart Nginx to apply the changes
sudo systemctl restart nginx