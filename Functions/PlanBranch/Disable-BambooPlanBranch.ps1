<#
.SYNOPSIS
    Disables a Bamboo plan-branch by its key.
.DESCRIPTION
    It doesn't return any object if it succeeds.
.PARAMETER PlanKey
    Mandatory - Key of the parent plan
.PARAMETER PlanKey
    Mandatory - Name of the branch under the parent plan to be disabled
.EXAMPLE
    Disable-BambooPlanBranch -PlanKey 'PRJ-PLANKEY' -BranchName 'master'
#>
function Disable-BambooPlanBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [Parameter(Mandatory)]
        [ValidatePattern('(\w|-)+')]
        [string]$BranchName
    )

    $plan = Get-BambooPlanBranch -PlanKey $PlanKey -BranchName $BranchName
    if ($plan -and ($plan | Get-Member key)) {
        Disable-BambooPlan -PlanKey $plan.key
    } else {
        Write-Error "$PlanKey/$BranchName branch is not found."
    }
}
