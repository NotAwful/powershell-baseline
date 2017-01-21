# SUMMARY

A set of Powershell v5.1 scripts that retrieves baseline information about host machines on a network and maintains a changelog of those machines over time.  
Server script will create the baseline the first time it encounters a host's data and create a changelog with the host's initial values.


# REQUIREMENTS

Host script requires PowerShell v5.1 to use Get-ComputerInfo cmdlet.

# HOST
```
Get Configuration
Create Object
Fetch values and add to object
Export Object  
```
# SERVER
```
get configuration  
foreach-Object vs targets {  
	Begin: Create changelog object  
	Process: foreach-Object vs XML {  
		begin: does baseline exist?  
			yes: import base/latest  
			no: rename latest to baseline  
		process: compare, update changelog  
		end: generate alerts or remediation if required  
	} Close vs XML  
	End: Report that baselining checks are done  
} Close vs targets  
```

# Suggested Configuration
A write-only non-enumeation network share should available to host machines to write xml files. The Server script requires read and write access to the xml files.