<# Baseline Host Script
# SUMMARY #
This script runs as a scheduled job on end hosts and report baselines to a W/O Share on the network
where it will be processed by a server.
#>

<# USER SET #>
$exportPath = "C:\test"
<# DECLARE VARIABLES #>
$name = $env:COMPUTERNAME
[string]$date = (Get-Date -UFormat %Y-%m-%d)
<# XML #>
Get-ComputerInfo | Export-Clixml "$exportPath\$name.$date.xml" -NoClobber
<# Custom XML #>
$CurrentXML = New-Object PSobject
$CurrentXML | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
$AVProductState = Get-WmiObject -Class AntiVirusProduct -Namespace root\SecurityCenter2 | Select-Object -Property displayname,productState
$CurrentXML | Add-Member -MemberType NoteProperty -Name "AVProductState" -Value "$AVProductState"
$HDDSerialNo = Get-WmiObject -Class win32_physicalmedia | Select-Object -Property serialnumber
$CurrentXML | Add-Member -MemberType NoteProperty -name HDDSerialNo -Value "$HDDSerialNo"
$CurrentXML | Export-Clixml "$exportPath\$name.$date.custom.xml" -NoClobber
