# Cloud Init zu erstellung eines Webservers mit Zerossl Zertifikat und DNS Eintrag

## Übersicht

Dieses Repository enthält ein einfaches Python-Skript, das grundlegende Datenanalysen durchführt. Das Skript liest eine CSV-Datei ein, berechnet einige grundlegende Statistiken und gibt die Ergebnisse in der Konsole aus.

## Installation

1. Klonen Sie das Repository:
   ```sh
   git clone https://github.com/IhrBenutzername/repository-name.git
Navigieren Sie in das Verzeichnis des Repositorys:

sh
Code kopieren
cd repository-name
Installieren Sie die erforderlichen Bibliotheken:

sh
Code kopieren
pip install pandas
Verwendung
Stellen Sie sicher, dass sich die zu analysierende CSV-Datei im selben Verzeichnis wie das Skript befindet oder geben Sie den Pfad zur Datei an.

Führen Sie das Skript aus:

sh
Code kopieren
python script.py data.csv
Das Skript gibt die folgenden Informationen aus:

Anzahl der Zeilen und Spalten in der CSV-Datei
Grundlegende Statistiken für jede numerische Spalte (Mittelwert, Median, Standardabweichung usw.)
## Beispiel
Ein Beispiel für die Ausgabe des Skripts könnte wie folgt aussehen:
``` bash
root@ip-172-31-63-43:~# ./script.sh
Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
curl is already the newest version (8.5.0-2ubuntu10.1).
curl set to manually installed.
The following additional packages will be installed:
  bind9-utils nginx-common
Suggested packages:
  fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  bind9-utils bind9utils nginx nginx-common
0 upgraded, 4 newly installed, 0 to remove and 0 not upgraded.
Need to get 714 kB of archives.
After this operation, 2276 kB of additional disk space will be used.
Get:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 bind9-utils amd64 1:9.18.24-0ubuntu5 [159 kB]
Get:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 bind9utils all 1:9.18.24-0ubuntu5 [3668 B]
Get:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 nginx-common all 1.24.0-2ubuntu7 [31.2 kB]
Get:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 nginx amd64 1.24.0-2ubuntu7 [521 kB]
Fetched 714 kB in 0s (3924 kB/s)
Preconfiguring packages ...
Selecting previously unselected package bind9-utils.
(Reading database ... 102461 files and directories currently installed.)
Preparing to unpack .../bind9-utils_1%3a9.18.24-0ubuntu5_amd64.deb ...
Unpacking bind9-utils (1:9.18.24-0ubuntu5) ...
Selecting previously unselected package bind9utils.
Preparing to unpack .../bind9utils_1%3a9.18.24-0ubuntu5_all.deb ...
Unpacking bind9utils (1:9.18.24-0ubuntu5) ...
Selecting previously unselected package nginx-common.
Preparing to unpack .../nginx-common_1.24.0-2ubuntu7_all.deb ...
Unpacking nginx-common (1.24.0-2ubuntu7) ...
Selecting previously unselected package nginx.
Preparing to unpack .../nginx_1.24.0-2ubuntu7_amd64.deb ...
Unpacking nginx (1.24.0-2ubuntu7) ...
Setting up bind9-utils (1:9.18.24-0ubuntu5) ...
Setting up bind9utils (1:9.18.24-0ubuntu5) ...
Setting up nginx (1.24.0-2ubuntu7) ...
Setting up nginx-common (1.24.0-2ubuntu7) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
Processing triggers for ufw (0.36.2-6) ...
Processing triggers for man-db (2.12.0-4build2) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Pending kernel upgrade!
Running kernel version:
  6.8.0-1008-aws
Diagnostics:
  The currently running kernel version is not the expected kernel version 6.8.0-1009-aws.

Restarting the system to load the new kernel will not be handled automatically, so you should consider rebooting.

Restarting services...

Service restarts being deferred:
 /etc/needrestart/restart.d/dbus.service
 systemctl restart getty@tty1.service
 systemctl restart networkd-dispatcher.service
 systemctl restart serial-getty@ttyS0.service
 systemctl restart systemd-logind.service
 systemctl restart unattended-upgrades.service

No containers need to be restarted.

User sessions running outdated binaries:
 ubuntu @ session #1: sshd[1023,1133], su[1184]
 ubuntu @ user manager service: systemd[1028]

No VM guests are running outdated hypervisor (qemu) binaries on this host.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1032    0  1032    0     0   6508      0 --:--:-- --:--:-- --:--:--  6531
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  218k  100  218k    0     0  3504k      0 --:--:-- --:--:-- --:--:-- 3519k
[Tue Jun 18 10:52:00 UTC 2024] Installing from online archive.
[Tue Jun 18 10:52:00 UTC 2024] Downloading https://github.com/acmesh-official/acme.sh/archive/master.tar.gz
[Tue Jun 18 10:52:00 UTC 2024] Extracting master.tar.gz
[Tue Jun 18 10:52:00 UTC 2024] It is recommended to install socat first.
[Tue Jun 18 10:52:00 UTC 2024] We use socat for standalone server if you use standalone mode.
[Tue Jun 18 10:52:00 UTC 2024] If you don't use standalone mode, just ignore this warning.
[Tue Jun 18 10:52:00 UTC 2024] Installing to /root/.acme.sh
[Tue Jun 18 10:52:00 UTC 2024] Installed to /root/.acme.sh/acme.sh
[Tue Jun 18 10:52:00 UTC 2024] Installing alias to '/root/.bashrc'
[Tue Jun 18 10:52:00 UTC 2024] OK, Close and reopen your terminal to start using acme.sh
[Tue Jun 18 10:52:00 UTC 2024] Installing cron job
no crontab for root
no crontab for root
[Tue Jun 18 10:52:00 UTC 2024] Good, bash is found, so change the shebang to use bash as preferred.
[Tue Jun 18 10:52:01 UTC 2024] OK
[Tue Jun 18 10:52:01 UTC 2024] Install success!
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1360  100  1360    0     0   9199      0 --:--:-- --:--:-- --:--:--  9251
[Tue Jun 18 10:52:02 UTC 2024] Create account key ok.
[Tue Jun 18 10:52:02 UTC 2024] No EAB credentials found for ZeroSSL, let's get one
[Tue Jun 18 10:52:03 UTC 2024] Registering account: https://acme.zerossl.com/v2/DV90
[Tue Jun 18 10:52:03 UTC 2024] Registered
[Tue Jun 18 10:52:04 UTC 2024] ACCOUNT_THUMBPRINT='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
[Tue Jun 18 10:52:04 UTC 2024] Using CA: https://acme.zerossl.com/v2/DV90
[Tue Jun 18 10:52:04 UTC 2024] Creating domain key
[Tue Jun 18 10:52:04 UTC 2024] The domain key is here: /root/.acme.sh/manuel.regli.users.bbw-it.ch_ecc/manuel.regli.users.bbw-it.ch.key
[Tue Jun 18 10:52:04 UTC 2024] Single domain='manuel.regli.users.bbw-it.ch'
[Tue Jun 18 10:52:05 UTC 2024] Getting webroot for domain='manuel.regli.users.bbw-it.ch'
[Tue Jun 18 10:52:05 UTC 2024] Adding txt value: t1Av45zwi7RsQs7BoDv0i4XqnN4OeLgICXEjb5sDDj0 for domain:  _acme-challenge.manuel.regli.users.bbw-it.ch
[Tue Jun 18 10:52:05 UTC 2024] adding _acme-challenge.manuel.regli.users.bbw-it.ch. 60 in txt "t1Av45zwi7RsQs7BoDv0i4XqnN4OeLgICXEjb5sDDj0"
[Tue Jun 18 10:52:06 UTC 2024] The txt record is added: Success.
[Tue Jun 18 10:52:06 UTC 2024] Sleep 120 seconds for the txt records to take effect
[Tue Jun 18 10:54:07 UTC 2024] Verifying: manuel.regli.users.bbw-it.ch
[Tue Jun 18 10:54:07 UTC 2024] Processing, The CA is processing your order, please just wait. (1/30)
[Tue Jun 18 10:54:11 UTC 2024] Success
[Tue Jun 18 10:54:11 UTC 2024] Removing DNS records.
[Tue Jun 18 10:54:11 UTC 2024] Removing txt: t1Av45zwi7RsQs7BoDv0i4XqnN4OeLgICXEjb5sDDj0 for domain: _acme-challenge.manuel.regli.users.bbw-it.ch
[Tue Jun 18 10:54:11 UTC 2024] removing _acme-challenge.manuel.regli.users.bbw-it.ch. txt
[Tue Jun 18 10:54:11 UTC 2024] Removed: Success
[Tue Jun 18 10:54:11 UTC 2024] Verify finished, start to sign.
[Tue Jun 18 10:54:11 UTC 2024] Lets finalize the order.
[Tue Jun 18 10:54:11 UTC 2024] Le_OrderFinalize='https://acme.zerossl.com/v2/DV90/order/8_UCm3aKk8YpoTx2dC7XqA/finalize'
[Tue Jun 18 10:54:11 UTC 2024] Order status is processing, lets sleep and retry.
[Tue Jun 18 10:54:11 UTC 2024] Retry after: 15
[Tue Jun 18 10:54:27 UTC 2024] Polling order status: https://acme.zerossl.com/v2/DV90/order/8_UCm3aKk8YpoTx2dC7XqA
[Tue Jun 18 10:54:27 UTC 2024] Downloading cert.
[Tue Jun 18 10:54:27 UTC 2024] Le_LinkCert='https://acme.zerossl.com/v2/DV90/cert/-FTP1cH7Z0dXDF2jrzVWTw'
[Tue Jun 18 10:54:28 UTC 2024] Cert success.
-----BEGIN CERTIFICATE-----
MIIEGjCCA6CgAwIBAgIQGQFVDqMVVJ9qqGeXlGoMoDAKBggqhkjOPQQDAzBLMQsw
CQYDVQQGEwJBVDEQMA4GA1UEChMHWmVyb1NTTDEqMCgGA1UEAxMhWmVyb1NTTCBF
Q0MgRG9tYWluIFNlY3VyZSBTaXRlIENBMB4XDTI0MDYxODAwMDAwMFoXDTI0MDkx
NjIzNTk1OVowJzElMCMGA1UEAxMcbWFudWVsLnJlZ2xpLnVzZXJzLmJidy1pdC5j
aDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABMGOhRyvMXOWw4gksv61vv2YqjMg
n+WiZuQtOdKmz4zEEIdVFMfCsSmwo/VjEPx7gcGeqoibTqUV4RM2xXWC46mjggKI
MIIChDAfBgNVHSMEGDAWgBQPa+ZLzjlHrvZ+kB558DCRkshfozAdBgNVHQ4EFgQU
AQ7ogiRl3RcCTpmBrfhQQPgnBicwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQC
MAAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMEkGA1UdIARCMEAwNAYL
KwYBBAGyMQECAk4wJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9D
UFMwCAYGZ4EMAQIBMIGIBggrBgEFBQcBAQR8MHowSwYIKwYBBQUHMAKGP2h0dHA6
Ly96ZXJvc3NsLmNydC5zZWN0aWdvLmNvbS9aZXJvU1NMRUNDRG9tYWluU2VjdXJl
U2l0ZUNBLmNydDArBggrBgEFBQcwAYYfaHR0cDovL3plcm9zc2wub2NzcC5zZWN0
aWdvLmNvbTCCAQQGCisGAQQB1nkCBAIEgfUEgfIA8AB2AHb/iD8KtvuVUcJhzPWH
ujS0pM27KdxoQgqf5mdMWjp0AAABkCr7o1kAAAQDAEcwRQIhAMTed+m/J51/xrCw
BoL0Wu/uRBzfQqVvaf7dRhCEK4wEAiBIjPVC2EutW1/tnTduTu/tDx0RwtTs3CMG
j7C7RlP2qQB2AD8XS0/XIkdYlB1lHIS+DRLtkDd/H4Vq68G/KIXs+GRuAAABkCr7
oxoAAAQDAEcwRQIgWC9qIB4RL9nMxTr7xCjcOCwby4GJYGRGYDg+jNLQ+OoCIQDY
9jOipV8pTD5lqY0JHialtXvK6qOmjERuA+KQKNNlNDAnBgNVHREEIDAeghxtYW51
ZWwucmVnbGkudXNlcnMuYmJ3LWl0LmNoMAoGCCqGSM49BAMDA2gAMGUCMQDZYbCN
1LssMlG8zFWCKn+FnAGGRXsYppMvTlLPN3agR/q1obKH9LNVK5Di4qkv7jUCMFD/
MK09jB3C9vNsWpfdhQCWNAekb0tCgCMeCfxRSf2ffmBCaCOd0zAne3ZODQHHwQ==
-----END CERTIFICATE-----
[Tue Jun 18 10:54:28 UTC 2024] Your cert is in: /root/.acme.sh/manuel.regli.users.bbw-it.ch_ecc/manuel.regli.users.bbw-it.ch.cer
[Tue Jun 18 10:54:28 UTC 2024] Your cert key is in: /root/.acme.sh/manuel.regli.users.bbw-it.ch_ecc/manuel.regli.users.bbw-it.ch.key
[Tue Jun 18 10:54:28 UTC 2024] The intermediate CA cert is in: /root/.acme.sh/manuel.regli.users.bbw-it.ch_ecc/ca.cer
[Tue Jun 18 10:54:28 UTC 2024] And the full chain certs is there: /root/.acme.sh/manuel.regli.users.bbw-it.ch_ecc/fullchain.cer
Zertifikatsgenerierungsskript wurde erfolgreich ausgeführt.
mv: cannot stat '/etc/ssl/certs/cert.crt': No such file or directory
mv: cannot stat '/etc/ssl/private/cert.key': No such file or directory
```
