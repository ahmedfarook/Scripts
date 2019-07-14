
$FolderPath = Read-Host "Please enter the Folder Path"

$Folder = Get-item $FolderPath

$FolderSize = $folder.FullName

$SizeMB= (Get-childItem $folder -Recurse| Measure-Object  -Sum Length).Sum / 1mb -as [INT]

 New-Object -TypeName Psobject -Property @{
 
                                            DirectoryName = $folder
                                            SizeMB = $SizeMB
                                            ModfiedDate = $folder.lastwritetime
                                            
                                          }