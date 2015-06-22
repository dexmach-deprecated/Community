## Demo 2

#####Translate the [Azure Portal][1] clicks to PowerShell (using the [Azure module][2]).

Actions taken:  
1.	Open ISE  
2.	Set some settings (credential for domain join…)  
3.	Import module  
4.	Show commands in module  
5.	~~Get the publishsettings file (containing the config to connect to azure)~~ Use Add-AzureAccount and authenticate  
6.	Import the settings   
7.	Select and set the settings  
8.	Setup some pre-reqs  
	* Show the list of Windows Images  
	* Show the list of unix Images  
 	* Get the latest windows 2012 R2 release  
9.	Build  
	* Set initial config  
		* Name  
		* Size  
		*	…  
	* Domain join or not  
	* …  
	* Subnets  
	* Additional disks  
	* Extensions (script or DSC)  
10.	Create  
	* Go to portal to show progress  
11.	Once created, RDP into it  
12.	Show the extension enabled for the VM  


[1]: http://manage.windowsazure.com "Windows Azure Portal"
[2]: https://github.com/Azure/azure-powershell "Azure PowerShell module"




