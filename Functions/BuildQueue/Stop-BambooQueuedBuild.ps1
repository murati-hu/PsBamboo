<#
.SYNOPSIS
    Stops and aborts a single queued or suspended build item.
.DESCRIPTION

.PARAMETER BuildKey
    Mandatory - BuildKey for the build to be stoppped
.EXAMPLE
    Stop-BambooQueuedBuild -BuildKey 'PRJ-PLANKEY-3'
#>
function Stop-BambooQueuedBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey
    )
    Invoke-BambooRestMethod -Resource "queue/$($BuildKey)" -Method Delete
}
