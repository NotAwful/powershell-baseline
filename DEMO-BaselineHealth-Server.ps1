<# Create Baseline and Changelog Proof of Concept #>

Get-ComputerInfo | Export-Clixml "c:\test\getcomp.xml"
$checksXML = ("WindowsCurrentVersion","WindowsEditionID")
[string]$date = (Get-Date -UFormat %Y-%m-%d)
$changelog = New-Object PSObject
$A = [ordered]@{Date="$date";Item="";BaseValue="";LatestValue=""}
$changelog | Add-Member -NotePropertyMembers $A

$checksXML | ForEach-Object -begin {
    if ((Test-Path "c:\test\getcomp.baseline.xml") -eq $true) {
        write "TRUE"
        $baselineXML = Import-CliXml "c:\test\getcomp.baseline.xml"
        $latestXML = (Import-CliXml "c:\test\getcomp.xml")
    } else {
        write "ELSE"
        Rename-Item -Path "C:\test\getcomp.xml" -NewName "getcomp.baseline.xml"
        $baselineXML = Import-CliXml "C:\test\getcomp.baseline.xml"
        $latestXML = ""
    }
} -process {
    if ($baselineXML.$_ -ne $latestXML.$_) {
        $changelog.Item = $_
        $changelog.BaseValue = $baselineXML.$_
        $changelog.LatestValue = $latestXML.$_
        $changelog | Export-Csv "c:\test\changelog.csv" -append
        write "$_ NOT EQUAL"
        }
    <# This if statement is for testing
    if ($baselineXML.$_ -eq $latestXML.$_) {
        $changelog.Item = $_
        $changelog.OldValue = $baselineXML.$_
        $changelog.NewValue = $latestXML.$_
        $changelog | Export-Csv "c:\test\changelog.csv" -append
        write "$_ EQUAL"
    } #>
}