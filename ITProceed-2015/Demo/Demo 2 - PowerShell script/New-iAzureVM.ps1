
#region init
$domain = 'Inovativ.be'
$credential = Get-Credential -UserName '<USERNAME' -Message 'azure domain creds'
$localAdmin = '<LOCALADMIN>'
#endregion

#import the azure-module
import-module Azure
#show commands
get-command -Module Azure

<#2 ways to connect to azure
        1. using the publishing file
        2. using credential object
        NOTE: when using both, Azure AD auth always wins
        you need at least version 0.8.7 if using a MS online credential
        Get-Module -Name Azure | select version 
#>

#go online and get the file
Get-AzurePublishSettingsFile
#import the file, not that the filename can differ
Import-AzurePublishSettingsFile -PublishSettingsFile "$env:USERPROFILE\Downloads\<PUBLISHSETTINGSFILE>.publishsettings"

#the account wa
Add-AzureAccount

#get the azure subscriptions
get-azuresubscription | Select-Object subscriptionname

#set the default subscription
Select-AzureSubscription -SubscriptionName Enterprise -Default

Set-AzureSubscription -SubscriptionName '<SUBSCRIPTION NAME>' -CurrentStorageAccountName '<STORAGEACCOUNTNAME'

#region pre-requisites
#All Windows Images
(Get-AzureVMImage).where( { $_.label -like '*Windows*'}) | Select-Object label -Unique
#All non Windows Images
(Get-AzureVMImage).where( { $_.label -notlike '*Windows*'}) | Select-Object label -Unique

#get the latest Windows 2012 R2 Datacenter Build                                      
$image = (Get-AzureVMImage -Verbose:$false | 
    Where-Object {$_.label -like 'Windows Server 2012 R2 Datacenter*'}| 
Sort-Object –Descending PublishedDate)[0]
#endregion

#region Build VM
    
<#Azure VM's can be configured using a varaity of cmdlets.
        During the configuration we'll use as many as possible to demonstrate the capabilities
        1. add-azurevmconfig to add the minimum set of details needed (like name and size)
        1. add-azureprovisioningConfig to set the username/password combination
        2. add-azuredatadisk to add additional disks (not limited to 1)
        3. Set-azuresubnet to add the VM to an existing or new subnet
        4. add-azurescriptextension to execute a script during startup. 
        The Script extension will be used to execute an initial script upon configuration to 
        format the data disk and install a windows feature (snmp). The add-azurescriptextension
        cmdlet is bypasses the need to wait for VM deployment and to remote into the VM to initiate
        initial configuration.
        Other useful scenario's might be:    a. SCCM client install
        b. Powershell DSC to configure the VM
        c. Copy files (ex: copy some default powershell modules)
        d. ....  
        you can use azurestorageExplorer to browse the storageAccount and show the files uploaded                                     
#>
#Let's configure the VM
#Note: the formatandinstallscript needs to be available in the storage. see the end of the script for details
$demoVMConfig = New-AzureVMConfig -Name '<VMNAME>' `
-InstanceSize ExtraSmall `
-ImageName $image.ImageName `
-DiskLabel 'OS' |
Add-AzureProvisioningConfig -WindowsDomain `
-AdminUsername $LocalAdmin `
-Password ($credential.GetNetworkCredential().Password) `
-JoinDomain $domain `
-Domain $($domain.split('.')[0]) `
-DomainPassword ($credential.GetNetworkCredential().password) `
-DomainUserName $credential.Username |
Set-AzureSubnet -SubnetNames 'Subnet-1' |
Add-AzureDataDisk -CreateNew `
-DiskSizeInGB '1' `
-DiskLabel 'DATA' `
-LUN 0 |
Set-AzureVMCustomScriptExtension -ContainerName scripts `
-FileName formatAndInstall.ps1 `
-Run formatAndInstall.ps1 -Verbose

#Create the VM
New-AzureVM -ServiceName '<SERVICENAME>' -VMs $demoVMConfig -WaitForBoot -Verbose
$VM = Get-AzureVM -ServiceName INovativ -Name <VMNAME>
$VM.ResourceExtensionStatusList.ExtensionSettingStatus

#once deployed, connect via rdp using domain credentials

#endregion

#Connect to the VM once provisioned

Get-AzureRemoteDesktopFile -Name $VM.Name -ServiceName $VM.ServiceName -localpath C:\Users\Stijn\Desktop

#region more info about VMExtensions
#list all extensions
Get-AzureVMAvailableExtension | Select-Object Extensionname, Publisher, version

#get extensions enabled for a VM
$exVM = Get-AzureVM -ServiceName <SERVICENAME> -Name <VMNAME
Get-AzureVMExtension -VM $exVM | Select-Object ExtensionName, Publisher, Version
#endregion


#Set-AzureStorageBlobContent -Container scripts -File '.\formatAndInstall.ps1' -Force

