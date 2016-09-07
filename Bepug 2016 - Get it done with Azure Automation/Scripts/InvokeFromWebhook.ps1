break

$uri = "<WEBHOOKURI>"
$headers = @{"From"="Belgium PowerShell user group"}

$vms  = @(
            @{ Name="Member01";ResourceGroupName="bepug-rg-automation"},
            @{ Name="Member02";ResourceGroupName="bepug-rg-automation"}
        )
$body = ConvertTo-Json -InputObject $vms 

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
$response
