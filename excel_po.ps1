$excel = New-Object -ComObject excel.application

$excel.visible = $True

#this will add 3 sheet by default to excel
$workbook = $excel.Workbooks.Add()

#this will add extra sheet in to workbook
$workbook.Worksheets.add()

#this will show how many worksheet i have
$i=0;$workbook.Worksheets | %{$i++;[ordered]@{$_.name=$i}}

#this will prevent a popup while sheet deletion

$excel.DisplayAlerts = $False

#this will delete extra sheets

$workbook.Worksheets.Item(2).Delete()

#just putting the variable service to get identified
$service = $workbook.Worksheets.Item(1)

$service.Name = "disk space"

#adding heade to excel file
$service.Cells.Item(1,1) = "Name"
$service.Cells.Item(1,2) = "Status"
$service.Cells.Item(1,3) = "DisplayName"
$service.Cells.Item(1,4) = "MachineName"


#starting with Row No 2
$row = 2

$column = 1

Get-Service | foreach {
$service.Cells.Item($row,$column) = $_.Name
$column++
$service.Cells.Item($row,$column) = ($_.Status).tostring()
$column++
$service.Cells.Item($row,$column) = $_.DisplayName
$column++
$service.Cells.Item($row,$column) = $_.MachineName
$row++
$column = 1
}