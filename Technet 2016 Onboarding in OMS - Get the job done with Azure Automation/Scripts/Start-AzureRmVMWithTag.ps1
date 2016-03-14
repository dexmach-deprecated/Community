$AzureCredential = Get-AutomationPSCredential -Name 'OMSOnboardingCredential'
$AzureSubscriptionId = Get-AutomationVariable -Name 'OMSOnboardingSubscriptionId'

add-azureRmAccount -Credential $AzureCredential
Select-AzureRmSubscription -SubscriptionId $AzureSubscriptionId


$params = @{
    TagName = 'Schedule'
    TagValue = '9-5'
}
Write-Output -Message "Looking for resources with the tag 'schedule=9:5'"
$Resources = Find-AzureRmResource @params

Foreach ($resource in $Resources){

    if($Resources.ResourceType -eq 'Microsoft.Compute/virtualMachines') {
        Write-Output -Message "Evaluating status of Virtual Machine ($Resource.Name) in ($resource.ResourceGroupName)"

        $params = @{
            Name = $resource.Name
            ResourceGroupName = $resource.ResourceGroupName
        }
        $Vm = Get-AzureRmVM @params -Status

        $ProvisioningState = ($Vm | Select-Object -ExpandProperty Statuses).where({$_.code -match 'ProvisioningState'})
        $PowerState = ($Vm | Select-Object -ExpandProperty Statuses).where({$_.code -match 'PowerState'})

        #Check if VM is provisioned
        if($ProvisioningState.Code -eq 'ProvisioningState/succeeded') {

            #check if it is shutdown, no need to start it if it is already in a running state
            if($PowerState.Code -eq 'PowerState/stopped' -or $PowerState.Code -eq 'PowerState/deallocated' ) {

                Write-Output -Message "Starting ($Vm.Name) as it has a status of ($PowerState.DisplayStatus)"

                Start-azurermvm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName 
            }
            else {
                Write-Output -Message "($Vm.Name) is already in a running state, no action needed"
            }
        }
        else {
            Write-Output -Message "($Vm.Name) is not provisioned yet, no action taken"
        }
    }
}