$disk = Import-Csv C:\TEMP\export.csv

Foreach ($d in $Disk)



{
  
     $n= $d.number
     $drive= $d.Diskname
  
     Add-PartitionAccessPath -DiskNumber $n -PartitionNumber "2" -AccessPath "F:\ExchangeDatabases\$drive"

}
