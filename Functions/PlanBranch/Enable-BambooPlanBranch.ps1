function Enable-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,
        [ValidatePattern('(\w|-)+')]
        [string]$BranchName
    )

    $plan = Get-BambooPlanBranch -PlanKey $PlanKey -BranchName $BranchName
    if ($plan -and ($plan | Get-Member key)) {
        Enable-BambooPlan -PlanKey $plan.key
    } else {
        Write-Error "$PlanKey/$BranchName branch is not found."
    }
}
