#!/bin/bash

# Verwendet Umgebungsvariablen, die beim Start übergeben werden
DOMAIN=${DOMAIN}
NSUPDATE_SERVER=${NSUPDATE_SERVER}
TTL=${TTL}
NSUPDATE_KEY=${NSUPDATE_KEY}
ACME=${ACME}
MAIL=${MAIL}

# Exportiere Umgebungsvariablen für acme.sh
export NSUPDATE_SERVER
export NSUPDATE_KEY

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
" | nsupdate -k $NSUPDATE_KEY
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

echo "Zertifikatsgenerierungsskript wurde erfolgreich ausgeführt."
