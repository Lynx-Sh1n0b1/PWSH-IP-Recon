clear

$headerColor = "Cyan"

$pingHeaderColor = "Yellow"
$dnsNameHeaderColor = "Yellow"
$alarmcolor = "Red"
$Okalarm = "Green"
$BlueLines = "Blue"

# Set color line
$colorLine = "********************************"

# Greeting
$username = $env:USERNAME
Write-Host "Hello, $username! Let's perform an IP recon."

# Prompt for IP address
$ipAddress = Read-Host "Which IP address would you like to recon?"

Write-Host "Processing..." -ForegroundColor $Okalarm

$progress = 0
while ($progress -le 100) {
 $status = "[$progress%]"
 Write-Host $status -NoNewline -ForegroundColor Magenta
 Write-Host " " -NoNewline
 $progress += 10
 Start-Sleep -Milliseconds 300
}
Write-Host ""
Write-Host $colorLine -ForegroundColor $dnsNameHeaderColor
# Collect geo information using ipinfo.io
$geoInfo = Invoke-RestMethod "http://ipinfo.io/$ipAddress/json" | Select-Object -Property *

# Perform nslookup
$nslookup = nslookup $ipAddress
$ping = Test-Connection -Count 1 -TTL 128 -BufferSize 32 -Delay 1 -ComputerName $ipAddress -ErrorAction SilentlyContinue
$dnsName = Resolve-DnsName $ipAddress

Write-Host ""
Write-Host $colorLine -ForegroundColor $BlueLines
Write-Host "Checking $ipAddress in AbuseIPDB ..." -ForegroundColor $headerColor
Write-Host ""
$url = "https://www.abuseipdb.com/check/$ipAddress"
$content = Invoke-WebRequest $url -UseBasicParsing | Select-Object -ExpandProperty RawContent
if ($content -like "*was found in our database*") {
if ($content -like "*This IP was reported*") {
$abuses = $content | Select-String -Pattern "(Bruteforce|Web App Attack|Email Spam|Bad Web Bot|Hacking|Port Scan|DNS Compromise|DDoS Attack|Web Spam|Spoofing|Exploited Host|SSH|IoT Targeted|FTP Brute-Force|Phishing|SQL Injection)" -AllMatches | Foreach-Object {$_.Matches.Value} | Select-Object -Unique
Write-Host "$ipAddress was found in AbuseIPDB database!!!!" -ForegroundColor $alarmcolor
Write-Host ""
Write-Host "Abuse types found: $($abuses -join ", " )" -ForegroundColor $alarmcolor
} else {
Write-Host "No AbuseIPDB reports found for IP: $ip" -ForegroundColor $Okalarm
}
} else {
Write-Host "$ipAddress wasn't found in AbuseIPDB" -ForegroundColor $Okalarm
}
Write-Host ""
Write-Host $colorLine -ForegroundColor $BlueLines


Write-Host "IPINFO.IO:" -ForegroundColor Cyan
Write-Host ""
# Display the information IPINFO.IO
Write-Host "IP Address: $ipAddress" -ForegroundColor Green
Write-Host "Hostname: $($geoInfo.hostname)" -ForegroundColor Green
Write-Host "City: $($geoInfo.city)" -ForegroundColor Green
Write-Host "Region: $($geoInfo.region)" -ForegroundColor Green
Write-Host "Country: $($geoInfo.country)" -ForegroundColor Green
Write-Host "Latitude: $($geoInfo.loc.Split(',')[0])" -ForegroundColor Green
Write-Host "Longitude: $($geoInfo.loc.Split(',')[1])" -ForegroundColor Green
Write-Host "Timezone: $($geoInfo.timezone)" -ForegroundColor Green
Write-Host "ISP: $($geoInfo.org)" -ForegroundColor Green
Write-Host "AS Number: $($geoInfo.as)" -ForegroundColor Green
Write-Host ""
Write-Host $colorLine -ForegroundColor $BlueLines

# Display NSLookup result
Write-Host "NSLookup Result:" -ForegroundColor $headerColor
Write-Host ""
$nslookup
Write-Host $colorLine -ForegroundColor $BlueLines

# Display Ping result
Write-Host "Ping Result:" -ForegroundColor $headerColor
Write-Host ""
if ($ping) {
Write-Host "Success" -ForegroundColor $pingHeaderColor
Write-Host $pingRequest -ForegroundColor Green
} else {
Write-Host "Failed" -ForegroundColor Red
}
Write-Host $colorLine -ForegroundColor $BlueLines

# Display DNS Name result
Write-Host "DNS Name Result:" -ForegroundColor $headerColor
Write-Host ""
Write-Host $dnsName.NameHost -ForegroundColor $dnsNameHeaderColor
Write-Host $colorLine -ForegroundColor $BlueLines


# Perform traceroute
#$traceroute = tracert $ipAddress
#Write-Host "Traceroute Result:" -ForegroundColor $headerColor
#$traceroute
#Write-Host $colorLine -ForegroundColor $BlueLines

# Perform whois lookup
$whois = whois $ipAddress
# Display Whois result
Write-Host "Whois Result:" -ForegroundColor $headerColor
$whois
