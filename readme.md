# powershell-baseline
# SUMMARY
A set of Powershell v5.1 scripts that retrieves baseline information about host machines on a network and maintains a changelog of those machines over time.
# REQUIREMENTS
The host script stores information in a write-only non-enumeration network share. The server-side script requires read/write access to the same share.
# ABOUT
Each script will have a text file associated with it that has information about the script. If it requires administrative rights, etc.
