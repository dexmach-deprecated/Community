Configuration Inovativ_BaseServer {
    
    param (


        [ValidateScript({   $UnfilteredTimezones  = tzutil /l
                            $FilteredTimezone = $UnfilteredTimezones | where {$psitem -notlike '(*' -and $psitem -notlike ''}
                            $FilteredTimezone -contains $_})]
        [System.String]
        $Timezone

    )

    Import-DscResource -Module xNetworking
    Import-DSCResource -Module xSystemSecurity
    Import-DscResource -Module StackExchangeResources

   Registry EnableRemoteDesktop {
        Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server'
        ValueName = 'fDenyTSConnections'
        ValueData = '0'
        ValueType = 'DWord'
    }
    Registry DisbableServerManagerAtStartup {
        Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\SERVERMANAGER'
        ValueName = 'DoNotOpenServerManagerAtLogon'
        ValueData = '1'
        ValueType = 'DWord'
    }
    xUAC NeverNotifyAndDisableAll 
        { 
            Setting = "NeverNotifyAndDisableAll" 
        }
    xIEEsc DisableIEEsc 
        { 
            IsEnabled = $false 
            UserRole = "Users" 
        } 
  Timezone GMT1 {
        Name = $timezone
    }


  
  }