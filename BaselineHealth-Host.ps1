<# Baseline Host Script
# SUMMARY #
This script runs as a scheduled job on end hosts and report baselines to a W/O Share on the network
where it will be processed by a server.
#>

<# DECLARE VARIABLES #>
$name = $env:COMPUTERNAME
[string]$date = (Get-Date -UFormat %Y-%m-%d)
<# XML #>
Get-ComputerInfo | Export-Clixml "\\WOShare\$name.$date.xml" -NoClobber
<# CSV #>
# Create Object & Date it
$CurrentCSV = New-Object System.Object
$CurrentCSV | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
# AV Health
[string]$AVProductState = Get-WmiObject -Class AntiVirusProduct -Namespace root\SecurityCenter2 | select displayname,productState
$CurrentCSV | Add-Member -MemberType NoteProperty -Name "AVProductState" -Value "$AVProductState"
# Hard Disk Serial Numbers
[string]$HDDSerialNo = Get-WmiObject -Class win32_physicalmedia | select serialnumber
$CurrentCSV | Add-Member -MemberType NoteProperty -Name "HDDSerialNo" -Value "$HDDSerialNo"
# Export; Creates the file if it doesn't exist, appends if it runs twice on one day somehow
$CurrentCSV | Export-Csv "\\WOShare\$name.$date.csv"
