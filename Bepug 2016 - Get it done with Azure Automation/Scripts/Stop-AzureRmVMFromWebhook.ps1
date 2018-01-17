workflow Stop-AzureRmVMFromWebhook
{
    param ( 
        [object]$WebhookData
    )

    # If runbook was called from Webhook, WebhookData will not be null.
    if ($WebhookData -ne $null) {   

        # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

        # Collect individual headers. VMList converted from JSON.
        $From = $WebhookHeaders.From
        $VMList = ConvertFrom-Json -InputObject $WebhookBody
        Write-Output "Runbook started from webhook $WebhookName by $From."

        $AzureCredential = Get-AutomationPSCredential -Name 'BepugCredential'
        $AzureSubscriptionId = Get-AutomationVariable -Name 'BepugSubscriptionId'

        add-azureRmAccount -Credential $AzureCredential
        Select-AzureRmSubscription -SubscriptionId $AzureSubscriptionId

        # Start each virtual machine
        foreach ($VM in $VMList)
        {
            $VMName = $VM.Name
            Write-Output "Stopping $VMName"
            Stop-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force
        }
    }
    else {
        Write-Error "Runbook to be started only from webhook." 
    } 
}
add-azureRmAccount
