$computer = Read-Host "Please Enter The Computer Name"

$GB = (1024 * 1024 * 1024)

$C_drive_Size = Get-WmiObject -Class win32_logicaldisk -Computername $computer  | Select-Object -Property Size,deviceid,freespace| where {$_.deviceid -eq 'c:'}

($C_drive_Size.freespace / $C_drive_Size.Size)*100