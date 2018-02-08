Configuration credentialsupport {
    param (
        [pscredential]$credential
    )
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    
    #instead of using a parameter we could also leverage Automation credentials
    #$Credential = Get-AutomationPSCredential -Name 'LocalAdmin'
    
    $contents = 'Hello from {0}' -f $credential.UserName
    
        xRegistry OMSReg {
            Ensure = 'Present'
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\OMSOnboarding"
            ValueName = "OMS"
            ValueData = "DSC Rocks"
           PsDscRunAsCredential = $credential
        }
       
}


