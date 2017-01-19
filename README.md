# SUMMARY

A set of Powershell v5.1 scripts that retrieves baseline information about host machines on a network and maintains a changelog of those machines over time.  
Server script will create the baseline the first time it encounters a host's data, and create a changelog with the host's initial values.


# REQUIREMENTS

The host script stores information in a write-only non-enumeration network share. The server-side script requires read/write access to the same share. Host script requires PowerShell v5.1 to use Get-ComputerInfo cmdlet.


# HOST
STRUCTURE
```
Declare Variables  
XML  
	Get-ComputerInfo | Export-Clixml to WOShare  
CSV  
	Create Object to store values  
	Add Values to Object  
	Object | Export-Csv (-append) to WOShare  
```
# SERVER
STRUCTURE 
```
get targets  
get checks  
foreach-Object vs targets {  
	Begin: Create changelog object  
	Process: foreach-Object vs XML {  
		begin: does baseline exist?  
			yes: import base/latest  
			no: rename latest to baseline  
		process: compare, update changelog  
		end: generate alerts if required, or remediation  
	} Close vs XML  
	Process: foreach-Object vs CSV {  
		begin: does baseline exist?  
			yes: import base/latest  
			no: rename latest to baseline  
		process: compare, update changelog  
		end: generate alerts if required, or remediation  
	} Close vs CSV  
	End: Report that baselining checks are done  
} Close vs targets  
```

# TO-DO
Server: Create Event Logic, Baseline-setting (need to work out logic for automating this), 
