<#
.SYNOPSIS
    Creates a new Plan Branch for a Bamboo Plan.
.DESCRIPTION
    If -VcsBranch is not specified, it takes the -BranchName.
.PARAMETER PlanKey
    Mandatory - Key for the Bamboo Plan for the branch-plan should be created
.PARAMETER BranchName
    Mandatory - Name of the Branch-Plan
.PARAMETER VcsBranch
    Optional - Name of the Version Control System branch. By default it is the
    same as the BranchName
.EXAMPLE
    Add-BambooPlanBranch -PlanKey 'PRJ-PLANKEY'
.EXAMPLE
    Add-BambooPlanBranch -PlanKey 'PRJ-PLANKEY' -BranchName pester
.EXAMPLE
    Add-BambooPlanBranch -PlanKey 'PRJ-PLANKEY' -BranchName patch12 -VcsBranch "patch/issue12"
#>
function Add-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [Parameter(Mandatory)]
        [ValidatePattern('(\w|-)+')]
        [ValidateNotNullOrEmpty()]
        [string]$BranchName,

        [ValidatePattern('(\w|-|/)+')]
        [ValidateNotNullOrEmpty()]
        [string]$VcsBranch=$BranchName
    )

    Invoke-BambooRestMethod -Resource "plan/$PlanKey/branch/$BranchName" -Method Put -UriParams @{vcsBranch=$VcsBranch} |
    Expand-BambooResource -ResourceName 'branch' -PluralResourceName 'branches'
}
