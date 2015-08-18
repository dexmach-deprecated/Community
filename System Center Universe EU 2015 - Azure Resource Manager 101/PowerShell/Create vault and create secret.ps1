import-module azure


    #credentials
$credential = Get-Credential -UserName stijn.callebaut@inovativ.be -Message 'Azure credential'

    #Authenticate
Add-AzureAccount -Credential $credential

Switch-AzureMode -Name AzureResourceManager

$vaultName = "SCU2015Vault" 
 $resourceGroup = "SCU2015Vault_RG"
 $location = "West Europe"
 $secretName = "scu2015"

 $fileName = "scu2015.pfx"
 $certPassword = "<PASSWORD>"

 $fileContentBytes = get-content $fileName -Encoding Byte
 $fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

 $jsonObject = @"
 {
 "data": "$filecontentencoded",
 "dataType" :"pfx",
 "password": "$certPassword"
 }
"@

 $jsonObjectBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonObject)
 $jsonEncoded = [System.Convert]::ToBase64String($jsonObjectBytes)

 New-AzureResourceGroup -Name $resourceGroup -Location $location

 #make sure the enabled for deployment is checked!
 New-AzureKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroup -Location $location -sku standard -EnabledForDeployment
 $secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText -Force
 Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $secret
