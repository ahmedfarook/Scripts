$PtrRecord = Get-Content C:\Temp\DnsRecord.txt
Foreach ($Ptr in $PtrRecord)
{
    Get-DnsServerResourceRecord -ComputerName 10.96.1.13 -ZoneName 60.10.in-addr.arpa. -RRType Ptr -Name $Ptr | Remove-DnsServerResourceRecord -ZoneName 60.10.in-addr.arpa. -ComputerName 10.96.1.13 -Force
  
}


