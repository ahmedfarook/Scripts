$Path = Read-Host "Please Enter the Path For .txt File For Which Data need to be extracted"

$Output = Read-Host "Please Enter CSV file Path for So the result can be printed"

$ComputerName = Get-content $path

foreach ($computer in $ComputerName) 
{
Get-ADComputer -Identity $computer -Properties operatingSystem, operatingSystemServicepack |select -Property Name,OperatingSystem,operatingsystemservicepack | Export-Csv -Path $Output
}