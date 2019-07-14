$Subfolders= (get-childitem c:\users).fullname

Foreach ($sub in $Subfolders) 

{


(get-acl -Path $sub).access | select @{n='Path';e={$Sub}},IdentityReference,FileSystemRights


}