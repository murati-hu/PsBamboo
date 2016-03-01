<#
.SYNOPSIS
    Returns the currenly used Bamboo Server address.
.DESCRIPTION
    This cmdlet is a simple getter function for Set-BambooServer cmdlet.
.EXAMPLE
    Get-BambooServer
#>
function Get-BambooServer {
    $script:BambooServer
}
