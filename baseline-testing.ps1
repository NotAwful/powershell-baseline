$exportPath = "C:\Test"

$name = $env:COMPUTERNAME
[string]$date = (Get-Date -UFormat %Y-%m-%d)
$CurrentXML = New-Object PSobject
$CurrentXML | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
$CurrentXML | Add-Member -MemberType NoteProperty -Name Name -Value "$name"

$OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem -Namespace Root\CIMV2 -ComputerName $env:COMPUTERNAME
$CurrentXML | Add-Member -MemberType NoteProperty -Name CSName -Value $OperatingSystem.CSName
$CurrentXML | Add-Member -MemberType NoteProperty -Name SerialNumber -Value $OperatingSystem.SerialNumber
$CurrentXML | Add-Member -MemberType NoteProperty -Name Version -Value $OperatingSystem.Version
$CurrentXML | Add-Member -MemberType NoteProperty -Name OSBuildNumber -Value $OperatingSystem.BuildNumber
$CurrentXML | Add-Member -MemberType NoteProperty -Name InstalledMemory -Value $OperatingSystem.TotalVisibleMemorySize

$BIOS = Get-WmiObject -Class Win32_BIOS
$CurrentXML | Add-Member -MemberType NoteProperty -Name BIOSVersion -Value $BIOS.Version
$CurrentXML | Add-Member -MemberType NoteProperty -Name BIOSSerialNo -Value $BIOS.SerialNumber
$CurrentXML | Add-Member -MemberType NoteProperty -Name BIOSReleaseDate -Value $BIOS.ReleaseDate

$AVProductState = Get-WmiObject -Class AntiVirusProduct -Namespace root\SecurityCenter2 | Select-Object -Property displayname,productState
$CurrentXML | Add-Member -MemberType NoteProperty -Name "AVProductState" -Value "$AVProductState"

$HDDSerialNo = Get-WmiObject -Class win32_physicalmedia | Select-Object -Property serialnumber
$CurrentXML | Add-Member -MemberType NoteProperty -name HDDSerialNo -Value "$HDDSerialNo"

$CurrentXML | Export-Clixml "$ExportPath\$name.$date.xml" -NoClobber

