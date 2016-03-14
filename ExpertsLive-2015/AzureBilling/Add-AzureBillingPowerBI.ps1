#region setup
$clientid = '671c1b4e-097a-4d1c-a050-c841c3871cab'
$AzureCredential = Get-Credential -username 'stijn.callebaut@inovativ.be' -message 'Azure cred'

$ServiceUri = 'https://billing.inovativ.be' # Unique Id of a Service Principal you must create
$ServicePassword = 'VaHFuqyCt6kqPvRrN1qqiQg3j5oK5eVo1a9jSggLGO4=' # The password of the Service Principal
$Password = ConvertTo-SecureString $ServicePassword -AsPlainText -Force

$BillingCred = [PSCredential]::new($ServiceUri,$Passwor)

#endregion
$Group = 'ExpertsLive'
	
#$token		
$authToken = Get-PBIAuthToken -clientid $clientid -Credential $AzureCredential -verbose

#Validate Group
$Group  = Get-PBIGroup -authToken $authToken -name 'ExpertsLive' -ErrorAction SilentlyContinue
Set-PBIGroup -authToken $authToken -name $Group.name

$dataSetSchema = Get-PBIDataSet -authToken $authToken -name "Azure billing" -Verbose
if( -Not $dataSetSchema){
    
    #Create a new schema
    $dataSetSchema = @{
         name = "Azure billing"
         tables = @(
            @{
             name = "ResourceConsumption"
	         columns = @( 
                    @{name = "UsageStartTime"; dataType = "DateTime"  }
		            @{name = "UsageEndTime"; dataType = "DateTime"  }
		            @{name='SubscriptionId'; dataType = 'String'},
                    @{name='MeterCategory'; dataType = 'String'}
                    @{name='MeterId'; dataType = 'String'},
                    @{name='MeterName'; dataType = 'String'},
                    @{name='MeterSubCategory'; dataType = 'String'},
                    @{name='MeterRegion'; dataType = 'String'},
                    @{name='Unit'; dataType = 'String'},
                    @{name='Quantity'; dataType = 'String'},
                    @{name='Project'; dataType = 'String'},
                    @{name='InstanceData'; dataType = 'String'}
		            )}
		    , 
		    @{
             name = "Pricelist"
	         columns = @( 
		            @{name='MeterId'; dataType='String'},
                    @{name='MeterName'; dataType = 'String'},
                    @{name='MeterCategory'; dataType = 'String'},
                    @{name='MeterSubCategory'; dataType = 'String'}
                    @{name='Unit'; dataType = 'String'},
                    @{name='MeterTags'; dataType = 'String'},
                    @{name='MeterRegion'; dataType = 'String'},
                    @{name='MeterRates'; dataType = 'String'},
                    @{name='EffectiveDate'; dataType = 'DateTime'},
                    @{name='IncludedQuantity'; dataType = 'String'},
                    @{name='Currency'; dataType = 'String'}			
		            )}
        )}
	$dataSetSchema = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -defaultRetentionPolicy "basicFIFO" -Verbose
}

#get the usage data
$DataUsage = .\Get-iAzureResourceUsageData.ps1 -credential $azureCredential

#Get the pricelist
$DataPrices = .\Get-iAzureResourceCards.ps1 -Credential $BillingCred

#for demo we clear the data
Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName 'ResourceConsumption' -Verbose
Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName 'Pricelist' -Verbose

$DataUsage | Add-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.id -tableName 'ResourceConsumption' -batchSize 1000 -Verbose


$DataPrices | Add-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.id -tableName 'Pricelist' -batchSize 1000 -Verbose
