# ACME DNS Challenge Automation

Dieses Projekt automatisiert die ACME DNS-Challenge zur Zertifikatsgenerierung und -erneuerung mithilfe von Docker und nsupdate.

## Projektstruktur
```
.
├── certs/
│ └── {Name of Keyfile in certs}
├── docker-compose.yaml
├── Dockerfile
└── script.sh
```

## Voraussetzungen
- Docker
- Docker Compose

## Installation und Konfiguration

1. **DNS-Server Konfiguration:**
   Stelle sicher, dass dein DNS-Server nsupdate unterstützt und du eine Schlüsseldatei hast, die die Berechtigung zur Aktualisierung der DNS-Einträge hat. Platziere diese Schlüsseldatei im `certs/` Verzeichnis.

2. **Umgebungsvariablen:**
   Erstelle eine `.env` Datei im Projektverzeichnis mit den folgenden Inhalten:

   ```env
   DOMAIN=dein.domain.com
   NSUPDATE_SERVER=nsupdate.server.com
   TTL=300
   NSUPDATE_KEY=dein_nsupdate_keyfile
   MAIL=deine.email@domain.com

## Verwendung
1. Docker Container bauen und starten:
    ``` bash
    docker-compose up --build
    ```
2. Zertifikate finden:
    Nach erfolgreicher Ausführung des Containers werden die generierten Zertifikate im certs/ Verzeichnis abgelegt:
    - Zertifikat: certs/cert.crt
    - Schlüssel: certs/cert.key

## Skript Details
- script.sh:
    - Installiert acme.sh
    - Definiert Funktionen zum Hinzufügen und Entfernen von DNS TXT-Einträgen mittels nsupdate
    - Registriert einen ACME-Account
    - Führt die Zertifikatsgenerierung durch
    - Kopiert die generierten Zertifikate in das certs/ Verzeichnis
## Dockerfile Details
- Basierend auf ubuntu:latest
- Installiert benötigte Pakete (dnsutils, cron, curl, jq, bash, openssl)
- Kopiert und setzt Ausführungsrechte für script.sh
- Definiert script.sh als den Startbefehl des Containers
## Wichtige Hinweise
- Stelle sicher, dass die Domain und der DNS-Server korrekt konfiguriert sind.
- Die Schlüsseldatei im certs/ Verzeichnis sollte die Berechtigung haben, DNS-Einträge zu aktualisieren.