function Get-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter()]
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
    Expand-BambooResource -ResourceName 'branch' -PluralResourceName 'branches'
}
