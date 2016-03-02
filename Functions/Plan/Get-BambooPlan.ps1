<#
.SYNOPSIS
    Gets all plans or describes a single Bamboo Plan.
.DESCRIPTION
    If -PlanKey is specified it describes only that plan.
.PARAMETER PlanKey
    Optional - Key for the Bamboo Plan to be described in details
.EXAMPLE
    Get-BambooPlan
.EXAMPLE
    Get-BambooPlan -PlanKey 'PRJ-PLANKEY'
#>
function Get-BambooPlan {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    $resource = 'plan'
    if ($PlanKey) {
        $resource = "plan/$PlanKey"
    }

    Invoke-BambooRestMethod -Resource $resource  -Expand 'plans.plan.branches' |
    Expand-BambooResource -ResourceName 'plan' |
    Add_ObjectType -TypeName 'PsBamboo.Plan'
}
