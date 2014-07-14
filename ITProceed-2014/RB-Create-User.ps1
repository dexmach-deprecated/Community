<#
.DESCRIPTION
Simple Runbook that Creates a user and moves it to a specified OU.
The Runbook uses SMA Assets to provide a certain flexibility.
#>

Workflow Create-User 
{
    param(
        [String]$username,
        [String]$LastName,
        [String]$FirstName,
        [String]$manager
    )


    #set some variables
    $OU = get-automationvariable -Name 'ADUserOU'
    $ADCredential = get-automationcredential -Name 'ADCredential'

    $SQLConnection = Get-AutomationConnection -Name 'ITProceedHR'

    Write-Verbose "Getting manager $manager data"

    $manager = Get-ADUser -Identity $manager -Credential $ADCredential

    $props = @{
        UserPrincipalName = $username
        Name = $FirstName
        SurName = $LastName
        DisplayName = "$FirstName $LastName"
        Path = $OU
    }# new AD user properties

    
    if($manager){
     $props =  inlinescript {
          $props = $using:props
          $props.Add('Manager',$manager)
          $props
      }# add manager property
      
    }#manager exist


    Write-verbose "Creating user $Username"

    $user = New-ADUser @props -PassThru $true -Credential $ADCredential

    Write-Output "Created user $user.UserPrincipalName"

    #Checkpoint
    Checkpoint-Workflow

    #create user in HR db
    inlinescript {
        $Query = @"
        INSERT INTO HRM
                    (USerName
                    ,Domain
                    ,FirstName
                    ,LastName
                    ,DisplayName)
            VALUES
                    ('$($user.SamAccountName)'
                    ,'$($user.UserPrincipalName.split('@')[1])
                    ,'$($user.GivenName)'
                    ,'$($user.Surname)'
                    ,'$($user.Name)')
"@

        $props = @{
            Query = $query
            ServerInstance = $using:SQLConnection.Server
            Database = $using:SQLConnection.Database
            UserName = $using:SQLCredential.UserName
            Password = ($using:SQLCredential).GetNetworkPassword().Password
        }# SQL properties
        Invoke-Sqlcmd @props

    }# inlinescript SQL

}#workflow Create user