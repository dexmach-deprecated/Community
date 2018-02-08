#install SNMP Service
Write-output 'installing windowsfeature'
Install-WindowsFeature -Name SNMP-Service

#format the disk
write-output 'Formatting disk'
$disk = Get-Disk | Where-Object partitionstyle -eq 'raw'
Initialize-Disk -Number ($disk).Number -PartitionStyle MBR
$partition = New-Partition -DiskNumber ($disk).Number -UseMaximumSize -DriveLetter F 
Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel 'DATA' -Confirm:$false