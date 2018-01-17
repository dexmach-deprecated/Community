Write-Ouput "Hello, this runbooks executes on our Hybrid Runbook worker $Env:COMPUTERNAME"
Write-Ouput "The following services are running"
(Get-Service).where({$_.Status -eq 'Running'})