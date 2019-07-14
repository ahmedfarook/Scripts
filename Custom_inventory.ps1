
$server = Get-Content C:\Temp\RITM\Server.txt

Foreach ($c in $server) {
   
    Get-WmiObject win32_ComputerSystem -ComputerName $c | 
    Select Name,NumberOfProcessors,@{n="Memory(GB)";e={$_.totalPhysicalmemory / 1GB -as [int]}},@{n="OS";e={(Get-WmiObject win32_OPeratingSystem -ComputerName $C).caption}},Model,Manufacturer |
    Export-Csv C:\temp\RITM\ServerDetails.csv -Append -NoTypeInformation


     
}

    $Today = Get-Date
    $MailFrom = "ServerDetails@Total.com"
    $MailTo = "abdulkalam.khan@capgemini.com","ahmed.gaziyani@caogemini.com"
    $SMTPServer = "emeamaicli-el01.main.glb.corp.local"
    $MailSubject = "Server Details Executed on $Today"
    $Mailbody = "Please find the file Attached."
    $Attachment = "C:\temp\RITM\ServerDetails.csv"

    Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $Mailbody -BodyAsHTML -Attachments $Attachment  -SmtpServer $SMTPServer
