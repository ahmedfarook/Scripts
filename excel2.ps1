$excel = New-Object -ComObject excel.application
$excel.visible = $True
$workbook = $excel.Workbooks.Open("C:\C\MAINOSVG01-DW01_Domain_Controllers_Acceptance_ORA_Check_V_0 1.xlsx")
$AcceptSheet = $workbook.Worksheets.Item(1)
$row = 3
$column = 5
$AcceptSheet.Cells.Item($row,$column) = "Vision Server 2012 R2 Std-x64-02.03"
