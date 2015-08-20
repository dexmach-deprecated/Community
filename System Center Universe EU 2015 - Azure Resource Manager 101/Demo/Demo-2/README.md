# Deploy using a JSON template
## this is a live build your template with Visual Studio demo.

The steps below are an outline of the demo.   
the deployment however is the same script, but prepped for deployment using http://Azuredeploy.com

<a href="" target="_blank">
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
