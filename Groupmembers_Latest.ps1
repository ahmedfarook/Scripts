
#$OU_Path = "OU=AOEP,OU=AO,OU=EMEA,DC=main,DC=glb,DC=corp,DC=local"
$OU= Read-Host Please Enter the OU Name for Example FRTE or FRHDGRP or the OU for which you require the Group Extract.
$group = (Get-Adgroup -filter * -searchscope Subtree -SearchBase $OU).samaccountname

Foreach ($groupname in $group) 
    {

     Write-Host $groupname -ForegroundColor Red 
    (Get-ADGroupMember $groupname).distinguishedname

    }

