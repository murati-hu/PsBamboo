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

    key          state      lifeCycleState buildStartedTime              buildCompletedDate
    ---          -----      -------------- ----------------              ------------------
    PSB-BB-23    Successful Finished       2015-10-07T00:30:09.800+13:00 2015-10-07T00:30:13.344+13:00
    TPRJ-TPLN-11 Successful Finished       2015-10-07T00:30:13.598+13:00 2015-10-07T00:30:15.426+13:00

.EXAMPLE
    Get-BambooResult -BuildKey PSB-BB-22

    key       state      lifeCycleState buildStartedTime              buildCompletedDate
    ---       -----      -------------- ----------------              ------------------
    PSB-BB-22 Successful Finished       2015-10-07T00:26:17.977+13:00 2015-10-07T00:26:20.480+13:00

.EXAMPLE
    Get-BambooResult -PlanKey PSB-BB -All

    key       state      lifeCycleState buildStartedTime              buildCompletedDate
    ---       -----      -------------- ----------------              ------------------
    PSB-BB-23 Successful Finished       2015-10-07T00:30:09.800+13:00 2015-10-07T00:30:13.344+13:00
    PSB-BB-22 Successful Finished       2015-10-07T00:26:17.977+13:00 2015-10-07T00:26:20.480+13:00
    PSB-BB-21 Successful Finished       2015-10-07T00:24:39.928+13:00 2015-10-07T00:24:41.778+13:00
#>
function Get-BambooResult {
    [CmdletBinding(DefaultParameterSetName="ListAll")]
    param(
        [Parameter(ParameterSetName="ByBuildKey")]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey,

        [Parameter(ParameterSetName="ByPlanKey")]
        [Parameter(ParameterSetName="ListExact")]
        [Parameter(ParameterSetName="ListLatest")]
        [Parameter(ParameterSetName="ListAll")]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [Parameter(ParameterSetName="ListExact")]
        [ValidatePattern('\d+|latest|all')]
        [string]$Build='latest',

        [Parameter(ParameterSetName="ListLatest")]
        [switch]$Latest,

        [Parameter(ParameterSetName="ListAll")]
        [switch]$All
    )

    $resource = 'result'

    # List results by PlanKey
    if ($PlanKey) {
        if ($All) { $Build = 'all' }
        if ($Latest) { $Build = 'latest' }

        $resource = "result/$PlanKey"
        if ($Build -and $Build -ne 'all') {
            $resource="$($resource)-$Build"
        }
    }

    # Get exact BuildKey
    if ($BuildKey) {
        $resource = "result/$BuildKey"
    }

    Invoke-BambooRestMethod -Resource $resource  -Expand 'results.result' |
    Expand-BambooResource -ResourceName 'result' |
    Add-ObjectType -TypeName 'PsBamboo.Build'
}
