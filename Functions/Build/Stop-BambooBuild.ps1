<#
.SYNOPSIS
    Stops and aborts the latest running build for the Plan.
.PARAMETER PlanKey
    Mandatory - PlanKey for the latest build to be stopped
.EXAMPLE
    Stop-BambooBuild -PlanKey 'PRJ-PLANKEY'
#>
function Stop-BambooBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )
    Invoke-BambooRestMethod -Resource "queue/$($PlanKey)" -Method Delete
}
