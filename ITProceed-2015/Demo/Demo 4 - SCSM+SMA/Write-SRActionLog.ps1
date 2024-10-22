Workflow Write-SRActionLog {

    [cmdletbinding()]
    param(
        [parameter(mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$SRGuid,
        
        [parameter(mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Tile,
        
        [parameter(mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,
        
        [parameter(mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('UserName')]
        [String]$EnteredBy,
        
        [parameter(mandatory=$false)]
        [Boolean]$Private = $false
    )
    
    $SMServer = Get-SMAVariable -Name SMServer
    $SMCredentials = Get-SMACredential -name SMCredential
    
    inlinescript {
        $SR = get-scsmObject -Class System.WorkItem.ServiceRequest$ -id $SRGuid
        
        $LogGUID = ([guid]::NewGuid()).ToString()
        $Projection = @{__CLASS = "System.WorkItem.ServiceRequest";
                        __SEED = $SR;
                            ActionLogs = @{__CLASS = "System.WorkItem.TroubleTicket.$($CommentType)";
                                              __OBJECT = @{Id = $LogGUID;
                                                           DisplayName = $using:Title;
                                                           Comment = $using:Description;
                                                           EnteredBy  = $using:EnteredBy;
                                                           EnteredDate = (Get-Date).ToUniversalTime();
                                                           IsPrivate = $using:Private
                                                          }#END Object
                                             }#End Usercomments
                       }#End Projection
        New-SCSMObjectProjection -Type "System.WorkItem.ServiceRequestProjection" -Projection $Projection
    } -PSComputerName $SMServer -PSCredential $SMCredentials
    #END inlinescript

}#END Workflow