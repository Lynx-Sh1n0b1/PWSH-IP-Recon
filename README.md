# PWSH-IP-Recon
Powershell IP reconnaissance script!
**************************
Looking to do some IP reconnaissance? Look no further than this powerful PowerShell IP recon script! 
With just a few simple steps, you can easily gather a wealth of information about any IP address. Here's how it works:

1) Launch the PowerShell script.
2) Insert the IP address you want to investigate and hit Enter.
3) The script will automatically query multiple sources and tools, including AbuseIPDB, ipinfo.io, ping (to check if the IP is alive or dead), nslookup, Resolve-DnsName, and whois.
4) Optionally, you can also use the traceroute function by uncommenting the relevant section of the code. Note that this function can take some time to run.

Scrip uses next modules and services:
- AbuseIPDB
- ipinfo.io
- ping (alive\dead)
- nslookup
- Resolve-DnsName
- whois
- Optional feature: you also can use traceroute function (just uncomment traceroute part. I've commented it bkz traceroute take some time and I hate wait)
