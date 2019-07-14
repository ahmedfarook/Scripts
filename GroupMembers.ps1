Param
(
$Group = ""
)
$Path = Read-Host "Please provide the path for text file Where Users are Present"
$FilePath = Get-Content $Path
(Get-ADGroup -identity $group).distinguishedname | Add-ADGroupMember -Members $FilePath -Verbose