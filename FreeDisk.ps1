$computerName= Read-Host "Enter The computer Name"

Get-ChildItem –Path  “\\$computerName\C$\Users” -Exclude admin*,All*,default*,public,S* | Where-Object{$_.LastWriteTime –lt (Get-Date).AddDays(-60)} | Remove-Item -force

Get-ChildItem –Path  “\\$computerName\C$\Windows\SysWOW64\CCM\Cache” | Where-Object{$_.LastWriteTime –lt (Get-Date).AddDays(-15)} | Remove-Item

Get-ChildItem –Path  “\\$computerName\C$\Temp” | Where-Object{$_.LastWriteTime –lt (Get-Date).AddDays(-30)} | Remove-Item

Get-ChildItem –Path  “\\$computerName\C$\Windows\Temp” -exclude Health* | Where-Object{$_.LastWriteTime –lt (Get-Date).AddDays(-10)} | Remove-Item

$GB = (1024 * 1024 * 1024)

$C_drive_Size = Get-WmiObject -Class win32_logicaldisk -Computername $computername| Select-Object -Property Size,deviceid,freespace| where {$_.deviceid -eq 'c:'}

($C_drive_Size.freespace / $C_drive_Size.Size)*100


