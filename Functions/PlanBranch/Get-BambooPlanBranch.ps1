<#
.SYNOPSIS
    Gets all plan-branches or describes a single plan-branch for a Bamboo Plan.
.DESCRIPTION
    If -BranchName is specified it describes only that plan-branch.
.PARAMETER PlanKey
    Mandatory - Key for the parent Bamboo Plan
.PARAMETER BranchName
    Optional - Name of the branch-plan to be described in details
.EXAMPLE
    Get-BambooPlanBranch -PlanKey 'PRJ-PLANKEY'
.EXAMPLE
    Get-BambooPlanBranch -PlanKey 'PRJ-PLANKEY' -BranchName 'master'
#>
function Get-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [ValidatePattern('()|(\w|-)+')]
        [string]$BranchName
    )

    $resource = "plan/$PlanKey/branch"
    if ($BranchName) {
        $resource = "plan/$PlanKey/branch/$BranchName"
    }

    Invoke-BambooRestMethod -Resource $resource -Expand 'branches.branch' |
    Expand-BambooResource -ResourceName 'branch' -PluralResourceName 'branches' |
    Add-ObjectType -TypeName 'PsBamboo.Plan'
}
