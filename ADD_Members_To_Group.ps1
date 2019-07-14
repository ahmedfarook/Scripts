$Path = Read-Host "Please provide the group name"
$Group = $Path
$Path = Read-Host "Please provide the path for text file Where Users are Present"
$FilePath = Get-Content $Path
Foreach ($User in $FilePath) {
(Get-ADGroup -identity $group).distinguishedname | Add-ADGroupMember -Members $user -Verbose
}