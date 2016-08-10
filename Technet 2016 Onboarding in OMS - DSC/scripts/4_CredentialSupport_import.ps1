#Add-azureRmAccount
$ConfigData = invoke-expression (get-content .\4b_CredentialSupportData.ps1 -Raw)
$AutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName 'technet2016' -Name 'OMSOnboarding'
$ConfigData

$ConfigurationParameters = @{
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    SourcePath = '.\4_CredentialSupport.ps1'
}
Import-AzureRmAutomationDscConfiguration @ConfigurationParameters -Published -Force

#We are only passing the name of the automation credential not a psccredential object
$CompilationParameters = @{
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    ConfigurationName = 'CredentialSupport'
    ConfigurationData = $ConfigData
    Parameters = @{
        Credential = 'LocalAdmin'
    }
}

$Job = Start-AzureRmAutomationDscCompilationJob @CompilationParameters

while (-not ($Job | Get-AzureRmAutomationDscCompilationJob).EndTime) {
    #We wait
    Start-Sleep -Seconds 5 
}

$NodeConfigurationParameters = @{
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    ConfigurationName = 'CredentialSupport'
}
Get-AzureRmAutomationDscNodeConfiguration @NodeConfigurationParameters