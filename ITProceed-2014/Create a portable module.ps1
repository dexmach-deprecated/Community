<#
.DESCRIPTION
    Create a portable module. Portable modules are like regular modules, except for one difference 
    – they don’t contain any functionality. Each portable module reflects a regular PowerShell module, 
    in that it contains the cmdlet stubs of all the cmdlets of its regular PowerShell module counterpart. 
.STEPS
    STEP1
        Logon to a server that has the SMA PowerShell module installed (available on the Orchestrator installation media)
    STEP2
        create a PowerShell remoting session to the server that has the module installed
    STEP3
        execute the New-SMAPortableModule cmdlet provinding a source and destination path
    STEP4
        import the zip file into WAP
.NOTES
    You can remote into the server that has the SMA PowerShell module installed, but be aware of the double Hop.
    As kerberos uses delegation, the SMA server is not authenticated to remote into the server that has the target module installed.
    Using CredSSP as the authentication mechanism resolved this issue (but needs to be used wisely).      
#>

#create the session
$Session = New-PSSession -ComputerName SCSM1

#create the module
New-SmaPortableModule -Session $session -ModuleName Smlets -OutputPath 'C:\Users\SCInstaller\Desktop'



<#
So, why does SMA contain these module monstrosities? 
Simply put, these modules do have their uses. Portable modules are useful when the module which they represent cannot be easily imported into SMA, 
due to how the module was packaged. For example, a module that you can only get on your local system by installing a product,  
such as the VMM PowerShell module, may depend on some DLLs which are not in the module directory and are instead somewhere else on the system,  
placed there by the installer. Of course, these DLLs would not be present on the SMA Runbook Worker that runs runbooks, and so cmdlets in this  
module would fail to run.

In theory, one could try to import the module, see what dependency it fails on, collect that DLL from somewhere on the system and put it in the 
module package, repeating this process for all dependencies until the import process succeeds. However, there could be many dependencies making  
this module package a huge pain to assemble. In addition, PowerShell modules that were installed on a system may depend on registry keys that were 
set by the installer. Clearly, these registry keys wouldn’t exist on the Runbook Worker machines, and so the module would not work even if one  
was able to package all its disparate file dependencies into a single folder. 
Worse yet, cmdlets in the module may try to access these registry keys at run time only, so while importing the module into SMA may succeed, 
actually executing a cmdlet may still fail!

Portable modules ease this pain, but they don’t fix everything. 
A portable module is generated with the SMA cmdlet New-SmaPortableModule, which takes in a regular Powershell module and spits out a self-contained 
SMA module package – something that can be easily imported into SMA. However, as explained above, this portable module package is mostly a stub  
of the regular module it was created from – if you ever try to run a cmdlet of a portable module, it just tries to run the cmdlet of the regular  
module it was created against, and if it can’t (usually because the real module isn’t on the Runbook Worker).

#>