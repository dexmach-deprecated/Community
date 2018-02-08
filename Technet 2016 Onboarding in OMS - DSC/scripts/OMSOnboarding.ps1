Configuration OMSOnboarding {
    param (
        [string]$WorkspaceID,
        [string]$WorkspaceKey 
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    
    Node MMA {
        $Path = 'C:\temp'
        File TempFolder {
            Ensure = 'Present'
            DestinationPath = $Path
            Type = 'Directory'
        }
        
        $MMAAgentPath = '{0}\\MMASetup-AMD64.exe' -f $Path
        xRemoteFile MMAAgentUri {
            Uri = "https://opsinsight.blob.core.windows.net/publicfiles/MMASetup-AMD64.exe"
            DestinationPath = $MMAAgentPath
            UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
            Headers = @{"Accept-Language" = "en-US"}
            MatchSource = $false
            DependsOn = '[File]TempFolder'
        }
        
        $Arguments = '/Q /C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 AcceptEndUserLicenseAgreement=1 '
        $cmdline = '{0}OPINSIGHTS_WORKSPACE_ID={1} OPINSIGHTS_WORKSPACE_KEY={2}"' -f $Arguments, $WorkspaceID, $WorkspaceKey
        xPackage MMAAgent {
            Ensure = 'Present'
            Path = $MMAAgentPath
            Name = 'Microsoft Monitoring Agent'
            ProductId = 'E854571C-3C01-4128-99B8-52512F44E5E9'
            Arguments = $cmdline
            DependsOn = '[xRemoteFile]MMAAgentUri'
        }
        
        Service MMAService {
            Name = 'HealthService'
            State = 'Running'
            DependsOn = '[xPackage]MMAAgent'
        }
    }
}