#Created BY P&G raining Institute

Function Get-ADNestedGroups 
{ #Function start

       [CmdletBindinG()]
       [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ObjectName
     )

    $Group = Get-ADPrincipalGroupMembership -Identity $ObjectName
    
    $Group1 = foreach ($g in $Group)
    {
        Get-ADPrincipalGroupMembership $g
    }
    
    $Group2 = foreach ($G in $group1)
    {
        Get-ADPrincipalGroupMembership $G
    }
    
    $Group3 = foreach ($G in $Group2)
    {
        Get-ADPrincipalGroupMembership $G
    }

    $Group4 = foreach ($G in $Group3)
    {
        Get-ADPrincipalGroupMembership $G
    }

    $Group
    $Group1
    $Group2
    $Group3
    $Group4


}

