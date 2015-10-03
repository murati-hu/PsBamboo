<#
function Remove-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [ValidatePattern('(\w|-)+')]
        [ValidateNotNullOrEmpty()]
        [string]$BranchName
    )

    Invoke-BambooRestMethod -Resource "plan/$PlanKey/branch/$BranchName" -Method Delete |
    Expand-BambooResource -ResourceName 'branch' -PluralResourceName 'branches'
}
#>
