# Deploy using a JSON template
## this is a live build your template with Visual Studio demo.

The steps below are an outline of the demo.   
the deployment however is the same script, but prepped for deployment using http://Azuredeploy.com

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2raw.githubusercontent.com%2FInovativ%2FCommunity%2Fmaster%2FSystem%20Center%20Universe%20EU%202015%20-%20Azure%20Resource%20Manager%20101%2FDemo%2FDemo-2%2Fdeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


Built by: [Stijn Callebaut](https://github.com/stijnc)

This template allows you to create a virtual machine with a dynamic public IP address, Virtual Network, Network Interface in the virtual network.
In addition a certificate stored in an Azufre Key Vault is deployed into the 'My'certificate store. On top of the certificate the web server role is installed using DSC.

Below are the parameters that the template expects

| Name   | Description    |
|:--- |:---|
| StorageAccountNamen  | the storage account where all the virtual disks will be stored  |
| StorageAccountType | The storageAccounttype, defaults to Standard Local storage.<br>accepted values are:   <br>* Standard_LRS <br>* Standard_GRS <br>* Standard_ZRS |
| VNetLocation | Virtual network location |
|VMName| the name of the Virtual Machine|
|VMAdminUserName| the local administrator account|
|VMAdminPassword|the password for the local administrator account|
|VMWindowsOSVersion| the windows flavors.<br>accepted values are:<br>* 2008-R2-SP1 <br>* 2012-Datacenter<br>* 2012-R2-Datacenter<br>* Windows-Server-Technical-Preview|

### demo outline
1. Open Visual studio
2. click New Project > Azure Resource Group
3. choose 'blank template'
4. click 'add resource' in the JSON view pane on the left
5. select 'Windows Virtual Machine'
    * provide a name
    * click 'new' in the storage account field and provide a name
    * Click 'new' in the virtual network field and provide a name
6. Click 'OK'
7. Click 'add resource' again to add the DSC extension
8. Select 'DSC extension'
    * Select the VM created in the previous steps
9. Click 'OK'
10. locate the 'osProfile' section of the Virtual Machine resource
11. add a 'secrets' property and use intellisense to provide the following info:
    * sourceVault > id
    * vaultCertificates > certificateUrl and certificateStore
12. Save the file
13. In the solution explorer right click the solution and select deploy
14. Create a resource group
15. Click 'Deploy'
16. provide values for the parameters
17. Click Cancel, open Github and deploy from there.
