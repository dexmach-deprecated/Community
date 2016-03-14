$uri = "<YOURWEBHOOKURL>"
$headers = @{"From"="Stijn.Callebaut"}

$vms  = @(
            @{ Name="Member01";ResourceGroupName="technet2016"},
            @{ Name="Member02";ResourceGroupName="technet2016"}
        )
$body = ConvertTo-Json -InputObject $vms 

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
$response
