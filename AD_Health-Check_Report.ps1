# name this file dc_health_report.ps1
Import-Module ActiveDirectory
Function DC-HealthHTML{


Remove-Item C:\Admin\Scripts\AD_Health\dcdiag_all_output.log
Remove-Item C:\Admin\Scripts\AD_Health\uptime.log
Remove-Item C:\Admin\Scripts\AD_Health\dcdiag.html


$AllResults=@()

$AllResults2=@()
$table2 = "<table width=100%>$data"
$a2 = "<html>"
$a2 = $a2 + "<head>"
$a2 = $a2 + "<style>"
$a2 = $a2 + "body{color:#717D7D;background-color:#F5BCA9;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a2 = $a2 + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a2 = $a2 + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a2 = $a2 + "th{font-weight:bold;background-color:#ADDFFF;}"
$a2 = $a2 + "</style>"

###################################################################


$table = "<table width=100%> $DomainResultsHTML $oo $anil"
$a = "<html>"
$a = $a + "<head>"
$a = $a + "<style>"
$a = $a + "body{color:#717D7D;background-color:#F5BCA9;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a = $a + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a = $a + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a = $a + "th{font-weight:bold;background-color:#ADDFFF;}"
$a = $a + "</style>"
##############################

$from = "ADreport@nokia.com"
$to = "imnokiawintel.in@capgemini.com"
$cc = "noimocl1.5-windowsvmware.in@capgemini.com"
$smtpserver = "10.50.32.200"
#############################

$CurrDate = Get-Date -Format "yyyy.MM.dd_HH.mm.ss"
$SubCurrDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#$OutputFile = "D:\scripts\ping-response\PS\Server_status_Output_"+$CurrDate+".htm"

$logfile = "C:\Admin\Scripts\AD_Health\dcdiag_all_output.log"
$uptimelog = "C:\Admin\Scripts\AD_Health\uptime.log"
#############################

import-module ActiveDirectory
$ADInfo2 = "nnok.nokia.com"
$ADinfo = Get-ADdomain -server $ADInfo2 
$Adforestinfo = get-adforest -server $ADInfo2
$allDCs = Get-ADDomainController -filter * -server "$ADInfo2" |foreach {$_.hostname}
$DomainMode2 = $adinfo.domainmode
$DomainMode = $DomainMode2 -replace "Windows", ""
$InfraMaster = $adinfo.infrastructuremaster
$DomainNamingMaster = $adforestinfo.domainnamingmaster
$PDCEmulator = $adinfo.pdcemulator
$RIDMaster = $adinfo.ridmaster
$SchemaMaster = $adforestinfo.schemamaster
$DomainResults = New-Object Object
$DomainResults | Add-Member -Type NoteProperty -Name "Mode" -Value $DomainMode
$DomainResults | Add-Member -Type NoteProperty -Name "InfraMaster" -Value $InfraMaster
$DomainResults | Add-Member -Type NoteProperty -Name "DomainNamingMaster" -Value $DomainNamingMaster
$DomainResults | Add-Member -Type NoteProperty -Name "PDCEmulator" -Value $PDCEmulator
$DomainResults | Add-Member -Type NoteProperty -Name "RIDMaster" -Value $RIDMaster
$DomainResults | Add-Member -Type NoteProperty -Name "SchemaMaster" -Value $SchemaMaster
$DomainResultsHTML = $DomainResults | ConvertTo-Html -head $style


function WMIDateStringToDate($Bootup) {   
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)   
}   



foreach ($item in $alldcs)

{
Write-Host "Processing $item for Dcdiag and Uptime ..... " -foregroundcolor magenta
$computers = Get-WMIObject -class Win32_OperatingSystem -computer $item   

    foreach ($system in $computers) {   
    
    if(-not $computers)
    {
    
    
    $uptime = "Server is not responding : !!!!!!!!!!!! : !!!!!!!!!!!! : !!!!!!!!!!!!"
    "$item : $uptime" >> $uptimelog 
     $TestStatus = "Failed"
     
    }
    else
   {
       
       $Cdisk = ([wmi]"\\$item\root\cimv2:Win32_logicalDisk.DeviceID='c:'") | ForEach-Object {[math]::truncate($_.freespace /1gb)}
       $Ddisk = ([wmi]"\\$item\root\cimv2:Win32_logicalDisk.DeviceID='D:'") | ForEach-Object {[math]::truncate($_.freespace /1gb)}
       $OSVersion = $system.caption -replace "Microsoft® Windows ", ""
       $Bootup = $system.LastBootUpTime   
       $LastBootUpTime = WMIDateStringToDate $bootup   
       $now = Get-Date 
       $Uptime = $now - $lastBootUpTime   
       $d = $Uptime.Days   
       $h = $Uptime.Hours   
       $m = $uptime.Minutes   
       $ms= $uptime.Milliseconds
	#$servicedetails = Get-WmiObject -Class Win32_Service -Filter "state = 'stopped' and startmode = 'auto'" | Select-Object name


#$Servicedetails = $null
#$Servicedetails = @(get-wmiobject -query "select Name from win32_service where startmode='Auto' and state='Stopped'" -computername $allDCs)
#$serv = $servicedetails.name
    "$item  : {0} days {1} hours, {2} GB, {3} GB, {4}" -f $d,$h,$Cdisk,$Ddisk,$osversion>> $uptimelog 
   
  
    }
  
   "">> $logfile
    
    }       

Dcdiag.exe /s:$item >> $logfile
#####################################################################


$Results = New-Object Object
$Results | Add-Member -Type NoteProperty -Name "ServerName" -Value $item
######################################################################


Get-Content "C:\Admin\Scripts\AD_Health\dcdiag_all_output.log" | %{
Switch -RegEx ($_)
{
 "Starting"      { $TestName   = ($_ -Replace ".*Starting test: ").Trim() }
 "passed|failed" { 
 if ($_ -Match $item.split(".")[0]){
 If ($_ -Match "passed") { 
 $TestStatus = "Passed" 
 } 

 Else 
 
 { 
 $TestStatus = "Failed" 
 } }}
}
If ($TestName -ne $Null -And $TestStatus -ne $Null)
{
 $Results | Add-Member -Name $("$TestName".Trim()) -Value $TestStatus -Type NoteProperty -force
 $TestName = $Null; $TestStatus = $Null
#####################################################33


}}


$AllResults += $results

}

# commented Enterprise tests : FSMOcheck, Intersite, FRSSysvol
#$table += "<tr><th>ServerName</th><th>Advertising</th><th>Connectivity</th><th>Replications</th><th>Services</th><th>NetLogons</th><th>FsmoCheck</th><th>MachineAccount</th><th>Systemlog</th><th>Intersite</th><th>NCSecDesc</th><th>kccevent</th><th>frssysvol</th><th>frsevent</th><th>ObjectsReplicated</th><th>RidManager</th></tr>"
$table += "<tr><th>ServerName</th><th>Advertising</th><th>Connectivity</th><th>Replications</th><th>Services</th><th>NetLogons</th><th>MachineAccount</th><th>Systemlog</th><th>NCSecDesc</th><th>kccevent</th><th>frsevent</th><th>ObjectsReplicated</th><th>RidManager</th></tr>"


foreach ($result in $AllResults)
{
$bg = $null
$link = "www.technet.com"
$linkadv = "www.a.com"
$linkrep = "www.a.com"
$linksrv = "www.a.com"
$linknet = "www.a.com"
$table += "<tr>"
$table += "<td bgcolor=""white"">$($Result.ServerName)</td>"

if ($result.Advertising -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Advertising)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Advertising)</td>"
}


if ($result.Connectivity -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Connectivity)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Connectivity)</td>"
}




if ($result.Replications -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Replications)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Replications)</td>"
}


if ($result.Services -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Services)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Services)</td>"
}


if ($result.NetLogons -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.NetLogons)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.NetLogons)</td>"
}
<#

if ($result.FsmoCheck -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.FsmoCheck)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.FsmoCheck)</td>"
}
#>

if ($result.MachineAccount -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.MachineAccount)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.MachineAccount)</td>"
}


if ($result.Systemlog -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Systemlog)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Systemlog)</td>"
}

<#
if ($result.Intersite -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.Intersite)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.Intersite)</td>"
}
#>

if ($result.NCSecDesc -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.NCSecDesc)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.NCSecDesc)</td>"
}


if ($result.kccevent -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.kccevent)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.kccevent)</td>"
}


<#
if ($result.frssysvol -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.frssysvol)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.frssysvol)</td>"
}
#>

if ($result.frsevent -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.frsevent)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.frsevent)</td>"
}


if ($result.ObjectsReplicated -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.ObjectsReplicated)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.ObjectsReplicated)</td>"
}



if ($result.RidManager -eq "Failed")
{
$bg="red"
$table += "<td bgcolor=""$bg""><a href=""$link"">$($Result.RidManager)</td>"
}
else
{
$bg="green"
$table += "<td bgcolor=""$bg"">$($Result.RidManager)</td>"
}



$table += "</tr>"
}




$table2 += "<tr><th>DC-Name</th><th>Uptime</th><th>C-DriveFreeSpace</th><th>D-DriveFreeSpace</th><th>OSVersion</th></tr>"

####################################################
$data = get-content C:\Admin\Scripts\AD_Health\uptime.log |  ?{$_ -match "(.*):(.*),(.*),(.*),(.*)"} | select @{n="DCName";e={$matches[1]}},@{n="UpTime";e={$matches[2]}},@{n="CFreeSpace";e={$matches[3]}},@{n="DFreeSpace";e={$matches[4]}},@{n="OSVersion";e={$matches[5]}}
$AllResults2 += $data

foreach ($res in $AllResults2)
{
$bg2 = $null
$link2 = "www.test.com"
$table2 += "<tr>"

if ($res.dcname -match "Server is not responding")
{
$bg2="red"
$table2 += "<td bgcolor=""$bg2"">$($res.dcname)</td>"
}
else
{
$bg2="green"
$table2 += "<td bgcolor=""$bg2"">$($res.dcname)</td>"
}

if ($res.dcname -match "Server is not responding")
{
$bg2="red"
$table2 += "<td bgcolor=""$bg2"">$($res.uptime)</td>"
}
else
{
$bg2="white"
$table2 += "<td bgcolor=""$bg2"">$($res.uptime)</td>"
}

if ($res.dcname -match "Server is not responding")
{
$bg2="red"
$table2 += "<td bgcolor=""$bg2"">$($res.cfreespace)</td>"
}
else
{
$bg2="white"
$table2 += "<td bgcolor=""$bg2"">$($res.cfreespace)</td>"
}

if ($res.dcname -match "Server is not responding")
{
$bg2="red"
$table2 += "<td bgcolor=""$bg2"">$($res.dfreespace)</td>"
}
else
{
$bg2="white"
$table2 += "<td bgcolor=""$bg2"">$($res.dfreespace)</td>"
}

if ($res.dcname -match "Server is not responding")
{
$bg2="red"
$table2 += "<td bgcolor=""$bg2"">$($res.osversion)</td>"
}
else
{
$bg2="white"
$table2 += "<td bgcolor=""$bg2"">$($res.osversion)</td>"
}

$table2 += "</tr>"
}

####################################################
$table3 = "<table width=100%> $oo <br>"
$a3 = "<html>"
$a3 = $a3 + "<head>"
$a3 = $a3 + "<style>"
$a3 = $a3 + "body{color:#717D7D;background-color:#F5F5F5;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a3 = $a3 + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a3 = $a3 + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a3 = $a3 + "th{font-weight:bold;background-color:#ADDFFF;}"
$a3 = $a3 + "</style>"
$AllResultspORT=@()

function Test-Port{   
[cmdletbinding(   
    DefaultParameterSetName = '',   
    ConfirmImpact = 'low'   
)]   
    Param(   
        [Parameter(   
            Mandatory = $True,   
            Position = 0,   
            ParameterSetName = '',   
            ValueFromPipeline = $True)]   
            [array]$computer,   
        [Parameter(   
            Position = 1,   
            Mandatory = $True,   
            ParameterSetName = '')]   
            [array]$port,   
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [int]$TCPtimeout=1000,   
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [int]$UDPtimeout=1000,              
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [switch]$TCP,   
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [switch]$UDP                                     
        )   
    Begin {   
        If (!$tcp -AND !$udp) {$tcp = $True}   
        #Typically you never do this, but in this case I felt it was for the benefit of the function   
        #as any errors will be noted in the output of the report           
        $ErrorActionPreference = "SilentlyContinue"   
        $report = @()   
    }   
    Process {      
        ForEach ($c in $computer) {   
            ForEach ($p in $port) {   
                If ($tcp) {     
                    #Create temporary holder    
                    $temp = "" | Select Server, Port, TypePort, Open, Notes   
                    #Create object for connecting to port on computer   
                    $tcpobject = new-Object system.Net.Sockets.TcpClient   
                    #Connect to remote machine's port                 
                    $connect = $tcpobject.BeginConnect($c,$p,$null,$null)   
                    #Configure a timeout before quitting   
                    $wait = $connect.AsyncWaitHandle.WaitOne($TCPtimeout,$false)   
                    #If timeout   
                    If(!$wait) {   
                        #Close connection   
                        $tcpobject.Close()   
                        Write-Verbose "Connection Timeout"   
                        #Build report   
                        $temp.Server = $c   
                        $temp.Port = $p   
                        $temp.TypePort = "TCP"   
                        $temp.Open = "False"   
                        $temp.Notes = "Connection to Port Timed Out"   
                    } Else {   
                        $error.Clear()   
                        $tcpobject.EndConnect($connect) | out-Null   
                        #If error   
                        If($error[0]){   
                            #Begin making error more readable in report   
                            [string]$string = ($error[0].exception).message   
                            $message = (($string.split(":")[1]).replace('"',"")).TrimStart()   
                            $failed = $true   
                        }   
                        #Close connection       
                        $tcpobject.Close()   
                        #If unable to query port to due failure   
                        If($failed){   
                            #Build report   
                            $temp.Server = $c   
                            $temp.Port = $p   
                            $temp.TypePort = "TCP"   
                            $temp.Open = "False"   
                            $temp.Notes = "$message"   
                        } Else{   
                            #Build report   
                            $temp.Server = $c   
                            $temp.Port = $p   
                            $temp.TypePort = "TCP"   
                            $temp.Open = "True"     
                            $temp.Notes = ""   
                        }   
                    }      
                    #Reset failed value   
                    $failed = $Null       
                    #Merge temp array with report               
                    $report += $temp   
                }       
                If ($udp) {   
                    #Create temporary holder    
                    $temp = "" | Select Server, Port, TypePort, Open, Notes                                      
                    #Create object for connecting to port on computer   
                    $udpobject = new-Object system.Net.Sockets.Udpclient 
                    #Set a timeout on receiving message  
                    $udpobject.client.ReceiveTimeout = $UDPTimeout  
                    #Connect to remote machine's port                 
                    Write-Verbose "Making UDP connection to remote server"  
                    $udpobject.Connect("$c",$p)  
                    #Sends a message to the host to which you have connected.  
                    Write-Verbose "Sending message to remote host"  
                    $a = new-object system.text.asciiencoding  
                    $byte = $a.GetBytes("$(Get-Date)")  
                    [void]$udpobject.Send($byte,$byte.length)  
                    #IPEndPoint object will allow us to read datagrams sent from any source.   
                    Write-Verbose "Creating remote endpoint"  
                    $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)  
                    Try {  
                        #Blocks until a message returns on this socket from a remote host.  
                        Write-Verbose "Waiting for message return"  
                        $receivebytes = $udpobject.Receive([ref]$remoteendpoint)  
                        [string]$returndata = $a.GetString($receivebytes) 
                        If ($returndata) { 
                           Write-Verbose "Connection Successful"   
                            #Build report   
                            $temp.Server = $c   
                            $temp.Port = $p   
                            $temp.TypePort = "UDP"   
                            $temp.Open = "True"   
                            $temp.Notes = $returndata    
                            $udpobject.close()    
                        }                        
                    } Catch {  
                        If ($Error[0].ToString() -match "\bRespond after a period of time\b") {  
                            #Close connection   
                            $udpobject.Close()   
                            #Make sure that the host is online and not a false positive that it is open  
                            If (Test-Connection -comp $c -count 1 -quiet) {  
                                Write-Verbose "Connection Open"   
                                #Build report   
                                $temp.Server = $c   
                                $temp.Port = $p   
                                $temp.TypePort = "UDP"   
                                $temp.Open = "True"   
                                $temp.Notes = ""  
                            } Else {  
                                <#  
                                It is possible that the host is not online or that the host is online,   
                                but ICMP is blocked by a firewall and this port is actually open.  
                                #>  
                                Write-Verbose "Host maybe unavailable"   
                                #Build report   
                                $temp.Server = $c   
                                $temp.Port = $p   
                                $temp.TypePort = "UDP"   
                                $temp.Open = "False"   
                                $temp.Notes = "Unable to verify if port is open or if host is unavailable."                                  
                            }                          
                        } ElseIf ($Error[0].ToString() -match "forcibly closed by the remote host" ) {  
                            #Close connection   
                            $udpobject.Close()   
                            Write-Verbose "Connection Timeout"   
                            #Build report   
                            $temp.Server = $c   
                            $temp.Port = $p   
                            $temp.TypePort = "UDP"   
                            $temp.Open = "False"   
                            $temp.Notes = "Connection to Port Timed Out"                          
                        } Else {                       
                            $udpobject.close()  
                        }  
                    }      
                    #Merge temp array with report               
                    $report += $temp   
                }                                   
            }   
        }                   
    }   
    End {   
        #Generate Report   
        $report  
    } 
}
$table3 += "<tr><th>ServerName</th><th>LDAP389</th><th>LDAP3268</th><th>DNS53</th><th>TCP135</th><th>SMB445</th></tr>"
import-module ActiveDirectory
#$ADInfo2 = Read-Host "Enter the Domain Name to check"
#$ADinfo = Get-ADdomain -server $ADInfo2 
#$allDCs = Get-ADDomainController -filter * -server "$ADInfo2" |foreach {$_.hostname}

#$allDCs = @("BRMADNSRV12","BRMANTSRV01","DCHOST01","BRMBRSSRV12","BRMBYLSRV12")
foreach ($item in $alldcs)
{
$sonuc = test-port -comp $item -port 389 -tcp 
$ResultsPort = New-Object Object
$ResultsPort | Add-Member -Type NoteProperty -Name "ServerName" -Value $sonuc.server
$ResultsPort | Add-Member -Type NoteProperty -Name "LDAP389" -Value $sonuc.open

$sonuc2 = test-port -comp $item -port 3268 -tcp 
$ResultsPort2 = New-Object Object
$ResultsPort2 | Add-Member -Type NoteProperty -Name "LDAP3268" -Value $sonuc2.open

$sonuc3 = test-port -comp $item -port 53 -udp 
$ResultsPort3 = New-Object Object
$ResultsPort3 | Add-Member -Type NoteProperty -Name "DNS53" -Value $sonuc3.open

$sonuc4 = test-port -comp $item -port 135 -tcp 
$ResultsPort4 = New-Object Object
$ResultsPort4 | Add-Member -Type NoteProperty -Name "RPC135" -Value $sonuc4.open

$sonuc5 = test-port -comp $item -port 445 -tcp 
$ResultsPort5 = New-Object Object
$ResultsPort5 | Add-Member -Type NoteProperty -Name "SMB445" -Value $sonuc5.open

foreach ($result in $ResultsPort)
{
$bg = $null
$table3 += "<tr>"
$table3 += "<td bgcolor=""$bg"">$($result.ServerName)</td>"
if ($result.LDAP389 -eq "False"){$bg="red"}else{$bg="green"}
$table3 += "<td bgcolor=""$bg"">$($result.LDAP389)</td>"
if ($ResultsPort2.LDAP3268 -eq "False"){$bg="red"}else{$bg="green"}
$table3 += "<td bgcolor=""$bg"">$($ResultsPort2.LDAP3268)</td>"
if ($ResultsPort3.DNS53 -eq "False"){$bg="red"}else{$bg="green"}
$table3 += "<td bgcolor=""$bg"">$($ResultsPort3.DNS53)</td>"
if ($ResultsPort4.RPC135 -eq "False"){$bg="red"}else{$bg="green"}
$table3 += "<td bgcolor=""$bg"">$($ResultsPort4.RPC135)</td>"
if ($ResultsPort5.SMB445 -eq "False"){$bg="red"}else{$bg="green"}
$table3 += "<td bgcolor=""$bg"">$($ResultsPort5.SMB445)</td>"
$table3 += "</tr>"
}

}


###################################################################
$myRepInfo = @(repadmin /replsum * /bysrc /bydest /sort:delta /homeserver:$ADinfo2)
 
# Initialize our array.
$cleanRepInfo = @() 
   # Start @ #10 because all the previous lines are junk formatting
   # and strip off the last 4 lines because they are not needed.
    for ($i=10; $i -lt ($myRepInfo.Count-4); $i++) {
            if($myRepInfo[$i] -ne ""){
            # Remove empty lines from our array.
            $myRepInfo[$i] -replace '\s+', " "            
            $cleanRepInfo += $myRepInfo[$i]             
            }
            }            
$finalRepInfo = @()   
            foreach ($line in $cleanRepInfo) {
            $splitRepInfo = $line -split '\s+',8
            if ($splitRepInfo[0] -eq "Source") { $repType = "Source" }
            if ($splitRepInfo[0] -eq "Destination") { $repType = "Destination" }
            
            if ($splitRepInfo[1] -notmatch "DSA") {       
            # Create an Object and populate it with our values.
           $objRepValues = New-Object System.Object 
               $objRepValues | Add-Member -type NoteProperty -name DSAType -value $repType # Source or Destination DSA
               $objRepValues | Add-Member -type NoteProperty -name Hostname  -value $splitRepInfo[1] # Hostname
               $objRepValues | Add-Member -type NoteProperty -name Delta  -value $splitRepInfo[2] # Largest Delta
               $objRepValues | Add-Member -type NoteProperty -name Fails -value $splitRepInfo[3] # Failures
               #$objRepValues | Add-Member -type NoteProperty -name Slash  -value $splitRepInfo[4] # Slash char
               $objRepValues | Add-Member -type NoteProperty -name Total -value $splitRepInfo[5] # Totals
               $objRepValues | Add-Member -type NoteProperty -name PctError  -value $splitRepInfo[6] # % errors   
               $objRepValues | Add-Member -type NoteProperty -name ErrorMsg  -value $splitRepInfo[7] # Error code
           
            # Add the Object as a row to our array    
            $finalRepInfo += $objRepValues
            
            }
            }
$html = $finalRepInfo|ConvertTo-Html -Fragment        
            
$xml = [xml]$html
$attr = $xml.CreateAttribute("id")
$attr.Value='diskTbl'
$xml.table.Attributes.Append($attr)

$rows=$xml.table.selectNodes('//tr')
for($i=1;$i -lt $rows.count; $i++){
    $value=$rows.Item($i).LastChild.'#text'
    if($value -ne $null){
       $attr=$xml.CreateAttribute('style')
       $attr.Value='background-color: red;'
       [void]$rows.Item($i).Attributes.Append($attr)
    }
    
    else {
     $value
     $attr=$xml.CreateAttribute('style')
     $attr.Value='background-color: green;'
     [void]$rows.Item($i).Attributes.Append($attr)
    }
}
#embed a CSS stylesheet in the html header 
$html4=$xml.OuterXml

####################################################################################################################
$table6 = "<table width=100%>  $oo $anil"
$a6 = "<html>"
$a6 = $a6 + "<head>"
$a6 = $a6 + "<style>"
$a6 = $a6 + "body{color:#717D7D;background-color:#F5F5F5;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a6 = $a6 + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a6 = $a6 + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a6 = $a6 + "th{font-weight:bold;background-color:green;}"
$a6= $a6 + "</style>"
###################################################################################################################


$Timeresults=@()
#$ADInfo2 = "statoilfrtest.com"
#$ADinfo = Get-ADdomain -server $ADInfo2 
#$allDCs = Get-ADDomainController -filter * -server "$ADInfo2" |foreach {$_.hostname}


foreach ($item in $alldcs)

{
Write-Host "Processing $item for Time " -foregroundcolor magenta
$computers = Get-WMIObject -class Win32_OperatingSystem -computer $item |Select-Object CSName,@{Name="LocalDateTime";Expression={$_.ConvertToDateTime($_.LocalDateTime)}} 


#$tz = Get-WMIObject -class Win32_TimeZone -ComputerName $item |Select-Object $$tz.description,$tz.daylightname | write-host ("$item has its timezone set to " + $tz.description , + $tz.daylightname) 

$tz = Get-WMIObject -class Win32_TimeZone -ComputerName $item -ErrorAction Stop
write-host ("$item has its timezone set to " + $tz.description) 


$domaintimes = New-Object object
$domaintimes | add-member -type NoteProperty -Name "DCName" -Value $computers.csname
$domaintimes | add-member -type NoteProperty -Name "LocalDateTime" -Value $computers.LocalDateTime 
$domaintimes | add-member -type NoteProperty -NAme "TimeZone" -value $tz.description

$Timeresults +=$domaintimes
#$Timezone +=$tz
}  
$DomainTimeResultHTML = $Timeresults|ConvertTo-Html -Head $style
#$DomainTimeZoneHTML = $TimeZone|ConvertTo-Html -Head $style

###################################################################################################################

$table10 = "<table width=100%>"
$a10 = "<html>"
$a10 = $a10 + "<head>"
$a10 = $a10 + "<style>"
$a10 = $a10 + "body{color:#717D7D;background-color:#F5F5F5;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a10 = $a10 + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a10 = $a10 + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a10 = $a10 + "th{font-weight:bold;background-color:green;}"
$a10 = $a10 + "</style>"
###################################################################################################################
$table10 += "<tr><th>Server Name</th><th>Automatic Services in Stopped State</th></tr>"

$ServiceResults = @()
Foreach($comp in $alldcs)
{
	write-host "Checking Services for $comp"
	$Servicedetails = @(get-wmiobject -query "select Name, Caption, StartMode, State from win32_service where startmode='Auto' and state='Stopped'" -computername $comp)

#$servicedetails = Get-WmiObject -Class Win32_Service -Filter "state = 'stopped' and startmode = 'auto'" | Select-Object name

	$ServiceResults = New-Object PSObject -Property @{
	ServerName = $comp
	ServiceDetails = $Servicedetails }

	Foreach($Entry in $ServiceResults)
    	{
        $table10 += "<TR>"
	$table10 += "<TD>$($Entry.ServerName)</TD>
		<TD>"
		foreach ($e in $Entry.ServiceDetails)
			{
		$table10 += 	"$($e.caption)</br>"
			}
		$table10 += 			"</TD></TR>"
    	}


#$domainservc = New-Object object
#$domainservc | add-member -type NoteProperty -Name "Server" -Value $comp
#$domainservc | add-member -type NoteProperty -Name "Automatic Service in Stopped State" -Value $servicedetails
  
#$DCServcresults += $domainservc
}

#$DomainServicesResult = $DCServcresults|ConvertTo-Html -Head $style

#####################################################################################################################################
$table7 = "<table width=100%>   $oo $anil"
$a7 = "<html>"
$a7 = $a7 + "<head>"
$a7 = $a7 + "<style>"
$a7 = $a7 + "body{color:#717D7D;background-color:#F5F5F5;font-size:10pt;font-family:'trebuchet ms', helvetica, sans-serif;font-weight:normal;padding-:0px;margin:0px;overflow:auto;}"
$a7 = $a7 + "a{font-family:Tahoma;color:#717D7D;Font-Size:10pt display: block;}"
$a7 = $a7 + "table,td,th {font-family:Tahoma;color:Black;Font-Size:10pt}"
$a7 = $a7 + "th{font-weight:bold;background-color:green;}"
$a7= $a7 + "</style>"
####################################################################################################################################


<#$SEPresults = @()
ipmo C:\admin\Scripts\AD_Health\Get-SEPVersion.psm1

foreach ($item in $alldcs)
{
Write-Host "Checking $item for SEP Info ............" -foregroundcolor magenta

$SEPInfo = Get-SEPVersion -ComputerName  $item -ErrorAction silentlycontinue |Select-Object ComputerName,SEPProductVersion,SEPDefinitionDate 
$domainSEPinfo = New-Object object
$domainSEPinfo | add-member -type NoteProperty -Name "DCName" -Value $SEPInfo.ComputerName
$domainSEPinfo | add-member -type NoteProperty -Name "SEP Product Version" -Value $SEPInfo.SEPProductVersion 
$domainSEPinfo | add-member -type NoteProperty -Name "SEP Defination Date" -Value $SEPInfo.SEPDefinitionDate 

$SEPresults += $domainSEPinfo
}

$DomainSEPResultHTML = $SEPresults|ConvertTo-Html -Head $style
#>


###########################################################################################################################
#$temp = '<font size="4" color="blue">FSMO Role Holders</font>'
#$temp1 = '<br><font size="4" color="blue">Domain Controllers Port Check</font>'
#$temp2 = '<br><font size="4" color="blue">Writable Domain Controllers Replication Summary</font>'
#$temp3 = '<font size="4" color="blue">Domain Controllers Uptime Status</font>'
#$temp4 = '<font size="4" color="blue">Current Time on Domain Controllers</font>'
#$temp5 = '<font size="4" color="blue">Domain Controllers Diagnostics Overview</font>'
#$temp6 = '<font size="4" color="blue">Domain Controllers Symantec Enterprise Overview</font>'
#$temp7 = '<font size="4" color="blue">Domain Controllers Auto Services Check</font>'

$Head10 = $temp7 + $a10 + "<tablewidth=100%> $($DomainServicesResult)"
$HTML10 = $Head10 + $Table10 + "</table></html>"

$Head7 = $temp6 + $a7 + "<table width=100%> $($DomainSEPResultHTML) " 
$HTML7 = $Head7 + $Table7 + "</table></html>"


$Head6 = $temp4 + $a6 + "<table width=100%> $($DomainTimeResultHTML)"
$HTML6 = $Head6 + $Table6 + "</table></html>"


$Head = $temp2 + $a + "<table width=100%> $($oo) <br>" 
$HTML4 = $Head + $html4 +  "</table></html>"


$Head3 = $temp1 + $a3 + "<table width=100%> $($oo) <br>" 
$HTML3 = $Head3 + $Table3 + "</table></html>"

$Head2 = $temp3 + $a2 + "<table width=100%> $($data)" 
$HTML2 = $Head2 + $Table2 + "</table></html>"



$Head = $a + "<table width=100%> <table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">FSMO Role Holders</h4></b></center></td>$($DomainResultsHTML) 
<table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Environment Report</h4></b></center></td>$($html2) 
<table width=100%>  <table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Port Check</h4></b></center></td>$($html3)
<table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Replication Report</h4></b></center></td>$($html4)
<table width=100%>  <table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Local Time Check</h4></b></center></td>$($html6)
<table width=100%> <td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Automatic Service Check</h4></b></center></td>$($Html10)
<table width=100%><td bgcolor=""blue""><center><b><font color =""white"">Domain Controllers Diagnostics Report</h4></b></center></td>$($Html7)"

$HTML = $Head + $Table + "</table></html>"


$html | Out-File "C:\Admin\Scripts\AD_Health\dcdiag.html"


#################################
invoke-item -Path "C:\Admin\Scripts\AD_Health\dcdiag.html"
####MAIL
Send-MailMessage -From $from -To $to -Cc $cc -Subject "Nokia AD Domain Status Report :: $subCurrDate" -SmtpServer $smtpserver -Body "Nokia Domain Controllers Health Check Report as attachment" -Attachments "C:\Admin\Scripts\AD_Health\dcdiag.html"
#Send-MailMessage -From $from -To $to -Cc $cc -Subject "Nokia AD Domain Status Report :: $subCurrDate" -SmtpServer $smtpserver -BodyAsHtml ($html | Out-String)
#Send-MailMessage -From $from -To $to -Subject "SFR AD Domain Status Report :: $subCurrDate" -SmtpServer $smtpserver -BodyAsHtml ($html | Out-String)

#################################



###################################

<# start comment--------------end 

# Now get GPO Report for the Domain in question

$PDC = Get-ADDomainController -DomainName $ADInfo2 -Discover -Service "PrimaryDC" |foreach {$_.name}
Get-GPOReport -all -domain $ADInfo2 -Server $PDC -ReportType HTML -Path D:\Scripts\AD_Health\"$ADInfo2"GPOReportsAll.html

# now View in IE 
 
Invoke-Item D:\Scripts\AD_Health\"$ADInfo2"GPOReportsAll.html

----------------------- end comment #>
}
DC-HealthHTML;