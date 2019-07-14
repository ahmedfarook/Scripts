$server = "EMEAMAI-NA10"
    
Foreach ($s in $server)

{

    $inst = (Get-Service -Name MSSQL$* -ComputerName $s).name -replace 'MSSQL\$'

    foreach ($i in $inst)
        
        {
        
        
        $p = ((reg query "\\$s\HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\instance names\sql" -v $i) -replace "    $i    REG_SZ    ")[2]
        
        $edition =    ((reg query "\\$s\HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup" -v Edition) -replace "    Edition    REG_SZ    ")[2]
        $version = ((reg query "\\$s\HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup" -v version) -replace "    version    REG_SZ    ")[2]
        
        New-Object psobject -Property @{

                                       ServerName = $s
                                       InstanceName = $i
                                       Edition = $edition
                                       Version = $version
        
                                       }
        }
         

    
}