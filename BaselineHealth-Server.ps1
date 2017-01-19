<# Baseline Health (Server)
SUMMARY
Baseline script to check key values about each machine, keeps track of changes automatically. Runs once a day
against a target list, all of which have to have a scheduled powershell job to create the baselines and place
them in a write-only network share.
#>

$TargetList = Get-Content "TargetList.txt"
$checksXML = ("CsPhysicallyInstalledMemory","OsVersion","OsBuildNumber")
$checksCSV = ("AVProductState,HDDSerialNo")

$TargetList | ForEach-Object -begin {
    [string]$date = Get-Date -UFormat %Y-%m-%d
    $changelog = New-Object PSObject
    $A = [ordered]@{Date="$date";Item="";BaseValue="";LatestValue=""}
    $changelog | Add-Member -NotePropertyMembers $A
} -process {
    $CurrentTarget = $_
    $checksXML | ForEach-Object -begin {
        if ((Test-Path "\\WOShare\$CurrentTarget.*.baseline.xml") -eq $true) {
            $baselineXML = (Import-CliXml "\\WOShare\$CurrentTarget.*.baseline.xml")
            $latestXML = (Import-CliXml \\WOShare\$CurrentTarget.$date.xml)
        } else {
            Rename-Item -Path "\\WOShare\$CurrentTarget.$date.xml" -NewName "$CurrentTarget.$date.baseline.xml"
            $baselineXML = (Import-CliXml "\\WOShare\$CurrentTarget.$date.baseline.xml")
            $latestXML = ""
        }
    } -process {
        if ($baselineXML.$_ -ne $latestXML.$_) {
            $changelog.Item = $_
            $changelog.BaseValue = $baselineXML.$_
            $changelog.LatestValue = $latestXML.$_
            $changelog | Export-Csv $CurrentTarget.changelog.csv -append
        }
    } -end {
        if ($baselineXML.CsPhysicallyInstalledMemory -ne $latestXML.CsPhysicallyInstalledMemory) {
            <# Write event to event log, triggering scheduled task to alert IT that RAM has changed #>
        }
    } #End XML block
    $checkCSV | ForEach-Object -begin {
        if ((Test-Path "\\WOShare\$CurrentTarget.*.baseline.csv") -eq $true) {
            $baselineCSV = (Import-CSV "\\WOShare\$CurrentTarget.*.baseline.csv")
            $latestCSV = (Import-CSV "\\WOShare\$CurrentTarget.$date.csv")
        } else {
            Rename-Item -Path "\\WOShare\$CurrentTarget.$date.csv" -NewName "$CurrentTarget.$date.baseline.csv"
            $baselineCSV = (Import-CSV "\\WOShare\$CurrentTarget.$date.baseline.csv")
            $latestCSV = ""
        }
    } -process {
        if ($baselineCSV.$_ -ne $latestCSV.$_) {
            $changelog.Item = $_
            $changelog.BaseValue = $baselineCSV.$_
            $changelog.LatestValue = $latestCSV.$_
            $changelog | Export-Csv $CurrentTarget.changelog.csv -append
        }
    } -end {
        if ($baselineCSV.AVProductState -ne $latestCSV.AVProductState) {
            <# Write event to event log, triggering scheduled task to alert IT that active AVs have changed #>
        }
        if ($baselineCSV.HDDSerialNo -ne $latestCSV.HDDSerialNo) {
            <# Write event to event log, triggering scheduled task to alert IT that installed disks have changed #>
        }
    } #End CSV Block
} -end {
    <## Reporting ##>
}
