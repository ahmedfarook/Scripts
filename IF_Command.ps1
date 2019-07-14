$Service= Read-Host "Enter the Command which you would like to run"

Switch ("$Service")
         {
           Process {Get-Process}
           Childitem {Get-ChildItem}
           Service {Get-Service}
           Alias {Get-Alias}
           Command {Get-Command}
         } 

