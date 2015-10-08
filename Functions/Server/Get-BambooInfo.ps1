<#
.SYNOPSIS
    Gets the current Bamboo Server information and version Detail.
.EXAMPLE
    Get-BambooInfo

    version     : 5.9.4
    edition     :
    buildDate   : 2015-08-16T00:22:28.000+12:00
    buildNumber : 5919
    state       : RUNNING
#>
function Get-BambooInfo {
    Invoke-BambooRestMethod -Resource 'info' |
    Expand-BambooResource -ResourceName 'info'
}
