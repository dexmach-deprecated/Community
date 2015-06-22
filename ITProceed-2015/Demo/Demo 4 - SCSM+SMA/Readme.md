## Demo 4

#####Integrate business processes using a combination of Service Manager and SMA.

The automation part is similar to the automation used in the SMA scenario.  
The main difference is that a structure of parent-child runbooks is used for SCSM interaction
* New-SCSMAzureVM
* New-IAzureVM (same as New-iAzureVMFromSMA without parameter validation)
* Add-SRComment to add comments in SR
 
Note that after the new-iazureVM the workflow is checkpointed.
This saves its state until completion.   
If failed, it can be resumed from that point on
 
Actions taken:
1.	Open the portal via [Inovativ Service Manager portal][1]
	* Browse the Cloud Management Category and select Public Cloud service offering
	* Select the New Azure Server offering
	* Click Go to request form
	* Fill in the form
		* Computername (ITPROCEEDDEMO0001)
		* Instance size (leave the default medium or more) to speed up the deployment
		* Choose a flavor (this translates to a PowerShell DSC configuration)
		* Click **Next**
	* Click **Submit** on the summary
	* Note the SR number
2.	Open the Console
	* Click the Work Item wunderbar
	* Select All open service requests
	* Open the SR 
	* Click the **Activities tab**
	* Explain process (ie review activity)
3.	Line manager approves
4.	For demo purposes --> auto approve
	* Open the RB activity
1.	Browse the log entries
	* Invoke = ok
	* Params = ok
		* Keep the SR open
3.	Open the [WAP management portal][2]
	* Click the **automation tab**
	* Click **runbooks** in the upper navigation menu
	* Search for the New-SCSMAzureVM runbook
 	* Select the job
4.	Open the [Azure portal][3] 
	* Select the **Virtual Machine** Tab
	* See the VM being created
5.	Click the Configuration Items tab
	* Click PowerShell > DSC in the tree structure
	* Talk about the configuration you see
		* Fileserver = DFS + file servr feature
		* Web = webserver + default site stopped
		* Base = UAC disabled, timezone,…
	* Talk about interlinking File server inherits the Base config,…
	* Show SCSMMGMT config
		* Click related items
		* Note the related computers using that config
6.	Back to the SR
	* Select the **SR** form and hit refresh + confirm
	* Click the general tab
	* Note the progress being logged in the comments
7.	Enter the computername in the search box (upper right hand corner) and select windows computer from the drop down
8.	Select the computer object from the popup window
	* Scroll down, note the custodian
	* Click **related items** tab
]	* Note the DSC resource being linked
9.	Open the [Azure portal][3]
10.	Click the virtual machines tab
11.	Select the computer created
12.	Click connect in the bottom navigation bar
13.	Logon with vnextdemo domain creds
14.	Click yes to confirm on the security prompt
15.	Enter remote desktop
	* Note server manager does not open automatically
	* Open server manager
	* Click on **local server** in the navigation menu
1.	Note the timezone
2.	File and storage item onm the left
3.	If needed click on manage in upper right corner
	* Select **add roles and features**
	* Click **Next** until you enter the server roles tab
	* Show the roles installed

[1]: http://inovativ-scsm.cloudapp.net "Inovativ Service Manager portal"
[2]: http://wap.inovativ.be "Inovativ WAP Portal"
[3]: http://manage.windowsazure.com ""Windows Azure Portal"
