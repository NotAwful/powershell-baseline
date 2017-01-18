<# NESTING FOREACH-OBJECT LOOPS
THEORY: $_ gets initialized at the start of every process block #>

$testOutter = (1..3)
$testOutter | ForEach-Object -Begin {
    Write "Enter Outer Begin Block"
    $TestInner = (1..3)
} -Process {
    Write "Enter Outer Process Block"
    $CurrentTarget = $_
    $TestInner | ForEach-Object -Begin {
        Write "Begin Inner Begin Block"
    } -Process {
        Write "Begin Inner Process Block"
        Write "Outer $CurrentTarget Inner $_"
    } -End {
        Write "Begin Inner End Block"
    }
} -End {
    Write "Enter Outer End Block"
}