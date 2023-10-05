$proxyUrl = "http://proxy.com:8080"
$proxy = New-Object System.Net.WebProxy($proxyUrl, $true)

# Setze Proxy für alle weiteren Web-Anfragen
[System.Net.WebRequest]::DefaultWebProxy = $proxy
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

# Server zum Pingen
$serverToPing = "8.8.8.8" 

# Teste die Verbindung zum Server
$pingResult = Test-NetConnection -ComputerName $serverToPing -ErrorAction SilentlyContinue

# Erstelle Basis Request
$Request = @{
  Method  = "POST"
  URI     = "https://ntfy.com/ping"
  Headers = @{
    Title    = "Server Status"
    Priority = "urgent"
    Authorization = "Bearer <Token>"
  }
}

# Überprüfe, ob der Ping erfolgreich war
if ($pingResult.PingSucceeded -eq $true) {
  $Request.Body = "Ping to $($serverToPing) was successful."
} else {
  $Request.Body = "Ping to $($serverToPing) failed."
}

# Sende den Request
try {
  Invoke-RestMethod @Request -UseDefaultCredentials -UseBasicParsing
} catch {
  Write-Host "Failed to send notification: $_" -ForegroundColor Red
}
