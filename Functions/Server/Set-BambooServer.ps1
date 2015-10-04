<#
.SYNOPSIS
    Sets the target Bamboo Server
.DESCRIPTION
    All further cmdlets from PsBamboo will be executed against the server-enpoint
    specified by this cmdlet.
.PARAMETER Url
    Mandatory - Fully qualified HTTP endpoint for the target Bamboo Server.
.EXAMPLE
    Set-BambooServer -Url "http://localhost:8085"
#>
function Set-BambooServer {
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^(https?:\/\/)([\w\.-]+)(:\d+)*\/*')]
        [string]$Url
    )
    $script:BambooServer = $Url
}
