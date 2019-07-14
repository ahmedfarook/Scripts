$server = Get-Content F:\server\host.txt

Foreach ($S in $server)

{

    $AdminGroup = [ADSI]"WinNT://$s/Administrators,group"
    $group = [ADSI]"WinNT://Main.glb.corp.local/DG-ITOP-SIRUS-LocalServersAdmins,group"
    $AdminGroup.Add($group.Path)

    if ($? -eq $false)

    {$s}

}