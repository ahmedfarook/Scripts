$Group = Get-Content C:\temp\RITM0388037\groupsname.txt

foreach ($g in $Group) {


    Get-ADGroupMember $g | Select @{n="GroupName";e={$g}},@{n="GroupMembers";e={$_.name}},@{n="GroupMembers_LoginID";e={$_.SamAccountname}} |
    Export-Csv C:\temp\RITM0388037\GroupExport.Csv -Append -NoTypeInformation


}