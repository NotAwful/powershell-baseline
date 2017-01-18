# SUMMARY

A set of Powershell v5.1 scripts that retrieves baseline information about host machines on a network and maintains a changelog of those machines over time.


# REQUIREMENTS

The host script stores information in a write-only non-enumeration network share. The server-side script requires read/write access to the same share.


# HOST
STRUCTURE
```
Declare Variables  
XML  
	Get-ComputerInfo & export to WOShare  
CSV  
	Create Object to store values  
	Add Values to Object  
Object | Export-Csv (-append) to WOShare  
```
# SERVER
STRUCTURE 
```
get targets  
foreach-Object vs targets {  
	Begin: List Checks  
		Process: foreach-Object vs XML {  
			begin: does baseline exist?  
			process: do checks, update changelog  
			end: generate alerts if required, or remediation if you're good  
		} Close vs XML  
		Process: foreach-Object vs CSV {  
			begin: does baseline exist?  
			process: do checks, update changelog  
			end: generate alerts if required, or remediation if you're good  
		} Close vs CSV  
	End: Report that baselining checks are done.  
} Close vs targets  
```
REQUIREMENTS  
Get-ComputerInfo was implemented in Powershell 5.1, so targets need that for this to even be conceptually sound.
Need a write-only network share for logs to be placed.

# TO-DO
Server: Create Event Logic, Baseline-setting (need to work out logic for automating this), 
