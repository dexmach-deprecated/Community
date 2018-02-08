#Get-iAzureResourceCards
    param(
         $Credential
        ,$ApiVersion = '2015-06-01-preview'
        ,$OfferDurableId = 'MS-AZR-0111p' #https://azure.microsoft.com/en-us/support/legal/offer-details/
        ,$Currency = 'EUR'
        ,$Locale = 'en-us'
        ,$RegionInfo = 'BE'
        ,$AzureTenantId = 'f28deca3-a66e-4902-8d52-7fef383a25d7'
        ,$SubscriptionId = 'a027c53d-0359-4edf-a3eb-9d5c429cbc95'
    )
    # Authentication
    $AuthenticationCreds = New-object Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential($Credential.Username,$Credential.GetNetworkCredential().Password)
 
    $AuthenticationUri = 'https://login.windows.net/{0}' -f $AzureTenantId
    $authenticationContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($AuthenticationUri,$false)
 
    $resource = 'https://management.core.windows.net/'
    $authenticationResult = $authenticationContext.AcquireToken($resource, $AuthenticationCreds)
 
    $ResHeaders = @{'authorization' = $authenticationResult.CreateAuthorizationHeader()}

    $ResourceCard = "https://management.azure.com/subscriptions/{5}/providers/Microsoft.Commerce/RateCard?api-version={0}&`$filter=OfferDurableId eq '{1}' and Currency eq '{2}' and Locale eq '{3}' and RegionInfo eq '{4}'" -f $ApiVersion, $OfferDurableId, $Currency, $Locale, $RegionInfo, $SubscriptionId

    $resources = Invoke-RestMethod -Uri $ResourceCard -Headers $ResHeaders -ContentType 'application/json' 
    $data = $Resources.Meters | Select-Object `
                            MeterId `
                            ,MeterName `
                            ,MeterCategory `
                            ,MeterSubCategory `
                            ,Unit `
                            ,MeterTags `
                            ,MeterRegion `
                            ,@{n='MeterRates';e={$_.MeterRates.0}} `
                            ,EffectiveDate `
                            ,IncludedQuantity `
                            ,@{n='Currency'; e={$Currency}}
    $data
    
    $ClientID = '54763718-b7b2-4798-8929-037d42e9600f'



 
