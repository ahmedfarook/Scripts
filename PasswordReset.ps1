$User = Read-Host "Please provide the path for text file Where Users are Present"
$FilePath = Get-Content $User
$Password = "P@sssw0rd"
foreach ($user in $FilePath)
{
(Get-ADUser -identity $User).distinguishedname | Set-ADAccountPassword -Reset -NewPassword ((ConvertTo-SecureString -AsPlainText "$Password" -Force)) ;
(Get-ADUser -identity $User).distinguishedname | Set-Aduser -ChangePasswordAtLogon $true
}