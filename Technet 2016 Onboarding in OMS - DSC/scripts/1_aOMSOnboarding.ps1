configuration OMSOnboadring {

    Import-DscResource -ModuleName PSdesiredStateConfiguration
    Import-DscResource -ModuleName xPSdesiredStateConfiguration

    File Tempfolder {
        Ensure= 'Present'
        DestinationPath = $path
        Type ='Directory'
    }

    xRemoteFile MMAgentUri {
        Uri = ''
        DestinationPath = ''
        UserAgent = ''
        MatchSource = $false
        DependsOn = '[File]Templfolder'
    }



}