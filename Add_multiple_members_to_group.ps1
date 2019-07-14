$FilePath = Get-Content C:\temp\user.txt

$Group1 = Get-ADgroup "LS_ManchesterStJohnsHouse-1401"
$Group2 = Get-ADgroup "LS_ManchesterStJohnsHouse-1243"
$Group3 = Get-ADgroup "LS_ManchesterStJohnsHouse-1100"
$Group4 = Get-ADgroup "LS_ManchesterStJohnsHouse-1159"
$Group5 = Get-ADgroup "LS_ManchesterStJohnsHous-1121"
$Group6 = Get-ADgroup "LS_ManchesterStJohnsHouse-1159"
$Group7 = Get-ADgroup "LS_ManchesterStJohnsHouse-1159"
$Group8 = Get-ADgroup "LS_ManchesterStJohnsHouse-1129"
$Group9 = Get-ADgroup "LS_WinchesterEastonLane-1153"
$Group10 = Get-ADgroup "LS_SuttonColdfieldKnightsHouse-1106"
$Group11 = Get-ADgroup "LS_SuttonColdfield-1121"
$Group12 = Get-ADgroup "LS_SuttonColdfieldKnightsHouse-2053"
$Group13 = Get-ADgroup "LS_SuttonColdfieldKnightsHouse-1456"
$Group14 = Get-ADgroup "LS_SuttonColdfield-1121"
$Group15 = Get-ADgroup "LS_SuttonColdfieldKnightsHouse-1106"
$Group16 = Get-ADgroup "LS_BournemouthTownHall"
$Group17 = Get-ADgroup "LS_BournemouthTownHall"
$Group18 = Get-ADgroup "LS_BournemouthTownHall"
$Group19 = Get-ADgroup "LS_BournemouthTownHall"
$Group20 = Get-ADgroup "LS_GlasgowLanarkCourt-1110"
$Group21 = Get-ADgroup "LS_Glasgow-1450"
$Group22 = Get-ADgroup "LS_GlasgowLanarkCourt-1420"
$Group23 = Get-ADgroup "LS_GlasgowLanarkCourt-1110"
$Group24 = Get-ADgroup "LS_GlasgowLanarkCourt-1120"
$Group25 = Get-ADgroup "LS_GlasgowLanarkCourt-1420"
$Group26 = Get-ADgroup "LS_HolywoodShorefieldHouse-1402"
$Group27 = Get-ADgroup "LS_HolywoodShorefieldHouse-1402"
$Group28 = Get-ADgroup "LS_HolywoodShorefieldHouse-1102"
$Group29 = Get-ADgroup "LS_Penrith-Skirsgill "
$Group30 = Get-ADgroup "LS_garstang"
$Group31 = Get-ADgroup "LS_OldhamBusinessCentre"
$Group32 = Get-ADgroup "LS_OldhamBusinessCentre"
$Group33 = Get-ADgroup "LS_OldhamBusinessCentre"
$Group34 = Get-ADgroup "LS_StokeGiffordParkmanHouse-1400"
$Group35 = Get-ADgroup "LS_StokeGiffordParkmanHouse-1121"
$Group36 = Get-ADgroup "LS_StokeGiffordParkmanHouse-1400"
$Group37 = Get-ADgroup "LS_StokeGiffordParkmanHouse-1400"
$Group38 = Get-ADgroup "LS_StokeGiffordParkmanHouse-1240"
$Group39 = Get-ADgroup "LS_ExeterAshHouse-1150"
$Group40 = Get-ADgroup "LS_ExeterClystWorks-1150"
$Group41 = Get-ADgroup "LS_ExeterSowtonDepot-1150"
$Group42 = Get-ADgroup "LS_ExeterSowtonDepot-1150"
$Group43 = Get-ADgroup "LS_Enfield-DesignCentre"
$Group44 = Get-ADgroup "LS_Enfield-DesignCentre"
$Group45 = Get-ADgroup "LS_StevenageMaxetHouse"
$Group46 = Get-ADgroup "LS_LondonTfLGreenwich-1152"
$Group47 = Get-ADgroup "LS_LondonBlackfriars-1401"
$Group48 = Get-ADgroup "LS_LondonBlackfriars-1401"
$Group49 = Get-ADgroup "LS_London209215BlackfriarsRoad-1232"
$Group50 = Get-ADgroup "LS_London209215BlackfriarsRoad-1232"
$Group51 = Get-ADgroup "LS_CambridgeMountPleasantHouse-1310"
$Group52 = Get-ADgroup "LS_Liverpool-1262"
$Group53 = Get-ADgroup "LS_Liverpool-2026"
$Group54 = Get-ADgroup "LS_Liverpool-2026"
$Group55 = Get-ADgroup "LS_LiverpoolCunardBuilding-1420"
$Group56 = Get-ADgroup "LS_Liverpool-1101"
$Group57 = Get-ADgroup "LS_LiverpoolCunardBuilding-2039"
$Group58 = Get-ADgroup "LS_HaywardsHeathPerrymountRoad-1428"
$Group59 = Get-ADgroup "LS_Maidstone-Kent"
$Group60 = Get-ADgroup "LS_Maidstone-Kent"
$Group61 = Get-ADgroup "LS_ShrewsburyHaughmondView-1213"
$Group62 = Get-ADgroup "LS_CroydonTFL-1152"
$Group63 = Get-ADgroup "LS_DerbyCanterburyHouse"
$Group64 = Get-ADgroup "LS_Liverpool-1400"
$Group65 = Get-ADgroup "LS_Liverpool-1400"


Foreach ($User in $FilePath)

{
$UserGRoup=(Get-ADUser -Identity $User -Properties *).memberof

if ($usergroup -like $Group1)
        
	{
        Set-ADUser $User -HomeDrive U -HomeDirectory \\CORMSFSMSJ03\USERS\$user -Verbose
        Add-ADGroupMember -Identity "MSJ03 - Users" -Members $User -Verbose
    }

elseif ($usergroup -like $Group2)
       
	{
        Set-ADUser $User -HomeDrive U -HomeDirectory \\CORMSFSMSJ03\USERS\$user
        Add-ADGroupMember -Identity "MSJ03 - Users" -Members $User

     }

elseif ($usergroup -like $Group3)
       
	{
        Set-ADUser $User -HomeDrive U -HomeDirectory \\CORMSFSMSJ03\USERS\$user -Verbose
        Add-ADGroupMember -Identity "MSJ03 - Users" -Members $User -Verbose
    }


elseif ($usergroup -like $Group4)
       
	{
        Set-ADUser $User -HomeDrive U -HomeDirectory \\JV1MSFSMSH01.v1.uk.venture.local\Users\$user -Verbose
        Add-ADGroupMember -Identity "MSHUsers" -Members $User -Verbose
    }

elseif ($usergroup -like $Group5)
       
	{
        Set-ADUser $User -HomeDrive U -HomeDirectory \\CORMSFSMSJ03\USERS\$user -Verbose
        Add-ADGroupMember -Identity "MSJ03 - Users" -Members $User -Verbose
    }
















 else {Write-host "$user does not exist in any group" -f White }

 
}