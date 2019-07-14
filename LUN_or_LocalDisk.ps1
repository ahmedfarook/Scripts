Foreach ($Server in Get-Content C:\temp\servers.txt) 

{

Get-WmiObject -Class win32_diskdrive -computername AOEPTTA-APPIL01 | select systemname,model #|export-csv c:\temp\hdd.csv -append -notypeinformation

if ($? -eq $false)

    {$server >>c:\temp\errorserver.txt} 
