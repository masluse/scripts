#!/bin/bash

# Verwendet Umgebungsvariablen, die beim Start übergeben werden
# ${DOMAIN} ${NSUPDATE_SERVER} ${TTL} ${NSUPDATE_KEY} ${ACME} ${MAIL} ${NSUPDATE_KEY_CONTENT}

curl https://get.acme.sh | sh

ACME="${HOME}/.acme.sh/acme.sh"

NSUPDATE_KEY="/certs/${NSUPDATE_KEY}"

# DNS-Update Skript für das Hinzufügen des TXT-Eintrags
dns_add() {
    DOMAIN=$1
    DNS_VALUE=$2

    echo "server $NSUPDATE_SERVER
update delete _acme-challenge.$DOMAIN. TXT
update add _acme-challenge.$DOMAIN. $TTL TXT \"$DNS_VALUE\"
send
" | nsupdate -k $NSUPDATE_KEY
}

# DNS-Update Skript für das Entfernen des TXT-Eintrags
dns_rm() {
    DOMAIN=$1
    DNS_VALUE=$2

    echo "server $NSUPDATE_SERVER
update delete _acme-challenge.$DOMAIN. TXT \"$DNS_VALUE\"
send
" | nsupdate
}

# Wrapper Skript für acme.sh zur Verwendung der DNS-Update Funktionen
acme_nsupdate() {
    case "$1" in
        add)
            dns_add "$2" "$4"
            ;;
        rm)
            dns_rm "$2" "$4"
            ;;
        *)
            echo "Usage: $0 {add|rm} domain txtvalue"
            return 1
            ;;
    esac
}

# Zertifikat generieren oder erneuern
$ACME --register-account -m $MAIL --server zerossl

$ACME --server zerossl --issue --dns dns_nsupdate --dnssleep 120 -d $DOMAIN

cp $HOME/.acme.sh/${DOMAIN}_ecc/$DOMAIN.cer /certs/cert.crt

cp $HOME/.acme.sh/${DOMAIN}_ecc/$DOMAIN.key /certs/cert.key

echo "Zertifikatsgenerierungsskript wurde erfolgreich ausgeführt."