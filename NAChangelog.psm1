# Requires Version 5
Set-StrictMode -Version 5

Function Register-NAChangelog(){
<# 
    .SYNOPSIS
    Registers the NAChangelog scheduled job.

    .DESCRIPTION
    Connects to remote computers and registers the NAChangelog scheduled powershell job.

#>
   [CmdletBinding()]
   Param(
    [Parameter(Mandatory= $True, HelpMessage = "Target Computer (or computers)")]
    [ValidateNotNullOrEmpty()]
    [string()]$ComputerName
   )

}

Function Unregister-NAChangelog(){
<#
    .SYNOPSIS
    Unregistered the NAChangelog scheduled job.

    .DESCRIPTION
    Connects to remote computers and unregisters the NAChangelog scheduled powershell job.
#>
    [CmdletBinding()]
}

Function New-NAChangelog(){
<#
    .SYNOPSIS
    Creates the NAChangelog script

    .DESCRIPTION
    Creates the NAChangelog script to be used by the NAChangelog scheduled job.
#>
    [CmdletBinding()]
    Param(
    $
    )
}

Function Remove-NAChangelog(){
<#
    .SYNOPSIS
    Removes NAChangelogs

    .DESCRIPTION
    Removes objects and changelogs created by the NAChangelog scheduled job. Used for removing specified objects from the records.
#>
    [CmdletBinding()]
}

