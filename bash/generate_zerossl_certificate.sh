#!/bin/bash

# Konfigurationsvariablen
DOMAIN="manuel.regli.users.bbw-it.ch"
NSUPDATE_SERVER="ns.users.bbw-it.ch"
TTL=120
NSUPDATE_KEY="$HOME/bbw.key"
ACME="$HOME/.acme.sh/acme.sh"
MAIL="manuel.1231231234@gmail.com"

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
