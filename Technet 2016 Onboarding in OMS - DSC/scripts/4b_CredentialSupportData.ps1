#more info on DSC and credentials: https://blogs.technet.microsoft.com/ashleymcglone/2015/12/18/using-credentials-with-psdscallowplaintextpassword-and-psdscallowdomainuser-in-powershell-dsc-configuration-data/
 @{
    AllNodes = @(
        @{
            NodeName = 'SetHelloOMSRegistry'
            PSDscAllowPlainTextPassword = $True
            #PSDscAllowDomainUser = $true
        }
    )
}