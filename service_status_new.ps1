$path = Read-Host "Please Enter the Server List"
$server = Get-Content $path
Foreach ($s in $server) 
{
    Get-Service -ComputerName $server -Name 'Sysload Collector' | select -Property MachineName,DisplayName,Status
}