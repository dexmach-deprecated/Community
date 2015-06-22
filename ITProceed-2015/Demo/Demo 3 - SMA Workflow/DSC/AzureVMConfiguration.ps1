Configuration BaseServer {
  
    Import-DscResource -ModuleName InovativResources
    
    #demonstrate composite resources
    Inovativ_BaseServer BaseConfig {
        TimeZone = 'Romance Standard Time'

    }
}

Configuration FileServer {
    
    Import-DscResource -ModuleName InovativResources

    Inovativ_BaseServer BaseConfig {
        TimeZone = 'Romance Standard Time'
    }

    WindowsFeature Fileserverfeature {
        ensure = 'present'
        Name = 'FS-FileServer'
    }

    WindowsFeature DFSfeature {
        ensure = 'present'
        Name = 'FS-DFS-Namespace'
    }
}

Configuration WebServer {
    
    Import-DscResource -Module xWebAdministration, xSystemSecurity, InovativResources

    Inovativ_BaseServer BaseConfig {
        TimeZone = 'Romance Standard Time'
    }

    # Install the IIS role  
    WindowsFeature IIS  
    {  
        Ensure          = "Present"  
        Name            = "Web-Server"
    }  
  
    # Install the ASP .NET 4.5 role  
    WindowsFeature AspNet45  
    {  
        Ensure          = "Present"  
        Name            = "Web-Asp-Net45"
    }  
  
    # Stop the default website  
    xWebsite DefaultSite   
    {  
        Ensure          = "Present"  
        Name            = "Default Web Site"  
        State           = "Stopped"  
        PhysicalPath    = "C:\inetpub\wwwroot"  
        DependsOn       = "[WindowsFeature]IIS"
    }  

}

Configuration SMARunbookServer {

    Import-DscResource -Module xWebAdministration, xSystemSecurity, InovativResources

    Inovativ_BaseServer BaseConfig {

        TimeZone = 'Romance Standard Time'

    }
}

Configuration SCSMMgmtServer {

    Import-DscResource -Module xWebAdministration, xSystemSecurity, InovativResources

    Inovativ_BaseServer BaseConfig {
        TimeZone = 'Romance Standard Time'

    }
}

