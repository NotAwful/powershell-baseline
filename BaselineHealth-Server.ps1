<# Baseline Health (Server)
SUMMARY
Baseline script to check key values about each machine, keeps track of changes automatically. Runs once a day
against a target list, all of which have to have a scheduled powershell job to create the baselines and place
them in a write-only network share.
#>

<# USER SET #>
$TargetList = Get-Content "TargetList.txt"
$importPath = "C:\test"
$logPath = "C:\test\logs"
$checksXML = ("CsPhysicallyInstalledMemory","OsVersion","OsBuildNumber")
$checksCustom = ("AVProductState,HDDSerialNo")

$TargetList | ForEach-Object -begin {
    [string]$date = Get-Date -UFormat %Y-%m-%d
    $changelog = New-Object PSObject
    $A = [ordered]@{Date="$date";Item="";BaseValue="";LatestValue=""}
    $changelog | Add-Member -NotePropertyMembers $A
} -process {
    $CurrentTarget = $_
    $checksXML | ForEach-Object -begin {
        if ((Test-Path "\\WOShare\$CurrentTarget.*.baseline.xml") -eq $true) {
            $baselineXML = (Import-CliXml "$importPath\$CurrentTarget.*.baseline.xml")
            $latestXML = (Import-CliXml $importPath\$CurrentTarget.$date.xml)
        } else {
            Rename-Item -Path "$importPath\$CurrentTarget.$date.xml" -NewName "$CurrentTarget.$date.baseline.xml"
            $baselineXML = (Import-CliXml "$importPath\$CurrentTarget.$date.baseline.xml")
            $latestXML = ""
        }
    } -process {
        if ($baselineXML.$_ -ne $latestXML.$_) {
            $changelog.Item = $_
            $changelog.BaseValue = $baselineXML.$_
            $changelog.LatestValue = $latestXML.$_
            $changelog | Export-Csv "$logPath\$CurrentTarget.changelog.csv" -append
        }
    } -end {
        if ($baselineXML.CsPhysicallyInstalledMemory -ne $latestXML.CsPhysicallyInstalledMemory) {
            <# Write event to event log, triggering scheduled task to alert IT that RAM has changed #>
        }
    } #End XML block
    $checkCustom | ForEach-Object -begin {
        if ((Test-Path "$importPath\$CurrentTarget.*.custom.baseline.xml") -eq $true) {
            $baselineCustom = (Import-CliXml "$importPath\$CurrentTarget.*.custom.baseline.xml")
            $latestCustom = (Import-CliXml "$importPath\$CurrentTarget.$date.custom.xml")
        } else {
            Rename-Item -Path "$importPath\$CurrentTarget.$date.custom.xml" -NewName "$CurrentTarget.$date.custom.baseline.xml"
            $baselineCustom = (Import-CSV "$importPath\$CurrentTarget.$date.custom.baseline.xml")
            $latestCustom = ""
        }
    } -process {
        if ($baselineCustom.$_ -ne $latestCustom.$_) {
            $changelog.Item = $_
            $changelog.BaseValue = $baselineCustom.$_
            $changelog.LatestValue = $latestCustom.$_
            $changelog | Export-Csv "$logPath\$CurrentTarget.changelog.csv" -append
        }
    } -end {
        if ($baselineCustom.AVProductState -ne $latestCustom.AVProductState) {
            <# Write event to event log, triggering scheduled task to alert IT that active AVs have changed #>
        }
        if ($baselineCustom.HDDSerialNo -ne $latestCustom.HDDSerialNo) {
            <# Write event to event log, triggering scheduled task to alert IT that installed disks have changed #>
        }
    } #End Custom Block
} -end {
    <## Reporting ##>
}
