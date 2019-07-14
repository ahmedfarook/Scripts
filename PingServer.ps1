#$Server = GC C:\temp\comp.txt

$server = "Localhost","Server"

Foreach ($S in $Server)

    
{
    $Connection = $null

    $Connection = Test-Connection -ComputerName $S -Quiet -Count 1

    $Status = if ($Connection -eq $true) {$connection -replace "True" , "Online" } else {$connection -replace "False" , "Ofline"}

    $RDP = (Test-NetConnection -Port 33893 -ComputerName Localhost).TcpTestSucceeded
    $share = (Get-Item -Path \\localhost\C$).exists
    
    New-Object -TypeName Psobject -Property @{
                                               
                                               ServerNAme = $S
                                               Status = $Status
                                               PortConnected = $RDP
                                               ShareAccessible = $share 

                                             }
    


}


