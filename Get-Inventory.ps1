
Function Get-Inventory
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ComputerPath,
                     
        $Outpath
    )

$Computers = Get-Content $ComputerPath

Foreach ($Computer in $Computers)

    {

    $Memory=(Get-WmiObject win32_ComputerSystem -ComputerName $Computer -Property TotalPhysicalMemory).TotalPhysicalMemory

    $Network = (Get-WmiObject -Class win32_networkadapter -ComputerName $Computer | where AdapterType -like "*ethernet*" | select name | ConvertTo-Csv -NoTypeInformation) -replace '"name"'

    $SystemData =Get-WmiObject win32_Processor -ComputerName $Computer | 
    select SystemName,NumberOfLogicalProcessors,@{n="Processor Speed";e={$_.MaxClockSpeed}},NumberOfCores,@{n='RAM Size(GB)';e={$memory / 1GB -as [INT]}},@{n='NetworkAdpter';e={$network}} |
    Export-Csv $Outpath -NoTypeInformation -Append
   
   }

    

}