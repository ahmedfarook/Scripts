$UserMessage = Read-Host "Please provide the path for text file Where Users are Present"
$FilePath = Get-Content $UserMessage
Foreach ($User in $FilePath)
{
Set-ADUser $User -HomeDrive U -HomeDirectory \\DC1\UserProfile\$user
}