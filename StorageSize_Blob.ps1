
#=============================================================================#
#                 1st Step For Authentication                                 
#=============================================================================#

    $token = (Get-AzAccessToken).token
    $header = @{
        'Authorization' = "Bearer $($token)"
        "Content-Type" = "application/json"
    }


#=============================================================================#
#                2nd Step is to find the number of storage Accounts                              
#=============================================================================#
 
  $subscription = Get-AzSubscription

 foreach ($sub in $subscription) 
 {
 
 $StorageusageURL =  "https://management.azure.com/subscriptions/$($sub.id)/providers/Microsoft.Storage/storageAccounts?api-version=2022-09-01"

    $StorageData = Invoke-RestMethod `
        -Method get `
        -Uri $StorageusageURL `
        -ContentType application/json `
        -Headers $header 

 
#=============================================================================#
#                3rd Step is to find the storage Gb                              
#=============================================================================#

    foreach ($Sd in $StorageData.value)
    {
        
        $rg = ($sd.id -split "/")[4]
        $sn = $sd.name

            $usageURL =  "https://management.azure.com/subscriptions/$($sub.id)/resourceGroups/$rg/providers/Microsoft.Storage/storageAccounts/$sn/blobServices/default/providers/Microsoft.Insights/metrics?aggregation=Average,count&top=3&orderby=Average asc&$filter=BlobType eq '*'&api-version=2018-01-01&metricnamespace=Microsoft.Storage/storageAccounts/blobServices"

            $UsageData = Invoke-RestMethod `
            -Method get `
            -Uri $usageURL `
            -ContentType application/json `
            -Headers $header 

           

       
       New-Object -TypeName psobject -Property @{
                                                    
                                                    StorageName = $sn
                                                    SubcriptionName = $sub.Name
                                                    RG = $rg
                                                    Sku = $sd.sku.name
                                                    Location = $sd.location
                                                    CapacityTB = [Math]::Round($UsageData.value.timeseries.data.average /1TB,1)
                                                    CapacityGB = [Math]::Round($UsageData.value.timeseries.data.average /1GB,1)
                                                    ResourceId = $sd.id
                                                }   | Select StorageName,SubcriptionName,Rg,Sku,Location,CapacityTB,CapacityGB,ResourceID |
                                                    Export-csv "D:\Reports\Storage\Storage_BlobSize_Apr_24.csv" -Append -NoTypeInformation

    }

}
#==============================================================================================================================================#
#                                                            Script End                            
#==============================================================================================================================================#