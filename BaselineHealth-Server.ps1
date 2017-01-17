<# Baseline Health Server
###
SUMMARY
Baseline script to check key values about each machine, keeps track of changes automatically. Runs once a day
against a target list, all of which have to have a scheduled powershell job to create the baselines and place
them in a write-only network share.
#>

$TargetList = Get-Content "TargetList.txt"
$TargetList | ForEach-Object -begin {
    <# This runs before checking any of the targets, so use it to do variables to be used throughout the whole thing #>
    $checksXML = ("CsPhysicallyInstalledMemory","OsVersion","OsBuildNumber","OsHotfixes")
    $checksCSV = ("AVProductState") # CSV Values to aquire: AVProductState
    $date = Get-Date -UFormat %Y-%m-%d
} -process {
    $CurrentTarget = $_
    $checksXML | ForEach-Object -begin {
        #Start XML "Begin" Block
        $latestXML = (Import-CliXml \\WOShare\$CurrentTarget.$date.xml)
        if ((TestPath "\\WOShare\$CurrentTarget.*.baseline.xml") -eq $true) {
            $baselineXML = Import-CliXml "\\WOShare\$CurrentTarget.*.baseline.xml"
        } else {
            #Rename the current XML to be the baseline XML, then set $baselineXML as normal
        }
    } -process {
        #Start XML "Process" Block
        if ($baselineXML.$_ -ne $latestXML.$_) {
            $changeTemp = New-Object System.Object
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Item" -Value "$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Old Value" -Value "$baselineXML.$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "New Value" -Value "$latestXML.$_"
            $changeTemp | Export-Csv $CurrentTarget.changelog.csv -append
        } #End if statement
    } -end {
        #Start XML "End" Block
        if ($baselineXML.CsPhysicallyInstalledMemory -ne $latestXML.CsPhysicallyInstalledMemory) {
            <# If baseline's installed memory is not equal to the latest installed memory then write an event to the...
                Event Log, triggering a Scheduled Task to send an email to IT that $CurrentTarget's installed RAM has changed.
            #>
        } #End If statement
    } #End XML "End" block
    $checkCSV | ForEach-Object -begin {
        # Start CSV "Begin" Block
        $lastestCSV = (Import-CSV \\WOShare\$CurrentTarget.$date.CSV)
        if ((TestPath "\\WOShare\$CurrentTarget.*.baseline.csv") -eq $true) {
            $baselineCSV = "\\WOShare\$CurrentTarget.*.baseline.csv"
        } else {
            #Rename the current CSV to be the baseline CSV, then set $baselineCSV as normal
        }
    } -process {
        # Start CSV "Process" Block
        if ($baselineCSV.$_ -ne $latestCSV.$_) {
            $changeTemp = New-Object System.Object
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Date" -Value "$date"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Item" -Value "$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "Old Value" -Value "$baselineCSV.$_"
            $changeTemp | Add-Member -MemberType NoteProperty -Name "New Value" -Value "$latestCSV.$_"
            $changeTemp | Export-Csv $CurrentTarget.changelog.csv -append
        } #End if statement
    } -end {
        #Start CSV "End" Block
        # Alerts/Remediation for XML
    } #End CSV "End" Block
} -end {
    <## Reporting ##>
}