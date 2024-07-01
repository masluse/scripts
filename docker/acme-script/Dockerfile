# Verwende ein Basis-Image, das eine leichte Linux-Distribution enthält
FROM ubuntu:latest

# Installiere Abhängigkeiten
RUN apt update && \
    apt install dnsutils cron curl jq bash openssl -y

# Kopiere das Skript in den Container
COPY script.sh /usr/local/bin/script.sh

# Gebe dem Skript Ausführungsrechte
RUN chmod +x /usr/local/bin/script.sh

# Definiere den Befehl, der beim Starten des Containers ausgeführt wird
CMD ["/usr/local/bin/script.sh"]