Function Get-LogicalDisk
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ComputerPath,
                     
        $OutPath
    )

    $Computers = Get-Content $ComputerPath

    ForEach ($Computer in $Computers)

    {

    Get-WmiObject -Class Win32_Logicaldisk -ComputerName $Computer | 
    Select DeviceID,@{N='TotalSize (GB)';e={$_.Size / 1GB -as [INT]}},@{N='FreeSpace (GB)';e={$_.FreeSpace / 1GB -as [INT]}},SystemName |
    Export-Csv $OutPath -Append -NoTypeInformation 

    }

}