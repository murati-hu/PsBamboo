<#
.SYNOPSIS
    Gets build results for all or for a single Bamboo Plan.
.DESCRIPTION
    If -PlanKey is specified it filters for only those build results.
    By default it returns the latest build results.
.PARAMETER PlanKey
    Optional - Key for the Bamboo Plans to filter build results
.PARAMETER Build
    Optional - Parameter to specify the build in question, by default it
    always returns the latest build and the valid values are:
        LATEST - to return the latest build info
        ALL - to return all build results
        BUILD-Number - to return an exact build result by its id
.EXAMPLE
    Get-BambooResult
.EXAMPLE
    Get-BambooResult -PlanKey 'PRJ-PLANKEY'
.EXAMPLE
    Get-BambooResult -PlanKey 'PRJ-PLANKEY' -All
#>
function Get-BambooResult {
    [CmdletBinding()]
    param(
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [ValidatePattern('\d+|latest|all')]
        [string]$Build='latest',

        [switch]$Latest,
        [switch]$All
    )

    if ($All) { $Build = 'all' }
    if ($Latest) { $Build = 'latest' }

    $resource = 'result'
    if ($PlanKey) {
        $resource = "result/$PlanKey"
        if ($Build -and $Build -ne 'all') {
            $resource="$($resource)-$Build"
        }
    }

    Invoke-BambooRestMethod -Resource $resource  -Expand 'results.result' |
    Expand-BambooResource -ResourceName 'result'
}
