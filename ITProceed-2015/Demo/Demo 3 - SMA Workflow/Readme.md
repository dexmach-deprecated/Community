## Demo 2

#####Move the PowerShell script into SMA[Service Management automation] (transform to workflow aka Runbook).

Actions taken:
1.	Logon to WAP
2.	**Select** the automation icon in the ribbon
3.	Use search to locate the azure runbooks (tags azure, IaaS)
4.	**Select** New-iAzureVMFromSMA
5.	Talk about parameter validation
	* Validateset limits the set of accepted values
	* Typecasting to limit errors
	* Only possible in parent runbook
6.	Some additional settings 
7.	A switch statement to take action on the flavor of the VM (web, file,…) the toUpper() functions is used as the switch statement in a workflow is casesensitive
8.	We use the automationaccount in WAAD (Windows Azure Active Directory) to connect.
9.	We get the latest windows build
10.	We get the storage account info (for our script extensions)
11.	Capitalize the instance size (it must match exactly, otherwise the value is not accepted and the command errors)
12.	Some additional provisioningparameters
13.	Now we use the DSC extension
	* Advantage to standarize on the configuration of the servers we deploy
14. Create the VM
