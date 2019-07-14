 $header= @"
    <style type=""text/css"">
    body {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
    #report { width: 835px; }
    table{border-collapse: collapse;border: none;
        font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
        color: black; margin-bottom: 10px;}
    table td{ font-size: 12px; padding-left: 0px; padding-right: 20px; text-align: left;}
    table th{ font-size: 12px; font-weight: bold; padding-left: 0px; padding-right: 20px; text-align: left;}
    h2{ clear: both; font-size: 130%;color:#354B5E; }
    h3{ clear: both; font-size: 75%; margin-left: 20px; margin-top: 30px; color:#475F77; }
    p{ margin-left: 20px; font-size: 12px; }
    table.list{ float: left; }
	table.list td:nth-child(1){font-weight: bold;border-right: 1px grey solid;text-align: right;}
    table.list td:nth-child(2){ padding-left: 7px; }
    table tr:nth-child(even) td:nth-child(even){ background: #BBBBBB; }
    table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
    table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
    table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
	div.column { width: 320px; float: left; }
    div.first{ padding-right: 20px; border-right: 1px grey solid; }
    div.second{ margin-left: 30px; }
    table{ margin-left: 20px; }
	</style>
"@;

get-service | select -Property name,status |ConvertTo-Html  -Head $header| Out-File ie.html