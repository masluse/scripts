# Verwende ein Basis-Image, das eine leichte Linux-Distribution enthält
FROM alpine:latest

# Installiere Abhängigkeiten
RUN apk update && \
    apk add --no-cache bind-tools curl jq bash

# Installiere acme.sh
RUN curl https://get.acme.sh | sh

# Kopiere das Skript in den Container
COPY script.sh /usr/local/bin/script.sh

# Gebe dem Skript Ausführungsrechte
RUN chmod +x /usr/local/bin/script.sh

# Definiere den Befehl, der beim Starten des Containers ausgeführt wird
CMD ["/usr/local/bin/script.sh"]
