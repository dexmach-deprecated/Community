#How to onboard a non-azure VM (onprem, AWS, ...)
#region pre-reqs
$LCMPath = $pwd
$AwsComputerName = '52.33.166.253'
$AutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName 'technet2016' -Name 'OMSOnboarding'

#endregion

#region generate the Configuration for onboarding
$MetaParameters = @{
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    ResourceGroupName = $AutomationAccount.ResourceGroupName
    ComputerName = $AwsComputerName
    OutputFolder = $LCMPath
}

Get-AzureRmAutomationDscOnboardingMetaconfig @MetaParameters -Force
#let's check the contents
ise ('.\DscMetaConfigs\{0}.meta.mof' -f $AwsComputerName)
#endregion

#region onboard AWS
$SessionParameters = @{
    ComputerName = $AwsComputerName
    Credential = $Credential
}
$Session = New-PSSession @SessionParameters
Copy-Item -Path $LCM -ToSession $Session -Destination $destionation

Enter-PSSession -Session $Session

Set-DscLocalConfigurationManager -Path $Destination -Force -Verbose
#endregion

#region Alternative
#https://azure.microsoft.com/en-us/documentation/articles/automation-dsc-onboarding/#physicalvirtual-windows-machines-on-premises-or-in-a-cloud-other-than-azure
# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs { 
    param ( 
        [Parameter(Mandatory=$True)] 
        [String]$RegistrationUrl,
        [Parameter(Mandatory=$True)] 
        [String]$RegistrationKey,
        [Parameter(Mandatory=$True)] 
        [String[]]$ComputerName,
        [Int]$RefreshFrequencyMins = 30, 
        [Int]$ConfigurationModeFrequencyMins = 15, 
        [String]$ConfigurationMode = "ApplyAndMonitor", 
        [String]$NodeConfigurationName,
        [Boolean]$RebootNodeIfNeeded= $False,
        [String]$ActionAfterReboot = "ContinueConfiguration",
        [Boolean]$AllowModuleOverwrite = $False,
        [Boolean]$ReportOnly
    )

    if(!$NodeConfigurationName -or $NodeConfigurationName -eq "") { 
        $ConfigurationNames = $null 
    } 
    else { 
        $ConfigurationNames = @($NodeConfigurationName) 
    }
    if($ReportOnly) {
       $RefreshMode = "PUSH"
    }
    else {
       $RefreshMode = "PULL"
    }
    Node $ComputerName {
        Settings { 
            RefreshFrequencyMins = $RefreshFrequencyMins 
            RefreshMode = $RefreshMode 
            ConfigurationMode = $ConfigurationMode 
            AllowModuleOverwrite  = $AllowModuleOverwrite 
            RebootNodeIfNeeded = $RebootNodeIfNeeded 
            ActionAfterReboot = $ActionAfterReboot 
            ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins 
        }
        if(!$ReportOnly) {
           ConfigurationRepositoryWeb AzureAutomationDSC { 
                ServerUrl = $RegistrationUrl 
                RegistrationKey = $RegistrationKey 
                ConfigurationNames = $ConfigurationNames 
            }
            ResourceRepositoryWeb AzureAutomationDSC { 
               ServerUrl = $RegistrationUrl 
               RegistrationKey = $RegistrationKey 
            }
        }
        ReportServerWeb AzureAutomationDSC { 
            ServerUrl = $RegistrationUrl 
            RegistrationKey = $RegistrationKey 
        }
    } 
}

# Create the metaconfigurations
$RegistrationParameters = @{
    AutomationAccountName = $AutomationAccount.AutomationAccountName
    ResourceGroupName = $AutomationAccount.ResourceGroupName
}
$Info = Get-AzureRmAutomationRegistrationInfo @RegistrationParameters

$Params = @{
     RegistrationUrl = $Info.Endpoint
     RegistrationKey = $Info.PrimaryKey
     ComputerName = $AwsComputerName
     NodeConfigurationName = 'OMSOnboarding.MMA';
     RefreshFrequencyMins = 30;
     ConfigurationModeFrequencyMins = 15;
     RebootNodeIfNeeded = $True;
     AllowModuleOverwrite = $False;
     ConfigurationMode = 'ApplyAndMonitor';
     ActionAfterReboot = 'ContinueConfiguration';
     ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
}

# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params

#endregion