$SERVER_NAme = Get-Content C:\TEMP\server.txt
foreach ($server in $SERVER_NAme) 
{

    install-WindowsFeature -Name Web-Mgmt-Tools -ComputerName $server
}
