#region pre-regs
$VerbosePreference = 'Continue'
    #credentials
$credential = Get-Credential -UserName stijn.callebaut@inovativ.be -Message 'Azure credential'

    #Authenticate
Add-AzureAccount -Credential $credential

    #switch to the arm module (by default the ASM module is loaded)
Switch-AzureMode -Name AzureResourceManager

<#if run for the first time, add the needed providers if not already present.

    ###DEFAULT
    PS C:\Users\StijnCallebaut> Get-AzureProvider | Select-Object -Property Providernamespace

    ProviderNamespace
    -----------------
    Microsoft.Automation
    Microsoft.Backup
    Microsoft.Batch
    microsoft.cache
    Microsoft.ClassicCompute
    microsoft.classicnetwork
    microsoft.classicstorage
    Microsoft.Compute                 <--
    microsoft.insights
    Microsoft.KeyVault
    Microsoft.MobileEngagement
    Microsoft.Network                 <--
    Microsoft.OperationalInsights
    Microsoft.SiteRecovery
    Microsoft.Sql
    Microsoft.Storage                 <--
    Microsoft.VisualStudio
    Microsoft.Web
    Sendgrid.Email
    successbricks.cleardb
    Microsoft.ADHybridHealthService
    Microsoft.Authorization
    Microsoft.Features
    Microsoft.Resources
    Microsoft.Scheduler

    ####REGISTER IF NOT PRESENT
    Register-AzureProvider -ProviderNamespace Microsoft.Compute
    Register-AzureProvider -ProviderNamespace Microsoft.Storage
    Register-AzureProvider -ProviderNamespace Microsoft.Network
#>

<#Select the subscription 
    use get-AzureSubcription to get all subscriptions
#>
Select-AzureSubscription -SubscriptionName 'Enterprise'
#endregion

#region parameters

<#Select the location
    use get-Azurelocation to get all Azure datacenter locations
    We are using the out-gridview cmdlet to have a more graphical representation
#>

Write-Verbose 'parameter section'

$location = ( Get-AzureLocation |
                where Name -eq "ResourceGroup" ).Locations | 
                Out-GridView `
                    -Title "Select a Region ..." `
                    -PassThru



$storageAccountName = 'scuweustordemo03'
$storageAccountType = 'Standard_LRS'

$vmName = "SCU-WEU-VM-VM1"
$vmSize = 'Standard_D1'
write-verbose 'local admin account and password'
$vmAdminCreds = Get-Credential -Message "Enter Local Admin credentials" -UserName 'sysadmin'

#endregion

#region variables
Write-Verbose 'variable section'
$tags = New-Object System.Collections.ArrayList
$tags.Add( @{ Name = "project"; Value = "SCU 2015 Europe" } )
$tags.Add( @{ Name = "Department"; Value = "Community" } )

$ResourceGroupName = "SCU-RG-DEMO03" #Environment - Location - type of resource - Name
$ResourceGroup = New-AzureResourceGroup -Name $ResourceGroupName -Location $location -Tag $tags

$vnetName = 'SCU-WEU-VNET-DEMO03'

$subnet1Prefix = "10.0.0.0/24"
$subnet1Name = "subnet-1"
$addressPrefix = "10.0.0.0/16"

$nicName = "vm1-nic1"

$imagePublisher = 'MicrosoftWindowsServer'
$imageOffer = 'WindowsServer'
$imageSku = '2012-R2-Datacenter'

$publicIPName = 'scuPublicIP'
$publicIPAddressType = 'Dynamic'

$dscArchiveName = "WebRole-configuration.zip"
$dscConfigFunction = "WebRole-configuration.ps1\SCUWebrole"
$dscConfig = ConvertTo-Json -Depth 8 `
@{

    SasToken = ''
    ModulesUrl = 'https://raw.githubusercontent.com/Inovativ/Community/master/System%20Center%20Universe%20EU%202015%20-%20Azure%20Resource%20Manager%20101/PowerShell/WebRole-configuration.zip'
    ConfigurationFunction = "$dscConfigFunction"

}

$VaultName = 'SCU2015Vault'
$vaultResourceGroupName = 'SCU2015Vault_RG'
$secretUrlWithVersion = 'https://scu2015vault.vault.azure.net:443/secrets/scu2015/748f7225c8a74a9091add09a6a95b99f'

#endregion

#region resources
Write-Verbose 'resources section'
$storageAccount = New-AzureStorageAccount `
                    -Name $storageAccountName `
                    -ResourceGroupName $ResourceGroupName `
                    -Location $location `
                    -Type $storageAccountType
                   
                  Set-AzureSubscription `
                    -SubscriptionName 'Enterprise' `
                    -CurrentStorageAccountName $storageAccountName

$publicIP = New-AzurePublicIpAddress `
                    -Name $publicIPName `
                    -ResourceGroupName $ResourceGroupName `
                    -Location $location `
                    -AllocationMethod $publicIPAddressType `
                    -Tag $tags

$subnet1 = New-AzureVirtualNetworkSubnetConfig `
                    -Name $subnet1Name `
                    -AddressPrefix $subnet1Prefix

$vnet = New-AzureVirtualNetwork `
                    -Name $vnetName `
                    -ResourceGroupName $ResourceGroupName `
                    -Location $location `
                    -AddressPrefix $addressPrefix `
                    -Subnet $subnet1 `
                    -Tag $tags

$nic= New-AzureNetworkInterface `
                    -Name $nicName `
                    -ResourceGroupName $ResourceGroupName `
                    -Location $location `
                    -SubnetId $vnet.Subnets[0].Id `
                    -PublicIpAddressId $publicIp.Id

$vmConfig = `
            New-AzureVMConfig `
                -VMName $vmName `
                -VMSize $vmSize |
            Set-AzureVMOperatingSystem `
                -Windows `
                -ComputerName $vmName `
                -Credential $vmAdminCreds `
                -ProvisionVMAgent `
                -EnableAutoUpdate |
            Set-AzureVMSourceImage `
                -PublisherName $imagePublisher `
                -Offer $imageOffer `
                -Skus $imagesku `
                -Version 'latest' |
            Set-AzureVMOSDisk `
                -Name 'osdisk' `
                -VhdUri $([String]::Concat('https://',($storageAccount.Name),'.blob.core.windows.net/vhds/',$vmname,'-osdisk.vhd')) `
                -Caching ReadWrite `
                -CreateOption fromImage |
            Add-AzureVMDataDisk `
                -Name 'datadisk' `
                -VhdUri $([String]::Concat('https://',($storageAccount.Name),'.blob.core.windows.net/vhds/',$vmname,'-datadisk.vhd')) `
                -DiskSizeInGB '30' `
                -CreateOption empty `
                -Lun 1 |
            Add-AzureVMNetworkInterface `
                -Id $nic.Id |
            Add-AzureVMSecret `
                     -SourceVaultId (Get-AzureResource -ResourceName $VaultName -ResourceType 'Microsoft.KeyVault/vaults' -ResourceGroupName $vaultResourceGroupName -OutputObjectFormat New).ResourceId `
                     -CertificateStore 'My' `
                     -CertificateUrl $secretUrlWithVersion
        
 $vm = New-AzureVM `
                    -VM $vmConfig `
                    -ResourceGroupName $ResourceGroupName `
                    -Location $location `
                    -Tags $tags `
                    -Verbose

$vm = Get-AzureVM -ResourceGroupName $ResourceGroupName -Name $vmName

      Set-AzureVMExtension `
                     -VMName $vm.Name `
                     -ResourceGroupName $vm.ResourceGroupName `
                     -Name $([String]::Concat($vmName,'-dscExtension')) `
                     -Location $location `
                     -Publisher "Microsoft.PowerShell" `
                     -ExtensionType "DSC" `
                     -Version 2.0 `
                     -SettingString $dscConfig

#endregion
