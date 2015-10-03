function Add-BambooPlanBranch {
    #curl -X PUT --user admin:admin http://localhost:8085/rest/api/latest/plan/PROJ-PLAN/branch/BranchName?vcsBranch="/refs/heads/myBranch"
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

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
