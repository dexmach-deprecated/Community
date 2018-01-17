<#
.DESCRIPTION
Create a module and portable module ready to be imported using WAP.

.STEPS MODULE
    STEP1
        browse to the module folder (typically C:\Windows\system32\WindowsPowerShell\v1.0\Modules\)
    STEP2
        copy the folder to a location (ex my documents)
    STEP3 (optional)
        if the module requires a connection, create an connection automation file (<modulename>-automation.json)
    STEP4 (optional)
        add the following to the modulename-automation.json file and adjust accordingly
        { 
           "ConnectionFields": [
           {
              "IsEncrypted":  false,
              "IsOptional":  false,
              "Name":  "ConnectionName",
              "TypeName":  "System.String"
           },
           {
              "IsEncrypted":  false,
              "IsOptional":  false,
              "Name":  "UserName",
           "TypeName":  "System.String"
           }],
           {
              "IsEncrypted":  true,
              "IsOptional":  false,
              "Name":  "Password",
           "TypeName":  "System.String"
           }],
           "ConnectionTypeName":  "YOURCONNECTIONDISPLAYNAME",
           "IntegrationModuleName":  "<ModuleName>"
        }
    STEP5
        zip the module folder
    STEP6
        browse the WAP admin portal and import the zipped module 
    STEP7
        Enjoy
        But don't forget to install the module (not zipped) to your runbook servers as well.
        Hint: PowerShell DSC can help keeping your runbook servers up to date and in sync! 
#>