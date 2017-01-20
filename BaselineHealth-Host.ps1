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

<# SCRIPT BELOW #>
$CurrentXML = New-Object PSobject
$CurrentXML | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
$CurrentXML | Add-Member -MemberType NoteProperty -Name Name -Value "$name"
$computerInfo = Get-ComputerInfo
$CurrentXML | Add-Member -MemberType NoteProperty -Name OsVersion -Value $computerInfo.OsVersion
$CurrentXML | Add-Member -MemberType NoteProperty -Name OsBuildNumber -Value $computerInfo.OsBuildNumber
$CurrentXML | Add-Member -MemberType NoteProperty -Name InstalledMemory -Value $computerInfo.CsPhysicallyInstalledMemory
$AVProductState = Get-WmiObject -Class AntiVirusProduct -Namespace root\SecurityCenter2 | Select-Object -Property displayname,productState
$CurrentXML | Add-Member -MemberType NoteProperty -Name "AVProductState" -Value "$AVProductState"
$HDDSerialNo = Get-WmiObject -Class win32_physicalmedia | Select-Object -Property serialnumber
$CurrentXML | Add-Member -MemberType NoteProperty -name HDDSerialNo -Value "$HDDSerialNo"
$CurrentXML | Export-Clixml "$exportPath\$name.$date.xml" -NoClobber
