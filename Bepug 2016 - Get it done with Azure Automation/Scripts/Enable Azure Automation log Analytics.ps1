#region pre 
Break

#endregion

$AA = Find-AzureRmResource -ResourceNameContains "bepug-aa" -ResourceType Microsoft.Automation/AutomationAccounts
$SA = Find-AzureRmResource -ResourceNameContains "bepugaaomsstorage" 
Set-AzureRmDiagnosticSetting -ResourceId $AA.ResourceId -StorageAccountId $SA.ResourceId -Enabled $true

break

Find-Script -Name Enable-AzureDiagnostics 

Install-Script -Name Enable-AzureDiagnostics -Force

Clear-Variable -Name parameters -Force -errorAction Ignore
$parameters = @{
    AutomationAccountName = 'bepug-aa'
    LogAnalyticsWorkspaceName = 'bepug-oms'

}
& 'C:\Program Files\WindowsPowerShell\Scripts\Enable-AzureDiagnostics.ps1' @parameters -Verbose
<#
1. login
2. create storage account for logs
3. Enable logs (joblogs and jobstreams
4. enable insights in OMS
#>

#verify

$omsStorageAccount = Get-AzureRmStorageAccount -ResourceGroupName 'bepug-rg-automation' -Name 'bepugaaomsstorage'
Get-AzureStorageContainer -Context $omsStorageAccount.Context

Get-AzureRmOperationalInsightsStorageInsight -ResourceGroupName "bepug-rg-automation"  -WorkspaceName "bepug-oms"

