$username = Get-content C:\temp\user.txt

Foreach ($user in $username) 
{
        $ExpirationDate= Get-aduser -identity $user -Properties Accountexpirationdate | select -Property AccountExpirationDate

        Set-ADAccountExpiration -identity A$user -DateTime $ExpirationDate.AccountExpirationDate


}









