 
   $Group = "MF-MAIN-OptimisDataFinance","MF-MAIN-OptimisPremium"
    
   Foreach ($g in $group) 

   {
    
    (get-adgroup $g -Properties members).members |
    foreach {Get-aduser $_ -Properties *  | 
    Select DisplayName,Enabled,AccountExpirationDate,LastLogonDate,Created,Modified,@{n="GroupName";e={$G}} | 
    Export-csv -Path C:\temp\groupexport.csv -Append -NoTypeInformation}

   }