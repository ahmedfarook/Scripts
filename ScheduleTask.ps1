
$Server = Get-Content C:\Temp\ServerTreso.txt 



Foreach ($s in $Server) 

    {

    $Task = (Schtasks.exe /query /fo list /s $s | Select-String "TaskName") -replace 'TaskName:      '

    $Task | select  @{name="Schedule_Task_Name";e={$_}},@{name="ServerName";e={$s}} | 
    ? {$_.Schedule_Task_Name -notlike "*Microsoft*"} | 
    Export-Csv C:\Temp\Task.csv -Append -NoTypeInformation

    }