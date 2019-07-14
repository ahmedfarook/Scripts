
#Function Get-LocalAdministratorsMembers ($Path)

#{

$ServerPath = Get-Content $Path 

Foreach ($Server in $ServerPath)

     {
        $group =[ADSI]"WinNT://$server/Administrators" 
    
        $members = @($group.psbase.Invoke("Members"))


         Foreach ($m in $members)

            {
         $m | Select  @{Name='Admins';e={$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}},
                     @{Name="Display Name";e=#expression defined below
                     { 
                     $m | 
                     Select  @{Name='Admins';e={$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}}| 	 Foreach {(get-aduser $_.admins).Name}}
                     },
                         @{Name="ServerName";e={$Server}}
            }

     }

 #}#