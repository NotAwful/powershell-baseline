<# Object Creation Streamline Proof #>
[string]$date = Get-Date -UFormat %Y-%m-%d
$changeTemp = New-Object PSObject
$A = [ordered]@{Date="$date";Item="";OldValue="";NewValue=""}
$changeTemp | Add-Member -NotePropertyMembers $A

$changeTemp | Get-Member

$changeTemp.date