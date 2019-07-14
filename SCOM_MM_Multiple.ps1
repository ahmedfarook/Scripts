Import-module OperationsManager
New-SCOMManagementGroupConnection -ComputerName emeamai-mn14
$agentNAme = Get-Content c:\temp\serveragent.txt
Foreach ($agents in $agentNAme)
{
$agent = Get-SCOMAgent -name $agents*
$Comment= "Scheduletask reboot"
$StartTime = [DateTime]::Now
$EndTime = $StartTime.AddMinutes(60)        
Start-SCOMMaintenanceMode -Instance $Agent.HostComputer -EndTime $EndTime -Reason "PlannedOther" -Comment $Comment  
}