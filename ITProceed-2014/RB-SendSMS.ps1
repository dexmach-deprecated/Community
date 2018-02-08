
Workflow SendSMS {

  param(
    
    [Parameter(mandatory=$true)]
    [Alias('Message')]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({$_.lenght -lt 100})]
    [string]$Text,

    [Parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('^((\+|00)32\s?|0)4(60|[789]\d)(\s?\d{2}){3}$')]
    [string[]]$Phonenumber
  )

    #get some variables
    $connection = get-automationConnection -Name 'BizzSMSConnection'
    $props = @{
      $username = $connection.username
      $apikey = $connection.apikey
    }

    $Numbers = $Phonenumber -join ','

    Send-SMS -phonenumber $Numbers -text $Text @props
}


SendSMS


