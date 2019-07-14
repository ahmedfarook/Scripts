
$Comp = "localhost" #Get-Content C:\temp\hostname.txt

foreach ($c in $Comp) 
    {

    $datetime = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $c).LastBootUpTime[0..7] -join ""
    $date = [datetime]::parseexact($datetime, 'yyyyMMdd', $null) 
    $todaydate= (get-date) 
    $days = ($todaydate - $date).Days

    New-Object PSobject -Property @{

    ComputerName= $C
    RebootDate= $date 
    RebootDays= $days
          

    } | select ComputerName,RebootDate,RebootDays

}
