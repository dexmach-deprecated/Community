 workflow insert-sql {
  $Query = @"
        INSERT INTO HRM
                    (USerName
                    ,Domain
                    ,FirstName
                    ,LastName
                    ,DisplayName)
            VALUES
                    ('test'
                    ,'test'
                    ,'test'
                    ,'test'
                    ,'test')
"@
$result = inlinescript {
        $props = @{
            Query = $using:query
            ServerInstance = 'ezbst0qebl.database.windows.net'
            Database = 'ITPROCEEDHR'
            UserName = 'ITProceedAdmin@ezbst0qebl'
            Password = 'Inovativ12+'
        }# SQL properties
        Invoke-Sqlcmd @props
  
<#[Reflection.Assembly]::LoadWithPartialName('System.Web')
[System.Web.Security.Membership]::GeneratePassword(12,2)#>

}
$result

}

insert-sql