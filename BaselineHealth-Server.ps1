<# Baseline Health Server
###
SUMMARY
Baseline script to check key values about each machine, keeps track of changes automatically. Runs once a day
against a target list, all of which have to have a scheduled powershell job to create the baselines and place
them in a write-only network share.
#>

$TargetList = Get-Content "TargetList.txt"
$TargetList | ForEach-Object -begin {
    $checksXML = ("CsPhysicallyInstalledMemory","OsVersion","OsBuildNumber")
    $checksCSV = ("AVProductState,HDDSerialNo")
    [string]$date = Get-Date -UFormat %Y-%m-%d
} -process {
    $CurrentTarget = $_
    $checksXML | ForEach-Object -begin {
        $latestXML = (Import-CliXml \\WOShare\$CurrentTarget.$date.xml)
        if ((TestPath "\\WOShare\$CurrentTarget.*.baseline.xml") -eq $true) {
            $baselineXML = Import-CliXml "\\WOShare\$CurrentTarget.*.baseline.xml"
        } else {
            #Rename the current XML to be the baseline XML, then set $baselineXML as normal
        }
    } -process {
        if ($baselineXML.$_ -ne $latestXML.$_) {
            $changeTemp = New-Object System.Object
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Item" -Value "$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Old Value" -Value "$baselineXML.$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "New Value" -Value "$latestXML.$_"
            $changeTemp | Export-Csv $CurrentTarget.changelog.csv -append
        }
    } -end {
        if ($baselineXML.CsPhysicallyInstalledMemory -ne $latestXML.CsPhysicallyInstalledMemory) {
            <# Write event to event log, triggering scheduled task to alert IT that RAM has changed #>
        }
    } #End XML block
    $checkCSV | ForEach-Object -begin {
        $lastestCSV = (Import-CSV \\WOShare\$CurrentTarget.$date.CSV)
        if ((TestPath "\\WOShare\$CurrentTarget.*.baseline.csv") -eq $true) {
            $baselineCSV = "\\WOShare\$CurrentTarget.*.baseline.csv"
        } else {
            #Rename the current CSV to be the baseline CSV, then set $baselineCSV as normal
        }
    } -process {
        if ($baselineCSV.$_ -ne $latestCSV.$_) {
            $changeTemp = New-Object System.Object
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Item" -Value "$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Old Value" -Value "$baselineCSV.$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "New Value" -Value "$latestCSV.$_"
            $changeTemp | Export-Csv $CurrentTarget.changelog.csv -append
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
