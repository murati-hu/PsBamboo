<#
.SYNOPSIS
    Triggers a build for the specified Plan.
.PARAMETER PlanKey
    Mandatory - PlanKey for the latest build to be started
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
    Invoke-BambooRestMethod -Resource "queue/$($PlanKey)" -Method Post
}
