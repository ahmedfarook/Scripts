function GetGroups ($object)
{
    Get-ADPrincipalGroupMembership $object | ForEach `
    {
        $_
        Get-ADPrincipalGroupMembership $_
    }
}

$shivauser=Get-content C:\Temp\group.txt

foreach ($user in $shivauser)
{
   $user ; (GetGroups $user | select -Unique).count
}