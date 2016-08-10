$AutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName 'technet2016' -Name 'OMSOnboarding'

$ConfigurationParameters = @{
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    SourcePath = '.\1_aOMSOnboarding.ps1'
}
Import-AzureRmAutomationDscConfiguration @ConfigurationParameters -Published -Force

#We are only passing the name of the automation credential not a psccredential object
$CompilationParameters = @{
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    ConfigurationName = 'OMSOnboarding'
    Parameters = @{
        $WorkspaceID = '39190147-de2a-4e01-9c63-5cff388047d8'
        $WorkspaceKey = '/WLYjvL61dOMkgj5pyqH88PIv/rDLqcB9jeTr4AazqcqX+eUJOl7cx7CXOERNedqFPB23rT2/fLpAh1priKNeQ=='
    }
}

Start-AzureRmAutomationDscCompilationJob @CompilationParameters
