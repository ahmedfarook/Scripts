$user = Get-Content C:\Temp\ADuser_.txt

Foreach ($u in $user) 

    {
        Get-ADUser -Identity $u -Properties enabled | select name,samaccountname,enabled | Export-Csv C:\Temp\users_status.csv -NoTypeInformation -Append
    }