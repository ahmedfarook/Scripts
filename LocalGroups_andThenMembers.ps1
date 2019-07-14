#$ServerPath = Get-Content $Path 
$ServerPath = Hostname
Foreach ($Server in $ServerPath)

    {

        #to find local groups
        $Localgroups= (Get-WMIObject win32_group -filter "LocalAccount='True'" -ComputerName $Server).Name
        #$Localgroups.trimend()
        

        #for finding each Group members using foreach
        foreach ($groupname in $Localgroups ) {


        $group =[ADSI]"WinNT://$server/$groupname" 
    
        $members = @($group.psbase.Invoke("Members"))

         
         Foreach ($m in $members)

            {
                New-Object psobject -Property @{
                        
                        GroupName = $Groupname
                        ComputerName = $Server
                        Members = $m.GetType().InvokeMember("Name", 'GetProperty', $null, $m, $null)

                                                } -ErrorAction SilentlyContinue
                    
            }
        
      }
     
     
 }