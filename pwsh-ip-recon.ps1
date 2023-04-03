# Greeting
$username = $env:USERNAME
Write-Host "Hello, $username! Let's perform an IP recon."

# Prompt for IP address
$ipAddress = Read-Host "Which IP address would you like to recon?"
Write-Host $colorLine
# Collect geo information using ipinfo.io
$geoInfo = Invoke-RestMethod "http://ipinfo.io/$ipAddress/json" | Select-Object -Property *


# Perform nslookup, ping, and Resolve-DnsName queries with TTL 128
$nslookup = nslookup $ipAddress
$ping = Test-Connection -Count 1 -TTL 128 -BufferSize 32 -Delay 1 -ComputerName $ipAddress -ErrorAction SilentlyContinue
$dnsName = Resolve-DnsName $ipAddress


# Perform traceroute
#$traceroute = tracert $ipAddress


# Perform whois lookup
$whois = whois $ipAddress

# Set header color
$headerColor = "Cyan"

# Set Ping and DNS Name result header color
$pingHeaderColor = "Yellow"
$dnsNameHeaderColor = "Yellow"

# Set color line
$colorLine = "********************************"

# Display the information with comments and colors
Write-Host "IP Address: $ipAddress" -ForegroundColor $headerColor
Write-Host "Hostname: $($geoInfo.hostname)" -ForegroundColor $headerColor
Write-Host "City: $($geoInfo.city)" -ForegroundColor $headerColor
Write-Host "Region: $($geoInfo.region)" -ForegroundColor $headerColor
Write-Host "Country: $($geoInfo.country)" -ForegroundColor $headerColor
Write-Host "Latitude: $($geoInfo.loc.Split(',')[0])" -ForegroundColor $headerColor
Write-Host "Longitude: $($geoInfo.loc.Split(',')[1])" -ForegroundColor $headerColor
Write-Host "Timezone: $($geoInfo.timezone)" -ForegroundColor $headerColor
Write-Host "ISP: $($geoInfo.org)" -ForegroundColor $headerColor
Write-Host "AS Number: $($geoInfo.as)" -ForegroundColor $headerColor
Write-Host ""
Write-Host $colorLine



# Display NSLookup result with header color
Write-Host "NSLookup Result:" -ForegroundColor $headerColor
$nslookup
Write-Host $colorLine



# Display Ping result with header color and Ping result header color
Write-Host "Ping Result:" -ForegroundColor $headerColor
if ($ping) {
Write-Host "Success" -ForegroundColor $pingHeaderColor
Write-Host $pingRequest -ForegroundColor Green
} else {
Write-Host "Failed" -ForegroundColor Red
}
Write-Host $colorLine

# Display DNS Name result with header color and DNS Name result header color
Write-Host "DNS Name Result:" -ForegroundColor $headerColor
Write-Host $dnsName.NameHost -ForegroundColor $dnsNameHeaderColor
Write-Host $colorLine

# Display Traceroute result with header color
#Write-Host "Traceroute Result:" -ForegroundColor $headerColor
#$traceroute
#Write-Host $colorLine

# Display Whois result with header color
Write-Host "Whois Result:" -ForegroundColor $headerColor
$whois
