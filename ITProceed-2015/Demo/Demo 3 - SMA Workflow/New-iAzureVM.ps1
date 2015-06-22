Workflow New-iAzureVM {
    param(
        [ValidateSet('ExtraSmall','Small')]
        [Alias('Size')]
        [string]$InstanceSize,
        [ValidateSet('FileServer','WebServer','SMARunbookServer','SCSMMgmtServer', 'BaseServer')]
        [string]$Flavor,
        [Alias('VMName')]
        [string]$ComputerName,
        [PSCredential]$Credential
    )

    #region settings
    $AzureConnection
    $storageKey = '<STORAGEACCOUNTKEY>'
    $StorageAccount = '<STORAGEACCOUNT>'
    $StorageContainer = '<DSCSTORAGECONTAINER'
    $domain = '<DOMAIN>'
    $Password = '<LOCALADMINPASSWORD>'
    $localAdmin = '<LOCALADMIN>'
    #endregion

    $Flavor  = $Flavor.ToUpper()
    $ComputerName = $ComputerName.ToUpper()

    Write-Verbose 'connecting to Azure'
    Add-AzureAccount -Credential $credential

    Write-Verbose 'Selecting the Enterprise subscription'
    Select-AzureSubscription -SubscriptionName <SUBSCRIPTIONNAME>

    Switch -CaseSensitive ($Flavor)
     {
        'FILESERVER' {
            Write-Verbose 'FileServer deployment choosen'
            $flavor = 'FileServer'

        }
        'WEBSERVER' {
            Write-Verbose 'WebServer'
            $flavor = 'WebServer deployment choosen'
        }
        'SMARUNBOOKWORKER' {
            Write-Verbose 'SMARunbookServer'
            $flavor = 'SMARunbookServer deployment choosen'
        }
        'SCSMMGMTSERVER' {
            Write-Verbose 'SCSMMgmtServer deployment choosen'
            $flavor = 'SCSMMgmtServer'
        }
        'BASESERVER' {
            Write-Verbose 'BaseServer deployment choosen'
            $Flavor = 'BaseServer'
        }
        default {
            Write-Verbose 'BaseServer deployment choosen'
            $Flavor = 'BaseServer'
        }
    
    }

    try {
    inlinescript {
        Write-Verbose 'Getting latest Windows 2012 R2 build'
        $image = (Get-AzureVMImage -Verbose:$false | 
                                    Where-Object {$_.label -like “Windows Server 2012 R2 Datacenter*”}| 
                                    Sort-Object –Descending PublishedDate)[0]
        Write-Verbose "Image '$($image.Imagename)' selected"

        Write-verbose "Getting the storagecontext for storageaccount $using:storageaccount"
        $storageContext = New-AzureStorageContext -StorageAccountName $using:storageaccount -StorageAccountKey $using:storageKey

        Write-Verbose "Building config for $using:ComputerName with size $using:InstanceSize and $($image.Label)"
        $VMConfig = New-AzureVMConfig -Name $using:ComputerName `
                                      -InstanceSize $using:InstanceSize `
                                      -ImageName $($image.ImageName) `
                                      -DiskLabel 'OS' |
                    Add-AzureProvisioningConfig -WindowsDomain `
                                                -AdminUsername $using:LocalAdmin `
                                                -Password $using:Password `
                                                -JoinDomain $using:domain `
                                                -Domain $(($using:domain).split('.')[0]) `
                                                -DomainPassword $using:password `
                                                -DomainUserName 'SCInstaller'  |
                    Set-AzureVMDscExtension -ConfigurationArchive AzureVMConfiguration.ps1.zip `
                                            -ConfigurationName $using:Flavor `
                                            -StorageContext $storageContext `
                                            -ContainerName $using:StorageContainer `
                                            -Force
                                                         
        Write-Verbose "Creating VM $using:ComputerName in service 'Inovativ'"

        New-AzureVM -ServiceName 'Inovativ' -VMs $VMConfig -WaitForBoot -Verbose
        Write-Verbose "$using:ComputerName created in Azure"
        }
    }
    catch{
        
        
    }
    
}




### EXAMPLE
#New-iAzureVM -InstanceSize Small -Flavor WebServer -ComputerName <VMNAME -Credential $cred -Verbose
