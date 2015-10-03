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
    Expand-BambooResource -ResourceName 'plan' #|
    #Add-Member -MemberType AliasProperty PlanKey key -PassThru |
    #Add-Member -MemberType AliasProperty PlanName name -PassThru
}
