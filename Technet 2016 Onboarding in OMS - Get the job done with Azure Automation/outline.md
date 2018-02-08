# Onboarding in OMS: Get the job done with Azure Automation

## outline
1. Position Azure Automation
    a. Part of OMS (OMS is Microsofts cloud and onprem managed solution)
    b. Use it to automate processes
    c. Deploy configurations to anticipate drift
    d. Targets all clouds (Azure, AWS, google,...) and on-prem
2. What makes up Azure Automation?  
    a. An Automation account (region bound + logical grouping of your Automation resources)  
    b. Assets (Modules, variables, credentials, connections, certificates, schedules)  
    c. Runbooks (powershell scripts, workflows and graphical runbooks)  
    d. Configurations and nodes (DSC)  
    e. Jobs (instances of all above)  
    f. Hybrid workers (more on that later)  
3. Automation Account (DEMO)
    a. used to isolate resources (example dev\test\prod)  
    b. region bound (but this does not mean you cannot manage resources outside this boundary. It is the region were the automation account resources live)  
    c. [DEMO] open the portal  
    d. [DEMO] select new resource > Management > Automation
    e. [DEMO] Provide a name, select the region and review the default settings
    f. [DEMO] Click create
    g. [DEMO] browse the portal dashboard and click the Automation account
    h. [DEMO] select the assets, explain each item, go back
    i. [DEMO] talk about the different runbooks
    j. [DEMO] talk about the other elements briefly (hybrid worker + DSC configurations, nodes)
4. Runbook Authoring
    a. Portal (text editor + graphical editor)
    b. PowerShell ISE (with Azure automation integration)
    e. whatever tool + PowerShell
5. start\Interact with Runbooks (DEMO)
    a. via the portal
    b. PowerShell script
    c. API
    d. Azure Alerts
    e. Schedule
    f. From another runbook
    g. [DEMO] open the automation account and start the runbook (Stop-VMS with tag)
    h. [DEMO] go over the functionality and execute
    i. [DEMO] open the Graphical XYZ and explain
    j. [DEMO] demo webhooks
6. Going Hybrid
    a. explain the hybrid worker (server + OMS agent) --> drawing
    b. [DEMO] register a hybrid worker
    c. [DEMO] execute the runbook : Get-onpremResources
    d. No inbound ports need to be opened!
7. Security  
    a. explain RBAC and roles  
    b. [DEMO] another role   
8. DSC configurations and nodes
    a. explain the purpose (briefly )
    b. Refer to the session of 4/4/2016 on DSC and OMS
9. Q&A
    

## info:
[HA] https://azure.microsoft.com/en-us/documentation/articles/automation-managing-data/
[Authoring] https://azure.microsoft.com/en-us/blog/azure-automation-graphical-and-textual-runbook-authoring/
