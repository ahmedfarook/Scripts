$folder = (Get-ChildItem c:\).Name

foreach ($f in $folder) 

{

takeown.exe /F .\$f /A

}