$Path = Read-Host "Please Enter the Path For .txt File For Which Data need to be extracted"

$Output = Read-Host "Please Enter CSV file Path for So the result can be printed"

$ComputerName = Get-content $path

foreach ($computer in $ComputerName)
{
Get-WmiObject -Class win32_operatingsystem -ComputerName $computer | select -Property Pscomputername,caption,csdversion
}