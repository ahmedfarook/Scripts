
$Path = Read-Host "Please Enter the Server list Path"
$ComputerName= Get-Content $Path
    Foreach ($Computer in $ComputerName) 
    {
        Get-Service adtagent -ComputerName $Computer -ErrorAction SilentlyContinue | Select -Property Name,Status,DisplayName,MachineName 
    }


Foreach ($server in $serverlist) {Get-WmiObject win32_service -ComputerName  $server| Select Name,StartMode,State,DisplayName,PsComputerName}