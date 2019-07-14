$ComputerName = Get-content c:\temp\server.txt
foreach ($computer in $ComputerName) {Get-Service *RasMan* -ComputerName $computer | Set-Service -StartupType Disabled}